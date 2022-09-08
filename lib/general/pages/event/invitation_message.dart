import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class InvitationMessage extends StatefulWidget {
  final Event event;
  final String currentUserId;
  final PaletteGenerator palette;
  InvitationMessage({
    required this.event,
    required this.currentUserId,
    required this.palette,
  });

  @override
  _InvitationMessageState createState() => _InvitationMessageState();
}

class _InvitationMessageState extends State<InvitationMessage> {
  int _attendeeRequesCount = 0;
  int _inviteCount = 0;

  @override
  void initState() {
    super.initState();
    _setUpAttendeeRequest();
    _setUpAttendee();
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

  _showSelectImageDialog2() {
    return Platform.isIOS ? _iosBottomSheet2() : _androidDialog2(context);
  }

  _iosBottomSheet2() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to request for invitation?',
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

  _androidDialog2(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to request for invitation?',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Request'),
                onPressed: () {
                  Navigator.pop(context);
                  _checkUser();
                },
              ),
              SimpleDialogOption(
                child: Text('cancel'),
                onPressed: () => Navigator.pop(context),
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
              'Request Sent!!',
              style: TextStyle(
                color: Colors.white,
                fontSize: width > 800 ? 22 : 14,
              ),
            ),
            messageText: Text(
              "Your inviation request has been sent succesfully",
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
      // DatabaseService.InvitationMessage(
      //     event: widget.event,
      //     user: Provider.of<UserData>(context, listen: false).user!,
      //     requestNumber: _requestNumber.toString());
      Navigator.pop(context);
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
          "Your inviation request has been sent succesfully",
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
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: ListView(
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
                      'invitation\nMessage.',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16.0, height: 1),
                    ),
                  ],
                ),
              ),
              ShakeTransition(
                child: new Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      width: width,
                      // height: MediaQuery.of(context).size.height,
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
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12),
                            child: Text(
                              'Your attendee number must much the event\s organiser\s account number in order to attend this event. You should show this account number at the entrance of the event',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 30.0, bottom: 30),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12),
                            child: ContentField(
                              labelText: 'Summary',
                              hintText: "Enter a summary of your blog",
                              initialValue: 'initialSubTitle',
                              onSavedText: (_) {},
                              onValidateText: () {},
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
        ),
      ),
    );
  }
}
