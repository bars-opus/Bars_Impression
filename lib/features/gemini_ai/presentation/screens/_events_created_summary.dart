// /// The `EventCreatedSummary` widget displays a summary of events created by the user.
// /// It fetches the events from a database, analyzes them using an AI service, and displays
// /// the results in a user-friendly interface.

// import 'package:bars/utilities/exports.dart';
// import 'package:intl/intl.dart';

// class EventCreatedSummary extends StatefulWidget {
//   @override
//   State<EventCreatedSummary> createState() => _EventCreatedSummaryState();
// }

// class _EventCreatedSummaryState extends State<EventCreatedSummary> {
//   final _googleGenerativeAIService = GoogleGenerativeAIService();
//   List<Event> _events = [];
//   List<String> _analysisResults = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _setupActivities();
//   }

//   /// Prepares a string representation of the list of events for analysis.
//   /// This will format each event's details into a string.
//   String prepareActivitiesForAnalysis(List<Event> events) {
//     return events.map((event) {
//       return '''
// The type of event I created: ${event.type}
// the title: ${event.title}
// the theme: ${event.theme}
// Address: ${event.address}
// Is the event private or public: ${event.isPrivate}
// Is the event free or paid: ${event.isFree}
// if the event is not free have I received the ticket sales payouts money: ${event.fundsDistributed}
// The start date of the event: ${MyDateFormat.toDate(event.startDate.toDate())}
// the closing date of the event: ${MyDateFormat.toDate(event.clossingDay.toDate())}
// ''';
//     }).join('\n\n');
//   }

//   /// Sets up activities by fetching events from the database and analyzing them.
//   Future<void> _setupActivities() async {
//     var _provider = Provider.of<UserData>(context, listen: false);
//     try {
//       List<Event> allEvents = [];
//       DocumentSnapshot? lastDocument;
//       // Fetch events in batches of 10, ordered by timestamp.
//       while (true) {
//         Query query = eventsRef
//             .doc(_provider.currentUserId)
//             .collection('userEvents')
//             .orderBy('timestamp', descending: true)
//             .limit(10);

//         if (lastDocument != null) {
//           query = query.startAfterDocument(lastDocument);
//         }

//         QuerySnapshot snapshot = await query.get();

//         if (snapshot.docs.isEmpty) break;

//         List<Event> batchEventies =
//             snapshot.docs.map((doc) => Event.fromDoc(doc)).toList();
//         allEvents.addAll(batchEventies);
//         lastDocument = snapshot.docs.last;
//       }

//       // If no events are found, update the state accordingly.
//       if (allEvents.isEmpty) {
//         if (mounted) {
//           setState(() {
//             _events = [];
//             _isLoading = false;
//           });
//         }
//         return;
//       }

//       // Analyze the fetched events.
//       List<String> analysisResults =
//           await batchAnalyzeActivitiesWithGemini(allEvents);

//       // Print and store the analysis results.
//       for (var result in analysisResults) {
//         print('Analysis: $result');
//       }

//       if (mounted) {
//         setState(() {
//           _analysisResults = analysisResults;
//           _events = allEvents;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       _isLoading = false;
//       // mySnackBar(context, 'An error occured');
//     }
//   }

//   /// Analyzes activities in batches using the Gemini AI service.
//   Future<List<String>> batchAnalyzeActivitiesWithGemini(
//       List<Event> activities) async {
//     int batchSize = 10;
//     List<String> analysisResults = [];
//     // Process events in batches to avoid overloading the analysis service.
//     for (int i = 0; i < activities.length; i += batchSize) {
//       List<Event> batch = activities.skip(i).take(batchSize).toList();
//       String preparedData = prepareActivitiesForAnalysis(batch);
//       String analysis = await analyzeActivitiesWithGemini(preparedData);
//       analysisResults.add(analysis);
//     }
//     return analysisResults;
//   }

//   /// Sends the prepared event data to  Gemini AI service for analysis and returns the result.
//   Future<String> analyzeActivitiesWithGemini(String preparedData) async {
//     final prompt = '''
// Analyze the following events I have created and give a detailed summary
// $preparedData
// ''';

//     final response = await _googleGenerativeAIService.generateResponse(prompt);
//     return response!;
//   }

