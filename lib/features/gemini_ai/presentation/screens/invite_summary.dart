/// The `InviteSummary` widget displays a summary of event invitations
/// received by the user. It fetches and analyzes invitation data,
/// providing insights using an AI service. The widget supports viewing
/// detailed invitation information and highlights the total number of events.

import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class InviteSummary extends StatefulWidget {
  @override
  State<InviteSummary> createState() => _InviteSummaryState();
}

class _InviteSummaryState extends State<InviteSummary> {
  final _googleGenerativeAIService = GoogleGenerativeAIService();
  List<InviteModel> _invites = [];
  List<String> _analysisResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupActivities();
  }

  /// Prepares invitation data for analysis by formatting each invitation
  /// into a string that can be processed by  Gemini AI.
  String prepareActivitiesForAnalysis(List<InviteModel> invites) {
    return invites.map((invite) {
      return '''
Event title: ${invite.eventTitle}
Invitation message: ${invite.generatedMessage}
Invitation message: ${invite.inviterMessage}
Do I get a free ticket upon accepting invitation: ${invite.isTicketPass}
The answer I have given to the invitation: ${invite.answer}
The date the event I have been invited to will happen: ${MyDateFormat.toDate(invite.eventTimestamp!.toDate())}
The date I received invite: ${MyDateFormat.toDate(invite.timestamp!.toDate())}
''';
    }).join('\n\n');
  }

  /// Sets up the invitation data by fetching it from firebase.
  /// It processes each invite and sends it for analysis.
  Future<void> _setupActivities() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    try {
      List<InviteModel> allInviteModels = [];
      DocumentSnapshot? lastDocument;

      // Fetch invitations from the database in batches
      while (true) {
        Query query = userInvitesRef
            .doc(_provider.currentUserId)
            .collection('eventInvite')
            .orderBy('timestamp', descending: true)
            .limit(10);

        if (lastDocument != null) {
          query = query.startAfterDocument(lastDocument);
        }

        QuerySnapshot snapshot = await query.get();

        if (snapshot.docs.isEmpty) break;

        List<InviteModel> batchInviteModels =
            snapshot.docs.map((doc) => InviteModel.fromDoc(doc)).toList();
        allInviteModels.addAll(batchInviteModels);
        lastDocument = snapshot.docs.last;
      }

      if (allInviteModels.isEmpty) {
        if (mounted) {
          setState(() {
            _invites = [];
            _isLoading = false;
          });
        }
        return; // Exit if no invitations
      }

      // Analyze the invitations in batches
      List<String> analysisResults =
          await batchAnalyzeActivitiesWithGemini(allInviteModels);

      if (mounted) {
        setState(() {
          _analysisResults = analysisResults;
          _invites = allInviteModels;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      mySnackBar(context, 'An error occured');
    }
  }

  /// Analyzes invitation data in batches using the AI service.
  Future<List<String>> batchAnalyzeActivitiesWithGemini(
      List<InviteModel> activities) async {
    int batchSize = 10;
    List<String> analysisResults = [];

    for (int i = 0; i < activities.length; i += batchSize) {
      List<InviteModel> batch = activities.skip(i).take(batchSize).toList();
      String preparedData = prepareActivitiesForAnalysis(batch);
      String analysis = await analyzeActivitiesWithGemini(preparedData);
      analysisResults.add(analysis);
    }

    return analysisResults;
  }

  /// Sends prepared invitation data to the AI service for analysis.
  Future<String> analyzeActivitiesWithGemini(String preparedData) async {
    final prompt = '''
Analyze the following invitations and provide a summary of the invites I have received:
$preparedData
''';

    final response = await _googleGenerativeAIService.generateResponse(prompt);
    return response!;
  }

  /// Builds a row widget for displaying a summary with an icon.
  Widget _summaryRow(IconData icon, String summary, bool isTotal) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.responsiveHeight(context, 20),
          color: isTotal ? Colors.white : Colors.red,
        ),
        const SizedBox(width: 10),
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

  /// Displays a bottom sheet with the list of invitations.
  void _showActivities() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: ResponsiveHelper.responsiveHeight(context, 600),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TicketPurchasingIcon(title: ''),
                  Container(
                    height: ResponsiveHelper.responsiveHeight(context, 530),
                    child: ListView.builder(
                      itemCount: _invites.length,
                      itemBuilder: (BuildContext context, int index) {
                        final _invite = _invites[index];
                        return InviteContainerWidget(invite: _invite);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Builds a widget to display the notification count with an icon.
  Widget _notificationCount() {
    return GestureDetector(
      onTap: () => _showActivities(),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: _summaryRow(
          Icons.event_available_outlined,
          "${NumberFormat.compact().format(_invites.length)} events in total",
          true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context);
    String analysisText = _analysisResults.join('\n\n');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(20),
        height: ResponsiveHelper.responsiveHeight(context, 600.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: _isLoading
            ? Center(
                child: Loading(
                  shakeReapeat: false,
                  color: Theme.of(context).secondaryHeaderColor,
                  title: 'processing...',
                  icon: (FontAwesomeIcons.circle),
                ),
              )
            : _invites.isEmpty
                ? Center(
                    child: NoContents(
                      isFLorence: true,
                      title: "",
                      subTitle:
                          "Hey, You have not received any event invitations to analyze",
                      icon: null,
                    ),
                  )
                : Material(
                    color: Colors.transparent,
                    child: ListView(
                      children: [
                        const SizedBox(height: 30),
                        Center(
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
                        ),
                        const SizedBox(height: 50),
                        Text(
                          'Hi ${_provider.user!.userName!}.  This is a summary of all your events invitations',
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _notificationCount(),
                        InviteReceivedSummaryWidget(invites: _invites),
                        const SizedBox(height: 20),
                        MarkdownBody(
                          data: analysisText,
                          styleSheet: MarkdownStyleSheet(
                            h1: Theme.of(context).textTheme.titleLarge,
                            h2: Theme.of(context).textTheme.titleMedium,
                            p: Theme.of(context).textTheme.bodyMedium,
                            listBullet: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
