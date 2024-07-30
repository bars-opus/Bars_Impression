import 'package:bars/utilities/exports.dart';

class BlockedAccounts extends StatefulWidget {
  static final id = 'BlockedAccounts';

  @override
  _BlockedAccountsState createState() => _BlockedAccountsState();
}

class _BlockedAccountsState extends State<BlockedAccounts>
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
    QuerySnapshot userSnapShot = await usersBlockedRef
        .doc(Provider.of<UserData>(context, listen: false).currentUserId)
        .collection('userBlocked')
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
    QuerySnapshot userSnapShot = await usersBlockedRef
        .doc(Provider.of<UserData>(context).currentUserId)
        .collection('userBlocked')
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
                        userId: user.userId!,
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
                  future: DatabaseService.getUserWithId(user.id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return FollowerUserSchimmerSkeleton();
                    }
                    AccountHolderAuthor user = snapshot.data;
                    return Provider.of<UserData>(context).currentUserId ==
                            user.userId
                        ? const SizedBox.shrink()
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
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: NestedScrollView(
        controller: _hideButtonController,
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SliverAppBar(
            elevation: 0.0,
            automaticallyImplyLeading: true,
            floating: true,
            snap: true,
            pinned: true,
            surfaceTintColor: Colors.transparent,
            iconTheme: new IconThemeData(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            backgroundColor: Theme.of(context).primaryColorLight,
            title: Text(
              'Blocked Accounts',
              style: Theme.of(context).textTheme.bodyLarge,
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
                child: Material(
                  color: Theme.of(context).primaryColorLight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          ' ${_userList.length.toString()} blocked accounts',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: .2,
                      ),
                      _userList.length == 0
                          ? Expanded(
                              child: Center(
                                child: NoContents(
                                  icon: (Icons.block),
                                  title: 'No blocked Accounts,',
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
      ),
    );
  }
}
