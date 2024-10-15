// import 'package:bars/utilities/exports.dart';

// class UserBooking extends StatefulWidget {
//   final String currentUserId;

//   UserBooking({
//     required this.currentUserId,
//   });

//   @override
//   State<UserBooking> createState() => _UserBookingState();
// }

// class _UserBookingState extends State<UserBooking>
//     with TickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       if (!_tabController.indexIsChanging) {
//         HapticFeedback.mediumImpact();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//           textScaleFactor:
//               MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Theme.of(context).cardColor,
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(100),
//           child: !Provider.of<UserData>(
//             context,
//           ).showEventTab
//               ? SizedBox.shrink()
//               : AppBar(
//                   automaticallyImplyLeading: true,
//                   iconTheme: IconThemeData(
//                     color: Theme.of(context).secondaryHeaderColor,
//                   ),
//                   elevation: 0.0,
//                   backgroundColor: Theme.of(context).cardColor,
//                   title: Text(
//                     'Bookings',
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                   bottom: TabBar(
//                     controller: _tabController,
//                     dividerColor: Colors.transparent,
//                     labelColor: Theme.of(context).secondaryHeaderColor,
//                     indicatorSize: TabBarIndicatorSize.label,
//                     indicatorColor: Colors.blue,
//                     unselectedLabelColor: Colors.grey,
//                     tabAlignment: TabAlignment.center,
//                     isScrollable: true,
//                     labelPadding:
//                         EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
//                     indicatorWeight: 2.0,
//                     tabs: <Widget>[
//                       Text(
//                         style: Theme.of(context).textTheme.bodyMedium,
//                         'Made',
//                       ),
//                       Text(
//                         style: Theme.of(context).textTheme.bodyMedium,
//                         'Received',
//                       ),
//                     ],
//                   ),
//                 ),
//         ),
//         body: TabBarView(
//           controller: _tabController,
//           physics: const AlwaysScrollableScrollPhysics(),
//           children: <Widget>[
//             BookedAndBookings(
//               userId: widget.currentUserId,
//               isBooked: false,
//             ),
//             BookedAndBookings(
//               userId: widget.currentUserId,
//               isBooked: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
