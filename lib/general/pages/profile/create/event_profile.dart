import 'package:bars/general/pages/chats/send_to_chat.dart';
import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class EventProfileView extends StatefulWidget {
  final String currentUserId;
  final Event event;
  final AccountHolder user;
  final bool allEvents;
  final String exploreLocation;
  final int feed;

  EventProfileView({
    required this.currentUserId,
    required this.allEvents,
    required this.exploreLocation,
    required this.feed,
    required this.user,
    required this.event,
  });

  @override
  _EventProfileViewState createState() => _EventProfileViewState();
}

class _EventProfileViewState extends State<EventProfileView> {
  int _askCount = 0;
  late DateTime _date;
  late DateTime _toDaysDate;
  late DateTime _closingDate;

  int _different = 0;

  void initState() {
    super.initState();
    _setUpAsks();
    _countDown();
  }

  _countDown() async {
    DateTime date = DateTime.parse(widget.event.date);
    DateTime clossingDate =
        DateTime.parse(widget.event.clossingDay).add(const Duration(hours: 3));
    var different = date.difference(DateTime.now()).inDays;

    final toDayDate = DateTime.now();
    setState(() {
      _date = date;
      _toDaysDate = toDayDate;
      _closingDate = clossingDate;
      _different = different;
    });
  }

  _setUpAsks() async {
    DatabaseService.numAsks(widget.event.id).listen((askCount) {
      if (mounted) {
        setState(() {
          _askCount = askCount;
        });
      }
    });
  }

  _dynamicLink() async {
    var linkUrl = Uri.parse(widget.event.imageUrl);

    final dynamicLinkParams = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: linkUrl,
        title: 'Event',
        description: widget.event.title,
      ),
      link: Uri.parse('https://www.barsopus.com/event_${widget.event.id}'),
      uriPrefix: 'https://barsopus.com/barsImpression',
      androidParameters:
          AndroidParameters(packageName: 'com.barsOpus.barsImpression'),
      iosParameters: IOSParameters(
        bundleId: 'com.bars-Opus.barsImpression',
        appStoreId: '1610868894',
      ),
    );
    var link =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    Share.share(link.shortUrl.toString());
    // if (Platform.isIOS) {
    //   var link =
    //       await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    //   Share.share(link.toString());
    // } else {
    //   var link =
    //       await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    //   Share.share(link.shortUrl.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return FocusedMenuHolder(
        menuWidth: width,
        menuOffset: 10,
        blurBackgroundColor:
            ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white10,
        openWithTap: false,
        onPressed: () {},
        menuItems: [
          widget.event.authorId == widget.currentUserId
              ? FocusedMenuItem(
                  title: Container(
                    width: width - 40,
                    child: Center(
                      child: Text(
                        'Edit event',
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      ),
                    ),
                  ),
                  onPressed: () => _different < 1
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventCompleted(
                                date: DateFormat.yMMMMEEEEd().format(_date),
                                event: widget.event,
                                currentUserId: widget.currentUserId),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditEvent(
                                event: widget.event,
                                currentUserId: widget.currentUserId),
                          ),
                        ),
                )
              : FocusedMenuItem(
                  title: Container(
                    width: width - 40,
                    child: Center(
                      child: Text(
                        "View profile",
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                                currentUserId: widget.currentUserId,
                                userId: widget.event.authorId,
                                user: null,
                              ))),
                ),
          FocusedMenuItem(
              title: Container(
                width: width - 40,
                child: Center(
                  child: Text(
                    'Send ',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SendToChats(
                              currentUserId: widget.currentUserId,
                              userId: '',
                              sendContentType: 'Event',
                              event: widget.event,
                              post: null,
                              forum: null,
                              user: null,
                              sendContentId: widget.event.id,
                            )));
              }),
          FocusedMenuItem(
              title: Container(
                width: width - 40,
                child: Center(
                  child: Text(
                    'Share ',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
              ),
              onPressed: () => _dynamicLink()),
          FocusedMenuItem(
              title: Container(
                width: width - 40,
                child: Center(
                  child: Text(
                    'Report',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ReportContentPage(
                            contentId: widget.event.id,
                            parentContentId: widget.event.id,
                            repotedAuthorId: widget.event.authorId,
                            contentType: 'event',
                          )))),
          FocusedMenuItem(
              title: Container(
                width: width - 40,
                child: Center(
                  child: Text(
                    'Suggestion Box',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
              ),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SuggestionBox()))),
        ],
        child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AllEvenEnlargedProfile(
                          askCount: _askCount,
                          currentUserId: widget.currentUserId,
                          event: widget.event,
                          exploreLocation: widget.exploreLocation,
                          feed: widget.feed,
                          user: widget.user,
                        ))),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaleFactor:
                      MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
              child: Stack(
                children: [
                  EventViewWidget(
                    completed: _toDaysDate.isAfter(_closingDate) ? true : false,
                    currentUserId: widget.currentUserId,
                    titleHero: 'title1  ${widget.event.id.toString()}',
                    event: widget.event,
                    askCount: _askCount,
                    difference: _date.difference(_toDaysDate).inMinutes < 0
                        ? true
                        : false,
                    exploreLocation: widget.exploreLocation,
                    feed: widget.feed,
                  ),
                  Positioned(
                    top: 1,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AllEvenEnlargedProfile(
                                    currentUserId: widget.currentUserId,
                                    event: widget.event,
                                    exploreLocation: widget.exploreLocation,
                                    feed: widget.feed,
                                    user: widget.user,
                                    askCount: 0,
                                  ))),
                      child: Hero(
                        tag: 'typeProfile' + widget.event.id.toString(),
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: 35.0,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                side: BorderSide(
                                  width: 1.0,
                                  color: widget.event.report.isNotEmpty
                                      ? Colors.grey
                                      : Colors.blue,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text(
                                widget.event.type.startsWith('F')
                                    ? 'F\nE'
                                    : widget.event.type.startsWith('Al')
                                        ? 'A\nL'
                                        : widget.event.type.startsWith('Aw')
                                            ? 'A\nW'
                                            : widget.event.type.startsWith('O')
                                                ? 'O\nT'
                                                : widget.event.type
                                                        .startsWith('T')
                                                    ? 'T\nO'
                                                    : '',
                                style: TextStyle(
                                  color: widget.event.report.isNotEmpty
                                      ? Colors.grey
                                      : Colors.blue,
                                  fontSize: width > 800 ? 16 : 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AllEvenEnlargedProfile(
                                            askCount: _askCount,
                                            currentUserId: widget.currentUserId,
                                            event: widget.event,
                                            exploreLocation:
                                                widget.exploreLocation,
                                            feed: widget.feed,
                                            user: widget.user,
                                          ))),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
