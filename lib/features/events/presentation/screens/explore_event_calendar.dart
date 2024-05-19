import 'package:bars/utilities/exports.dart';

class ExploreEventCalendar extends StatefulWidget {
  final String currentUserId;

  ExploreEventCalendar({
    required this.currentUserId,
  });

  @override
  State<ExploreEventCalendar> createState() => _ExploreEventCalendarState();
}

class _ExploreEventCalendarState extends State<ExploreEventCalendar> {
  List<Event> _eventsAll = [];
  final _eventAllSnapshot = <DocumentSnapshot>[];

  DateTime _focusedDay = DateTime.now();

  DateTime _currentDate = DateTime.now();
  DateTime _firstDayOfNextMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 2, 1);

  bool loading = true;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _setupEvents(false);
  }

  Future<List<Event>> _setupEvents(bool fetchMore) async {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    String country = _userLocationSettings!.country!;
    String city = _userLocationSettings.city!;

    int remainingLimit = 50;
    List<Event> events = [];

    // Fetch events from the city
    events += fetchMore
        ? await _fetchMoreEvents(
            limit: 25,
            country: country,
            city: city,
            currentDate: _currentDate,
            firstDayOfNextMonth: _firstDayOfNextMonth)
        : await _fetchEvents(
            limit: 25,
            country: country,
            city: city,
            currentDate: _currentDate,
            firstDayOfNextMonth: _firstDayOfNextMonth);
    remainingLimit -= events.length;

    if (remainingLimit > 0) {
      // Fetch events from the country
      events += fetchMore
          ? await _fetchMoreEvents(
              limit: remainingLimit + 15,
              country: country,
              currentDate: _currentDate,
              firstDayOfNextMonth: _firstDayOfNextMonth)
          : await _fetchEvents(
              limit: remainingLimit + 15,
              country: country,
              currentDate: _currentDate,
              firstDayOfNextMonth: _firstDayOfNextMonth);
      remainingLimit = 50 - events.length;
    }

    if (remainingLimit > 0) {
      // Fetch events from anywhere
      events += fetchMore
          ? await _fetchMoreEvents(
              limit: remainingLimit,
              currentDate: _currentDate,
              firstDayOfNextMonth: _firstDayOfNextMonth)
          : await _fetchEvents(
              limit: remainingLimit,
              currentDate: _currentDate,
              firstDayOfNextMonth: _firstDayOfNextMonth);
    }

    if (mounted) {
      setState(() {
        _eventsAll = events;
        loading = false;
      });
    }

    return events;
  }

  Set<String> addedEventIds = Set<String>();

  Future<List<Event>> _fetchEvents({
    required int limit,
    String? country,
    String? city,
    required DateTime currentDate,
    required DateTime firstDayOfNextMonth,
  }) async {
    Query<Map<String, dynamic>> query = allEventsRef;

    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }

    try {
      QuerySnapshot eventFeedSnapShot = await query
          .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
          .orderBy('clossingDay')
          .orderBy(FieldPath.documentId)
          .limit(limit)
          .get();

      List<Event> uniqueEvents = [];

      for (var doc in eventFeedSnapShot.docs) {
        Event event = Event.fromDoc(doc);
        if (!addedEventIds.contains(event.id)) {
          uniqueEvents.add(event);
          addedEventIds.add(event.id);
        }
      }

      if (_eventAllSnapshot.isEmpty) {
        _eventAllSnapshot.addAll(eventFeedSnapShot.docs);
      }

      return uniqueEvents;
    } catch (e) {
      print('Failed to fetch events: $e');
      return [];
    }
  }

  Future<List<Event>> _fetchMoreEvents({
    required int limit,
    String? country,
    String? city,
    required DateTime currentDate,
    required DateTime firstDayOfNextMonth,
  }) async {
    Query<Map<String, dynamic>> query = allEventsRef;

    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }

    query = query.where('startDate', isLessThanOrEqualTo: firstDayOfNextMonth);

    if (_eventAllSnapshot.isNotEmpty) {
      query = query.startAfterDocument(_eventAllSnapshot.last);
    }

    try {
      QuerySnapshot eventFeedSnapShot =
          await query.orderBy(FieldPath.documentId).limit(limit).get();

      List<Event> uniqueEvents = [];

      for (var doc in eventFeedSnapShot.docs) {
        Event event = Event.fromDoc(doc);
        if (!addedEventIds.contains(event.id)) {
          uniqueEvents.add(event);
          addedEventIds.add(event.id);
        }
      }

      _eventAllSnapshot.addAll(eventFeedSnapShot.docs);

      return uniqueEvents;
    } catch (e) {
      print('Failed to fetch events: $e');
      return [];
    }
  }

  Map<DateTime, List<Event>> convertToMap(List<Event> events) {
    Map<DateTime, List<Event>> eventMap = {};
    for (Event event in events) {
      DateTime date = event.startDate.toDate();
      DateTime normalizedDate = DateTime(date.year, date.month,
          date.day); // normalize the date to midnight time.
      if (eventMap[normalizedDate] == null) {
        eventMap[normalizedDate] = [];
      }
      eventMap[normalizedDate]?.add(event);
    }
    return eventMap;
  }

  void _showBottomSheetErrorMessage(BuildContext context, String error) {
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
          title: error,
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  _keyWidget(Color color, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Container(
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Event>> _events = convertToMap(_eventsAll);
    // var _user = Provider.of<UserData>(context, listen: false).user;
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    // final size = MediaQuery.of(context).size;
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 700),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(30)),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(
            height: 10,
          ),
          TicketPurchasingIcon(
            // icon: Icons.schedule_outlined,
            title: '',
          ),
          // const SizedBox(
          //   height: 30,
          // ),
          Divider( thickness: .3,),
          TableCalendar(
              daysOfWeekHeight: ResponsiveHelper.responsiveHeight(context, 50),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Wrap(
                      children: events.map((e) {
                        Event event = e as Event;

                        // Now you can access the isPrivate property
                        Color markerColor;
                        if (event.city == _userLocationSettings!.city!) {
                          markerColor = Colors.red;
                        } else if (event.country ==
                            _userLocationSettings.country) {
                          markerColor = Colors.blue;
                        } else {
                          markerColor = Theme.of(context).secondaryHeaderColor;
                        }
                        return Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: markerColor,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              eventLoader: (day) {
                try {
                  DateTime normalizedDay =
                      DateTime(day.year, day.month, day.day);
                  return _events[normalizedDay] ?? [];
                } catch (e) {
                  _showBottomSheetErrorMessage(
                      context, 'Error loading events for day $day');
                  // print('Error loading events for day $day: $e');
                  return [];
                }
              },
              availableGestures: AvailableGestures.all,
              pageAnimationCurve: Curves.easeInOut,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                holidayTextStyle: TextStyle(color: Colors.red),
                outsideDaysVisible: true,
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 30),
                ),
                headerMargin:
                    const EdgeInsets.only(top: 20, bottom: 10, left: 10),

                leftChevronVisible: false,
                rightChevronVisible: false,
                // ),
                formatButtonVisible: false,
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                DateTime normalizedDay = DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day);
                List<Event> selectedEvents = _events[normalizedDay] ?? [];
                HapticFeedback.mediumImpact();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.black.withOpacity(.6),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height:
                                ResponsiveHelper.responsiveHeight(context, 100),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: ResponsiveHelper.responsiveHeight(
                                    context, 40),
                                width: ResponsiveHelper.responsiveHeight(
                                    context, 40),
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
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
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
                                          .map((event) => EventDisplayWidget(
                                                currentUserId:
                                                    widget.currentUserId,
                                                eventList: selectedEvents,
                                                event: event,
                                                pageIndex: 0,
                                                eventSnapshot: [],
                                                eventPagesOnly: true,
                                                liveCity: '',
                                                liveCountry: '',
                                                isFrom: '',
                                                sortNumberOfDays: 0,
                                              ))
                                          .toList())),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
              firstDay: DateTime(2023),
              lastDay: DateTime(2028),
              focusedDay: _focusedDay),
          loading
              ? Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: SizedBox(
                      height:
                          ResponsiveHelper.responsiveFontSize(context, 30.0),
                      width: ResponsiveHelper.responsiveFontSize(context, 30.0),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                        strokeWidth:
                            ResponsiveHelper.responsiveFontSize(context, 2.0),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Divider( thickness: .3,),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Explore events by dates',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'The use of different colors in the event calendar represents various event locations.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      _userLocationSettings!.city!.isEmpty
                          ? const SizedBox()
                          : _keyWidget(Colors.red,
                              'events in  ${_userLocationSettings.city}'),
                      _userLocationSettings.country!.isEmpty
                          ? const SizedBox()
                          : _keyWidget(Colors.blue,
                              'events in ${_userLocationSettings.country}'),
                      _keyWidget(Theme.of(context).secondaryHeaderColor,
                          'events in other parts of the world'),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
