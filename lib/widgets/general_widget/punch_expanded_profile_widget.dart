import 'dart:ui';
import 'package:bars/general/pages/chats/send_to_chat.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timeago/timeago.dart' as timeago;

class PunchExpandedProfileWidget extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final AccountHolder author;
  final String feed;

  PunchExpandedProfileWidget({
    required this.currentUserId,
    required this.post,
    required this.feed,
    required this.author,
  });

  @override
  _PunchExpandedProfileWidgetState createState() =>
      _PunchExpandedProfileWidgetState();
}

class _PunchExpandedProfileWidgetState
    extends State<PunchExpandedProfileWidget> {
  bool _displayImage = false;
  bool _imageAnim = false;
  bool _displayWarning = false;
  bool _warningAnim = false;
  double page = 0.0;
  bool _isLiked = false;
  bool _isDisLiked = false;
  bool _heartAnim = false;

  @override
  void initState() {
    super.initState();
    _displayWarning = widget.post.report.isNotEmpty ? true : false;
  }

  _setImage() {
    HapticFeedback.heavyImpact();

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

  _unLikePost() {
    HapticFeedback.heavyImpact();

    DatabaseService.unlikePost(
        currentUserId: widget.currentUserId, post: widget.post);
    if (mounted) {
      setState(() {
        _isLiked = false;
      });
    }
  }

  _likePost() {
    HapticFeedback.heavyImpact();

    DatabaseService.likePost(
        user: Provider.of<UserData>(context, listen: false).user!,
        post: widget.post);
    SystemSound.play(SystemSoundType.click);
    if (mounted) {
      setState(() {
        _isLiked = true;
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

  _viewProfessionalProfile() async {
    AccountHolder user =
        await DatabaseService.getUserWithId(widget.post.authorId);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProfileProfessionalProfile(
                  currentUserId: Provider.of<UserData>(context).currentUserId!,
                  userId: widget.post.authorId,
                  user: user,
                )));
  }

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
            ? GestureDetector(
                onVerticalDragUpdate: (details) {},
                onHorizontalDragUpdate: (details) {
                  if (details.delta.direction <= 0) {
                    Navigator.pop(context);
                  }
                },
                child: ContentWarning(
                  report: widget.post.report,
                  onPressed: _setContentWarning,
                  imageUrl: widget.post.imageUrl,
                ),
              )
            : GestureDetector(
                onVerticalDragUpdate: (details) {},
                onHorizontalDragUpdate: (details) {
                  if (details.delta.direction <= 0) {
                    Navigator.pop(context);
                  }
                },
                child: Stack(
                    alignment: FractionalOffset.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        GestureDetector(
                          onLongPress: () => Navigator.of(context).push(
                              PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  pageBuilder: (context, animation, _) {
                                    HapticFeedback.heavyImpact();

                                    return FadeTransition(
                                      opacity: animation,
                                      child: ExplorePosts(
                                        feed: 'Feed',
                                        currentUserId: widget.currentUserId,
                                        post: widget.post,
                                      ),
                                    );
                                  })),
                          child: Hero(
                            tag: 'postImage' + widget.post.id.toString(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: GestureDetector(
                                onDoubleTap: _setImage,
                                child: Container(
                                    height: height,
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
                                        : const SizedBox.shrink()),
                              ),
                            ),
                          ),
                        ),
                        _imageAnim
                            ? Animator(
                                duration: const Duration(milliseconds: 300),
                                tween: Tween(begin: 0.5, end: 1.4),
                                curve: Curves.elasticOut,
                                builder: (context, anim, child) =>
                                    Transform.scale(
                                  scale: anim.value as double,
                                  child: Container(
                                    height: height,
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
                            : const SizedBox.shrink(),
                        _displayImage == false
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, left: 10.0, right: 10.0),
                                child: GestureDetector(
                                  onDoubleTap: () {
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
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Stack(
                                          alignment: FractionalOffset.center,
                                          children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Slidable(
                                                    startActionPane: ActionPane(
                                                      motion:
                                                          const DrawerMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          onPressed: (_) async {
                                                            await new Future
                                                                    .delayed(
                                                                const Duration(
                                                                    milliseconds:
                                                                        100));
                                                            widget.currentUserId ==
                                                                    widget.post
                                                                        .authorId
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
                                                                : widget.post
                                                                        .authorHandleType
                                                                        .startsWith(
                                                                            'Fan')
                                                                    ? () {}
                                                                    : _viewProfessionalProfile();
                                                          },
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          foregroundColor:
                                                              Colors.white,
                                                          icon: widget.currentUserId ==
                                                                  widget.post
                                                                      .authorId
                                                              ? Icons.edit
                                                              : widget.post
                                                                      .authorHandleType
                                                                      .startsWith(
                                                                          'Fan')
                                                                  ? null
                                                                  : Icons.work,
                                                          label: widget
                                                                      .currentUserId ==
                                                                  widget.post
                                                                      .authorId
                                                              ? 'Edit mood'
                                                              : widget.post
                                                                      .authorHandleType
                                                                      .startsWith(
                                                                          'Fan')
                                                                  ? ' '
                                                                  : 'Booking page ',
                                                        ),
                                                      ],
                                                    ),
                                                    child: FocusedMenuHolder(
                                                      menuWidth: width,
                                                      menuItemExtent: 60,
                                                      menuOffset: 10,
                                                      blurBackgroundColor:
                                                          Colors.transparent,
                                                      openWithTap: false,
                                                      onPressed: () {},
                                                      menuItems: [
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              width: width - 40,
                                                              child: Center(
                                                                child: Text(
                                                                  'Send ',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textScaleFactor:
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .textScaleFactor,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          SendToChats(
                                                                            currentUserId:
                                                                                widget.currentUserId,
                                                                            userId:
                                                                                '',
                                                                            sendContentType:
                                                                                'Mood Punched',
                                                                            event:
                                                                                null,
                                                                            post:
                                                                                widget.post,
                                                                            forum:
                                                                                null,
                                                                            user:
                                                                                null,
                                                                            sendContentId:
                                                                                widget.post.id!,
                                                                          )));
                                                            }),
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              width: width - 40,
                                                              child: Center(
                                                                child: Text(
                                                                  'Share ',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textScaleFactor:
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .textScaleFactor,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () =>
                                                                _dynamicLink()),
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              width: width - 40,
                                                              child: Center(
                                                                child: Text(
                                                                  widget.post.authorId ==
                                                                          widget
                                                                              .currentUserId
                                                                      ? 'Edit mood punched'
                                                                      : 'Report',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textScaleFactor:
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .textScaleFactor,
                                                                ),
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
                                                                        builder: (_) => ReportContentPage(
                                                                              parentContentId: widget.post.id,
                                                                              repotedAuthorId: widget.post.authorId,
                                                                              contentType: 'Mood punched',
                                                                              contentId: widget.post.id!,
                                                                            )))),
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              width: width - 40,
                                                              child: Center(
                                                                child: Text(
                                                                  'Suggestion Box',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textScaleFactor:
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .textScaleFactor,
                                                                ),
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
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 16.0,
                                                                              vertical: 0.0),
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap: () => Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (_) =>

                                                                                            //  widget.post.authorName.isEmpty
                                                                                            //     ? UserNotFound(
                                                                                            //         userName: 'User',
                                                                                            //       )
                                                                                            //     :

                                                                                            ProfileScreen(
                                                                                              currentUserId: widget.currentUserId,
                                                                                              userId: widget.post.authorId,
                                                                                            ))),
                                                                                child: Container(
                                                                                  width: width,
                                                                                  height: 65,
                                                                                  child: ListView(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    children: <Widget>[
                                                                                      Material(
                                                                                        color: Colors.transparent,
                                                                                        child: Container(
                                                                                            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                                                          Hero(
                                                                                            tag: 'author' + widget.post.id.toString(),
                                                                                            child: widget.author.profileImageUrl!.isEmpty
                                                                                                ? Icon(
                                                                                                    Icons.account_circle,
                                                                                                    size: 50.0,
                                                                                                    color: Colors.grey,
                                                                                                  )
                                                                                                : CircleAvatar(
                                                                                                    radius: 25.0,
                                                                                                    backgroundColor: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
                                                                                                    backgroundImage: CachedNetworkImageProvider(widget.author.profileImageUrl!),
                                                                                                  ),
                                                                                          ),
                                                                                          const SizedBox(
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
                                                                                                  widget.post.authorVerification.isEmpty
                                                                                                      ? const SizedBox.shrink()
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
                                                                                                    TextSpan(text: "${widget.author.profileHandle}\n", style: const TextStyle(fontSize: 10, color: Colors.white)),
                                                                                                    // TextSpan(text: "${widget.author.company}", style: const TextStyle(fontSize: 10, color: Colors.white)),
                                                                                                  ],
                                                                                                ),
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ])),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              _heartAnim
                                                                                  ? Container(
                                                                                      height: Responsive.isDesktop(context) ? 400 : 300,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(bottom: 60.0),
                                                                                        child: Center(
                                                                                          child: Animator(
                                                                                              duration: Duration(milliseconds: 300),
                                                                                              tween: Tween(begin: 0.5, end: 1.4),
                                                                                              curve: Curves.elasticOut,
                                                                                              builder: (context, anim2, child) => Transform.scale(
                                                                                                    scale: anim2.value as double,
                                                                                                    child: const Icon(
                                                                                                      Icons.favorite,
                                                                                                      size: 200.0,
                                                                                                      color: Colors.white,
                                                                                                    ),
                                                                                                  )),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  : const SizedBox.shrink()
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                10),
                                                                        GestureDetector(
                                                                          onTap: () => Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (_) => PunchWidget(
                                                                                        currentUserId: widget.currentUserId,
                                                                                        post: widget.post,
                                                                                      ))),
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
                                                                                      style: const TextStyle(
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
                                                                        const SizedBox(
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
                                                                        const SizedBox(
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
                                                                        const SizedBox(
                                                                            height:
                                                                                5),
                                                                        BarsTextFooter(
                                                                          text:
                                                                              timeago.format(
                                                                            widget.post.timestamp!.toDate(),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                20),
                                                                        GestureDetector(
                                                                          onTap: () => Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (_) => PunchWidget(
                                                                                        currentUserId: widget.currentUserId,
                                                                                        post: widget.post,
                                                                                      ))),
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
                                                  const SizedBox(
                                                    height: 70,
                                                  ),
                                                  widget.post.musicLink.isEmpty
                                                      ? const SizedBox.shrink()
                                                      : IconButton(
                                                          icon: const Icon(
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
                                                ]),
                                          ]),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
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
                                    child: const Icon(
                                      MdiIcons.eye,
                                      color: Colors.grey,
                                      size: 150.0,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                        // ]),
                      ]),
                    ]),
              ),
      ),
    );
  }
}
