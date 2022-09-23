import 'package:bars/utilities/exports.dart';

class EventsFeedAttendingWidget extends StatefulWidget {
  final EventInvite invite;
  final Event event;

  const EventsFeedAttendingWidget({
    required this.invite,
    required this.event,
  });

  @override
  State<EventsFeedAttendingWidget> createState() =>
      _EventsFeedAttendingWidgetState();
}

class _EventsFeedAttendingWidgetState extends State<EventsFeedAttendingWidget> {
  late DateTime _date;
  late DateTime _toDaysDate;
  int _different = 0;

  @override
  void initState() {
    super.initState();
    widget.event.id.isEmpty ? () {} : _countDown();
  }

  _countDown() async {
    DateTime date = DateTime.parse(widget.event.date);
    final toDayDate = DateTime.now();
    var different = date.difference(toDayDate).inDays;

    setState(() {
      _different = different;
      _date = date;
      _toDaysDate = toDayDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () => widget.event.id.isEmpty
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EventsAttendingDeleted(
                          invite: widget.invite,
                        )))
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EventsAttending(
                          invite: widget.invite,
                          event: widget.event,
                          date: _date,
                          different: _different,
                          toDaysDate: _toDaysDate,
                        ))),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ConfigBloc().darkModeOn
                                  ? Color(0xFF1a1a1a)
                                  : Colors.white,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.invite.eventImageUrl),
                                fit: BoxFit.cover,
                              )),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.center,
                              colors: [
                                Colors.black.withOpacity(.6),
                                Colors.black.withOpacity(.6),
                              ],
                            ),
                            shape: BoxShape.circle,
                            color: ConfigBloc().darkModeOn
                                ? Color(0xFF1a1a1a)
                                : Colors.white,
                          ),
                          child: Icon(
                            Icons.event_available,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            widget.event.id.isEmpty
                ? Text(
                    'unavailable',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    ),
                  )
                : RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _different.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' days',
                          style: TextStyle(
                            fontSize: 12,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
          ],
        ),
      ),
    );
  }
}
