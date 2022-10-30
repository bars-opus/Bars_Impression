import 'package:bars/utilities/exports.dart';

class FestivalEventsLiveCity extends StatefulWidget {
  static final id = 'FestivalEventsLiveCity';
  final String currentUserId;
  final AccountHolder user;
  final String liveCity;
  final String type;
  final String liveCountry;
  FestivalEventsLiveCity({
    required this.currentUserId,
    required this.user,
    required this.liveCity,
    required this.liveCountry,
    required this.type,
  });
  @override
  _FestivalEventsLiveCityState createState() => _FestivalEventsLiveCityState();
}

class _FestivalEventsLiveCityState extends State<FestivalEventsLiveCity>
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
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: widget.liveCity)
        .where('country', isEqualTo: widget.liveCountry)
        .where('type', isEqualTo: widget.type)
        .limit(limit)
        .get();
    List<Event> events = eventFeedSnapShot.docs
        .map((doc) => Event.fromDoc(doc))
        .toList()
      ..shuffle();
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
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: widget.liveCity)
        .where('country', isEqualTo: widget.liveCountry)
        .where('type', isEqualTo: widget.type)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents = eventFeedSnapShot.docs
        .map((doc) => Event.fromDoc(doc))
        .toList()
      ..shuffle();
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

  _displayEvents(
    Event event,
  ) {
    return EventView(
      exploreLocation: 'Live',
      feed: 3,
      currentUserId: widget.currentUserId,
      event: event,
      user: widget.user,

      // eventList: _events,
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
                  return _displayEvents(
                    event,
                  );
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
                    child: NoUsersDicovered(
                      title: 'Festivals\n in ${widget.liveCity}',
                    ),
                  )
                : Center(
                    child: EventSchimmer(),
                  ));
  }
}
