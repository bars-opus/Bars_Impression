import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventRoomMessageWidget extends StatefulWidget {
  final EventRoomMessageModel message;
  final EventRoom room;
  final PaletteGenerator palette;
  final String currentUserId;
  final Function(EventRoomMessageModel) onReply;

  EventRoomMessageWidget({
    Key? key,
    required this.message,
    required this.onReply,
    required this.room,
    required this.palette,
    required this.currentUserId,
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
    Color _palleteColor =
        Utils.getPaletteDominantColor(widget.palette, Colors.blue);
    Color dominantColor = _palleteColor;
    double luminance = dominantColor.computeLuminance();
    Color titleColor = luminance < 0.5 ? Colors.white : Colors.black;
    String senderId = message.senderId;
    bool isSent = senderId == widget.currentUserId;
    CrossAxisAlignment crossAxisAlignment =
        isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    MainAxisAlignment mainAxisAlignment =
        isSent ? MainAxisAlignment.end : MainAxisAlignment.start;
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
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: _repliedTome!
                                                ? 'Me\n'
                                                : "${message.authorName}\n",
                                            style: TextStyle(
                                              fontSize: ResponsiveHelper
                                                  .responsiveFontSize(
                                                      context, 16),
                                              color: textColor.withOpacity(.6),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                message.replyToMessage!.message,
                                            style: TextStyle(
                                              fontSize: ResponsiveHelper
                                                  .responsiveFontSize(
                                                      context, 16),
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
                                          fontSize: ResponsiveHelper
                                              .responsiveFontSize(context, 16),
                                          fontWeight: FontWeight.normal),
                                    )
                                  : RichText(
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: "${message.authorName}\n",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: ResponsiveHelper
                                                  .responsiveFontSize(
                                                      context, 12),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: message.content,
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: ResponsiveHelper
                                                  .responsiveFontSize(
                                                      context, 16),
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
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 10),
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: textAlign,
                              )),
                        ],
                      ),
                    ),
                  ),
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

  Future<void> deleteMessageAndAttachment(
      List<MessageAttachment> attatchments) async {
    try {
      // Delete the message from Firestore.
      DocumentSnapshot doc = await eventsChatRoomsConverstionRef
          .doc(widget.room.linkedEventId)
          .collection('roomChats')
          .doc(widget.message.id)
          .get();

      if (doc.exists) {
        await doc.reference.delete();
      }

      // Delete the attachment from Firebase Storage, if the URL is valid.
      if (Uri.parse(attatchments[0].mediaUrl).isAbsolute) {
        await FirebaseStorage.instance
            .refFromURL(attatchments[0].mediaUrl)
            .delete();
      }
    } catch (e) {
      // Handle the error appropriately.
      print(e); // Consider a better error handling approach than just printing.
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
                    isAuthor ? 'Delete' : 'View profile',
                  ),
                  onPressed: isAuthor
                      ? () {
                          deleteMessageAndAttachment(attatchments);
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
