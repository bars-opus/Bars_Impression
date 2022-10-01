import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EventInviteAvailable extends StatefulWidget {
  final EventInvite eventInvite;
  final Event event;
  final PaletteGenerator palette;
  final int inviteCount;
  final String from;

  const EventInviteAvailable({
    required this.eventInvite,
    required this.event,
    required this.palette,
    required this.inviteCount,
    required this.from,
  });

  @override
  State<EventInviteAvailable> createState() => _EventInviteAvailableState();
}

class _EventInviteAvailableState extends State<EventInviteAvailable> {
  int _different = 0;

  @override
  void initState() {
    super.initState();
    _countDown();
  }

  _countDown() async {
    final DateTime date = DateTime.parse(widget.event.date);
    final toDayDate = DateTime.now();
    var different = date.difference(toDayDate).inDays;

    setState(() {
      _different = different;
    });
  }

  _showSelectImageDialog2(
      BuildContext context, String from, EventInvite eventInvite) {
    return Platform.isIOS
        ? _iosBottomSheet2(context, from, eventInvite)
        : _androidDialog2(context, from, eventInvite);
  }

  _iosBottomSheet2(BuildContext context, String from, EventInvite eventInvite) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              from.startsWith('Accept')
                  ? 'Are you sure you want to accept this invitation?'
                  : from.startsWith('Reject')
                      ? 'Are you sure you want to reject this invitation?'
                      : from.startsWith('Cancel')
                          ? 'Are you sure you want to cancel this invitation request?'
                          : '',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  from.startsWith('Accept')
                      ? 'Accept'
                      : from.startsWith('Reject')
                          ? 'Reject'
                          : from.startsWith('Cancel')
                              ? 'Cancel request'
                              : 'Request',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _answereInvitation(from, eventInvite);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancle',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog2(
      BuildContext parentContext, String from, EventInvite eventInvite) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              from.startsWith('Accept')
                  ? 'Are you sure you want to accept this invitation?'
                  : from.startsWith('Reject')
                      ? 'Are you sure you want to reject this invitation?'
                      : from.startsWith('Cancel')
                          ? 'Are you sure you want to cancel this invitation request?'
                          : '',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    from.startsWith('Accept')
                        ? 'Accept'
                        : from.startsWith('Reject')
                            ? 'Reject'
                            : from.startsWith('Cancel')
                                ? 'Cancel request'
                                : 'Request',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _answereInvitation(from, eventInvite);
                  },
                ),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        });
  }

  _answereInvitation(String from, EventInvite eventInvite) async {
    final double width = MediaQuery.of(context).size.width;
    DatabaseService.numEventAttendee(eventInvite.eventId, 'Accepted')
        .listen((attendeeNumber) {
      Provider.of<UserData>(
        context,
      ).setChatCount(attendeeNumber + 1);
    });

    AccountHolder user =
        await DatabaseService.getUserWithId(eventInvite.anttendeeId);

    try {
      from.startsWith('Cancel')
          ? DatabaseService.cancelInvite(eventInvite: eventInvite)
          : DatabaseService.addEventInviteToAttending(
              answer: from,
              eventInvite: eventInvite,
              currentUserId: eventInvite.authorId,
              event: widget.event,
              eventDate: DateTime.parse(widget.event.date),
              message: '',
              requestNumber: '',
              user: user,
              attendeeNumber: Provider.of<UserData>(context, listen: false)
                      .chatCount
                      .toString() +
                  Provider.of<UserData>(context, listen: false)
                      .currentUserId!
                      .substring(0, 3),
            );
      Provider.of<UserData>(context, listen: false).setChatCount(0);
      Flushbar(
        margin: EdgeInsets.all(8),
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        titleText: Text(
          from.startsWith('Accept')
              ? 'Invitation Accepted'
              : from.startsWith('Reject')
                  ? 'Invitation Rejected'
                  : 'Invatation Cancelled',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 22 : 14,
          ),
        ),
        messageText: Text(
          "",
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 20 : 12,
          ),
        ),
        icon: Icon(
          MdiIcons.checkCircleOutline,
          size: 30.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 2),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    } catch (e) {
      final double width = Responsive.isDesktop(context)
          ? 600.0
          : MediaQuery.of(context).size.width;
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      Flushbar(
        margin: EdgeInsets.all(8),
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        titleText: Text(
          'Error',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 22 : 14,
          ),
        ),
        messageText: Text(
          result.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 20 : 12,
          ),
        ),
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    }
  }

  _unAnsweredWidget(BuildContext context, double width) {
    return ShakeTransition(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Container(
              width: width,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(10, 10),
                  blurRadius: 10.0,
                  spreadRadius: 4.0,
                )
              ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Cordially\nInvited',
                      style: TextStyle(
                          fontSize: 30,
                          color: widget.palette.darkMutedColor == null
                              ? Color(0xFF1a1a1a)
                              : widget.palette.darkMutedColor!.color,
                          height: 0.8),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'To attend ${widget.event.title} at  ${widget.event.venue} on ${MyDateFormat.toDate(DateTime.parse(widget.event.date))} at ${MyDateFormat.toTime(DateTime.parse(widget.event.time))}.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    widget.eventInvite.message.isEmpty
                        ? const SizedBox.shrink()
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Invitation message:',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.eventInvite.message,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    SfCalendar(
                        view: CalendarView.month,
                        initialSelectedDate:
                            DateTime.parse(widget.event.date.toString()),
                        initialDisplayDate:
                            DateTime.parse(widget.event.date.toString())),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            widget.from.startsWith('Activity')
                ? Container(
                    width: width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
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
                          'View event flier',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AllEvenEnlarged(
                                    exploreLocation: 'No',
                                    feed: 1,
                                    askCount: 0,
                                    currentUserId: Provider.of<UserData>(
                                            context,
                                            listen: false)
                                        .currentUserId!,
                                    event: widget.event,
                                    user: Provider.of<UserData>(context,
                                            listen: false)
                                        .user!,
                                  ))),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final List<String> datePartition =
        MyDateFormat.toDate(DateTime.parse(widget.event.date)).split(" ");
    final List<String> timePartition =
        MyDateFormat.toTime(DateTime.parse(widget.event.time)).split(" ");
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
                    'Event \nInvitation.',
                    style: TextStyle(
                        color: Colors.white, fontSize: 16.0, height: 1),
                  ),
                ],
              ),
            ),
            _different < 1
                ? RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Ongoing...',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text:
                              '\nThis event is in progress. It would be completed on ${MyDateFormat.toDate(DateTime.parse(widget.event.clossingDay))}. Attend, meet and explore.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox.shrink(),
            _different < 1
                ? const SizedBox(
                    height: 10,
                  )
                : const SizedBox.shrink(),
            widget.eventInvite.invited! &&
                    widget.eventInvite.attendeeStatus.isEmpty
                ? _unAnsweredWidget(context, width)
                : ShakeTransition(
                    child: new Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Container(
                          width: width,
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
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
                              widget.eventInvite.validated!
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 30.0),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.blue,
                                          size: 20.0,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(
                                height: 10,
                              ),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? Text(
                                      widget.eventInvite.attendeeStatus
                                              .startsWith('Reject')
                                          ? 'Invitation\nRejected'
                                          : 'Invitation\nRequested',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color:
                                              widget.palette.darkMutedColor ==
                                                      null
                                                  ? Color(0xFF1a1a1a)
                                                  : widget.palette
                                                      .darkMutedColor!.color,
                                          height: 0.8),
                                      textAlign: TextAlign.start,
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color:
                                              widget.palette.darkMutedColor ==
                                                      null
                                                  ? Color(0xFF1a1a1a)
                                                  : widget.palette
                                                      .darkMutedColor!.color,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(10, 10),
                                              blurRadius: 10.0,
                                              spreadRadius: 4.0,
                                            )
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20),
                                        child: Text(
                                          widget.eventInvite.attendNumber,
                                          style: TextStyle(
                                            fontSize: 80,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, bottom: 30),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                width: width,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12),
                                  child: RichText(
                                    textScaleFactor:
                                        MediaQuery.of(context).textScaleFactor,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: widget.eventInvite.validated!
                                              ? 'Entrance Status:   '
                                              : '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget.eventInvite.validated!
                                              ? 'Validated\n'
                                              : '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: widget.eventInvite.validated!
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Invitation Status:   ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget
                                                  .eventInvite.attendeeStatus
                                                  .startsWith('Reject')
                                              ? 'Rejected'
                                              : "${widget.eventInvite.attendeeStatus.isEmpty ? 'Pending' : 'Accepted'}  ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: widget
                                                    .eventInvite.attendeeStatus
                                                    .startsWith('Reject')
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nAttendee name:   ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "${widget.eventInvite.anttendeeName} ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nAttendee account type:   ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "${widget.eventInvite.anttendeeprofileHandle} ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nAttendee number:   ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "${widget.eventInvite.attendNumber} ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget.eventInvite.invited!
                                              ? '\nInvitation number:   '
                                              : '\nInvitation request number:   ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "${widget.eventInvite.requestNumber} ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, bottom: 30),
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? const SizedBox.shrink()
                                  : Container(
                                      height: 150,
                                      width: width,
                                      decoration: BoxDecoration(
                                          color: ConfigBloc().darkModeOn
                                              ? Color(0xFF1a1a1a)
                                              : Color(0xFFeff0f2),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                widget.event.imageUrl),
                                            fit: BoxFit.cover,
                                          )),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomRight,
                                                colors: [
                                              Colors.black.withOpacity(.5),
                                              // darkColor.withOpacity(.5),
                                              Colors.black.withOpacity(.4),
                                            ])),
                                      )),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, bottom: 30),
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? const SizedBox.shrink()
                                  : Text(
                                      widget.event.title.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? const SizedBox.shrink()
                                  : SizedBox(height: 20),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? const SizedBox.shrink()
                                  : Container(
                                      height: 1.0,
                                      width: 200,
                                      color: Colors.black,
                                    ),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? const SizedBox.shrink()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: datePartition[0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (datePartition.length > 1)
                                                TextSpan(
                                                  text:
                                                      "\n${datePartition[1].toUpperCase()} ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (datePartition.length > 2)
                                                TextSpan(
                                                  text:
                                                      "\n${datePartition[2].toUpperCase()} ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Container(
                                            height: 50,
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: timePartition[0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (timePartition.length > 1)
                                                TextSpan(
                                                  text:
                                                      "\n${timePartition[1].toUpperCase()} ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (timePartition.length > 2)
                                                TextSpan(
                                                  text:
                                                      "\n${timePartition[2].toUpperCase()} ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, bottom: 30),
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? const SizedBox.shrink()
                                  : const SizedBox(
                                      height: 10,
                                    ),
                              widget.eventInvite.attendeeStatus
                                          .startsWith('Reject') ||
                                      widget.eventInvite.attendeeStatus.isEmpty
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => EventAttendees(
                                                    dontShowAnswerWidget: true,
                                                    palette: widget.palette,
                                                    event: widget.event,
                                                    from: 'Accepted',
                                                    showAppBar: true,
                                                  ))),
                                      child: Container(
                                        width: width,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, right: 12),
                                          child: RichText(
                                            textScaleFactor:
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'The number of people attending:   ',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${widget.inviteCount.toString()} ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "\nSee people attending",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, bottom: 30),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12),
                                child: Text(
                                  widget.eventInvite.attendeeStatus.isEmpty
                                      ? 'Your invitation request has been sent to the organizer of this event. Your request must be accepted before you can attend this event.'
                                      : widget.eventInvite.attendeeStatus
                                              .startsWith('Reject')
                                          ? 'Your invitation request has been rejected.'
                                          : 'Your entrance number also known as your attendee number is ${widget.eventInvite.attendNumber}. This number would be validated at the entrance of this event before you can enter. This number is unique. Have fun attending this event.',
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
            widget.eventInvite.invited!
                ? widget.eventInvite.attendeeStatus.isNotEmpty
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width / 2.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
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
                                    'Accept',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () => _showSelectImageDialog2(
                                    context, 'Accepted', widget.eventInvite),
                              ),
                            ),
                            Container(
                              width: width / 2.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
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
                                    'Reject',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () => _showSelectImageDialog2(
                                    context, 'Rejected', widget.eventInvite),
                              ),
                            ),
                          ],
                        ),
                      )
                : widget.eventInvite.attendeeStatus.isNotEmpty
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Container(
                          width: width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
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
                                'Cancel Request',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onPressed: () => _showSelectImageDialog2(
                                context, 'Cancel', widget.eventInvite),
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
      ),
    );
  }
}
