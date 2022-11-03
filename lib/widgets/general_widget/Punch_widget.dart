import 'dart:ui';
import 'package:bars/general/pages/chats/send_to_chat.dart';
import 'package:bars/utilities/exports.dart';
import 'package:bars/utilities/profaine_text%20copy.dart';
import 'package:intl/intl.dart';

class PunchWidget extends StatefulWidget {
  final String currentUserId;
  final Post post;
  PunchWidget({
    required this.currentUserId,
    required this.post,
  });

  @override
  _PunchWidgetState createState() => _PunchWidgetState();
}

class _PunchWidgetState extends State<PunchWidget> {
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

  int _dbDisLikeCount = 0;
  int _dbLikeCount = 0;
  bool _isLiked = false;
  bool _isDisLiked = false;
  bool _showInfo = false;
  bool _showPunchlineInfo = false;
  bool _heartAnim = false;
  bool _thumbAnim = false;
  int _commentCount = 0;
  bool _isBlockedUser = false;

  @override
  void initState() {
    super.initState();
    _dbLikeCount = widget.post.likeCount;
    _initPostLiked();
    _dbDisLikeCount = widget.post.disLikeCount;
    _initPostDisLiked();
    _setUpComments();
    _setUpLikes();
    _setUpDisLikes();
    _setupIsBlockedUser();
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.post.authorId,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
  }

