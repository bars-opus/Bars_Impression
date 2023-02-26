import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';
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
        if (mounted) {
          setState(() {
            _isVisible = true;
          });
        }
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      }
    });
    _hideAppBarController = new ScrollController();
    _hideAppBarController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (mounted) {
          setState(() {
            _isVisible = true;
          });
        }
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      }
    });
  }

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog(context);
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to enable advice?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'enable',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _enableAdvice();
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancle',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to enable advice',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'enable',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _enableAdvice();
                  },
                ),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        });
  }

  _enableAdvice() async {
    usersRef
        .doc(
      widget.currentUserId,
    )
        .update({
      'disableAdvice': false,
    });

    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);

    final double width = MediaQuery.of(context).size.width;
    Flushbar(
      margin: EdgeInsets.all(8),
      boxShadows: [
        BoxShadow(
          color: Colors.black,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      titleText: Text(
        'Done!!',
        style: TextStyle(
          color: Colors.white,
          fontSize: width > 800 ? 22 : 14,
        ),
      ),
      messageText: Text(
        "Advice enabled",
        style: TextStyle(
          color: Colors.white,
          fontSize: width > 800 ? 20 : 12,
        ),
      ),
      icon: Icon(
        MdiIcons.checkCircleOutline,
        size: 30.0,
        color: Colors.blue,
      ),
      duration: Duration(seconds: 2),
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
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

  _viewProfessionalProfile(UserAdvice userAdvice) async {
    AccountHolder user =
        await DatabaseService.getUserWithId(userAdvice.authorId);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProfileProfessionalProfile(
                  currentUserId: Provider.of<UserData>(context).currentUserId!,
                  userId: userAdvice.authorId,
                  user: user,
                )));
  }

  _buildBlogComment(
    UserAdvice userAdvice,
  ) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId = Provider.of<UserData>(context).currentUserId!;
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
                currentUserId == userAdvice.authorId
                    ? 'Edit your advice'
                    : userAdvice.authorProfileHanlde.startsWith('Fan') ||
                            userAdvice.authorProfileHanlde.isEmpty
                        ? 'View profile '
                        : 'View booking page ',
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
            ),
            onPressed: () => currentUserId == userAdvice.authorId
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditAdvice(
                          advice: userAdvice,
                          currentUserId: widget.currentUserId,
                          user: widget.user),
                    ),
                  )
                : userAdvice.authorProfileHanlde.startsWith('Fan') ||
                        userAdvice.authorProfileHanlde.isEmpty
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  currentUserId: Provider.of<UserData>(context)
                                      .currentUserId!,
                                  userId: userAdvice.authorId,
                                  user: widget.user,
                                )))
                    : _viewProfessionalProfile(userAdvice)),
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
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) {
                  currentUserId == userAdvice.authorId
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditAdvice(
                                advice: userAdvice,
                                currentUserId: widget.currentUserId,
                                user: widget.user),
                          ),
                        )
                      : const SizedBox.shrink();
                },
                backgroundColor: Color(0xFF1a1a1a),
                foregroundColor: Colors.white,
                icon: currentUserId == userAdvice.authorId ? Icons.edit : null,
                label: currentUserId == userAdvice.authorId
                    ? 'Edit your advice'
                    : '',
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Padding(
              padding: currentUserId == userAdvice.authorId
                  ? const EdgeInsets.only(left: 30.0)
                  : const EdgeInsets.only(right: 30.0),
              child: Container(
                decoration: BoxDecoration(
                    color: currentUserId == userAdvice.authorId
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
                  crossAxisAlignment: currentUserId == userAdvice.authorId
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: currentUserId == userAdvice.authorId
                          ? const SizedBox.shrink()
                          : CircleAvatar(
                              radius: 20.0,
                              backgroundColor: ConfigBloc().darkModeOn
                                  ? Color(0xFF1a1a1a)
                                  : Color(0xFFf2f2f2),
                              backgroundImage:
                                  userAdvice.authorProfileImageUrl.isEmpty
                                      ? AssetImage(
                                          ConfigBloc().darkModeOn
                                              ? 'assets/images/user_placeholder.png'
                                              : 'assets/images/user_placeholder2.png',
                                        ) as ImageProvider
                                      : CachedNetworkImageProvider(
                                          userAdvice.authorProfileImageUrl),
                            ),
                      title: Column(
                        crossAxisAlignment: currentUserId == userAdvice.authorId
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          currentUserId == userAdvice.authorId
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
                                        userAdvice.authorName,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    userAdvice.authorVerification.isEmpty
                                        ? const SizedBox.shrink()
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
                          Text(userAdvice.authorProfileHanlde,
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
                              color: Colors.black38,
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
                                      : HyperLinkText(
                                          from: 'Advice',
                                          text: userAdvice.content,
                                        ),
                                )
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
                                          : HyperLinkText(
                                              from: 'Advice',
                                              text: userAdvice.content,
                                            ),
                                    ),
                          Text(
                              timeago.format(
                                userAdvice.timestamp.toDate(),
                              ),
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey)),
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
                                    userId: userAdvice.authorId,
                                    user: null,
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
    //   },
    // );
  }

  _buildUserAdvice() {
    final currentUserId = Provider.of<UserData>(context).currentUserId!;
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
                                .setPost9(userAdvice.trim()),
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
                              currentUser:
                                  Provider.of<UserData>(context, listen: false)
                                      .user!,
                              user: widget.user,
                              reportConfirmed: '',
                              advice: _adviceControler.text.trim(),
                            );
                            kpiStatisticsRef.doc('0SuQxtu52SyYjhOKiLsj').update(
                                {'advicesSent': FieldValue.increment(1)});
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
                                            const SizedBox(
                                              height: 10,
                                            ),
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
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            PageFeatureWidget(
                                              heroTag: '',
                                              title: widget.user.id ==
                                                      widget.currentUserId
                                                  ? 'Advices \nFor You'
                                                  : '${widget.user.userName}\'s \nAdvices',
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
                                          : const SizedBox.shrink(),
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
                                            return _userAdviceCount == 0
                                                ? Expanded(
                                                    child: Center(
                                                      child: NoContents(
                                                        icon: (MdiIcons
                                                            .sendOutline),
                                                        title: '',
                                                        subTitle: ' ',
                                                      ),
                                                    ),
                                                  )
                                                : Expanded(
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
                                                      title: widget.user.id ==
                                                              widget
                                                                  .currentUserId
                                                          ? 'No advice for you.'
                                                          : 'No advices for ${widget.user.userName} yet,',
                                                      subTitle: widget
                                                                  .user.id ==
                                                              widget
                                                                  .currentUserId
                                                          ? ''
                                                          : 'You can be the first to leave an advice for ${widget.user.name},  ',
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
                                                              return _buildBlogComment(
                                                                userAdvice,
                                                              );
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
                                          ? widget.user.id ==
                                                  widget.currentUserId
                                              ? Padding(
                                                  padding: EdgeInsets.all(40.0),
                                                  child: GestureDetector(
                                                    onTap:
                                                        _showSelectImageDialog,
                                                    child: Text(
                                                      widget.user.userName! +
                                                          ', Receiving new advice is disabled. To enable advice, tap here.\n\nYour advice inbox displays opinions of your fans or other creatives about you or your work. This helps you understand how other people are relating to your works or brand. ',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Padding(
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
                                              ? const SizedBox.shrink()
                                              : Provider.of<UserData>(context,
                                                              listen: false)
                                                          .user!
                                                          .score!
                                                          .isNegative ||
                                                      widget.user.score!
                                                          .isNegative
                                                  ? const SizedBox.shrink()
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
