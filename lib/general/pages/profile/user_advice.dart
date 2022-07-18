import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:timeago/timeago.dart' as timeago;

class UserAdviceScreen extends StatefulWidget {
  final AccountHolder user;
  final String currentUserId;

  UserAdviceScreen({required this.user, required this.currentUserId});

  @override
  _UserAdviceScreenState createState() => _UserAdviceScreenState();
}

class _UserAdviceScreenState extends State<UserAdviceScreen> {
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

  final TextEditingController _adviceControler = TextEditingController();
  bool _isAdvicingUser = false;
  bool _isBlockedUser = false;
  int _userAdviceCount = 0;
  late ScrollController _hideButtonController;
  late ScrollController _hideAppBarController;
  var _isVisible;

  void initState() {
    super.initState();
    _setUpUserAdvice();
    _setupIsBlockedUser();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setPost9('');
    });
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
      userId: widget.user.id!,
    );
    setState(() {
      _isBlockedUser = isBlockedUser;
    });
  }

  _setUpUserAdvice() async {
    DatabaseService.numAdvices(widget.user.id!).listen((userAdviceCount) {
      if (mounted) {
        setState(() {
          _userAdviceCount = userAdviceCount;
        });
      }
    });
  }

  _buildBlogComment(UserAdvice userAdvice, AccountHolder author) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    return FutureBuilder(
      future: DatabaseService.getUserWithId(userAdvice.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        AccountHolder author = snapshot.data;
        return FocusedMenuHolder(
          menuWidth: width,
          menuOffset: 1,
          blurBackgroundColor: Colors.white10,
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
                        builder: (_) => EditAdvice(
                            advice: userAdvice,
                            currentUserId: widget.currentUserId,
                            user: widget.user),
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
                                    user: widget.user,
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
                              parentContentId: widget.user.id,
                              repotedAuthorId: userAdvice.authorId,
                              contentId: userAdvice.id,
                              contentType: 'advice',
                            )))),
          ],
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor:
                    MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
                      child: Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      currentUserId == author.id!
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditAdvice(
                                    advice: userAdvice,
                                    currentUserId: widget.currentUserId,
                                    user: widget.user),
                              ),
                            )
                          : SizedBox.shrink();
                    },
                    backgroundColor: Color(0xFF1a1a1a),
                    foregroundColor: Colors.white,
                    icon: currentUserId == author.id! ? Icons.edit : null,
                    label: currentUserId == author.id! ? 'Edit your advice' : '',
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: currentUserId == author.id!
                      ? const EdgeInsets.only(left: 30.0)
                      : const EdgeInsets.only(right: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: currentUserId == author.id!
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        border: Border.all(
                          color: ConfigBloc().darkModeOn
                              ? Colors.grey[800]!
                              : Colors.grey[400]!,
                          width: 1,
                        )),
                    child: Column(
                      crossAxisAlignment: currentUserId == author.id!
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: currentUserId == author.id!
                              ? SizedBox.shrink()
                              : CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: ConfigBloc().darkModeOn
                                      ? Color(0xFF1a1a1a)
                                      : Color(0xFFf2f2f2),
                                  backgroundImage: author.profileImageUrl!.isEmpty
                                      ? AssetImage(
                                          ConfigBloc().darkModeOn
                                              ? 'assets/images/user_placeholder.png'
                                              : 'assets/images/user_placeholder2.png',
                                        ) as ImageProvider
                                      : CachedNetworkImageProvider(
                                          author.profileImageUrl!),
                                ),
                          title: Column(
                            crossAxisAlignment: currentUserId == author.id!
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
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
                                          padding:
                                              const EdgeInsets.only(right: 12.0),
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
                                                  MdiIcons.checkboxMarkedCircle,
                                                  size: 11,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                      ],
                                    ),
                              Text(author.profileHandle!,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  )),
                              SizedBox(
                                height: 5.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Container(
                                  color: _randomColor.randomColor(
                                    colorHue:
                                        ColorHue.multiple(colorHues: _hueType),
                                    colorSaturation: _colorSaturation,
                                  ),
                                  height: 1.0,
                                  width: 50.0,
                                ),
                              ),
                              widget.user.id == currentUserId
                                  ? Material(
                                      color: Colors.transparent,
                                      child: userAdvice.report.isNotEmpty
                                          ? BarsTextStrikeThrough(
                                              fontSize: 12,
                                              text: userAdvice.content,
                                            )
                                          : Text(
                                              userAdvice.content,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0),
                                            ))
                                  : widget.user.hideAdvice!
                                      ? BarsTextStrikeThrough(
                                          fontSize: 12,
                                          text: '*********************',
                                        )
                                      : Material(
                                          color: Colors.transparent,
                                          child: userAdvice.report.isNotEmpty
                                              ? BarsTextStrikeThrough(
                                                  fontSize: 12,
                                                  text: userAdvice.content,
                                                )
                                              : Text(
                                                  userAdvice.content,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0),
                                                )),
                              Text(
                                  timeago.format(
                                    userAdvice.timestamp.toDate(),
                                  ),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey)),
                              SizedBox(height: 10.0),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ProfileScreen(
                                        currentUserId: currentUserId,
                                        userId: author.id!,
                                        user: widget.user,
                                      ))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildUserAdvice() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: _isVisible ? null : 0.0,
        child: IconTheme(
          data: IconThemeData(
            color:
                _isAdvicingUser ? Colors.blue : Theme.of(context).disabledColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
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
                        controller: _adviceControler,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines:
                            _adviceControler.text.length > 300 ? 10 : null,
                        onChanged: (userAdvice) =>
                            Provider.of<UserData>(context, listen: false)
                                .setPost9(userAdvice),
                        decoration: InputDecoration.collapsed(
                          hintText: widget.user.id == currentUserId
                              ? 'Reply advice'
                              : 'Leave an advice for ${widget.user.name}',
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
                            ? Color(0xFF1a1a1a)
                            : Colors.transparent,
                        icon: Icon(
                          Icons.send,
                          color: Provider.of<UserData>(context, listen: false)
                                  .post9
                                  .isNotEmpty
                              ? Colors.white
                              : ConfigBloc().darkModeOn
                                  ? Color(0xFF1a1a1a)
                                  : Theme.of(context).disabledColor,
                        ),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          if (Provider.of<UserData>(context, listen: false)
                              .post9
                              .isNotEmpty) {
                            DatabaseService.userAdvice(
                              currentUserId: currentUserId,
                              user: widget.user,
                              reportConfirmed: '',
                              advice: _adviceControler.text,
                            );
                            _adviceControler.clear();
                            Provider.of<UserData>(context, listen: false)
                                .setPost9('');
                            setState(() {
                              _isAdvicingUser = false;
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
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor: Color(0xFF1a1a1a),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10,
            top: 50,
          ),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Container(
                color: Color(0xFF1a1a1a),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 50,
                child: Material(
                  color: Colors.transparent,
                  child: NestedScrollView(
                      controller: _hideAppBarController,
                      headerSliverBuilder: (context, innerBoxScrolled) => [],
                      body: Container(
                          color: Color(0xFF1a1a1a),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                height: _isVisible ? 140 : 0.0,
                                child: Material(
                                  color: Color(0xFF1a1a1a),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      color: Color(0xFF1a1a1a),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5.0, 0, 10, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Platform.isIOS
                                                      ? Icons.arrow_back_ios
                                                      : Icons.arrow_back),
                                                  iconSize: 30.0,
                                                  color: Colors.white,
                                                  onPressed: _pop,
                                                ),
                                                Text(
                                                  ' ',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0, top: 20),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Icon(
                                                        Icons.message,
                                                        color:
                                                            Color(0xFF1a1a1a),
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    widget.user.id ==
                                                            widget.currentUserId
                                                        ? 'Advices \nFor You'
                                                        : '${widget.user.userName}\'s \nAdvices',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0,
                                                        height: 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Color(0xFF1a1a1a),
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
                                      color: Color(0xFFf2f2f2),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0))),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Color(0xFFf2f2f2),
                                  child: Column(
                                    children: [
                                      widget.user.hideAdvice!
                                          ? Padding(
                                              padding: EdgeInsets.all(40.0),
                                              child: Text(
                                                widget.user.userName! +
                                                    ' Wishes to keep advices private.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      StreamBuilder(
                                        stream: userAdviceRef
                                            .doc(widget.user.id)
                                            .collection('userAdvice')
                                            .orderBy('timestamp',
                                                descending: true)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (!snapshot.hasData) {
                                            return Expanded(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                          return _userAdviceCount == 0
                                              ? Expanded(
                                                  child: Center(
                                                    child: NoContents(
                                                      icon: (MdiIcons
                                                          .sendOutline),
                                                      title:
                                                          'No advices for ${widget.user.userName} yet,',
                                                      subTitle:
                                                          'You can be the first to leave an advice for ${widget.user.name},  ',
                                                    ),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12.0),
                                                  child: Scrollbar(
                                                      child: CustomScrollView(
                                                          reverse: true,
                                                          slivers: [
                                                        SliverList(
                                                          delegate:
                                                              SliverChildBuilderDelegate(
                                                            (context, index) {
                                                              UserAdvice
                                                                  userAdvice =
                                                                  UserAdvice.fromDoc(
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]);
                                                              return FutureBuilder(
                                                                  future: DatabaseService
                                                                      .getUserWithId(
                                                                          userAdvice
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
                                                                        snapshot
                                                                            .data;
                                                                    return _buildBlogComment(
                                                                        userAdvice,
                                                                        author);
                                                                  });
                                                            },
                                                            childCount: snapshot
                                                                .data
                                                                .docs
                                                                .length,
                                                          ),
                                                        )
                                                      ])),
                                                ));
                                        },
                                      ),
                                      widget.user.disableAdvice!
                                          ? Padding(
                                              padding: EdgeInsets.all(40.0),
                                              child: Text(
                                                widget.user.userName! +
                                                    ' is not interested in recieving new advices at the moment.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                          : _isBlockedUser
                                              ? SizedBox.shrink()
                                              : _buildUserAdvice(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ))),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
