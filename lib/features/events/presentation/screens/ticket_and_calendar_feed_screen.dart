import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class TicketAndCalendarFeedScreen extends StatefulWidget {
  static final id = 'TicketAndCalendarFeedScreen';
  final String currentUserId;
  TicketAndCalendarFeedScreen({
    required this.currentUserId,
  });

  @override
  _TicketAndCalendarFeedScreenState createState() =>
      _TicketAndCalendarFeedScreenState();
}

class _TicketAndCalendarFeedScreenState
    extends State<TicketAndCalendarFeedScreen>
    with AutomaticKeepAliveClientMixin {
  DocumentSnapshot? _lastTicketOrderDocument;
  List<TicketOrderModel> _ticketOrder = [];
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
    _setUpInvites();
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
    int feedCount = await DatabaseService.numUsersTickets(widget.currentUserId);
    if (mounted) {
      setState(() {
        _ticketCount = feedCount;
      });
    }
  }

  _setUpInvites() async {
    // try {
    QuerySnapshot ticketOrderSnapShot = await userInviteRef
        .doc(widget.currentUserId)
        .collection('eventInvite')
        .orderBy('eventTimestamp', descending: true)
        .limit(10)
        .get();
    List<TicketOrderModel> ticketOrder = ticketOrderSnapShot.docs
        .map((doc) => TicketOrderModel.fromDoc(doc))
        .toList();
    if (ticketOrderSnapShot.docs.isNotEmpty) {
      _lastTicketOrderDocument = ticketOrderSnapShot.docs.last;
    }
    if (mounted) {
      setState(() {
        _ticketOrder = ticketOrder;
        _isLoading = false;
      });
    }
    if (ticketOrderSnapShot.docs.length < limit) {
      _hasNext = false;
    }

    return ticketOrder;
    // } catch (e) {
    //   return [];
    // }
  }

  _loadMoreActivities() async {
    _hasNext = true;
    QuerySnapshot postFeedSnapShot = await userInviteRef
        .doc(widget.currentUserId)
        .collection('eventInvite')
        .orderBy('eventTimestamp', descending: true)
        .startAfterDocument(_lastTicketOrderDocument!)
        .limit(limit)
        .get();
    List<TicketOrderModel> morePosts = postFeedSnapShot.docs
        .map((doc) => TicketOrderModel.fromDoc(doc))
        .toList();
    List<TicketOrderModel> allPost = _ticketOrder..addAll(morePosts);
    if (postFeedSnapShot.docs.isNotEmpty) {
      _lastTicketOrderDocument = postFeedSnapShot.docs.last;
    }
    if (mounted) {
      setState(() {
        _ticketOrder = allPost;
      });
    }
    _hasNext = false;
    return _hasNext;
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
                TicketOrderModel ticketOrder = _ticketOrder[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: EventsFeedAttendingWidget(
                    ticketOrder: ticketOrder,
                    currentUserId: widget.currentUserId,
                    ticketList: _ticketOrder,
                  ),
                );
              },
              childCount: _ticketOrder.length,
            ),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<TicketOrderModel>> convertToMap(
      List<TicketOrderModel> tickets) {
    Map<DateTime, List<TicketOrderModel>> eventMap = {};
    for (TicketOrderModel ticket in tickets) {
      DateTime date = ticket.eventTimestamp!.toDate();
      DateTime normalizedDate = DateTime(date.year, date.month, date.day);
      if (eventMap[normalizedDate] == null) {
        eventMap[normalizedDate] = [];
      }
      eventMap[normalizedDate]?.add(ticket);
    }
    return eventMap;
  }

  _calendar(BuildContext context) {
    Map<DateTime, List<TicketOrderModel>> _ticket = convertToMap(_ticketOrder);

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
          List<TicketOrderModel> selectedEvents = _ticket[normalizedDay] ?? [];
          HapticFeedback.mediumImpact();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black.withOpacity(.6),
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  children: [
                    SizedBox(
                      height: ResponsiveHelper.responsiveHeight(context, 100),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height:
                              ResponsiveHelper.responsiveHeight(context, 40),
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
                        Expanded(
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
                      ],
                    ),
                    const SizedBox(
                      height: 10,
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
                                  (ticket) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: EventsFeedAttendingWidget(
                                      ticketOrder: ticket,
                                      currentUserId: widget.currentUserId,
                                      ticketList: _ticketOrder,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                  ],
                ),
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
                      _navigateToPage(SearchTicket(
                        currentUserId: widget.currentUserId,
                      ));
                    },
                    icon: Icon(
                      Icons.search,
                      size: ResponsiveHelper.responsiveHeight(context, 25),
                      color: Theme.of(context).secondaryHeaderColor,
                    )),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _showBottomSheetExpandCalendar(context);
              },
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'The calendar above allows you to stay organized by keeping track of the dates of your events (Tickets). To explore events for specific dates, tap ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: "Explore events by date.",
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Colors.blue,
                      ),
                    )
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
    setState(
      () {
        _isLoading = true;
      },
    );
    await _setUpInvites();
  }

  _ticketPageBody() {
    int count = _ticketCount - 1;
    return RefreshIndicator(
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
                  "Tickets",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: !_isLoading
                    ? count.isNegative
                        ? Center(
                            child: NoContents(
                              icon: MdiIcons.ticketOutline,
                              title: 'No tickets found',
                              subTitle:
                                  'This section will display the tickets for the events you plan to attend.',
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
