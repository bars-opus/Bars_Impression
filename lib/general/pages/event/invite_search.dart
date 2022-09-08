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
    return UserListTile(
        user: user,
        onPressed: () {
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
        });
  }

  _buildEventBuilder() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: NotificationListener<ScrollNotification>(
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
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Material(
                color: ConfigBloc().darkModeOn
                    ? Color(0xFFf2f2f2)
                    : Color(0xFF1a1a1a),
                elevation: 1.0,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                child: TextField(
                  style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                  ),
                  cursorColor: Colors.blue,
                  controller: _controller,
                  onChanged: (input) {
                    setState(() {
                      _users = DatabaseService.searchUsers(input.toUpperCase());
                    });
                  },

                  // },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    border: InputBorder.none,
                    hintText: 'Enter username',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.0,
                      color:
                          ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 15.0,
                        color: ConfigBloc().darkModeOn
                            ? Colors.black
                            : Colors.white,
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
                      ? _buildEventBuilder()
                      //  Center(
                      //     child: NoContents(
                      //         title: "Searh for users. ",
                      //         subTitle:
                      //             'Enter username, \ndon\'t enter a user\'s nickname.',
                      //         icon: Icons.search))
                      : FutureBuilder<QuerySnapshot>(
                          future: _users,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return SearchUserSchimmer();
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
    )

        // NestedScrollView(
        //   controller: _hideButtonController,
        //   headerSliverBuilder: (context, innerBoxScrolled) => [
        //     SliverAppBar(
        //       elevation: 0.0,
        //       automaticallyImplyLeading: true,
        //       floating: true,
        //       snap: true,
        //       pinned: true,
        //       iconTheme: new IconThemeData(
        //         color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        //       ),
        //       backgroundColor:
        //           ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
        //       title: Text(
        //         'Invtite',
        //         style: TextStyle(
        //             color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        //             fontSize: 20,
        //             fontWeight: FontWeight.bold),
        //       ),
        //       centerTitle: true,
        //     ),
        //   ],
        //   body: MediaQuery.removePadding(
        //     context: context,
        //     removeTop: true,
        //     child: Container(
        //       color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
        //       child: SafeArea(
        //         child: MediaQuery(
        //           data: MediaQuery.of(context).copyWith(
        //               textScaleFactor:
        //                   MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: <Widget>[
        //               AnimatedContainer(
        //                   curve: Curves.easeInOut,
        //                   duration: Duration(milliseconds: 800),
        //                   height: _showInfo ? 50 : 0.0,
        //                   width: double.infinity,
        //                   color: Colors.blue,
        //                   child: ShakeTransition(
        //                     child: ListTile(
        //                       title:
        //                           Text('Other users can\'t see your following.',
        //                               style: TextStyle(
        //                                 color: Colors.white,
        //                                 fontSize: 12,
        //                               )),
        //                       leading: IconButton(
        //                         icon: Icon(Icons.info_outline_rounded),
        //                         iconSize: 20.0,
        //                         color:
        //                             _showInfo ? Colors.white : Colors.transparent,
        //                         onPressed: () => () {},
        //                       ),
        //                     ),
        //                   )),
        //               SizedBox(
        //                 height: 30.0,
        //               ),
        //               Expanded(
        //                 child: _buildEventBuilder(),
        //                 //  widget.followingCount > 0
        //                 //     ? _buildEventBuilder()
        //                 //     : _userList.length > 0
        //                 //         ? Expanded(
        //                 //             child: Center(
        //                 //               child: NoContents(
        //                 //                 icon: (Icons.people_outline),
        //                 //                 title: 'No following yet,',
        //                 //                 subTitle:
        //                 //                     'You are not following anybody yet, follow people to see the contents they create and connect with them for collaborations ',
        //                 //               ),
        //                 //             ),
        //                 //           )
        //                 //         : Center(child: FollowUserSchimmer()),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        );
  }
}
