import 'package:bars/utilities/exports.dart';

import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

class BottomModalSheetMessage extends StatefulWidget {
  final UserStoreModel? userPortfolio;
  final AccountHolderAuthor? user;
  final AccountHolderAuthor? userAuthor;
  final String userId;
  final bool showAppbar;
  final Chat? chatLoaded;
  final String currentUserId;
  final bool? isBlocked;
  final bool? isBlocking;

  BottomModalSheetMessage({
    required this.user,
    required this.userPortfolio,
    required this.userAuthor,
    required this.currentUserId,
    required this.userId,
    required this.chatLoaded,
    this.isBlocked,
    this.isBlocking,
    required this.showAppbar,
  });
  @override
  State<BottomModalSheetMessage> createState() =>
      _BottomModalSheetMessageState();
}

class _BottomModalSheetMessageState extends State<BottomModalSheetMessage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  late final ValueNotifier<bool> _isTypingNotifier;
  final FocusNode _focusNode = FocusNode();
  bool _isBlockedUser = false;
  bool _isBlockingUser = false;
  bool _disableChat = false;
  late var _user;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _user = widget.user ?? widget.userAuthor ?? widget.userPortfolio;
    _isBlockedUser = widget.isBlocked ?? false;
    _isBlockingUser = widget.isBlocking ?? false;
    widget.isBlocked ?? _setupIsBlocked();
    widget.isBlocking ?? _setupIsBlocking();
    widget.userPortfolio == null ? _setDisabled() : _setFetchedDisabled();
    _isTypingNotifier =
        ValueNotifier<bool>(_messageController.text.trim().isNotEmpty);
    _messageController.addListener(_onAskTextChanged);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final _provider = Provider.of<UserData>(context, listen: false);
      _provider.setReplyChatMessage(null);
      _provider.setMessageImage(null);
      _provider.setChatMessageId('');
      _provider.setMessageCount(0);
    });
    widget.chatLoaded == null ? () {} : _updateChatSeen();
    _timer = Timer.periodic(
        Duration(hours: 24), (_) => expireOldMessages(Duration(days: 30)));
  }

  _setDisabled() {
    _disableChat = widget.user != null
        ? widget.user!.disableChat!
        : widget.userAuthor != null
            ? widget.userAuthor!.disableChat!
            : false;
  }

  _setFetchedDisabled() async {
    AccountHolderAuthor? newuser =
        await DatabaseService.getUserWithId(widget.userId);

    setState(() {
      _disableChat = newuser!.disableChat!;
    });
  }

  void _updateChatSeen() {
    // Assuming usersRef is a global variable of type CollectionReference
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(
      usersAuthorRef
          .doc(widget.currentUserId)
          .collection('new_chats')
          .doc(widget.userId),
      {'seen': true},
    );
    batch.commit();
  }

  Future<void> _setupIsBlocking() async {
    try {
      bool isBlockingUser = await DatabaseService.isBlokingUser(
        currentUserId: widget.currentUserId,
        userId: widget.userId,
      );
      if (mounted) {
        setState(() {
          _isBlockingUser = isBlockingUser;
        });
      }
    } catch (e) {}
  }

  Future<void> _setupIsBlocked() async {
    try {
      bool isBlockedUser = await DatabaseService.isBlockedUser(
        currentUserId: widget.currentUserId,
        userId: widget.userId,
      );
      if (mounted) {
        setState(() {
          _isBlockedUser = isBlockedUser;
        });
      }
    } catch (e) {}
  }

  void _onAskTextChanged() {
    _isTypingNotifier.value = _messageController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _isTypingNotifier.dispose();
    _timer?.cancel();
    super.dispose();
  }

  _handleImage({required bool fromCamera}) async {
    final file = fromCamera
        ? await PickCropCamera.pickedMedia(cropImage: _cropImage)
        : await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file != null && mounted) {
      Provider.of<UserData>(context, listen: false)
          .setMessageImage(file as File?);
      _focusNode.requestFocus();
    }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
    );
    return croppedImage!;
  }

  void _showBottomSheetErrorMessage(Object e) {
    String error = e.toString();
    String result = error.contains(']')
        ? error.substring(error.lastIndexOf(']') + 1)
        : error;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: 'Coulnd\'nt send message. ',
          subTitle: result,
        );
      },
    );
  }

  _submitMessageFirstMessage() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    HapticFeedback.mediumImpact();
    var replyMessage;
    if (_provider.replyChatMessage != null) {
      replyMessage = ReplyToMessage(
        id: _provider.replyChatMessage!.id,
        imageUrl: _provider.replyChatMessage!.attachments.isEmpty
            ? ''
            : _provider.replyChatMessage!.attachments[0].mediaUrl,
        message: _provider.replyChatMessage!.content,
        athorId: _provider.replyChatMessage!.senderId,
      );
    }
    String? imageUrl;
    if (_provider.messageImage != null) {
      _provider.setIsSendigChat(true);
      try {
        imageUrl =
            await StorageService.uploadMessageImage(_provider.messageImage!);
      } catch (e) {}
    }
    List<MessageAttachment> attachement = [];
    String commonId = Uuid().v4();
    if (_provider.messageImage != null) {
      attachement.add(MessageAttachment(
        id: commonId,
        mediaUrl: imageUrl!,
        type: 'image',
      ));
    }

    var sendContent;
    ChatMessage message = ChatMessage(
        content: _messageController.text.trim().isEmpty
            ? ''
            : _messageController.text.trim(),
        id: '',
        receiverId: widget.userId,
        senderId: widget.currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
        isLiked: false,
        isRead: false,
        isSent: false,
        replyToMessage: replyMessage,
        sendContent: sendContent,
        attachments: attachement);
    try {
      String messageId = Uuid().v4();
      DatabaseService.firstChatMessage(
        chatId: _provider.chatMessageId,
        message: message,
        currentUserId: widget.currentUserId,
        messageId: messageId,
        isAuthor: widget.currentUserId == message.senderId,
      );
      _provider.setChatMessageId(messageId);
    } catch (e) {}

    limitMessagesPerConversation(_provider.chatMessageId);
    _provider.setReplyChatMessage(null);
    _provider.setMessageImage(null);
    _messageController.clear();
    _provider.setIsSendigChat(false);
  }

  _commentField() {
    final _provider = Provider.of<UserData>(
      context,
    );
    return ValueListenableBuilder(
        valueListenable: _isTypingNotifier,
        builder: (BuildContext context, bool isTyping, Widget? child) {
          return Column(
            children: [
              replyMessageHeader(),
              _displayImage(),
              _commentFiledWidget(
                _messageController,
                _provider.isSendigChat
                    ? () {}
                    : () {
                        HapticFeedback.mediumImpact();
                        final trimmedText = _messageController.text.trim();
                        if (trimmedText.isNotEmpty ||
                            _provider.messageImage != null) {
                          try {
                            _submitMessageFirstMessage();
                          } catch (e) {
                            _showBottomSheetErrorMessage(e);
                          }
                        }
                      },
                _provider.replyChatMessage == null
                    ? 'type a message...'
                    : 'reply to ${_provider.replyChatMessage!.content}',
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
        });
  }

  void _markAllMessagesAsRead(String chatId) async {
    // Get a reference to the Firestore messages collection
    final messageRef = FirebaseFirestore.instance.collection('messages');
    // Query for all messages where isRead is false and receiverId is widget.userId
    final querySnap = await messageRef
        .doc(chatId)
        .collection('conversation')
        .where('isRead', isEqualTo: false)
        .where('receiverId', isEqualTo: widget.currentUserId)
        .get();
    // Get the documents from the query snapshot
    final docs = querySnap.docs;
    // For each document, update isRead to true
    for (final doc in docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  _noMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () async {
            if (!await launchUrl(
                Uri.parse('https://www.barsopus.com/terms-of-use'))) {
              throw 'Could not launch link';
            }
          },
          child: RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(
              children: [
                TextSpan(
                    text: "What's\nUp",
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 40),
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                    text: "?\n",
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 40),
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                    text:
                        "\nBefore starting a chat, please ensure that your communication adheres to ",
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.normal,
                    )),
                TextSpan(
                    text: "our community guidelines. ",
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                    )),
                TextSpan(
                    text:
                        "These guidelines promote respect, prohibit abuse, racism, and discrimination. Let's create a positive and inclusive environment for everyone.",
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.normal,
                    )),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  _displayImage() {
    final width = MediaQuery.of(context).size.width;
    final _provider = Provider.of<UserData>(context, listen: false);
    FileImage? image;
    if (_provider.messageImage != null) {
      image = FileImage(File(_provider.messageImage!.path));
    }
    return ReplyMessageAndActivityCountWidget(
      color: Colors.blue,
      height: _provider.messageImage == null ? 0.0 : 80,
      width: width,
      widget: ListTile(
          title: Text(
            'Ready to send',
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                fontWeight: FontWeight.bold),
          ),
          trailing: _provider.isSendigChat
              ? SizedBox(
                  height: ResponsiveHelper.responsiveHeight(context, 10.0),
                  width: ResponsiveHelper.responsiveHeight(context, 10.0),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    strokeWidth:
                        ResponsiveHelper.responsiveFontSize(context, 2.0),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _provider.setMessageImage(null);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
          leading: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Container(
                width: 70,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: image != null
                        ? DecorationImage(
                            image: image,
                            fit: BoxFit.cover,
                          )
                        : null)),
          )),
    );
  }

