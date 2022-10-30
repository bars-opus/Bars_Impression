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

    widget.event.isPrivate
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AttendEvent(
                      event: widget.event,
                      currentUserId:
                          Provider.of<UserData>(context, listen: false)
                              .currentUserId!,
                      palette: _paletteGenerator,
                    )),
          )
        : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => EventPublicInviteAvailable(
                      event: widget.event,
                      palette: _paletteGenerator,
                      eventInvite: widget.invite,
                    )),
          );
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
    final List<String> datePartition =
        MyDateFormat.toDate(DateTime.parse(widget.event.date)).split(" ");
    return ResponsiveScaffold(
      child: Material(
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
                      image: CachedNetworkImageProvider(
                          widget.invite.eventImageUrl),
                      fit: BoxFit.cover,
                    )),
                child: Container(
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                    Colors.black.withOpacity(.5),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            border: Border.all(width: .3, color: Colors.white),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10),
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.different.toString(),
                                  style: TextStyle(
                                    fontSize: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\nDays More',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // RichText(
                      //   textScaleFactor:
                      //       MediaQuery.of(context).textScaleFactor,
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text: widget.different < 1
                      //             ? 'Ongoing...'
                      //             : widget.different.toString(),
                      //         style: TextStyle(
                      //           fontSize: widget.different < 1 ? 30 : 50,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: widget.different < 1
                      //             ? '\nThis event is still in progress.\nIt would be completed on\n${MyDateFormat.toDate(DateTime.parse(widget.event.clossingDay))}.\nAttend, meet and explore.'
                      //             : '\nDays\nMore',
                      //         style: TextStyle(
                      //             fontSize: widget.different < 1 ? 12 : 16,
                      //             fontWeight: widget.different < 1
                      //                 ? FontWeight.normal
                      //                 : FontWeight.bold,
                      //             color: Colors.white,
                      //             height: 1),
                      //       ),
                      //     ],
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Container(
                          color: Colors.white,
                          height: .3,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          widget.event.rate.isEmpty
                              ? const SizedBox.shrink()
                              : ShakeTransition(
                                  child: Center(
                                    child: widget.event.rate.startsWith('free')
                                        ? RichText(
                                            textScaleFactor:
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: 'Free\n',
                                                style: TextStyle(
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    'This event is free. \nSwag up, attend,\nmeet and experience.',
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
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: rate[1],
                                                style: TextStyle(
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "\n${rate[0]}\n\n",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                text: widget.event.isCashPayment
                                                    ? 'The payment method\nfor this event is cash. '
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
                          // Text(
                          //   MyDateFormat.toTime(
                          //       DateTime.parse(widget.event.time)),
                          //   style: TextStyle(
                          //     fontSize: 25,
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          //   textAlign: TextAlign.start,
                          // ),
                          RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: MyDateFormat.toTime(
                                      DateTime.parse(widget.event.time)),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                      // const SizedBox(
                      //   height: 40,
                      // ),
                      // const Divider(
                      //   color: Colors.white,
                      // ),

                      const SizedBox(
                        height: 40,
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
                              'Invitation',
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
                              'Ask question',
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
                                builder: (_) => AsksScreen(
                                      event: widget.event,
                                      ask: null,
                                      currentUserId: Provider.of<UserData>(
                                              context,
                                              listen: false)
                                          .currentUserId!,
                                    )),
                          ),
                        ),
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
                                'Event flier',
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
                                          // user: Provider.of<UserData>(context,
                                          //         listen: false)
                                          //     .user!,
                                        )))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 30.0,
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
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
    );
  }
}