//   /// Creates a row widget displaying an icon and summary text.
//   _summaryRow(IconData icon, String summary, bool isTotal) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: ResponsiveHelper.responsiveHeight(context, 20),
//           color: isTotal ? Colors.white : Colors.red,
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         Expanded(
//           child: Text(
//             summary,
//             style: TextStyle(
//               color: isTotal
//                   ? Colors.white
//                   : Theme.of(context).secondaryHeaderColor,
//               fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Displays a modal bottom sheet with the list of activities.
//   void _showActivities() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//           var _provider = Provider.of<UserData>(context, listen: false);

//           return Container(
//             height: ResponsiveHelper.responsiveHeight(context, 600),
//             decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(30)),
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 TicketPurchasingIcon(
//                   title: '',
//                 ),
//                 Container(
//                   height: ResponsiveHelper.responsiveHeight(context, 530),
//                   child: ListView.builder(
//                     itemCount: _events.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final _event = _events[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 1.0),
//                         child: EventDisplayWidget(
//                           currentUserId: _provider.currentUserId!,
//                           eventList: _events,
//                           post: _event,
//                           pageIndex: 0,
//                           eventSnapshot: [],
//                           eventPagesOnly: true,
//                           liveCity: '',
//                           liveCountry: '',
//                           isFrom: '',
//                           sortNumberOfDays: 0,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }

//   /// Displays a notification count for the total number of events.
//   _notificationCount() {
//     return GestureDetector(
//       onTap: () => _showActivities(),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(vertical: 1),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.blue,
//         ),
//         child: _summaryRow(
//             Icons.event_available_outlined,
//             "${NumberFormat.compact().format(_events.length)} events in total",
//             true),
//       ),
//     );
//   }

// // Builds the main body of the screen
//   Widget _buildBody(
//       BuildContext context, UserData provider, String analysisText) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       height: ResponsiveHelper.responsiveHeight(context, 600.0),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: _isLoading
//           ? _buildLoadingIndicator(context)
//           : _events.isEmpty
//               ? _buildNoEventsMessage()
//               : _buildEventList(context, provider, analysisText),
//     );
//   }

// // Displays a loading indicator
//   Widget _buildLoadingIndicator(BuildContext context) {
//     return Center(
//       child: Loading(
//         shakeReapeat: false,
//         color: Theme.of(context).secondaryHeaderColor,
//         title: 'processing...',
//         icon: FontAwesomeIcons.circle,
//       ),
//     );
//   }

// // Displays a message when no events are available
//   Widget _buildNoEventsMessage() {
//     return Center(
//       child: NoContents(
//         isFLorence: true,
//         title: "",
//         subTitle: "Hey, There have been no events created to analyze",
//         icon: null,
//       ),
//     );
//   }

// // Builds the list of events
//   Widget _buildEventList(
//       BuildContext context, UserData provider, String analysisText) {
//     var _sizedBox = const SizedBox(height: 20);
//     return Material(
//       color: Colors.transparent,
//       child: ListView(
//         children: [
//           const SizedBox(height: 30),
//           _buildAnimatedCircle(),
//           const SizedBox(height: 50),
//           _buildGreetingText(context, provider),
//           _sizedBox,
//           _notificationCount(),
//           EventCreatedSummaryWidget(events: _events),
//           _sizedBox,
//           _buildAnalysisText(context, analysisText),
//         ],
//       ),
//     );
//   }

// // Builds the animated circle widget
//   Widget _buildAnimatedCircle() {
//     return Center(
//       child: ShakeTransition(
//         axis: Axis.vertical,
//         duration: Duration(seconds: 2),
//         child: AnimatedCircle(
//           size: 30,
//           stroke: 2,
//           animateSize: true,
//           animateShape: true,
//         ),
//       ),
//     );
//   }

// // Displays a greeting text with the user's name
//   Widget _buildGreetingText(BuildContext context, UserData provider) {
//     return Text(
//       'Hi ${provider.user!.userName!}. This is a summary of all your past 10 events created',
//       style: TextStyle(
//         color: Theme.of(context).secondaryHeaderColor,
//         fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
//       ),
//     );
//   }

// // Displays the analysis text using Markdown
//   Widget _buildAnalysisText(BuildContext context, String analysisText) {
//     return MarkdownBody(
//       data: analysisText,
//       styleSheet: MarkdownStyleSheet(
//         h1: Theme.of(context).textTheme.titleLarge,
//         h2: Theme.of(context).textTheme.titleMedium,
//         p: Theme.of(context).textTheme.bodyMedium,
//         listBullet: Theme.of(context).textTheme.bodySmall,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var provider = Provider.of<UserData>(context);
//     String analysisText = _analysisResults.join('\n\n');

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: _buildBody(context, provider, analysisText),
//     );
//   }
// }
