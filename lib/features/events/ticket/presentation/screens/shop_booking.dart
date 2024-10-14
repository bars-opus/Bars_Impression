import 'package:bars/features/gemini_ai/presentation/screens/shop_booking_summary.dart';
import 'package:bars/utilities/exports.dart';

class ShopBooking extends StatefulWidget {
  static final id = 'ShopBooking';
  final String currentUserId;
  final DateTime selectedDay;
  final List<BookingAppointmentModel> selectedBookings;
  // final bool showPopArrow;
  ShopBooking({
    required this.currentUserId,
    required this.selectedDay,
    required this.selectedBookings,
    // this.showPopArrow = false,
  });

  @override
  _ShopBookingState createState() => _ShopBookingState();
}

class _ShopBookingState extends State<ShopBooking>
    with AutomaticKeepAliveClientMixin {
  DocumentSnapshot? _lastTicketOrderDocument;
  // List<BookingAppointmentModel> _appointmentOrder = [];
  // int _ticketCount = 0;
  int limit = 5;
  bool _hasNext = true;
  bool _isLoading = true;

  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  double _startingHorizontalDragPosition = 0;
  bool _canChangeMonth = true;

  late ScrollController _hideButtonController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // _setUpAppointments();
    // _setUpUserCount();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(
    ScrollNotification notification,
  ) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        // if (_lastTicketOrderDocument != null) _loadMoreActivities();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  // _setUpUserCount() async {
  //   DateTime startOfDay = DateTime(widget.selectedDay.year,
  //       widget.selectedDay.month, widget.selectedDay.day);
  //   DateTime endOfDay = DateTime(widget.selectedDay.year,
  //       widget.selectedDay.month, widget.selectedDay.day, 23, 59, 59);
  //   int feedCount = await DatabaseService.numShopAppointmentsReceived(
  //       widget.currentUserId, startOfDay, endOfDay);
  //   if (mounted) {
  //     setState(() {
  //       _ticketCount = feedCount;
  //     });
  //   }
  // }

  Set<String> addedTicketIds = Set<String>();

//   _setUpAppointments() async {
//     try {
//       DateTime startOfDay = DateTime(widget.selectedDay.year,
//           widget.selectedDay.month, widget.selectedDay.day);
//       DateTime endOfDay = DateTime(widget.selectedDay.year,
//           widget.selectedDay.month, widget.selectedDay.day, 23, 59, 59);

//       QuerySnapshot ticketOrderSnapShot = await newBookingsReceivedRef
//           .doc(widget.currentUserId)
//           .collection('bookings')
//           .where('bookingDate',
//               isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
//           .where('bookingDate',
//               isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
//           .orderBy('bookingDate', descending: true)
//           .limit(30)
//           .get();

//       List<BookingAppointmentModel> ticketOrders = ticketOrderSnapShot.docs
//           .map((doc) => BookingAppointmentModel.fromDoc(doc))
//           .toList();

//       List<BookingAppointmentModel> sortedTicketOrders =
//           _sortTicketOrders(ticketOrders);

//       List<BookingAppointmentModel> uniqueEvents = [];

//       for (var ticketOrder in sortedTicketOrders) {
//         if (addedTicketIds.add(ticketOrder.id)) {
//           uniqueEvents.add(ticketOrder);
//         }
//       }
//       if (ticketOrderSnapShot.docs.isNotEmpty) {
//         _lastTicketOrderDocument = ticketOrderSnapShot.docs.last;
//       }

//       if (mounted) {
//         setState(() {
//           _appointmentOrder = uniqueEvents;
//           _isLoading = false;
//         });
//       }

//       if (ticketOrderSnapShot.docs.length < 10) {
//         _hasNext = false; // No more documents to load
//       }

//       return uniqueEvents;
//     } catch (e) {
//       print('Error fetching initial invites: $e');
//       return [];
//     }
//   }

// // Method to load more activities
//   _loadMoreActivities() async {
//     if (_lastTicketOrderDocument == null) {
//       // No more documents to load or initial load has not been done
//       print("No more documents to load or last document is null.");
//       return;
//     }
//     try {
//       DateTime startOfDay = DateTime(widget.selectedDay.year,
//           widget.selectedDay.month, widget.selectedDay.day);
//       DateTime endOfDay = DateTime(widget.selectedDay.year,
//           widget.selectedDay.month, widget.selectedDay.day, 23, 59, 59);

//       QuerySnapshot postFeedSnapShot = await newBookingsReceivedRef
//           .doc(widget.currentUserId)
//           .collection('bookings')
//           .where('bookingDate',
//               isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
//           .where('bookingDate',
//               isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
//           .orderBy('bookingDate', descending: true)
//           .limit(30)
//           .get();
//       List<BookingAppointmentModel> ticketOrders = postFeedSnapShot.docs
//           .map((doc) => BookingAppointmentModel.fromDoc(doc))
//           .toList();

//       List<BookingAppointmentModel> sortedTicketOrders =
//           _sortTicketOrders(ticketOrders);

//       List<BookingAppointmentModel> uniqueEvents = [];

