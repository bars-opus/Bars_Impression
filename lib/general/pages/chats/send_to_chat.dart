import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

class SendToChats extends StatefulWidget {
  static final id = 'SendToChats';
  final String currentUserId;
  final String sendContentType;
  final String sendContentId;
  final String sendImageUrl;
  final String sendTitle;

  SendToChats({
    required this.currentUserId,
    required this.sendContentType,
    required this.sendContentId,
    required this.sendImageUrl,
    required this.sendTitle,
  });

  @override
  _SendToChatsState createState() => _SendToChatsState();
}

class _SendToChatsState extends State<SendToChats> {
  int limit = 10;
  String query = "";

  Map<String, bool> userSelection = {};
  List<AccountHolderAuthor> selectedUsersList = [];

  final TextEditingController _messageController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onAskTextChanged);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _isTypingNotifier.dispose();

    super.dispose();
  }

  void _onAskTextChanged() {
    if (_messageController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  void updateListState() {
    setState(() {});
  }

  _submitMessageFirstMessage() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    HapticFeedback.mediumImpact();

    var sendContent;
    sendContent = SendContentMessage(
      id: widget.sendContentId,
      title: widget.sendTitle,
      type: widget.sendContentType,
      imageUrl: widget.sendImageUrl,
    );

    ChatMessage message = ChatMessage(
        content: _messageController.text.trim().isEmpty
            ? ''
            : _messageController.text.trim(),
        id: '',
        receiverId: '',
        senderId: widget.currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
        isLiked: false,
        isRead: false,
        isSent: false,
        replyToMessage: null,
        sendContent: sendContent,
        attachments: []);
    await DatabaseService.shareBroadcastChatMessage(
      chatId: _provider.chatMessageId,
      message: message,
      currentUserId: widget.currentUserId,
      users: selectedUsersList,
    );

    mySnackBar(context, "${widget.sendTitle} sent successfully");

    Navigator.pop(context);

    _provider.setReplyChatMessage(null);
    selectedUsersList.clear();
    setState(() {});

    _provider.setMessageImage(null);
    _messageController.clear();
  }

  _chat() {
    final _provider = Provider.of<UserData>(context, listen: false);

    return StreamBuilder(
      stream: usersAuthorRef
          .doc(widget.currentUserId)
          .collection('new_chats')
          .orderBy('newMessageTimestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.length < 1) {
            return Expanded(
              child: Center(
                child: NoContents(
                  icon: (Icons.send_outlined),
                  title: 'No Chats.',
                  subTitle: 'Your chats and messages would appear here. ',
                ),
              ),
            );
          }
          return Expanded(
              child: Scrollbar(
                  child: CustomScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Chat chats = Chat.fromDoc(snapshot.data.docs[index]);

                      String userId = snapshot.data.docs[index].id;
                      var lastMessage =
                          snapshot.data.docs[index]['lastMessage'];
                      var seen = snapshot.data.docs[index]['seen'];
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        _provider.setChatMessageId((chats.messageId));
                      });
                      return GetAuthor(
                        chats: chats,
                        lastMessage: lastMessage,
                        seen: seen,
                        userId: userId,
                        selectedUsersList: selectedUsersList,
                        userSelection: userSelection,
                        updateParent: updateListState,
                      );
                    },
                    childCount: snapshot.data.docs.length,
                  ),
                )
              ])));
        }
        return Expanded(
          child: Center(
            child: Text(
              'Loading...',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
        );
      },
    );
  }

  _commentField() {
    return ValueListenableBuilder(
        valueListenable: _isTypingNotifier,
        builder: (BuildContext context, bool isTyping, Widget? child) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: TextField(
                controller: _messageController,
                keyboardAppearance: MediaQuery.of(context).platformBrightness,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: _messageController.text.length > 300 ? 10 : null,
                decoration: InputDecoration(
                  hintText: 'A caption for the content you are sending',
                  hintStyle: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                
                )),
          );
        });
  }


  _button() {
    final width = MediaQuery.of(context).size.width;
    return selectedUsersList.isEmpty
        ? SizedBox(
            height: 60,
          )
        : Container(
            width: width.toDouble(),
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 0.0,
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                onPressed: () {
                  _submitMessageFirstMessage();
                }),
          );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        elevation: 0,

        backgroundColor: Theme.of(context).primaryColorLight,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.sendTitle.toUpperCase(),
                style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Container(
              height: ResponsiveHelper.responsiveHeight(context, 40),
              width: ResponsiveHelper.responsiveHeight(context, 40),
              child: widget.sendImageUrl.isEmpty
                  ? null
                  : CachedNetworkImage(
                      imageUrl: widget.sendImageUrl,
                      height: 50.0,
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
            ),
          ],
        ),

      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              _commentField(),
              Center(
                child: _button(),
              ),
              const SizedBox(
                height: 10,
              ),
              _chat(),
            ],
          ),
        ),
      ),
    );
  }
}

class GetAuthor extends StatefulWidget {
  final Chat chats;
  final String userId;
  final bool seen;
  final String lastMessage;
  List<AccountHolderAuthor> selectedUsersList;
  Map<String, bool> userSelection;
  final Function updateParent;

  GetAuthor({
    super.key,
    required this.chats,
    required this.userId,
    required this.seen,
    required this.lastMessage,
    required this.selectedUsersList,
    required this.userSelection,
    required this.updateParent,
  });

  @override
  State<GetAuthor> createState() => _GetAuthorState();
}

class _GetAuthorState extends State<GetAuthor>
    with AutomaticKeepAliveClientMixin {
  AccountHolderAuthor? _author;

  @override
  void initState() {
    super.initState();
    _setUpProfileUser();
    widget.userSelection[widget.userId] = false;
  }

  Future<void> _setUpProfileUser() async {
    AccountHolderAuthor? profileUser =
        await DatabaseService.getUserWithId(widget.userId);
    if (mounted) {
      setState(() {
        _author = profileUser;
      });
    }
  }

  _loadingSkeleton() {
    return ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.blue,
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            const SizedBox(
              height: 2.0,
            ),
          ],
        ),
        onTap: () {});
  }

  _display() {
    return Container(
      color: widget.userSelection[_author!.userId]!
          ? Colors.blue.withOpacity(.1)
          : null,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
        child: CheckboxListTile(
          selectedTileColor:
              widget.userSelection[_author!.userId]! ? Colors.blue : null,
          title: Row(
            children: [
              _author!.profileImageUrl!.isEmpty
                  ? Icon(
                      Icons.account_circle,
                      size: 40.0,
                      color: Colors.grey,
                    )
                  : CircleAvatar(
                      radius: 18.0,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage:
                          CachedNetworkImageProvider(_author!.profileImageUrl!),
                    ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(children: [
                      TextSpan(
                        text: _author!.userName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: "\n${_author!.profileHandle}",
                        style: TextStyle(
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 12),
                          color: Colors.blue,
                        ),
                      )
                    ])),
              ),
            ],
          ),
          value: widget.userSelection[_author!.userId] ?? false,
          onChanged: (bool? value) {
            HapticFeedback.lightImpact();
            setState(() {
              widget.userSelection[_author!.userId!] = value!;
              if (value == true) {
                widget.selectedUsersList
                    .add(_author!); // add user to list if selected
              } else {
                widget.selectedUsersList
                    .remove(_author); // remove user from list if unselected
              }
              widget.updateParent(); // Call the callback function
            });
          },
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _author == null ? _loadingSkeleton() : _display();
  }
}
