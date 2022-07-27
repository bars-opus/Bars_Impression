import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';

class EventsAllLocation extends StatefulWidget {
  static final id = 'EventsAllLocation';
  final String currentUserId;
  final AccountHolder user;
  final String locationType;

  EventsAllLocation(
      {required this.currentUserId,
      required this.user,
      required this.locationType});
  @override
  _EventsAllLocationState createState() => _EventsAllLocationState();
}

class _EventsAllLocationState extends State<EventsAllLocation>
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
                : () {};
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
        widget.locationType.startsWith('City')
            ? _loadMoreEvents()
            : widget.locationType.startsWith('Country')
                ? _loadMoreCountryEvents()
                : widget.locationType.startsWith('Virtual')
                    ? _loadMoreVirtualEvents()
                    : () {};
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
        .where('city', isEqualTo: widget.user.city)
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
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: widget.user.city)
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

  _setupCountryEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('country', isEqualTo: widget.user.country)
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

  _loadMoreCountryEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('country', isEqualTo: widget.user.country)
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

  _setupVirtalEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('isVirtual', isEqualTo: true)
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

  _loadMoreVirtualEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('isVirtual', isEqualTo: true)
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
    return EventProfileView(
      exploreLocation: widget.locationType.startsWith('City')
          ? 'City'
          : widget.locationType.startsWith('Country')
              ? 'Country'
              : widget.locationType.startsWith('Virtual')
                  ? 'Virtual'
                  : '',
      allEvents: true,
      feed: 2,
      currentUserId: widget.currentUserId,
      event: event,
      author: author,
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
                          return EventSchimmerBlurHash(event: event,);
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
                    child: NoUsersDicovered(
                      title: 'Events',
                    ),
                  )
                : Center(
                    child: EventSchimmer(),
                  ));
  }
}
