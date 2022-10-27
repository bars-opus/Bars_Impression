import 'package:bars/utilities/exports.dart';

class AlbumLaunches extends StatefulWidget {
  static final id = 'AlbumLaunches';
  final String currentUserId;
  final AccountHolder user;
  AlbumLaunches({
    required this.currentUserId,
    required this.user,
  });
  @override
  _AlbumLaunchesState createState() => _AlbumLaunchesState();
}

class _AlbumLaunchesState extends State<AlbumLaunches>
    with AutomaticKeepAliveClientMixin {
  List<Event> _events = [];
  final _eventSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFetchingEvent = false;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setupEventFeed();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreEvents();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setupEventFeed() async {
    QuerySnapshot eventFeedSnapShot = await eventTypesRef
        .doc('Album_Launch')
        .collection('Album_Launch')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _events = events;
      });
    }
    return events;
  }

  _loadMoreEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await eventTypesRef
        .doc('Album_Launch')
        .collection('Album_Launch')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _events..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _events = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _displayEvents(Event event, AccountHolder author) {
    return EventView(
      exploreLocation: '',
      feed: 3,
      currentUserId: widget.currentUserId,
      event: event,
      // eventList: _events,
      user: widget.user,
    );
  }

  _buildUser() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scrollbar(
        controller: _hideButtonController,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _hideButtonController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  Event event = _events[index];
                  return FutureBuilder(
                      future: DatabaseService.getUserWithId(event.authorId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return EventSchimmerBlurHash(
                            event: event,
                          );
                        }
                        AccountHolder author = snapshot.data;

                        return _displayEvents(event, author);
                      });
                },
                childCount: _events.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
        body: _events.length > 0
            ? RefreshIndicator(
                backgroundColor: Colors.white,
                onRefresh: () async {
                  _setupEventFeed();
                },
                child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _buildUser()))
            : _events.length == 0
                ? Center(
                    child: EventSchimmer(),
                  )
                : Center(
                    child: EventSchimmer(),
                  ));
  }
}
