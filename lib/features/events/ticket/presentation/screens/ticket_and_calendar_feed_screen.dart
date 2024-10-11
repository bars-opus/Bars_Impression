import 'package:bars/utilities/exports.dart';

class TicketAndCalendarFeedScreen extends StatefulWidget {
  static final id = 'TicketAndCalendarFeedScreen';
  final String currentUserId;
  final bool showPopArrow;
  TicketAndCalendarFeedScreen({
    required this.currentUserId,
    this.showPopArrow = false,
  });

  @override
  _TicketAndCalendarFeedScreenState createState() =>
      _TicketAndCalendarFeedScreenState();
}

class _TicketAndCalendarFeedScreenState
    extends State<TicketAndCalendarFeedScreen>
    with AutomaticKeepAliveClientMixin {
  DocumentSnapshot? _lastTicketOrderDocument;
  List<BookingAppointmentModel> _appointmentOrder = [];
  int _ticketCount = 0;
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
    _setUpAppointments();
    _setUpUserCount();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(
    ScrollNotification notification,
  ) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        if (_lastTicketOrderDocument != null) _loadMoreActivities();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setUpUserCount() async {
    int feedCount =
        await DatabaseService.numUserAppointments(widget.currentUserId);
    if (mounted) {
      setState(() {
        _ticketCount = feedCount;
      });
    }
  }

  Set<String> addedTicketIds = Set<String>();

  _setUpAppointments() async {
    try {
      QuerySnapshot ticketOrderSnapShot = await newBookingsSentRef
          .doc(widget.currentUserId)
          .collection('bookings')
          .orderBy('bookingDate', descending: true)
          .limit(30)
          .get();

      List<BookingAppointmentModel> ticketOrders = ticketOrderSnapShot.docs
          .map((doc) => BookingAppointmentModel.fromDoc(doc))
          .toList();

      List<BookingAppointmentModel> sortedTicketOrders =
          _sortTicketOrders(ticketOrders);

      List<BookingAppointmentModel> uniqueEvents = [];

      for (var ticketOrder in sortedTicketOrders) {
        if (addedTicketIds.add(ticketOrder.id)) {
          uniqueEvents.add(ticketOrder);
        }
      }
      if (ticketOrderSnapShot.docs.isNotEmpty) {
        _lastTicketOrderDocument = ticketOrderSnapShot.docs.last;
      }

      if (mounted) {
        setState(() {
          _appointmentOrder = uniqueEvents;
          _isLoading = false;
        });
      }

      if (ticketOrderSnapShot.docs.length < 10) {
        _hasNext = false; // No more documents to load
      }

      return uniqueEvents;
    } catch (e) {
      print('Error fetching initial invites: $e');
      return [];
    }
  }

// Method to load more activities
  _loadMoreActivities() async {
    if (_lastTicketOrderDocument == null) {
      // No more documents to load or initial load has not been done
      print("No more documents to load or last document is null.");
      return;
    }
    try {
      QuerySnapshot postFeedSnapShot = await newBookingsSentRef
          .doc(widget.currentUserId)
          .collection('bookings')
          .orderBy('bookingDate', descending: true) // Keep consistent order
          .startAfterDocument(_lastTicketOrderDocument!)
          .limit(limit)
          .get();

      List<BookingAppointmentModel> ticketOrders = postFeedSnapShot.docs
          .map((doc) => BookingAppointmentModel.fromDoc(doc))
          .toList();

      List<BookingAppointmentModel> sortedTicketOrders =
          _sortTicketOrders(ticketOrders);

      List<BookingAppointmentModel> uniqueEvents = [];

      for (var ticketOrder in sortedTicketOrders) {
        if (addedTicketIds.add(ticketOrder.id)) {
          uniqueEvents.add(ticketOrder);
        }
      }

      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastTicketOrderDocument = postFeedSnapShot.docs.last;
      }

      if (mounted) {
        setState(() {
          _appointmentOrder.addAll(uniqueEvents);
          // Check if there might be more documents to load
          _hasNext = postFeedSnapShot.docs.length == limit;
        });
      }
      return uniqueEvents;
    } catch (e) {
      print('Error loading more activities: $e');
      _hasNext = false;
      return _hasNext;
    }
  }

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

  void _showBottomSheetErrorMessage(String errorTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: errorTitle,
          subTitle: 'Check your internet connection and try again.',
        );
      },
    );
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
                    _appointmentOrder[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: UserAppointmenstWidget(
                    // ticketOrder: ticketOrder,
                    currentUserId: widget.currentUserId,
                    appointmentList: _appointmentOrder,
                    appointmentOrder: appoinmentOrder,
                  ),
                );
              },
              childCount: _appointmentOrder.length,
            ),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<BookingAppointmentModel>> convertToMap(
      List<BookingAppointmentModel> tickets) {
    Map<DateTime, List<BookingAppointmentModel>> eventMap = {};
    for (BookingAppointmentModel ticket in tickets) {
      DateTime date = ticket.bookingDate!.toDate();
      DateTime normalizedDate = DateTime(date.year, date.month, date.day);
      if (eventMap[normalizedDate] == null) {
        eventMap[normalizedDate] = [];
      }
      eventMap[normalizedDate]?.add(ticket);
    }
    return eventMap;
  }

  _calendar(BuildContext context) {
    Map<DateTime, List<BookingAppointmentModel>> _ticket =
        convertToMap(_appointmentOrder);

    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _startingHorizontalDragPosition = event.position.dx;
      },
      onPointerMove: (PointerMoveEvent event) async {
        final double dragDistance =
            event.position.dx - _startingHorizontalDragPosition;

        if (_canChangeMonth && dragDistance.abs() > 50) {
          // Consider it a swipe if user moved pointer more than 50 pixels
          _canChangeMonth =
              false; // Prevent changing the month again until delay is over

          if (dragDistance < 0) {
            HapticFeedback.lightImpact();
            // Swipe to the left, go to next month
            setState(() {
              _focusedDay = DateTime(
                  _focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
            });
          } else {
            HapticFeedback.lightImpact();
            // Swipe to the right, go to previous month
            setState(() {
              _focusedDay = DateTime(
                  _focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
            });
          }

          // Reset starting drag position
          _startingHorizontalDragPosition = 0;

          // Wait a bit before allowing the month to be changed again to prevent skipping months
          await Future.delayed(Duration(milliseconds: 500));
          _canChangeMonth = true; // Allow changing the month again
        }
      },
      child: TableCalendar(
        eventLoader: (day) {
          try {
            DateTime normalizedDay = DateTime(day.year, day.month, day.day);
            return _ticket[normalizedDay] ?? [];
          } catch (e) {
            _showBottomSheetErrorMessage('Error loading tickets for day $day');
            return [];
          }
        },
        rowHeight: ResponsiveHelper.responsiveHeight(context, 40.0),
        availableGestures: AvailableGestures.all,
        daysOfWeekHeight: ResponsiveHelper.responsiveHeight(context, 25),
        pageAnimationCurve: Curves.easeInOut,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          holidayTextStyle: TextStyle(color: Colors.red),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
          ),
          headerMargin: const EdgeInsets.only(top: 20, bottom: 10, left: 10),
          leftChevronVisible: false,
          rightChevronVisible: false,
          formatButtonVisible: false,
          formatButtonTextStyle: TextStyle(color: Colors.white),
          formatButtonShowsNext: false,
        ),
        onDaySelected: (selectedDay, focusedDay) {
          DateTime normalizedDay =
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
          List<BookingAppointmentModel> selectedEvents =
              _ticket[normalizedDay] ?? [];
          HapticFeedback.mediumImpact();
          showModalBottomSheet(
            context: context,
            isDismissible: false,
            enableDrag: false,
            isScrollControlled: true,
            backgroundColor: Colors.black.withOpacity(.6),
            builder: (BuildContext context) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: ResponsiveHelper.responsiveHeight(context, 100),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: ResponsiveHelper.responsiveHeight(context, 40),
                        width: ResponsiveHelper.responsiveHeight(context, 40),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: ResponsiveHelper.responsiveHeight(
                                  context, 30),
                            )),
                      ),
                      Container(
                        width: ResponsiveHelper.responsiveHeight(context, 150),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text(
                            MyDateFormat.toDate(selectedDay),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14),
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveHelper.responsiveHeight(context, 100),
                  ),
                  if (selectedEvents.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: selectedEvents
                              .map(
                                (appoinmentOrder) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: UserAppointmenstWidget(
                                    // ticketOrder: ticketOrder,
                                    currentUserId: widget.currentUserId,
                                    appointmentList: _appointmentOrder,
                                    appointmentOrder: appoinmentOrder,
                                  ),

                                  //  EventsFeedAttendingWidget(
                                  //   ticketOrder: ticket,
                                  //   currentUserId: widget.currentUserId,
                                  //   ticketList: _appointmentOrder,
                                  // ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        calendarFormat: _calendarFormat,
        focusedDay: _focusedDay,
      ),
    );
  }

  void _showBottomSheetExpandCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ExploreEventCalendar(
          currentUserId: widget.currentUserId,
        );
      },
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _calendarContainer(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Stack(
            children: [
              _calendar(context),
              Positioned(
                right: 10,
                top: 20,
                child: IconButton(
                    onPressed: () {
                      widget.showPopArrow
                          ? Navigator.pop(context)
                          : _navigateToPage(SearchTicket(
                              currentUserId: widget.currentUserId,
                            ));
                    },
                    icon: Icon(
                      widget.showPopArrow ? Icons.close : Icons.search,
                      size: ResponsiveHelper.responsiveHeight(context, 25),
                      color: Theme.of(context).secondaryHeaderColor,
                    )),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _showBottomSheetExpandCalendar(context);
              },
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'The calendar above allows you to stay organized by keeping track of the dates of your appointments.  ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
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
    await _setUpAppointments();
    await _setUpUserCount();
  }

  _ticketPageBody() {
    int count = _ticketCount - 1;
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: refreshData,
      child: Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Appointments",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: !_isLoading
                    ? count.isNegative
                        ? Center(
                            child: NoContents(
                              icon: MdiIcons.ticketOutline,
                              title: 'No appointments',
                              subTitle:
                                  'This section will display the appoints you have on your schedule.',
                            ),
                          )
                        : _buildInviteBuilder()
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        itemBuilder: (context, index) =>
                            EventAndUserScimmerSkeleton(from: 'Event'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
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
                    backgroundColor: Colors.black,
                    expandedHeight:
                        ResponsiveHelper.responsiveHeight(context, 370),
                    flexibleSpace: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                      ),
                      child: FlexibleSpaceBar(
                          background: SafeArea(
                        child: _calendarContainer(context),
                      )),
                    ),
                  ),
                ];
              },
              body: _ticketPageBody()),
        ),
      ),
    );
  }
}
