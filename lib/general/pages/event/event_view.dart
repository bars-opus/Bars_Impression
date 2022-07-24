import 'package:bars/utilities/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class EventView extends StatefulWidget {
  final String currentUserId;
  final Event event;
  final AccountHolder author;
  final AccountHolder? user;
  // final List<Event> eventList;
  final int feed;
  final String exploreLocation;

  EventView(
      {required this.currentUserId,
      //  required  this.eventList,
      required this.feed,
      required this.exploreLocation,
      required this.user,
      required this.event,
      required this.author});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  int _askCount = 0;
  late DateTime _date;
  late DateTime _toDaysDate;

  void initState() {
    super.initState();
    _setUpAsks();
    _countDown();
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

  _countDown() async {
    DateTime date = DateTime.parse(widget.event.date);
    final toDayDate = DateTime.now();
    setState(() {
      _date = date;
      _toDaysDate = toDayDate;
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
        FocusedMenuItem(
            title: Text(
              'Enlarge Event',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AllEvenEnlarged(
                          exploreLocation: widget.exploreLocation,
                          feed: widget.feed,
                          askCount: _askCount,
                          currentUserId: widget.currentUserId,
                          event: widget.event,
                          author: widget.author,
                          user: widget.user,
                          // eventList: widget.eventList,
                        )))),
        widget.event.authorId == widget.currentUserId
            ? FocusedMenuItem(
                title: Text(
                  'Edit event',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
                onPressed: () => _toDaysDate.isAfter(_date)
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
                title: Text(
                  "Go to ${widget.author.userName}'s profile",
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              user: widget.user,
                              currentUserId: widget.currentUserId,
                              userId: widget.event.authorId,
                            ))),
              ),
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Report',
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
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
              width: width / 2,
              child: Text(
                'Suggestion Box',
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
            ),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => SuggestionBox()))),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
        child: Slidable(
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) {
                  widget.currentUserId == widget.author.id!
                      ? _toDaysDate.isAfter(_date)
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
                                    user: widget.user,
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
          child: Stack(
            children: [
              EventViewWidget(
                currentUserId: widget.currentUserId,
                author: widget.author,
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
                              author: widget.author,
                              user: widget.user,
                              // eventList: widget.eventList,
                            ))),
                imageHero: 'image ${widget.event.id.toString()}',
                askCount: NumberFormat.compact().format(_askCount),
                titleHero: 'title ${widget.event.id.toString()}',
              ),
              Positioned(
                top: 1,
                right: 10,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AllEvenEnlarged(
                                exploreLocation: widget.exploreLocation,
                                feed: widget.feed,
                                askCount: _askCount,
                                currentUserId: widget.currentUserId,
                                event: widget.event,
                                author: widget.author,
                                user: widget.user,
                                // eventList: widget.eventList,
                              ))),
                  child: Hero(
                    tag: 'type' + widget.event.id.toString(),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 35.0,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: widget.event.report.isNotEmpty
                                ? Colors.grey
                                : Colors.blue,
                            side: BorderSide(width: 1.0, color: Colors.blue),
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
                                        : widget.event.type.startsWith('O')
                                            ? 'OT'
                                            : widget.event.type.startsWith('T')
                                                ? 'TO'
                                                : '',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: width > 800 ? 16 : 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AllEvenEnlarged(
                                        exploreLocation: widget.exploreLocation,
                                        feed: widget.feed,
                                        askCount: _askCount,
                                        currentUserId: widget.currentUserId,
                                        event: widget.event,
                                        author: widget.author,
                                        user: widget.user,
                                        // eventList: widget.eventList,
                                      ))),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
