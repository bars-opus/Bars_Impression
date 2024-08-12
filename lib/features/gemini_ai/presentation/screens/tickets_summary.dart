/// The `TicketsSummary` widget provides a comprehensive summary of event tickets
/// owned by the user. It fetches and analyzes ticket data, offering insights
/// using an AI service. The widget displays ticket information, including event
/// details and purchase history.

import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class TicketsSummary extends StatefulWidget {
  @override
  State<TicketsSummary> createState() => _TicketsSummaryState();
}

class _TicketsSummaryState extends State<TicketsSummary> {
  final _googleGenerativeAIService = GoogleGenerativeAIService();
  List<TicketOrderModel> _tickets = [];
  List<String> _analysisResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupActivities();
  }

  /// Prepares ticket data for AI analysis by formatting each ticket detail.
  String prepareActivitiesForAnalysis(List<TicketOrderModel> tickets) {
    return tickets.map((ticket) {
      return '''
Title of the event I have a ticket for: ${ticket.eventTitle}
Date the event will happen: ${MyDateFormat.toDate(ticket.eventTimestamp!.toDate())}
The price of the ticket: ${ticket.total}
Did I request for a refund: ${ticket.refundRequestStatus}
Was I invited: ${ticket.isInvited}
Has the event been cancelled: ${ticket.isDeleted} and if cancelled what was the reason provided  ${ticket.canlcellationReason}
The time I purchased the ticket: ${MyDateFormat.toDate(ticket.timestamp!.toDate())}
''';
    }).join('\n\n');
  }

  /// Fetches and sets up ticket data, analyzing it in batches.
  Future<void> _setupActivities() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    try {
      List<TicketOrderModel> allTicketPurchasedModels = [];
      DocumentSnapshot? lastDocument;

      while (true) {
        Query query = newUserTicketOrderRef
            .doc(_provider.currentUserId)
            .collection('ticketOrders')
            .orderBy('timestamp', descending: true)
            .limit(10);

        if (lastDocument != null) {
          query = query.startAfterDocument(lastDocument);
        }

        QuerySnapshot snapshot = await query.get();

        if (snapshot.docs.isEmpty) break;

        List<TicketOrderModel> batchTicketPurchasedModels =
            snapshot.docs.map((doc) => TicketOrderModel.fromDoc(doc)).toList();
        allTicketPurchasedModels.addAll(batchTicketPurchasedModels);
        lastDocument = snapshot.docs.last;
      }

      if (allTicketPurchasedModels.isEmpty) {
        if (mounted) {
          setState(() {
            _tickets = [];
            _isLoading = false;
          });
        }
        return; // Exit if no activities
      }

      // Analyze the tickets in batches
      List<String> analysisResults =
          await batchAnalyzeActivitiesWithGemini(allTicketPurchasedModels);

      if (mounted) {
        setState(() {
          _analysisResults = analysisResults;
          _tickets = allTicketPurchasedModels;
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

  /// Analyzes ticket data in batches using the AI service.
  Future<List<String>> batchAnalyzeActivitiesWithGemini(
      List<TicketOrderModel> activities) async {
    int batchSize = 10;
    List<String> analysisResults = [];

    for (int i = 0; i < activities.length; i += batchSize) {
      List<TicketOrderModel> batch =
          activities.skip(i).take(batchSize).toList();
      String preparedData = prepareActivitiesForAnalysis(batch);
      String analysis = await analyzeActivitiesWithGemini(preparedData);
      analysisResults.add(analysis);
    }

    return analysisResults;
  }

  /// Sends prepared ticket data to the AI service for analysis.
  Future<String> analyzeActivitiesWithGemini(String preparedData) async {
    final prompt = '''
Analyze the following event tickets I have and provide a summary:
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

  /// Displays a bottom sheet with a list of tickets.
  void _showActivities() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var _provider = Provider.of<UserData>(context, listen: false);

            return Container(
              height: ResponsiveHelper.responsiveHeight(context, 600),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TicketPurchasingIcon(title: ''),
                  Container(
                    height: ResponsiveHelper.responsiveHeight(context, 530),
                    child: ListView.builder(
                      itemCount: _tickets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final _ticket = _tickets[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: EventsFeedAttendingWidget(
                            ticketOrder: _ticket,
                            currentUserId: _provider.currentUserId!,
                            ticketList: _tickets,
                          ),
                        );
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

  /// Builds a notification count widget with an icon.
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
          "${NumberFormat.compact().format(_tickets.length)} events in total",
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
            : _tickets.isEmpty
                ? Center(
                    child: NoContents(
                      isFLorence: true,
                      title: "",
                      subTitle:
                          "Hey, You don't have any tickets yet to analyze.",
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
                          'Hi ${_provider.user!.userName!}.  This is a summary of your tickets. Tickets for events you have created were also considered in this analysis.',
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _notificationCount(),
                        TicketSummaryWidget(
                          tickets: _tickets,
                        ),
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
