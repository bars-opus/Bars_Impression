import 'package:bars/utilities/exports.dart';

class EventRate extends StatefulWidget {
  final Event event;
  final PaletteGenerator palette;

  EventRate({
    required this.event,
    required this.palette,
  });

  @override
  State<EventRate> createState() => _EventRateState();
}

class _EventRateState extends State<EventRate> {
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
    final List<String> rate = widget.event.rate.isEmpty
        ? widget.event.title.split("")
        : widget.event.rate.startsWith('free')
            ? widget.event.title.split("r")
            : widget.event.rate.split(",");
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
          padding: const EdgeInsets.all(20.0),
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
                        'Event \nRate',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16.0, height: 1),
                      ),
                    ],
                  ),
                  widget.event.date.isEmpty
                      ? Text(
                          '',
                          style:
                              TextStyle(color: Colors.transparent, fontSize: 0),
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
                                  fontSize: 40,
                                  fontWeight: FontWeight.w100,
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
                                  // fontWeight: FontWeight.w100,
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
                height: 50,
              ),
              widget.event.rate.isEmpty
                  ? const SizedBox.shrink()
                  : ShakeTransition(
                      child: Center(
                        child: widget.event.rate.startsWith('free')
                            ? RichText(
                                textScaleFactor:
                                    MediaQuery.of(context).textScaleFactor,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Free\n',
                                    style: TextStyle(
                                      fontSize: 50.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'This event is free. \nSwag up, attend, meet and experience.',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                                textAlign: TextAlign.center,
                              )
                            : RichText(
                                textScaleFactor:
                                    MediaQuery.of(context).textScaleFactor,
                                text: TextSpan(children: [
                                  if (rate.length > 1)
                                    TextSpan(
                                      text: rate[1],
                                      style: TextStyle(
                                        fontSize: 50.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  if (rate.length > 0)
                                    TextSpan(
                                      text: "\n${rate[0]}\n\n",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  TextSpan(
                                    text: widget.event.isCashPayment
                                        ? 'The payment method for this event is cash. '
                                        : '',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
              const SizedBox(
                height: 40,
              ),
              widget.event.authorId ==
                      Provider.of<UserData>(context).currentUserId!
                  ? const SizedBox.shrink()
                  : Provider.of<UserData>(context, listen: false)
                          .user!
                          .score!
                          .isNegative
                      ? const SizedBox.shrink()
                      : Container(
                          width: width,
                          child: widget.event.date.isEmpty ||
                                  widget.event.time.isEmpty ||
                                  widget.event.clossingDay.isEmpty
                              ? const SizedBox.shrink()
                              : ElevatedButton(
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
                                  onPressed: () {
                                    widget.event.isPrivate
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => AttendEvent(
                                                      event: widget.event,
                                                      currentUserId:
                                                          Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .currentUserId!,
                                                      palette: widget.palette,
                                                    )),
                                          )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    EventPublicInviteAvailable(
                                                      event: widget.event,
                                                      palette: widget.palette,
                                                      eventInvite: null,
                                                    )),
                                          );
                                  }),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
