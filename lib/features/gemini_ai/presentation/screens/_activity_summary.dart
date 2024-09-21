import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';
import 'package:store_redirect/store_redirect.dart';

/// The `ActivitySummary` widget displays a summary of user activities
/// including notifications and updates, and handles the analysis of
/// these activities using an AI service.
class ActivitySummary extends StatefulWidget {
  final UpdateApp updateApp;
  final bool showUpdate;
  final bool showAffiliateNote;

  const ActivitySummary({
    required this.updateApp,
    required this.showUpdate,
    required this.showAffiliateNote,
    super.key,
  });

  @override
  State<ActivitySummary> createState() => _ActivitySummaryState();
}

class _ActivitySummaryState extends State<ActivitySummary> {
  final _googleGenerativeAIService = GoogleGenerativeAIService();
  List<Activity> _activities = [];
  List<String> _analysisResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupActivities();
  }

  /// Prepares activities for analysis by formatting them into a string.
  /// Each activity's details are structured for the AI to analyze.
  String prepareActivitiesForAnalysis(List<Activity> activities) {
    return activities.map((activity) {
      return activity.type == NotificationActivityType.eventUpdate ||
              activity.type == NotificationActivityType.newEventInNearYou ||
              activity.type == NotificationActivityType.inviteRecieved
          ? '''
The type of notification: ${activity.type}
The name of the user sending the notification: ${activity.authorName}, for notifications where type is eventUpdate, the userName wouldn't be here but rather the title
The primary message of the notification: ${activity.comment}
The date I received the notification: ${MyDateFormat.toDate(activity.timestamp!.toDate())}
'''
          : '''
The type of notification: ${activity.type}
The name of the user sending the notification: ${activity.authorName} 
The type of user sending the notification: ${activity.authorProfileHandle}
Is the notification from a verified user?: ${activity.authorVerification} 
The primary message of the notification: ${activity.comment}
The date I received the notification: ${MyDateFormat.toDate(activity.timestamp!.toDate())}
''';
    }).join('\n\n');
  }

  /// Sets up activities by fetching them from the database.
  /// It filters activities from the last 7 days and analyzes them.
  Future<void> _setupActivities() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    try {
      DateTime now = DateTime.now();
      DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

      List<Activity> allActivities = [];
      DocumentSnapshot? lastDocument;

      while (true) {
        // Query for activities from the last 14 days
        Query query = activitiesRef
            .doc(_provider.currentUserId)
            .collection('userActivities')
            .where('timestamp', isGreaterThanOrEqualTo: sevenDaysAgo)
            .orderBy('timestamp', descending: true)
            .limit(10);

        if (lastDocument != null) {
          query = query.startAfterDocument(lastDocument);
        }

        QuerySnapshot snapshot = await query.get();

        if (snapshot.docs.isEmpty) break;

        List<Activity> batchActivities =
            snapshot.docs.map((doc) => Activity.fromDoc(doc)).toList();
        allActivities.addAll(batchActivities);
        lastDocument = snapshot.docs.last;
      }

      if (allActivities.isEmpty) {
        if (mounted) {
          setState(() {
            _activities = [];
            _isLoading = false;
          });
        }
        return; // Exit if no activities
      }

      // Batch prepare and analyze
      List<String> analysisResults =
          await batchAnalyzeActivitiesWithGemini(allActivities);

      if (mounted) {
        setState(() {
          _analysisResults = analysisResults;
          _activities = allActivities;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // mySnackBar(context, 'An error occured');
    }
  }

  /// Analyzes activities in batches using the Gemini AI service.
  Future<List<String>> batchAnalyzeActivitiesWithGemini(
      List<Activity> activities) async {
    int batchSize = 10;
    List<String> analysisResults = [];

    for (int i = 0; i < activities.length; i += batchSize) {
      List<Activity> batch = activities.skip(i).take(batchSize).toList();
      String preparedData = prepareActivitiesForAnalysis(batch);
      String analysis = await analyzeActivitiesWithGemini(preparedData);
      analysisResults.add(analysis);
    }

    return analysisResults;
  }

  /// Sends prepared activity data to the AI service for analysis.
  Future<String> analyzeActivitiesWithGemini(String preparedData) async {
    final prompt = '''
Analyze the following activities and provide a summary of the notifications received:
$preparedData
''';
    final response = await _googleGenerativeAIService.generateResponse(prompt);
    return response!;
  }

  /// Builds a row widget for displaying a summary with an icon.
  _summaryRow(IconData icon, String summary, bool isTotal) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.responsiveHeight(context, 20),
          color: isTotal ? Colors.white : Colors.red,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            summary,
            style: TextStyle(
              color: isTotal
                  ? Colors.white
                  : Theme.of(context).secondaryHeaderColor,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
            ),
          ),
        ),
      ],
    );
  }

  /// Displays a bottom sheet with the list of activities.
  void _showActivities() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        var _provider = Provider.of<UserData>(context, listen: false);

        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 600),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TicketPurchasingIcon(
                title: '',
              ),
              Container(
                height: ResponsiveHelper.responsiveHeight(context, 530),
                child: ListView.builder(
                  itemCount: _activities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final activity = _activities[index];
                    return ActivityWidget(
                      activity: activity,
                      currentUserId: _provider.currentUserId!,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds a widget to display the notification count.
  _notificationCount() {
    return GestureDetector(
      onTap: () => _showActivities(),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        child: _summaryRow(
          Icons.notifications_active_outlined,
          "${NumberFormat.compact().format(_activities.length)} Notification from last week",
          true,
        ),
      ),
    );
  }

// Builds the main body of the screen
  Widget _buildBody(
      BuildContext context, UserData provider, String analysisText) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: ResponsiveHelper.responsiveHeight(context, 600.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: _isLoading
          ? _buildLoadingIndicator(context)
          : _activities.isEmpty
              ? _buildNoActivitiesMessage()
              : _buildActivityList(context, provider, analysisText),
    );
  }

// Displays a loading indicator
  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: Loading(
        shakeReapeat: false,
        color: Theme.of(context).secondaryHeaderColor,
        title: 'processing...',
        icon: FontAwesomeIcons.circle,
      ),
    );
  }

