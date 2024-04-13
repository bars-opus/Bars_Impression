import 'package:bars/utilities/exports.dart';
import 'package:bars/widgets/general_widget/loading_chats.dart';

class FollowerFollowing extends StatefulWidget {
  static final id = 'FollowerFollowing';
  final String userId;
  final int followerCount;
  final int followingCount;
  final String follower;
  FollowerFollowing({
    required this.userId,
    required this.followerCount,
    required this.followingCount,
    required this.follower,
  });

  @override
  _FollowerFollowingState createState() => _FollowerFollowingState();
}

class _FollowerFollowingState extends State<FollowerFollowing>
    with AutomaticKeepAliveClientMixin {
  List<DocId> _userList = [];
  final _userSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  // bool _showInfo = true;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    widget.follower.startsWith('Follower')
        ? _setUpFollower()
        : _setUpFollowing();
    // __setShowInfo();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        widget.follower.startsWith('Follower')
            ? _loadMoreFollower()
            : _loadMoreFollowing();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  // __setShowInfo() {
  //   if (_showInfo) {
  //     Timer(Duration(seconds: 7), () {
  //       if (mounted) {
  //         setState(() {
  //           _showInfo = false;
  //         });
  //       }
  //     });
  //   }
  // }

  _setUpFollower() async {
    QuerySnapshot userSnapShot = await followersRef
        .doc(widget.userId)
        .collection('userFollowers')
        .limit(limit)
        .get();
    List<DocId> users =
        userSnapShot.docs.map((doc) => DocId.fromDoc(doc)).toList();
    _userSnapshot.addAll((userSnapShot.docs));
    if (mounted) {
      print(users.length.toString());
      setState(() {
        _hasNext = false;
        _userList = users;
      });
    }
    return users;
  }

  _loadMoreFollower() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userSnapShot = await followersRef
        .doc(widget.userId)
        .collection('userFollowers')
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();
    List<DocId> moreusers =
        userSnapShot.docs.map((doc) => DocId.fromDoc(doc)).toList();
    if (_userSnapshot.length < limit) _hasNext = false;
    List<DocId> allusers = _userList..addAll(moreusers);
    _userSnapshot.addAll((userSnapShot.docs));
    if (mounted) {
      setState(() {
        _userList = allusers;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _setUpFollowing() async {
    QuerySnapshot userSnapShot = await followingRef
        .doc(widget.userId)
        .collection('userFollowing')
        .limit(limit)
        .get();
    List<DocId> users =
        userSnapShot.docs.map((doc) => DocId.fromDoc(doc)).toList();
    _userSnapshot.addAll((userSnapShot.docs));
    if (mounted) {
      print(users.length.toString());
      setState(() {
        _hasNext = false;
        _userList = users;
      });
    }
    return users;
  }

  _loadMoreFollowing() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userSnapShot = await followingRef
        .doc(widget.userId)
        .collection('userFollowing')
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();
    List<DocId> moreusers =
        userSnapShot.docs.map((doc) => DocId.fromDoc(doc)).toList();
    if (_userSnapshot.length < limit) _hasNext = false;
    List<DocId> allusers = _userList..addAll(moreusers);
    _userSnapshot.addAll((userSnapShot.docs));
    if (mounted) {
      setState(() {
        _userList = allusers;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _buildUserTile(AccountHolderAuthor user) {
    return UserListTile(
        user: user,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        user: null,
                        currentUserId:
                            Provider.of<UserData>(context).currentUserId!,
                        userId: user.userId!,
                      )));
        });
  }

  _buildEventBuilder() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scrollbar(
        child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                DocId user = _userList[index];
                return FutureBuilder(
                  future: DatabaseService.getUserWithId(user.id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for the future to resolve, show the skeleton.
                      return FollowerUserSchimmerSkeleton();
                    } else if (snapshot.hasError) {
                      // If the future completes with an error, handle it appropriately.
                      debugPrint('Error: ${snapshot.error}');
                      return Text('Something went wrong');
                    } else if (!snapshot.hasData) {
                      return Material(
                        color: Colors.transparent,
                        child: LoadingChats(
                          deleted: true,
                          userId: user.id,
                          onPressed: () {},
                        ),
                      );
                      // No error, but there's also no data. This might indicate a null user.
                      // debugPrint(
                      //     'No data available for user with id: ${user.id}');
                      // return SizedBox.shrink();
                    } else {
                      // Data is available.
                      AccountHolderAuthor? _user = snapshot.data;
                      debugPrint('User data: $_user');
                      return _user == null
                          ? LoadingChats(
                              deleted: true,
                              userId: user.id,
                              onPressed: () {},
                            )
                          : widget.userId == _user.userId
                              ? SizedBox.shrink()
                              : _buildUserTile(_user);
                    }
                  },
                );

                // FutureBuilder(
                //   future: DatabaseService.getUserWithId(user.id),
                //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                //     if (!snapshot.hasData) {
                //       return FollowerUserSchimmerSkeleton();
                //     }
                //     AccountHolderAuthor? _user = snapshot.data;
                //     return _user == null
                //         ? SizedBox.shrink()
                //         : widget.userId == _user.userId
                //             ? const SizedBox.shrink()
                //             : _buildUserTile(_user);
                //   },
                // );
              },
              childCount: _userList.length,
            ),
          )
        ]),
      ),
    );
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
          pinned: true,
          iconTheme: new IconThemeData(
            color: Theme.of(context).secondaryHeaderColor,
          ),
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text(
            widget.follower.startsWith('Follower') ? 'Followers' : 'Following',
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ],
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: Theme.of(context).primaryColorLight,
          child: SafeArea(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaleFactor:
                      MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  widget.follower.startsWith('Follower')
                      ? Expanded(
                          child: widget.followerCount > 0
                              ? _buildEventBuilder()
                              : _userList.length > 0
                                  ? Expanded(
                                      child: Center(
                                        child: NoContents(
                                          icon: (Icons.people_outline),
                                          title: 'No followers yet,',
                                          subTitle:
                                              'You don\'t have any follower yet. Make sure you have update your profile with the neccessary information and upload creative contents in order for people to follower you. ',
                                        ),
                                      ),
                                    )
                                  : Center(child: FollowUserSchimmer()),
                        )
                      : Expanded(
                          child: widget.followingCount > 0
                              ? _buildEventBuilder()
                              : _userList.length > 0
                                  ? Expanded(
                                      child: Center(
                                        child: NoContents(
                                          icon: (Icons.people_outline),
                                          title: 'No following yet,',
                                          subTitle:
                                              'You are not following anybody yet, follow people to see the contents they create and connect with them for collaborations ',
                                        ),
                                      ),
                                    )
                                  : Center(child: FollowUserSchimmer()),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
