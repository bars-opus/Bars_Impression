import 'package:bars/utilities/exports.dart';

class AllHashTagPost extends StatefulWidget {
  static final id = 'AllHashTagPost';
  final String currentUserId;
  final String hashTag;

  AllHashTagPost({
    required this.currentUserId,
    required this.hashTag,
  });

  @override
  _AllHashTagPostState createState() => _AllHashTagPostState();
}

class _AllHashTagPostState extends State<AllHashTagPost> {
  List<Post> _posts = [];
  final _postSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFetchingPosts = false;
  late ScrollController _hideButtonController;
  int _hashTagCount = 0;

  @override
  void initState() {
    super.initState();
    _setUpFeed();
    _setUpArtistPuchCount();
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

  _setUpFeed() async {
    QuerySnapshot postSnapShot = await allPostsRef
        .where('hashTag', isEqualTo: widget.hashTag)
        .limit(limit)
        .get();
    List<Post> posts =
        postSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    _postSnapshot.addAll((postSnapShot.docs));
    if (mounted) {
      setState(() {
        _posts = posts;
      });
    }
    return posts;
  }

  _loadMorePosts() async {
    if (_isFetchingPosts) return;
    _isFetchingPosts = true;
    _hasNext = true;
    QuerySnapshot postSnapShot = await allPostsRef
        .where('hashTag', isEqualTo: widget.hashTag)
        .limit(limit)
        .startAfterDocument(_postSnapshot.last)
        .get();
    List<Post> moreposts =
        postSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    List<Post> allposts = _posts..addAll(moreposts);
    _postSnapshot.addAll((postSnapShot.docs));
    if (mounted) {
      setState(() {
        _posts = allposts;
      });
    }
    _hasNext = false;
    _isFetchingPosts = false;
    return _hasNext;
  }

  _setUpArtistPuchCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numHashTagPunch(currentUserId, widget.hashTag)
        .listen((hashTagPunch) {
      if (mounted) {
        setState(() {
          _hashTagCount = hashTagPunch;
        });
      }
    });
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
                'Hashtag punches',
                style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            floating: true,
            pinned: true,
            snap: true,
            iconTheme: new IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          )
        ],
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Container(
            color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "These are the mood punches with the tag:",
                              style: TextStyle(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              )),
                          TextSpan(
                              text: "  '${widget.hashTag}.'",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              )),
                          TextSpan(
                              text:
                                  "\nTotal Punches : ${_hashTagCount.toString()}.",
                              style: TextStyle(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: _posts.length > 0
                          ? RefreshIndicator(
                              onRefresh: () => _setUpFeed(),
                              child: NotificationListener<ScrollNotification>(
                                onNotification: _handleScrollNotification,
                                child: Scrollbar(
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverGrid(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            Post post = _posts[index];
                                            return FutureBuilder(
                                              future:
                                                  DatabaseService.getUserWithId(
                                                      post.authorId),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (!snapshot.hasData) {
                                                  return GridSchimmerSkeleton();
                                                }
                                                AccountHolder author =
                                                    snapshot.data;
                                                return FeedGrid(
                                                  currentUserId:
                                                      widget.currentUserId,
                                                  post: post,
                                                  author: author,
                                                  feed: 'Hashtag',
                                                );
                                              },
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
