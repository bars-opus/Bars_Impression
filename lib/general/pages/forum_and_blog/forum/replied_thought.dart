import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReplyThoughtsScreen extends StatefulWidget {
  final Forum forum;
  final Thought thought;
  final String currentUserId;
  final bool isBlocked;
  final AccountHolder author;

  ReplyThoughtsScreen({
    required this.forum,
    required this.currentUserId,
    required this.thought,
    required this.author,
    required this.isBlocked,
  });

  @override
  _ReplyThoughtsScreenState createState() => _ReplyThoughtsScreenState();
}

class _ReplyThoughtsScreenState extends State<ReplyThoughtsScreen> {
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

  final TextEditingController _replythoughtController = TextEditingController();
  bool _isThinking = false;
  late ScrollController _hideButtonController;
  late ScrollController _hideButtonController2;
  late ScrollController _hideAppBarController;
  bool _displayWarning = false;
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  var _isVisible;
  int _count = 0;

  void initState() {
    super.initState();
    _isVisible = true;
    _count = widget.thought.count!;
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

  _buildComment(ReplyThought replyThought, AccountHolder author) {
    final String currentUserId = Provider.of<UserData>(context).currentUserId!;
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: FutureBuilder(
        future: DatabaseService.getUserWithId(replyThought.authorId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          AccountHolder author = snapshot.data;
          return ListTile(
            leading: currentUserId == author.id!
                ? SizedBox.shrink()
                : CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: author.profileImageUrl!.isEmpty
                        ? AssetImage(
                            'assets/images/user_placeholder2.png',
                          ) as ImageProvider
                        : CachedNetworkImageProvider(author.profileImageUrl!),
                  ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: currentUserId != author.id!
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  currentUserId == author.id! ? 'Me' : author.userName!,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  ),
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
                      colorHue: ColorHue.multiple(colorHues: _hueType),
                      colorSaturation: _colorSaturation,
                    ),
                    height: 1.0,
                    width: 30.0,
                  ),
                ),
                replyThought.report.isNotEmpty
                    ? BarsTextStrikeThrough(
                        fontSize: 12,
                        text: replyThought.content,
                      )
                    : Text(
                        replyThought.content,
                        style: TextStyle(
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                            fontSize: 12.0),
                      ),
                SizedBox(height: 10.0),
                Text(
                    timeago.format(
                      replyThought.timestamp.toDate(),
                    ),
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
                SizedBox(
                  height: 2.0,
                ),
                Divider(
                  color: Colors.grey,
                ),
              ],
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                          currentUserId:
                              Provider.of<UserData>(context).currentUserId!,
                          userId: author.id!,
                        ))),
          );
        },
      ),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        controller: _replythoughtController,
                        keyboardType: TextInputType.multiline,
                        maxLines: _replythoughtController.text.length > 300
                            ? 10
                            : null,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (thought) =>
                            Provider.of<UserData>(context, listen: false)
                                .setPost9(thought),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Reply...',
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
                          color: Provider.of<UserData>(context, listen: false)
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
                          if (_replythoughtController.text.isNotEmpty ||
                              Provider.of<UserData>(context, listen: false)
                                  .post9
                                  .isNotEmpty) {
                            setState(() {
                              _count = _count + 1;
                            });
                            HapticFeedback.mediumImpact();
                            DatabaseService.replyThought(
                              count: _count,
                              currentUserId: currentUserId!,
                              forum: widget.forum,
                              replyThought: _replythoughtController.text,
                              thoughtId: widget.thought.id,
                              reportConfirmed: '',
                            );
                            setState(() {
                              _isThinking = false;
                              _replythoughtController.clear();
                              Provider.of<UserData>(context, listen: false)
                                  .setPost9('');
                            });
                          }
                        },
                      ),
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
    Provider.of<UserData>(context, listen: false).setPost9('');
    Provider.of<UserData>(context, listen: false).setPost8('');
    Provider.of<UserData>(context, listen: false).setPost7('');
    Provider.of<UserData>(context, listen: false).setPost6('');
    _replythoughtController.clear();
    if (mounted) {
      setState(() {
        _isThinking = false;
      });
    }
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
                            ? Colors.white
                            : ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                        onPressed: _pop,
                      ),
                    )
                  : SizedBox.shrink(),
            ]),
          )
        : ResponsiveScaffold(
            child: Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: ConfigBloc().darkModeOn
                      ? Colors.white
                      : ConfigBloc().darkModeOn
                          ? Colors.white
                          : Colors.black,
                ),
                automaticallyImplyLeading: true,
                elevation: 0,
                backgroundColor: ConfigBloc().darkModeOn
                    ? Color(0xFF1a1a1a)
                    : Color(0xFFf2f2f2),
                title: Text(
                  'Reply thought',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  ),
                ),
              ),
              body: SafeArea(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 50.0,
                                          bottom: 5.0,
                                          top: 10.0,
                                          left: 15),
                                      child: ListTile(
                                        leading: GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => ProfileScreen(
                                                        currentUserId: Provider
                                                                .of<UserData>(
                                                                    context)
                                                            .currentUserId!,
                                                        userId:
                                                            widget.author.id!,
                                                      ))),
                                          child: CircleAvatar(
                                            radius: 30.0,
                                            backgroundColor: Colors.grey,
                                            backgroundImage: widget.author
                                                    .profileImageUrl!.isEmpty
                                                ? AssetImage(
                                                    'assets/images/user_placeholder2.png',
                                                  ) as ImageProvider
                                                : CachedNetworkImageProvider(
                                                    widget.author
                                                        .profileImageUrl!),
                                          ),
                                        ),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.author.userName!,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: ConfigBloc().darkModeOn
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            Text(widget.author.profileHandle!,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.blueGrey,
                                                )),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2.0),
                                              child: Container(
                                                color: _randomColor.randomColor(
                                                  colorHue: ColorHue.multiple(
                                                      colorHues: _hueType),
                                                  colorSaturation:
                                                      _colorSaturation,
                                                ),
                                                height: 1.0,
                                                width: 50.0,
                                              ),
                                            ),
                                            widget.thought.report.isNotEmpty
                                                ? BarsTextStrikeThrough(
                                                    fontSize: 16,
                                                    text:
                                                        widget.thought.content,
                                                  )
                                                : Text(
                                                    widget.thought.content,
                                                    style: TextStyle(
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 16.0),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                            SizedBox(height: 10.0),
                                          ],
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                          timeago.format(
                                            widget.thought.timestamp.toDate(),
                                          ),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: StreamBuilder(
                                      stream: replyThoughtsRef
                                          .doc(widget.thought.id)
                                          .collection('replyThoughts')
                                          .orderBy(
                                            'timestamp',
                                            descending: true,
                                          )
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container(
                                              height: 50,
                                              color: Colors.red,
                                              child: SizedBox.shrink());
                                        }
                                        return MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          removeBottom: true,
                                          child: ListView.builder(
                                              controller:
                                                  _hideButtonController2,
                                              shrinkWrap: true,
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                ReplyThought replyThought =
                                                    ReplyThought.fromDoc(
                                                        snapshot
                                                            .data.docs[index]);
                                                return FutureBuilder(
                                                  future: DatabaseService
                                                      .getUserWithId(
                                                          replyThought
                                                              .authorId),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return SizedBox.shrink();
                                                    }
                                                    AccountHolder author =
                                                        snapshot.data;
                                                    return _buildComment(
                                                        replyThought, author);
                                                  },
                                                );
                                              }),
                                        );
                                      }),
                                ),
                                widget.isBlocked
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
