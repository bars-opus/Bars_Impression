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
    var _provider = Provider.of<UserData>(context, listen: false);
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
    _provider.setIsLoading(true);
    HapticFeedback.mediumImpact();
    try {
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
        // chatId: _provider.chatMessageId,
        message: message,
        currentUserId: widget.currentUserId,
        users: selectedUsersList,
        contentSharing: widget.sendContentType,
      );
      Navigator.pop(context);

      _provider.setIsLoading(false);

      mySnackBar(context, "${widget.sendTitle} sent successfully");
    } catch (e) {
      mySnackBar(context, "An error occured try again");

      _provider.setIsLoading(false);
    }

    _provider.setIsLoading(false);

    _provider.setReplyChatMessage(null);
    selectedUsersList.clear();
    setState(() {});

    _provider.setMessageImage(null);
    _messageController.clear();
  }

  // Future<AccountHolderAuthor?> _setUpProfileUser(String userId) async {
  //   // final usersBox = Hive.box<AccountHolderAuthor>('accountHolderAuthor');
  //   // if (usersBox.containsKey(chatUserId)) {
  //   //   // // If the user data is already in the box, use it
  //   //   return usersBox.get(chatUserId);
  //   // } else {
  //   //   // If the user data is not in the box, fetch it from the database and save it to the box
  //   //   // try {
  //   final author = await DatabaseService.getUserWithId(userId);
  //   print(author!.userName);

  //   // if (author != null) usersBox.put(chatUserId, author);
  //   // print(author!.userName);
  //   // return author;
  //   // // } catch (e) {

  //   // // }
  //   // }
  // }

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
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    ResponsiveHelper.responsiveFontSize(context, 14.0),
                  ),
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
                      return FutureBuilder<AccountHolderAuthor?>(
                        future: DatabaseService.getUserWithId(userId),
                        builder: (BuildContext context,
                            AsyncSnapshot<AccountHolderAuthor?>
                                authorSnapshot) {
                          if (authorSnapshot.hasError) {
                            return const Text('Error loading chat room');
                          }
                          if (!authorSnapshot.hasData) {
                            return _loadingSkeleton(); // return a loading spinner or some other widget
                          }
                          final author = authorSnapshot.data;
                          // limitRooms(); // Ensure these functions are defined and manage your data as expected
                          // limitTicketIds(); // Ensure these functions are defined and manage your data as expected
                          return GetAuthor(
                            chats: chats,
                            lastMessage: lastMessage,
                            seen: seen,
                            userId: userId,
                            selectedUsersList: selectedUsersList,
                            userSelection: userSelection,
                            updateParent: updateListState,
                            author: author!,
                          );
                        },
                      );

                      // GetAuthor(
                      //   chats: chats,
                      //   lastMessage: lastMessage,
                      //   seen: seen,
                      //   userId: userId,
                      //   // selectedUsersList: selectedUsersList,
                      //   userSelection: userSelection,
                      //   updateParent: updateListState,
                      // );
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
    var _provider = Provider.of<UserData>(
      context,
    );

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
                child: _provider.isLoading
                    ? SizedBox(
                        height:
                            ResponsiveHelper.responsiveHeight(context, 10.0),
                        width: ResponsiveHelper.responsiveHeight(context, 10.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 2),
                        child: Text(
                          'Send',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                onPressed: () {
                  if (!_provider.isLoading) _submitMessageFirstMessage();
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
  final AccountHolderAuthor author;

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
    required this.author,
  });

  @override
  State<GetAuthor> createState() => _GetAuthorState();
}

class _GetAuthorState extends State<GetAuthor>
    with AutomaticKeepAliveClientMixin {
  // AccountHolderAuthor? _author;

  @override
  void initState() {
    super.initState();
    // _setUpProfileUser();
    widget.userSelection[widget.userId] = false;
  }

  // Future<void> _setUpProfileUser() async {
  //   AccountHolderAuthor? profileUser =
  //       await DatabaseService.getUserWithId(widget.userId);
  //   if (mounted) {
  //     setState(() {
  //       _author = profileUser;
  //     });
  //   }
  // }

  // _loadingSkeleton() {
  //   return ListTile(
  //       leading: CircleAvatar(
  //         radius: 20.0,
  //         backgroundColor: Colors.blue,
  //       ),
  //       title: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.only(right: 12.0),
  //             child: Text(
  //               'Loading...',
  //               style: TextStyle(
  //                 fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
  //                 color: Theme.of(context).secondaryHeaderColor,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 2.0,
  //           ),
  //         ],
  //       ),
  //       onTap: () {});
  // }

  _display() {
    var _provider = Provider.of<UserData>(context, listen: false);

    return Container(
      color: widget.userSelection[widget.author.userId]!
          ? Colors.blue.withOpacity(.1)
          : null,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
        child: CheckboxListTile(
          selectedTileColor:
              widget.userSelection[widget.author.userId]! ? Colors.blue : null,
          title: Row(
            children: [
              widget.author.profileImageUrl!.isEmpty
                  ? Icon(
                      Icons.account_circle,
                      size: 40.0,
                      color: Colors.grey,
                    )
                  : CircleAvatar(
                      radius: 18.0,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage: CachedNetworkImageProvider(
                          widget.author.profileImageUrl!),
                    ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(children: [
                      TextSpan(
                        text: widget.author.userName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: "\n${widget.author.profileHandle}",
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
          value: widget.userSelection[widget.author.userId] ?? false,
          onChanged: (bool? value) {
            HapticFeedback.lightImpact();
            setState(() {
              widget.userSelection[widget.author.userId!] = value!;
              if (value == true) {
                widget.selectedUsersList
                    .add(widget.author); // add user to list if selected
              } else {
                widget.selectedUsersList.remove(
                    widget.author); // remove user from list if unselected
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
    return
        //  widget.author == null ? _loadingSkeleton() :
        _display();
  }
}
