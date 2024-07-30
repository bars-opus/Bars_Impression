// import 'package:bars/utilities/dimensions.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventEnlargedScreen extends StatefulWidget {
  final String currentUserId;
  final String type;
  final Event event;
  final bool justCreated;
  final bool showPrivateEvent;
  final PaletteGenerator? palette;
  final String marketedAffiliateId;

  EventEnlargedScreen({
    required this.currentUserId,
    required this.event,
    required this.type,
    this.justCreated = false,
    required this.showPrivateEvent,
    this.marketedAffiliateId = '',
    this.palette,
  });

  @override
  State<EventEnlargedScreen> createState() => _EventEnlargedScreenState();
}

class _EventEnlargedScreenState extends State<EventEnlargedScreen>
    with AutomaticKeepAliveClientMixin {
  bool _displayImage = false;
  bool _displayReportWarning = false;
  var _isVisible;
  bool _heartAnim = false;
  bool _isBlockedUser = false;
  late DateTime _date;
  late DateTime _closingDate;
  bool _eventHasStarted = false;
  bool _eventHasEnded = false;
  int _ticketSeat = 0;
  TextEditingController _askController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  Timestamp _fristScheduleTime = Timestamp.now();
  double _fristTickePrice = 0;
  TicketModel? _fristTicke;
  int _selectedSeat = 0;
  int _selectedRow = 0;
  bool _isPlaying = true;
  bool _isLoadingDashboard = false;
  bool _isLoading = false;
  late ScrollController _hideButtonController;
  bool _showInfo = false;
  int duratoinDuringStartingToEndingDate = 0;
  Color lightVibrantColor = Colors.white;
  late Color lightMutedColor;

  @override
  void initState() {
    super.initState();
    _setupIsBlockedUser();
    _countDown();
    _displayReportWarning = widget.event.report.isNotEmpty;
    _setUpTicket();
    _askController.addListener(_onAskTextChanged);
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (mounted) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    _askController.dispose();
    _isTypingNotifier.dispose();
    super.dispose();
  }

  void _countDown() async {
    DateTime eventDate = widget.event.startDate == null
        ? DateTime.parse('2023-02-27 00:00:00.000')
        : widget.event.startDate.toDate();

    DateTime clossingDate = widget.event.clossingDay.toDate();
    final toDaysDate = DateTime.now();
    Duration _duratoinDuringStartingToEndingDate =
        clossingDate.difference(eventDate);
    int duratoinDuringStartingToEnding =
        _duratoinDuringStartingToEndingDate.inDays;

    setState(() {
      duratoinDuringStartingToEndingDate = duratoinDuringStartingToEnding;
    });

    if (EventHasStarted.hasEventStarted(widget.event.startDate.toDate())) {
      if (mounted) {
        setState(() {
          _eventHasStarted = true;
        });
      }
    }

    if (EventHasStarted.hasEventEnded(widget.event.clossingDay.toDate())) {
      if (mounted) {
        setState(() {
          _eventHasEnded = true;
        });
      }
    }
  }

  _setUpTicket() {
    List<TicketModel> tickets = widget.event.ticket;
    if (tickets.isNotEmpty) {
      TicketModel firstTicket = tickets[0];
      if (mounted) {
        setState(() {
          _fristTickePrice = firstTicket.price;
        });
      }
    } else {}
  }

  void _onAskTextChanged() {
    if (_askController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.event.authorId,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
  }

  _setImage() async {
    HapticFeedback.heavyImpact();
    if (mounted) {
      setState(() {
        _displayImage = !_displayImage;
      });
    }
  }

  _launchMap() {
    return MapsLauncher.launchQuery(widget.event.address);
  }

  _setContentWarning() {
    if (mounted) {
      setState(() {
        _displayReportWarning = false;
      });
    }
  }

  void _showBottomSheetPreviosEvent(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 400),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: WebDisclaimer(
            contentType: 'Previous Event',
            icon: Icons.play_arrow_outlined,
            link: widget.event.previousEvent,
          ),
        );
      },
    );
  }