// This function shows a modal bottom sheet for selecting an image either from the camera or gallery.
  _showBottomPickImage() {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
              height: 230,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
                  child: MyBottomModelSheetAction(actions: [
                    const SizedBox(
                      height: 40,
                    ),
                    BottomModelSheetListTileActionWidget(
                      colorCode: '',
                      icon: Icons.camera_alt_rounded,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        try {
                          _handleImage(fromCamera: true);
                        } catch (e) {
                          _showBottomSheetErrorMessage(e);
                        }
                      },
                      text: 'Camera',
                    ),
                    BottomModelSheetListTileActionWidget(
                      colorCode: '',
                      icon: MdiIcons.image,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        try {
                          _handleImage(fromCamera: false);
                        } catch (e) {
                          _showBottomSheetErrorMessage(e);
                        }
                      },
                      text: 'Gallery',
                    ),
                  ])));
        },
      );
    } catch (e) {
      _showBottomSheetErrorMessage(e);
    }
  }

  // This function shows a bottom sheet with chat details.
  _showBottomSheetChatDetails(BuildContext context) {
    if (widget.chatLoaded == null) return;
    bool _restrictChat = widget.chatLoaded!.restrictChat;

    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: ResponsiveHelper.responsiveHeight(context, 670),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30)),
                child: ChatDetails(
                  chat: widget.chatLoaded!,
                  currentUserId: widget.currentUserId,
                  user: _user,
                  isBlockingUser: _isBlockingUser,
                  restrictFunction: (value) {
                    setState(() {
                      _restrictChat = value;
                    });

                    usersAuthorRef
                        .doc(widget.currentUserId)
                        .collection('new_chats')
                        .doc(_user!.userId)
                        .update({
                      'restrictChat': value,
                    });

                    usersAuthorRef
                        .doc(_user!.userId)
                        .collection('new_chats')
                        .doc(widget.currentUserId)
                        .update({
                      'restrictChat': value,
                    });
                  },
                  restrict: _restrictChat,
                ));
          });
        },
      );
    } catch (e) {
      _showBottomSheetErrorMessage(e);
    }
  }

