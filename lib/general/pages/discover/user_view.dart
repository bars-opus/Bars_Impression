import 'package:bars/utilities/exports.dart';

class UserView extends StatefulWidget {
  final String currentUserId;
  final String userId;
  final AccountHolder user;
  final String exploreLocation;

  UserView(
      {required this.currentUserId,
      required this.exploreLocation,
      required this.userId,
      required this.user});

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
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

  _userFans() {
    final width = MediaQuery.of(context).size.width;
    return Container(
        height: Responsive.isDesktop(context) ? 350 : 250,
        child: FocusedMenuHolder(
          menuWidth: width,
          menuOffset: 10,
          blurBackgroundColor:
              ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white10,
          openWithTap: false,
          onPressed: () {},
          menuItems: [
            FocusedMenuItem(
                title: Container(
                  width: width / 2,
                  child: Text(
                    'Go to ${widget.user.userName}\'s profile ',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              currentUserId:
                                  Provider.of<UserData>(context).currentUserId!,
                              userId: widget.userId,
                            )))),
            FocusedMenuItem(
                title: Container(
                  width: width / 2,
                  child: const Text(
                    'Report',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportContentPage(
                              contentId: widget.user.id!,
                              contentType: widget.user.userName!,
                              parentContentId: widget.user.id!,
                              repotedAuthorId: widget.user.id!,
                            )))),
          ],
          child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            currentUserId:
                                Provider.of<UserData>(context).currentUserId!,
                            userId: widget.userId,
                          ))),
              child: Container(
                  width: width,
                  child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              right: 12.0, top: 12, bottom: 12),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        color: ConfigBloc().darkModeOn
                                            ? Color(0xFF1a1a1a)
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            ConfigBloc().darkModeOn
                                                ? Color(0xFF1a1a1a)
                                                : Colors.white,
                                        radius: 25.0,
                                        backgroundImage: widget
                                                .user.profileImageUrl!.isEmpty
                                            ? AssetImage(
                                                ConfigBloc().darkModeOn
                                                    ? 'assets/images/user_placeholder.png'
                                                    : 'assets/images/user_placeholder2.png',
                                              ) as ImageProvider
                                            : CachedNetworkImageProvider(
                                                widget.user.profileImageUrl!),
                                      ),
                                    ),
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0, bottom: 7),
                                              child: RichText(
                                                  textScaleFactor:
                                                      MediaQuery.of(context)
                                                          .textScaleFactor,
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text: widget
                                                          .user.userName!
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: width > 800
                                                              ? 18
                                                              : 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: ConfigBloc()
                                                                  .darkModeOn
                                                              ? Colors.white
                                                              : Colors.black,
                                                          shadows: [
                                                            const BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(0, 10),
                                                              blurRadius: 10.0,
                                                              spreadRadius: 2.0,
                                                            )
                                                          ]),
                                                    )
                                                  ])),
                                            ),
                                            widget.user.verified!.isEmpty
                                                ? SizedBox.shrink()
                                                : Positioned(
                                                    top: -17,
                                                    right: -10,
                                                    child: IconButton(
                                                        icon: Icon(
                                                          MdiIcons
                                                              .checkboxMarkedCircle,
                                                        ),
                                                        iconSize: 12,
                                                        color: Colors.blue,
                                                        onPressed: () {}),
                                                  ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: _randomColor.randomColor(
                                                  colorHue: ColorHue.multiple(
                                                      colorHues: _hueType),
                                                  colorSaturation:
                                                      _colorSaturation,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                boxShadow: [
                                                  const BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(0, 10),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 2.0,
                                                  )
                                                ]),
                                            height: 1.0,
                                            width: 50.0,
                                          ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: RichText(
                                            textScaleFactor:
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: widget
                                                          .user.company!.isEmpty
                                                      ? ''
                                                      : '${widget.user.company}\n',
                                                  style: TextStyle(
                                                    fontSize:
                                                        width > 800 ? 14 : 12,
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        "City/ Country/ Continent: ",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    )),
                                                TextSpan(
                                                    text:
                                                        "${widget.user.city}/ ${widget.user.country}/  ${widget.user.continent}",
                                                    style: TextStyle(
                                                      fontSize:
                                                          width > 800 ? 14 : 12,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.white
                                                          : Colors.black,
                                                    )),
                                                TextSpan(
                                                    text: "\nBio: ",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    )),
                                                TextSpan(
                                                  text: " ${widget.user.bio}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        width > 800 ? 14 : 12,
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        " \nFavorite Punchline:  ",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    )),
                                                TextSpan(
                                                    text:
                                                        " ${widget.user.favouritePunchline}\n",
                                                    style: TextStyle(
                                                      fontSize:
                                                          width > 800 ? 14 : 12,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.white
                                                          : Colors.black,
                                                    )),
                                                TextSpan(
                                                    text: 'Favorite Musician',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    )),
                                                TextSpan(
                                                    text:
                                                        " ${widget.user.favouriteArtist}\n",
                                                    style: TextStyle(
                                                      fontSize:
                                                          width > 800 ? 14 : 12,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.white
                                                          : Colors.black,
                                                    )),
                                                TextSpan(
                                                    text: 'Favorite Song',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    )),
                                                TextSpan(
                                                    text:
                                                        " ${widget.user.favouriteSong}\n",
                                                    style: TextStyle(
                                                      fontSize: width > 800
                                                          ? 14
                                                          : 12.0,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.white
                                                          : Colors.black,
                                                    )),
                                                TextSpan(
                                                    text: 'Favorite Album',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    )),
                                                TextSpan(
                                                    text:
                                                        " ${widget.user.favouriteAlbum}",
                                                    style: TextStyle(
                                                      fontSize:
                                                          width > 800 ? 14 : 12,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.white
                                                          : Colors.black,
                                                    )),
                                              ],
                                            ),
                                            maxLines: 16,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ProfileScreen(
                                                  currentUserId:
                                                      Provider.of<UserData>(
                                                              context)
                                                          .currentUserId!,
                                                  userId: widget.userId,
                                                )))),
                              ]))))),
        ));
  }

  _userOthers() {
    final width = MediaQuery.of(context).size.width;
    return FocusedMenuHolder(
        menuWidth: width,
        menuOffset: 10,
        blurBackgroundColor:
            ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white10,
        openWithTap: false,
        onPressed: () {},
        menuItems: [
          FocusedMenuItem(
              title: Container(
                width: width / 2,
                child: Text(
                  'Go to ${widget.user.userName}\' profile ',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            currentUserId:
                                Provider.of<UserData>(context).currentUserId!,
                            userId: widget.userId,
                          )))),
          FocusedMenuItem(
            title: Text(
              'Go to Booking Page',
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfessionalProfile(
                          exploreLocation: widget.exploreLocation,
                          currentUserId:
                              Provider.of<UserData>(context).currentUserId!,
                          user: widget.user,
                          userId: widget.user.id!,
                        ))),
          ),
          FocusedMenuItem(
            title: Text(
              'Rate me here',
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileRating(
                          user: widget.user,
                          currentUserId: widget.currentUserId,
                        ))),
          ),
          FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Leave an advice for ${widget.user.userName}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => UserAdviceScreen(
                          currentUserId: widget.currentUserId,
                          user: widget.user,
                        ))),
          ),
          FocusedMenuItem(
              title: Container(
                width: width / 2,
                child: const Text(
                  'Report',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ReportContentPage(
                            contentId: widget.user.id!,
                            contentType: widget.user.userName!,
                            parentContentId: widget.user.id!,
                            repotedAuthorId: widget.user.id!,
                          )))),
          FocusedMenuItem(
              title: Container(
                width: width / 2,
                child: const Text(
                  'Suggestion Box',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SuggestionBox()))),
        ],
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfessionalProfile(
                        exploreLocation: widget.exploreLocation,
                        currentUserId:
                            Provider.of<UserData>(context).currentUserId!,
                        user: widget.user,
                        userId: widget.user.id!,
                      ))),
          child: Container(
            height: Responsive.isDesktop(context) ? 350 : 250,
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileProfessionalProfile(
                            currentUserId:
                                Provider.of<UserData>(context).currentUserId!,
                            user: widget.user,
                            userId: widget.user.id!,
                          ))),
              child: Container(
                width: width,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                color: ConfigBloc().darkModeOn
                                    ? Color(0xFF1a1a1a)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: Hero(
                                tag: 'container1' + widget.user.id.toString(),
                                child: CircleAvatar(
                                  backgroundColor: ConfigBloc().darkModeOn
                                      ? Color(0xFF1a1a1a)
                                      : Colors.white,
                                  radius: 25.0,
                                  backgroundImage:
                                      widget.user.profileImageUrl!.isEmpty
                                          ? AssetImage(
                                              ConfigBloc().darkModeOn
                                                  ? 'assets/images/user_placeholder.png'
                                                  : 'assets/images/user_placeholder2.png',
                                            ) as ImageProvider
                                          : CachedNetworkImageProvider(
                                              widget.user.profileImageUrl!),
                                ),
                              ),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20.0, bottom: 7),
                                      child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: widget.user.userName!
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize:
                                                      width > 800 ? 18 : 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.white
                                                      : Colors.black,
                                                  shadows: [
                                                    const BoxShadow(
                                                      color: Colors.black26,
                                                      offset: Offset(0, 10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 2.0,
                                                    )
                                                  ]),
                                            )
                                          ])),
                                    ),
                                    widget.user.verified!.isEmpty
                                        ? SizedBox.shrink()
                                        : Positioned(
                                            top: -17,
                                            right: -10,
                                            child: IconButton(
                                                icon: Icon(
                                                  MdiIcons.checkboxMarkedCircle,
                                                ),
                                                iconSize: 12,
                                                color: Colors.blue,
                                                onPressed: () {}),
                                          ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: _randomColor.randomColor(
                                          colorHue: ColorHue.multiple(
                                              colorHues: _hueType),
                                          colorSaturation: _colorSaturation,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        boxShadow: [
                                          const BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0, 10),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          )
                                        ]),
                                    height: 1.0,
                                    width: 50.0,
                                  ),
                                ),
                                Stars(
                                  score: widget.user.score!,
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: RichText(
                                    textScaleFactor:
                                        MediaQuery.of(context).textScaleFactor,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: widget.user.profileHandle!,
                                          style: TextStyle(
                                            fontSize: width > 800 ? 14 : 12,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                widget.user.report!.isNotEmpty
                                    ? Column(
                                        children: [
                                          Divider(
                                            color: Colors.red,
                                          ),
                                          ListTile(
                                            title: Text(
                                                widget.user.userName! +
                                                    ': reported for violating guidelines. ',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                )),
                                            leading: IconButton(
                                              icon: Icon(
                                                  Icons.info_outline_rounded),
                                              iconSize: 20.0,
                                              color: Colors.red,
                                              onPressed: () => () {},
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.red,
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                            subtitle: RichText(
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget.user.company!.isEmpty
                                        ? ''
                                        : '${widget.user.company}\n',
                                    style: TextStyle(
                                      fontSize: width > 800 ? 14 : 12,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  TextSpan(
                                      text: "City/ Country/ Continent: ",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text:
                                          "${widget.user.city}/ ${widget.user.country}/  ${widget.user.continent}",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 14 : 12,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: "\nBio: ",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                    text: " ${widget.user.bio}",
                                    style: TextStyle(
                                      fontSize: width > 800 ? 14 : 12,
                                      color: ConfigBloc().darkModeOn
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                      text: " \nSkills:  ",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text: " ${widget.user.skills}\n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 14 : 12,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: widget.user.profileHandle!
                                              .startsWith('Ar')
                                          ? 'Music Collaborations:'
                                          : widget.user.profileHandle!
                                                  .startsWith('Co')
                                              ? 'Design Collaborations:'
                                              : widget.user.profileHandle!
                                                      .startsWith('Da')
                                                  ? 'Danced With:'
                                                  : widget.user.profileHandle!
                                                          .startsWith('M')
                                                      ? 'Video Works:'
                                                      : widget.user.profileHandle!
                                                              .endsWith('xen')
                                                          ? 'Video appearances:'
                                                          : widget.user
                                                                  .profileHandle!
                                                                  .startsWith(
                                                                      'Bl')
                                                              ? 'Blogged About:'
                                                              : widget.user
                                                                      .profileHandle!
                                                                      .startsWith(
                                                                          'Ph')
                                                                  ? 'Worked With:'
                                                                  : widget.user
                                                                          .profileHandle!
                                                                          .startsWith(
                                                                              'Ba')
                                                                      ? 'Battled Against:'
                                                                      : widget.user
                                                                              .profileHandle!
                                                                              .endsWith('J')
                                                                          ? 'Dj Collaborations:'
                                                                          : widget.user.profileHandle!.startsWith('Make')
                                                                              ? 'Worked For:'
                                                                              : widget.user.profileHandle!.startsWith('Re')
                                                                                  ? 'Partners:'
                                                                                  : widget.user.profileHandle!.startsWith('Pr')
                                                                                      ? 'Production Collaborations:'
                                                                                      : '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text: " ${widget.user.collaborations}\n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 14 : 12,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: widget.user.performances!.isEmpty
                                          ? ''
                                          : widget.user.profileHandle!
                                                      .startsWith('Pr') ||
                                                  widget.user.profileHandle!
                                                      .startsWith("Bl") ||
                                                  widget.user.profileHandle!
                                                      .startsWith("Br") ||
                                                  widget.user.profileHandle!
                                                      .startsWith("Mak") ||
                                                  widget.user.profileHandle!
                                                      .startsWith("Re") ||
                                                  widget.user.profileHandle!
                                                      .startsWith("Mu") ||
                                                  widget.user.profileHandle!
                                                      .endsWith("xen")
                                              ? ''
                                              : widget.user.profileHandle!
                                                      .startsWith('Ar')
                                                  ? 'Music Performances: '
                                                  : widget.user.profileHandle!
                                                          .startsWith('Co')
                                                      ? 'Design Exhibitions: '
                                                      : widget.user
                                                              .profileHandle!
                                                              .startsWith('Ph')
                                                          ? 'Photo Exhibitions: '
                                                          : widget.user
                                                                  .profileHandle!
                                                                  .startsWith(
                                                                      'Da')
                                                              ? 'Dance performancess: '
                                                              : widget.user
                                                                      .profileHandle!
                                                                      .startsWith(
                                                                          'Ba')
                                                                  ? 'Batlle Stages: '
                                                                  : widget.user
                                                                          .profileHandle!
                                                                          .endsWith('J')
                                                                      ? 'Performances: '
                                                                      : '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text: widget.user.performances!.isEmpty
                                          ? ''
                                          : widget.user.profileHandle!
                                                      .startsWith('Pr') ||
                                                  widget.user.profileHandle!
                                                      .startsWith("Bl") ||
                                                  widget.user.profileHandle!
                                                      .startsWith("Br") ||
                                                  widget.user.profileHandle!
                                                      .startsWith("Mak") ||
                                                  widget.user.profileHandle!
                                                      .startsWith("Re") ||
                                                  widget.user.profileHandle!
                                                      .startsWith("Mu") ||
                                                  widget.user.profileHandle!
                                                      .endsWith("xen")
                                              ? ''
                                              : " ${widget.user.performances}\n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 14 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: widget.user.profileHandle!
                                              .startsWith('Ar')
                                          ? 'Music Awards:'
                                          : widget.user.profileHandle!
                                                  .startsWith('Co')
                                              ? 'Design Awards'
                                              : widget.user.profileHandle!
                                                      .startsWith('Ph')
                                                  ? 'Awards'
                                                  : widget.user.profileHandle!
                                                          .startsWith('Da')
                                                      ? 'Dance Awards'
                                                      : widget.user
                                                              .profileHandle!
                                                              .startsWith('Re')
                                                          ? 'Awards'
                                                          : widget.user
                                                                  .profileHandle!
                                                                  .endsWith(
                                                                      'xen')
                                                              ? 'Awards: '
                                                              : widget.user
                                                                      .profileHandle!
                                                                      .startsWith(
                                                                          'Mu')
                                                                  ? 'Video Awards:'
                                                                  : widget.user
                                                                          .profileHandle!
                                                                          .startsWith(
                                                                              'Bl')
                                                                      ? 'Blogging Awards:'
                                                                      : widget.user.profileHandle!.startsWith('Ba')
                                                                          ? 'Battle Awards:'
                                                                          : widget.user.profileHandle!.startsWith('Br')
                                                                              ? 'Awards: '
                                                                              : widget.user.profileHandle!.endsWith('J')
                                                                                  ? 'Dj Awards:'
                                                                                  : widget.user.profileHandle!.startsWith('Pr')
                                                                                      ? 'Beat Production Awards:'
                                                                                      : '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text: " ${widget.user.awards}",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 14 : 12,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                ],
                              ),
                              maxLines: 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProfessionalProfile(
                                          exploreLocation:
                                              widget.exploreLocation,
                                          currentUserId:
                                              Provider.of<UserData>(context)
                                                  .currentUserId!,
                                          user: widget.user,
                                          userId: widget.user.id!,
                                        )))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
            left: 10,
            right: 10,
          ),
          child: widget.user.profileHandle!.startsWith('Fan')
              ? _userFans()
              : _userOthers(),
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}
