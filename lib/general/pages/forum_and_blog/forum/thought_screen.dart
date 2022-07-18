import 'package:bars/general/pages/forum_and_blog/forum/replied_thought.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ThoughtsScreen extends StatefulWidget {
  final Forum forum;
  final AccountHolder author;
  final int thoughtCount;
  final String currentUserId;
  final String feed;

  ThoughtsScreen(
      {required this.forum,
      required this.thoughtCount,
      required this.author,
      required this.feed,
      required this.currentUserId});

  @override
  _ThoughtsScreenState createState() => _ThoughtsScreenState();
}

class _ThoughtsScreenState extends State<ThoughtsScreen> {
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

  final TextEditingController _thoughtController = TextEditingController();
  bool _isThinking = false;
  bool _isBlockedUser = false;
  late ScrollController _hideButtonController;
  late ScrollController _hideButtonController2;
  late ScrollController _hideAppBarController;
  int _thoughtCount = 0;
  bool _displayWarning = false;
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  var _isVisible;

  void initState() {
    super.initState();
    _setUpThoughts();
    _isVisible = true;
    _setupIsBlockedUser();
    _displayWarning = widget.forum.report.isNotEmpty ? true : false;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setPost9('');
    });

    _hideButtonController2 = new ScrollController();
    _hideButtonController2.addListener(() {
      if (_hideButtonController2.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
      if (_hideButtonController2.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
    });

    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
    });
    _hideAppBarController = new ScrollController();
    _hideAppBarController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.author.id!,
    );
    setState(() {
      _isBlockedUser = isBlockedUser;
    });
  }

  _setUpThoughts() async {
    DatabaseService.numThoughts(widget.forum.id).listen((thoughtCount) {
      if (mounted) {
        setState(() {
          _thoughtCount = thoughtCount;
        });
      }
    });
  }

  _buildThought(Thought thought, AccountHolder author) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    return FutureBuilder(
      future: DatabaseService.getUserWithId(thought.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        AccountHolder author = snapshot.data;

        return FocusedMenuHolder(
          menuWidth: width,
          menuOffset: 10,
          blurBackgroundColor:
              ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.blueGrey[700],
          openWithTap: false,
          onPressed: () {},
          menuItems: [
            FocusedMenuItem(
              title: Container(
                width: width / 2,
                child: Text(
                  currentUserId == author.id!
                      ? 'Edit your thought'
                      : author.profileHandle!.startsWith('Fan') ||
                              author.profileHandle!.isEmpty
                          ? 'Go to ${author.userName}\' profile '
                          : 'Go to ${author.userName}\' booking page ',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
              ),
              onPressed: () => currentUserId == author.id!
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditThought(
                          thought: thought,
                          currentUserId: widget.currentUserId,
                          forum: widget.forum,
                        ),
                      ),
                    )
                  : author.profileHandle!.startsWith('Fan') ||
                          author.profileHandle!.isEmpty
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId,
                                    userId: author.id!,
                                    user: widget.author,
                                  )))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileProfessionalProfile(
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId,
                                    user: author,
                                    userId: author.id!,
                                  ))),
            ),
            FocusedMenuItem(
                title: Container(
                  width: width / 2,
                  child: Text(
                    'Report',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportContentPage(
                              parentContentId: widget.forum.id,
                              repotedAuthorId: thought.authorId,
                              contentId: thought.id,
                              contentType: 'thought',
                            )))),
            FocusedMenuItem(
              title: Container(
                width: width / 2,
                child: Text(
                  'Reply',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReplyThoughtsScreen(
                      thought: thought,
                      currentUserId: widget.currentUserId,
                      forum: widget.forum,
                      author: author,
                      isBlocked: _isBlockedUser,
                    ),
                  ),
                );
              },
            ),
          ],
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor:
                    MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
            child: Column(
              children: [
                Slidable(
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          currentUserId == author.id!
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditThought(
                                      thought: thought,
                                      currentUserId: widget.currentUserId,
                                      forum: widget.forum,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink();
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Colors.white,
                        icon: currentUserId == author.id! ? Icons.edit : null,
                        label: currentUserId == author.id!
                            ? 'Edit your thought'
                            : '',
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: currentUserId == author.id!
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: currentUserId == author.id!
                            ? const EdgeInsets.only(
                                left: 50.0, bottom: 5.0, top: 10.0, right: 15)
                            : const EdgeInsets.only(
                                right: 50.0, bottom: 5.0, top: 10.0, left: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              color: currentUserId == author.id!
                                  ? Colors.blue[100]
                                  : Colors.white,
                              borderRadius: currentUserId == author.id!
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(30.0))
                                  : BorderRadius.only(
                                      topRight: Radius.circular(30.0),
                                      topLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(30.0))),
                          child: ListTile(
                            leading: currentUserId == author.id!
                                ? SizedBox.shrink()
                                : CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                        author.profileImageUrl!.isEmpty
                                            ? AssetImage(
                                                'assets/images/user_placeholder2.png',
                                              ) as ImageProvider
                                            : CachedNetworkImageProvider(
                                                author.profileImageUrl!),
                                  ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: currentUserId != author.id!
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: <Widget>[
                                currentUserId == author.id!
                                    ? Text(
                                        'Me',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      )
                                    : Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12.0),
                                            child: Text(
                                              author.userName!,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          author.verified!.isEmpty
                                              ? SizedBox.shrink()
                                              : Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Icon(
                                                    MdiIcons
                                                        .checkboxMarkedCircle,
                                                    size: 11,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                        ],
                                      ),
                                Text(author.profileHandle!,
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.blueGrey,
                                    )),
                                SizedBox(
                                  height: 5.0,
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: currentUserId == author.id!
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Container(
                                    color: _randomColor.randomColor(
                                      colorHue: ColorHue.multiple(
                                          colorHues: _hueType),
                                      colorSaturation: _colorSaturation,
                                    ),
                                    height: 1.0,
                                    width: 50.0,
                                  ),
                                ),
                                thought.report.isNotEmpty
                                    ? BarsTextStrikeThrough(
                                        fontSize: 12,
                                        text: thought.content,
                                      )
                                    : Text(
                                        thought.content,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0),
                                      ),
                                SizedBox(height: 10.0),
                              ],
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProfileScreen(
                                          currentUserId:
                                              Provider.of<UserData>(context)
                                                  .currentUserId,
                                          userId: author.id!,
                                          user: widget.author,
                                        ))),
                          ),
                        ),
                      ),
                      thought.count! > 0
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReplyThoughtsScreen(
                                        thought: thought,
                                        currentUserId: widget.currentUserId,
                                        forum: widget.forum,
                                        author: author,
                                        isBlocked: _isBlockedUser,
                                      ),
                                    ),
                                  );
                                },
                                child: RichText(
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: timeago.format(
                                            thought.timestamp.toDate(),
                                          ),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          )),
                                      TextSpan(
                                          text:
                                              " View ${NumberFormat.compact().format(
                                            thought.count,
                                          )} replies",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                  timeago.format(
                                    thought.timestamp.toDate(),
                                  ),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey)),
                            ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildThoughtTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: _isVisible ? null : 0.0,
        child: IconTheme(
          data: IconThemeData(
            color: _isThinking ? Colors.blue : Theme.of(context).disabledColor,
          ),
          child: Container(
            child: Material(
              color: Colors.white,
              elevation: 10.0,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: _thoughtController,
                            keyboardType: TextInputType.multiline,
                            maxLines: _thoughtController.text.length > 300
                                ? 10
                                : null,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (thought) =>
                                Provider.of<UserData>(context, listen: false)
                                    .setPost9(thought),
                            decoration: InputDecoration.collapsed(
                              hintText: 'What do you think?...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          child: CircularButton(
                            color: Provider.of<UserData>(context, listen: false)
                                    .post9
                                    .isNotEmpty
                                ? Colors.blue
                                : Colors.transparent,
                            icon: Icon(
                              Icons.send,
                              color:
                                  Provider.of<UserData>(context, listen: false)
                                          .post9
                                          .isNotEmpty
                                      ? Colors.white
                                      : !_isVisible
                                          ? Colors.transparent
                                          : ConfigBloc().darkModeOn
                                              ? Color(0xFF1a1a1a)
                                              : Theme.of(context).disabledColor,
                            ),
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              if (Provider.of<UserData>(context, listen: false)
                                  .post9
                                  .isNotEmpty) {
                                DatabaseService.thoughtOnForum(
                                  currentUserId: currentUserId,
                                  forum: widget.forum,
                                  thought: _thoughtController.text,
                                  reportConfirmed: '',
                                );
                                Provider.of<UserData>(context, listen: false)
                                    .setPost9('');
                                _thoughtController.clear();
                                setState(() {
                                  _isThinking = false;
                                });
                                Provider.of<UserData>(context, listen: false)
                                    .setPost8('');
                                Provider.of<UserData>(context, listen: false)
                                    .setPost7('');
                                Provider.of<UserData>(context, listen: false)
                                    .setPost6('');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _pop() {
    Navigator.pop(context);
    Provider.of<UserData>(context, listen: false).setPost9('');
    Provider.of<UserData>(context, listen: false).setPost8('');
    Provider.of<UserData>(context, listen: false).setPost7('');
    Provider.of<UserData>(context, listen: false).setPost6('');
  }

  _setContentWarning() {
    if (mounted) {
      setState(() {
        _displayWarning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _displayWarning == true
        ? Material(
            child: Stack(children: <Widget>[
              ContentWarning(
                report: widget.forum.report,
                onPressed: _setContentWarning,
                imageUrl: widget.author.profileImageUrl!,
              ),
              _displayWarning == true
                  ? Positioned(
                      top: 50,
                      left: 10,
                      child: IconButton(
                        icon: Icon(Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back),
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Color(0xFFe8f3fa),
                        onPressed: _pop,
                      ),
                    )
                  : SizedBox.shrink(),
            ]),
          )
        : ResponsiveScaffold(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Material(
                    color: Colors.transparent,
                    child: NestedScrollView(
                        controller: _hideAppBarController,
                        headerSliverBuilder: (context, innerBoxScrolled) => [],
                        body: Container(
                            color: ConfigBloc().darkModeOn
                                ? Color(0xFF1a1a1a)
                                : Color(0xFFf2f2f2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  height: _isVisible ? 230 : 0.0,
                                  child: Material(
                                    color: Colors.blue,
                                    child: SingleChildScrollView(
                                      child: GestureDetector(
                                        onLongPress: () => Navigator.of(context)
                                            .push(PageRouteBuilder(
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 500),
                                                pageBuilder:
                                                    (context, animation, _) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: ExploreForums(
                                                      currentUserId:
                                                          widget.currentUserId,
                                                      feed: widget.feed,
                                                      author: widget.author,
                                                      forum: widget.forum,
                                                      profileImage: widget
                                                          .author
                                                          .profileImageUrl!,
                                                    ),
                                                  );
                                                })),
                                        child: Container(
                                          color: Colors.blue,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10.0, 30, 10, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0,
                                                                top: 8.0,
                                                                bottom: 8.0),
                                                        child: IconButton(
                                                          icon: Icon(Platform.isIOS
                                                              ? Icons
                                                                  .arrow_back_ios
                                                              : Icons
                                                                  .arrow_back),
                                                          color: ConfigBloc()
                                                                  .darkModeOn
                                                              ? Color(
                                                                  0xFF1a1a1a)
                                                              : Color(
                                                                  0xFFe8f3fa),
                                                          onPressed: _pop,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Forum',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Color(0xFF1a1a1a)
                                                            : Color(0xFFe8f3fa),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.info),
                                                      iconSize: 30.0,
                                                      color: Colors.transparent,
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                ),
                                                Hero(
                                                  tag: 'title' +
                                                      widget.forum.id
                                                          .toString(),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      widget.forum.title,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Color(0xFF1a1a1a)
                                                            : Color(0xFFe8f3fa),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3.0,
                                                ),
                                                Hero(
                                                  tag: 'subTitle' +
                                                      widget.forum.id
                                                          .toString(),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      widget.forum.subTitle,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Color(0xFF1a1a1a)
                                                            : Color(0xFFe8f3fa),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Container(
                                                  height: 70,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SingleChildScrollView(
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              90,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              RichText(
                                                                textScaleFactor:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .textScaleFactor,
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            'created by:    ',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: ConfigBloc().darkModeOn
                                                                              ? Color(0xFF1a1a1a)
                                                                              : Color(0xFFe8f3fa),
                                                                        )),
                                                                    TextSpan(
                                                                        text:
                                                                            "${widget.author.userName}  ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: ConfigBloc().darkModeOn
                                                                              ? Color(0xFF1a1a1a)
                                                                              : Color(0xFFe8f3fa),
                                                                        )),
                                                                  ],
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                              RichText(
                                                                textScaleFactor:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .textScaleFactor,
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            'thoughts:    ',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: ConfigBloc().darkModeOn
                                                                              ? Color(0xFF1a1a1a)
                                                                              : Color(0xFFe8f3fa),
                                                                        )),
                                                                    TextSpan(
                                                                        text: NumberFormat.compact().format(
                                                                            _thoughtCount),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: ConfigBloc().darkModeOn
                                                                              ? Color(0xFF1a1a1a)
                                                                              : Color(0xFFe8f3fa),
                                                                        )),
                                                                  ],
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                              SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              Text(
                                                                  timeago
                                                                      .format(
                                                                    widget.forum
                                                                        .timestamp
                                                                        .toDate(),
                                                                  ),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: ConfigBloc()
                                                                            .darkModeOn
                                                                        ? Color(
                                                                            0xFF1a1a1a)
                                                                        : Color(
                                                                            0xFFe8f3fa),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .center_focus_strong,
                                                          color: ConfigBloc()
                                                                  .darkModeOn
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ),
                                                        onPressed: () => Navigator.of(context).push(
                                                            PageRouteBuilder(
                                                                transitionDuration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                pageBuilder:
                                                                    (context,
                                                                        animation,
                                                                        _) {
                                                                  return FadeTransition(
                                                                    opacity:
                                                                        animation,
                                                                    child:
                                                                        ExploreForums(
                                                                      feed: widget
                                                                          .feed,
                                                                      currentUserId:
                                                                          widget
                                                                              .currentUserId,
                                                                      author: widget
                                                                          .author,
                                                                      forum: widget
                                                                          .forum,
                                                                      profileImage: widget
                                                                          .author
                                                                          .profileImageUrl!,
                                                                    ),
                                                                  );
                                                                })),
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
                                Container(
                                  color: Colors.blue,
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(0, -5),
                                            blurRadius: 2.0,
                                            spreadRadius: 2.0,
                                          )
                                        ],
                                        color: ConfigBloc().darkModeOn
                                            ? Color(0xFF1a1a1a)
                                            : Color(0xFFf2f2f2),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.0),
                                            topRight: Radius.circular(30.0))),
                                  ),
                                ),
                                StreamBuilder(
                                  stream: thoughtsRef
                                      .doc(widget.forum.id)
                                      .collection('forumThoughts')
                                      .orderBy(
                                        'timestamp',
                                        descending: true,
                                      )
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return Expanded(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    return _thoughtCount == 0
                                        ? Expanded(
                                            child: Center(
                                              child: NoContents(
                                                icon: (MdiIcons.brain),
                                                title:
                                                    'No thoughts on this forum yet,',
                                                subTitle:
                                                    'You can be the first person to tell us what you think about this forum, ',
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: Scrollbar(
                                                child: CustomScrollView(
                                                    controller:
                                                        _hideButtonController,
                                                    reverse: true,
                                                    slivers: [
                                                SliverList(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                    (context, index) {
                                                      Thought thought =
                                                          Thought.fromDoc(
                                                              snapshot.data
                                                                  .docs[index]);
                                                      return FutureBuilder(
                                                          future: DatabaseService
                                                              .getUserWithId(
                                                                  thought
                                                                      .authorId),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return FollowerUserSchimmerSkeleton();
                                                            }
                                                            AccountHolder
                                                                author =
                                                                snapshot.data;
                                                            return _buildThought(
                                                                thought,
                                                                author);
                                                          });
                                                    },
                                                    childCount: snapshot
                                                        .data.docs.length,
                                                  ),
                                                )
                                              ])));
                                  },
                                ),
                                _isBlockedUser
                                    ? SizedBox.shrink()
                                    : _buildThoughtTF(),
                              ],
                            ))),
                  ),
                ),
              ),
            ),
          );
  }
}
