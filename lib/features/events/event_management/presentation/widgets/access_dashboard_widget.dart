// import 'package:bars/utilities/exports.dart';

// class AccessDashBoardWidget extends StatelessWidget {
//   final Event event;
//   final String currentUserId;
//   final PaletteGenerator palette;

//   const AccessDashBoardWidget(
//       {super.key,
//       required this.event,
//       required this.currentUserId,
//       required this.palette});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (_) => EventDashboardScreen(
//                     currentUserId: currentUserId,
//                     event: event,
//                     palette: palette,
//                   )),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
//         child: Container(
//           padding: const EdgeInsets.symmetric(
//             vertical: 20.0,
//           ),
//           decoration: BoxDecoration(
//               color: Theme.of(context).primaryColorLight,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   offset: Offset(10, 10),
//                   blurRadius: 10.0,
//                   spreadRadius: 4.0,
//                 )
//               ]),
//           // width: width,
//           child: Column(
//             children: [
//               TapToAccessDashboard(),
//               const SizedBox(
//                 height: 20,
//               ),
//               Divider( thickness: .2,
//                 color: Colors.grey,
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20.0,
//                 ),
//                 child: Text(
//                   'You can manage this event through your dashboard, accessible here. If you have purchased tickets for events not created by you, those tickets will be displayed here rather than the dashboard access.',
//                   style: TextStyle(
//                     color: Theme.of(context).secondaryHeaderColor,
//                     fontSize:
//                         ResponsiveHelper.responsiveFontSize(context, 12.0),
//                   ),
//                   textAlign: TextAlign.start,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
