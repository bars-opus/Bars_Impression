import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class SlidableMessage extends StatefulWidget {
  final ChatMessage message;
  final String chatId;
  final String userId;

  final Chat? chat;

  final String currentUserId;
  var user;
  final bool isBlockingUser;

  final Function(ChatMessage) onReply;

  SlidableMessage({
    Key? key,
    required this.message,
    required this.chatId,
    required this.onReply,
    required this.user,
    required this.currentUserId,
    required this.chat,
    required this.isBlockingUser,
    required this.userId,
  }) : super(key: key);

  @override
  _SlidableMessageState createState() => _SlidableMessageState();
}

class _SlidableMessageState extends State<SlidableMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  // bool _isBlockingUser = false;
  // bool _isAFollower = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _slideAnimation =
        Tween<double>(begin: 0, end: 100).animate(_slideController);
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  _unLikeMessage(
    ChatMessage message,
  ) {
    DatabaseService.likeMessage(
        currentUserId: widget.currentUserId,
        liked: false,
        userId: widget.userId,
        message: message,
        chatId: widget.chatId);
  }

  _likeMessage(
    ChatMessage message,
  ) {
    DatabaseService.likeMessage(
        currentUserId: widget.currentUserId,
        liked: true,
        userId: widget.userId,
        message: message,
        chatId: widget.chatId);
  }

  _action(BuildContext context, String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
          overflow: TextOverflow.ellipsis,
          textScaler: MediaQuery.of(context).textScaler,
        ),
      ),
    );
  }

  _likeWidget(
    ChatMessage message,
  ) {
    return IconButton(
      icon: Icon(message.isLiked ? Icons.favorite : Icons.favorite_border),
      color: message.isLiked ? Colors.red : Colors.grey,
      onPressed: () {
        HapticFeedback.heavyImpact();
        message.isLiked
            ? _unLikeMessage(
                message,
              )
            : _likeMessage(
                message,
              );
      },
    );
  }

  _displayAttachment(
      Color backgroundColor, List<MessageAttachment> messageAttatchment) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: GestureDetector(
        onTap: () {
          _navigateToPage(
              context,
              ViewImage(
                imageUrl: messageAttatchment[0].mediaUrl,
              ));
        },
        child: Container(
            height: width,
            width: width,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(5),
              image: messageAttatchment.isEmpty
                  ? null
                  : DecorationImage(
                      image: CachedNetworkImageProvider(
                          messageAttatchment[0].mediaUrl),
                      fit: BoxFit.cover,
                    ),
            )),
      ),
    );
  }

  void _showBottomSheetChatDetails(
    BuildContext context,
  ) {
    bool _restrictChat = widget.chat!.restrictChat;

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
              child: widget.chat == null
                  ? NoContents(
                      title: 'No chat details',
                      subTitle: '',
                      icon: Icons.send_outlined)
                  : ChatDetails(
                      chat: widget.chat!,
                      currentUserId: widget.currentUserId,
                      user: widget.user,
                      isBlockingUser: widget.isBlockingUser,
                      restrictFunction: (value) {
                        setState(() {
                          _restrictChat = value;
                        });

                        usersAuthorRef
                            .doc(widget.currentUserId)
                            .collection('new_chats')
                            .doc(widget.user.userId)
                            .update({
                          'restrictChat': value,
                        });

                        usersAuthorRef
                            .doc(widget.user.userId)
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
  }

  _replyMessage(
    ChatMessage message,
  ) {
    bool isSent = message.senderId == widget.currentUserId;

    final width = MediaQuery.of(context).size.width;
    Color textColor =
        isSent ? Colors.black : Theme.of(context).secondaryHeaderColor;
    bool? _repliedTome;

    if (message.replyToMessage != null) {
      _repliedTome = message.replyToMessage!.athorId == widget.currentUserId;
    }
    BorderRadius borderRadius = isSent
        ? BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0))
        : BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topRight: Radius.circular(10.0));
    return message.replyToMessage == null
        ? const SizedBox.shrink()
        : Container(
            width: width,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.2),
              borderRadius: borderRadius,
            ),
            child: ListTile(
              leading: message.replyToMessage!.imageUrl.isEmpty
                  ? null
                  : Container(
                      height: ResponsiveHelper.responsiveHeight(context, 70.0),
                      width: ResponsiveHelper.responsiveHeight(context, 70.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              message.replyToMessage!.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      )),
              title: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          _repliedTome! ? 'Me\n' : "${widget.user.userName}\n",
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                        color: textColor.withOpacity(.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: message.replyToMessage!.message,
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                        color: textColor,
                      ),
                    )
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
  }

  void _showBottomSheetErrorMessage(String title) {
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
          title: title,
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  receivedSentContentMessage(
    ChatMessage message,
  ) {
    bool isSent = message.senderId == widget.currentUserId;

    final width = MediaQuery.of(context).size.width;
    Color textColor =
        isSent ? Colors.black : Theme.of(context).secondaryHeaderColor;

    BorderRadius borderRadius = isSent
        ? BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0))
        : BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topRight: Radius.circular(10.0));
    return message.sendContent == null
        ? const SizedBox.shrink()
        : Container(
            width: width,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.2),
              borderRadius: borderRadius,
            ),
            child: ListTile(
              trailing: _isLoading
                  ? SizedBox(
                      height: ResponsiveHelper.responsiveHeight(context, 10.0),
                      width: ResponsiveHelper.responsiveHeight(context, 10.0),
                      child: CircularProgressIndicator(
                          strokeWidth: 3, color: textColor),
                    )
                  : Icon(
                      Icons.arrow_forward_ios,
                      color: textColor,
                      size: ResponsiveHelper.responsiveHeight(context, 20.0),
                    ),
              leading: message.sendContent!.imageUrl.isEmpty
                  ? null
                  : Container(
                      height: ResponsiveHelper.responsiveHeight(context, 70.0),
                      width: ResponsiveHelper.responsiveHeight(context, 70.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              message.sendContent!.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      )),
              title: Text(
                message.sendContent!.title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                message.sendContent!.type,
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                  color: textColor,
                ),
              ),
              onTap: 
              
              message.sendContent!.type.startsWith('Post')
                  ? () async {
                      _isLoading = true;
                      try {
                        Post? post = await DatabaseService.getPostWithId(
                            message.sendContent!.id);

                        if (post != null) {
                          _navigateToPage(
                              context,
                              EventEnlargedScreen(
                                currentUserId: widget.currentUserId,
                                post: post,
                                type: post.storeType,
                                showPrivateEvent: true,
                              ));
                        } else {
                          _showBottomSheetErrorMessage(
                              'Failed to fetch event.');
                        }
                        // Navigator.pop(context);
                      } catch (e) {
                        // print('Failed to fetch user data: $e');
                        _showBottomSheetErrorMessage('Failed to fetch event');
                      } finally {
                        _isLoading = false;
                      }
                    }
                  : () {
                      _navigateToPage(
                          context,
                          ProfileScreen(
                            user: null,
                            currentUserId: widget.currentUserId,
                            userId: message.sendContent!.id,
                          ));
                    },
            ),
          );
  }

  Widget _buildMessageTile(ChatMessage message, String chat,
      List<MessageAttachment> messageAttatchment) {
    final width = MediaQuery.of(context).size.width;
    String senderId = message.senderId;
    String content = message.content;
    bool isSent = senderId == widget.currentUserId;
    CrossAxisAlignment crossAxisAlignment =
        isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    MainAxisAlignment mainAxisAlignment =
        isSent ? MainAxisAlignment.end : MainAxisAlignment.start;

    //Container color
    Color backgroundColor = isSent
        ? message.isRead
            ? Colors.lightBlueAccent
            : Colors.teal
        : Theme.of(context).primaryColorLight;

    TextAlign textAlign = isSent ? TextAlign.end : TextAlign.start;
    Color textColor =
        isSent ? Colors.black : Theme.of(context).secondaryHeaderColor;

    BorderRadius borderRadius = isSent
        ? BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0))
        : BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topRight: Radius.circular(10.0));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding:
            EdgeInsets.only(left: isSent ? 30 : 0.0, right: isSent ? 0 : 30.0),
        child: Container(
          width: width,
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              messageAttatchment.isEmpty
                  ? const SizedBox.shrink()
                  : _displayAttachment(backgroundColor, messageAttatchment),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  isSent
                      ? message.isLiked && isSent
                          ? _likeWidget(
                              message,
                            )
                          : const SizedBox.shrink()
                      : SizedBox.shrink(),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: borderRadius,
                      ),
                      child: Column(
                        crossAxisAlignment: crossAxisAlignment,
                        children: [
                          _replyMessage(message),
                          receivedSentContentMessage(message),
                          ListTile(
                              title: Text(
                                content,
                                style: TextStyle(
                                    color: textColor,
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 16.0),
                                    fontWeight: FontWeight.normal),
                              ),
                              subtitle: Text(
                                message.timestamp == null
                                    ? ''
                                    : timeago.format(
                                        message.timestamp!.toDate(),
                                      ),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 10.0),
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: textAlign,
                              )),
                        ],
                      ),
                    ),
                  ),
                  !isSent
                      ? _likeWidget(
                          message,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteMessageAndAttachment(
      List<MessageAttachment> attatchments) async {
    if (widget.chat == null) {
      // If there's no chat or message, there's nothing to delete.
      return;
    }

    try {
      // Update the deleted chat message in the database.
      await DatabaseService.updateDeletedChatMessage(message: widget.message);

      // Attempt to delete the message from Firestore.
      DocumentSnapshot doc = await messageRef
          .doc(widget.chatId)
          .collection('conversation')
          .doc(widget.message.id)
          .get();

      if (doc.exists) {
        await doc.reference.delete();
      }
    } catch (e) {
      // Handle errors for Firestore operations.
      // Log the error, show a user-facing error message, or handle it as needed.
      print('Error deleting message from Firestore: $e');
    }

    if (attatchments.isNotEmpty && attatchments[0].mediaUrl.isNotEmpty) {
      try {
        // Attempt to delete the attachment from Firebase Storage.
        await FirebaseStorage.instance
            .refFromURL(attatchments[0].mediaUrl)
            .delete();
      } catch (e) {
        // Handle errors for Firebase Storage operations.
        // Log the error, show a user-facing error message, or handle it as needed.
        print('Error deleting attachment from Firebase Storage: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MessageAttachment> messageAttatchment = [];
    List<MessageAttachment> attatchments = widget.message.attachments;
    for (MessageAttachment attatchment in attatchments) {
      MessageAttachment attatchmentsOption = attatchment;
      messageAttatchment.add(attatchmentsOption);
    }

    final width = MediaQuery.of(context).size.width;
    bool isAuthor = widget.currentUserId == widget.message.senderId;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (_slideController.isAnimating) return;

        _slideController.value += details.primaryDelta! / context.size!.width;
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity!.isNegative) {
          _slideController.animateTo(0);
        } else {
          _slideController.animateTo(1).then((_) {
            HapticFeedback.lightImpact();
            widget.onReply(widget.message);
            Future.delayed(const Duration(milliseconds: 200)).then((_) {
              _slideController.animateTo(0);
            });
          });
        }
      },
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_slideAnimation.value, 0),
            child: child,
          );
        },
        child: FocusedMenuHolder(
            menuWidth: width.toDouble(),
            menuItemExtent: 60,
            menuOffset: 10,
            blurBackgroundColor: Colors.transparent,
            openWithTap: false,
            onPressed: () {},
            menuItems: [
              FocusedMenuItem(
                  title: _action(
                    context,
                    'Reply',
                  ),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    widget.onReply(widget.message);
                  }),
              FocusedMenuItem(
                  title: _action(
                    context,
                    isAuthor ? 'Delete' : ' Chat setting',
                  ),
                  onPressed: isAuthor
                      ? () async {
                          deleteMessageAndAttachment(attatchments);
                          // try {
                          //   if (widget.chat != null) {
                          //     DatabaseService.updateDeletedChatMessage(
                          //         message: widget.message);
                          //   }
                          //   messageRef
                          //       .doc(widget.chatId)
                          //       .collection('conversation')
                          //       .doc(widget.message.id)
                          //       .get()
                          //       .then((doc) {
                          //     if (doc.exists) {
                          //       doc.reference.delete();
                          //     }
                          //   });
                          //   FirebaseStorage.instance
                          //       .refFromURL(attatchments[0].mediaUrl)
                          //       .delete()
                          //       .catchError((e) {});
                          // } catch (e) {}
                        }
                      : () {
                          _showBottomSheetChatDetails(context);
                        }),
              FocusedMenuItem(
                  title: _action(
                    context,
                    'Report',
                  ),
                  onPressed: () {
                    _navigateToPage(
                      context,
                      ReportContentPage(
                        parentContentId: widget.message.id,
                        repotedAuthorId: widget.message.senderId,
                        contentId: widget.message.id,
                        contentType: 'message',
                      ),
                    );
                  }),
              FocusedMenuItem(
                title: _action(
                  context,
                  'Suggest',
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SuggestionBox()));
                },
              ),
            ],
            child: _buildMessageTile(
                widget.message, widget.chatId, messageAttatchment)),
      ),
    );
  }
}
