import 'package:bars/utilities/exports.dart';

class ThoughtLikeAccounts extends StatefulWidget {
  static final id = 'ThoughtLikeAccounts';

  final Thought thought;

  ThoughtLikeAccounts({
    required this.thought,
  });

  @override
  _ThoughtLikeAccountsState createState() => _ThoughtLikeAccountsState();
}

class _ThoughtLikeAccountsState extends State<ThoughtLikeAccounts>
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
    QuerySnapshot userSnapShot = await thoughtsLikeRef
        .doc(widget.thought.id)
        .collection('thoughtLikes')
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
    QuerySnapshot userSnapShot = await thoughtsLikeRef
        .doc(widget.thought.id)
        .collection('thoughtLikes')
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
                        currentUserId:
                            Provider.of<UserData>(context).currentUserId!,
                        userId: user.id!,
                        user: null,
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
                  future: DatabaseService.getUserAuthorWithId(user.id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return FollowerUserSchimmerSkeleton();
                    }
                    AccountHolderAuthor user = snapshot.data;
                    return _buildUserTile(user);
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
              'Like by:',
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
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaleFactor:
                        MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        ' ${_userList.length.toString()} likes',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Divider(),
                    _userList.length == 0
                        ? Expanded(
                            child: Center(
                              child: NoContents(
                                icon: (Icons.favorite_outline),
                                title: 'No likes',
                                subTitle: '',
                              ),
                            ),
                          )
                        : Expanded(child: _buildEventBuilder())
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
