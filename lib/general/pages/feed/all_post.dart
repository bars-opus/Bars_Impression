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
      child: NestedScrollView(
          controller: _hideButtonController,
          headerSliverBuilder: (context, innerBoxScrolled) => [
                SliverAppBar(
                  title: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Explore Punches',
                      style: TextStyle(
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0.0,
                  automaticallyImplyLeading: true,
                  floating: true,
                  snap: true,
                  iconTheme: new IconThemeData(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  ),
                  backgroundColor: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Color(0xFFf2f2f2),
                )
              ],
          body: Material(
            color: Colors.transparent,
            child: Container(
                color: ConfigBloc().darkModeOn
                    ? Color(0xFF1a1a1a)
                    : Color(0xFFf2f2f2),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: _posts.length > 0
                            ? RefreshIndicator(
                                onRefresh: () => _setupFeed(),
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: _handleScrollNotification,
                                  child: Scrollbar(
                                    child: CustomScrollView(
                                      slivers: [
                                        SliverGrid(
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                              Post post = _posts[index];
                                              return FeedGrid(
                                                feed: 'All',
                                                currentUserId:
                                                    widget.currentUserId,
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
                  ),
                )),
          )),
    );
  }
}
