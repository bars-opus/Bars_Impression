import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class SendToChats extends StatefulWidget {
  static final id = 'SendToChats';
  final String currentUserId;
  final String sendContentType;
  final String sendContentId;
  final String? userId;
  final Post? post;
  final Event? event;
  final Forum? forum;
  final AccountHolder? user;

  // final int activityChatCount;

  SendToChats({
    required this.currentUserId,
    required this.userId,
    required this.sendContentType,
    required this.post,
    required this.event,
    required this.forum,
    required this.user,
    required this.sendContentId,
    // required this.activityChatCount,
  });

  @override
  _SendToChatsState createState() => _SendToChatsState();
}

class _SendToChatsState extends State<SendToChats> {
  int limit = 10;
  // bool _showInfo = true;
  String query = "";

  @override
  void initState() {
    super.initState();
    // __setShowInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return ResponsiveScaffold(
        child: ResponsiveScaffold(
            child: Scaffold(
                backgroundColor:
                    ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  ),
                  automaticallyImplyLeading: true,
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Colors.white,
                  title: Text(
                    'Send',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                body: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SafeArea(
                      child: Column(
                    children: [
                      widget.sendContentType.startsWith('Mood Punched')
                          ? Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: ConfigBloc().darkModeOn
                                    ? Color(0xFF1a1a1a)
                                    : Color(0xFFeff0f2),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      widget.post!.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    colors: [
                                      Colors.black.withOpacity(.6),
                                      Colors.black.withOpacity(.6),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Hero(
                                      tag: widget.sendContentType
                                              .startsWith('Mood Punched')
                                          ? 'punch' + widget.post!.id.toString()
                                          : '',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          widget.post!.punch,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          maxLines: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          : widget.sendContentType.startsWith('Forum')
                              ? Hero(
                                  tag: 'title' + widget.forum!.id.toString(),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: RichText(
                                        textScaleFactor: MediaQuery.of(context)
                                            .textScaleFactor,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: widget.forum!.title,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "\n${widget.forum!.subTitle}",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey,
                                            ),
                                          )
                                        ])),
                                  ),
                                )
                              : widget.sendContentType.startsWith('Event')
                                  ? ListTile(
                                      trailing: Hero(
                                        tag:
                                            'image ${widget.event!.id.toString()}',
                                        child: CachedNetworkImage(
                                          imageUrl: widget.event!.imageUrl,
                                          height: 50.0,
                                          width: 50.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: RichText(
                                        textScaleFactor: MediaQuery.of(context)
                                            .textScaleFactor,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: widget.event!.title
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    '\n ${widget.event!.theme}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                )),
                                          ],
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {},
                                    )
                                  : widget.sendContentType.startsWith('User')
                                      ? ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                ConfigBloc().darkModeOn
                                                    ? Color(0xFF1a1a1a)
                                                    : Color(0xFFf2f2f2),
                                            radius: 25.0,
                                            backgroundImage: widget.user!
                                                    .profileImageUrl!.isEmpty
                                                ? AssetImage(
                                                    ConfigBloc().darkModeOn
                                                        ? 'assets/images/user_placeholder.png'
                                                        : 'assets/images/user_placeholder2.png',
                                                  ) as ImageProvider
                                                : CachedNetworkImageProvider(
                                                    widget.user!
                                                        .profileImageUrl!),
                                          ),
                                          title: Align(
                                            alignment: Alignment.topLeft,
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12.0),
                                                  child: Text(
                                                      widget.user!.userName!,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.white
                                                            : Colors.black,
                                                      )),
                                                ),
                                                widget.user!.verified!.isEmpty
                                                    ? SizedBox.shrink()
                                                    : Positioned(
                                                        top: 3,
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
                                          ),
                                          subtitle: RichText(
                                            textScaleFactor:
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: widget
                                                        .user!.profileHandle,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.blue,
                                                    )),
                                                TextSpan(
                                                    text:
                                                        '\n${widget.user!.bio}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    )),
                                              ],
                                            ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          onTap: () {},
                                        )
                                      : const SizedBox.shrink(),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Container(
                          // ignore: unnecessary_null_comparison
                          child: StreamBuilder(
                              stream: usersRef
                                  .doc(widget.currentUserId)
                                  .collection('chats')
                                  .orderBy('newMessageTimestamp',
                                      descending: true)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.docs.length < 1) {
                                    return Expanded(
                                      child: Center(
                                        child: NoContents(
                                          icon: (Icons.send),
                                          title: 'No Chats.',
                                          subTitle:
                                              'Your chats will appear here.\nYou can send contents to people you are already chatting with.',
                                        ),
                                      ),
                                    );
                                  }
                                  return Expanded(
                                      child: Scrollbar(
                                          child: CustomScrollView(slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          Chat chats = Chat.fromDoc(
                                              snapshot.data.docs[index]);

                                          String userId =
                                              snapshot.data.docs[index].id;
                                          var lastMessage = snapshot
                                              .data.docs[index]['lastMessage'];
                                          var seen =
                                              snapshot.data.docs[index]['seen'];

                                          return FutureBuilder(
                                              future:
                                                  DatabaseService.getUserWithId(
                                                      userId),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                                AccountHolder author =
                                                    snapshot.data;

                                                return _display(
                                                  author: author,
                                                  chats: chats,
                                                  lastMessage: lastMessage,
                                                  seen: seen,
                                                  userId: userId,
                                                  sendContentType:
                                                      widget.sendContentType,
                                                  sendContentId:
                                                      widget.sendContentId,
                                                  mediaUrl: widget
                                                          .sendContentType
                                                          .startsWith(
                                                              'Mood Punched')
                                                      ? widget.post!.imageUrl
                                                      : widget.sendContentType
                                                              .startsWith(
                                                                  'Event')
                                                          ? widget
                                                              .event!.imageUrl
                                                          : widget.sendContentType
                                                                  .startsWith(
                                                                      'User')
                                                              ? widget.user!
                                                                  .profileImageUrl!
                                                              : '',
                                                  title: widget.sendContentType
                                                          .startsWith(
                                                              'Mood Punched')
                                                      ? widget.post!.punch
                                                      : widget.sendContentType
                                                              .startsWith(
                                                                  'Event')
                                                          ? widget.event!.title
                                                          : widget.sendContentType
                                                                  .startsWith(
                                                                      'Forum')
                                                              ? widget.forum!
                                                                      .title +
                                                                  '\n${widget.forum!.subTitle}'
                                                              : widget.sendContentType
                                                                      .startsWith(
                                                                          'User')
                                                                  ? '${widget.user!.userName}\n${widget.user!.profileHandle}\n${widget.user!.company}'
                                                                  : '',
                                                );
                                              });
                                        },
                                        childCount: snapshot.data.docs.length,
                                      ),
                                    )
                                  ])));
                                }
                                return Expanded(
                                  child: Center(
                                      child: Text(
                                    'Loading....',
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                );
                              })),
                    ],
                  )),
                ))));
  }
}

