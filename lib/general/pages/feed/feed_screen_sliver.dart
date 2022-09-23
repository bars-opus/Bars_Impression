import 'package:bars/utilities/exports.dart';

import 'package:intl/intl.dart';

class FeedScreenSliver extends StatefulWidget {
  static final id = 'Feed_screen';
  final String currentUserId;

  FeedScreenSliver({
    required this.currentUserId,
  });

  @override
  _FeedScreenSliverState createState() => _FeedScreenSliverState();
}

class _FeedScreenSliverState extends State<FeedScreenSliver>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Post> _postsList = [];
  final _postSnapshot = <DocumentSnapshot>[];
  int _feedCount = 0;
  int _activityCount = 0;
  int _activityFollowerCount = 0;
  int _activityChatCount = 0;
  int _activityForumCount = 0;
  int _activityEventCount = 0;
  int _activityAdviceCount = 0;
  int total = 0;
  final bool _showExplore = true;
  late ScrollController _hideButtonController;
  late ScrollController _listController;
  int limit = 5;
  bool _hasNext = true;
  bool _isFetchingPost = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
    _setupFeed();
    _setUpactivityCount();
    _setUpactivityForumCount();
    _setUpactivityEventCount();
    _setUpactivityFollowerCount();
    _setUpactivityChatCount();
    _setUpFeedCount();
    _setUpactivityAdviceCount();
    _hideButtonController = ScrollController();
    _listController = new ScrollController();
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMorePosts();
      }
    }
    return false;
  }

  _setupFeed() async {
    QuerySnapshot postFeedSnapShot = await feedsRef
        .doc(
          widget.currentUserId,
        )
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Post> posts =
        postFeedSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    _postSnapshot.addAll((postFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _postsList = posts;
      });
    }
    return posts;
  }

  _loadMorePosts() async {
    if (_isFetchingPost) return;
    _isFetchingPost = true;
    _hasNext = true;
    QuerySnapshot postFeedSnapShot = await feedsRef
        .doc(
          widget.currentUserId,
        )
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_postSnapshot.last)
        .get();
    List<Post> morePosts =
        postFeedSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    List<Post> allPost = _postsList..addAll(morePosts);
    _postSnapshot.addAll((postFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _postsList = allPost;
      });
    }
    _hasNext = false;
    _isFetchingPost = false;

    return _hasNext;
  }

  _setUpFeedCount() async {
    int feedCount = await DatabaseService.numFeedPosts(widget.currentUserId);
    if (mounted) {
      setState(() {
        _feedCount = feedCount;
      });
    }
  }

  _setUpactivityFollowerCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numActivitiesFollower(currentUserId)
        .listen((activityFollowerCount) {
      if (mounted) {
        setState(() {
          _activityFollowerCount = activityFollowerCount;
        });
      }
    });
  }

  _setUpactivityChatCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numChats(
      currentUserId,
    ).listen((activityChatCount) {
      if (mounted) {
        setState(() {
          _activityChatCount = activityChatCount;
        });
      }
    });
  }

  _setUpactivityCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numActivities(currentUserId).listen((activityCount) {
      if (mounted) {
        setState(() {
          _activityCount = activityCount;
        });
      }
    });
  }

  _setUpactivityForumCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numForumActivities(currentUserId)
        .listen((activityForumCount) {
      if (mounted) {
        setState(() {
          _activityForumCount = activityForumCount;
        });
      }
    });
  }

  _setUpactivityAdviceCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numActivitiesAdvice(currentUserId)
        .listen((activityAdviceCount) {
      if (mounted) {
        setState(() {
          _activityAdviceCount = activityAdviceCount;
        });
      }
    });
  }

  _setUpactivityEventCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numEventActivities(currentUserId)
        .listen((activityEventCount) {
      if (mounted) {
        setState(() {
          _activityEventCount = activityEventCount;
        });
      }
    });
  }

  _buildPostBuilder() {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: RawScrollbar(
        controller: _hideButtonController,
        thumbColor: Colors.white,
        radius: Radius.circular(20),
        thickness: 2,
        child: CustomScrollView(
          controller: _hideButtonController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  Post post = _postsList[index];
                  return FutureBuilder(
                    future: DatabaseService.getUserWithId(post.authorId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return PostEnlargedBlurharsh(
                          post: post,
                        );
                      }
                      AccountHolder author = snapshot.data;
                      return PostView(
                        key: PageStorageKey('FeedList'),
                        currentUserId: widget.currentUserId,
                        post: post,
                        author: author,
                        postList: _postsList,
                        showExplore: _showExplore,
                      );
                    },
                  );
                },
                childCount: _postsList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    final AccountHolder? user =
        Provider.of<UserData>(context, listen: false).user;
    return MediaQuery.removePadding(
        context: context,
        child: PageView(
            controller: _pageController,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Stack(
                children: [
                  Container(
                    color: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _postsList.length > 0
                              ? RefreshIndicator(
                                  backgroundColor: Colors.white,
                                  onRefresh: () async {
                                    _setupFeed();
                                    _setUpactivityCount();
                                    _setUpactivityForumCount();
                                    _setUpactivityEventCount();
                                    _setUpactivityAdviceCount();
                                    _setUpactivityChatCount();
                                  },
                                  child: _buildPostBuilder())
                              : _feedCount.isNegative
                                  ? RefreshIndicator(
                                      backgroundColor: Colors.white,
                                      onRefresh: () async {
                                        _setupFeed();
                                        _setUpactivityCount();
                                        _setUpactivityForumCount();
                                        _setUpactivityEventCount();
                                        _setUpactivityAdviceCount();
                                        _setUpactivityChatCount();
                                      },
                                      child: ListView(
                                        controller: _listController,
                                        children: [
                                          SingleChildScrollView(
                                            child: Container(
                                              width: width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: Center(
                                                child: NoFeed(
                                                  title:
                                                      "Set up your punch feed. ",
                                                  subTitle:
                                                      'Your punch feed contains moods punched by people you follow. You can set up your feed by exploring punches and following people by tapping on the button below. You can also discover people based on account types you are interested in by tapping on the discover icon on the bottom navigation bar',
                                                  buttonText: 'Explore Punches',
                                                  onPressed: () =>
                                                      Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => AllPost(
                                                        currentUserId: widget
                                                            .currentUserId,
                                                        post: null,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: PostSchimmerSkeleton(),
                                    ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 28,
                    left: 5,
                    child: _feedCount.isNegative
                        ? const SizedBox.shrink()
                        : SizedBox(
                            child: _buildNotification(
                            user: user,
                            activityFollowerCount: _activityFollowerCount,
                            activityCount: _activityCount,
                            activityForumCount: _activityForumCount,
                            activityEventCount: _activityEventCount,
                            activityAdviceCount: _activityAdviceCount,
                          )),
                  ),
                  Positioned(
                    top: 28,
                    right: 5,
                    child: _buildToggleButton(
                      activityChatCount: _activityChatCount,
                    ),
                  ),
                ],
              ),
              Chats(
                currentUserId: widget.currentUserId,
                // activityChatCount: _activityChatCount,
                userId: '',
              ),
            ]));
  }
}

//notification
class _buildNotification extends StatelessWidget {
  final AccountHolder? user;
  final int activityCount;
  final int activityForumCount;
  final int activityEventCount;
  final int activityFollowerCount;
  final int activityAdviceCount;

  const _buildNotification(
      {required this.user,
      required this.activityCount,
      required this.activityForumCount,
      required this.activityAdviceCount,
      required this.activityEventCount,
      required this.activityFollowerCount});

  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    int eCount = activityEventCount.toInt();
    int pCount = activityCount.toInt();
    int fCount = activityForumCount.toInt();
    int aCount = activityAdviceCount.toInt();
    int flCount = activityFollowerCount.toInt();
    int total = eCount + pCount + fCount + aCount + flCount;
    return Stack(
      children: [
        const Text(
          'Explore moods punched',
          style: TextStyle(
              color: Colors.transparent,
              fontSize: 11,
              fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        IconButton(
          icon: Icon(total == 0
              ? Icons.notifications_none
              : Icons.notifications_active),
          iconSize: 30.0,
          color: Colors.grey,
          onPressed: () {
            if (user!.profileHandle!.startsWith('F') ||
                user!.profileHandle!.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Notifications(
                    currentUserId: currentUserId,
                    activityFollowerCount: activityFollowerCount,
                    activityCount: activityCount,
                    activityForumCount: activityForumCount,
                    activityEventCount: activityEventCount,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationNotFan(
                    currentUserId: currentUserId,
                    activityFollowerCount: activityFollowerCount,
                    activityCount: activityCount,
                    activityForumCount: activityForumCount,
                    activityEventCount: activityEventCount,
                    activityAdviceCount: activityAdviceCount,
                  ),
                ),
              );
            }
          },
        ),
        total == 0
            ? SizedBox.shrink()
            : Positioned(
                top: 5,
                left: 25,
                child: GestureDetector(
                  onTap: () {
                    if (user!.profileHandle!.startsWith('F') ||
                        user!.profileHandle!.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Notifications(
                            activityFollowerCount: activityFollowerCount,
                            currentUserId: currentUserId,
                            activityCount: activityCount,
                            activityForumCount: activityForumCount,
                            activityEventCount: activityEventCount,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationNotFan(
                            activityFollowerCount: activityFollowerCount,
                            currentUserId: currentUserId,
                            activityCount: activityCount,
                            activityForumCount: activityForumCount,
                            activityEventCount: activityEventCount,
                            activityAdviceCount: activityAdviceCount,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 10),
                            blurRadius: 10.0,
                            spreadRadius: 4.0,
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                        color: Colors.red),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 2, bottom: 2),
                      child: Text(
                        NumberFormat.compact().format(total),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

// explore punches
class _buildToggleButton extends StatelessWidget {
  final int activityChatCount;

  const _buildToggleButton({
    required this.activityChatCount,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    return Stack(
      children: [
        Row(
          children: <Widget>[
            Tooltip(
              padding: EdgeInsets.all(20.0),
              message: 'Explore punches by people you have not followed',
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllPost(
                      currentUserId: currentUserId,
                      post: null,
                    ),
                  ),
                ),
                child: FadeAnimation(
                  1,
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AllPost(
                                  currentUserId: currentUserId,
                                  post: null,
                                ),
                              ),
                            ),
                        child: Material(
                            color: Colors.transparent,
                            child: Text('Explore moods punched',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: width > 800 ? 16 : 11,
                                    fontWeight: FontWeight.bold)))),
                  )),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              iconSize: 30.0,
              color: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Chats(
                      currentUserId: currentUserId,
                      // activityChatCount: activityChatCount,
                      userId: '',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        activityChatCount == 0
            ? const SizedBox.shrink()
            : Positioned(
                top: 5,
                right: 30,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Chats(
                          currentUserId: currentUserId,
                          // activityChatCount: activityChatCount,
                          userId: '',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
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
                            .format(activityChatCount.toInt()),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
