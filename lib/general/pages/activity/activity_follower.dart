import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFollowerScreen extends StatefulWidget {
  static final id = 'ActivityFollowerScreen';
  final String currentUserId;
  final int activityFollowerCount;
  ActivityFollowerScreen({
    required this.currentUserId,
    required this.activityFollowerCount,
  });

  @override
  _ActivityFollowerScreenState createState() => _ActivityFollowerScreenState();
}

class _ActivityFollowerScreenState extends State<ActivityFollowerScreen>
    with AutomaticKeepAliveClientMixin {
  List<ActivityFollower> _activities = [];
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
    QuerySnapshot userFeedSnapShot = await activitiesFollowerRef
        .doc(widget.currentUserId)
        .collection('activitiesFollower')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<ActivityFollower> activities = userFeedSnapShot.docs
        .map((doc) => ActivityFollower.fromDoc(doc))
        .toList();
    _activitySnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _activities = activities;
      });
    }
    return activities;
  }

  _loadMoreActivities() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await activitiesFollowerRef
        .doc(widget.currentUserId)
        .collection('activitiesFollower')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_activitySnapshot.last)
        .get();
    List<ActivityFollower> moreusers = userFeedSnapShot.docs
        .map((doc) => ActivityFollower.fromDoc(doc))
        .toList();
    if (_activitySnapshot.length < limit) _hasNext = false;
    List<ActivityFollower> activities = _activities..addAll(moreusers);
    _activitySnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _activities = activities;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _submit(activiities) async {
    ActivityFollower activity = ActivityFollower(
      id: activiities.id,
      fromUserId: activiities.fromUserId,
      userId: activiities.userId,
      seen: 'seen',
      timestamp: activiities.timestamp,
      authorName: activiities.authorName,
      authorProfileHanlde: activiities.authorProfileHanlde,
      authorVerification: activiities.authorVerification,
      authorProfileImageUrl: activiities.authorProfileImageUrl,
    );
    print('sumiting');
    try {
      DatabaseService.editActivityFollower(
        activity,
        widget.currentUserId,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  _buildActivity(ActivityFollower activity) {
    // return FutureBuilder(
    //     future: DatabaseService.getUserWithId(activity.fromUserId),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       if (!snapshot.hasData) {
    //         return const SizedBox.shrink();
    //       }
    //       AccountHolder author = snapshot.data;

    return Column(
      children: [
        Container(
          decoration: ConfigBloc().darkModeOn
              ? BoxDecoration(
                  color: activity.seen == 'seen'
                      ? Colors.transparent
                      : Color(0xFF2B2B28),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                      BoxShadow(
                        color: activity.seen == 'seen'
                            ? Colors.transparent
                            : Colors.black45,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: activity.seen == 'seen'
                            ? Colors.transparent
                            : Colors.black45,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      )
                    ])
              : BoxDecoration(
                  color: activity.seen == 'seen'
                      ? Colors.transparent
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                      BoxShadow(
                        color: activity.seen == 'seen'
                            ? Colors.transparent
                            : Colors.grey[500]!,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: activity.seen == 'seen'
                            ? Colors.transparent
                            : Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      )
                    ]),
          child: ListTile(
            onTap: () async {
              activity.seen != 'seen'
                  ? _submit(activity)
                  : const SizedBox.shrink();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            currentUserId:
                                Provider.of<UserData>(context).currentUserId!,
                            userId: activity.fromUserId,
                          )));
            },
            leading: activity.authorProfileImageUrl.isEmpty
                ? Icon(
                    Icons.account_circle,
                    size: 60.0,
                    color: Colors.grey,
                  )
                : CircleAvatar(
                    radius: 25.0,
                    backgroundColor: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Color(0xFFf2f2f2),
                    backgroundImage: CachedNetworkImageProvider(
                        activity.authorProfileImageUrl)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text(
                            activity.authorName,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: activity.seen == 'seen'
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        activity.authorVerification.isEmpty
                            ? const SizedBox.shrink()
                            : Positioned(
                                top: 0,
                                right: 0,
                                child: Icon(
                                  MdiIcons.checkboxMarkedCircle,
                                  size: 11,
                                  color: Colors.blue,
                                ),
                              ),
                      ],
                    ),
                    RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "${activity.authorProfileHanlde}\n",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                )),
                            TextSpan(
                                text: 'Started following you',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: activity.seen != 'seen'
                                      ? Color(0xFFD38B41)
                                      : Colors.grey,
                                ))
                          ],
                        )),
                  ],
                ),
              ],
            ),
            subtitle: Text(
                timeago.format(
                  activity.timestamp.toDate(),
                ),
                style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
        ),
        const Divider(
          color: Colors.grey,
        )
      ],
    );
    // });
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
          SizedBox(
            height: 5,
          ),
          widget.activityFollowerCount == 0
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    Padding(
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
                                .format(widget.activityFollowerCount),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        TextSpan(text: 'Fetching post please Wait... '),
                      ],
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    )),
                  ),
                )
              : const SizedBox.shrink(),
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
                            ActivityFollower activity = _activities[index];

                            return _buildActivity(activity);
                          },
                          childCount: _activities.length,
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
