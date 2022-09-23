import 'package:bars/utilities/exports.dart';

class EventsAttendingDeleted extends StatefulWidget {
  final EventInvite invite;

  const EventsAttendingDeleted({
    required this.invite,
  });

  @override
  State<EventsAttendingDeleted> createState() => _EventsAttendingDeletedState();
}

class _EventsAttendingDeletedState extends State<EventsAttendingDeleted> {
  _deleteEvent() {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;

    DatabaseService.deleteUnAvailableEvent(eventInvite: widget.invite);

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
        'Done!!',
        style: TextStyle(
          color: Colors.white,
          fontSize: width > 800 ? 22 : 14,
        ),
      ),
      messageText: Text(
        "Deleted successfully. Refresh your event page",
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
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: FractionalOffset.center,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                color: ConfigBloc().darkModeOn
                    ? Color(0xFF1a1a1a)
                    : Color(0xFFeff0f2),
                image: DecorationImage(
                  image:
                      CachedNetworkImageProvider(widget.invite.eventImageUrl),
                  fit: BoxFit.cover,
                )),
            child: Container(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.5),
                // darkColor.withOpacity(.5),
                Colors.black.withOpacity(.4),
              ])),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Not\nAvailable',
                          style: TextStyle(
                              fontSize: 30, color: Colors.white, height: 0.8),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'This event has been deleted by the creator.\nTap to delete this event from your list of events you would be attending.',
                          style: TextStyle(
                            fontSize: 14,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _deleteEvent(),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.delete_forever),
                                iconSize: 25,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.black
                                    : Colors.white,
                                onPressed: () => _deleteEvent(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}
