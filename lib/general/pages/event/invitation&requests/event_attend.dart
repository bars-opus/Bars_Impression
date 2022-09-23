import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class AttendEvent extends StatefulWidget {
  final Event event;
  final String currentUserId;
  final PaletteGenerator palette;
  AttendEvent({
    required this.event,
    required this.currentUserId,
    required this.palette,
  });

  @override
  _AttendEventState createState() => _AttendEventState();
}

class _AttendEventState extends State<AttendEvent> {
  int _attendeeRequesCount = 0;
  int _inviteCount = 0;
  String _message = '';

  @override
  void initState() {
    super.initState();

    _setUpAttendeeRequest();
    widget.event.isPrivate ? _setUpInviteAttendee() : _setUpAttendee();
  }

  _setUpAttendeeRequest() async {
    DatabaseService.numEventAttendee(widget.event.id, '')
        .listen((requestCount) {
      if (mounted) {
        setState(() {
          _attendeeRequesCount = requestCount;
        });
      }
    });
  }

  _setUpAttendee() async {
    DatabaseService.numEventAttendee(widget.event.id, 'Accepted')
        .listen((inviteCount) {
      if (mounted) {
        setState(() {
          _inviteCount = inviteCount;
        });
      }
    });
  }

  _setUpInviteAttendee() async {
    DatabaseService.numEventInvites(widget.event.id, 'Accepted')
        .listen((inviteCount) {
      if (mounted) {
        setState(() {
          _inviteCount = inviteCount;
        });
      }
    });
  }

  _showSelectImageDialog2(EventInvite eventInvite) {
    return Platform.isIOS
        ? _iosBottomSheet2(eventInvite)
        : _androidDialog2(context, eventInvite);
  }

  _iosBottomSheet2(EventInvite eventInvite) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to request for an invitation?',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Request',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _checkUser();
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

  // _androidDialog2(BuildContext parentContext, EventInvite eventInvite) {
  //   return showDialog(
  //       context: parentContext,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: Text(
  //             'Are you sure you want to request for an invitation?',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //             textAlign: TextAlign.center,
  //           ),
  //           children: <Widget>[
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'Request',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, color: Colors.blue),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   _checkUser();
  //                 },
  //               ),
  //             ),
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'Cancel',
  //                 ),
  //                 onPressed: () => Navigator.pop(context),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  _androidDialog2(BuildContext parentContext, EventInvite eventInvite) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to request for an invitation?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Request',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _checkUser();
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

  _checkUser() {
    final double width = MediaQuery.of(context).size.width;
    Provider.of<UserData>(context, listen: false).user == null
        ? Flushbar(
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
              'Sorry!!',
              style: TextStyle(
                color: Colors.white,
                fontSize: width > 800 ? 22 : 14,
              ),
            ),
            messageText: Text(
              "We run into a problem refresh your app and start again",
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
          ).show(context)
        : _SendInvitation();
  }

  _SendInvitation() {
    final double width = MediaQuery.of(context).size.width;
    int _requestNumber = _attendeeRequesCount + 1;
    try {
      DatabaseService.attendEvent(
          message: _message,
          eventDate: DateTime.parse(widget.event.date),
          event: widget.event,
          user: Provider.of<UserData>(context, listen: false).user!,
          requestNumber: _requestNumber.toString(),
          currentUserId:
              Provider.of<UserData>(context, listen: false).currentUserId!);

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
          'Request Sent!!',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 22 : 14,
          ),
        ),
        messageText: Text(
          "Your invitation request has been sent successfully. You would be notified when your invitation is accepted.",
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ResponsiveScaffold(
      child: FutureBuilder(
          future: DatabaseService.getEventAttendeee(
              widget.event, widget.currentUserId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Expanded(
                child: Container(
                  color: widget.palette.darkMutedColor == null
                      ? Color(0xFF1a1a1a)
                      : widget.palette.darkMutedColor!.color,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            EventInvite _eventInvite = snapshot.data;
            return _eventInvite.anttendeeId.isNotEmpty ||
                    _eventInvite.eventId.isNotEmpty
                ? EventInviteAvailable(
                    from: '',
                    eventInvite: _eventInvite,
                    event: widget.event,
                    palette: widget.palette,
                    inviteCount: _inviteCount,
                  )
                : Scaffold(
                    backgroundColor: widget.palette.darkMutedColor == null
                        ? Color(0xFF1a1a1a)
                        : widget.palette.darkMutedColor!.color,
                    appBar: AppBar(
                      automaticallyImplyLeading: true,
                      elevation: 0,
                      backgroundColor: widget.palette.darkMutedColor == null
                          ? Color(0xFF1a1a1a)
                          : widget.palette.darkMutedColor!.color,
                      title: Text(
                        'Attend Event',
                        style: TextStyle(
                            color: ConfigBloc().darkModeOn
                                ? Colors.black
                                : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      centerTitle: true,
                    ),
                    body: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: ListView(
                        children: <Widget>[
                          const SizedBox(height: 40),
                          ShakeTransition(
                            child: new Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 30.0, left: 30),
                                child: Container(
                                  width: width,
                                  decoration: BoxDecoration(
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
                                      const SizedBox(height: 50),
                                      Text(
                                        'Request\nInvitation',
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
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, right: 12),
                                        child: Text(
                                          'To attend ${widget.event.title} at  ${widget.event.venue} on ${MyDateFormat.toDate(DateTime.parse(widget.event.date))} at ${MyDateFormat.toTime(DateTime.parse(widget.event.time))}.',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
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
                                          'You can give a reason why your request should be accepted.',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, right: 12),
                                        child: ContentField(
                                          labelText: 'Reason',
                                          hintText: "Reason to attend",
                                          initialValue: _message,
                                          onSavedText: (input) =>
                                              _message = input,
                                          onValidateText: () {},
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Center(
                              child: Container(
                                width: width,
                                child: TextButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: ConfigBloc().darkModeOn
                                        ? Color(0xFF1a1a1a)
                                        : Colors.white,
                                    onPrimary: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                  ),
                                  onPressed: () =>
                                      _showSelectImageDialog2(_eventInvite),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      'Request Invitation',
                                      style: TextStyle(
                                        color: widget.palette.darkMutedColor ==
                                                null
                                            ? Color(0xFF1a1a1a)
                                            : widget
                                                .palette.darkMutedColor!.color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 30.0, left: 30),
                            child: Text(
                              'This event is private. You need an invitation to attend.\ If you are interested in this event but you have not received an invitation, you can request for an invitation. Your invitation request needs to be accepted by this event organizer before you can attend this event.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}
