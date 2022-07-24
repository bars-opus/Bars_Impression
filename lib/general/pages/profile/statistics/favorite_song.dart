import 'package:bars/utilities/exports.dart';

class FavoriteSong extends StatefulWidget {
  static final id = 'FavoriteSong';

  final String currentUserId;
  final String song;
  final AccountHolder user;

  FavoriteSong(
      {required this.currentUserId, required this.song, required this.user});

  @override
  _FavoriteSongState createState() => _FavoriteSongState();
}

class _FavoriteSongState extends State<FavoriteSong> {
  RandomColor _randomColor = RandomColor();
  final List<ColorHue> _hueType = <ColorHue>[
    ColorHue.green,
    ColorHue.red,
    ColorHue.pink,
    ColorHue.purple,
    ColorHue.blue,
    ColorHue.yellow,
    ColorHue.orange
  ];

  ColorSaturation _colorSaturation = ColorSaturation.random;

  List<AccountHolder> _users = [];
  int limit = 10;
  bool _isFetchingUsers = false;
  bool _hasNext = true;
  final _userSnapshot = <DocumentSnapshot>[];
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setUpFeed();
    _hideButtonController = ScrollController();
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_hideButtonController.position.extentAfter == 0) {
      _loadMoreUsers();
    }
    return false;
  }

  _setUpFeed() async {
    QuerySnapshot userSnapShot = await usersRef
        .where('favouriteSong', isEqualTo: widget.song)
        .limit(limit)
        .get();
    List<AccountHolder> users =
        userSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    _userSnapshot.addAll((userSnapShot.docs));
    if (mounted) {
      setState(() {
        _users = users;
      });
    }
    return users;
  }

  _loadMoreUsers() async {
    if (_isFetchingUsers) return;
    _isFetchingUsers = true;
    _hasNext = true;
    QuerySnapshot userSnapShot = await usersRef
        .where('favouriteSong', isEqualTo: widget.song)
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();
    List<AccountHolder> moreusers =
        userSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    List<AccountHolder> allusers = _users..addAll(moreusers);
    _userSnapshot.addAll((userSnapShot.docs));
    if (mounted) {
      setState(() {
        _users = allusers;
      });
    }
    _hasNext = false;
    _isFetchingUsers = false;
    return _hasNext;
  }

  _buildUserTile(AccountHolder user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProfileScreen(
                      currentUserId:
                          Provider.of<UserData>(context).currentUserId!,
                      userId: user.id!,
                      user: widget.user,
                    ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Color(0xFFf2f2f2),
                    radius: 25.0,
                    backgroundImage: user.profileImageUrl!.isEmpty
                        ? AssetImage(
                            ConfigBloc().darkModeOn
                                ? 'assets/images/user_placeholder.png'
                                : 'assets/images/user_placeholder2.png',
                          ) as ImageProvider
                        : CachedNetworkImageProvider(user.profileImageUrl!),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.userName!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Container(
                          color: _randomColor.randomColor(
                            colorHue: ColorHue.multiple(colorHues: _hueType),
                            colorSaturation: _colorSaturation,
                          ),
                          height: 1.0,
                          width: 25.0,
                        ),
                      ),
                      user.profileHandle!.isEmpty
                          ? SizedBox.shrink()
                          : Text(user.profileHandle!,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.blueGrey,
                              )),
                      user.company!.isEmpty
                          ? SizedBox.shrink()
                          : Text(user.company!,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              )),
                    ],
                  ),
                ]),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
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
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  ),
                  backgroundColor: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Colors.white,
                  title: Text(
                    'Favorite Song',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
//           ),
                ),
              ],
          body: Container(
            color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        'The following people listed ${widget.song}  as their favorite song',
                        style: TextStyle(
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                          fontSize: width > 600 ? 16 : 14,
                        )),
                  ),
                  Expanded(
                      child: _users.length > 0
                          ? NotificationListener<ScrollNotification>(
                              onNotification: _handleScrollNotification,
                              child: Scrollbar(
                                  child: CustomScrollView(slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      AccountHolder user = _users[index];
                                      return FutureBuilder(
                                        future: DatabaseService.getUserWithId(
                                            user.id!),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (!snapshot.hasData) {
                                            return SizedBox.shrink();
                                          }
                                          AccountHolder user = snapshot.data;
                                          return _buildUserTile(user);
                                        },
                                      );
                                    },
                                    childCount: _users.length,
                                  ),
                                )
                              ])),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 250,
                                    width: 250,
                                    child: CircularProgressIndicator(
                                      backgroundColor: ConfigBloc().darkModeOn
                                          ? Color(0xFF1a1a1a)
                                          : Colors.white,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                        Colors.grey,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Shimmer.fromColors(
                                    period: Duration(milliseconds: 1000),
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.white,
                                    child: RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "Loading ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey)),
                                        TextSpan(
                                            text:
                                                'Favorite Song\nPlease Wait... '),
                                      ],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    )),
                                  ),
                                ],
                              ),
                            ))
                ]),
          )),
    );
  }
}
