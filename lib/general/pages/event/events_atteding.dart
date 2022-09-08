import 'package:bars/utilities/exports.dart';

class EventsAttending extends StatefulWidget {
  final EventInvite invite;
  final Event event;
  final DateTime date;
  final DateTime toDaysDate;
  final int different;

  const EventsAttending({
    required this.invite,
    required this.event,
    required this.date,
    required this.toDaysDate,
    required this.different,
  });

  @override
  State<EventsAttending> createState() => _EventsAttendingState();
}

class _EventsAttendingState extends State<EventsAttending> {
  Future<void> _generatePalette(
    context,
  ) async {
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(widget.event.imageUrl),
      size: Size(1110, 150),
      maximumColorCount: 20,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => InviteAvailable(
                eventInvite: widget.invite,
                event: widget.event,
                palette: _paletteGenerator,
                attendeeRequesCount: 0,
                inviteCount: 0,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final List<String> datePartition =
        MyDateFormat.toDate(DateTime.parse(widget.event.date)).split(" ");
    return Material(
      child: Stack(
        alignment: FractionalOffset.center,
        children: [
          Hero(
            tag: 'image' + widget.event.id.toString(),
            child: Container(
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
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        iconSize: 30.0,
                        color: Colors.white,
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.different.toString(),
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
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            MyDateFormat.toTime(
                                DateTime.parse(widget.event.time)),
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: datePartition[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (datePartition.length > 1)
                                  TextSpan(
                                    text:
                                        "\n${datePartition[1].toUpperCase()} ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                if (datePartition.length > 2)
                                  TextSpan(
                                    text:
                                        "\n${datePartition[2].toUpperCase()} ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ShakeTransition(
                        child: Container(
                          height: width / 1.5,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SfCalendar(
                                view: CalendarView.month,
                                initialSelectedDate: DateTime.parse(
                                    widget.event.date.toString()),
                                initialDisplayDate: DateTime.parse(
                                    widget.event.date.toString())),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 2),
                              child: Text(
                                'View event flier',
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
                                    builder: (_) => AllEvenEnlarged(
                                          exploreLocation: 'No',
                                          feed: 1,
                                          askCount: 0,
                                          currentUserId: Provider.of<UserData>(
                                                  context,
                                                  listen: false)
                                              .currentUserId!,
                                          event: widget.event,

                                          user: Provider.of<UserData>(context,
                                                  listen: false)
                                              .user!,
                                          // eventList: widget.eventList,
                                        )))),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 2),
                            child: Text(
                              'View invitation',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () => _generatePalette(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