// Displays a message when no activities are available
  Widget _buildNoActivitiesMessage() {
    return Center(
      child: NoContents(
        isFLorence: true,
        title: "",
        subTitle:
            "Hey, You have not received any notification to analyze over the past 7 days",
        icon: null,
      ),
    );
  }

// Builds the list of activities
  Widget _buildActivityList(
      BuildContext context, UserData provider, String analysisText) {
    var _sizedBox = const SizedBox(height: 20);

    return Material(
      color: Colors.transparent,
      child: ListView(
        children: [
          const SizedBox(height: 30),
          _buildAnimatedCircle(),
          const SizedBox(height: 50),
          _buildGreetingText(context, provider),
          _sizedBox,
          _buildUpdateInfo(),
          const SizedBox(height: 2),
          _buildAffiliateNote(),
          _sizedBox,
          _notificationCount(),
          ActivitySummaryWidget(activities: _activities),
          _sizedBox,
          _buildAnalysisText(context, analysisText),
        ],
      ),
    );
  }

// Builds the animated circle widget
  Widget _buildAnimatedCircle() {
    return Center(
      child: ShakeTransition(
        axis: Axis.vertical,
        duration: Duration(seconds: 2),
        child: AnimatedCircle(
          size: 30,
          stroke: 2,
          animateSize: true,
          animateShape: true,
        ),
      ),
    );
  }

// Displays a greeting text with the user's name
  Widget _buildGreetingText(BuildContext context, UserData provider) {
    return Text(
      'Hi ${provider.user!.userName!}. This is a summary of your notifications in the past 7 days',
      style: TextStyle(
        color: Theme.of(context).secondaryHeaderColor,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      ),
    );
  }

// Builds the update info widget
  Widget _buildUpdateInfo() {
    return UpdateInfoMini(
      updateNote: widget.updateApp.updateNote!,
      showinfo: widget.showUpdate,
      displayMiniUpdate: widget.updateApp.displayMiniUpdate!,
      onPressed: () {
        StoreRedirect.redirect(
          androidAppId: "com.barsOpus.barsImpression",
          iOSAppId: "1610868894",
        );
      },
    );
  }

// Builds the affiliate note widget
  Widget _buildAffiliateNote() {
    return MiniAffiliateNote(
      updateNote: 'Congratulations, you have one or more affiliate deals.',
      showinfo: widget.showAffiliateNote,
      displayMiniUpdate: widget.updateApp.displayMiniUpdate!,
    );
  }

// Displays the analysis text using Markdown
  Widget _buildAnalysisText(BuildContext context, String analysisText) {
    return MarkdownBody(
      data: analysisText,
      styleSheet: MarkdownStyleSheet(
        h1: Theme.of(context).textTheme.titleLarge,
        h2: Theme.of(context).textTheme.titleMedium,
        p: Theme.of(context).textTheme.bodyMedium,
        listBullet: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserData>(context);
    String analysisText = _analysisResults.join('\n\n');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _buildBody(context, provider, analysisText),
    );
  }
}