// This function returns a ListTile widget that displays user details.
  _userHeaderWidget() {
    return ListTile(
      onTap: widget.chatLoaded == null
          ? null
          : () {
              _showBottomSheetChatDetails(context);
            },
      leading: Hero(
        tag: widget.userId,
        child: _user.profileImageUrl!.isEmpty
            ? Icon(
                Icons.account_circle,
                color: Theme.of(context).secondaryHeaderColor,
                size: ResponsiveHelper.responsiveHeight(context, 40),
              )
            : CircleAvatar(
                radius: 20.0,
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage: _user.profileImageUrl == null
                    ? null
                    : CachedNetworkImageProvider(_user.profileImageUrl!),
              ),
      ),
      title: NameText(
        name:
            _user.userName == null ? 'No name' : _user.userName!.toUpperCase(),
        verified: _user!.verified! ? true : false,
      ),
      subtitle: Text(
        _user.storeType,
        style: TextStyle(
          color: Colors.blue,
          fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  _commentFiledWidget(
    final TextEditingController controller,
    final VoidCallback onSend,
    final String hintText,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);

    bool readyToSend =
        _provider.messageImage != null || controller.text.trim().length > 0
            ? true
            : false;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Theme.of(context).primaryColorLight,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: ListTile(
          leading: controller.text.trim().length > 0
              ? null
              : GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showBottomPickImage();
                  },
                  child: Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
          title: TextField(
            autofocus: true,
            focusNode: _focusNode,
            controller: controller,
            cursorColor: Colors.blue,
            keyboardAppearance: MediaQuery.of(context).platformBrightness,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: controller.text.trim().length > 300 ? 10 : null,
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              hintStyle: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
            onSubmitted: (string) {
              onSend();
            },
          ),
          trailing: _provider.isSendigChat
              ? null
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: CircularButton(
                      color: readyToSend ? Colors.blue : Colors.transparent,
                      icon:  Icons.send,
                      onPressed: onSend),
                ),
        ),
      ),
    );
  }

  replyMessageHeader() {
    final width = MediaQuery.of(context).size.width;
    final _provider = Provider.of<UserData>(
      context,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ReplyMessageAndActivityCountWidget(
        color: Colors.blue,
        height: _provider.replyChatMessage == null ? 0.0 : 80,
        width: width,
        widget: ListTile(
          leading: _provider.replyChatMessage == null
              ? null
              : _provider.replyChatMessage!.attachments.isEmpty
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Container(
                          width: 70,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(_provider
                                    .replyChatMessage!.attachments[0].mediaUrl),
                                fit: BoxFit.cover,
                              ))),
                    ),
          trailing: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _provider.setReplyChatMessage(null);
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
              )),
          title: _provider.replyChatMessage == null
              ? SizedBox()
              : RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: widget.currentUserId !=
                                  _provider.replyChatMessage!.senderId
                              ? 'Replying to ${_user.userName}:\n'
                              : 'Replying to yourself:\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12),
                          )),
                      TextSpan(
                        text: _provider.replyChatMessage!.content,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 14),
                        ),
                      )
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
        ),
      ),
    );
  }

  Future<void> limitMessagesPerConversation(
    String chatMessageId,
  ) async {
    var box = await Hive.openBox<ChatMessage>('chatMessages');
    var messages =
        box.values.where((message) => message.id == chatMessageId).toList();
    if (messages.length > 25) {
      messages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
      for (var i = 0; i < messages.length - 25; i++) {
        box.delete(messages[i].id);
      }
    }
  }

  void expireOldMessages(Duration ageLimit) async {
    var box = await Hive.openBox<ChatMessage>('chatMessages');
    var now = DateTime.now();
    for (var message in box.values) {
      if (now.difference(message.timestamp!.toDate()) > ageLimit) {
        box.delete(message.id);
      }
    }
  }

  Future<Box<ChatMessage>> getChatMessagesBox() async {
    try {
      return await Hive.openBox<ChatMessage>('chatMessages');
    } catch (e) {
      // print('Error opening the box: $e');
      // handle error, perhaps show a UI message
      throw e;
    }
  }

  _loading() {
    return Expanded(
        child: Center(
      child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            color: Colors.blue,
          )),
    ));
  }

  Widget _getMessages(Chat chat) {
    final chatMessagesBox = Hive.box<ChatMessage>('chatMessages');
    _markAllMessagesAsRead(chat.messageId);
    final _provider = Provider.of<UserData>(context, listen: false);
    return FutureBuilder<Box<ChatMessage>>(
      future: getChatMessagesBox(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _loading();
        } else if (snapshot.hasError) {
          return Text('Error opening the box: ${snapshot.error}');
        } else {
          final box = snapshot.data!;
          return StreamBuilder<QuerySnapshot>(
            stream: messageRef
                .doc(chat.messageId)
                .collection('conversation')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _provider.setChatMessageId((chat.messageId.isEmpty
                    ? widget.chatLoaded!.messageId
                    : chat.messageId));
              });
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return _loading();
              } else {
                _updateChatSeen();
                List<ChatMessage> newMessages = snapshot.data!.docs.map((doc) {
                  return ChatMessage.fromDoc(doc);
                }).toList();
                // Save new messages to Hive
                for (ChatMessage newMessage in newMessages) {
                  box.put(newMessage.id, newMessage);
                }
                // Fetch messages from Hive directly
                List<ChatMessage> retrievedMessages = [];
                for (ChatMessage newMessage in newMessages) {
                  ChatMessage? messageFromBox = box.get(newMessage.id);
                  if (messageFromBox != null) {
                    retrievedMessages.add(messageFromBox);
                  }
                }

                List<ChatMessage> retrievedChats =
                    chatMessagesBox.values.toList();
// Sort the chats by newMessageTimestamp descending
                retrievedChats.sort((ChatMessage a, ChatMessage b) {
                  // Handle potential null values by treating them as dates far in the past
                  var aTimestamp = a.timestamp?.toDate() ?? DateTime(1970);
                  var bTimestamp = b.timestamp?.toDate() ?? DateTime(1970);
                  return bTimestamp.compareTo(aTimestamp);
                });

                // Use retrievedMessages directly in your FutureBuilder
                return FutureBuilder<List<ChatMessage>>(
                  future: Future.value(retrievedMessages),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ChatMessage>> boxSnapshot) {
                    if (!boxSnapshot.hasData || boxSnapshot.data!.isEmpty) {
                      // The Hive box is empty, show an error or placeholder
                      return Expanded(child: _noMessage());
                    } else {
                      // The Hive box has messages, use them
                      return _buildMessageList(
                          chat.messageId, chat, boxSnapshot.data!);
                    }
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _buildMessageList(
      String chatId, Chat? chat, List<ChatMessage> messages) {
    final _provider = Provider.of<UserData>(context, listen: false);

    return Expanded(
      child: Scrollbar(
        child: ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            return SlidableMessage(
              key: ValueKey(messages[index].id),
              currentUserId: widget.currentUserId,
              onReply: (message) {
                _focusNode.requestFocus();
                _provider.setReplyChatMessage(message);
              },
              chatId: chatId,
              message: messages[index],
              user: _user,
              isBlockingUser: _isBlockingUser,
              chat: chat,
              userId: widget.userId,
            );
          },
        ),
      ),
    );
  }

  _future() {
    final chatMessageId =
        Provider.of<UserData>(context, listen: false).chatMessageId;
    return chatMessageId.isEmpty
        ? Expanded(child: _noMessage())
        : FutureBuilder<Box<ChatMessage>>(
            future: getChatMessagesBox(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _loading();
              } else if (snapshot.hasError) {
                return Text('Error opening the box: ${snapshot.error}');
              } else {
                final box = snapshot.data!;

                return StreamBuilder<QuerySnapshot>(
                  stream: messageRef
                      .doc(chatMessageId)
                      .collection('conversation')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return _loading();
                    } else {
                      List<ChatMessage> newMessages =
                          snapshot.data!.docs.map((doc) {
                        return ChatMessage.fromDoc(doc);
                      }).toList();

                      // Save new messages to Hive
                      for (ChatMessage newMessage in newMessages) {
                        box.put(newMessage.id, newMessage);
                      }

                      // Fetch messages from Hive directly
                      List<ChatMessage> retrievedMessages = [];
                      for (ChatMessage newMessage in newMessages) {
                        ChatMessage? messageFromBox = box.get(newMessage.id);
                        if (messageFromBox != null) {
                          retrievedMessages.add(messageFromBox);
                        }
                      }

                      // Use retrievedMessages directly in your FutureBuilder
                      return FutureBuilder<List<ChatMessage>>(
                        future: Future.value(retrievedMessages),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ChatMessage>> boxSnapshot) {
                          if (!boxSnapshot.hasData ||
                              boxSnapshot.data!.isEmpty) {
                            // The Hive box is empty, show an error or placeholder
                            return SizedBox.shrink();
                          } else {
                            // The Hive box has messages, use them
                            return _buildMessageList(
                                chatMessageId, null, boxSnapshot.data!);
                          }
                        },
                      );
                    }
                  },
                );
              }
            },
          );
  }

// The build function is the main rendering function.
//  It sets up a Scaffold with an AppBar (if widget.userAuthor is not null),
//   a list of messages, and a comment field.

  @override
  Widget build(BuildContext context) {
    bool _restricitedChat =
        widget.chatLoaded == null ? false : widget.chatLoaded!.restrictChat;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: !widget.showAppbar
            ? null
            : AppBar(
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                backgroundColor: Theme.of(context).cardColor,
                automaticallyImplyLeading: true,
                title: _userHeaderWidget(),
              ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!widget.showAppbar)
                TicketPurchasingIcon(
                  title: '',
                ),
              widget.chatLoaded == null
                  ? _future()
                  : _getMessages(widget.chatLoaded!),
              if (!_isBlockingUser && !_isBlockedUser)
                if (!_restricitedChat)
                  if (!_disableChat) _commentField()
            ],
          ),
        ),
      ),
    );
  }
}