//display
// ignore: must_be_immutable
class _display extends StatefulWidget {
  final AccountHolder author;
  final Chat chats;
  String lastMessage;
  String seen;
  final String userId;
  final String mediaUrl;
  final String title;
  final String sendContentType;
  final String sendContentId;

  _display({
    required this.author,
    required this.chats,
    required this.lastMessage,
    required this.seen,
    required this.userId,
    required this.sendContentType,
    required this.sendContentId,
    required this.mediaUrl,
    required this.title,
  });

  @override
  State<_display> createState() => _displayState();
}

class _displayState extends State<_display> {
  int _chatMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _setUpMessageCount();
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
              'Are you sure you want to send this ${widget.sendContentType} to ${widget.author.userName}?',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _sendContent();
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
              'Are you sure you want to send this ${widget.sendContentType} to ${widget.author.userName}?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Send',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _sendContent();
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

  _sendContent() {
    _chatMessageCount < 1
        ? _submitFirstContentMessage()
        : _submitContentMessageMore();
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
        "Sent succesfully.",
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
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  _setUpMessageCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numChatsMessages(
      currentUserId,
      widget.author.id!,
    ).listen((chatMessageCount) {
      if (mounted) {
        setState(() {
          _chatMessageCount = chatMessageCount;
        });
      }
    });
  }

