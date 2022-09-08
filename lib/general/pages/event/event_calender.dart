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
  late DateTime _date;
  late DateTime _toDaysDate;
  int _different = 0;

  @override
  void initState() {
    super.initState();
    _countDown();
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
          'Event Calendar',
          style: TextStyle(
              color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _different.toString(),
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: '\nDays More',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 10,
            ),
            ShakeTransition(
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
            Container(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                  child: Text(
                    'View invitation',
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
                      builder: (_) => AttendEvent(
                            event: widget.event,
                            currentUserId:
                                Provider.of<UserData>(context, listen: false)
                                    .currentUserId!,
                            palette: widget.palette,
                          )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