  @override
  void didUpdateWidget(PunchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.likeCount != widget.post.likeCount) {
      _dbLikeCount = widget.post.likeCount;
    }
    if (oldWidget.post.disLikeCount != widget.post.disLikeCount) {
      _dbDisLikeCount = widget.post.disLikeCount;
    }
  }

  _setShowInfo() {
    setState(() {
      _showInfo = true;
    });
    Timer(Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _showInfo = false;
        });
      }
    });
  }

  _setShowPunchlineInfo() {
    setState(() {
      _showPunchlineInfo = true;
    });
    Timer(Duration(seconds: 12), () {
      if (mounted) {
        setState(() {
          _showPunchlineInfo = false;
        });
      }
    });
  }

  _setUpComments() async {
    DatabaseService.numComments(widget.post.id).listen((commentCount) {
      if (mounted) {
        setState(() {
          _commentCount = commentCount;
        });
      }
    });
  }

  _setUpLikes() async {
    int likeCount = await DatabaseService.numLikes(widget.post.id);
    if (mounted) {
      setState(() {
        _dbLikeCount = likeCount;
      });
    }
  }

  _setUpDisLikes() async {
    int disLikeCount = await DatabaseService.numDisLikes(widget.post.id);
    if (mounted) {
      setState(() {
        _dbDisLikeCount = disLikeCount;
      });
    }
  }

  _initPostLiked() async {
    bool isLiked = await DatabaseService.didLikePost(
      currentUserId: widget.currentUserId,
      post: widget.post,
    );
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
        _isDisLiked = _isDisLiked;
      });
    }
  }

  _initPostDisLiked() async {
    bool isDisLiked = await DatabaseService.didDisLikePost(
      currentUserId: widget.currentUserId,
      post: widget.post,
    );
    if (mounted) {
      setState(() {
        _isDisLiked = isDisLiked;
      });
    }
  }

  _unLikePost() {
    DatabaseService.unlikePost(
        currentUserId: widget.currentUserId, post: widget.post);
    if (mounted) {
      setState(() {
        _isLiked = false;
        _dbLikeCount = _dbLikeCount - 1;
      });
    }
  }

  _likePost() {
    DatabaseService.likePost(
        user: Provider.of<UserData>(context, listen: false).user!,
        post: widget.post);
    if (mounted) {
      setState(() {
        _isLiked = true;
        _dbLikeCount = _dbLikeCount + 1;
        _heartAnim = true;
      });

      Timer(Duration(milliseconds: 350), () {
        setState(() {
          _heartAnim = false;
        });
      });
    }
  }

  _unDisLikePost() {
    DatabaseService.unDisLikePost(
        currentUserId: widget.currentUserId, post: widget.post);
    if (mounted) {
      setState(() {
        _isDisLiked = false;
        _dbDisLikeCount = _dbDisLikeCount - 1;
      });
    }
  }

  _disLikePost() {
    DatabaseService.disLikePost(
        currentUserId: widget.currentUserId, post: widget.post);
    if (mounted) {
      setState(() {
        _isDisLiked = true;
        _dbDisLikeCount = _dbDisLikeCount + 1;
        _thumbAnim = true;
      });
      Timer(Duration(milliseconds: 350), () {
        setState(() {
          _thumbAnim = false;
        });
      });
    }
  }

  Widget buildBlur({
    required Widget child,
    double sigmaX = 20,
    double sigmaY = 20,
    BorderRadius? borderRadius,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );

  _dynamicLink() async {
    var linkUrl = Uri.parse(widget.post.imageUrl);

    final dynamicLinkParams = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: linkUrl,
        title: 'MoodPunched',
        description: widget.post.punch,
      ),
      link: Uri.parse('https://www.barsopus.com/moopunched_${widget.post.id}'),
      uriPrefix: 'https://barsopus.com/barsImpression',
      androidParameters:
          AndroidParameters(packageName: 'com.barsOpus.barsImpression'),
      iosParameters: IOSParameters(
        bundleId: 'com.bars-Opus.barsImpression',
        appStoreId: '1610868894',
      ),
    );

    if (Platform.isIOS) {
      var link =
          await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
      Share.share(link.toString());
    } else {
      var link =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      Share.share(link.shortUrl.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    int _point = _dbLikeCount - _dbDisLikeCount;
    final width = Responsive.isDesktop(context)
        ? 700.0
        : MediaQuery.of(context).size.width;

    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          title: Text(
            'Punchline',
            style: TextStyle(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 800),
                    height: _showPunchlineInfo ? 100 : 0.0,
                    width: double.infinity,
                    color: Colors.blue,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => FeatureInfo(
                                    feature: 'Punch Mood',
                                  ))),
                      child: Center(
                        child: ShakeTransition(
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 1000),
                          child: ListTile(
                            title: Text(
                                'Punchline score is the subtraction of the negative reaction(???) from the positive reaction(Dope) of a punchline. It indicates how people are relating to a punchline.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                            subtitle: Text('\nTap and read more',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                            leading: IconButton(
                              icon: Icon(Icons.info_outline_rounded),
                              iconSize: 20.0,
                              color: _showPunchlineInfo
                                  ? Colors.white
                                  : Colors.transparent,
                              onPressed: () => () {},
                            ),
                          ),
                        ),
                      ),
                    )),
                AnimatedContainer(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 800),
                    height: _showInfo ? 70 : 0.0,
                    width: double.infinity,
                    color: Colors.blue,
                    child: Center(
                      child: ShakeTransition(
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 1000),
                        child: ListTile(
                          title: Text(
                              'We do not display the name of people who have reacted to a punchline to maintain the integrity of their reactions.',
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
                      ),
                    )),
                Center(
                  child: GestureDetector(
                    onTap: _setShowPunchlineInfo,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'punch\nscore',
                            style: TextStyle(
                                fontSize: 12,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                height: 1),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Text(
                          '/',
                          style: TextStyle(
                            fontSize: 38,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          _point.toString(),
                          style: TextStyle(
                            fontSize: 38,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                FocusedMenuHolder(
                  menuWidth: width,
                  menuOffset: 10,
                  blurBackgroundColor: Colors.transparent,
                  openWithTap: false,
                  onPressed: () {},
                  menuItems: [
                    FocusedMenuItem(
                        title: Container(
                          width: width - 40,
                          child: Center(
                            child: Text(
                              'Send ',
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SendToChats(
                                        currentUserId: widget.currentUserId,
                                        userId: '',
                                        sendContentType: 'Mood Punched',
                                        event: null,
                                        post: widget.post,
                                        forum: null,
                                        user: null,
                                        sendContentId: widget.post.id!,
                                      )));
                        }),
                    FocusedMenuItem(
                        title: Container(
                          width: width - 40,
                          child: Center(
                            child: Text(
                              'Share ',
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                            ),
                          ),
                        ),
                        onPressed: () => _dynamicLink()),
                    FocusedMenuItem(
                        title: Container(
                          width: width - 40,
                          child: Center(
                            child: Text(
                              widget.post.authorId == widget.currentUserId
                                  ? 'Edit mood punched'
                                  : 'View profile ',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        onPressed: () =>
                            widget.post.authorId == widget.currentUserId
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditPost(
                                        post: widget.post,
                                        currentUserId: widget.currentUserId,
                                      ),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProfileScreen(
                                              currentUserId:
                                                  Provider.of<UserData>(context)
                                                      .currentUserId!,
                                              userId: widget.post.authorId,
                                              user: null,
                                            )))),
                    FocusedMenuItem(
                        title: Container(
                          width: width - 40,
                          child: Center(
                            child: Text(
                              'Report',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ReportContentPage(
                                      parentContentId: widget.post.id,
                                      repotedAuthorId: widget.post.authorId,
                                      contentType: 'post',
                                      contentId: widget.post.id!,
                                    )))),
                    FocusedMenuItem(
                        title: Container(
                          width: width - 40,
                          child: Center(
                            child: Text(
                              'Suggestion Box',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SuggestionBox()))),
                  ],
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AllPunclinePost(
                          currentUserId: widget.currentUserId,
                          punch: widget.post.punch,
                        ),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Hero(
                            tag: 'punch' + widget.post.id.toString(),
                            child: Material(
                              color: Colors.transparent,
                              child: ProfainTextCheck(
                                color: Colors.blue,
                                fontSize: 20,
                                from: '',
                                text: widget.post.punch.toLowerCase(),
                              ),
                            ),
                          ),
                          _thumbAnim
                              ? Animator(
                                  duration: Duration(milliseconds: 300),
                                  tween: Tween(begin: 0.5, end: 1.4),
                                  curve: Curves.elasticOut,
                                  builder: (context, anim2, child) =>
                                      Transform.scale(
                                        scale: anim2.value as double,
                                        child: const Icon(
                                          Icons.thumb_down,
                                          size: 150.0,
                                          color: Colors.grey,
                                        ),
                                      ))
                              : const SizedBox.shrink(),
                          _heartAnim
                              ? Animator(
                                  duration: Duration(milliseconds: 300),
                                  tween: Tween(begin: 0.5, end: 1.4),
                                  curve: Curves.elasticOut,
                                  builder: (context, anim2, child) =>
                                      Transform.scale(
                                        scale: anim2.value as double,
                                        child: const Icon(
                                          Icons.favorite,
                                          size: 150.0,
                                          color: Colors.pink,
                                        ),
                                      ))
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _randomColor.randomColor(
                        colorHue: ColorHue.multiple(colorHues: _hueType),
                        colorSaturation: _colorSaturation,
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    height: 1.0,
                    width: 50.0,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllArtistPosts(
                        currentUserId: widget.currentUserId,
                        post: widget.post,
                        artistPunch: null,
                        artist: widget.post.artist,
                      ),
                    ),
                  ),
                  child: Hero(
                    tag: 'artist' + widget.post.id.toString(),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        '${widget.post.artist} ',
                        style: TextStyle(
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _isBlockedUser
                          ? const SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          CircularButton(
                                              color: _isLiked
                                                  ? Colors.pink
                                                  : ConfigBloc().darkModeOn
                                                      ? Color(0xFF1f2022)
                                                      : Colors.white,
                                              icon: _isLiked
                                                  ? Icon(
                                                      Icons.favorite,
                                                      color: Colors.white,
                                                    )
                                                  : Icon(
                                                      Icons.favorite_border,
                                                      color: Colors.grey,
                                                    ),
                                              onPressed: () {
                                                HapticFeedback.heavyImpact();
                                                SystemSound.play(
                                                    SystemSoundType.click);
                                                if (_isLiked) {
                                                  setState(() {
                                                    _unLikePost();
                                                  });
                                                } else {
                                                  _likePost();
                                                }

                                                if (_isDisLiked) {
                                                  setState(() {
                                                    _unDisLikePost();
                                                  });
                                                }
                                              }),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          GestureDetector(
                                            onTap: _setShowInfo,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      _dbLikeCount.toString(),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' Dope',
                                                    style: TextStyle(
                                                      fontSize: width > 800
                                                          ? 16
                                                          : 12.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          CircularButton(
                                              color: _isDisLiked
                                                  ? ConfigBloc().darkModeOn
                                                      ? Colors.white
                                                      : Colors.black
                                                  : ConfigBloc().darkModeOn
                                                      ? Color(0xFF1f2022)
                                                      : Colors.white,
                                              icon: _isDisLiked
                                                  ? Icon(
                                                      Icons.thumb_down,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.black
                                                          : Colors.white,
                                                    )
                                                  : Icon(
                                                      MdiIcons.thumbDownOutline,
                                                      color: Colors.grey,
                                                    ),
                                              onPressed: () {
                                                HapticFeedback.heavyImpact();
                                                SystemSound.play(
                                                    SystemSoundType.click);
                                                if (_isDisLiked) {
                                                  setState(() {
                                                    _unDisLikePost();
                                                  });
                                                } else {
                                                  setState(() {
                                                    _disLikePost();
                                                  });
                                                }

                                                if (_isLiked) {
                                                  setState(() {
                                                    _unLikePost();
                                                  });
                                                }
                                              }),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          GestureDetector(
                                            onTap: _setShowInfo,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      _dbDisLikeCount
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '???',
                                                    style: TextStyle(
                                                      fontSize: width > 800
                                                          ? 16
                                                          : 12.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.cyan[800],
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CommentsScreen(
                                                          commentCount:
                                                              _commentCount,
                                                          post: widget.post,
                                                          likeCount:
                                                              _dbLikeCount,
                                                          dislikeCount:
                                                              _dbDisLikeCount,
                                                          currentUserId: widget
                                                              .currentUserId,
                                                        ))),
                                            icon: Icon(Icons.comment_outlined,
                                                color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                            text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: NumberFormat.compact()
                                                  .format(_commentCount),
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey),
                                            ),
                                            TextSpan(
                                              text: ' Vibes',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ]),
                      widget.post.hashTag.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AllHashTagPost(
                                      currentUserId: widget.currentUserId,
                                      hashTag: widget.post.hashTag,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '#',
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${widget.post.hashTag} ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: HyperLinkText(
                    from: 'Caption',
                    text: '${widget.post.caption}'.toLowerCase(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
