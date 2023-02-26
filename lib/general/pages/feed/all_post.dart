import 'package:bars/utilities/exports.dart';

class AllPost extends StatefulWidget {
  static final id = 'AllPost';
  final String currentUserId;
  final Post? post;
  AllPost({required this.currentUserId, required this.post});

  @override
  _AllPostState createState() => _AllPostState();
}

class _AllPostState extends State<AllPost> {
  List<Post> _posts = [];
  final _postSnapshot = <DocumentSnapshot>[];
  int limit = 16;
  bool _hasNext = true;
  bool _listView = false;
  bool _showInfo = false;
  bool _isFetchingPost = false;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setupFeed();
    PaintingBinding.instance.imageCache.clear();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMorePosts();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setupFeed() async {
    QuerySnapshot postFeedSnapShot = await allPostsRef
        .where('disbleSharing', isEqualTo: true)

        // .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Post> posts = postFeedSnapShot.docs
        .map((doc) => Post.fromDoc(doc))
        .toList()
      ..shuffle();
    _postSnapshot.addAll((postFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _posts = posts;
      });
    }
    return posts;
  }

  _loadMorePosts() async {
    if (_isFetchingPost) return;
    _isFetchingPost = true;
    _hasNext = true;
    QuerySnapshot postFeedSnapShot = await allPostsRef
        .where('disbleSharing', isEqualTo: true)
        // .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_postSnapshot.last)
        .get();
    List<Post> morePosts = postFeedSnapShot.docs
        .map((doc) => Post.fromDoc(doc))
        .toList()
      ..shuffle();
    List<Post> allPost = _posts..addAll(morePosts);
    _postSnapshot.addAll((postFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _posts = allPost;
      });
    }
    _hasNext = false;
    _isFetchingPost = false;
    return _hasNext;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          extendBodyBehindAppBar: _listView ? true : false,
          appBar: AppBar(
              iconTheme: new IconThemeData(
                color: _listView
                    ? Colors.white
                    : ConfigBloc().darkModeOn
                        ? Colors.white
                        : Colors.black,
              ),
              backgroundColor: Colors.transparent,
              title: Material(
                color: Colors.transparent,
                child: Text(
                  _listView ? '' : 'Explore Punches',
                  style: TextStyle(
                      color: _listView
                          ? Colors.white
                          : ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              automaticallyImplyLeading: true,
              actions: [
                IconButton(
                    icon: Icon(
                      _listView ? FontAwesomeIcons.list : Icons.grid_view,
                    ),
                    iconSize: 20,
                    color: _listView
                        ? Colors.white
                        : ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                    onPressed: () async {
                      HapticFeedback.heavyImpact();
                      if (mounted) {
                        setState(() {
                          // _isHidden = !_isHidden;
                          _listView = !_listView;

                          _showInfo = true;
                        });
                      }

                      Timer(Duration(seconds: 5), () {
                        if (mounted) {
                          setState(() {
                            _showInfo = false;
                          });
                        }
                      });
                    }),
              ]),
          // controller: _hideButtonController,

          // headerSliverBuilder: (context, innerBoxScrolled) => [
          //       SliverAppBar(
          // title: Material(
          //   color: Colors.transparent,
          //   child: Text(
          //     'Explore Punches',
          //     style: TextStyle(
          //         color: ConfigBloc().darkModeOn
          //             ? Colors.white
          //             : Colors.black,
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold),
          //   ),
          // ),
          // centerTitle: true,
          // elevation: 0.0,
          // automaticallyImplyLeading: true,
          //         floating: true,
          //         snap: true,
          //         iconTheme: new IconThemeData(
          //           color:
          //               ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          //         ),
          //         backgroundColor: ConfigBloc().darkModeOn
          //             ? Color(0xFF1a1a1a)
          //             : Color(0xFFf2f2f2),
          //         actions: [
          //           IconButton(
          //               icon: Icon(
          //                 _listView ? Icons.grid_view : FontAwesomeIcons.list,
          //               ),
          //               iconSize: 20,
          //               color: ConfigBloc().darkModeOn
          //                   ? Colors.white
          //                   : Colors.black,
          //               onPressed: () async {
          //                 HapticFeedback.heavyImpact();
          //                 setState(() {
          //                   // _isHidden = !_isHidden;
          //                   _listView = !_listView;
          //                 });
          //               }),
          //         ],
          //       )
          //     ],
          body: Stack(
            alignment: FractionalOffset.center,
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                    color: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Color(0xFFf2f2f2),
                    child: Column(
                      children: [
                        Expanded(
                          child: _posts.length > 0
                              ? RefreshIndicator(
                                  onRefresh: () => _setupFeed(),
                                  child: _listView
                                      ? NotificationListener<
                                          ScrollNotification>(
                                          onNotification:
                                              _handleScrollNotification,
                                          child: RawScrollbar(
                                            controller: _hideButtonController,
                                            thumbColor: Colors.white,
                                            radius: Radius.circular(20),
                                            thickness: 2,
                                            child: CustomScrollView(
                                              controller: _hideButtonController,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              slivers: [
                                                SliverList(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                    (context, index) {
                                                      Post post = _posts[index];
                                                      return PostView(
                                                        key: PageStorageKey(
                                                            'FeedList'),
                                                        currentUserId: widget
                                                            .currentUserId,
                                                        post: post,
                                                        // postList: _postsList,
                                                        showExplore: false,
                                                      );
                                                    },
                                                    childCount: _posts.length,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : NotificationListener<
                                          ScrollNotification>(
                                          onNotification:
                                              _handleScrollNotification,
                                          child: Scrollbar(
                                            controller: _hideButtonController,
                                            child: CustomScrollView(
                                              controller: _hideButtonController,
                                              slivers: [
                                                SliverGrid(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                    (context, index) {
                                                      Post post = _posts[index];
                                                      return FeedGrid(
                                                        feed: 'All',
                                                        currentUserId: widget
                                                            .currentUserId,
                                                        post: post,
                                                      );
                                                    },
                                                    childCount: _posts.length,
                                                  ),
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 5.0,
                                                    crossAxisSpacing: 5.0,
                                                    childAspectRatio: 1.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                )
                              : GroupGridSchimmerSkeleton(),
                        ),
                      ],
                    )),
              ),
              Positioned(
                top: 60,
                right: 50,
                child: AnimatedInfoWidget(
                  buttonColor: Colors.white,
                  text: 'Scroll up or down',
                  requiredBool: _showInfo,
                ),
              ),
            ],
          )),
    );
  }
}
