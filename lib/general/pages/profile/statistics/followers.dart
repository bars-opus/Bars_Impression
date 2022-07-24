import 'package:bars/utilities/exports.dart';

class Followers extends StatefulWidget {
  static final id = 'Followers';
  final String currentUserId;
  final int followersCount;
  Followers({
    required this.currentUserId,
    required this.followersCount,
  });

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers>
    with AutomaticKeepAliveClientMixin {
  List<DocId> _userList = [];
  final _userSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  bool _showInfo = true;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setUpFeed();
    __setShowInfo();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreUsers();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  __setShowInfo() {
    if (_showInfo) {
      Timer(Duration(seconds: 7), () {
        if (mounted) {
          setState(() {
            _showInfo = false;
          });
        }
      });
    }
  }

  _setUpFeed() async {
    QuerySnapshot userSnapShot = await followersRef
        .doc(widget.currentUserId)
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

  _loadMoreUsers() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userSnapShot = await followersRef
        .doc(widget.currentUserId)
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

  _buildUserTile(AccountHolder user) {
    return UserListTile(
        user: user,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        currentUserId:
                            Provider.of<UserData>(context).currentUserId!,
                        userId: user.id!, user: null,
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
                    if (!snapshot.hasData) {
                      return FollowerUserSchimmerSkeleton();
                    }
                    AccountHolder user = snapshot.data;
                    return widget.currentUserId == user.id
                        ? SizedBox.shrink()
                        : _buildUserTile(user);
                  },
                );
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
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            title: Text(
              'Followers',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
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
              child:   MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        textScaleFactor: MediaQuery.of(context)
                            .textScaleFactor
                            .clamp(0.5, 1.5)),
                              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AnimatedContainer(
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 800),
                        height: _showInfo ? 50 : 0.0,
                        width: double.infinity,
                        color: Colors.blue,
                        child: ShakeTransition(
                          child: ListTile(
                            title: Text('Other users can\'t see your followers.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                            leading: IconButton(
                              icon: Icon(Icons.info_outline_rounded),
                              iconSize: 20.0,
                              color:
                                  _showInfo ? Colors.white : Colors.transparent,
                              onPressed: () => () {},
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 30.0,
                    ),
                    Expanded(
                      child: widget.followersCount > 0
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
