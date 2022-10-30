import 'dart:ui';

import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:vector_math/vector_math_64.dart' as vector;

class ExplorePosts extends StatefulWidget {
  final Post post;
  final String feed;
  final String currentUserId;
  ExplorePosts({
    required this.currentUserId,
    required this.post,
    required this.feed,
  });
  @override
  _ExplorePostsState createState() => _ExplorePostsState();
}

class _ExplorePostsState extends State<ExplorePosts> {
  final _pageController = PageController();
  double page = 0.0;
  List<Post> _postsList = [];
  final _postSnapshot = <DocumentSnapshot>[];
  bool _showInfo = true;
  int limit = 5;
  bool _hasNext = true;
  bool _isFetchingPost = false;

  @override
  void initState() {
    _pageController.addListener(_listenScroll);
    widget.feed.startsWith('Feed')
        ? _setupFeed()
        : widget.feed.startsWith('All')
            ? _setupAllPost()
            : widget.feed.startsWith('Profile')
                ? _setupProfilePost()
                : widget.feed.startsWith('Punchline')
                    ? _setupPunchlinePost()
                    : widget.feed.startsWith('Artist')
                        ? _setupArtistPost()
                        : widget.feed.startsWith('Hashtag')
                            ? _setupHashtagPost()
                            : _nothing();
    _setShowInfo();

    super.initState();
  }

  void _listenScroll() {
    setState(() {
      page = _pageController.page!;
    });
  }

