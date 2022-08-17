import 'dart:ui';
import 'package:bars/utilities/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timeago/timeago.dart' as timeago;

class PunchExpandedWidget extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final AccountHolder author;
  final String feed;

  PunchExpandedWidget(
      {required this.currentUserId,
      required this.post,
      required this.feed,
      required this.author});

  @override
  _PunchExpandedWidgetState createState() => _PunchExpandedWidgetState();
}

class _PunchExpandedWidgetState extends State<PunchExpandedWidget> {
  bool _displayImage = false;
  bool _imageAnim = false;
  bool _displayWarning = false;
  bool _warningAnim = false;
  double page = 0.0;

  @override
  void initState() {
    super.initState();
    _displayWarning = widget.post.report.isNotEmpty ? true : false;
  }

  _setImage() {
    if (_displayImage) {
      if (mounted) {
        setState(() {
          _imageAnim = true;
          _displayImage = false;
        });
      }

      Timer(Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {
            _imageAnim = false;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          _displayImage = true;
          _imageAnim = true;
          _imageAnim = true;
        });
      }

      Timer(Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {
            _imageAnim = false;
          });
        }
      });
    }
  }

  _setContentWarning() {
    if (mounted) {
      setState(() {
        _warningAnim = true;
        _displayWarning = false;
      });
    }

    Timer(Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _warningAnim = false;
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = Responsive.isDesktop(context)
        ? 700.0
        : MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        centerTitle: true,
        actions: [],
      ),
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFeff0f2),
      body: Center(
        child: _displayWarning == true
            ? Hero(
                tag: 'postImage' + widget.post.id.toString(),
                child: ContentWarning(
                  report: widget.post.report,
                  onPressed: _setContentWarning,
                  imageUrl: widget.post.imageUrl,
                ),
              )
            : Stack(
                alignment: FractionalOffset.bottomCenter,
                children: <Widget>[
                    GestureDetector(
                      onLongPress: () => Navigator.of(context).push(
                          PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder: (context, animation, _) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ExplorePosts(
                                    feed: widget.feed,

                                    currentUserId: widget.currentUserId,
                                    // postList:
                                    //    [],
                                    post: widget.post,
                                  ),
                                );
                              })),
                      child: Stack(children: <Widget>[
                        Hero(
                          tag: 'postImage' + widget.post.id.toString(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: ClipRRect(
                                child: GestureDetector(
                                  onDoubleTap: _setImage,
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: ConfigBloc().darkModeOn
                                          ? Color(0xFF1a1a1a)
                                          : Color(0xFFeff0f2),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            widget.post.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: _displayImage == false
                                        ? GestureDetector(
                                            onDoubleTap: _setImage,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.black
                                                        .withOpacity(.6),
                                                    Colors.black
                                                        .withOpacity(.6),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _imageAnim
                            ? Animator(
                                duration: Duration(milliseconds: 300),
                                tween: Tween(begin: 0.5, end: 1.4),
                                curve: Curves.elasticOut,
                                builder: (context, anim, child) =>
                                    Transform.scale(
                                  scale: anim.value as double,
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          widget.post.imageUrl),
                                      fit: BoxFit.cover,
                                    )),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        _displayImage == false
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, left: 10.0, right: 10.0),
                                child: GestureDetector(
                                  onDoubleTap: _setImage,
                                  child: Container(
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                ShakeTransition(
                                                  child: Slidable(
                                                    startActionPane: ActionPane(
                                                      motion:
                                                          const DrawerMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          onPressed: (_) {
                                                            // widget.currentUserId ==
                                                            //         widget
                                                            //             .author
                                                            //             .id
                                                            //     ?
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) =>
                                                                    EditPost(
                                                                  post: widget
                                                                      .post,
                                                                  currentUserId:
                                                                      widget
                                                                          .currentUserId,
                                                                ),
                                                              ),
                                                            );
                                                          
                                                          },
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          foregroundColor:
                                                              Colors.white,
                                                          icon: widget.currentUserId ==
                                                                  widget.author
                                                                      .id!
                                                              ? Icons.edit
                                                              : widget.author
                                                                      .profileHandle!
                                                                      .startsWith(
                                                                          'Fan')
                                                                  ? null
                                                                  : Icons.work,
                                                          label: widget
                                                                      .currentUserId ==
                                                                  widget.author
                                                                      .id!
                                                              ? 'Edit mood'
                                                              : widget.author
                                                                      .profileHandle!
                                                                      .startsWith(
                                                                          'Fan')
                                                                  ? ' '
                                                                  : 'Booking page ',
                                                        ),
                                                      ],
                                                    ),
                                                    child: FocusedMenuHolder(
                                                      menuWidth: width,
                                                      menuOffset: 10,
                                                      blurBackgroundColor:
                                                          Colors.transparent,
                                                      openWithTap: false,
                                                      onPressed: () {},
                                                      menuItems: [
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              width: width / 2,
                                                              child: Text(
                                                                widget.post.authorId ==
                                                                        widget
                                                                            .currentUserId
                                                                    ? 'Edit mood punched'
                                                                    : 'Go to ${widget.author.name}\' profile ',
                                                                textScaleFactor:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .textScaleFactor
                                                                        .clamp(
                                                                            0.5,
                                                                            1.5),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            onPressed: () => widget
                                                                        .post
                                                                        .authorId ==
                                                                    widget
                                                                        .currentUserId
                                                                ? Navigator
                                                                    .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (_) =>
                                                                              EditPost(
                                                                        post: widget
                                                                            .post,
                                                                        currentUserId:
                                                                            widget.currentUserId,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (_) => ProfileScreen(
                                                                              currentUserId: Provider.of<UserData>(context).currentUserId!,
                                                                              userId: widget.author.id!,
                                                                            )))),
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              width: width / 2,
                                                              child: Text(
                                                                'Go to punchline ',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textScaleFactor:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .textScaleFactor
                                                                        .clamp(
                                                                            0.5,
                                                                            1.5),
                                                              ),
                                                            ),
                                                            onPressed: () => Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) => PunchWidget(
                                                                        currentUserId:
                                                                            widget
                                                                                .currentUserId,
                                                                        post: widget
                                                                            .post,
                                                                        author:
                                                                            widget.author)))),
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              width: width / 2,
                                                              child: Text(
                                                                'Change mood punch state ',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textScaleFactor:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .textScaleFactor
                                                                        .clamp(
                                                                            0.5,
                                                                            1.5),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                _setImage),
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              width: width / 2,
                                                              child: Text(
                                                                'Report',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textScaleFactor:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .textScaleFactor
                                                                        .clamp(
                                                                            0.5,
                                                                            1.5),
                                                              ),
                                                            ),
                                                            onPressed: () =>
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (_) =>
                                                                            ReportContentPage(
                                                                              parentContentId: widget.post.id,
                                                                              repotedAuthorId: widget.post.authorId,
                                                                              contentType: 'Mood punched',
                                                                              contentId: widget.post.id!,
                                                                            )))),
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              width: width / 2,
                                                              child: Text(
                                                                'Suggestion Box',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textScaleFactor:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .textScaleFactor
                                                                        .clamp(
                                                                            0.5,
                                                                            1.5),
                                                              ),
                                                            ),
                                                            onPressed: () =>
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (_) =>
                                                                                SuggestionBox()))),
                                                      ],
                                                      child: MediaQuery(
                                                        data: MediaQuery.of(
                                                                context)
                                                            .copyWith(
                                                                textScaleFactor:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .textScaleFactor
                                                                        .clamp(
                                                                            0.5,
                                                                            1.5)),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: buildBlur(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Color(0xFF1f2022)
                                                                          .withOpacity(
                                                                              0.6)
                                                                      : Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.2),
                                                                ),
                                                                height: Responsive
                                                                        .isDesktop(
                                                                            context)
                                                                    ? 400
                                                                    : 300,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          30.0),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 16.0,
                                                                              vertical: 0.0),
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap: () => Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (_) => ProfileScreen(
                                                                                              currentUserId: widget.currentUserId,
                                                                                              userId: widget.post.authorId,
                                                                                            ))),
                                                                                child: Container(
                                                                                  width: width,
                                                                                  height: 55,
                                                                                  child: ListView(
                                                                                    physics: NeverScrollableScrollPhysics(),
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    children: <Widget>[
                                                                                      Material(
                                                                                        color: Colors.transparent,
                                                                                        child: Container(
                                                                                            child: Row(children: <Widget>[
                                                                                          Hero(
                                                                                            tag: 'author' + widget.post.id.toString(),
                                                                                            child: CircleAvatar(
                                                                                              radius: 25.0,
                                                                                              backgroundColor: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
                                                                                              backgroundImage: widget.author.profileImageUrl!.isEmpty
                                                                                                  ? AssetImage(
                                                                                                      ConfigBloc().darkModeOn ? 'assets/images/user_placeholder.png' : 'assets/images/user_placeholder2.png',
                                                                                                    ) as ImageProvider
                                                                                                  : CachedNetworkImageProvider(widget.author.profileImageUrl!),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: <Widget>[
                                                                                              Stack(
                                                                                                alignment: Alignment.bottomRight,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(right: 12.0),
                                                                                                    child: Text("${widget.author.userName}", style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                                                                                                  ),
                                                                                                  widget.author.verified!.isEmpty
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
                                                                                              RichText(
                                                                                                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                                                                                  text: TextSpan(
                                                                                                    children: [
                                                                                                      TextSpan(text: "${widget.author.profileHandle!}\n", style: TextStyle(fontSize: 10, color: Colors.white)),
                                                                                                      TextSpan(text: "${widget.author.company}", style: TextStyle(fontSize: 10, color: Colors.white)),
                                                                                                    ],
                                                                                                  )),
                                                                                            ],
                                                                                          ),
                                                                                        ])),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        GestureDetector(
                                                                          onTap: () => Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (_) => PunchWidget(currentUserId: widget.currentUserId, post: widget.post, author: widget.author))),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                width,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(0.0),
                                                                              child: Hero(
                                                                                tag: 'punch' + widget.post.id.toString(),
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  child: SingleChildScrollView(
                                                                                    child: Text(
                                                                                      '" ${widget.post.punch} " '.toLowerCase(),
                                                                                      maxLines: 5,
                                                                                      style: TextStyle(
                                                                                        fontSize: 14,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Hero(
                                                                          tag: 'artist' +
                                                                              widget.post.id.toString(),
                                                                          child:
                                                                              Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            child:
                                                                                Text(
                                                                              '${widget.post.artist} ',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: width > 500 && width < 800
                                                                                    ? 16
                                                                                    : width > 800
                                                                                        ? 20
                                                                                        : 14,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                7.0),
                                                                        Hero(
                                                                          tag: 'artist2' +
                                                                              widget.post.id.toString(),
                                                                          child:
                                                                              Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                              ),
                                                                              height: 1.0,
                                                                              child: Text(
                                                                                '${widget.post.artist} ',
                                                                                style: TextStyle(
                                                                                  fontSize: width > 500 && width < 800
                                                                                      ? 16
                                                                                      : width > 800
                                                                                          ? 20
                                                                                          : 14,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        BarsTextFooter(
                                                                          text:
                                                                              timeago.format(
                                                                            widget.post.timestamp.toDate(),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        GestureDetector(
                                                                          onTap: () => Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (_) => PunchWidget(currentUserId: widget.currentUserId, post: widget.post, author: widget.author))),
                                                                          child:
                                                                              Stack(
                                                                            alignment:
                                                                                Alignment.bottomLeft,
                                                                            children: [
                                                                              Positioned(
                                                                                left: 0.0,
                                                                                top: 0.0,
                                                                                child: Container(
                                                                                  height: 10,
                                                                                  width: 10,
                                                                                  color: Colors.blue,
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 20.0),
                                                                                child: Hero(
                                                                                  tag: 'caption' + widget.post.id.toString(),
                                                                                  child: Material(
                                                                                    color: Colors.transparent,
                                                                                    child: SingleChildScrollView(
                                                                                      child: Text(
                                                                                        '${widget.post.caption} '.toLowerCase(),
                                                                                        style: TextStyle(
                                                                                          fontSize: 12,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 70,
                                                ),
                                                widget.post.musicLink.isEmpty
                                                    ? SizedBox.shrink()
                                                    : ShakeTransition(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    1200),
                                                        axis: Axis.vertical,
                                                        child: IconButton(
                                                          icon: Icon(
                                                            MdiIcons
                                                                .playCircleOutline,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) => WebDisclaimer(
                                                                    link: widget
                                                                        .post
                                                                        .musicLink,
                                                                    contentType:
                                                                        'Watch Music Video'),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        _warningAnim
                            ? Container(
                                height: height,
                                width: double.infinity,
                                color: Colors.black.withOpacity(.9),
                                child: Animator(
                                  duration: Duration(seconds: 1),
                                  tween: Tween(begin: 0.5, end: 1.4),
                                  builder: (context, anim, child) =>
                                      ShakeTransition(
                                    child: Icon(
                                      MdiIcons.eye,
                                      color: Colors.grey,
                                      size: 150.0,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ]),
                    ),
                  ]),
      ),
    );
  }
}
