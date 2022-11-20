import 'package:bars/utilities/exports.dart';
import 'package:bars/widgets/general_widget/activity_reacted.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityForumScreen extends StatefulWidget {
  static final id = 'ActivityForumScreen';
  final String currentUserId;
  final int activityForumCount;
  ActivityForumScreen(
      {required this.currentUserId, required this.activityForumCount});

  @override
  _ActivityForumScreenState createState() => _ActivityForumScreenState();
}

class _ActivityForumScreenState extends State<ActivityForumScreen>
    with AutomaticKeepAliveClientMixin {
  List<ActivityForum> _activitiesForum = [];
  int _thoughtCount = 0;
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
    QuerySnapshot userFeedSnapShot = await activitiesForumRef
        .doc(widget.currentUserId)
        .collection('userActivitiesForum')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<ActivityForum> activities =
        userFeedSnapShot.docs.map((doc) => ActivityForum.fromDoc(doc)).toList();
    _activitySnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _activitiesForum = activities;
      });
    }
    return activities;
  }

  _loadMoreActivities() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await activitiesForumRef
        .doc(widget.currentUserId)
        .collection('userActivitiesForum')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_activitySnapshot.last)
        .get();
    List<ActivityForum> moreusers =
        userFeedSnapShot.docs.map((doc) => ActivityForum.fromDoc(doc)).toList();
    if (_activitySnapshot.length < limit) _hasNext = false;
    List<ActivityForum> activities = _activitiesForum..addAll(moreusers);
    _activitySnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _activitiesForum = activities;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _submit(activiitiesForum) async {
    ActivityForum activityForum = ActivityForum(
      forumAuthorId: activiitiesForum.forumAuthorId,
      id: activiitiesForum.id,
      fromUserId: activiitiesForum.fromUserId,
      seen: 'seen',
      forumId: activiitiesForum.forumId,
      forumTitle: activiitiesForum.forumTitle,
      thought: activiitiesForum.thought,
      timestamp: activiitiesForum.timestamp,
      authorName: activiitiesForum.authorName,
      authorProfileHanlde: activiitiesForum.authorProfileHanlde,
      authorVerification: activiitiesForum.authorVerification,
      authorProfileImageUrl: activiitiesForum.authorProfileImageUrl,
      isThoughtLike: activiitiesForum.isThoughtLike,
      thoughtId: activiitiesForum.thoughtId,
      isThoughtReplied: activiitiesForum.isThoughtReplied,
    );
    print('sumiting');
    try {
      DatabaseService.editActivityForum(activityForum, widget.currentUserId);
    } catch (e) {
      print(e.toString());
    }
  }

  _buildActivity(ActivityForum activityForum) {
    return ActivityTile(
      isLiked: activityForum.isThoughtLike,
      seen: activityForum.seen,
      verified: activityForum.authorVerification,
      profileImageUrl: activityForum.authorProfileImageUrl,
      activityIndicator: activityForum.isThoughtReplied
          ? 'Replied your thought on: '
          : activityForum.isThoughtLike
              ? 'Liked your thought on: '
              : 'thought on:  ',
      activityTitle: activityForum.forumTitle,
      activityContent: activityForum.thought,
      activityTime: timeago.format(
        activityForum.timestamp.toDate(),
      ),
      userName: activityForum.authorName,
      onPressed: () async {
        String currentUserId =
            Provider.of<UserData>(context, listen: false).currentUserId!;
        activityForum.isThoughtReplied
            ? _gotToRepliedForum(currentUserId, activityForum)
            : activityForum.isThoughtLike
                ? _goReactionPage(currentUserId, activityForum)
                : _goToThought(currentUserId, activityForum);
      },
    );
    //   },
    // );
  }

  _goReactionPage(currentUserId, ActivityForum activityForum) {
    activityForum.seen != 'seen'
        ? _submit(activityForum)
        : const SizedBox.shrink();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityReactedContent(
          authorId: activityForum.fromUserId,
          contentId: activityForum.thoughtId,
          parentContentId: activityForum.forumId,
          contentType: 'Thought',
          forumAuthorId: activityForum.forumAuthorId,
        ),
      ),
    );
  }

  _gotToRepliedForum(String currentUserId, activityForum) async {
    Forum forum = await DatabaseService.getUserForum(
      activityForum.forumAuthorId,
      activityForum.forumId,
    );

    activityForum.seen != 'seen'
        ? _submit(activityForum)
        : const SizedBox.shrink();

    Thought _thought = await DatabaseService.getUserThought(
      activityForum.thoughtId,
      activityForum.forumId,
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReplyThoughtsScreen(
                  currentUserId: currentUserId,
                  forum: forum,
                  isBlocked: false,
                  thought: _thought,
                )));
  }

  _goToThought(String currentUserId, activityForum) async {
    Forum forum = await DatabaseService.getUserForum(
      currentUserId,
      activityForum.forumId,
    );

    DatabaseService.numThoughts(forum.id).listen((thoughtCount) {
      if (mounted) {
        setState(() {
          _thoughtCount = thoughtCount;
        });
      }
    });
    // AccountHolder user =
    //     await DatabaseService.getUserWithId(forum.authorId);
    activityForum.seen != 'seen'
        ? _submit(activityForum)
        : const SizedBox.shrink();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThoughtsScreen(
          feed: '',
          forum: forum,
          // author: user,
          thoughtCount: _thoughtCount,
          currentUserId: widget.currentUserId,
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
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.activityForumCount == 0
              ? const SizedBox.shrink()
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
                            .format(widget.activityForumCount),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
          const SizedBox(
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
                            ActivityForum activityForum =
                                _activitiesForum[index];

                            return _buildActivity(activityForum);
                          },
                          childCount: _activitiesForum.length,
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