  _submitFirstContentMessage() async {
    final AccountHolder currentUser =
        Provider.of<UserData>(context, listen: false).user!;
    HapticFeedback.mediumImpact();

    DatabaseService.firstChatMessage(
      currentUserId:
          Provider.of<UserData>(context, listen: false).currentUserId!,
      userId: widget.author.id!,
      messageInitiator: currentUser.userName!,
      restrictChat: false,
      mediaUrl: widget.mediaUrl,
      mediaType: '',
      replyingAuthor: '',
      replyingMessage: '',
      reportConfirmed: '',
      liked: '',
      message: "Transported\n${widget.sendContentType}",
      sendPostType: widget.sendContentType,
      sendContentId: widget.sendContentId,
      sendContentTitle: widget.title,
    );

    Provider.of<UserData>(context, listen: false).setPost9('');
    Provider.of<UserData>(context, listen: false).setPost8('');
    Provider.of<UserData>(context, listen: false).setPost7('');
    Provider.of<UserData>(context, listen: false).setPost12('');
  }

  _submitContentMessageMore() async {
    HapticFeedback.mediumImpact();

    DatabaseService.chatMessage(
      currentUserId:
          Provider.of<UserData>(context, listen: false).currentUserId!,
      userId: widget.author.id!,
      mediaUrl: widget.mediaUrl,
      mediaType: '',
      replyingAuthor: '',
      replyingMessage: Provider.of<UserData>(context, listen: false).post8,
      reportConfirmed: '',
      liked: '',
      message: "Transported\n${widget.sendContentType}",
      sendPostType: widget.sendContentType,
      sendContentId: widget.sendContentId,
      sendContentTitle: widget.title,
    );

    Provider.of<UserData>(context, listen: false).setPost9('');

    Provider.of<UserData>(context, listen: false).setPost8('');
    Provider.of<UserData>(context, listen: false).setPost7('');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: FocusedMenuHolder(
        menuWidth: width,
        menuOffset: 1,
        blurBackgroundColor:
            ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white10,
        openWithTap: false,
        onPressed: () {},
        menuItems: [
          FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Report chat',
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ReportContentPage(
                          contentId: widget.userId,
                          contentType: widget.author.userName!,
                          parentContentId: widget.userId,
                          repotedAuthorId: currentUserId,
                        ))),
          ),
        ],
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaleFactor:
                  MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
          child: Container(
            decoration: ConfigBloc().darkModeOn
                ? BoxDecoration(
                    color: widget.seen == 'seen'
                        ? Colors.transparent
                        : Color(0xFF1f2022),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                        BoxShadow(
                          color: widget.seen == 'seen'
                              ? Colors.transparent
                              : Colors.black45,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ),
                        BoxShadow(
                          color: widget.seen == 'seen'
                              ? Colors.transparent
                              : Colors.black45,
                          offset: Offset(-4.0, -4.0),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        )
                      ])
                : BoxDecoration(
                    color: widget.seen == 'seen'
                        ? Colors.transparent
                        : Colors.teal[50],
                  ),
            child: Column(
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
                        tag: widget.userId,
                        child: Material(
                          color: Colors.transparent,
                          child: CircleAvatar(
                            radius: 20.0,
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
                        ),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.seen == 'seen'
                                ? Colors.transparent
                                : Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                      ],
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Text(
                                widget.author.userName!,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
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
                        const SizedBox(
                          height: 2.0,
                        ),
                        Wrap(
                          children: [
                            widget.chats.mediaType.isEmpty
                                ? SizedBox.shrink()
                                : Icon(
                                    MdiIcons.image,
                                    size: 20,
                                    color: widget.seen == 'seen'
                                        ? Colors.grey
                                        : Colors.blue,
                                  ),
                            Text(
                              widget.lastMessage,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: widget.seen == 'seen'
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: widget.seen == 'seen'
                                    ? Colors.grey
                                    : Colors.teal[800],
                                overflow: TextOverflow.ellipsis,
                                decoration: widget.chats.restrictChat
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      _showSelectImageDialog();
                    }),
                ConfigBloc().darkModeOn
                    ? Divider(
                        color: Colors.grey[850],
                      )
                    : Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
