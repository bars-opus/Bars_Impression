import 'package:bars/utilities/exports.dart';

class TaggedUser extends StatefulWidget {
  static final id = 'TaggedUser';
  final String currentUserId;
  final String user;

  TaggedUser({
    required this.currentUserId,
    required this.user,
  });

  @override
  _TaggedUserState createState() => _TaggedUserState();
}

class _TaggedUserState extends State<TaggedUser> {
  late Future<QuerySnapshot> _users;
  int limit = 15;

  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setupArtist();
    _hideButtonController = ScrollController();
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setupArtist() async {
    setState(() {
      _users =
          DatabaseService.searchArtist(widget.user.substring(1).toUpperCase());
    });
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
                    color: Colors.white,
                  ),
                  backgroundColor: Color(0xFF1a1a1a),
                  centerTitle: true,
                ),
              ],
          body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Container(
              color: Color(0xFF1a1a1a),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        textScaleFactor: MediaQuery.of(context)
                            .textScaleFactor
                            .clamp(0.5, 1.5)),
                    child: FutureBuilder<QuerySnapshot>(
                        future: _users,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                SchimmerSkeleton(
                                  schimmerWidget: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    child: const CircleAvatar(
                                      backgroundColor: Color(0xFFf2f2f2),
                                      radius: 80.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SchimmerSkeleton(
                                  schimmerWidget: Container(
                                    height: 20,
                                    width: width - 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomRight,
                                          colors: [
                                            Colors.black.withOpacity(.5),
                                            Colors.black.withOpacity(.5)
                                          ]),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SchimmerSkeleton(
                                  schimmerWidget: Container(
                                    height: 10,
                                    width: width - 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomRight,
                                          colors: [
                                            Colors.black.withOpacity(.5),
                                            Colors.black.withOpacity(.5)
                                          ]),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SchimmerSkeleton(
                                  schimmerWidget: Container(
                                    height: 10,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomRight,
                                          colors: [
                                            Colors.black.withOpacity(.5),
                                            Colors.black.withOpacity(.5)
                                          ]),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          if (snapshot.data!.docs.length == 0) {
                            return Center(
                              child: Column(
                                children: [
                                  ShakeTransition(
                                    child: Icon(
                                      Icons.person_off_outlined,
                                      size: 40.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(widget.user.substring(1),
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('not found',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                            );
                          }
                          return Container(
                            height: width * 2,
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                AccountHolder? user = AccountHolder.fromDoc(
                                    snapshot.data!.docs[index]);
                                return Column(children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1a1a1a),
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    child: Hero(
                                      tag: 'useravater',
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFF1a1a1a),
                                        radius: width > 600 ? 120 : 80.0,
                                        backgroundImage:
                                            user.profileImageUrl!.isEmpty
                                                ? AssetImage(
                                                    'assets/images/user_placeholder.png',
                                                  ) as ImageProvider
                                                : CachedNetworkImageProvider(
                                                    user.profileImageUrl!),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: user.verified!.isNotEmpty
                                                ? 18.0
                                                : 0.0),
                                        child: new Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            user.userName!.toUpperCase(),
                                            style: TextStyle(
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.blueGrey
                                                  : Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      user.verified!.isEmpty
                                          ? const SizedBox.shrink()
                                          : Positioned(
                                              top: 3,
                                              right: 0,
                                              child: Icon(
                                                MdiIcons.checkboxMarkedCircle,
                                                size: 16,
                                                color: Colors.blue,
                                              ),
                                            ),
                                    ],
                                  ),
                                  Hero(
                                    tag: 'profileHandle',
                                    child: new Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        user.profileHandle!,
                                        style: TextStyle(
                                          color: ConfigBloc().darkModeOn
                                              ? Colors.blueGrey[300]
                                              : Colors.white,
                                          fontSize: width > 600 ? 30 : 14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Bio',
                                      style: TextStyle(
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.blueGrey[100]
                                            : Colors.grey,
                                        fontSize: width > 600 ? 16 : 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  HyperLinkText(
                                    from: 'Profile',
                                    text: user.bio!,
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Center(
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          primary: Colors.blue,
                                          side: BorderSide(
                                              width: 1.0, color: Colors.blue),
                                        ),
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ProfileScreen(
                                                      currentUserId:
                                                          Provider.of<UserData>(
                                                                  context)
                                                              .currentUserId!,
                                                      userId: user.id!,
                                                    ))),
                                        child: Text(
                                          'Go to profile',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]);
                              },
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
