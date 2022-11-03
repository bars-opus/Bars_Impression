import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

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
  late DateTime _toDaysDate = DateTime.now();

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

  _showSelectImageDialog(
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
              from.startsWith('Stop')
                  ? 'Are you sure you want to stop attending this event?'
                  : 'Are you sure you want to attend this event?',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  from.startsWith('Stop') ? 'Stop Attending' : 'Attend',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _attend(context, from, eventInvite);
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
              from.startsWith('Stop')
                  ? 'Are you sure you want to stop attending this event?'
                  : 'Are you sure you want to attend this event?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    from.startsWith('Stop') ? 'Stop Attending' : 'Attend',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _attend(context, from, eventInvite);
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

  _attend(BuildContext context, String from, EventInvite eventInvite) {
    final double width = MediaQuery.of(context).size.width;
    try {
      from.startsWith('Stop')
          ? DatabaseService.cancelInvite(eventInvite: eventInvite)
          : DatabaseService.attendEvent(
              eventDate: DateTime.parse(widget.event.date),
              message: '',
              event: widget.event,
              user: Provider.of<UserData>(context, listen: false).user!,
              requestNumber: 0.toString(),
              currentUserId:
                  Provider.of<UserData>(context, listen: false).currentUserId!);

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
          'Done',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 22 : 14,
          ),
        ),
        messageText: Text(
          from.startsWith('Stop')
              ? "Event removed from your attending list successfully."
              : "Event added to your attending list successfully.",
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

  _launchMap() {
    return MapsLauncher.launchQuery(widget.event.venue);
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
                      widget.different < 0
                          ? const SizedBox.shrink()
                          : Container(
                              decoration: BoxDecoration(
                                  // color: Colors.white,
                                  border: Border.all(
                                      width: .3, color: Colors.white),
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
                              text: _toDaysDate.isAfter(
                                      DateTime.parse(widget.event.clossingDay))
                                  ? 'Completed'
                                  : widget.different < 0
                                      ? 'Ongoing'
                                      : '\nDays More',
                              style: TextStyle(
                                fontSize: widget.different < 0 ? 30 : 14,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                                            textAlign: TextAlign.start,
                                          )
                                        : RichText(
                                            textScaleFactor:
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            text: TextSpan(children: [
                                              if (rate.length > 1)
                                                TextSpan(
                                                  text: rate[1].trim(),
                                                  style: TextStyle(
                                                    fontSize: 30.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              if (rate.length > 0)
                                                TextSpan(
                                                  text: "\n${rate[0]}\n",
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
                                            textAlign: TextAlign.start,
                                          ),
                                  ),
                                ),
                          RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${MyDateFormat.toTime(DateTime.parse(widget.event.time))}\n',
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
                      _toDaysDate
                              .isAfter(DateTime.parse(widget.event.clossingDay))
                          ? const SizedBox.shrink()
                          : Container(
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
                      _toDaysDate
                              .isAfter(DateTime.parse(widget.event.clossingDay))
                          ? const SizedBox.shrink()
                          : Container(
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
                                    widget.event.isVirtual
                                        ? 'Host link'
                                        : 'Event location',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () {
                                  widget.event.isVirtual
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => MyWebView(
                                                    url: widget
                                                        .event.virtualVenue,
                                                  )))
                                      : _launchMap();
                                },
                              ),
                            ),
                      _toDaysDate
                              .isAfter(DateTime.parse(widget.event.clossingDay))
                          ? const SizedBox.shrink()
                          : Container(
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
                                            askCount: 0,
                                            event: widget.event,
                                            ask: null,
                                            currentUserId:
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .currentUserId!,
                                          )),
                                ),
                              ),
                            ),
                      _toDaysDate
                              .isAfter(DateTime.parse(widget.event.clossingDay))
                          ? Text(
                              widget.event.title +
                                  ' Which was dated on\n' +
                                  MyDateFormat.toDate(
                                      DateTime.parse(widget.event.date)) +
                                  ' has been successfully completed. Congratulations on your attendance at this event.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  height: 1),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox.shrink(),
                      _toDaysDate
                              .isAfter(DateTime.parse(widget.event.clossingDay))
                          ? Padding(
                              padding: const EdgeInsets.only(top: 70.0),
                              child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                    height:
                                        Responsive.isDesktop(context) ? 40 : 30,
                                    width:
                                        Responsive.isDesktop(context) ? 40 : 30,
                                    child: IconButton(
                                      icon: Icon(Icons.delete_forever),
                                      iconSize: 25,
                                      color: Colors.black,
                                      onPressed: () => _showSelectImageDialog(
                                          context,
                                          widget.invite.anttendeeId.isNotEmpty
                                              ? 'Stop'
                                              : '',
                                          widget.invite),
                                    ),
                                  )),
                            )
                          : Container(
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
                                                currentUserId:
                                                    Provider.of<UserData>(
                                                            context,
                                                            listen: false)
                                                        .currentUserId!,
                                                event: widget.event,
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
