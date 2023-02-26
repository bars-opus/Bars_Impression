import 'package:bars/utilities/exports.dart';

class FestivalEventsLocation extends StatefulWidget {
  static final id = 'FestivalEventsLocation';
  final String currentUserId;
  final AccountHolder user;
  final String locationType;
  final String type;

  FestivalEventsLocation({
    required this.currentUserId,
    required this.user,
    required this.locationType,
    required this.type,
  });
  @override
  _FestivalEventsLocationState createState() => _FestivalEventsLocationState();
}

class _FestivalEventsLocationState extends State<FestivalEventsLocation>
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
    widget.locationType.startsWith('City')
        ? _setupEventFeed()
        : widget.locationType.startsWith('Country')
            ? _setupCountryEvent()
            : widget.locationType.startsWith('Virtual')
                ? _setupVirtalEvent()
                : _nothing();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        widget.locationType.startsWith('City')
            ? _loadMoreEvents()
            : widget.locationType.startsWith('Country')
                ? _loadMoreCountryEvents()
                : widget.locationType.startsWith('Virtual')
                    ? _loadMoreVirtualEvents()
                    : _nothing();
      }
    }
    return false;
  }

  _nothing() {}

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setupEventFeed() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('city', isEqualTo: widget.user.city)
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
        .where('showOnExplorePage', isEqualTo: true)
        .where('city', isEqualTo: widget.user.city)
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

  _setupCountryEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('country', isEqualTo: widget.user.country)
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

  _loadMoreCountryEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('country', isEqualTo: widget.user.country)
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

  _setupVirtalEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('isVirtual', isEqualTo: true)
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

  _loadMoreVirtualEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('isVirtual', isEqualTo: true)
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
      exploreLocation: widget.locationType.startsWith('City')
          ? 'City'
          : widget.locationType.startsWith('Country')
              ? 'Country'
              : widget.locationType.startsWith('Virtual')
                  ? 'Virtual'
                  : '',
      currentUserId: widget.currentUserId,
      event: event,
      user: widget.user,
      feed: 3,
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
                      title: 'Festivals',
                    ),
                  )
                : Center(
                    child: EventSchimmer(),
                  ));
  }
}
