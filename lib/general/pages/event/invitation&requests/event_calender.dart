import 'package:bars/utilities/exports.dart';

class EventCalender extends StatefulWidget {
  final Event event;
  final PaletteGenerator palette;

  EventCalender({
    required this.event,
    required this.palette,
  });

  @override
  State<EventCalender> createState() => _EventCalenderState();
}

class _EventCalenderState extends State<EventCalender> {
  int _different = 0;
  late DateTime _date;
  late DateTime _toDaysDate;

  @override
  void initState() {
    super.initState();
    _countDown();
  }

  _countDown() async {
    final DateTime date = widget.event.date.isEmpty
        ? DateTime.parse('2023-12-19 00:00:00.000')
        : DateTime.parse(widget.event.date);
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
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
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
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
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
                        'Event \nCalendar.',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16.0, height: 1),
                      ),
                    ],
                  ),
                  widget.event.date.isEmpty
                      ? Text(
                          '',
                          style: TextStyle(
                            color: Colors.transparent,
                            fontSize: 0,
                          ),
                        )
                      : RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    _date.difference(_toDaysDate).inMinutes < 0
                                        ? ''
                                        : _different.toString(),
                                style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text:
                                    _date.difference(_toDaysDate).inMinutes < 0
                                        ? 'Ongoing...'
                                        : '\nDays More',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.right,
                        ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              widget.event.date.isEmpty
                  ? const SizedBox.shrink()
                  : ShakeTransition(
                      child: Container(
                        height: width,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SfCalendar(
                              view: CalendarView.month,
                              initialSelectedDate:
                                  DateTime.parse(widget.event.date.toString()),
                              initialDisplayDate:
                                  DateTime.parse(widget.event.date.toString())),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 30,
              ),
              widget.event.isPrivate &&
                      widget.event.authorId !=
                          Provider.of<UserData>(context).currentUserId
                  ? Container(
                      width: width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0.0,
                          foregroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2),
                          child: Text(
                            'Attend',
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
                              builder: (_) => EventRate(
                                    event: widget.event,
                                    palette: widget.palette,
                                  )),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              widget.event.isPrivate
                  ? widget.event.authorId ==
                          Provider.of<UserData>(context, listen: false)
                              .currentUserId!
                      ? const SizedBox.shrink()
                      : Text(
                          'This event is private. You need an invitation to attend.\ If you are interested in this event but you have not received an invitation, you can request for an invitation. Your invitation request needs to be accepted by this event\'s organizer before you can attend this event.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        )
                  : widget.event.authorId ==
                          Provider.of<UserData>(context, listen: false)
                              .currentUserId!
                      ? const SizedBox.shrink()
                      : Text(
                          'This event is public. You don\'t need an invitation to attend. Just swag up, show up and capture the moment in your memory. Attend, meet, and experience.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
