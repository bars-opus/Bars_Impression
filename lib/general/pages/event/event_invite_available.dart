
import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class InviteAvailable extends StatelessWidget {
  final EventInvite eventInvite;
  final Event event;
  final PaletteGenerator palette;
  final int attendeeRequesCount;
  final int inviteCount;

  const InviteAvailable({
    required this.eventInvite,
    required this.event,
    required this.palette,
    required this.attendeeRequesCount,
    required this.inviteCount,
  });

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
                  _answereInvitation(context, from, eventInvite);
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
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  from.startsWith('Accept')
                      ? 'Accept'
                      : from.startsWith('Reject')
                          ? 'Reject'
                          : from.startsWith('Cancel')
                              ? 'Cancel request'
                              : 'Request',
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _answereInvitation(context, from, eventInvite);
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

  _answereInvitation(
      BuildContext context, String from, EventInvite eventInvite) {
    final double width = MediaQuery.of(context).size.width;
    // int _requestNumber = _attendeeRequesCount + 1;

    try {
      from.startsWith('Cancel')
          ? DatabaseService.cancelInvite(eventInvite: eventInvite)
          : DatabaseService.answerEventAttendee(
              answer: from, eventInvite: eventInvite);

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

  _unAnsweredWidget(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Column(
      children: [
        const SizedBox(
          height: 60,
        ),
        Text(
          'Invitation\nReceived',
          style: TextStyle(
              fontSize: 30,
              color: palette.darkMutedColor == null
                  ? Color(0xFF1a1a1a)
                  : palette.darkMutedColor!.color,
              height: 0.8),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Text(
            'You have been invited by ${eventInvite.anttendeeName} to attend ${event.title} at  ${event.venue}',
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
        eventInvite.message.isEmpty
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
        eventInvite.message.isEmpty
            ? SizedBox.shrink()
            : Container(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Invitation message:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                        TextSpan(
                          text: '\n${eventInvite.message}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        Container(
          width: width,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Invitation Status:   ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    text: eventInvite.attendeeStatus.startsWith('Reject')
                        ? 'Rejected'
                        : "${eventInvite.attendeeStatus.isEmpty ? 'Pending' : 'Accepted'}  ",
                    style: TextStyle(
                      fontSize: 12,
                      color: eventInvite.attendeeStatus.startsWith('Reject')
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '\nInvitee name:   ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    text: "${eventInvite.inviteeName} ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
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
                    text: "${eventInvite.anttendeeName} ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '\nInvitation number:   ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    text: "${eventInvite.requestNumber} ",
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
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Text(
            eventInvite.attendeeStatus.isEmpty
                ? 'Your invitation request has be sent to the organizer of this event. '
                : eventInvite.attendeeStatus.startsWith('Reject')
                    ? 'Your invitation request has been rejected.'
                    : 'Your attendee number must much the event\s organiser\s account number in order to attend this event. You should show this account number at the entrance of the event',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 60,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final List<String> datePartition =
        MyDateFormat.toDate(DateTime.parse(event.date)).split(" ");
    final List<String> timePartition =
        MyDateFormat.toTime(DateTime.parse(event.time)).split(" ");
    return Scaffold(
      backgroundColor: palette.darkMutedColor == null
          ? Color(0xFF1a1a1a)
          : palette.darkMutedColor!.color,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: palette.darkMutedColor == null
            ? Color(0xFF1a1a1a)
            : palette.darkMutedColor!.color,
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
                      color: palette.darkMutedColor == null
                          ? Color(0xFF1a1a1a)
                          : palette.darkMutedColor!.color,
                      size: 20.0,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Event \nInvitation.',
                  style:
                      TextStyle(color: Colors.white, fontSize: 16.0, height: 1),
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
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(10, 10),
                      blurRadius: 10.0,
                      spreadRadius: 4.0,
                    )
                  ]),
                  child: eventInvite.invited &&
                          eventInvite.attendeeStatus.isEmpty
                      ? _unAnsweredWidget(context)
                      : Column(
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            eventInvite.attendNumber.length <= 3
                                ? SizedBox.shrink()
                                : Text(
                                    eventInvite.attendNumber,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: palette.darkMutedColor == null
                                            ? Color(0xFF1a1a1a)
                                            : palette.darkMutedColor!.color,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? Text(
                                    eventInvite.attendeeStatus
                                            .startsWith('Reject')
                                        ? 'Invitation\nRejected'
                                        : 'Invitation\nRequested',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: palette.darkMutedColor == null
                                            ? Color(0xFF1a1a1a)
                                            : palette.darkMutedColor!.color,
                                        height: 0.8),
                                    textAlign: TextAlign.start,
                                  )
                                : Container(
                                    width: eventInvite.attendNumber.length <= 3
                                        ? 150
                                        : 100,
                                    decoration: BoxDecoration(
                                        color: palette.darkMutedColor == null
                                            ? Color(0xFF1a1a1a)
                                            : palette.darkMutedColor!.color,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(10, 10),
                                            blurRadius: 10.0,
                                            spreadRadius: 4.0,
                                          )
                                        ]),
                                    child: Text(
                                      eventInvite.attendNumber,
                                      style: TextStyle(
                                          fontSize: 80,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w100),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                            const SizedBox(height: 40),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30.0, bottom: 30),
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
                                        text: 'Invitation Status:   ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      TextSpan(
                                        text: eventInvite.attendeeStatus
                                                .startsWith('Reject')
                                            ? 'Rejected'
                                            : "${eventInvite.attendeeStatus.isEmpty ? 'Pending' : 'Accepted'}  ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: eventInvite.attendeeStatus
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
                                        text: "${eventInvite.anttendeeName} ",
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
                                            "${eventInvite.anttendeeprofileHandle} ",
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
                                        text: "${eventInvite.attendNumber} ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nInvitation request number:   ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${eventInvite.requestNumber} ",
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
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, bottom: 30),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
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
                                              event.imageUrl),
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
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, bottom: 30),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? const SizedBox.shrink()
                                : Text(
                                    event.title.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? const SizedBox.shrink()
                                : SizedBox(height: 20),
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? const SizedBox.shrink()
                                : Container(
                                    height: 1.0,
                                    width: 200,
                                    color: Colors.black,
                                  ),
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? const SizedBox.shrink()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RichText(
                                        textScaleFactor: MediaQuery.of(context)
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
                                        textScaleFactor: MediaQuery.of(context)
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
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, bottom: 30),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? const SizedBox.shrink()
                                : Container(
                                    width: width,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, right: 12),
                                      child: RichText(
                                        textScaleFactor: MediaQuery.of(context)
                                            .textScaleFactor,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  'Number of invitation requests:   ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "${attendeeRequesCount} ",
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
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? const SizedBox.shrink()
                                : const SizedBox(
                                    height: 10,
                                  ),
                            eventInvite.attendeeStatus.startsWith('Reject') ||
                                    eventInvite.attendeeStatus.isEmpty
                                ? const SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => EventAttendees(
                                                  palette: palette,
                                                  event: event,
                                                  from: 'Accepted',
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
                                                    'Number of people attending:   ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "${inviteCount} ",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "\nSee people attending",
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
                              padding:
                                  const EdgeInsets.only(top: 30.0, bottom: 30),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, right: 12),
                              child: Text(
                                eventInvite.attendeeStatus.isEmpty
                                    ? 'Your invitation request has be sent to the organizer of this event. '
                                    : eventInvite.attendeeStatus
                                            .startsWith('Reject')
                                        ? 'Your invitation request has been rejected.'
                                        : 'Your attendee number must much the event\s organiser\s account number in order to attend this event. You should show this account number at the entrance of the event',
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
          eventInvite.invited
              ? eventInvite.attendeeStatus.isNotEmpty
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
                                  context, 'Accepted', eventInvite),
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
                                  context, 'Rejected', eventInvite),
                            ),
                          ),
                        ],
                      ),
                    )
              : eventInvite.attendeeStatus.isNotEmpty
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
                              context, 'Cancel', eventInvite),
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
    );
  }
}
