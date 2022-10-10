import 'package:bars/utilities/exports.dart';

class InviteSearch extends StatefulWidget {
  static final id = 'InviteSearch';
  final String currentUserId;
  final Event event;
  final PaletteGenerator palette;

  InviteSearch({
    required this.currentUserId,
    required this.event,
    required this.palette,
  });

  @override
  _InviteSearchState createState() => _InviteSearchState();
}

class _InviteSearchState extends State<InviteSearch>
    with AutomaticKeepAliveClientMixin {
  List<DocId> _userList = [];
  final _userSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  bool _showInfo = true;
  late ScrollController _hideButtonController;
  Future<QuerySnapshot>? _users;
  String query = "";
  final _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _setUpFollower();
    __setShowInfo();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreFollowing();
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

  _setUpFollower() async {
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

  _loadMoreFollowing() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userSnapShot = await followingRef
        .doc(widget.currentUserId)
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

  _buildUserTile(AccountHolder user) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: user.profileImageUrl!.isEmpty
              ? Icon(
                  Icons.account_circle,
                  size: 60.0,
                  color: Colors.white,
                )
              : CircleAvatar(
                  radius: 25.0,
                  backgroundColor: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Color(0xFFf2f2f2),
                  backgroundImage:
                      CachedNetworkImageProvider(user.profileImageUrl!),
                ),
          title: Align(
            alignment: Alignment.topLeft,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(user.userName!,
                      style: TextStyle(
                        fontSize: width > 800 ? 18 : 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
                user.verified!.isEmpty
                    ? SizedBox.shrink()
                    : Positioned(
                        top: 3,
                        right: 0,
                        child: Icon(
                          MdiIcons.checkboxMarkedCircle,
                          size: 11,
                          color: Colors.blue,
                        ),
                      ),
              ],
            ),
          ),
          subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(user.profileHandle!,
                        style: TextStyle(
                          fontSize: width > 800 ? 14 : 12,
                          color: Colors.blue,
                        )),
                    Text(user.company!,
                        style: TextStyle(
                          fontSize: width > 800 ? 14 : 12,
                          color: Colors.blueGrey,
                        )),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      color: ConfigBloc().darkModeOn
                          ? Colors.grey[850]
                          : Colors.grey[350],
                    )
                  ],
                ),
              ]),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SendEventInviation(
                          user: user,
                          currentUserId:
                              Provider.of<UserData>(context).currentUserId!,
                          event: widget.event,
                          palette: widget.palette,
                        )));
          },
        ));
  }

  _buildFollowerBuilder() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scrollbar(
          controller: _hideButtonController,
          child: CustomScrollView(controller: _hideButtonController, slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  DocId user = _userList[index];
                  return FutureBuilder(
                    future: DatabaseService.getUserWithId(user.id),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
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
      ),
    );
  }

  _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
    setState(() {
      _users = null;
    });
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ResponsiveScaffold(
        child: ResponsiveScaffold(
      child: Scaffold(
          backgroundColor: widget.palette.darkMutedColor == null
              ? Color(0xFF1a1a1a)
              : widget.palette.darkMutedColor!.color,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor: widget.palette.darkMutedColor == null
                ? Color(0xFF1a1a1a)
                : widget.palette.darkMutedColor!.color,
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Material(
                color: Colors.white,
                elevation: 1.0,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  cursorColor: Colors.blue,
                  controller: _controller,
                  onChanged: (input) {
                    setState(() {
                      _users = DatabaseService.searchUsers(input.toUpperCase());
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    border: InputBorder.none,
                    hintText: 'Enter username',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 15.0,
                        color: Colors.black,
                      ),
                      onPressed: _clearSearch,
                    ),
                  ),
                  onSubmitted: (input) {
                    if (input.isNotEmpty) {
                      setState(() {
                        _users =
                            DatabaseService.searchUsers(input.toUpperCase());
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Container(
                  // ignore: unnecessary_null_comparison
                  child: _users == null
                      ? _buildFollowerBuilder()
                      : FutureBuilder<QuerySnapshot>(
                          future: _users,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  height: 250,
                                  width: 250,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.transparent,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                      Colors.grey,
                                    ),
                                    strokeWidth: 1,
                                  ),
                                ),
                              );
                            }
                            if (snapshot.data!.docs.length == 0) {
                              return Center(
                                child: RichText(
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
                                            '\nCheck username and try again.'),
                                  ],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Scrollbar(
                                child: CustomScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    slivers: [
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            AccountHolder? user =
                                                AccountHolder.fromDoc(
                                                    snapshot.data!.docs[index]);
                                            return _buildUserTile(user);
                                          },
                                          childCount:
                                              snapshot.data!.docs.length,
                                        ),
                                      ),
                                    ]),
                              ),
                            );
                          })),
            ),
          )),
    ));
  }
}
