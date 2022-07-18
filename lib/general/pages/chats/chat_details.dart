import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatDetails extends StatefulWidget {
  final AccountHolder user;
  final AccountHolder currentUser;
  final Chat chat;
  final String currentUserId;

  ChatDetails({
    required this.user,
    required this.chat,
    required this.currentUser,
    required this.currentUserId,
  });

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  bool _restrictChat = false;
  bool _isAFollower = false;
  bool _isBlockingUser = false;

  @override
  void initState() {
    super.initState();
    _restrictChat = widget.chat.restrictChat;
    _setupIsBlocking();
    _setupIsAFollowerUser();
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
              'Are you sure you want to block ${widget.user.userName}?',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text(
                  'Block',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);

                  _blockOrUnBlock();
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text(
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
              'Are you sure you want to block ${widget.user.userName}?',
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('Block'),
                onPressed: () {
                  Navigator.pop(context);
                  _blockOrUnBlock();
                },
              ),
              SimpleDialogOption(
                child: const Text('cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  _setupIsBlocking() async {
    bool isBlockingUser = await DatabaseService.isBlokingUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = isBlockingUser;
      });
    }
  }

  _blockOrUnBlock() {
    HapticFeedback.heavyImpact();
    if (_isBlockingUser) {
      _unBlockser();
    } else {
      _blockser();
    }
  }

  _unBlockser() {
    DatabaseService.unBlockUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = false;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        'unBlocked ',
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _blockser() async {
    AccountHolder fromUser =
        await DatabaseService.getUserWithId(widget.currentUserId);
    DatabaseService.blockUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
      user: fromUser,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = true;
      });
    }
    if (_isAFollower) {
      DatabaseService.unfollowUser(
        currentUserId: widget.currentUserId,
        userId: widget.user.id!,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color(0xFFD38B41),
      content: const Text(
        'Blocked ',
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _setupIsAFollowerUser() async {
    bool isAFollower = await DatabaseService.isAFollowerUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _isAFollower = isAFollower;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;

    return ResponsiveScaffold(
      child: Container(
        color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
                  SliverAppBar(
                    elevation: 0.0,
                    automaticallyImplyLeading: true,
                    floating: true,
                    snap: true,
                    iconTheme: new IconThemeData(
                      color:
                          ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    ),
                    backgroundColor: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Colors.white,
                    title: Text(
                      'Chat Info',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: null,
                                    currentUserId: widget.currentUserId,
                                    userId: widget.user.id!,
                                  ))),
                      child: Center(
                        child: Hero(
                          tag: widget.user.id!,
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Color(0xFF1a1a1a),
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: widget.user.profileImageUrl!.isEmpty
                                        ? AssetImage(
                                            ConfigBloc().darkModeOn
                                                ? 'assets/images/user_placeholder.png'
                                                : 'assets/images/user_placeholder2.png',
                                          ) as ImageProvider
                                        : CachedNetworkImageProvider(
                                            widget.user.profileImageUrl!),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Text(
                              widget.user.userName!,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          widget.user.verified!.isEmpty
                              ? SizedBox.shrink()
                              : Positioned(
                                  top: 5,
                                  right: 0,
                                  child: Icon(
                                    MdiIcons.checkboxMarkedCircle,
                                    size: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: null,
                                    currentUserId: widget.currentUserId,
                                    userId: widget.user.id!,
                                  ))),
                      child: Center(
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${widget.user.profileHandle!}\n',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: widget.user.company,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    widget.user.enableBookingOnChat!
                        ? const SizedBox(
                            height: 30,
                          )
                        : const SizedBox.shrink(),
                    !widget.user.enableBookingOnChat!
                        ? Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.teal,
                                  onPrimary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => UserBooking(
                                              user: widget.user,
                                              currentUserId:
                                                  widget.currentUserId,
                                              userIsCall: 1,
                                            ))),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Booking Contact',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 30,
                    ),
                    Divider(color: Colors.teal),
                    SettingSwitch(
                      color: Colors.teal,
                      title: 'Restrict messages',
                      subTitle:
                          'Restrict messaging between you and ${widget.user.userName}.',
                      value: _restrictChat,
                      onChanged: (value) => setState(
                        () {
                          _restrictChat = this._restrictChat = value;
                          usersRef
                              .doc(widget.currentUserId)
                              .collection('chats')
                              .doc(widget.user.id)
                              .update({
                            'restrictChat': _restrictChat,
                          });
                          usersRef
                              .doc(widget.user.id)
                              .collection('chats')
                              .doc(widget.currentUserId)
                              .update({
                            'restrictChat': _restrictChat,
                          });
                        },
                      ),
                    ),
                    Divider(color: Colors.teal),
                    GestureDetector(
                      onTap: () => _showSelectImageDialog(),
                      child: IntroInfo(
                        title: _isBlockingUser
                            ? 'unBlock ${widget.user.userName}'
                            : 'Block ${widget.user.userName}',
                        onPressed: () => _showSelectImageDialog(),
                        subTitle: _isBlockingUser
                            ? "${widget.user.userName} would see and react to any of your content."
                            : "Stop ${widget.user.userName} from seeing and reacting to any of your content.",
                        icon: Icon(
                          Icons.block,
                          color: _isBlockingUser ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    Divider(color: Colors.teal),
                    const SizedBox(height: 30),
                    _display(
                      currentUserId: widget.currentUserId,
                      chat: widget.chat,
                      user: widget.user,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

//display
class _display extends StatelessWidget {
  final AccountHolder user;
  final Chat chat;
  final String currentUserId;

  _display(
      {required this.user, required this.currentUserId, required this.chat});
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Table(
            border: TableBorder.all(
              color: Colors.teal,
              width: 0.5,
            ),
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'Chat initiator',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    chat.messageInitiator,
                    style: TextStyle(
                      color:
                          ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'First message',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    chat.firstMessage,
                    style: TextStyle(
                      color:
                          ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'First message date',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: MyDateFormat.toDate(chat.timestamp.toDate()),
                            style: TextStyle(
                              fontSize: 12,
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        TextSpan(
                            text: '\n' +
                                timeago.format(
                                  chat.timestamp.toDate(),
                                ),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'Last message',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    chat.lastMessage,
                    style: TextStyle(
                      color:
                          ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'Last message date',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: MyDateFormat.toDate(
                              chat.newMessageTimestamp.toDate(),
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        TextSpan(
                            text: '\n' +
                                timeago.format(
                                  chat.newMessageTimestamp.toDate(),
                                ),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'Number of messages',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    NumberFormat.compact().format(
                        Provider.of<UserData>(context, listen: false)
                            .messageCount),
                    style: TextStyle(
                      color:
                          ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 30),
          Divider(color: Colors.teal),
        ]);
  }
}
