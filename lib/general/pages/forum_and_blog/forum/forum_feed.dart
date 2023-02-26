import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';

class ForumFeed extends StatefulWidget {
  static final id = 'ForumFeed';
  final String currentUserId;
  ForumFeed({
    required this.currentUserId,
  });
  @override
  _ForumFeedState createState() => _ForumFeedState();
}

class _ForumFeedState extends State<ForumFeed>
    with AutomaticKeepAliveClientMixin {
  List<Forum> _forumList = [];
  final _forumSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  int _feedCount = 0;
  bool _hasNext = true;
  bool _isFetchingForum = false;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setupForumFeed();
    _setUpFeedCount();
    _hideButtonController = ScrollController();
     _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        Provider.of<UserData>(context, listen: false).setShowUsersTab(false);
      }
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreForums();
      }
    }
    return false;
  }

  _setUpFeedCount() async {
    int feedCount = await DatabaseService.numFeedForums(widget.currentUserId);
    if (mounted) {
      setState(() {
        _feedCount = feedCount;
      });
    }
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
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

  _buildDisplayForum() {
    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scrollbar(
          controller: _hideButtonController,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Forum forum = _forumList[index];
                    return ForumView(
                      feed: 'All',
                      currentUserId: widget.currentUserId,
                      forum: forum,
                    );
                  },
                  childCount: _forumList.length,
                ),
              ),
            ],
          ),
        ));
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      controller: _hideButtonController,
      headerSliverBuilder: (context, innerBoxScrolled) => [
        SliverAppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          floating: true,
          snap: true,
          iconTheme: new IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          title: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              child:
                  _feedCount.isNegative ? const SizedBox.shrink() : Display(),
            ),
          ),
        ),
      ],
      body: MediaQuery(
        data: MediaQuery.of(context).removePadding(
          removeTop: true,
        ),
        child: Container(
          color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _forumList.length > 0
                      ? RefreshIndicator(
                          backgroundColor: Colors.white,
                          onRefresh: () async {
                            _setupForumFeed();
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: _buildDisplayForum()))
                      : _feedCount.isNegative
                          ? RefreshIndicator(
                              backgroundColor: Colors.white,
                              onRefresh: () async {
                                _setupForumFeed();
                              },
                              child: SingleChildScrollView(
                                  child: NoFeed(
                                title: "Set up your forum feed. ",
                                subTitle:
                                    'Your forum feed contains forums by people you follow. You can set up your feed by exploring forums and following people by tapping on the button below. You can also discover people based on account types you are interested in by tapping on the discover icon on the bottom navigation bar.',
                                buttonText: 'Explore Forums',
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ForumPage(
                                      currentUserId: widget.currentUserId,
                                    ),
                                  ),
                                ),
                              )),
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: ForumSchimmer(),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//display
class Display extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.2)),
      child: FadeAnimation(
        1,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'KNOW',
                        textStyle: TextStyle(
                          fontSize: 24.0,
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      FadeAnimatedText(
                        'WHAT\'S',
                        textStyle: TextStyle(
                          fontSize: 24.0,
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      FadeAnimatedText(
                        'GOING',
                        textStyle: TextStyle(
                          fontSize: 24.0,
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      FadeAnimatedText(
                        'ON.',
                        textStyle: TextStyle(
                          fontSize: 24.0,
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    repeatForever: true,
                    pause: const Duration(milliseconds: 3000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true),
                Provider.of<UserData>(context, listen: false)
                        .user!
                        .score!
                        .isNegative
                    ? const SizedBox.shrink()
                    : FadeAnimation(
                        1,
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ForumPage(currentUserId: currentUserId),
                            ),
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFff2f56),
                              ),
                              child: Tooltip(
                                padding: EdgeInsets.all(20.0),
                                message:
                                    'Explore forums by people you have not followed',
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7.0, right: 20, top: 7, bottom: 7),
                                  child: GestureDetector(
                                      onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ForumPage(
                                                  currentUserId: currentUserId),
                                            ),
                                          ),
                                      child: Hero(
                                        tag: 'explore',
                                        child: const Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            ' Tap  explore forums',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              )),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
