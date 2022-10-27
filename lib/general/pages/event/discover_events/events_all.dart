import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';
import 'package:async/async.dart';

class EventsAll extends StatefulWidget {
  static final id = 'EventsAll';
  final String currentUserId;
  final AccountHolder? user;
  EventsAll({
    required this.currentUserId,
    required this.user,
  });
  @override
  _EventsAllState createState() => _EventsAllState();
}

class _EventsAllState extends State<EventsAll>
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
    QuerySnapshot eventFeedSnapShot = await allEventsRef
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

  // _displayEvents(Event event, AccountHolder author) {
  //   return EventProfileView(
  //     exploreLocation: ' ',
  //     allEvents: true,
  //     currentUserId: widget.currentUserId,
  //     event: event,
  //     feed: 2,
  //     // author: author,
  //     user: widget.user!,
  //   );
  // }

  // Future _fetchData(String authorId) async {
  //   return this._memoizer.runOnce(() async {
  //     final user = await DatabaseService.getUserWithId(authorId);
  //     return user;
  //   });
  // }

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
                  return EventProfileView(
                    exploreLocation: ' ',
                    allEvents: true,
                    currentUserId: widget.currentUserId,
                    event: event,
                    feed: 2,
                    // author: author,
                    user: widget.user!,
                  );

                  // FutureBuilder(
                  //     future: _fetchData(event.authorId),
                  //     // DatabaseService.getUserWithId(event.authorId),
                  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //       if (!snapshot.hasData) {
                  //         return EventSchimmerBlurHash(
                  //           event: event,
                  //         );
                  //       }
                  //       AccountHolder author = snapshot.data;

                  //       return _displayEvents(event, author);
                  //     });
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

class MyBuilder extends StatelessWidget {
  const MyBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
