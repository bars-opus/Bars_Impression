import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class EventDashboard extends StatefulWidget {
  final Event event;
  final String currentUserId;
  final PaletteGenerator palette;
  final int askCount;

  EventDashboard({
    required this.event,
    required this.currentUserId,
    required this.palette,
    required this.askCount,
  });

  @override
  _EventDashboardState createState() => _EventDashboardState();
}

class _EventDashboardState extends State<EventDashboard> {
  int _attendeeRequesCount = 0;
  int _different = 0;
  int _attendeeAcceptedCount = 0;
  int _attendeeRejectedCount = 0;
  int _attendeeUnAnswered = 0;
  int _inviteCount = 0;
  int _inviteAcceptedCount = 0;
  int _inviteRejectedCount = 0;
  int _inviteUnAnswered = 0;
  int _attendeesValidated = 0;
  // late DateTime _closingdate;

  late DateTime _toDaysDate;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _setUpAttendeeRequest();
    _setUpEventInvites();
    _setUpAttendeeAccepted();
    _setUpAttendeeRejected();
    _setUpAttendeeUnAnswered();
    _setUpInviteAccepted();
    _setUpInviteRejected();
    _setUpInviteUnAnswered();
    widget.event.isPrivate
        ? _setUpAttendeesValidatedPrivate()
        : _setUpAttendeesValidatedPublic();
    _countDown();
  }

  _countDown() async {
    DateTime date = DateTime.parse(widget.event.date);
    final toDayDate = DateTime.now();
    var different = date.difference(toDayDate).inDays;
    // DateTime closingdate = DateTime.parse(widget.event.clossingDay);

    setState(() {
      _different = different;
      _toDaysDate = toDayDate;
      // _closingdate = closingdate;

      _date = date;
    });
  }

  _setUpAttendeeRequest() async {
    DatabaseService.numEventAttendeeRequest(
      widget.event.id,
    ).listen((requestCount) {
      if (mounted) {
        setState(() {
          _attendeeRequesCount = requestCount;
        });
      }
    });
  }

  _setUpAttendeeUnAnswered() async {
    DatabaseService.numEventAttendee(widget.event.id, '')
        .listen((attendeeUnAnswered) {
      if (mounted) {
        setState(() {
          _attendeeUnAnswered = attendeeUnAnswered;
        });
      }
    });
  }

  _setUpEventInvites() async {
    DatabaseService.numAllEventInvites(
      widget.event.id,
    ).listen((inviteCount) {
      if (mounted) {
        setState(() {
          _inviteCount = inviteCount;
        });
      }
    });
  }

  _setUpAttendeeAccepted() async {
    DatabaseService.numEventAttendee(widget.event.id, 'Accepted')
        .listen((attendeeAcceptedCount) {
      if (mounted) {
        setState(() {
          _attendeeAcceptedCount = attendeeAcceptedCount;
        });
      }
    });
  }

  _setUpAttendeesValidatedPrivate() async {
    DatabaseService.numEventAttendeeValidate(widget.event.id, 'Accepted')
        .listen((attendeesValidatedPrivate) {
      if (mounted) {
        setState(() {
          _attendeesValidated = attendeesValidatedPrivate;
        });
      }
    });
  }

  _setUpAttendeesValidatedPublic() async {
    DatabaseService.numEventAttendeeValidate(widget.event.id, '')
        .listen((attendeesValidatedPublic) {
      if (mounted) {
        setState(() {
          _attendeesValidated = attendeesValidatedPublic;
        });
      }
    });
  }

  _setUpInviteAccepted() async {
    DatabaseService.numEventInvites(widget.event.id, 'Accepted')
        .listen((inviteAcceptedCount) {
      if (mounted) {
        setState(() {
          _inviteAcceptedCount = inviteAcceptedCount;
        });
      }
    });
  }

  _setUpAttendeeRejected() async {
    DatabaseService.numEventAttendee(widget.event.id, 'Rejected')
        .listen((attendeeAcceptedRejected) {
      if (mounted) {
        setState(() {
          _attendeeRejectedCount = attendeeAcceptedRejected;
        });
      }
    });
  }

  _setUpInviteRejected() async {
    DatabaseService.numEventInvites(widget.event.id, 'Rejected')
        .listen((inviteAcceptedRejected) {
      if (mounted) {
        setState(() {
          _inviteRejectedCount = inviteAcceptedRejected;
        });
      }
    });
  }

  _setUpInviteUnAnswered() async {
    DatabaseService.numEventInvites(widget.event.id, '')
        .listen((inviteUnAnswered) {
      if (mounted) {
        setState(() {
          _inviteUnAnswered = inviteUnAnswered;
        });
      }
    });
  }

  _dynamicLink() async {
    final dynamicLinkParams = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Event',
        description: widget.event.title,
      ),
      link: Uri.parse('https://www.barsopus.com/event_${widget.event.id}'),
      uriPrefix: 'https://barsopus.com/barsImpression',
      androidParameters:
          AndroidParameters(packageName: 'com.barsOpus.barsImpression'),
      iosParameters: IOSParameters(
        bundleId: 'com.bars-Opus.barsImpression',
        appStoreId: '1610868894',
      ),
    );
    if (Platform.isIOS) {
      var link =
          await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
      Share.share(link.toString());
    } else {
      var link =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      Share.share(link.shortUrl.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int sum = _attendeeAcceptedCount + _inviteAcceptedCount;
    return ResponsiveScaffold(
        child: Scaffold(
      backgroundColor: widget.palette.darkMutedColor == null
          ? Color(0xFF1a1a1a)
          : widget.palette.darkMutedColor!.color,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: widget.palette.darkMutedColor == null
            ? Color(0xFF1a1a1a)
            : widget.palette.darkMutedColor!.color,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 30),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.event_available,
                      color: widget.palette.darkMutedColor == null
                          ? Color(0xFF1a1a1a)
                          : widget.palette.darkMutedColor!.color,
                      size: 20.0,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Event \nDashboard',
                  style:
                      TextStyle(color: Colors.white, fontSize: 16.0, height: 1),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          _date.subtract(Duration(days: 3)).isBefore(_toDaysDate)
              ? ShakeTransition(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(10, 10),
                              blurRadius: 10.0,
                              spreadRadius: 4.0,
                            )
                          ]),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          Text(
                            'CHECK-IN\nVALIDATOR',
                            style: TextStyle(
                              fontSize: 20,
                              color: widget.palette.darkMutedColor == null
                                  ? Color(0xFF1a1a1a)
                                  : widget.palette.darkMutedColor!.color,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => widget.event.isPrivate
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                EventAttendeesValidated(
                                                  palette: widget.palette,
                                                  event: widget.event,
                                                  from: 'Accepted',
                                                )))
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                EventAttendeesValidated(
                                                  palette: widget.palette,
                                                  event: widget.event,
                                                  from: '',
                                                ))),
                                child: RichText(
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: _attendeesValidated.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              widget.palette.darkMutedColor ==
                                                      null
                                                  ? Color(0xFF1a1a1a)
                                                  : widget.palette
                                                      .darkMutedColor!.color,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nValidated\nAttendees',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              widget.palette.darkMutedColor ==
                                                      null
                                                  ? Color(0xFF1a1a1a)
                                                  : widget.palette
                                                      .darkMutedColor!.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                height: 100,
                                width: 1,
                                color: widget.palette.darkMutedColor == null
                                    ? Color(0xFF1a1a1a)
                                    : widget.palette.darkMutedColor!.color,
                              ),
                              GestureDetector(
                                onTap: () => widget.event.isPrivate
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                EventAttendeesRequested(
                                                  palette: widget.palette,
                                                  event: widget.event,
                                                  answer: 'Accepted',
                                                  showAppBar: true,
                                                  dontShowAnswerWidget: true,
                                                )))
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                EventAttendeesRequested(
                                                  showAppBar: true,
                                                  dontShowAnswerWidget: true,
                                                  palette: widget.palette,
                                                  event: widget.event,
                                                  answer: '',
                                                ))),
                                child: RichText(
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: widget.event.isPrivate
                                            ? sum.toString()
                                            : _attendeeUnAnswered.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              widget.palette.darkMutedColor ==
                                                      null
                                                  ? Color(0xFF1a1a1a)
                                                  : widget.palette
                                                      .darkMutedColor!.color,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nExpected\nAttendees',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              widget.palette.darkMutedColor ==
                                                      null
                                                  ? Color(0xFF1a1a1a)
                                                  : widget.palette
                                                      .darkMutedColor!.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Container(
                              width: width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.blue,
                                  side: BorderSide(
                                    width: 1.0,
                                    color: widget.palette.darkMutedColor == null
                                        ? Color(0xFF1a1a1a)
                                        : widget.palette.darkMutedColor!.color,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 2),
                                  child: Text(
                                    'Validate attendees',
                                    style: TextStyle(
                                      color:
                                          widget.palette.darkMutedColor == null
                                              ? Color(0xFF1a1a1a)
                                              : widget.palette.darkMutedColor!
                                                  .color,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ValidateEventAttendees(
                                                event: widget.event,
                                                palette: widget.palette,
                                                from: widget.event.isPrivate
                                                    ? 'Accepted'
                                                    : '',
                                              )));
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RichText(
                              textScaleFactor: MediaQuery.of(context)
                                  .textScaleFactor
                                  .clamp(0.5, 1.5),
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text:
                                          'Your validator is ready. Your validator helps you validate attendees at the entrance of the event. An attendee\'s number is unique. You must match the attendee\'s number on the ticket of the attendee to the attendee\'s number among the list of this event attendees to see if it correspond.  If the two numbers are equal, you can validate the attendee before they access the event. This helps keep track of the people(attedees) you permit to your event.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          ShakeTransition(
            child: new Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        topLeft: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(10, 10),
                          blurRadius: 10.0,
                          spreadRadius: 4.0,
                        )
                      ]),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, right: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  elevation: 0.0,
                                  onPrimary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                                child: Icon(
                                  Icons.notifications,
                                  color: widget.palette.darkMutedColor == null
                                      ? Color(0xFF1a1a1a)
                                      : widget.palette.darkMutedColor!.color,
                                  size: 30.0,
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EventInvitationNotification(
                                        palette: widget.palette,
                                        event: widget.event,
                                        currentUserId:
                                            Provider.of<UserData>(context)
                                                .currentUserId!,
                                        attendeeRequesCount:
                                            _attendeeUnAnswered,
                                        invitationRespondCount:
                                            _inviteAcceptedCount,
                                      ),
                                    )),
                              ),
                            ),
                            _attendeeUnAnswered == 0
                                ? const SizedBox.shrink()
                                : Positioned(
                                    top: 10,
                                    right: 16,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0)),
                                          color: Colors.red),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                          right: 8,
                                          top: 3,
                                          bottom: 3,
                                        ),
                                        child: Text(
                                          NumberFormat.compact()
                                              .format(_attendeeUnAnswered),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _toDaysDate.isAfter(
                                        DateTime.parse(widget.event.date))
                                    ? 'Ongiong...'
                                    : _different.toString(),
                                style: TextStyle(
                                  fontSize: 50,
                                  color: widget.palette.darkMutedColor == null
                                      ? Color(0xFF1a1a1a)
                                      : widget.palette.darkMutedColor!.color,
                                ),
                              ),
                              TextSpan(
                                text: _toDaysDate.isAfter(
                                        DateTime.parse(widget.event.date))
                                    ? ''
                                    : '\nDays\nMore',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.palette.darkMutedColor == null
                                      ? Color(0xFF1a1a1a)
                                      : widget.palette.darkMutedColor!.color,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: width - 80,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: widget.palette.darkMutedColor == null
                                  ? Color(0xFF1a1a1a)
                                  : widget.palette.darkMutedColor!.color,
                              elevation: 0.0,
                              onPrimary: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 2),
                              child: Text(
                                'Send Invite',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => InviteSearch(
                                            currentUserId: widget.currentUserId,
                                            event: widget.event,
                                            palette: widget.palette,
                                          )));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: width / 2.6,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            widget.palette.darkMutedColor ==
                                                    null
                                                ? Color(0xFF1a1a1a)
                                                : widget.palette.darkMutedColor!
                                                    .color,
                                        elevation: 0.0,
                                        onPrimary: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 2),
                                        child: Text(
                                          'Send to chat',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => SendToChats(
                                                      currentUserId:
                                                          widget.currentUserId,
                                                      userId: '',
                                                      sendContentType: 'Event',
                                                      event: widget.event,
                                                      post: null,
                                                      forum: null,
                                                      user: null,
                                                      sendContentId:
                                                          widget.event.id,
                                                    )));
                                      }),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: width / 2.6,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            widget.palette.darkMutedColor ==
                                                    null
                                                ? Color(0xFF1a1a1a)
                                                : widget.palette.darkMutedColor!
                                                    .color,
                                        elevation: 0.0,
                                        onPrimary: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 2),
                                        child: Text(
                                          'Share event',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => _dynamicLink()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EventAttendeesAll(
                                        dontShowAnswerWidget: true,
                                        palette: widget.palette,
                                        event: widget.event,
                                        showAppBar: true,
                                        answer: 'Accepted',
                                      ))),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  widget.event.isPrivate
                                      ? sum.toString()
                                      : _attendeeUnAnswered.toString(),
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 40.0,
                                      height: 1),
                                ),
                              ),
                              Text(
                                'People\nattending',
                                style: TextStyle(
                                    color: widget.palette.darkMutedColor == null
                                        ? Color(0xFF1a1a1a)
                                        : widget.palette.darkMutedColor!.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    height: 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      !widget.event.isPrivate
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 30),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Invitation table',
                                    style: TextStyle(
                                        color: widget.palette.darkMutedColor ==
                                                null
                                            ? Color(0xFF1a1a1a)
                                            : widget
                                                .palette.darkMutedColor!.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        height: 1),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Table(
                                    border: TableBorder.all(
                                      color: Colors.grey,
                                    ),
                                    children: [
                                      TableRow(children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesInvited(
                                                        letShowAppBar: true,
                                                        palette: widget.palette,
                                                        event: widget.event,
                                                        answer: '',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        _inviteCount.toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: _inviteCount < 1
                                                          ? Colors.grey
                                                          : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\nInvitations\nsent',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: _inviteCount < 1
                                                          ? Colors.grey
                                                          : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesInvited(
                                                        letShowAppBar: true,
                                                        event: widget.event,
                                                        palette: widget.palette,
                                                        answer: '',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _inviteUnAnswered
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          _inviteUnAnswered < 1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nInvitations\nunanswered\n(pending)',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          _inviteUnAnswered < 1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesInvited(
                                                        letShowAppBar: true,
                                                        palette: widget.palette,
                                                        event: widget.event,
                                                        answer: 'Accepted',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _inviteAcceptedCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          _inviteAcceptedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nInvitations\naccepted',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          _inviteAcceptedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesInvited(
                                                        letShowAppBar: true,
                                                        palette: widget.palette,
                                                        event: widget.event,
                                                        answer: 'Rejected',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _inviteRejectedCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          _inviteRejectedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nInvitations\nrejected',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          _inviteRejectedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 30),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Invitation table',
                                    style: TextStyle(
                                        color: widget.palette.darkMutedColor ==
                                                null
                                            ? Color(0xFF1a1a1a)
                                            : widget
                                                .palette.darkMutedColor!.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        height: 1),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Table(
                                    border: TableBorder.all(
                                      color: Colors.grey,
                                    ),
                                    children: [
                                      TableRow(children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesInvited(
                                                        letShowAppBar: true,
                                                        palette: widget.palette,
                                                        event: widget.event,
                                                        answer: 'All',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        _inviteCount.toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: _inviteCount < 1
                                                          ? Colors.grey
                                                          : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\nInvitations\nsent',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: _inviteCount < 1
                                                          ? Colors.grey
                                                          : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesInvited(
                                                        letShowAppBar: true,
                                                        event: widget.event,
                                                        palette: widget.palette,
                                                        answer: '',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _inviteUnAnswered
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          _inviteUnAnswered < 1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nInvitations\nunanswered\n(pending)',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          _inviteUnAnswered < 1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesInvited(
                                                        letShowAppBar: true,
                                                        palette: widget.palette,
                                                        event: widget.event,
                                                        answer: 'Accepted',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _inviteAcceptedCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          _inviteAcceptedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nInvitations\naccepted',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          _inviteAcceptedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesInvited(
                                                        letShowAppBar: true,
                                                        palette: widget.palette,
                                                        event: widget.event,
                                                        answer: 'Rejected',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _inviteRejectedCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          _inviteRejectedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nInvitations\nrejected',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          _inviteRejectedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    'Attendee Request table',
                                    style: TextStyle(
                                        color: widget.palette.darkMutedColor ==
                                                null
                                            ? Color(0xFF1a1a1a)
                                            : widget
                                                .palette.darkMutedColor!.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        height: 1),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Table(
                                    border: TableBorder.all(
                                      color: Colors.grey,
                                    ),
                                    children: [
                                      TableRow(children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesRequested(
                                                        dontShowAnswerWidget:
                                                            false,
                                                        showAppBar: true,
                                                        palette: widget.palette,
                                                        event: widget.event,
                                                        answer: 'All',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _attendeeRequesCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          _attendeeRequesCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nAttendee\nrequests\nreceived',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          _attendeeRequesCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesRequested(
                                                        dontShowAnswerWidget:
                                                            false,
                                                        showAppBar: true,
                                                        palette: widget.palette,
                                                        event: widget.event,
                                                        answer: '',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _attendeeUnAnswered
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          _attendeeUnAnswered <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nAttendee\nrequests\nunanswered\n(pending)',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          _attendeeUnAnswered <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesRequested(
                                                        dontShowAnswerWidget:
                                                            false,
                                                        showAppBar: true,
                                                        palette: widget.palette,
                                                        event: widget.event,
                                                        answer: 'Accepted',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _attendeeAcceptedCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          _attendeeAcceptedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nAttendee\nrequests\naccepted',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          _attendeeAcceptedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttendeesRequested(
                                                        dontShowAnswerWidget:
                                                            false,
                                                        showAppBar: true,
                                                        palette: widget.palette,
                                                        event: widget.event,
                                                        answer: 'Rejected',
                                                      ))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20),
                                            child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: _attendeeRejectedCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          _attendeeRejectedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nAttendee\nrequests\nrejected',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          _attendeeRejectedCount <
                                                                  1
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 50),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: RichText(
                          textScaleFactor: MediaQuery.of(context)
                              .textScaleFactor
                              .clamp(0.5, 1.5),
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      'Every attendee of this event would be given an check-in number also known as an attendee number. An event organizer should validate each attendee by checking if the check-in number they have corresponds to the check-in number you have among your people attending list. Your validator would be ready 3 days before this event.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "This dashboard would be closed on\n${MyDateFormat.toDate(DateTime.parse(widget.event.clossingDay))} after this event is completed.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          Center(
            child: IconButton(
              icon: Icon(Icons.close),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
        ],
      ),
    ));
  }
}
