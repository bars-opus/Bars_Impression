// import 'package:bars/utilities/exports.dart';

// // This widget summarizes and displays a list of events by grouping them.
// // It shows a summary of each event type, whether it's free or private.
// // Users can tap on a summary to see detailed events in a modal sheet.

// class EventCreatedSummaryWidget extends StatelessWidget {
//   final List<Event> events;

//   EventCreatedSummaryWidget({required this.events});

//   // Groups events by their properties and counts them.
//   Map<String, int> _groupAndCountEvents() {
//     Map<String, int> eventCounts = {};

//     for (var event in events) {
//       String key = '${event.isFree}-${event.type}-${event.isPrivate}';
//       eventCounts[key] = (eventCounts[key] ?? 0) + 1;
//     }

//     return eventCounts;
//   }

//   // Builds a summary container for each event type.
//   Widget _summaryContainer(BuildContext context, IconData icon, Color color,
//       String summary, List<Event> events) {
//     return GestureDetector(
//       onTap: () => _showActivitiesByType(context, events),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(vertical: 1),
//         decoration: BoxDecoration(
//           color: Theme.of(context).primaryColorLight,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: _summaryRow(
//           context,
//           icon,
//           color,
//           summary,
//         ),
//       ),
//     );
//   }

//   // Creates a row with an icon and summary text.
//   Widget _summaryRow(
//     BuildContext context,
//     IconData icon,
//     Color color,
//     String summary,
//   ) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: ResponsiveHelper.responsiveHeight(context, 20),
//           color: color,
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             summary,
//             style: TextStyle(
//               color: Theme.of(context).secondaryHeaderColor,
//               fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Displays a list of events in a modal bottom sheet.
//   void _showActivitiesByType(BuildContext context, List<Event> events) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             var _provider = Provider.of<UserData>(context, listen: false);

//             return Container(
//               height: ResponsiveHelper.responsiveHeight(context, 600),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 children: [
//                   TicketPurchasingIcon(title: ''),
//                   Container(
//                     height: ResponsiveHelper.responsiveHeight(context, 530),
//                     child: ListView.builder(
//                       itemCount: events.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final event = events[index];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 1.0),
//                           child: EventDisplayWidget(
//                             currentUserId: _provider.currentUserId!,
//                             eventList: events,
//                             event: event,
//                             pageIndex: 0,
//                             eventSnapshot: [],
//                             eventPagesOnly: true,
//                             liveCity: '',
//                             liveCountry: '',
//                             isFrom: '',
//                             sortNumberOfDays: 0,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Group and count events for display.
//     Map<String, int> eventCounts = _groupAndCountEvents();

//     // Define icons for each event type.
//     Map<String, IconData> icons = {
//       'true-Parties-true': Icons.party_mode_outlined,
//       'true-Music_concerts-true': Icons.music_note_outlined,
//       'true-Festivals-true': Icons.festival_outlined,
//       'true-Club_nights-true': Icons.nightlife_outlined,
//       'true-Pub_events-true': Icons.local_bar_outlined,
//       'true-Games/Sports-true': Icons.sports_outlined,
//       'true-Religious-true': Icons.church_outlined,
//       'true-Business-true': Icons.business_center_outlined,
//       'true-Others-true': Icons.other_houses_outlined,
//       'false-Parties-true': Icons.party_mode_outlined,
//       'false-Music_concerts-true': Icons.music_note_outlined,
//       'false-Festivals-true': Icons.festival_outlined,
//       'false-Club_nights-true': Icons.nightlife_outlined,
//       'false-Pub_events-true': Icons.local_bar_outlined,
//       'false-Games/Sports-true': Icons.sports_outlined,
//       'false-Religious-true': Icons.church_outlined,
//       'false-Business-true': Icons.business_center_outlined,
//       'false-Others-true': Icons.other_houses_outlined,
//       'true-Parties-false': Icons.party_mode_outlined,
//       'true-Music_concerts-false': Icons.music_note_outlined,
//       'true-Festivals-false': Icons.festival_outlined,
//       'true-Club_nights-false': Icons.nightlife_outlined,
//       'true-Pub_events-false': Icons.local_bar_outlined,
//       'true-Games/Sports-false': Icons.sports_outlined,
//       'true-Religious-false': Icons.church_outlined,
//       'true-Business-false': Icons.business_center_outlined,
//       'true-Others-false': Icons.other_houses_outlined,
//       'false-Parties-false': Icons.party_mode_outlined,
//       'false-Music_concerts-false': Icons.music_note_outlined,
//       'false-Festivals-false': Icons.festival_outlined,
//       'false-Club_nights-false': Icons.nightlife_outlined,
//       'false-Pub_events-false': Icons.local_bar_outlined,
//       'false-Games/Sports-false': Icons.sports_outlined,
//       'false-Religious-false': Icons.church_outlined,
//       'false-Business-false': Icons.business_center_outlined,
//       'false-Others-false': Icons.other_houses_outlined,
//     };

//     return Column(
//       children: icons.entries.map((entry) {
//         int count = eventCounts[entry.key] ?? 0;
//         if (count > 0) {
//           // Filter events matching the current key.
//           List<Event> filteredEvents = events.where((event) {
//             String key = '${event.isFree}-${event.type}-${event.isPrivate}';
//             return key == entry.key;
//           }).toList();

//           // Determine tags for free and private events.
//           bool isFree = entry.key.split('-')[0] == 'true';
//           bool isPrivate = entry.key.split('-')[2] == 'true';
//           String additionalTags =
//               '${isFree ? " (free)" : ""}${isPrivate ? " (private)" : ""}';
//           String summaryText =
//               '$count ${entry.key.split('-')[1]}$additionalTags';

//           // Create a summary container for the event type.
//           return _summaryContainer(context, entry.value,
//               isFree ? Colors.green : Colors.red, summaryText, filteredEvents);
//         } else {
//           return SizedBox.shrink();
//         }
//       }).toList(),
//     );
//   }
// }