//       for (var ticketOrder in sortedTicketOrders) {
//         if (addedTicketIds.add(ticketOrder.id)) {
//           uniqueEvents.add(ticketOrder);
//         }
//       }

//       if (postFeedSnapShot.docs.isNotEmpty) {
//         _lastTicketOrderDocument = postFeedSnapShot.docs.last;
//       }

//       if (mounted) {
//         setState(() {
//           _appointmentOrder.addAll(uniqueEvents);
//           // Check if there might be more documents to load
//           _hasNext = postFeedSnapShot.docs.length == limit;
//         });
//       }
//       return uniqueEvents;
//     } catch (e) {
//       print('Error loading more activities: $e');
//       _hasNext = false;
//       return _hasNext;
//     }
//   }

// Custom sort function
  List<BookingAppointmentModel> _sortTicketOrders(
      List<BookingAppointmentModel> ticketOrders) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    // Function to determine the sort weight, considering only the date part

    int sortWeight(DateTime eventDate) {
      final eventDay = DateTime(eventDate.year, eventDate.month, eventDate.day);
      if (eventDay.year == today.year &&
          eventDay.month == today.month &&
          eventDay.day == today.day) {
        return 0; // Today's events
      } else if (eventDay.year == tomorrow.year &&
          eventDay.month == tomorrow.month &&
          eventDay.day == tomorrow.day) {
        return 1; // Tomorrow's events
      } else {
        return 2; // Future events
      }
    }

    // Sort the list
    ticketOrders.sort((a, b) {
      final eventADate =
          a.bookingDate!.toDate(); // Convert Timestamp to DateTime if needed
      final eventBDate =
          b.bookingDate!.toDate(); // Convert Timestamp to DateTime if needed

      // Get the sort weight for both events
      final weightA = sortWeight(eventADate);
      final weightB = sortWeight(eventBDate);

      if (weightA != weightB) {
        // Compare based on calculated weight
        return weightA.compareTo(weightB);
      } else {
        // If events have the same weight, sort by timestamp
        // Assuming you still want to sort descending
        return b.bookingDate!.compareTo(a.bookingDate!);
      }
    });

    return ticketOrders;
  }

  _buildInviteBuilder() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: ResponsiveHelper.responsiveFontSize(context, 60.0),
      width: width.toDouble(),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                BookingAppointmentModel appoinmentOrder =
                    widget.selectedBookings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: UserAppointmenstWidget(
                    // ticketOrder: ticketOrder,
                    currentUserId: widget.currentUserId,
                    appointmentList: widget.selectedBookings,
                    appointmentOrder: appoinmentOrder,
                  ),
                );
              },
              childCount: widget.selectedBookings.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshData() async {
    addedTicketIds.clear();
    setState(
      () {
        _isLoading = true;
      },
    );
    // await _setUpAppointments();
    // await _setUpUserCount();
  }

  _ticketPageBody() {
    // int count = _ticketCount - 1;
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: refreshData,
      child: Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Text(
            //     "Appointments",
            //     style: Theme.of(context).textTheme.bodyMedium,
            //   ),
            // ),
            Expanded(
                child: widget.selectedBookings.isEmpty
                    ? Center(
                        child: NoContents(
                          icon: Icons.schedule_outlined,
                          title: 'No appointments',
                          subTitle:
                              'This section will display the appoints you have on your schedule for ${MyDateFormat.toDate(widget.selectedDay)}.',
                        ),
                      )
                    : _buildInviteBuilder()

                //  !_isLoading
                //     ? count.isNegative
                //         ?

                //         Center(
                //             child: NoContents(
                //               icon: Icons.schedule_outlined,
                //               title: 'No appointments',
                //               subTitle:
                //                   'This section will display the appoints you have on your schedule for ${MyDateFormat.toDate(widget.selectedDay)}.',
                //             ),
                //           )
                //         : _buildInviteBuilder()
                //     : ListView.builder(
                //         physics: const NeverScrollableScrollPhysics(),
                //         itemCount: 8,
                //         itemBuilder: (context, index) =>
                //             EventAndUserScimmerSkeleton(from: 'Event'),
                //       ),
                ),
          ],
        ),
      ),
    );
  }

  _shopBookingSummay(
    BuildContext context,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(.6),
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 700),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: ShopBookinSummary(
            bookings: widget.selectedBookings,
            shopType: _provider.user!.shopType!,
          ),

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [_userBookedInfoForNotAuthor(context)],
          // ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scrollbar(
          controller: _hideButtonController,
          child: NestedScrollView(
              controller: _hideButtonController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    expandedHeight:
                        ResponsiveHelper.responsiveHeight(context, 100),
                    flexibleSpace: FlexibleSpaceBar(
                        background: SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TicketPurchasingIcon(
                                  title: '',
                                ),
                                Text(
                                  "Shop appointments",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          if (widget.selectedBookings.isNotEmpty)
                            GestureDetector(
                              onTap: () => _shopBookingSummay(
                                context,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SummaryButton(
                                  icon: null,
                                  isAi: true,
                                  color: Colors.blue,
                                  summary: 'Analyze',
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
                  ),
                ];
              },
              body: _ticketPageBody()),
        ),
      ),
    );
  }
}
