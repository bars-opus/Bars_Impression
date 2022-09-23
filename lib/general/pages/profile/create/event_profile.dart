import 'package:bars/utilities/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class EventProfileView extends StatefulWidget {
  final String currentUserId;
  final Event event;
  final AccountHolder author;
  final AccountHolder user;
  final bool allEvents;
  final String exploreLocation;
  final int feed;

  EventProfileView(
      {required this.currentUserId,
      required this.allEvents,
      required this.exploreLocation,
      required this.feed,
      required this.user,
      required this.event,
      required this.author});

  @override
  _EventProfileViewState createState() => _EventProfileViewState();
}

class _EventProfileViewState extends State<EventProfileView> {
  int _askCount = 0;
  late DateTime _date;
  late DateTime _toDaysDate;
  late DateTime _closingDate;

  void initState() {
    super.initState();
    _setUpAsks();
    _countDown();
  }

  _countDown() async {
    DateTime date = DateTime.parse(widget.event.date);
    DateTime clossingDate = DateTime.parse(widget.event.clossingDay);

    final toDayDate = DateTime.now();
    setState(() {
      _date = date;
      _toDaysDate = toDayDate;
      _closingDate = clossingDate;
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
                  onPressed: () => _toDaysDate.isAfter(_closingDate)
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
                        "Go to ${widget.author.userName}'s profile",
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
        child: Slidable(
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) {
                  widget.currentUserId == widget.author.id!
                      ? _toDaysDate.isAfter(_closingDate)
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
                            )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    currentUserId: widget.currentUserId,
                                    userId: widget.event.authorId,
                                  )));
                },
                backgroundColor: ConfigBloc().darkModeOn
                    ? Color(0xFF1f2022)
                    : Color(0xFFf2f2f2),
                foregroundColor: Colors.grey,
                icon: widget.currentUserId == widget.author.id!
                    ? Icons.edit
                    : Icons.account_circle,
                label: widget.currentUserId == widget.author.id!
                    ? 'Edit event'
                    : 'Profile page ',
              ),
            ],
          ),
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
                      currentUserId: widget.currentUserId,
                      author: widget.author,
                      titleHero: 'title1  ${widget.event.id.toString()}',
                      event: widget.event,
                      onPressedEventEnlarged: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AllEvenEnlarged(
                                    exploreLocation: widget.exploreLocation,
                                    feed: widget.feed,
                                    askCount: _askCount,
                                    currentUserId: widget.currentUserId,
                                    event: widget.event,
                                    user: widget.user,
                                  ))),
                      imageHero: 'image1 ${widget.event.id.toString()}',
                      askCount: NumberFormat.compact().format(_askCount),
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
                                  primary: Colors.blue,
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
                                      ? 'FE'
                                      : widget.event.type.startsWith('Al')
                                          ? 'AL'
                                          : widget.event.type.startsWith('Aw')
                                              ? 'AW'
                                              : widget.event.type
                                                      .startsWith('O')
                                                  ? 'OT'
                                                  : widget.event.type
                                                          .startsWith('T')
                                                      ? 'TO'
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
                                              currentUserId:
                                                  widget.currentUserId,
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
              )),
        ));
  }
}
