// import 'dart:ui';
import 'package:bars/utilities/exports.dart';

class EventEnlargedWidget extends StatefulWidget {
  final String closeHero;
  final String titleHero;
  final String imageHero;
  final Event event;
  final VoidCallback onPressedEventEnlarged;
  final VoidCallback onPressedLocationMap;
  final VoidCallback onPressedAttend;
  final VoidCallback onPressedCalendar;
  final VoidCallback onPressedEventticketSite;
  final VoidCallback onPressedPreviousEvent;
  final VoidCallback onPressedPeople;
  final VoidCallback onPressedAsk;

  EventEnlargedWidget({
    required this.event,
    required this.closeHero,
    required this.titleHero,
    required this.imageHero,
    required this.onPressedEventEnlarged,
    required this.onPressedEventticketSite,
    required this.onPressedAttend,
    required this.onPressedLocationMap,
    required this.onPressedPreviousEvent,
    required this.onPressedAsk,
    required this.onPressedCalendar,
    required this.onPressedPeople,
  });

  @override
  _EventEnlargedWidgetState createState() => _EventEnlargedWidgetState();
}

class _EventEnlargedWidgetState extends State<EventEnlargedWidget> {
  late DateTime _date;
  late DateTime _closingDate;
  late DateTime _toDaysDate;
  int _different = 0;
  bool _displayWarning = false;
  bool _warningAnim = false;
  Color lightVibrantColor = Colors.white;
  late Color lightMutedColor;

  @override
  void initState() {
    super.initState();
    _countDown();
    _displayWarning = widget.event.report.isNotEmpty ? true : false;
  }

  _countDown() async {
    DateTime date = DateTime.parse(widget.event.date);
    DateTime clossingDate = DateTime.parse(widget.event.clossingDay);
    final toDayDate = DateTime.now();

    var different = date.difference(toDayDate).inDays;

    setState(() {
      _different = different;
      _date = date;
      _toDaysDate = toDayDate;
      _closingDate = clossingDate;
    });
    return _date;
  }

