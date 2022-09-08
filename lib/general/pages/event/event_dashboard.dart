import 'package:bars/utilities/exports.dart';

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
    _countDown();
  }

  _countDown() async {
    DateTime date = DateTime.parse(widget.event.date);
    final toDayDate = DateTime.now();
    var different = date.difference(toDayDate).inDays;

    setState(() {
      _different = different;
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
          ShakeTransition(
            child: new Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: width,
                  // height: MediaQuery.of(context).size.height,
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
                        height: 30,
                      ),
                      Center(
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _different.toString(),
                                style: TextStyle(
                                  fontSize: 50,
                                  color: widget.palette.darkMutedColor == null
                                      ? Color(0xFF1a1a1a)
                                      : widget.palette.darkMutedColor!.color,
                                ),
                              ),
                              TextSpan(
                                text: '\nDays\nMore',
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
                        height: 30,
                      ),
                      Container(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          widget.palette.darkMutedColor == null
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
                                        'Send Invite',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (_) => InvitationMessage(
                                      //               currentUserId:
                                      //                   widget.currentUserId,
                                      //               event: widget.event,
                                      //               palette: widget.palette,
                                      //             )));
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => InviteSearch(
                                                    currentUserId:
                                                        widget.currentUserId,
                                                    event: widget.event,
                                                    palette: widget.palette,
                                                  )));
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: width / 4,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: widget.palette.darkMutedColor ==
                                            null
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
                                    child: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                  onPressed: () {},
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
                                  builder: (_) => EventAttendees(
                                        palette: widget.palette,
                                        event: widget.event,
                                        from: 'Accepted',
                                      ))),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  sum.toString(),
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
                      widget.event.isPrivate
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Table(
                                border: TableBorder.all(
                                  color: Colors.grey,
                                ),
                                children: [
                                  TableRow(children: [
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => EventAttendees(
                                                    palette: widget.palette,
                                                    event: widget.event,
                                                    from: 'Accepted',
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
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '\nInvitation\nsent',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
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
                                              builder: (_) => EventAttendees(
                                                    palette: widget.palette,
                                                    event: widget.event,
                                                    from: '',
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
                                                text: _different.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '\nInvitations\naccepted',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
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
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Table(
                                border: TableBorder.all(
                                  color: Colors.grey,
                                ),
                                children: [
                                  TableRow(children: [
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => EventAttendees(
                                                    palette: widget.palette,
                                                    event: widget.event,
                                                    from: 'Received',
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
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '\nAttendee\nrequests\nreceived',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
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
                                              builder: (_) => EventInvites(
                                                    palette: widget.palette,
                                                    event: widget.event,
                                                    from: 'Sent',
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
                                                text: _inviteCount.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '\nInvitations\nsent',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
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
                                              builder: (_) => EventAttendees(
                                                    palette: widget.palette,
                                                    event: widget.event,
                                                    from: 'Accepted',
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
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '\nAttendee\nrequests\naccepted',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
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
                                              builder: (_) => EventInvites(
                                                    palette: widget.palette,
                                                    event: widget.event,
                                                    from: 'Accepted',
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
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '\nInvitations\naccepted',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
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
                                              builder: (_) => EventInvites(
                                                    palette: widget.palette,
                                                    event: widget.event,
                                                    from: 'Rejected',
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
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '\nAttendee\nrequests\nrejected',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
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
                                              builder: (_) => EventInvites(
                                                    palette: widget.palette,
                                                    event: widget.event,
                                                    from: 'Rejected',
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
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '\nInvitations\nrejected',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
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
                                              builder: (_) => EventAttendees(
                                                    palette: widget.palette,
                                                    event: widget.event,
                                                    from: '',
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
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '\nAttendee\nrequests\nunanswered\n(pending)',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
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
                                              builder: (_) => EventInvites(
                                                    event: widget.event,
                                                    from: '',
                                                    palette: widget.palette,
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
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '\nInvitations\nunanswered\n(pending)',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
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
                            ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Text(
                          'Your attendee number must much the event\s organiser\s account number in order to attend this event. You should show this account number at the entrance of the event',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
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
