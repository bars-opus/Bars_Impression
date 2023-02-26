import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';

class EventsAllLiveCity extends StatefulWidget {
  static final id = 'EventsAllLiveCity';
  final String currentUserId;
  final AccountHolder user;
  final String liveCity;
  final String liveCountry;
  EventsAllLiveCity({
    required this.currentUserId,
    required this.user,
    required this.liveCity,
    required this.liveCountry,
  });
  @override
  _EventsAllLiveCityState createState() => _EventsAllLiveCityState();
}

class _EventsAllLiveCityState extends State<EventsAllLiveCity>
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
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        Provider.of<UserData>(context, listen: false).setShowEventTab(true);
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        Provider.of<UserData>(context, listen: false).setShowEventTab(false);
      }
    });
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
        .where('showOnExplorePage', isEqualTo: true)
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
        .where('showOnExplorePage', isEqualTo: true)
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
    return EventProfileView(
      exploreLocation: 'Live',
      feed: 2,
      allEvents: true,
      currentUserId: widget.currentUserId,
      event: event,
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
                  return _displayEvents(event);
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
                      title: 'Events\n in ${widget.liveCity}',
                    ),
                  )
                : Center(
                    child: EventSchimmer(),
                  ));
  }
}
