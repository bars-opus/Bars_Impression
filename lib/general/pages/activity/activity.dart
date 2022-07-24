import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityScreen extends StatefulWidget {
  static final id = 'ActivityScreen';
  final String currentUserId;
  final int activityCount;
  ActivityScreen({
    required this.currentUserId,
    required this.activityCount,
  });

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with AutomaticKeepAliveClientMixin {
  List<Activity> _activities = [];
  bool _isLoadingContent = false;
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
    QuerySnapshot userFeedSnapShot = await activitiesRef
        .doc(widget.currentUserId)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Activity> activities =
        userFeedSnapShot.docs.map((doc) => Activity.fromDoc(doc)).toList();
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
    QuerySnapshot userFeedSnapShot = await activitiesRef
        .doc(widget.currentUserId)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_activitySnapshot.last)
        .get();
    List<Activity> moreusers =
        userFeedSnapShot.docs.map((doc) => Activity.fromDoc(doc)).toList();
    if (_activitySnapshot.length < limit) _hasNext = false;
    List<Activity> activities = _activities..addAll(moreusers);
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
    Activity activity = Activity(
      id: activiities.id,
      fromUserId: activiities.fromUserId,
      postId: activiities.postId,
      postImageUrl: activiities.postImageUrl,
      seen: 'seen',
      comment: activiities.comment,
      timestamp: activiities.timestamp,
    );
    try {
      DatabaseService.editActivity(activity, widget.currentUserId);
    } catch (e) {
      print(e.toString());
    }
  }

  _buildActivity(Activity activity) {
    return FutureBuilder(
      future: DatabaseService.getUserWithId(activity.fromUserId!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        AccountHolder user = snapshot.data;
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
                onTap: activity.comment != null
                    ? () async {
                        setState(() {
                          _isLoadingContent = true;
                        });
                        String currentUserId =
                            Provider.of<UserData>(context, listen: false)
                                .currentUserId!;
                        Post post = await DatabaseService.getUserPost(
                          currentUserId,
                          activity.postId!,
                        );
                        activity.seen != 'seen'
                            ? _submit(activity)
                            : SizedBox.shrink();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommentsScreen(
                              post: post,
                              likeCount: post.likeCount,
                              dislikeCount: post.disLikeCount,
                              comment: null,
                              commentCount: 0,
                              currentUserId: widget.currentUserId,
                            ),
                          ),
                        );
                        setState(() {
                          _isLoadingContent = false;
                        });
                      }
                    : () async {
                        setState(() {
                          _isLoadingContent = true;
                        });
                        String currentUserId =
                            Provider.of<UserData>(context, listen: false)
                                .currentUserId!;
                        Post post = await DatabaseService.getUserPost(
                          currentUserId,
                          activity.postId!,
                        );
                        AccountHolder user =
                            await DatabaseService.getUserWithId(post.authorId);
                        activity.seen != 'seen'
                            ? _submit(activity)
                            : SizedBox.shrink();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllPostEnlarged(
                              currentUserId: widget.currentUserId,
                              post: post,
                              author: user,
                              feed: '',
                            ),
                          ),
                        );
                        setState(() {
                          _isLoadingContent = false;
                        });
                      },
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Color(0xFFf2f2f2),
                  backgroundImage: user.profileImageUrl!.isEmpty
                      ? AssetImage(
                          ConfigBloc().darkModeOn
                              ? 'assets/images/user_placeholder.png'
                              : 'assets/images/user_placeholder2.png',
                        ) as ImageProvider
                      : CachedNetworkImageProvider(user.profileImageUrl!),
                ),
                // ignore: unnecessary_null_comparison
                title: activity.comment != null
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Text(
                                user.userName!,
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
                            user.verified!.isEmpty
                                ? SizedBox.shrink()
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
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "vibed:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                              TextSpan(
                                text: ' ${activity.comment}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: activity.seen != ''
                                      ? Colors.grey
                                      : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Text(
                                user.userName!,
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
                            user.verified!.isEmpty
                                ? SizedBox.shrink()
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                                textScaleFactor:
                                    MediaQuery.of(context).textScaleFactor,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'liked your punch',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: activity.seen != 'seen'
                                              ? Colors.pink
                                              : Colors.grey,
                                        ))
                                  ],
                                )),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                                height: 30,
                                child: activity.seen != 'seen'
                                    ? CircularButton(
                                        color: Colors.pink,
                                        icon: Icon(Icons.favorite,
                                            color: Colors.white),
                                        onPressed: () {},
                                      )
                                    : SizedBox.shrink()),
                          ],
                        ),
                      ],
                    ),
                subtitle: Text(
                    timeago.format(
                      activity.timestamp!.toDate(),
                    ),
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
                trailing: CachedNetworkImage(
                  imageUrl: activity.postImageUrl!,
                  height: 40.0,
                  width: 40.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            )
          ],
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
          SizedBox(
            height: 5,
          ),
          widget.activityCount == 0
              ? SizedBox.shrink()
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
                            NumberFormat.compact().format(widget.activityCount),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          _isLoadingContent
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
                            Activity activity = _activities[index];
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
