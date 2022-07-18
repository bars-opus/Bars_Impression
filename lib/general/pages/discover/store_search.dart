import 'package:bars/utilities/exports.dart';

class StoreSearch extends StatefulWidget {
  final User? user;

  StoreSearch({required this.user});

  static final id = 'StoreSearch';

  @override
  _StoreSearchState createState() => _StoreSearchState();
}

class _StoreSearchState extends State<StoreSearch> {
  Future<QuerySnapshot>? _users;
  // Timer? _debounce;
  String query = "";
  // String _userName = '';
  Timer? _timer;

  // int _debouncetime = 1500;
  final _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();

    // _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // _controller.removeListener();
    _controller.dispose();
    super.dispose();
  }

  _onSearchChanged() async {
    if (_timer?.isActive != null) _timer!.cancel();
    _timer = Timer(Duration(milliseconds: 1500),  _search());
  }

  _search() {
    if (mounted) {
      setState(() {
        _users = DatabaseService.searchUsers(_controller.text.toUpperCase());
      });
      // }
    }
  }
  // if (_debounce == null) {
  // if (_debounce.isActive) _debounce.cancel();
  // _debounce = Timer(Duration(milliseconds: _debouncetime), () {
  //   if (_controller.text != "") {
  //     if (mounted) {
  //       setState(() {
  //         _users =
  //             DatabaseService.searchUsers(_controller.text.toUpperCase());
  //       });
  //     }
  //   }
  // });
  // }
  // }
  // _onSearchChanged() async {
  //   // if (_debounce == null) {
  //   // } else {
  //   //   return _debounce = Timer(Duration(milliseconds: _debouncetime), () {
  //   //     if (_debounce!.isActive) _debounce!.cancel();
  //   if (_userName.isNotEmpty) {
  //     if (mounted) {
  //       setState(() {
  //         _users = DatabaseService.searchUsers(_controller.text.toUpperCase());
  //       });
  //       //     }
  //     }
  //     // });
  //   }
  // }

  _buildUserTile(AccountHolder user) {
    return SearchUserTile(
        userName: user.userName!.toUpperCase(),
        profileHandle: user.profileHandle!,
        verified: user.verified,
        company: user.company!,
        profileImageUrl: user.profileImageUrl!,
        bio: user.bio!,
        score: user.score!,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        currentUserId:
                            Provider.of<UserData>(context).currentUserId,
                        userId: user.id!,
                        user: user,
                      )));
        });
  }

  _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
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
                  onChanged: (input) => _onSearchChanged(),
                  // setState(()
                  //   _users = DatabaseService.searchUsers(input.toUpperCase());
                  // });
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
                      ? Center(
                          child: NoContents(
                              title: "Searh for users. ",
                              subTitle:
                                  'Enter username, \ndon\'t enter a user\'s nickname.',
                              icon: Icons.search))
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
                                        childCount: snapshot.data!.docs.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
            ),
          )),
    );
  }
}