  _setContentWarning() {
    if (mounted) {
      setState(() {
        _warningAnim = true;
        _displayWarning = false;
      });
    }

    Timer(Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _warningAnim = false;
        });
      }
    });
  }

  _pop() {
    Navigator.pop(context);
    Provider.of<UserData>(context, listen: false).setPost9('');
  }

  _dynamicLink() async {
    var linkUrl = await Uri.parse(widget.event.imageUrl);

    final dynamicLinkParams = await DynamicLinkParameters(
      socialMetaTagParameters: await SocialMetaTagParameters(
        imageUrl: linkUrl,
        title: 'Event',
        description: widget.event.title,
      ),
      link: Uri.parse('https://www.barsopus.com/event_${widget.event.id}'),
      uriPrefix: 'https://barsopus.com/barsImpression/',
      androidParameters:
          AndroidParameters(packageName: 'com.barsOpus.barsImpression'),
      iosParameters: IOSParameters(
        bundleId: 'com.bars-Opus.barsImpression',
        appStoreId: '1610868894',
      ),
    );
    if (Platform.isIOS) {
      var link =
          await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

      Share.share(link.toString());
    } else {
      var link =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      Share.share(link.shortUrl.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final List<String> namePartition = widget.event.title.split(" ");
    final List<String> datePartition =
        MyDateFormat.toDate(DateTime.parse(widget.event.date)).split(" ");
    final List<String> timePartition =
        MyDateFormat.toTime(DateTime.parse(widget.event.time)).split(" ");
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return ResponsiveScaffold(
      child: Center(
        child: _displayWarning == true
            ? Hero(
                tag: widget.imageHero,
                child: Material(
                  child: Stack(children: <Widget>[
                    ContentWarning(
                      report: widget.event.report,
                      onPressed: _setContentWarning,
                      imageUrl: widget.event.imageUrl,
                    ),
                    Positioned(
                      top: 50,
                      left: 10,
                      child: IconButton(
                        icon: Icon(Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back),
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Color(0xFFe8f3fa),
                        onPressed: _pop,
                      ),
                    )
                  ]),
                ))
            : Stack(alignment: FractionalOffset.topCenter, children: <Widget>[
                Hero(
                  tag: widget.imageHero,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Color(0xFFeff0f2),
                        image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(widget.event.imageUrl),
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
                      child: ListView(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 30,
                  child: Hero(
                    tag: widget.closeHero,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        iconSize: 30.0,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: width / 2 - 20,
                  child: widget.event.isPrivate
                      ? RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "P",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              TextSpan(
                                  text: "rivate",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      color: Colors.white)),
                            ],
                          ))
                      : RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "P",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              TextSpan(
                                  text: "ublic",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      color: Colors.white)),
                            ],
                          )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 130.0, left: 10.0, right: 10.0),
                  child: Container(
                    child: SingleChildScrollView(
                      child: _toDaysDate.isAfter(_closingDate)
                          ? EventCompletedWidget(
                              date: widget.event.date,
                              onPressed: widget.onPressedPreviousEvent,
                              type: widget.event.type,
                              title: widget.event.title,
                              time: widget.event.time,
                              previousEvent: widget.event.previousEvent,
                            )
                          : Column(
                              children: <Widget>[
                                widget.event.authorId ==
                                        Provider.of<UserData>(context)
                                            .currentUserId!
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20,
                                            right: 30,
                                            bottom: 40,
                                            left: 30.0),
                                        child: Center(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: TextButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                                onPrimary: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
                                                ),
                                              ),
                                              onPressed: widget.onPressedAttend,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  'Go to your dashboard',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                ShakeTransition(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Tooltip(
                                        padding: EdgeInsets.all(20.0),
                                        message: widget.event.type
                                                .startsWith('F')
                                            ? 'FESTIVAL'
                                            : widget.event.type.startsWith('Al')
                                                ? 'ALBUM LAUNCH'
                                                : widget.event.type
                                                        .startsWith('Aw')
                                                    ? 'AWARD'
                                                    : widget.event.type
                                                            .startsWith('O')
                                                        ? 'OTHERS'
                                                        : widget.event.type
                                                                .startsWith('T')
                                                            ? 'TOUR'
                                                            : '',
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            width: 35.0,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                primary: Colors.blue,
                                                side: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white),
                                              ),
                                              child: Text(
                                                widget.event.type
                                                        .startsWith('F')
                                                    ? 'FE'
                                                    : widget.event.type
                                                            .startsWith('Al')
                                                        ? 'AL'
                                                        : widget.event.type
                                                                .startsWith(
                                                                    'Aw')
                                                            ? 'AW'
                                                            : widget.event.type
                                                                    .startsWith(
                                                                        'O')
                                                                ? 'OT'
                                                                : widget.event
                                                                        .type
                                                                        .startsWith(
                                                                            'T')
                                                                    ? 'TO'
                                                                    : '',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              onPressed: () => () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ShakeTransition(
                                  axis: Axis.vertical,
                                  child: new Material(
                                    color: Colors.transparent,
                                    child: RichText(
                                      textScaleFactor: MediaQuery.of(context)
                                          .textScaleFactor,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                namePartition[0].toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 50,
                                                color: lightVibrantColor,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  const BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(0, 10),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 3.0,
                                                  )
                                                ]),
                                          ),
                                          if (namePartition.length > 1)
                                            TextSpan(
                                              text:
                                                  "\n${namePartition[1].toUpperCase()} ",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: lightVibrantColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                            ),
                                          if (namePartition.length > 2)
                                            TextSpan(
                                              text:
                                                  "\n${namePartition[2].toUpperCase()} ",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: lightVibrantColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                            ),
                                          if (namePartition.length > 3)
                                            TextSpan(
                                              text:
                                                  "\n${namePartition[3].toUpperCase()} ",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: lightVibrantColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                            ),
                                          if (namePartition.length > 4)
                                            TextSpan(
                                              text:
                                                  "\n${namePartition[4].toUpperCase()} ",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: lightVibrantColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                            ),
                                          if (namePartition.length > 5)
                                            TextSpan(
                                              text:
                                                  "\n${"namePartition"[5].toUpperCase()} ",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: lightVibrantColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                            ),
                                          if (namePartition.length > 6)
                                            TextSpan(
                                              text:
                                                  "\n${"namePartition"[6].toUpperCase()} ",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: lightVibrantColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                            ),
                                          if (namePartition.length > 7)
                                            TextSpan(
                                              text:
                                                  "\n${"namePartition"[7].toUpperCase()} ",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: lightVibrantColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                            ),
                                          if (namePartition.length > 8)
                                            TextSpan(
                                              text:
                                                  "\n${"namePartition"[8].toUpperCase()} ",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: lightVibrantColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                            ),
                                          if (namePartition.length > 9)
                                            TextSpan(
                                              text:
                                                  "\n${"namePartition"[9].toUpperCase()} ",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: lightVibrantColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                            ),
                                          if (namePartition.length > 10)
                                            TextSpan(
                                              text:
                                                  "\n${"namePartition"[10].toUpperCase()} ",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: lightVibrantColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                            ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                ShakeTransition(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 1.0,
                                        width: 200,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      textScaleFactor: MediaQuery.of(context)
                                          .textScaleFactor,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                datePartition[0].toUpperCase(),
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        height: 50,
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                    RichText(
                                      textScaleFactor: MediaQuery.of(context)
                                          .textScaleFactor,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                timePartition[0].toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (timePartition.length > 1)
                                            TextSpan(
                                              text:
                                                  "\n${timePartition[1].toUpperCase()} ",
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          if (timePartition.length > 2)
                                            TextSpan(
                                              text:
                                                  "\n${timePartition[2].toUpperCase()} ",
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                ShakeTransition(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0),
                                    child: Text(
                                      widget.event.theme,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ShakeTransition(
                                  child: RichText(
                                    textScaleFactor:
                                        MediaQuery.of(context).textScaleFactor,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                'This event would be hosted by ' +
                                                    widget.event.host,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            )),
                                        TextSpan(
                                            text: widget.event.isVirtual
                                                ? 'and be a vitual event'
                                                : ' and would take place at ' +
                                                    widget.event.venue,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            )),
                                        TextSpan(
                                            text: widget.event.guess.isEmpty
                                                ? ''
                                                : ' With special guessess like ' +
                                                    widget.event.guess +
                                                    ' attending, ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            )),
                                        TextSpan(
                                            text: widget.event.artist.isEmpty
                                                ? ''
                                                : ' and the following artist would be performing ' +
                                                    widget.event.artist,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, right: 0.0, bottom: 0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        top: 00.0,
                                        right: 0.0,
                                        bottom: 0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        ShakeTransition(
                                          axis: Axis.vertical,
                                          child: Container(
                                            color: Colors.white,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 5.0),
                                                child: RichText(
                                                    textScaleFactor:
                                                        MediaQuery.of(context)
                                                            .textScaleFactor,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: "RATE: ",
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .black)),
                                                        TextSpan(
                                                            text:
                                                                " ${widget.event.rate} ",
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        ShakeTransition(
                                          child: Container(
                                            color: Colors.white,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 5.0),
                                                child: RichText(
                                                    textScaleFactor:
                                                        MediaQuery.of(context)
                                                            .textScaleFactor,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "Dress Code: ",
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .black)),
                                                        TextSpan(
                                                            text:
                                                                " ${widget.event.dressCode} ",
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        ShakeTransition(
                                          axis: Axis.vertical,
                                          child: Container(
                                            color: Colors.white,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 5.0),
                                                child: RichText(
                                                    textScaleFactor:
                                                        MediaQuery.of(context)
                                                            .textScaleFactor,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: "Dj: ",
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .black)),
                                                        TextSpan(
                                                            text:
                                                                " ${widget.event.dj} ",
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        ShakeTransition(
                                            child: Material(
                                                color: Colors.transparent,
                                                child: widget.event.isVirtual
                                                    ? IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .live_tv_outlined,
                                                          color: Colors.white,
                                                        ),
                                                        iconSize: 30.0,
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      MyWebView(
                                                                        url: widget
                                                                            .event
                                                                            .virtualVenue,
                                                                      )));
                                                        },
                                                      )
                                                    : IconButton(
                                                        icon: Icon(
                                                          Icons.location_on,
                                                          color: Colors.white,
                                                        ),
                                                        iconSize: 30.0,
                                                        onPressed: widget
                                                            .onPressedLocationMap,
                                                      ))),
                                        IconButton(
                                          icon: Icon(
                                            Icons.event_available,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                          onPressed: widget.onPressedCalendar,
                                        ),
                                        widget.event.guess.isEmpty ||
                                                widget.event.artist.isEmpty
                                            ? const SizedBox.shrink()
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.account_circle,
                                                  color: Colors.white,
                                                  size: 30.0,
                                                ),
                                                onPressed:
                                                    widget.onPressedPeople,
                                              ),
                                        widget.event.authorId ==
                                                Provider.of<UserData>(context)
                                                    .currentUserId!
                                            ? SizedBox.shrink()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0, top: 70),
                                                child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: ShakeTransition(
                                                      axis: Axis.vertical,
                                                      child: Container(
                                                        width: 150.0,
                                                        child: OutlinedButton(
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            primary:
                                                                Colors.blue,
                                                            side: BorderSide(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .white),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              'Attend',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: widget
                                                              .onPressedAttend,
                                                        ),
                                                      ),
                                                    ))),
                                        widget.event.authorId ==
                                                Provider.of<UserData>(context)
                                                    .currentUserId!
                                            ? const SizedBox(height: 70)
                                            : SizedBox.shrink(),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 70.0,
                                            ),
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: ShakeTransition(
                                                  axis: Axis.vertical,
                                                  child: Container(
                                                    width: 150.0,
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        primary: Colors.blue,
                                                        side: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                Colors.white),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          'Ask more',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed:
                                                          widget.onPressedAsk,
                                                    ),
                                                  ),
                                                ))),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 3,
                                                ),
                                                child: _different < 1
                                                    ? RichText(
                                                        textScaleFactor:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaleFactor,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Ongoing...',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  '\nThis event is still in progress.\nIt would be completed on\n${MyDateFormat.toDate(DateTime.parse(widget.event.clossingDay))}.\nAttend, meet and explore.',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    : RichText(
                                                        textScaleFactor:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaleFactor,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: _different
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  '\nDays\nMore',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Container(
                                                  color: Colors.white,
                                                  width: 30,
                                                  height: 1,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Container(
                                                  color: Colors.white,
                                                  width: 30,
                                                  height: 1,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Container(
                                                  color: Colors.white,
                                                  width: 30,
                                                  height: 1,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3.0),
                                                child: Text(
                                                  widget.event.type
                                                          .startsWith('Fe')
                                                      ? 'Festival'
                                                      : widget.event.type
                                                              .startsWith('Al')
                                                          ? 'Album Launch'
                                                          : widget.event.type
                                                                  .startsWith(
                                                                      'Aw')
                                                              ? 'Award'
                                                              : widget.event
                                                                      .type
                                                                      .startsWith(
                                                                          'O')
                                                                  ? 'Others'
                                                                  : widget.event
                                                                          .type
                                                                          .startsWith(
                                                                              'T')
                                                                      ? 'Tour'
                                                                      : '',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Bessita',
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        const SizedBox(
                                          height: 70,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            widget.event.previousEvent.isEmpty
                                                ? SizedBox.shrink()
                                                : GestureDetector(
                                                    onTap: widget
                                                        .onPressedPreviousEvent,
                                                    child: Text(
                                                      'Previous Event',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                            widget.event.ticketSite.isEmpty ||
                                                    widget.event.previousEvent
                                                        .isEmpty
                                                ? SizedBox.shrink()
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Container(
                                                      width: 1,
                                                      height: 30,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                            widget.event.ticketSite.isEmpty
                                                ? SizedBox.shrink()
                                                : GestureDetector(
                                                    onTap: widget
                                                        .onPressedEventticketSite,
                                                    child: Text(
                                                      ' Event Ticket ',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "This event would be completed on\n${MyDateFormat.toDate(DateTime.parse(widget.event.clossingDay))}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            SendToChats(
                                                              currentUserId: Provider.of<
                                                                          UserData>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .currentUserId!,
                                                              userId: '',
                                                              sendContentType:
                                                                  'Event',
                                                              event:
                                                                  widget.event,
                                                              post: null,
                                                              forum: null,
                                                              user: null,
                                                              sendContentId:
                                                                  widget
                                                                      .event.id,
                                                            )));
                                              },
                                              child: Text(
                                                'Send     ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Container(
                                                width: 1,
                                                height: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => _dynamicLink(),
                                              child: Text(
                                                '    Share',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 200,
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            iconSize: 30.0,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
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
                    ),
                  ),
                ),
                _warningAnim
                    ? Container(
                        height: height,
                        width: double.infinity,
                        color: Colors.black.withOpacity(.9),
                        child: Animator(
                          duration: Duration(seconds: 1),
                          tween: Tween(begin: 0.5, end: 1.4),
                          builder: (context, anim, child) => ShakeTransition(
                            child: Icon(
                              MdiIcons.eye,
                              color: Colors.grey,
                              size: 150.0,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ]),
      ),
    );
  }
}
