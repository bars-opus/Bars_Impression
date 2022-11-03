import 'package:bars/utilities/exports.dart';

class EventAttendeeRequestAnswereWidget extends StatefulWidget {
  final ActivityEvent? activityEvent;
  final EventInvite invite;
  final PaletteGenerator? palette;

  const EventAttendeeRequestAnswereWidget(
      {Key? key,
      required this.invite,
      required this.palette,
      required this.activityEvent})
      : super(key: key);

  @override
  State<EventAttendeeRequestAnswereWidget> createState() =>
      _EventAttendeeRequestAnswereWidgetState();
}

class _EventAttendeeRequestAnswereWidgetState
    extends State<EventAttendeeRequestAnswereWidget> {
  bool _rejected = false;
  bool _accepted = false;
  late ActivityEvent? _inviteActivity;
  // int _attendeeNumber = 0;

  @override
  void initState() {
    super.initState();
    widget.invite.attendeeStatus.startsWith('Accept')
        ? _accepted = true
        : widget.invite.attendeeStatus.startsWith('Reject')
            ? _rejected = true
            : _nothing();

    widget.activityEvent == null ? _getInvitationActivity() : _nothing();
    // _setUpAttendee();
  }

  _nothing() {}
  // _setUpAttendee() async {
  //   DatabaseService.numEventAttendeeAll(widget.invite.eventId, 'Accepted')
  //       .listen((attendeeNumber) {
  //     if (mounted) {
  //       setState(() {
  //         _attendeeNumber = attendeeNumber;
  //       });
  //     }
  //   });
  // }

  _getInvitationActivity() async {
    ActivityEvent inviteActivity =
        await DatabaseService.getEventInviteAcivityWithId(
            widget.invite.commonId,
            Provider.of<UserData>(context, listen: false).currentUserId!);
    if (mounted) {
      setState(() {
        _inviteActivity = inviteActivity;
      });
    }
  }

  _checkSubmit() {
    widget.activityEvent == null
        ? _activitySubmit()
        : _activityAvailableSubmit();
  }

  _activityAvailableSubmit() {
    widget.activityEvent!.seen != 'seen'
        ? _submit(widget.activityEvent!)
        : _nothing();
  }

  _activitySubmit() {
    _inviteActivity!.seen != 'seen' ? _submit(_inviteActivity!) : _nothing();
  }

  _submit(ActivityEvent activiitiesEvent) async {
    try {
      activitiesEventRef
          .doc(Provider.of<UserData>(context, listen: false).currentUserId!)
          .collection('userActivitiesEvent')
          .doc(activiitiesEvent.id)
          .update({
        'seen': 'seen',
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // var attendeeNumber = _attendeeNumber.toString() +
    //     "  ${widget.invite.anttendeeId.substring(0, 3)}";
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
            onTap: _nothing(),
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
                            ? const Icon(
                                Icons.account_circle,
                                size: 50.0,
                                color: Colors.grey,
                              )
                            : CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Color(0xFFf2f2f2),
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
                                      '\n${widget.invite.anttendeeprofileHandle},',
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
                                      user: null,
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
                              text: 'Request reason:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '\n${widget.invite.message}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
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
                        padding: const EdgeInsets.only(right: 8.0),
                        child: widget.palette == null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: width / 3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _accepted == true
                                            ? Colors.blue
                                            : _rejected == true
                                                ? Colors.white
                                                : Color(0xFFf2f2f2),
                                        elevation: 0.0,
                                        foregroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 2),
                                        child: Text(
                                          _accepted == true
                                              ? 'Accepted'
                                              : 'Accept',
                                          style: TextStyle(
                                            color: _accepted == true
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        HapticFeedback.heavyImpact();
                                        DatabaseService
                                            .answerEventAttendeeReques(
                                                answer: 'Accepted',
                                                eventInvite: widget.invite,
                                              );
                                        _checkSubmit();
                                        setState(() {
                                          _accepted = true;
                                          _rejected = false;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: width / 3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _rejected == true
                                            ? Colors.blue
                                            : _accepted == true
                                                ? Colors.white
                                                : Color(0xFFf2f2f2),
                                        elevation: 0.0,
                                        foregroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 2),
                                        child: Text(
                                          _rejected == true
                                              ? 'Rejected'
                                              : 'Reject',
                                          style: TextStyle(
                                            color: widget.invite.attendeeStatus
                                                        .startsWith('Reject') ||
                                                    _rejected == true
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        HapticFeedback.heavyImpact();
                                        DatabaseService
                                            .answerEventAttendeeReques(
                                              
                                                answer: 'Rejected',
                                                eventInvite: widget.invite);
                                        _checkSubmit();
                                        setState(() {
                                          _rejected = true;
                                          _accepted = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: width / 3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _accepted == true
                                            ? widget.palette!.darkMutedColor ==
                                                    null
                                                ? Colors.blue
                                                : widget.palette!
                                                    .darkMutedColor!.color
                                            : _rejected == true
                                                ? Colors.white
                                                : Color(0xFFf2f2f2),
                                        elevation: 0.0,
                                        foregroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 2),
                                        child: Text(
                                          _accepted == true
                                              ? 'Accepted'
                                              : 'Accept',
                                          style: TextStyle(
                                            color: _accepted == true
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        HapticFeedback.heavyImpact();
                                        DatabaseService
                                            .answerEventAttendeeReques(
                                                answer: 'Accepted',
                                                eventInvite: widget.invite,
                                              );
                                        _checkSubmit();
                                        setState(() {
                                          _accepted = true;
                                          _rejected = false;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: width / 3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _rejected == true
                                            ? widget.palette!.darkMutedColor ==
                                                    null
                                                ? Colors.blue
                                                : widget.palette!
                                                    .darkMutedColor!.color
                                            : _accepted == true
                                                ? Colors.white
                                                : Color(0xFFf2f2f2),
                                        elevation: 0.0,
                                        foregroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 2),
                                        child: Text(
                                          _rejected == true
                                              ? 'Rejected'
                                              : 'Reject',
                                          style: TextStyle(
                                            color: widget.invite.attendeeStatus
                                                        .startsWith('Reject') ||
                                                    _rejected == true
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        HapticFeedback.heavyImpact();
                                        DatabaseService
                                            .answerEventAttendeeReques(
                                                answer: 'Rejected',
                                                eventInvite: widget.invite,
                                            );
                                        _checkSubmit();
                                        setState(() {
                                          _rejected = true;
                                          _accepted = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
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
