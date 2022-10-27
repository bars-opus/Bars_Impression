import 'package:bars/utilities/exports.dart';

class FavoriteArtists extends StatefulWidget {
  static final id = 'FavoriteArtists';

  final String currentUserId;
  final String artist;
  final AccountHolder user;
  final int? artistFavoriteCount;

  FavoriteArtists(
      {required this.currentUserId,
      required this.artistFavoriteCount,
      required this.artist,
      required this.user});

  @override
  _FavoriteArtistsState createState() => _FavoriteArtistsState();
}

class _FavoriteArtistsState extends State<FavoriteArtists> {
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
  final _userSnapshot = <DocumentSnapshot>[];
  bool _hasNext = true;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setUpFeed();
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

  _setUpFeed() async {
    QuerySnapshot userSnapShot = await usersRef
        .where('favouriteArtist', isEqualTo: widget.artist)
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
        .where('favouriteArtist', isEqualTo: widget.artist)
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
    print('user ' + user.id!);
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
                          ? const SizedBox.shrink()
                          : Text(user.profileHandle!,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.blueGrey,
                              )),
                      user.company!.isEmpty
                          ? const SizedBox.shrink()
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
        child: ResponsiveScaffold(
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
                    'Favorite Artist',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                ),
              ],
          body: Container(
            color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: widget.artistFavoriteCount == 0
                        ? const SizedBox.shrink()
                        : Text(
                            'The following people listed ${widget.artist}  as their favorite artist',
                            style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: width > 600 ? 16 : 14,
                            )),
                  ),
                  widget.artistFavoriteCount == 0
                      ? Expanded(
                          child: Center(
                            child: NoContents(
                              icon: (Icons.favorite_border),
                              title: 'No Favorite yet,',
                              subTitle:
                                  'You are yet to be listed as a favorite artist, make sure you upload creative contents and update your professional and booking infomation correctly. ',
                            ),
                          ),
                        )
                      : Expanded(
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
                                            future:
                                                DatabaseService.getUserWithId(
                                                    user.id!),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              if (!snapshot.hasData) {
                                                return const SizedBox.shrink();
                                              }
                                              AccountHolder user =
                                                  snapshot.data;
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
                                          backgroundColor:
                                              ConfigBloc().darkModeOn
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
                                                    'Favorite Artist\nPlease Wait... '),
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
    ));
  }
}
