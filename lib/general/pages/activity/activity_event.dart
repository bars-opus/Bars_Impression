import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityEventScreen extends StatefulWidget {
  static final id = 'ActivityEventScreen';
  final String currentUserId;
  final int activityEventCount;
  ActivityEventScreen(
      {required this.currentUserId, required this.activityEventCount});

  @override
  _ActivityEventScreenState createState() => _ActivityEventScreenState();
}

class _ActivityEventScreenState extends State<ActivityEventScreen>
    with AutomaticKeepAliveClientMixin {
  List<ActivityEvent> _activitiesEvent = [];
  int _askCount = 0;
  bool _isLoading = false;
  final _activitySnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setupActivities();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreActivities();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setupActivities() async {
    QuerySnapshot userFeedSnapShot = await activitiesEventRef
        .doc(widget.currentUserId)
        .collection('userActivitiesEvent')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<ActivityEvent> activities =
        userFeedSnapShot.docs.map((doc) => ActivityEvent.fromDoc(doc)).toList();
    _activitySnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _activitiesEvent = activities;
      });
    }
    return activities;
  }

  _loadMoreActivities() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await activitiesEventRef
        .doc(widget.currentUserId)
        .collection('userActivitiesEvent')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_activitySnapshot.last)
        .get();
    List<ActivityEvent> moreusers =
        userFeedSnapShot.docs.map((doc) => ActivityEvent.fromDoc(doc)).toList();
    if (_activitySnapshot.length < limit) _hasNext = false;
    List<ActivityEvent> activities = _activitiesEvent..addAll(moreusers);
    _activitySnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _activitiesEvent = activities;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _submit(activiitiesEvent) async {
    ActivityEvent activityEvent = ActivityEvent(
      id: activiitiesEvent.id,
      fromUserId: activiitiesEvent.fromUserId,
      seen: 'seen',
      eventId: activiitiesEvent.eventId,
      eventTitle: activiitiesEvent.eventTitle,
      eventImageUrl: activiitiesEvent.eventImageUrl,
      ask: activiitiesEvent.ask,
      timestamp: activiitiesEvent.timestamp,
    );
    print('sumiting');
    try {
      DatabaseService.editActivityEvent(activityEvent, widget.currentUserId);
    } catch (e) {
      print(e.toString());
    }
  }

  _buildActivity(ActivityEvent activityEvent) {
    return FutureBuilder(
      future: DatabaseService.getUserWithId(activityEvent.fromUserId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        AccountHolder user = snapshot.data;
        return ActivityImageTile(
          seen: activityEvent.seen,
          verified: user.verified!,
          profileImageUrl: user.profileImageUrl!,
          activityIndicator: "asked about:  ",
          activityTitle: activityEvent.eventTitle,
          activityContent: activityEvent.ask,
          activityImage: activityEvent.eventImageUrl,
          activityTime: timeago.format(
            activityEvent.timestamp.toDate(),
          ),
          userName: user.userName!,
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            String currentUserId =
                Provider.of<UserData>(context, listen: false).currentUserId;
            Event event = await DatabaseService.getUserEvent(
              currentUserId,
              activityEvent.eventId,
            );
            DatabaseService.numAsks(event.id).listen((askCount) {
              if (mounted) {
                setState(() {
                  _askCount = askCount;
                });
              }
            });
            activityEvent.seen != 'seen'
                ? _submit(activityEvent)
                : SizedBox.shrink();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AsksScreen(
                  event: event,
                  ask: null,
                  askCount: _askCount,
                  author: user,
                  currentUserId: widget.currentUserId,  
                ),
              ),
            );
            setState(() {
              _isLoading = false;
            });
          },
        );
      },
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.activityEventCount == 0
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        color: Colors.red),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 2, bottom: 2),
                      child: Text(
                        NumberFormat.compact()
                            .format(widget.activityEventCount),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Shimmer.fromColors(
                    period: Duration(milliseconds: 1000),
                    baseColor: Colors.grey,
                    highlightColor: Colors.blue,
                    child: RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(text: 'Fetching event please Wait... '),
                      ],
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    )),
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _setupActivities(),
              child: NotificationListener<ScrollNotification>(
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
                            ActivityEvent activityEvent =
                                _activitiesEvent[index];

                            return _buildActivity(activityEvent);
                          },
                          childCount: _activitiesEvent.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
