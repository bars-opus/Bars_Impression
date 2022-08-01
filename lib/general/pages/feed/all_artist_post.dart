import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class AllArtistPosts extends StatefulWidget {
  static final id = 'AllArtistPosts';
  final String currentUserId;
  final String artist;
  final Post? post;
  final int? artistPunch;
  AllArtistPosts(
      {required this.currentUserId,
      required this.artistPunch,
      required this.artist,
      required this.post});

  @override
  _AllArtistPostsState createState() => _AllArtistPostsState();
}

class _AllArtistPostsState extends State<AllArtistPosts> {
  List<Post> _posts = [];
  int _artistPunch = 0;
  late Future<QuerySnapshot> _users;
  int limit = 15;
  bool _isFetchingPosts = false;
  final _postSnapshot = <DocumentSnapshot>[];
  bool _hasNext = true;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setUpFeed();
    _setupArtist();
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
        .where('artist', isEqualTo: widget.artist)
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
        .where('artist', isEqualTo: widget.artist)
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

  _setupArtist() async {
    setState(() {
      _users = DatabaseService.searchArtist(widget.artist.toUpperCase());
    });
  }

  _setUpArtistPuchCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;

    DatabaseService.numArtistPunch(currentUserId, widget.artist)
        .listen((artistPunch) {
      if (mounted) {
        setState(() {
          _artistPunch = artistPunch;
        });
      }
    });
  }

  _buildUserTile(AccountHolder user) {
    return SearchUserTile(
      userName: user.userName!.toUpperCase(),
      profileHandle: user.profileHandle!,
      company: user.company!,
      profileImageUrl: user.profileImageUrl!,
      bio: user.bio!,
      score: user.score!,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProfileScreen(
                      currentUserId:
                          Provider.of<UserData>(context).currentUserId!,
                      userId: user.id!,
                    )));
      },
      verified: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: NestedScrollView(
          controller: _hideButtonController,
          headerSliverBuilder: (context, innerBoxScrolled) => [
                SliverAppBar(
                  elevation: 0.0,
                  automaticallyImplyLeading: true,
                  floating: true,
                  snap: true,
                  pinned: true,
                  iconTheme: new IconThemeData(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  ),
                  backgroundColor: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Colors.white,
                  title: Text(
                    'Artist punches',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                ),
              ],
          body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Container(
              color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:   MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        textScaleFactor: MediaQuery.of(context)
                            .textScaleFactor
                            .clamp(0.5, 1.5)),    child: Column(
                      children: <Widget>[
                        widget.artistPunch == 0
                            ? SizedBox.shrink()
                            : FutureBuilder<QuerySnapshot>(
                                future: _users,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox.shrink();
                                  }
                                  if (snapshot.data!.docs.length == 0) {
                                    return Center(
                                      child: RichText(
                                          textScaleFactor: MediaQuery.of(context)
                            .textScaleFactor
                            .clamp(0.5, 1.5),
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "No users found. ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blueGrey)),
                                            TextSpan(
                                                text:
                                                    '\nThis artist is not on Bars Impression\n'),
                                          ],
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textScaleFactor: MediaQuery.of(context)
                                            .textScaleFactor
                                            .clamp(0.5, 1.5),
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    "These are the mood punches which contains the punchline of",
                                                style: TextStyle(
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14,
                                                )),
                                            TextSpan(
                                                text: "  ${widget.artist}.",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                )),
                                            TextSpan(
                                                text: "\nTotal Punches : ",
                                                style: TextStyle(
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14,
                                                )),
                                            TextSpan(
                                                text: NumberFormat.compact()
                                                    .format(_artistPunch),
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
                                      SingleChildScrollView(
                                        child: Container(
                                          height: width / 3.8,
                                          child: ListView.builder(
                                            itemCount: snapshot.data!.docs.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              AccountHolder? user =
                                                  AccountHolder.fromDoc(
                                                      snapshot.data!.docs[index]);
                                              return _buildUserTile(user);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                        SizedBox(
                          height: 30,
                        ),
                        widget.artistPunch == 0
                            ? Expanded(
                                child: Center(
                                  child: NoContents(
                                    icon: (MdiIcons.musicNoteOutline),
                                    title: 'No Punchlines yet,',
                                    subTitle:
                                        'Nobody has used ${widget.artist}\'s pucnhlines to punch thier moods yet, make sure you have updated your profile information correctly and you have creative contents. ',
                                  ),
                                ),
                              )
                            : Expanded(
                                child: _posts.length > 0
                                    ? RefreshIndicator(
                                        onRefresh: () => _setUpFeed(),
                                        child: NotificationListener<
                                            ScrollNotification>(
                                          onNotification:
                                              _handleScrollNotification,
                                          child: Scrollbar(
                                            child: CustomScrollView(
                                              slivers: [
                                                SliverGrid(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                    (context, index) {
                                                      Post post = _posts[index];
                                                      return FutureBuilder(
                                                        future: DatabaseService
                                                            .getUserWithId(
                                                                post.authorId),
                                                        builder:
                                                            (BuildContext context,
                                                                AsyncSnapshot
                                                                    snapshot) {
                                                          if (!snapshot.hasData) {
                                                            return GridSchimmerSkeleton();
                                                          }
                                                          AccountHolder author =
                                                              snapshot.data;
                                                          return FeedGrid(
                                                              currentUserId: widget
                                                                  .currentUserId,
                                                              post: post,
                                                              author: author,
                                                              feed: 'Artist');
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
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
