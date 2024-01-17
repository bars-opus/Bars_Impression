import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventRoomMessageWidget extends StatefulWidget {
  final EventRoomMessageModel message;
  final EventRoom room;
  final PaletteGenerator palette;
  // final Chat chat;
  final String currentUserId;
  // final Color randomColor ;
  // var user;
  final Function(EventRoomMessageModel) onReply;

  EventRoomMessageWidget({
    Key? key,
    required this.message,
    // required this.chat,
    required this.onReply,
    required this.room,
    required this.palette,
    // required this.user,
    required this.currentUserId,
    // required this.randomColor,
  }) : super(key: key);

  @override
  _EventRoomMessageWIdgetState createState() => _EventRoomMessageWIdgetState();
}

class _EventRoomMessageWIdgetState extends State<EventRoomMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

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
    EventRoomMessageModel message,
    // Chat chat,
  ) {
    // DatabaseService.likeMessage(
    //     currentUserId: widget.currentUserId,
    //     liked: false,
    //     userId: widget.user.id!,
    //     message: message,
    //     chat: chat);
  }

  _likeMessage(
    EventRoomMessageModel message,
    // Chat chat,
  ) {
    // DatabaseService.likeMessage(
    //     currentUserId: widget.currentUserId,
    //     liked: true,
    //     userId: widget.user.id!,
    //     message: message,
    //     chat: chat);
  }

  _action(BuildContext context, String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
        ),
      ),
    );
  }

  // _likeWidget(
  //   EventRoomMessageModel message,
  // ) {
  //   return IconButton(
  //     icon: Icon(message.isLiked ? Icons.favorite : Icons.favorite_border),
  //     color: message.isLiked ? Colors.red : Colors.grey,
  //     onPressed: () {
  //       message.isLiked
  //           ? _unLikeMessage(
  //               message,
  //             )
  //           : _likeMessage(
  //               message,
  //             );
  //     },
  //   );
  // }

  _profileWidgetWidget(
    EventRoomMessageModel message,
  ) {
    return GestureDetector(
      onTap: () {
        _navigateToPage(
            context,
            ProfileScreen(
              user: null,
              currentUserId: widget.currentUserId,
              userId: message.senderId,
            ));
      },
      child: message.authorProfileImageUrl.isEmpty
          ? Icon(
              Icons.account_circle,
              size: 40.0,
              color: Colors.grey,
            )
          : CircleAvatar(
              radius: 15.0,
              backgroundColor: Colors.blue,
              backgroundImage:
                  CachedNetworkImageProvider(message.authorProfileImageUrl),
            ),
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
              // color: Colors.white,
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

  Widget _buildMessageTile(EventRoomMessageModel message,
      List<MessageAttachment> messageAttatchment) {
    final width = MediaQuery.of(context).size.width;

    Color _palleteColor = widget.palette == null
        ? Colors.yellow
        : widget.palette.dominantColor == null
            ? Colors.blue
            : widget.palette.dominantColor!.color;

    Color dominantColor = _palleteColor;
    double luminance = dominantColor.computeLuminance();
    Color titleColor = luminance < 0.5 ? Colors.white : Colors.black;

    String senderId = message.senderId;

    bool isSent = senderId == widget.currentUserId;
    //Row alignment in container
    CrossAxisAlignment crossAxisAlignment =
        isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    MainAxisAlignment mainAxisAlignment =
        isSent ? MainAxisAlignment.end : MainAxisAlignment.start;

    //Container color
    Color backgroundColor =
        isSent ? _palleteColor : Theme.of(context).primaryColorLight;

    TextAlign textAlign = isSent ? TextAlign.end : TextAlign.start;

    Color textColor =
        isSent ? titleColor : Theme.of(context).secondaryHeaderColor;

    bool? _repliedTome;
    if (message.replyToMessage != null) {
      _repliedTome = message.replyToMessage!.athorId != widget.currentUserId;
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding:
            EdgeInsets.only(left: isSent ? 40 : 0.0, right: isSent ? 0 : 40.0),
        child: Column(
          children: [
            messageAttatchment.isEmpty
                ? const SizedBox.shrink()
                : _displayAttachment(backgroundColor, messageAttatchment),
            Container(
              width: width,
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  // message.isLiked && isSent
                  //     ? _likeWidget(message)
                  //     : const SizedBox.shrink(),
                  isSent
                      ? const SizedBox.shrink()
                      : const SizedBox(
                          width: 10,
                        ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: borderRadius,
                      ),
                      child: Column(
                        crossAxisAlignment: crossAxisAlignment,
                        children: [
                          message.replyToMessage == null
                              ? const SizedBox.shrink()
                              : Container(
                                  width: width,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.2),
                                    borderRadius: borderRadius,
                                  ),
                                  child: ListTile(
                                    leading:
                                        message.replyToMessage!.imageUrl.isEmpty
                                            ? null
                                            : Container(
                                                height: 70,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            message
                                                                .replyToMessage!
                                                                .imageUrl),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                    title: RichText(
                                      textScaleFactor: MediaQuery.of(context)
                                          .textScaleFactor,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: _repliedTome!
                                                ? 'Me\n'
                                                : "${message.authorName}\n",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: textColor.withOpacity(.6),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                message.replyToMessage!.message,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                          ListTile(
                              leading:
                                  isSent ? null : _profileWidgetWidget(message),
                              onTap: () => FocusScope.of(context).unfocus(),
                              title: isSent
                                  ? Text(
                                      message.content,
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )
                                  : RichText(
                                      textScaleFactor: MediaQuery.of(context)
                                          .textScaleFactor,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: "${message.authorName}\n",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: message.content,
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ])),
                              subtitle: Text(
                                message.timestamp == null
                                    ? ''
                                    : timeago.format(
                                        message.timestamp!.toDate(),
                                      ),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: textAlign,
                              )),
                        ],
                      ),
                    ),
                  ),

                  // !isSent ? _likeWidget(message) : const SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
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
                    isAuthor ? 'Delete' : 'View profile',
                  ),
                  onPressed: isAuthor
                      ? () {
                          try {
                            eventsChatRoomsConverstionRef
                                .doc(widget.room.linkedEventId)
                                .collection('roomChats')
                                .doc(widget.message.id)
                                .get()
                                .then((doc) {
                              if (doc.exists) {
                                doc.reference.delete();
                              }
                            });
                          } catch (e) {}
                        }
                      : () {
                          _navigateToPage(
                              context,
                              ProfileScreen(
                                user: null,
                                currentUserId: widget.currentUserId,
                                userId: widget.message.senderId,
                              ));
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
            child: _buildMessageTile(widget.message, messageAttatchment)),
      ),
    );
  }
}
