import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EventAttendeeValidateWidget extends StatefulWidget {
  final ActivityEvent? activityEvent;
  final EventInvite invite;
  final Event event;
  final PaletteGenerator? palette;

  const EventAttendeeValidateWidget(
      {Key? key,
      required this.invite,
      required this.palette,
      required this.activityEvent,
      required this.event})
      : super(key: key);

  @override
  State<EventAttendeeValidateWidget> createState() =>
      _EventAttendeeValidateWidgetState();
}

class _EventAttendeeValidateWidgetState
    extends State<EventAttendeeValidateWidget> {
  bool _validated = false;

  @override
  void initState() {
    super.initState();
    widget.invite.validated! ? _validated = true : null;
  }

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog(context);
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to unvalidate this attendee?',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Unvalidate',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _unValidate();
                },
              )
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

  _androidDialog(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to unvalidate this attendee?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Unvalidate',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _unValidate();
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

  _unValidate() {
    DatabaseService.validateEventAttendee(
      validate: false,
      eventInvite: widget.invite,
    );

    if (mounted) {
      setState(() {
        _validated = false;
      });
    }
  }

  _validate() {
    DatabaseService.validateEventAttendee(
      validate: true,
      eventInvite: widget.invite,
    );

    if (mounted) {
      setState(() {
        _validated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(10, 10),
                blurRadius: 10.0,
                spreadRadius: 4.0,
              )
            ]),
        child: GestureDetector(
            onTap: () => widget.event.isPrivate
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AttendEvent(
                              event: widget.event,
                              currentUserId: widget.invite.anttendeeId,
                              palette: widget.palette!,
                            )),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EventPublicInvite(
                              event: widget.event,
                              palette: widget.palette!,
                            )),
                  ),
            child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      decoration: BoxDecoration(),
                      height: 60,
                      child: ListTile(
                        leading: widget.invite.anttendeeprofileImageUrl.isEmpty
                            ? Icon(
                                Icons.account_circle,
                                size: 60.0,
                                color: Colors.white,
                              )
                            : CircleAvatar(
                                radius: 25.0,
                                backgroundColor: ConfigBloc().darkModeOn
                                    ? Color(0xFF1a1a1a)
                                    : Color(0xFFf2f2f2),
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.invite.anttendeeprofileImageUrl),
                              ),
                        title: Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.invite.anttendeeName.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '\n${widget.invite.anttendeeprofileHandle}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfileScreen(
                                      currentUserId: Provider.of<UserData>(
                                              context,
                                              listen: false)
                                          .currentUserId!,
                                      userId: widget.invite.anttendeeId,
                                    ))),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Attendee Number:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '\n${widget.invite.attendNumber}',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: width / 3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  _validated ? Colors.blue : Color(0xFFf2f2f2),
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
                                _validated ? 'Validated' : 'validate',
                                style: TextStyle(
                                  color:
                                      _validated ? Colors.white : Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              if (_validated) {
                                _showSelectImageDialog();
                              } else {
                                _validate();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ))),
      ),
    );
  }
}
