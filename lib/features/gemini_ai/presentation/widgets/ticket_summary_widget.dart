// import 'package:bars/utilities/exports.dart';



// // This widget summarizes and displays a list of tickets by grouping them.
// // It categorizes tickets based on their invitation, deletion, and payment status.
// // Users can tap on a summary to view detailed tickets in a modal sheet.


// class TicketSummaryWidget extends StatelessWidget {
//   final List<TicketOrderModel> tickets;

//   TicketSummaryWidget({required this.tickets});

//   // Groups tickets by their properties and counts them.
//   Map<String, int> _groupAndCountTicketOrderModels() {
//     Map<String, int> ticketCounts = {};

//     for (var ticket in tickets) {
//       bool isFree = ticket.total == 0;
//       String key = '${ticket.isInvited}-${ticket.isDeleted}-${isFree}';
//       ticketCounts[key] = (ticketCounts[key] ?? 0) + 1;
//     }

//     return ticketCounts;
//   }

//   // Generates summary text for a given ticket status and count.
//   String _generateSummaryText(String key, int count) {
//     bool isInvited = key.split('-')[0] == 'true';
//     bool isDeleted = key.split('-')[1] == 'true';
//     bool isFree = key.split('-')[2] == 'true';

//     String invitedText = isInvited ? "Invited" : "Not Invited";
//     String deletedText = isDeleted ? "Deleted" : "Available";
//     String freeText = isFree ? "Free" : "Paid";

//     return '$count $invitedText, $deletedText & $freeText';
//   }

//   // Builds a summary container for each ticket status.
//   Widget _summaryContainer(BuildContext context, IconData icon, Color color,
//       String summary, List<TicketOrderModel> tickets) {
//     return GestureDetector(
//       onTap: () => _showActivitiesByType(context, tickets),
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

//   // Displays a list of tickets in a modal bottom sheet.
//   void _showActivitiesByType(
//       BuildContext context, List<TicketOrderModel> tickets) {
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
//                 color: Theme.of(context).primaryColorLight,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 children: [
//                   TicketPurchasingIcon(title: ''),
//                   Container(
//                     height: ResponsiveHelper.responsiveHeight(context, 530),
//                     child: ListView.builder(
//                       itemCount: tickets.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final ticket = tickets[index];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 1.0),
//                           child: EventsFeedAttendingWidget(
//                             ticketOrder: ticket,
//                             currentUserId: _provider.currentUserId!,
//                             ticketList: tickets,
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
//     // Group and count tickets for display.
//     Map<String, int> ticketCounts = _groupAndCountTicketOrderModels();

//     // Define icons for each ticket status.
//     Map<String, IconData> icons = {
//       'true-true-true': Icons.event_available_outlined,
//       'true-true-false': Icons.event_busy_outlined,
//       'true-false-true': Icons.event_note_outlined,
//       'true-false-false': Icons.event_outlined,
//       'false-true-true': Icons.event_outlined,
//       'false-true-false': Icons.event_busy_outlined,
//       'false-false-true': Icons.event_note_outlined,
//       'false-false-false': Icons.event_seat_outlined,
//     };

//     return Column(
//       children: icons.entries.map((entry) {
//         int count = ticketCounts[entry.key] ?? 0;
//         if (count > 0) {
//           // Filter tickets matching the current key.
//           List<TicketOrderModel> filteredTickets = tickets.where((ticket) {
//             bool isFree = ticket.total == 0;
//             String key = '${ticket.isInvited}-${ticket.isDeleted}-${isFree}';
//             return key == entry.key;
//           }).toList();

//           // Generate summary text for the ticket status.
//           String summaryText = _generateSummaryText(entry.key, count);
//           bool isAvailable = !entry.key.contains('true-true');

//           // Create a summary container for the ticket status.
//           return _summaryContainer(
//             context,
//             entry.value,
//             isAvailable ? Colors.blue : Colors.red,
//             summaryText,
//             filteredTickets,
//           );
//         } else {
//           return SizedBox.shrink();
//         }
//       }).toList(),
//     );
//   }
// }


