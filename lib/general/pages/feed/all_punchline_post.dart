import 'package:bars/utilities/exports.dart';

class AllPunclinePost extends StatefulWidget {
  static final id = 'AllPunclinePost';
  final String currentUserId;
  final String punch;

  AllPunclinePost({
    required this.currentUserId,
    required this.punch,
  });

  @override
  _AllPunclinePostState createState() => _AllPunclinePostState();
}

class _AllPunclinePostState extends State<AllPunclinePost> {
  List<Post> _posts = [];
  final _postSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFetchingPosts = false;
  late ScrollController _hideButtonController;
  int _punchCount = 0;

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
        .where('punch', isEqualTo: widget.punch)
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
        .where('punch', isEqualTo: widget.punch)
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
    DatabaseService.numPunchlinePunch(currentUserId, widget.punch)
        .listen((punclinePunch) {
      if (mounted) {
        setState(() {
          _punchCount = punclinePunch;
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
                'Punchline punches',
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
                              text:
                                  "These are the mood punches which contains the punchline:",
                              style: TextStyle(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              )),
                          TextSpan(
                              text: "  '${widget.punch}.'".toLowerCase(),
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              )),
                          TextSpan(
                              text:
                                  "\nTotal Punches : ${_punchCount.toString()}.",
                              style: TextStyle(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              )),
                        ],
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                          textScaleFactor: MediaQuery.of(context)
                              .textScaleFactor
                              .clamp(0.5, 1.5)),
                      child: Expanded(
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
                                              return FeedGrid(
                                                    feed: 'Punchline',
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
