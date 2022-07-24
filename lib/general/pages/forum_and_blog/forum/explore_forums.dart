import 'dart:ui';

import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ExploreForums extends StatefulWidget {
  final Forum forum;
  final AccountHolder author;
  final String currentUserId;
  final String profileImage;
  final String feed;

  ExploreForums({
    required this.currentUserId,
    required this.author,
    required this.forum,
    required this.feed,
    required this.profileImage,
  });
  @override
  _ExploreForumsState createState() => _ExploreForumsState();
}

class _ExploreForumsState extends State<ExploreForums> {
  final _pageController = PageController();
  double page = 0.0;
  bool _showInfo = true;
  List<Forum> _forumList = [];
  final _forumSnapshot = <DocumentSnapshot>[];
  int limit = 5;
  bool _hasNext = true;
  bool _isFetchingForum = false;

  @override
  void initState() {
    _pageController.addListener(_listenScroll);
    _setShowInfo();
    widget.feed.startsWith('Feed')
        ? _setupForumFeed()
        : widget.feed.startsWith('All')
            ? _setupAllForum()
            : widget.feed.startsWith('Profile')
                ? _setupProfileForum()
                : () {};
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

  _setupForumFeed() async {
    QuerySnapshot forumFeedSnapShot = await forumFeedsRef
        .doc(
          widget.currentUserId,
        )
        .collection('userForumFeed')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Forum> forums =
        forumFeedSnapShot.docs.map((doc) => Forum.fromDoc(doc)).toList();
    _forumSnapshot.addAll((forumFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _forumList = forums;
      });
    }
    return forums;
  }

  _loadMoreForums() async {
    if (_isFetchingForum) return;
    _isFetchingForum = true;
    _hasNext = true;
    QuerySnapshot forumFeedSnapShot = await forumFeedsRef
        .doc(widget.currentUserId)
        .collection('userForumFeed')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_forumSnapshot.last)
        .get();
    List<Forum> moreforums =
        forumFeedSnapShot.docs.map((doc) => Forum.fromDoc(doc)).toList();
    if (_forumSnapshot.length < limit) _hasNext = false;
    List<Forum> allforums = _forumList..addAll(moreforums);
    _forumSnapshot.addAll((forumFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _forumList = allforums;
      });
    }
    _hasNext = false;
    _isFetchingForum = false;
    return _hasNext;
  }

  _setupAllForum() async {
    QuerySnapshot forumFeedSnapShot = await allForumsRef
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Forum> forums =
        forumFeedSnapShot.docs.map((doc) => Forum.fromDoc(doc)).toList();
    _forumSnapshot.addAll((forumFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _forumList = forums;
      });
    }
    return forums;
  }

  _loadMoreAllForums() async {
    if (_isFetchingForum) return;
    _isFetchingForum = true;
    _hasNext = true;
    QuerySnapshot forumFeedSnapShot = await allForumsRef
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_forumSnapshot.last)
        .get();
    List<Forum> moreforums =
        forumFeedSnapShot.docs.map((doc) => Forum.fromDoc(doc)).toList();
    if (_forumSnapshot.length < limit) _hasNext = false;
    List<Forum> allforums = _forumList..addAll(moreforums);
    _forumSnapshot.addAll((forumFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _forumList = allforums;
      });
    }
    _hasNext = false;
    _isFetchingForum = false;
    return _hasNext;
  }

  _setupProfileForum() async {
    QuerySnapshot userForumsSnapshot = await forumsRef
        .doc(widget.currentUserId)
        .collection('userForums')
        .limit(limit)
        .get();
    List<Forum> forums =
        userForumsSnapshot.docs.map((doc) => Forum.fromDoc(doc)).toList();
    _forumSnapshot.addAll((userForumsSnapshot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _forumList = forums;
      });
    }
    return forums;
  }

  _loadMoreProfileForums() async {
    if (_isFetchingForum) return;
    _isFetchingForum = true;
    _hasNext = true;
    QuerySnapshot userForumsSnapshot = await forumsRef
        .doc(widget.currentUserId)
        .collection('userForums')
        .limit(limit)
        .startAfterDocument(_forumSnapshot.last)
        .get();
    List<Forum> moreforums =
        userForumsSnapshot.docs.map((doc) => Forum.fromDoc(doc)).toList();
    if (_forumSnapshot.length < limit) _hasNext = false;
    List<Forum> allforums = _forumList..addAll(moreforums);
    _forumSnapshot.addAll((userForumsSnapshot.docs));
    if (mounted) {
      setState(() {
        _forumList = allforums;
      });
    }
    _hasNext = false;
    _isFetchingForum = false;
    return _hasNext;
  }

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

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Stack(
        children: [
          widget.profileImage.isEmpty
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                )
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ConfigBloc().darkModeOn
                          ? Color(0xFF1a1a1a)
                          : Color(0xFFeff0f2),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.profileImage,
                        ),
                        fit: BoxFit.cover,
                      )),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
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
                        Material(
                            color: Colors.transparent, child: ExploreClose()),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Explore\nForums",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
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
                  _forumList.length > 0
                      ? Expanded(
                          child: PageView.builder(
                              controller: _pageController,
                              itemCount: _forumList.length,
                              onPageChanged: (i) {
                                if (i == _forumList.length - 1) {
                                  widget.feed.startsWith('Feed')
                                      ? _loadMoreForums()
                                      : widget.feed.startsWith('All')
                                          ? _loadMoreAllForums()
                                          : widget.feed.startsWith('Profile')
                                              ? _loadMoreProfileForums()
                                              : () {};
                                }
                              },
                              itemBuilder: (context, index) {
                                final forum = _forumList[index];
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
                                    child: ExploreForumMin(
                                      feed: widget.feed,
                                      forum: forum,
                                      author: widget.author,
                                      currentUserId:
                                          Provider.of<UserData>(context)
                                              .currentUserId!,
                                    ),
                                  ),
                                );
                              }),
                        )
                      : ExploreForumsSchimmerSkeleton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
