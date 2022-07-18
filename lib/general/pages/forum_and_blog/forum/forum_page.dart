import 'package:bars/utilities/exports.dart';

class ForumPage extends StatefulWidget {
  static final id = 'ForumPage';
  final String currentUserId;
  ForumPage({
    required this.currentUserId,
  });
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage>
    with AutomaticKeepAliveClientMixin {
  List<Forum> _forumList = [];
  final _forumSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFetchingForum = false;
  late ScrollController _hideButtonController;
  @override
  void initState() {
    super.initState();
    _setupForumFeed();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreForums();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setupForumFeed() async {
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

  _loadMoreForums() async {
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

  _buildDisplayForum() {
    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scrollbar(
          controller: _hideButtonController,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Forum forum = _forumList[index];
                    return FutureBuilder(
                        future: DatabaseService.getUserWithId(forum.authorId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return ForumSchimmerSkeleton();
                          }
                          AccountHolder author = snapshot.data;
                          return ForumView(
                            feed: 'All',
                            currentUserId: widget.currentUserId,
                            forum: forum,
                            author: author,
                            // forumList: _forumList,
                          );
                        });
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
          automaticallyImplyLeading: true,
          floating: true,
          snap: true,
          iconTheme: new IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          centerTitle: true,
          title: Text('Explore Forums',
              style: TextStyle(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              )),
        ),
      ],
      body: MediaQuery(
        data: MediaQuery.of(context).removePadding(
          removeTop: true,
        ),
        child: Material(
          child: Container(
            color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        textScaleFactor: MediaQuery.of(context)
                            .textScaleFactor
                            .clamp(0.5, 1.5)),
                    child: Expanded(
                      child: _forumList.length > 0
                          ? RefreshIndicator(
                              backgroundColor: Colors.white,
                              onRefresh: () async {
                                _setupForumFeed();
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: _buildDisplayForum()))
                          : _forumList.length == 0
                              ? RefreshIndicator(
                                  backgroundColor: Colors.white,
                                  onRefresh: () async {
                                    _setupForumFeed();
                                  },
                                  child: Center(
                                    child: SizedBox.shrink(),
                                  ),
                                )
                              : Center(
                                  child: UserSchimmer(),
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
