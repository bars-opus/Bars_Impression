import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';

class EventsFeed extends StatefulWidget {
  static final id = 'EventsFeed';
  final String currentUserId;
  EventsFeed({
    required this.currentUserId,
  });

  @override
  _EventsFeedState createState() => _EventsFeedState();
}

class _EventsFeedState extends State<EventsFeed>
    with AutomaticKeepAliveClientMixin {
  final _eventSnapshot = <DocumentSnapshot>[];
  final _invitesSnapshot = <DocumentSnapshot>[];
  List<Event> _events = [];
  List<EventInvite> _invites = [];

  int _feedCount = 0;
  int limit = 5;
  bool _hasNext = true;
  bool _isFetchingEvent = false;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setupEventFeed();
    _setUpFeedCount();
    _setUpInvites();
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        Provider.of<UserData>(context, listen: false).setShowUsersTab(false);
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

  _setUpFeedCount() async {
    int feedCount = await DatabaseService.numFeedEvents(widget.currentUserId);
    if (mounted) {
      setState(() {
        _feedCount = feedCount;
      });
    }
  }

  _setUpInvites() async {
    QuerySnapshot invitesFeedSnapShot = await userInviteRef
        .doc(widget.currentUserId)
        .collection('eventInvite')
        .orderBy('eventTimestamp', descending: false)
        .limit(10)
        .get();
    List<EventInvite> invites = invitesFeedSnapShot.docs
        .map((doc) => EventInvite.fromDoc(doc))
        .toList();
    _invitesSnapshot.addAll((invitesFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _invites = invites;
      });
    }

    return invites;
  }

  _setupEventFeed() async {
    QuerySnapshot eventFeedSnapShot = await eventFeedsRef
        .doc(
          widget.currentUserId,
        )
        .collection('userEventFeed')
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
    QuerySnapshot eventFeedSnapShot = await eventFeedsRef
        .doc(widget.currentUserId)
        .collection('userEventFeed')
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

  _buildEventBuilder(AccountHolder user) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  Event event = _events[index];
                  return EventView(
                    exploreLocation: 'No',
                    feed: 1,
                    currentUserId: widget.currentUserId,
                    event: event,
                    user: user,
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

  _buildInviteBuilder() {
    return CustomScrollView(scrollDirection: Axis.horizontal, slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            EventInvite invite = _invites[index];
            return FutureBuilder(
                future: DatabaseService.getInviteEventWithId(invite),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  Event event = snapshot.data;
                  return EventsFeedAttendingWidget(
                    event: event,
                    invite: invite,
                  );
                });
          },
          childCount: _invites.length,
        ),
      )
    ]);
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    final AccountHolder user =
        Provider.of<UserData>(context, listen: false).user!;
    super.build(context);
    return NestedScrollView(
      controller: _hideButtonController,
      headerSliverBuilder: (context, innerBoxScrolled) => [
        SliverAppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          floating: true,
          snap: true,
          iconTheme: new IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          title: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              child: _feedCount.isNegative
                  ? const SizedBox.shrink()
                  // ignore: unnecessary_null_comparison
                  : user == null
                      ? const SizedBox.shrink()
                      : Display(
                          user: user,
                        ),
            ),
          ),
        ),
      ],
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _invites.length == 0
                  ? const SizedBox.shrink()
                  : Container(
                      height: Responsive.isDesktop(
                        context,
                      )
                          ? 100
                          : 80,
                      child: _buildInviteBuilder()),
              Divider(
                color: Colors.grey,
                thickness: .1,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: _events.length > 0
                    ? RefreshIndicator(
                        backgroundColor: Colors.white,
                        onRefresh: () async {
                          _setupEventFeed();
                          _setUpFeedCount();
                          _setUpInvites();
                        },
                        child: _buildEventBuilder(user))
                    : _feedCount.isNegative
                        ? RefreshIndicator(
                            backgroundColor: Colors.white,
                            onRefresh: () async {
                              _setupEventFeed();
                              _setUpFeedCount();
                              _setUpInvites();
                            },
                            child: SingleChildScrollView(
                                child: NoFeed(
                              title: "Set up your event feed. ",
                              subTitle:
                                  'Your event feed contains events by people you follow. You can set up your feed by exploring events and following people by tapping on the button below. You can also discover people based on account types you are interested in by tapping on the discover icon on the bottom navigation bar.',
                              buttonText: 'Explore Events',
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EventPage(
                                    currentUserId: widget.currentUserId,
                                    user: user,
                                  ),
                                ),
                              ),
                            )),
                          )
                        : Center(child: EventSchimmer()),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//display
class Display extends StatelessWidget {
  final AccountHolder user;

  Display({
    required this.user,
  });
  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.2)),
      child: FadeAnimation(
        1,
        Container(
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      'ATTEND',
                      textStyle: TextStyle(
                        fontSize: 24.0,
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FadeAnimatedText(
                      'MEET',
                      textStyle: TextStyle(
                        fontSize: 24.0,
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FadeAnimatedText(
                      'EXPLORE.',
                      textStyle: TextStyle(
                        fontSize: 24.0,
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  repeatForever: true,
                  pause: const Duration(milliseconds: 3000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true),
              Provider.of<UserData>(context, listen: false)
                      .user!
                      .score!
                      .isNegative
                  ? const SizedBox.shrink()
                  : Tooltip(
                      padding: EdgeInsets.all(20.0),
                      message: 'Explore events by people you have not followed',
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventPage(
                              currentUserId: currentUserId,
                              user: user,
                            ),
                          ),
                        ),
                        child: FadeAnimation(
                          1,
                          Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFff2f56),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 7.0, right: 20, top: 7, bottom: 7),
                                child: GestureDetector(
                                    onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EventPage(
                                              currentUserId: currentUserId,
                                              user: user,
                                            ),
                                          ),
                                        ),
                                    child: const Material(
                                        color: Colors.transparent,
                                        child: Hero(
                                          tag: 'Explore Events',
                                          child: Text(' Tap explore events',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              )),
                                        ))),
                              )),
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