//Action Sheet to perform more actions
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EventBottomModalSheetActions(
          event: widget.event,
          currentUserId: widget.currentUserId,
          eventHasEnded: _eventHasEnded,
        );
      },
    );
  }

  // display event dates and schedules on calendar
  void _expandEventDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 650),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(30),
            ),
            child: _eventDetails());
      },
    );
  }

  GoogleMapController? _mapController;
  LatLng? _initialPosition;
  Set<Marker> _markers = {};

  Future<void> _setInitialPosition() async {
    try {
      if (widget.event.latLng.isNotEmpty) {
        final List<String> latLngPartition =
            widget.event.latLng.trim().replaceAll('\n', ' ').split(",");
        final LatLng newPosition = LatLng(
          double.parse(latLngPartition[0]),
          double.parse(latLngPartition[1]),
        );
        setState(() {
          _initialPosition = newPosition;
          _markers.add(
            Marker(
              onTap: _launchMap,
              markerId: MarkerId('marker_id_23'),
              position: newPosition,
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(
                title: widget.event.address,
                onTap: _launchMap,
              ),
            ),
          );
        });
      } else {
        print('No results found for the address.');
        _fallbackPosition();
      }
    } catch (e) {
      // print('Error getting initial position: $e');
    }
  }

  void _fallbackPosition() {
    setState(() {
      _initialPosition = LatLng(
          5.653311499999999, -0.0203699); // Fallback position to Accra, Ghana
      _markers.add(
        Marker(
          markerId: MarkerId('fallback_marker'),
          position: _initialPosition!,
          infoWindow: InfoWindow(
            title: 'Fallback Position',
          ),
        ),
      );
    });
  }

  void _moveCamera(LatLng position) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 12.0,
        ),
      ),
    );
  }

  Map<DateTime, List<Schedule>> convertToMap(List<Schedule> shedules) {
    Map<DateTime, List<Schedule>> scheduleMap = {};
    for (Schedule schedule in shedules) {
      DateTime date = schedule.scheduleDate.toDate();
      DateTime normalizedDate = DateTime(date.year, date.month, date.day);
      if (scheduleMap[normalizedDate] == null) {
        scheduleMap[normalizedDate] = [];
      }
      scheduleMap[normalizedDate]?.add(schedule);
    }
    return scheduleMap;
  }

  _scheduleTitle(DateTime selectedDay) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
            )),
        Text(
          MyDateFormat.toDate(selectedDay),
          style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  _googleMapDisplay() {
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 400.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
      ),
      child: FutureBuilder<void>(
        future: _setInitialPosition(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return GoogleMap(
              myLocationButtonEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
                if (_initialPosition != null) {
                  _moveCamera(_initialPosition!);
                }
              },
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: _initialPosition!,
                zoom: 21.0,
              ),
            );
          }
        },
      ),
    );
  }

  _sponsorAndPartner() {
    List<TaggedEventPeopleModel> taggedPeople = widget.event.taggedPeople;
    List<TaggedEventPeopleModel> taggedPeopleOption = [];
    for (TaggedEventPeopleModel taggedPeople in taggedPeople) {
      TaggedEventPeopleModel taggedPersonOption = taggedPeople;
      taggedPeopleOption.add(taggedPersonOption);
    }

    var crew = taggedPeopleOption
        .where((taggedPerson) =>
            taggedPerson.taggedType == 'performer' ||
            taggedPerson.taggedType == 'crew')
        .toList();

    var sponsor = taggedPeopleOption
        .where((taggedPerson) =>
            taggedPerson.taggedType == 'Partner' ||
            taggedPerson.taggedType == 'Sponsor')
        .toList();
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(children: [
        if (widget.event.taggedPeople.isNotEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (crew.isNotEmpty)
                Center(
                  child: Text(
                    "Performers and Crew",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              if (crew.isNotEmpty)
                const SizedBox(
                  height: 10,
                ),
              if (crew.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(
                      ResponsiveHelper.responsiveWidth(context, 2)),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                  child: ShedulePeopleHorizontal(
                    event: widget.event,
                    edit: false,
                    from: '',
                    schedulepeople: crew,
                    currentUserId: widget.currentUserId, fromDetails: true,
                    isSponsor: false,
                    // isSponsor: false,
                  ),
                ),
              if (crew.isNotEmpty)
                const SizedBox(
                  height: 40,
                ),
              if (sponsor.isNotEmpty)
                Center(
                  child: Text(
                    "Partners and Sponsers",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              if (sponsor.isNotEmpty)
                const SizedBox(
                  height: 10,
                ),
              if (sponsor.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(
                      ResponsiveHelper.responsiveWidth(context, 2)),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                  child: ShedulePeopleHorizontal(
                    edit: false, fromDetails: true,
                    from: '',
                    schedulepeople: sponsor,
                    currentUserId: widget.currentUserId,
                    // isSponsor: true,
                    event: widget.event, isSponsor: true,
                  ),
                ),
              const SizedBox(
                height: 30,
              ),
            ],
          )
      ]),
    );
  }

  void _showBottomSheetExternalLink() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 550),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: WebDisclaimer(
              link: widget.event.ticketSite,
              contentType: 'Event ticket',
              icon: Icons.link,
            ));
      },
    );
  }

  _eventDetails() {
    final width = MediaQuery.of(context).size.width;
    bool _isAuthor = widget.currentUserId == widget.event.authorId;
    bool _showAffiliate = widget.event.isAffiliateEnabled &&
        !widget.event.isAffiliateExclusive &&
        !_isAuthor;

    List<Schedule> scheduleOptions = [];

    for (Schedule schedule in widget.event.schedule) {
      scheduleOptions.add(schedule);
    }
    scheduleOptions.sort(
        (a, b) => a.scheduleDate.toDate().compareTo(b.scheduleDate.toDate()));

    DateTime _scheduleFirsttDay = scheduleOptions.first.scheduleDate.toDate();
    DateTime _scheduleLastDay = scheduleOptions.last.scheduleDate.toDate();
    DateTime _startDay = widget.event.startDate.toDate();
    DateTime _astDay = widget.event.clossingDay.toDate();

    DateTime _calendarFirstDay =
        _startDay.isBefore(_scheduleFirsttDay) ? _startDay : _scheduleFirsttDay;

    DateTime _calendarLastDay =
        _astDay.isAfter(_scheduleLastDay) ? _astDay : _scheduleLastDay;

    DateTime _focusedDay =
        _startDay.isBefore(_scheduleFirsttDay) ? _startDay : _scheduleFirsttDay;

    Map<DateTime, List<Schedule>> _sheduleDates = convertToMap(scheduleOptions);
    var blueTextStyle = TextStyle(
        color: Colors.blue,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14));
    var greyTextStyle = TextStyle(
        color: Colors.blueGrey,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14));

    return ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Theme.of(context).secondaryHeaderColor,
              size: ResponsiveHelper.responsiveFontSize(context, 25),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Center(
          child: ShakeTransition(
            child: Text(
              widget.event.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.responsiveWidth(context, 5)),
          child: Center(
            child: ShakeTransition(
              axis: Axis.vertical,
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${widget.event.theme}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (widget.event.dressCode.isNotEmpty)
                      TextSpan(
                        text: "\nDress code: ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    if (widget.event.dressCode.isNotEmpty)
                      TextSpan(
                        text: " ${widget.event.dressCode}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        widget.event.startDate == null
            ? const SizedBox.shrink()
            : Container(
                height: ResponsiveHelper.responsiveHeight(context, 570),
                color: Theme.of(context).cardColor,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(
                          ResponsiveHelper.responsiveWidth(context, 5)),
                      height: ResponsiveHelper.responsiveHeight(context, 350.0),
                      width: width.toDouble(),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TableCalendar(
                        eventLoader: (day) {
                          DateTime normalizedDay =
                              DateTime(day.year, day.month, day.day);

                          return _sheduleDates[normalizedDay] ?? [];
                        },
                        pageAnimationCurve: Curves.easeInOut,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarFormat: CalendarFormat.month,
                        availableGestures: AvailableGestures.horizontalSwipe,
                        rowHeight:
                            ResponsiveHelper.responsiveHeight(context, 40.0),
                        daysOfWeekHeight:
                            ResponsiveHelper.responsiveHeight(context, 30),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          defaultTextStyle: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          markerDecoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          holidayTextStyle: TextStyle(color: Colors.red),
                          outsideDaysVisible: true,
                        ),
                        headerStyle: HeaderStyle(
                          titleTextStyle: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14),
                          ),
                          formatButtonDecoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          formatButtonVisible: false,
                          formatButtonTextStyle: TextStyle(color: Colors.white),
                          formatButtonShowsNext: false,
                        ),
                        firstDay: _calendarFirstDay,
                        focusedDay: _focusedDay,
                        lastDay: _calendarLastDay,
                        onDaySelected: (selectedDay, focusedDay) {
                          DateTime normalizedDay = DateTime(selectedDay.year,
                              selectedDay.month, selectedDay.day);
                          List<Schedule> selectedEvents =
                              _sheduleDates[normalizedDay] ?? [];
                          HapticFeedback.mediumImpact();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return Container(
                                height: ResponsiveHelper.responsiveHeight(
                                    context,
                                    selectedEvents.isEmpty ? 700 : 800),
                                width: ResponsiveHelper.responsiveHeight(
                                    context, 400),
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(20),
                                child: selectedEvents.isEmpty
                                    ? Column(
                                        children: [
                                          _scheduleTitle(selectedDay),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: ResponsiveHelper
                                                    .responsiveHeight(
                                                        context, 100)),
                                            child: NoContents(
                                                textColor: Colors.white,
                                                title: 'No Schedules',
                                                subTitle:
                                                    'The event organizer didn\'t provide schedules for this date. If you want to know more about the schedules and program lineup, you can contact the organizer',
                                                icon:
                                                    Icons.watch_later_outlined),
                                          ),
                                        ],
                                      )
                                    : Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: ResponsiveHelper
                                                    .responsiveFontSize(
                                                        context, 100)),
                                            child: ListView(
                                                // mainAxisSize: MainAxisSize.min,
                                                children: selectedEvents
                                                    .map((schedule) =>
                                                        ScheduleWidget(
                                                          schedule: schedule,
                                                          edit: false,
                                                          from: 'Calendar',
                                                          currentUserId: widget
                                                              .currentUserId,
                                                        ))
                                                    .toList()),
                                          ),
                                          Positioned(
                                            top: 50,
                                            child: _scheduleTitle(selectedDay),
                                          ),
                                        ],
                                      ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    EventDateInfo(
                      duration: duratoinDuringStartingToEndingDate,
                      endDate: widget.event.clossingDay.toDate(),
                      startDate: widget.event.startDate.toDate(),
                    ),
                  ],
                ),
              ),
        SizedBox(
          height: 50,
        ),
        _sponsorAndPartner(),
        const SizedBox(
          height: 50,
        ),
        GestureDetector(
          onTap: _launchMap,
          child: RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "This event would take place at ${widget.event.venue}: ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: widget.event.address,
                  style: blueTextStyle,
                ),
                TextSpan(
                  text:
                      '\nTap on the red location icon to launh map for venue direction.\nDouble tap on map to zoom in. ',
                  style: greyTextStyle,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        _googleMapDisplay(),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BottomModelSheetListTileActionWidget(
                colorCode: 'Blue',
                dontPop: true,
                icon: Icons.schedule_outlined,
                onPressed: () {
                  _showBottomSheetSchedules(context);
                },
                text: 'See full program lineup (Schedule)',
              ),
              if (widget.event.previousEvent.isNotEmpty)
                BottomModelSheetListTileActionWidget(
                  colorCode: 'Blue',
                  dontPop: true,
                  icon: Icons.play_circle_fill_rounded,
                  onPressed: () {
                    _showBottomSheetPreviosEvent(context);
                  },
                  text: 'Watch previous event',
                ),
              BottomModelSheetListTileActionWidget(
                colorCode: 'Blue',
                dontPop: true,
                icon: Icons.question_mark_rounded,
                onPressed: () {
                  _showBottomSheetAskMore(context);
                },
                text: 'Ask questions',
              ),
              BottomModelSheetListTileActionWidget(
                colorCode: 'Blue',
                dontPop: true,
                icon: Icons.qr_code_2_sharp,
                onPressed: () {
                  _navigateToPage(
                    context,
                    ExpandEventBarcodeScreen(
                      event: widget.event,
                    ),
                  );
                },
                text: 'Share Qr code',
              ),
              BottomModelSheetListTileActionWidget(
                colorCode: 'Blue',
                dontPop: true,
                icon: Icons.account_circle,
                onPressed: () {
                  _navigateToPage(
                      context,
                      ProfileScreen(
                        user: null,
                        currentUserId: widget.currentUserId,
                        userId: widget.event.authorId,
                      ));
                },
                text: 'See publisher',
              ),
              BottomModelSheetListTileActionWidget(
                dontPop: true,
                colorCode: 'Blue',
                icon: Icons.call_outlined,
                onPressed: () {
                  _showBottomSheetContactOrganizer(context);
                },
                text: 'Call organizer',
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        if (!widget.event.isPrivate && !_isAuthor)
          if (!_eventHasEnded)
            Column(
              children: [
                Divider(
                  thickness: .3,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Tickets',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 50,
                ),
                widget.event.ticketSite.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: BottomModelSheetListTileActionWidget(
                          dontPop: true,
                          colorCode: 'Blue',
                          icon: Icons.payment,
                          onPressed: () {
                            _showBottomSheetExternalLink();
                          },
                          text: 'Get ticket from website',
                        ),
                      )
                    : Container(
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.only(top: 20),
                        child: TicketGroup(
                          currentUserId: widget.currentUserId,
                          groupTickets: widget.event.ticket,
                          event: widget.event,
                          inviteReply: '',
                          onInvite: false,
                          // marketedAffiliateId: widget.marketedAffiliateId,
                        ),
                      ),
              ],
            ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  void _showBottomSheetContactOrganizer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 700),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.horizontal_rule,
                color: Theme.of(context).secondaryHeaderColor,
                size: ResponsiveHelper.responsiveHeight(context, 30.0),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DisclaimerWidget(
                        title: 'Call Organizer',
                        subTitle:
                            'These are the contacts provided by this event\'s organizers. While we make efforts to gather the contact information, we cannot guarantee that these are the exact and correct contacts. Therefore, we advise you to conduct additional research and verify these contact details  independently.',
                        icon: Icons.call,
                      ),
                      const SizedBox(height: 40),
                      EventOrganizerContactWidget(
                        portfolios: widget.event.contacts,
                        edit: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// //display schedules and programe line ups
  void _showBottomSheetSchedules(BuildContext context) {
    List<Schedule> shedules = widget.event.schedule;
    List<Schedule> scheduleOptions = [];
    for (Schedule shedules in shedules) {
      Schedule sheduleOption = shedules;
      scheduleOptions.add(sheduleOption);
    }
    scheduleOptions
        .sort((a, b) => a.startTime.toDate().compareTo(b.startTime.toDate()));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return widget.event.schedule.isEmpty
            ? NoScheduleCalendar(
                showAskMore: true,
                askMoreOnpressed: () {
                  Navigator.pop(context);
                  _showBottomSheetAskMore(context);
                },
              )
            : Stack(
                children: [
                  Container(
                    height: ResponsiveHelper.responsiveHeight(context, 800),
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(top: 50),
                    child: Container(
                      padding: const EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ScheduleGroup(
                        from: 'Schedule',
                        schedules: widget.event.schedule,
                        isEditing: false,
                        eventOrganiserId: widget.event.authorId,
                        currentUserId: widget.currentUserId,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: TicketPurchasingIcon(
                      onlyWhite: true,
                      title: '',
                    ),
                  ),
                ],
              );
      },
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

//build ask question display
  _buildAsk(
    Ask ask,
  ) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
        child: DisplayAskAndReply(
          ask: ask,
          event: widget.event,
        ));
  }

  void _showBottomSheetErrorMessage(String title, String subTitle) {
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
          title: title,
          subTitle: subTitle,
        );
      },
    );
  }

  _buildAskTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return CommentContentField(
      controller: _askController,
      onSend: () {
        HapticFeedback.mediumImpact();

        final trimmedText = _askController.text.trim();
        if (trimmedText.isNotEmpty) {
          try {
            final currentUser =
                Provider.of<UserData>(context, listen: false).user!;
            DatabaseService.askAboutEvent(
              currentUserId: currentUserId!,
              user: currentUser,
              event: widget.event,
              reportConfirmed: '',
              ask: trimmedText,
            );
            _askController.clear();
          } catch (e) {
            _showBottomSheetErrorMessage('Failed to send question.',
                'Please check your internet connection and try again.');
          }
        }
      },
      hintText: 'Interested? Ask more...',
    );
  }

  //Ask more bottom model sheet to handle and display questions
  void _showBottomSheetAskMore(BuildContext context) async {
    bool _isAuthor = widget.currentUserId == widget.event.authorId;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ValueListenableBuilder(
          valueListenable: _isTypingNotifier,
          builder: (BuildContext context, bool isTyping, Widget? child) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                height: ResponsiveHelper.responsiveHeight(context, 630),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TicketPurchasingIcon(
                        title: '',
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: StreamBuilder(
                          stream: asksRef
                              .doc(widget.event.id)
                              .collection('eventAsks')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                height: ResponsiveHelper.responsiveHeight(
                                    context, 630),
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.blue,
                                )),
                              );
                            }
                            return snapshot.data.docs.length == 0
                                ? Container(
                                    height: ResponsiveHelper.responsiveHeight(
                                        context, 630),
                                    child: Center(
                                      child: NoContents(
                                        icon: (FontAwesomeIcons.question),
                                        title:
                                            '\nNo questions have been asked about this event yet.\n',
                                        subTitle: _isAuthor
                                            ? 'Questions asked about this event would appear here so you can answer them and provide more clarifications'
                                            : ' You can be the first to ask a question or share your thoughts and excitement about this upcoming event. Engage with others and make the event experience even more interactive!',
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: ResponsiveHelper.responsiveHeight(
                                        context, 630),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Scrollbar(
                                        child: CustomScrollView(
                                          slivers: [
                                            SliverList(
                                              delegate:
                                                  SliverChildBuilderDelegate(
                                                (context, index) {
                                                  Ask ask = Ask.fromDoc(snapshot
                                                      .data.docs[index]);
                                                  return _buildAsk(ask);
                                                },
                                                childCount:
                                                    snapshot.data.docs.length,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                      _buildAskTF(),
                      SizedBox(
                        height:
                            ResponsiveHelper.responsiveHeight(context, 20.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// icon widgets for location, people tagged and more
  _accessIcons(IconData icon, VoidCallback onPressed) {
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 35.0),
      width: ResponsiveHelper.responsiveHeight(context, 35.0),
      decoration: BoxDecoration(
          color: widget.event.previousEvent.isEmpty
              ? Colors.transparent
              : Colors.white.withOpacity(.2),
          borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        onTap: onPressed,
        child: Icon(
          icon,
          size: ResponsiveHelper.responsiveHeight(context, 30.0),
          color: Colors.white,
        ),
      ),
    );
  }

  List<String> usernames = <String>[
    "Artist",
    "Producer",
    "DJ",
    "Dancer",
    "Music_Video_Director",
    "Content_creator",
    "Photographer",
    "Record_Label",
    "Brand_Influencer",
    "Event_organiser",
    "Band",
    "Instrumentalist",
    "Cover_Art_Designer",
    "Makeup_Artist",
    "Video_Vixen",
    "Blogger",
    "MC(Host)",
    "Choire",
    "Battle_Rapper",
    "Fan",
  ];

  _toRoom(PaletteGenerator palette) async {
    EventRoom? room = await DatabaseService.getEventRoomWithId(widget.event.id);
    TicketIdModel? ticketId = await DatabaseService.getTicketIdWithId(
        widget.event.id, widget.currentUserId);

    if (room != null) {
      _navigateToPage(
          context,
          EventRoomScreen(
            currentUserId: widget.currentUserId,
            room: room,
            palette: palette,
            ticketId: ticketId!,
          ));
    } else {
      _showBottomSheetErrorMessage('Failed to get event room.',
          'Please check your internet connection and try again.');
    }
  }

  _goToRoom(PaletteGenerator palette) async {
    try {
      if (_isLoading) return;
      _isLoading = true;

      _toRoom(palette);
    } catch (e) {
      _showBottomSheetErrorMessage('Failed to get event room.',
          'Please check your internet connection and try again.');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _generatePalette(isDashBoard) async {
    if (_isLoading) return;
    if (_isLoadingDashboard) return;

    isDashBoard
        ? setState(() {
            _isLoadingDashboard = true;
          })
        : setState(() {
            _isLoading = true;
          });
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(widget.event.imageUrl),
      size: Size(1110, 150),
      maximumColorCount: 20,
    );

    isDashBoard
        ? setState(() {
            _isLoadingDashboard = false;
          })
        : setState(() {
            _isLoading = false;
          });
    isDashBoard
        ? _navigateToPage(
            context,
            EventDashboardScreen(
              currentUserId: widget.currentUserId,
              event: widget.event,
              palette: _paletteGenerator,
            ))
        : _goToRoom(_paletteGenerator);
  }

  _inviteonSummaryButton(
    String buttonText,
    VoidCallback onPressed,
  ) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          foregroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
          ),
          textAlign: TextAlign.center,
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _showBottomInvitationMessage() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SendInviteMessage(
            currentUserId: widget.currentUserId,
            event: widget.event,
          );
        });
  }

  void _showBottomSheetCreateAffiliate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: CreateAffiliate(
                event: widget.event,
                currentUserId: widget.currentUserId,
                paletteColor: widget.palette!,
              ));
        });
      },
    );
  }

  void _showBottomSheetRefund(bool isRefund) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: AffiliateDoc(
                isAffiliated: widget.event.isAffiliateEnabled,
                isOganiser: true,
                affiliateOnPressed: () {
                  Navigator.pop(context);
                  _showBottomSheetCreateAffiliate();
                },
              ));
        });
      },
    );
  }

  _resourceSummaryInfo() {
    final width = MediaQuery.of(context).size.width;
    var _provider = Provider.of<UserData>(context, listen: false);
    bool _noResources = !widget.event.isFree &&
        !widget.event.isCashPayment &&
        widget.event.ticketSite.isNotEmpty;

    return new Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          width: width,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(10, 10),
                  blurRadius: 10.0,
                  spreadRadius: 4.0,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                ShakeTransition(
                  duration: const Duration(seconds: 2),
                  child: Center(
                    child: Icon(
                      Icons.done,
                      size: ResponsiveHelper.responsiveHeight(context, 50.0),
                      color: Colors.grey,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Successful',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 40.0),
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Colors.grey,
                  thickness: .3,
                ),
                const SizedBox(
                  height: 30,
                ),
                if (_provider.user != null)
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Dear  ${_provider.user!.userName} \n',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              'Your event: ${widget.event.title}, has been created successfully.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 40,
                ),
                RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Your \nExperience',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 20.0),
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      TextSpan(
                        text:
                            '\nWe prioritize providing an exceptional experience that will benefit you in managing this event. We are thrilled to support you throughout the event management process. As an organizer, you have access to a comprehensive set of resources to help you manage the event and engage with attendees effectively.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _navigateToPage(
                      context,
                      DiscoverUser(
                        currentUserId: widget.currentUserId,
                        // userLocationSettings:
                        //     _provider.userLocationPreference!,
                        isLiveLocation: true,
                        liveCity: widget.event.city,
                        liveCountry: widget.event.city,
                        liveLocationIntialPage: 0, isWelcome: false,
                        // sortNumberOfDays: 0,
                      ),
                    );
                  },
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\n\nBook a creative.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              '\nEnhance your event experience by booking a professional who can provide that extra special touch. We have a diverse selection of talented creatives available, perfectly suited for your event. Our creatives are sorted based on your event location (${widget.event.city}), ensuring a seamless fit for your specific needs.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: '\nBook a creative.',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!_noResources)
                  GestureDetector(
                    onTap: () {
                      widget.justCreated || widget.palette != null
                          ? _navigateToPage(
                              context,
                              EventDashboardScreen(
                                // askCount: 0,
                                currentUserId: widget.currentUserId,
                                event: widget.event,
                                palette: widget.palette!,
                              ))
                          : _generatePalette(true);
                    },
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\n\nEvent Dashboard.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text:
                                '\nThe Event Dashboard is designed to assist you in managing attendees for this event. Within the dashboard, you\'ll find various tools that enable you to send invitations to potential attendees, monitor the number of expected attendees, and scan attendee tickets for validation',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: '\nAccess dashboard.',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!_noResources)
                  GestureDetector(
                    onTap: () {
                      widget.justCreated || widget.palette == null
                          ? _goToRoom(widget.palette!)
                          : _generatePalette(false);
                    },
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\n\nEvent Room',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text:
                                '\nAn event room fosters networking and interaction among attendees of a specific event. It creates a dedicated group for all event attendees to chat and connect with each other.  ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: '\nAccess room.',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!_noResources)
                  if (!widget.event.isFree && !widget.event.isCashPayment)
                    GestureDetector(
                      onTap: () {
                        _showBottomSheetRefund(false);
                      },
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\n\nAffiliate marketers',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text:
                                  '\nThis will allow affiliates to promote your event and earn a commission on any ticket sales generated through their unique affiliate links.  ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextSpan(
                              text: '\nLearn more.',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                if (!_noResources)
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\n\nReminders',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              '\nSeven days prior to the event, we will send daily reminders to attendees to ensure that they don\'t forget about the events.\n',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: '\n\nEvent Barcode',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              '\nThe event barcode makes it convenient for you to share this event with others. Simply take a screenshot of the barcode and place it at your desired location. Potential attendees can then scan the barcode to gain access to the event. It\'s a hassle-free way to promote and provide easy entry to the event.  ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 50,
                ),
                Hero(
                  tag: 'new ${widget.event.id}',
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _navigateToPage(
                        context,
                        ExpandEventBarcodeScreen(
                          justCreated: true,
                          event: widget.event,
                        ),
                      );
                    },
                    child: Center(
                      child: QrImageView(
                        version: QrVersions.auto,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.blue,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: Colors.blue,
                        ),
                        backgroundColor: Colors.transparent,
                        data: widget.event.dynamicLink,
                        size: ResponsiveHelper.responsiveHeight(context, 200.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                _inviteonSummaryButton(
                  'Send Invite',
                  () async {
                    _showBottomInvitationMessage();
                  },
                ),
                _inviteonSummaryButton(
                  'Share link',
                  () async {
                    Share.share(widget.event.dynamicLink);
                  },
                ),
                _inviteonSummaryButton(
                  'Send to chats',
                  () {
                    _navigateToPage(
                        context,
                        SendToChats(
                          currentUserId: widget.currentUserId,
                          sendContentType: 'Event',
                          sendContentId: widget.event.id,
                          sendImageUrl: widget.event.imageUrl,
                          sendTitle: widget.event.title,
                        ));
                  },
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _barCode() {
    return Hero(
      tag: widget.event.id,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _navigateToPage(
            context,
            ExpandEventBarcodeScreen(
              event: widget.event,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: QrImageView(
            version: QrVersions.auto,
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            data: widget.event.dynamicLink,
            size: ResponsiveHelper.responsiveHeight(context, 40.0),
          ),
        ),
      ),
    );
  }

  void _showBottomSheetTicketDoc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 700),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  const SizedBox(height: 40),
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Private Event.',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text:
                              "\n\nThis event is exclusive and access to event tickets is restricted to a select group of individuals.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  Icon(
                    Icons.lock,
                    color: Theme.of(context).primaryColorLight,
                    size: ResponsiveHelper.responsiveHeight(context, 60.0),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  _showDetails() {
    bool _isAuthor = widget.currentUserId == widget.event.authorId;
    widget.showPrivateEvent
        ? _expandEventDetails()
        : widget.event.isPrivate && !_isAuthor
            ? _showBottomSheetTicketDoc()
            : widget.event.isPrivate && _isAuthor
                ? _expandEventDetails()
                : _expandEventDetails();
    ;
  }

  _contentWidget() {
    bool _isAuthor = widget.currentUserId == widget.event.authorId;
    final List<String> datePartition = widget.event.startDate == null
        ? MyDateFormat.toDate(DateTime.now()).split(" ")
        : MyDateFormat.toDate(widget.event.startDate.toDate()).split(" ");
    final List<String> timePartition = _fristScheduleTime == null
        ? MyDateFormat.toTime(DateTime.now()).split(" ")
        : MyDateFormat.toTime(_fristScheduleTime.toDate()).split(" ");
    final List<String> namePartition =
        widget.event.title.trim().replaceAll('\n', ' ').split(" ");
    var _titleStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 30.0),
      color: lightVibrantColor,
      fontWeight: FontWeight.bold,
    );
    var _dateAndTimeSmallStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      color: Colors.white,
      decoration:
          _eventHasEnded ? TextDecoration.lineThrough : TextDecoration.none,
    );
    var _dateAndTimeLargeStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
      color: Colors.white,
      fontWeight: FontWeight.bold,
      decoration:
          _eventHasEnded ? TextDecoration.lineThrough : TextDecoration.none,
    );

    var _provider = Provider.of<UserData>(
      context,
    );
    var _usercountry = _provider.userLocationPreference!.country;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isAuthor)
              Padding(
                padding: EdgeInsets.only(
                    bottom: widget.justCreated ? 100.0 : 30, top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BottomModelSheetIconActionWidget(
                            minor: true,
                            dontPop: true,
                            textcolor: _isLoadingDashboard ? Colors.blue : null,
                            icon: Icons.dashboard_outlined,
                            onPressed: () {
                              widget.palette == null
                                  ? _generatePalette(true)
                                  : _navigateToPage(
                                      context,
                                      EventDashboardScreen(
                                        currentUserId: widget.currentUserId,
                                        event: widget.event,
                                        palette: widget.palette!,
                                      ));
                            },
                            text:
                                _isLoadingDashboard ? 'Loading...' : 'Dashbord',
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey,
                          ),
                          BottomModelSheetIconActionWidget(
                            minor: true,
                            dontPop: true,
                            textcolor: _isLoading ? Colors.blue : null,
                            icon: MdiIcons.thoughtBubbleOutline,
                            onPressed: () async {
                              widget.palette == null
                                  ? _generatePalette(false)
                                  : _goToRoom(widget.palette!);
                            },
                            text: _isLoading ? 'Loading...' : 'Room',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BottomModelSheetIconActionWidget(
                            minor: true,
                            dontPop: true,
                            icon: Icons.edit_outlined,
                            onPressed: () {
                              _navigateToPage(
                                context,
                                EditEventScreen(
                                  currentUserId: widget.currentUserId,
                                  event: widget.event,
                                  isCompleted: _eventHasEnded,
                                ),
                              );
                            },
                            text: 'Edit',
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey,
                          ),
                          BottomModelSheetIconActionWidget(
                            minor: true,
                            dontPop: true,
                            icon: Icons.call_outlined,
                            onPressed: () async {
                              _navigateToPage(
                                context,
                                DiscoverUser(
                                  currentUserId: widget.currentUserId,
                                  isLiveLocation: true,
                                  liveCity: widget.event.city,
                                  liveCountry: widget.event.country,
                                  liveLocationIntialPage: 0,
                                  isWelcome: false,
                                ),
                              );
                            },
                            text: 'Book creative',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            GestureDetector(
              onTap: () {
                _showDetails();
              },
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: namePartition[0].toUpperCase(),
                      style: _titleStyle,
                    ),
                    if (namePartition.length > 1)
                      TextSpan(
                          text: "\n${namePartition[1].toUpperCase()} ",
                          style: _titleStyle),
                    if (namePartition.length > 2)
                      TextSpan(
                          text: "\n${namePartition[2].toUpperCase()} ",
                          style: _titleStyle),
                    if (namePartition.length > 3)
                      TextSpan(
                          text: "${namePartition[3].toUpperCase()} ",
                          style: _titleStyle),
                    if (namePartition.length > 4)
                      TextSpan(
                          text: "${namePartition[4].toUpperCase()} ",
                          style: _titleStyle),
                    if (namePartition.length > 5)
                      TextSpan(
                          text: "${namePartition[5].toUpperCase()} ",
                          style: _titleStyle),
                    if (namePartition.length > 6)
                      TextSpan(
                          text: "${namePartition[6].toUpperCase()} ",
                          style: _titleStyle),
                    if (namePartition.length > 7)
                      TextSpan(
                          text: "${namePartition[7].toUpperCase()} ",
                          style: _titleStyle),
                    if (namePartition.length > 8)
                      TextSpan(
                          text: "${namePartition[8].toUpperCase()} ",
                          style: _titleStyle),
                    if (namePartition.length > 9)
                      TextSpan(
                          text: "${namePartition[9].toUpperCase()} ",
                          style: _titleStyle),
                    if (namePartition.length > 10)
                      TextSpan(
                          text: "${namePartition[10].toUpperCase()} ",
                          style: _titleStyle),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.responsiveWidth(context, 10.0),
            ),
            GestureDetector(
              onTap: () {
                _showDetails();
              },
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  _isAuthor
                      ? "${widget.event.theme.trim().replaceAll('\n', ' ')}"
                      : "${widget.event.theme.trim().replaceAll('\n', ' ')}. \nThis event would take place at ${widget.event.venue} ",
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 16.0),
                    color: Colors.white,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveHelper.responsiveWidth(context, 20.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _showDetails();
              },
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: datePartition[0].toUpperCase(),
                        style: _dateAndTimeSmallStyle),
                    if (datePartition.length > 1)
                      TextSpan(
                          text: "\n${datePartition[1].toUpperCase()} ",
                          style: _dateAndTimeSmallStyle),
                    if (datePartition.length > 2)
                      TextSpan(
                          text: "\n${datePartition[2].toUpperCase()} ",
                          style: _dateAndTimeLargeStyle),
                  ],
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 50,
                width: 1,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showDetails();
              },
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: timePartition[0].toUpperCase(),
                        style: _dateAndTimeLargeStyle),
                    if (timePartition.length > 1)
                      TextSpan(
                          text: "\n${timePartition[1].toUpperCase()} ",
                          style: _dateAndTimeSmallStyle),
                    if (timePartition.length > 2)
                      TextSpan(
                          text: "\n${timePartition[2].toUpperCase()} ",
                          style: _dateAndTimeSmallStyle),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        widget.event.isPrivate
            ? widget.showPrivateEvent
                ? AttendButton(
                    marketedAffiliateId: widget.marketedAffiliateId,
                    fromFlyier: true,
                    currentUserId: widget.currentUserId,
                    event: widget.event,
                  )
                : SizedBox.shrink()
            : !_eventHasEnded && !_isAuthor
                ? AttendButton(
                    marketedAffiliateId: widget.marketedAffiliateId,
                    fromFlyier: true,
                    currentUserId: widget.currentUserId,
                    event: widget.event,
                  )
                : SizedBox.shrink(),
        SizedBox(
          height: 5,
        ),
        Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Container(
              width: ResponsiveHelper.responsiveWidth(context, 150.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: BorderSide(width: 1.0, color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _isAuthor ? 'Questions' : 'Ask more',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                    ),
                  ),
                ),
                onPressed: () {
                  _showBottomSheetAskMore(context);
                },
              ),
            )),
        SizedBox(
          height: 10,
        ),

        if (!_isAuthor)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.event.previousEvent.isNotEmpty)
                  _accessIcons(
                    Icons.play_circle_outline_rounded,
                    () {
                      _showBottomSheetPreviosEvent(context);
                    },
                  ),
                if (widget.event.previousEvent.isNotEmpty)
                  const SizedBox(
                    width: 5,
                  ),
                _accessIcons(
                  Icons.location_on,
                  _launchMap,
                ),
              ],
            ),
          ),
        if (!_eventHasEnded)
          if (_isAuthor) _barCode(),
        // !widget.event.isPrivate
        //     ? _barCode()
        //     : widget.event.isPrivate && _isAuthor
        //         ? _barCode()
        //         : SizedBox.shrink(),
        SizedBox(
          height: 10,
        ),
        if (!_isAuthor)
          CountdownTimer(
            split: 'Single',
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            color: Colors.white,
            clossingDay: DateTime.now(),
            startDate: widget.event.startDate.toDate(),
            eventHasEnded: _eventHasEnded,
            eventHasStarted: _eventHasStarted,
            big: true,
          ),
        if (!widget.event.isPrivate && !_isAuthor)
          if (!_eventHasEnded)
            widget.event.ticketSite.isNotEmpty
                ? Icon(
                    Icons.link,
                    color: Colors.white,
                    size: ResponsiveHelper.responsiveHeight(context, 30.0),
                  )
                : RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.event.isFree
                              ? ''
                              : "${widget.event.rate}:\n",
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.event.isFree
                              ? 'Free'
                              : _fristTickePrice.toString(),
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 30.0),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
        if (widget.event.isPrivate && !_isAuthor)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () {
                _showBottomSheetTicketDoc();
              },
              child: Icon(
                Icons.lock,
                color: Colors.white,
                size: ResponsiveHelper.responsiveHeight(context, 30.0),
              ),
            ),
          ),
        if (_isAuthor && _eventHasEnded)
          Text(
            'Completed',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
              color: Colors.white,
            ),
          ),
        // if (!_isAuthor)
        //   Text(
        //     widget.event.type,
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
        //       color: Colors.white,
        //       fontFamily: 'Bessita',
        //     ),
        //   ),
        // if (!widget.event.isPrivate && !_isAuthor)
        if (widget.event.taggedPeople.isNotEmpty)
          ShedulePeopleHorizontal(
            event: widget.event,
            edit: false,
            from: '',
            schedulepeople: widget.event.taggedPeople,
            currentUserId: widget.currentUserId,
            fromDetails: false,
            // isSponsor: false,
          ),
      ],
    );
  }

  _eventInfoBody() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: widget.justCreated
            ? ListView(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  _resourceSummaryInfo(),
                  _contentWidget(),
                  const SizedBox(
                    height: 200,
                  ),
                ],
              )
            : _contentWidget());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: _displayImage ? false : true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          _displayImage ? 'Tagged people' : '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
            color: Colors.white,
          ),
        ),
        actions: [
          _displayImage || _displayReportWarning
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: ResponsiveHelper.responsiveHeight(context, 30.0),
                  ),
                ),
        ],
      ),
      body: Stack(
        alignment: FractionalOffset.center,
        children: <Widget>[
          Container(
            height: height,
            width: double.infinity,
            child: BlurHash(
              hash: widget.event.blurHash.isEmpty
                  ? 'LpQ0aNRkM{M{~qWBayWB4nofj[j['
                  : widget.event.blurHash,
              imageFit: BoxFit.cover,
            ),
          ),
          GestureDetector(
              onLongPress: _setImage,
              onTap: () {
                () {
                  _showDetails();
                };
              },
              child: Container(
                height: height,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.event.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.6),
                          Colors.black.withOpacity(.6),
                        ],
                      ),
                    ),
                    child: !_displayImage
                        ? SizedBox.shrink()
                        : EventTaggedPeople(
                            event: widget.event,
                            isSponsor: false,
                            showTagsOnImage: true,
                          )),
              )),
          _displayReportWarning
              ? ContentWarning(
                  imageUrl: widget.event.imageUrl,
                  onPressed: () {
                    _setContentWarning();
                  },
                  report: widget.event.report,
                )
              : _displayImage
                  ? SizedBox.shrink()
                  : _eventInfoBody(),
        ],
      ),
    );
  }
}
