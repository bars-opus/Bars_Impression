import 'dart:ui';

import 'package:bars/utilities/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePostView extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final AccountHolder author;

  ProfilePostView(
      {required this.currentUserId, required this.post, required this.author});

  @override
  _ProfilePostViewState createState() => _ProfilePostViewState();
}

class _ProfilePostViewState extends State<ProfilePostView> {
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
  bool _isLiked = false;
  bool _isDisLiked = false;
  bool _heartAnim = false;
  bool _thumbsDown = false;
  bool _displayImage = false;
  bool _imageAnim = false;
  int _dbLikeCount = 0;
  int _commentCount = 0;

  @override
  void initState() {
    super.initState();
    _dbLikeCount = widget.post.likeCount;
    _initPostLiked();
    _dbDisLikeCount = widget.post.disLikeCount;
    _initPostDisLiked();
    _setUpLikes();
    _setUpDisLikes();
    _setUpComments();
  }

  @override
  void didUpdateWidget(ProfilePostView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.likeCount != widget.post.likeCount) {
      _dbLikeCount = widget.post.likeCount;
    }
    if (oldWidget.post.disLikeCount != widget.post.disLikeCount) {
      _dbDisLikeCount = widget.post.disLikeCount;
    }
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

  _setUpComments() async {
    DatabaseService.numComments(widget.post.id).listen((commentCount) {
      if (mounted) {
        setState(() {
          _commentCount = commentCount;
        });
      }
    });
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
        _heartAnim = true;
        _isLiked = true;
        _dbLikeCount = _dbLikeCount + 1;
      });
    }

    Timer(Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _heartAnim = false;
        });
      }
    });
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
        _thumbsDown = true;
        _isDisLiked = true;
        _dbDisLikeCount = _dbDisLikeCount + 1;
      });
    }

    Timer(Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _thumbsDown = false;
        });
      }
    });
  }

  _setImage() {
    if (_displayImage) {
      setState(() {
        _imageAnim = true;
        _displayImage = false;
      });
      Timer(Duration(milliseconds: 350), () {
        setState(() {
          _imageAnim = false;
        });
      });
    } else {
      setState(() {
        _displayImage = true;
        _imageAnim = true;
        _imageAnim = true;
      });
      Timer(Duration(milliseconds: 350), () {
        setState(() {
          _imageAnim = false;
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

  _buildProfilePostView() {
    final width =
        Responsive.isDesktop(context) ? 700 : MediaQuery.of(context).size.width;
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: null,
            backgroundColor: Colors.cyan[800]!,
            foregroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            icon: widget.currentUserId == widget.author.id! ? Icons.edit : null,
            label: widget.currentUserId == widget.author.id!
                ? 'Edit your vibe'
                : '',
          ),
        ],
      ),
      child: Stack(alignment: FractionalOffset.bottomCenter, children: <Widget>[
        _displayImage == false
            ? Stack(alignment: Alignment.center, children: <Widget>[
                Container(
                  height: width.toDouble() > 500
                      ? width.toDouble() / 1.2
                      : width.toDouble(),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 0.0,
                        spreadRadius: 3.0,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onLongPress: () => _setImage(),
                      onDoubleTap: () => _setImage(),
                      child: Container(
                        height: width.toDouble() > 500
                            ? width.toDouble() / 1.2
                            : width.toDouble(),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(widget.post.imageUrl),
                          fit: BoxFit.cover,
                        )),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                Colors.black.withOpacity(.7),
                                Colors.black.withOpacity(.7),
                              ])),
                        ),
                      ),
                    ),
                  ),
                ),
                _heartAnim
                    ? Animator(
                        duration: Duration(milliseconds: 300),
                        tween: Tween(begin: 0.5, end: 1.4),
                        curve: Curves.elasticOut,
                        builder: (context, anim, child) => Transform.scale(
                          scale: anim.value as double,
                          child: Icon(
                            Icons.favorite,
                            size: 100.0,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      )
                    : _thumbsDown
                        ? Animator(
                            duration: Duration(milliseconds: 300),
                            tween: Tween(begin: 0.5, end: 1.4),
                            curve: Curves.elasticOut,
                            builder: (context, anim, child) => Transform.scale(
                              scale: anim.value as double,
                              child: Icon(
                                Icons.thumb_down,
                                size: 100.0,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : _imageAnim
                            ? Animator(
                                duration: Duration(milliseconds: 300),
                                tween: Tween(begin: 0.5, end: 1.4),
                                curve: Curves.elasticOut,
                                builder: (context, anim, child) =>
                                    Transform.scale(
                                  scale: anim.value as double,
                                  child: Container(
                                    height: width.toDouble() > 500
                                        ? width.toDouble() / 12
                                        : width.toDouble(),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          widget.post.imageUrl),
                                      fit: BoxFit.cover,
                                    )),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
              ])
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onLongPress: () => _setImage(),
                  onDoubleTap: () => _setImage(),
                  child: Container(
                    height:
                        width.toDouble() > 500 ? width / 1.2 : width.toDouble(),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.post.imageUrl),
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),
        _imageAnim
            ? Animator(
                duration: Duration(milliseconds: 300),
                tween: Tween(begin: 0.5, end: 1.4),
                curve: Curves.elasticOut,
                builder: (context, anim, child) => Transform.scale(
                  scale: anim.value as double,
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.post.imageUrl),
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        _displayImage == false
            ? Padding(
                padding: EdgeInsets.only(bottom: 40.0, left: 10.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: width > 600 ? 500 : 300,
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.bottomCenter,
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
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  ' " ${widget.post.punch} "'.toLowerCase(),
                                  style: TextStyle(
                                    fontSize: width > 500 && width < 800
                                        ? 20
                                        : width > 800
                                            ? 30
                                            : 14,
                                    color: Colors.white,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 3),
                                        blurRadius: 2.0,
                                        spreadRadius: 1.0,
                                      )
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllArtistPosts(
                            currentUserId: widget.currentUserId,
                            artist: widget.post.artist,
                            artistPunch: null,
                            post: null,
                          ),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: buildBlur(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white.withOpacity(0.2)),
                            height: width > 600 ? 40 : 30.0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 7.0),
                            child: Text(
                              '${widget.post.artist} ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width > 500 && width < 800
                                    ? 16
                                    : width > 800
                                        ? 20
                                        : 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black54,
                                      offset: Offset(0, 3),
                                      blurRadius: 2.0,
                                      spreadRadius: 1.0,
                                    )
                                  ]),
                              height: 3.0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 3.0),
                              child: Text(
                                '${widget.post.artist} ',
                                style: TextStyle(
                                  fontSize: width > 500 && width < 800
                                      ? 16
                                      : width > 800
                                          ? 20
                                          : 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container()
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        FocusedMenuHolder(
          menuWidth: width,
          menuOffset: 10,
          blurBackgroundColor:
              ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white10,
          openWithTap: false,
          onPressed: () {},
          menuItems: [
            widget.post.authorId == widget.currentUserId
                ? FocusedMenuItem(
                    title: Text('Edit punch'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditPost(
                          post: widget.post,
                          currentUserId: widget.currentUserId,
                        ),
                      ),
                    ),
                  )
                : FocusedMenuItem(
                    title: Text("Go to ${widget.author.userName}'s profile"),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  currentUserId: widget.currentUserId,
                                  userId: widget.post.authorId,
                                ))),
                  ),
            FocusedMenuItem(
              title: Text("Vibe with this punch"),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CommentsScreen(
                            post: widget.post,
                            likeCount: _dbLikeCount,
                            dislikeCount: _dbDisLikeCount,
                            comment: null,
                            currentUserId: widget.currentUserId,
                          ))),
            ),
            FocusedMenuItem(
              title: Text("Change state of mood punch"),
              onPressed: () => _setImage(),
            ),
            FocusedMenuItem(
              title: Text("See Punches with ${widget.post.artist}'s name"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllArtistPosts(
                    currentUserId: widget.currentUserId,
                    artist: widget.post.artist,
                    artistPunch: null,
                    post: null,
                  ),
                ),
              ),
            ),
            FocusedMenuItem(
              title: Text("See Punches with this punchline"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllPunclinePost(
                    currentUserId: widget.currentUserId,
                    punch: widget.post.punch,
                  ),
                ),
              ),
            ),
            FocusedMenuItem(
              title: Text(
                  widget.post.musicLink.isNotEmpty
                      ? 'Get link to song'
                      : ' Song link not added',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              onPressed: () => widget.post.musicLink.isNotEmpty
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MyWebView(
                                    url: widget.post.musicLink,
                                  )));
                    }
                  : () {},
            ),
            FocusedMenuItem(
              title: Text("See punches ${widget.author.userName}'s name"),
              onPressed: () => _setImage(),
            ),
            FocusedMenuItem(
              title: Text("Read Punch Tips",
                  style: TextStyle(
                    fontSize: 16,
                  )),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            currentUserId: widget.currentUserId,
                            userId: widget.post.authorId,
                          ))),
            ),
            FocusedMenuItem(
                backgroundColor: Colors.red,
                trailingIcon: Icon(Icons.close, color: Colors.white),
                title: Text("close",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )),
                onPressed: () => () {}),
          ],
          child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                          currentUserId: widget.currentUserId,
                          userId: widget.post.authorId,
                        ))),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          child: Row(children: <Widget>[
                        CircleAvatar(
                          radius: 25.0,
                          backgroundColor: ConfigBloc().darkModeOn
                              ? Color(0xFF1a1a1a)
                              : Color(0xFFf2f2f2),
                          backgroundImage:
                              widget.author.profileImageUrl!.isEmpty
                                  ? AssetImage(
                                      ConfigBloc().darkModeOn
                                          ? 'assets/images/user_placeholder.png'
                                          : 'assets/images/user_placeholder2.png',
                                    ) as ImageProvider
                                  : CachedNetworkImageProvider(
                                      widget.author.profileImageUrl!),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: RichText(
                                  text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "${widget.author.userName}\n",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ConfigBloc().darkModeOn
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: "${widget.author.profileHandle!}\n",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: "${widget.author.company}",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                ],
                              )),
                            ),
                          ],
                        ),
                      ])),
                    ],
                  ),
                  Positioned(
                    top: 1,
                    right: 3,
                    child: IconButton(
                      icon: Icon(Icons.share),
                      iconSize: 25.0,
                      color:
                          ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                      onPressed: () => Share.share('widget.post.musicLink'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 75.0, bottom: 10, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 3,
                width: 100,
                decoration: BoxDecoration(
                  color: _randomColor.randomColor(
                    colorHue: ColorHue.multiple(colorHues: _hueType),
                    colorSaturation: _colorSaturation,
                  ),
                ),
              ),
              Text(
                  timeago.format(
                    widget.post.timestamp!.toDate(),
                  ),
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
        _buildProfilePostView(),
        SizedBox(
          height: 10,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Stack(alignment: Alignment.center, children: <Widget>[
                        CircularButton(
                            color: _isLiked
                                ? Colors.pink
                                : ConfigBloc().darkModeOn
                                    ? Color(0xFF1a1a1a)
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
                      ]),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                NumberFormat.compact().format(_dbLikeCount),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              ' Dope',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Stack(children: <Widget>[
                        CircularButton(
                            color: _isDisLiked
                                ? ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black
                                : ConfigBloc().darkModeOn
                                    ? Color(0xFF1a1a1a)
                                    : Colors.white,
                            icon: _isDisLiked
                                ? Icon(
                                    Icons.thumb_down,
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.black
                                        : Colors.white,
                                  )
                                : Icon(
                                    MdiIcons.thumbDownOutline,
                                    color: Colors.grey,
                                  ),
                            onPressed: () {
                              HapticFeedback.vibrate();
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
                      ]),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                NumberFormat.compact().format(_dbDisLikeCount),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              '???',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CommentsScreen(
                                    post: widget.post,
                                    likeCount: _dbLikeCount,
                                    dislikeCount: _dbDisLikeCount,
                                    comment: null,
                                    currentUserId: widget.currentUserId,
                                  ))),
                      child: Container(
                        height: 25.0,
                        decoration: BoxDecoration(
                          color: Colors.cyan[800],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5.0),
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              'Vibe with punch',
                              style: TextStyle(
                                fontSize: width > 800 ? 14 : 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: NumberFormat.compact().format(_commentCount),
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      TextSpan(
                        text: ' Vibes',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ])),
                  ],
                ),
              ),
            ]),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.post.caption.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          '${widget.post.caption}',
                          style: TextStyle(
                            fontSize: width > 500 && width < 800
                                ? 16
                                : width > 800
                                    ? 30
                                    : 12,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.post.caption,
                  style: TextStyle(
                    fontSize: 12.0,
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ConfigBloc().darkModeOn
                  ? Divider(color: Colors.white)
                  : Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