  _setShowInfo() {
    if (_showInfo) {
      Timer(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showInfo = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_listenScroll);
    _pageController.dispose();
    super.dispose();
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

  _setupAllPost() async {
    QuerySnapshot postFeedSnapShot = await allPostsRef
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

  _loadMoreAllPosts() async {
    if (_isFetchingPost) return;
    _isFetchingPost = true;
    _hasNext = true;
    QuerySnapshot postFeedSnapShot = await allPostsRef
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

  _setupProfilePost() async {
    QuerySnapshot userPostsSnapshot = await postsRef
        .doc(widget.currentUserId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Post> posts =
        userPostsSnapshot.docs.map((doc) => Post.fromDoc(doc)).toList();
    _postSnapshot.addAll((userPostsSnapshot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _postsList = posts;
      });
    }
    return posts;
  }

  _loadMoreProfilePosts() async {
    if (_isFetchingPost) return;
    _isFetchingPost = true;
    _hasNext = true;
    QuerySnapshot userPostsSnapshot = await postsRef
        .doc(widget.currentUserId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_postSnapshot.last)
        .get();
    List<Post> morePosts =
        userPostsSnapshot.docs.map((doc) => Post.fromDoc(doc)).toList();
    List<Post> allPost = _postsList..addAll(morePosts);
    _postSnapshot.addAll((userPostsSnapshot.docs));
    if (mounted) {
      setState(() {
        _postsList = allPost;
      });
    }
    _hasNext = false;
    _isFetchingPost = false;
    return _hasNext;
  }

  _setupPunchlinePost() async {
    QuerySnapshot postSnapShot = await allPostsRef
        .where('punch', isEqualTo: widget.post.punch)
        .limit(limit)
        .get();
    List<Post> posts =
        postSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    _postSnapshot.addAll((postSnapShot.docs));
    if (mounted) {
      setState(() {
        _postsList = posts;
      });
    }
    return posts;
  }

  _loadMorePunchlinePosts() async {
    if (_isFetchingPost) return;
    _isFetchingPost = true;
    _hasNext = true;
    QuerySnapshot postSnapShot = await allPostsRef
        .where('punch', isEqualTo: widget.post.punch)
        .limit(limit)
        .startAfterDocument(_postSnapshot.last)
        .get();
    List<Post> moreposts =
        postSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    List<Post> allposts = _postsList..addAll(moreposts);
    _postSnapshot.addAll((postSnapShot.docs));
    if (mounted) {
      setState(() {
        _postsList = allposts;
      });
    }
    _hasNext = false;
    _isFetchingPost = false;
    return _hasNext;
  }

  _setupHashtagPost() async {
    QuerySnapshot postSnapShot = await allPostsRef
        .where('hashTag', isEqualTo: widget.post.hashTag)
        .limit(limit)
        .get();
    List<Post> posts =
        postSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    _postSnapshot.addAll((postSnapShot.docs));
    if (mounted) {
      setState(() {
        _postsList = posts;
      });
    }
    return posts;
  }

  _loadMoreHashtagPosts() async {
    if (_isFetchingPost) return;
    _isFetchingPost = true;
    _hasNext = true;
    QuerySnapshot postSnapShot = await allPostsRef
        .where('hashTag', isEqualTo: widget.post.hashTag)
        .limit(limit)
        .startAfterDocument(_postSnapshot.last)
        .get();
    List<Post> moreposts =
        postSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    List<Post> allposts = _postsList..addAll(moreposts);
    _postSnapshot.addAll((postSnapShot.docs));
    if (mounted) {
      setState(() {
        _postsList = allposts;
      });
    }
    _hasNext = false;
    _isFetchingPost = false;
    return _hasNext;
  }

  _setupArtistPost() async {
    QuerySnapshot postSnapShot = await allPostsRef
        .where('artist', isEqualTo: widget.post.artist)
        .limit(limit)
        .get();
    List<Post> posts =
        postSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    _postSnapshot.addAll((postSnapShot.docs));
    if (mounted) {
      setState(() {
        _postsList = posts;
      });
    }
    return posts;
  }

  _loadMoreArtistPosts() async {
    if (_isFetchingPost) return;
    _isFetchingPost = true;
    _hasNext = true;
    QuerySnapshot postSnapShot = await allPostsRef
        .where('artist', isEqualTo: widget.post.artist)
        .limit(limit)
        .startAfterDocument(_postSnapshot.last)
        .get();
    List<Post> moreposts =
        postSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
    List<Post> allposts = _postsList..addAll(moreposts);
    _postSnapshot.addAll((postSnapShot.docs));
    if (mounted) {
      setState(() {
        _postsList = allposts;
      });
    }
    _hasNext = false;
    _isFetchingPost = false;
    return _hasNext;
  }

_nothing(){}


  Widget buildBlur({
    required Widget child,
    double sigmaX = 5,
    double sigmaY = 5,
    BorderRadius? borderRadius,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );

  final backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF444a55),
        Color(0xFFf2f2f2),
      ]);

  _buildPunchView(Post post, AccountHolder accountHolder) {
    final width = MediaQuery.of(context).size.width;
    return FocusedMenuHolder(
      menuWidth: width,
      menuOffset: 10,
      blurBackgroundColor:
          ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white10,
      openWithTap: false,
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Go to ${accountHolder.name}\' profile ',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                          currentUserId:
                              Provider.of<UserData>(context).currentUserId!,
                          userId: accountHolder.id!,
                        )))),
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Go to punchline ',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PunchWidget(
                        currentUserId: widget.currentUserId,
                        post: post,
                       )))),
      ],
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AllPostEnlarged(
                        feed: widget.feed,
                        currentUserId: widget.currentUserId,
                        post: post, 
                   ))),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 10),
                    blurRadius: 10.0,
                    spreadRadius: 4.0,
                  )
                ],
                borderRadius: BorderRadius.circular(30),
                color:
                    ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Colors.white,
              ),
              height: Responsive.isDesktop(context) ? 400 : 300,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0.0),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Material(
                                  color: Colors.transparent,
                                  child: Container(
                                      child: Row(children: <Widget>[
                                    Hero(
                                      tag: 'author' + post.id.toString(),
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: ConfigBloc().darkModeOn
                                            ? Color(0xFF1a1a1a)
                                            : Color(0xFFf2f2f2),
                                        backgroundImage: accountHolder
                                                .profileImageUrl!.isEmpty
                                            ? AssetImage(
                                                ConfigBloc().darkModeOn
                                                    ? 'assets/images/user_placeholder.png'
                                                    : 'assets/images/user_placeholder2.png',
                                              ) as ImageProvider
                                            : CachedNetworkImageProvider(
                                                accountHolder.profileImageUrl!),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: RichText(
                                              text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text:
                                                      "${accountHolder.userName}\n",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text:
                                                      "${accountHolder.profileHandle!}\n",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.white
                                                            : Colors.black,
                                                  )),
                                              TextSpan(
                                                  text:
                                                      "${accountHolder.company}",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.white
                                                            : Colors.black,
                                                  )),
                                            ],
                                          )),
                                        ),
                                      ],
                                    ),
                                  ])),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Hero(
                            tag: 'punch' + post.id.toString(),
                            child: Material(
                              color: Colors.transparent,
                              child: SingleChildScrollView(
                                child: Text(
                                  '" ${post.punch} " '.toLowerCase(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: 'artist' + post.id.toString(),
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            '${post.artist} ',
                            style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: width > 500 && width < 800
                                  ? 16
                                  : width > 800
                                      ? 20
                                      : 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.0),
                      Hero(
                        tag: 'artist2' + post.id.toString(),
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            height: 1.0,
                            child: Text(
                              '${post.artist} ',
                              style: TextStyle(
                                fontSize: width > 500 && width < 800
                                    ? 16
                                    : width > 800
                                        ? 20
                                        : 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      BarsTextFooter(
                        text: timeago.format(
                          post.timestamp!.toDate(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Positioned(
                            left: 0.0,
                            top: 0.0,
                            child: Container(
                              height: 10,
                              width: 10,
                              color: Colors.blue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Hero(
                              tag: 'caption' + post.id.toString(),
                              child: Material(
                                color: Colors.transparent,
                                child: SingleChildScrollView(
                                  child: Text(
                                    '${post.caption} '.toLowerCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ConfigBloc().darkModeOn
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                color: ConfigBloc().darkModeOn
                    ? Color(0xFF1a1a1a)
                    : Color(0xFFeff0f2),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.post.imageUrl,
                  ),
                  fit: BoxFit.cover,
                )),
            child: Container(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.5),
                Colors.black.withOpacity(.5),
              ])),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Hero(
                          tag: 'close' + widget.post.id.toString(),
                          child: Material(
                              color: Colors.transparent, child: ExploreClose()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: width / 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.feed.startsWith('All')
                                    ? Text(
                                        "Explore\nAll Punches",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.end,
                                      )
                                    : widget.feed.startsWith('Feed')
                                        ? Text(
                                            "Explore\Feed Punches",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.end,
                                          )
                                        : widget.feed.startsWith('Profile')
                                            ? Text(
                                                "Explore\nProfile Punches",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.end,
                                              )
                                            : widget.feed.startsWith('Artist')
                                                ? Text(
                                                    "Explore\nArtist Punches",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  )
                                                : widget.feed
                                                        .startsWith('Punchline')
                                                    ? Text(
                                                        "Explore\nPunchline Punches",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                        ),
                                                        textAlign:
                                                            TextAlign.end,
                                                      )
                                                    : widget.feed.startsWith(
                                                            'Hashtag')
                                                        ? Text(
                                                            "Explore\nHashtag Punches",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end,
                                                          )
                                                        : Text(
                                                            "Explore\nPunches",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 800),
                      height: _showInfo ? 40 : 0.0,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Center(
                        child: Swipinfo(
                          color: _showInfo ? Colors.white : Colors.transparent,
                          text: 'Swipe',
                        ),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  _postsList.length > 0
                      ? Expanded(
                          child: PageView.builder(
                              controller: _pageController,
                              itemCount: _postsList.length,
                              onPageChanged: (i) {
                                if (i == _postsList.length - 1) {
                                  widget.feed.startsWith('Feed')
                                      ? _loadMorePosts()
                                      : widget.feed.startsWith('All')
                                          ? _loadMoreAllPosts()
                                          : widget.feed.startsWith('Profile')
                                              ? _loadMoreProfilePosts()
                                              : widget.feed
                                                      .startsWith('Punchline')
                                                  ? _loadMorePunchlinePosts()
                                                  : widget.feed
                                                          .startsWith('Artist')
                                                      ? _loadMoreArtistPosts()
                                                      : widget.feed.startsWith(
                                                              'Hashtag')
                                                          ? _loadMoreHashtagPosts()
                                                          : _nothing();
                                }
                              },
                              itemBuilder: (context, index) {
                                final post = _postsList[index];
                                final percent =
                                    (page - index).abs().clamp(0.0, 1.0);
                                final factor = _pageController
                                            .position.userScrollDirection ==
                                        ScrollDirection.forward
                                    ? 1.0
                                    : -1.0;
                                final opacity = percent.clamp(0.0, 0.7);
                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(
                                        vector.radians(45 * factor * percent)),
                                  child: Opacity(
                                      opacity: (1 - opacity),
                                      child: FutureBuilder<DocumentSnapshot>(
                                          future:
                                              usersRef.doc(post.authorId).get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (!snapshot.hasData) {
                                              return PunchSchimmerSkeleton();
                                            }
                                            AccountHolder accountHolder =
                                                AccountHolder.fromDoc(
                                                    snapshot.data!);

                                            return _buildPunchView(
                                                post, accountHolder);
                                          })),
                                );
                              }),
                        )
                      : PunchSchimmerSkeleton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
