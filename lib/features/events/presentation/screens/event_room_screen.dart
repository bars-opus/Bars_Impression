import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:uuid/uuid.dart';

class EventRoomScreen extends StatefulWidget {
  static final id = 'EventRoomScreen';
  final EventRoom room;
  final TicketIdModel ticketId;

  final PaletteGenerator palette;

  final String currentUserId;
  EventRoomScreen({
    required this.currentUserId,
    required this.room,
    required this.palette,
    required this.ticketId,
  });

  @override
  _EventRoomScreenState createState() => _EventRoomScreenState();
}

class _EventRoomScreenState extends State<EventRoomScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  late ScrollController _hideButtonController;
  final FocusNode _focusNode = FocusNode();

  final TextEditingController _messageController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  // int _messageCount = 0;

  @override
  void initState() {
    super.initState();
    // _setMessageCount();
    _slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _slideAnimation =
        Tween<double>(begin: 0, end: 100).animate(_slideController);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false)
          .setReplyEventRoomMessage(null);
    });
    _messageController.addListener(_onAskTextChanged);

    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (mounted) {
          setState(() {
            Provider.of<UserData>(context, listen: false)
                .setChatRoomScrollVisibl(false);
          });
        }
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (mounted) {
          setState(() {
            Provider.of<UserData>(context, listen: false)
                .setChatRoomScrollVisibl(true);
          });
        }
      }
    });
  }

  // _setMessageCount() async {
  //   DatabaseService.numChatRoomMessage(widget.room.linkedEventId)
  //       .listen((messageCount) {
  //     if (mounted) {
  //       setState(() {
  //         _messageCount = messageCount;
  //       });
  //     }
  //   });
  // }

  void _onAskTextChanged() {
    if (_messageController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _isTypingNotifier.dispose();
    _slideController.dispose();
    _hideButtonController.dispose();

    super.dispose();
  }

  _handleImage({required bool fromCamera}) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    final file = fromCamera
        ? await PickCropCamera.pickedMedia(cropImage: _cropImage)
        : await PickCropImage.pickedMedia(cropImage: _cropImage);

    if (file == null) return;
    _provider.setIsLoading(true);
    // final isHarmful = await _checkForHarmfulContent(context, file as File);

     bool isHarmful = await HarmfulContentChecker.checkForHarmfulContent(context, file as File);

    if (isHarmful) {
      _provider.setIsLoading(false);
       mySnackBarModeration(context,
              'Harmful content detected. Please choose a different image. Please review');
          _provider.setIsLoading(false);

      
    } else {
      _provider.setIsLoading(false);
      // isEvent ?
      _provider.setMessageImage(file);
      _focusNode.requestFocus();
      //  : _provider.setPostImage(file);
    }

    // if (file != null && mounted) {
    //   setState(() {
    //     Provider.of<UserData>(context, listen: false)
    //         .setMessageImage(file as File?);
    //     _focusNode.requestFocus();
    //   });
    // }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
    );
    return croppedImage!;
  }

  // Future<bool> _checkForHarmfulContent(BuildContext context, File image) async {
  //   VisionApiHelper visionHelper = VisionApiHelper();

  //   Map<String, dynamic>? analysisResult =
  //       await visionHelper.safeSearchDetect(image.path);
  //   if (analysisResult != null) {
  //     final safeSearch = analysisResult['responses'][0]['safeSearchAnnotation'];
  //     if (safeSearch['adult'] == 'LIKELY' ||
  //         safeSearch['adult'] == 'VERY_LIKELY' ||
  //         safeSearch['spoof'] == 'LIKELY' ||
  //         safeSearch['spoof'] == 'VERY_LIKELY' ||
  //         safeSearch['medical'] == 'LIKELY' ||
  //         safeSearch['medical'] == 'VERY_LIKELY' ||
  //         safeSearch['violence'] == 'LIKELY' ||
  //         safeSearch['violence'] == 'VERY_LIKELY' ||
  //         safeSearch['racy'] == 'LIKELY' ||
  //         safeSearch['racy'] == 'VERY_LIKELY') {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  void _showBottomPickImage() {
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
                      _handleImage(fromCamera: true);
                    },
                    text: 'Camera',
                  ),
                  BottomModelSheetListTileActionWidget(
                    colorCode: '',
                    icon: MdiIcons.image,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _handleImage(fromCamera: false);
                    },
                    text: 'Gallery',
                  ),
                ])));
      },
    );
  }

  _displayImage() {
    final width = MediaQuery.of(context).size.width;
    final _provider = Provider.of<UserData>(context, listen: false);
    return _provider.isLoading
        ? ReplyMessageAndActivityCountWidget(
            color: Colors.blue,
            height: _provider.isLoading ? 80.0 : 0,
            width: width,
            widget: Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
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
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Text(
                    'Processing image...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        : ShakeTransition(
            child: ReplyMessageAndActivityCountWidget(
              color: Colors.blue,
              height: _provider.messageImage == null ? 0.0 : 80,
              width: width,
              widget: ListTile(
                  title: Text(
                    'Ready to send',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: _provider.isSendigChat
                      ? SizedBox(
                          height:
                              ResponsiveHelper.responsiveHeight(context, 10.0),
                          width:
                              ResponsiveHelper.responsiveHeight(context, 10.0),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: ResponsiveHelper.responsiveFontSize(
                                context, 2.0),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              HapticFeedback.lightImpact();
                              _provider.setMessageImage(null);
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                  leading: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: _provider.messageImage == null
                              ? null
                              : DecorationImage(
                                  image: FileImage(
                                      File(_provider.messageImage!.path)),
                                  fit: BoxFit.cover,
                                )))),
            ),
          );
  }

  _commentFiledWidget(
    Color palleteColor,
    final TextEditingController controller,
    final VoidCallback onSend,
    final String hintText,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);
    Color dominantColor = palleteColor;
    double luminance = dominantColor.computeLuminance();
    Color titleColor = luminance < 0.5 ? Colors.white : Colors.black;

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
            focusNode: _focusNode,
            controller: controller,
            keyboardAppearance: MediaQuery.of(context).platformBrightness,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: controller.text.trim().length > 300 ? 10 : null,
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              hintStyle: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
            onSubmitted: (string) {
              onSend();
            },
          ),
          trailing: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: _provider.isSendigChat
                ? null
                : CircularButton(
                    color: readyToSend ? palleteColor : Colors.transparent,
                    icon: Icon(Icons.send,
                        color: readyToSend ? titleColor : Colors.grey),
                    onPressed: onSend),
          ),
        ),
      ),
    );
  }

  _submitMessageFirstMessage() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    HapticFeedback.mediumImpact();

    var replyMessage;
    if (_provider.replyEventRoomMessage != null) {
      replyMessage = ReplyToMessage(
        id: _provider.replyEventRoomMessage!.id,
        imageUrl: _provider.replyEventRoomMessage!.attachments.isEmpty
            ? ''
            : _provider.replyEventRoomMessage!.attachments[0].mediaUrl,
        message: _provider.replyEventRoomMessage!.content,
        athorId: _provider.replyEventRoomMessage!.senderId,
      );
    }
    String? imageUrl;
    if (_provider.messageImage != null) {
      _provider.setIsSendigChat(true);
      try {
        imageUrl = await StorageService.uploadEventRooomMessageImage(
            _provider.messageImage!, widget.room.linkedEventId);
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

    EventRoomMessageModel message = EventRoomMessageModel(
      content: _messageController.text.trim().isEmpty
          ? ''
          : _messageController.text.trim(),
      id: '',
      senderId: widget.currentUserId,
      timestamp: Timestamp.fromDate(DateTime.now()),
      isLiked: false,
      isRead: false,
      isSent: false,
      replyToMessage: replyMessage,
      sendContent: sendContent,
      attachments: attachement,
      eventId: widget.room.linkedEventId,
      authorName: _provider.user!.userName!,
      authorProfileHanlde: _provider.user!.profileHandle!,
      authorProfileImageUrl: _provider.user!.profileImageUrl!,
      authorVerification: _provider.user!.verified! ? false : true,
    );
    DatabaseService.roomChatMessage(
      eventId: widget.room.linkedEventId,
      message: message,
      currentUserId: widget.currentUserId,
    );
    _provider.setReplyEventRoomMessage(null);
    _provider.setMessageImage(null);
    _messageController.clear();
    _provider.setIsSendigChat(false);
  }

  replyMessageHeader() {
    final width = MediaQuery.of(context).size.width;
    final _provider = Provider.of<UserData>(
      context,
    );

    return ReplyMessageAndActivityCountWidget(
      color: Colors.blue,
      height: _provider.replyEventRoomMessage == null ? 0.0 : 80,
      width: width,
      widget: ListTile(
        leading: _provider.replyEventRoomMessage == null
            ? null
            : _provider.replyEventRoomMessage!.attachments.isEmpty
                ? null
                : Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(_provider
                              .replyEventRoomMessage!.attachments[0].mediaUrl),
                          fit: BoxFit.cover,
                        ))),
        trailing: IconButton(
            onPressed: () {
              setState(() {
                HapticFeedback.lightImpact();
                _provider.setReplyEventRoomMessage(null);
              });
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
            )),
        title: _provider.replyEventRoomMessage == null
            ? SizedBox()
            : RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: widget.currentUserId !=
                                _provider.replyEventRoomMessage!.senderId
                            ? 'Replying to ${_provider.replyEventRoomMessage!.authorName}:\n'
                            : 'Replying to yourself:\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 12.0),
                        )),
                    TextSpan(
                      text: _provider.replyEventRoomMessage!.content,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                      ),
                    )
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }

  _commentField(Color palleteColor) {
    final _provider = Provider.of<UserData>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: ValueListenableBuilder(
          valueListenable: _isTypingNotifier,
          builder: (BuildContext context, bool isTyping, Widget? child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _displayImage(),
                replyMessageHeader(),
                _commentFiledWidget(
                  palleteColor,
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
                              print('Error sending comment or reply: $e');
                            }
                          }
                        },
                  _provider.replyEventRoomMessage == null
                      ? 'type a message...'
                      : 'reply to ${_provider.replyEventRoomMessage!.content}',
                ),
              ],
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    final double width = MediaQuery.of(context).size.width;
    Color _palleteColor = widget.palette == null
        ? Colors.yellow
        : widget.palette.dominantColor == null
            ? Colors.blue
            : widget.palette.dominantColor!.color;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Material(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            alignment: FractionalOffset.bottomCenter,
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.room.imageUrl),
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
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: _provider.isChatRoomScrollVisible ? 0 : 55,
                    width: width,
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () => Navigator.pop(context),
                      ),
                      title: Text(
                        "${widget.room.title}",
                        style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 16.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          StreamBuilder(
                            stream: eventsChatRoomsConverstionRef
                                .doc(widget.room.linkedEventId)
                                .collection('roomChats')
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Expanded(
                                  child: Center(
                                    child: CircularProgress(
                                      isMini: true,
                                    ),
                                  ),
                                );
                              }
                              return snapshot.data.docs.length == 0
                                  ? Expanded(
                                      child: Center(
                                        child: NoContents(
                                          icon:
                                              (Icons.chat_bubble_outline_sharp),
                                          title: 'No conversations,',
                                          subTitle:
                                              'You can be the first person to start a conversation. ',
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Scrollbar(
                                        controller: _hideButtonController,
                                        child: ListView.builder(
                                          controller: _hideButtonController,
                                          reverse: true,
                                          itemCount: snapshot.data.docs.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            EventRoomMessageModel message =
                                                EventRoomMessageModel.fromDoc(
                                                    snapshot.data.docs[index]);

                                            return EventRoomMessageWidget(
                                              key: ValueKey(
                                                  snapshot.data.docs[index].id),
                                              currentUserId:
                                                  widget.currentUserId,
                                              onReply: (message) {
                                                _focusNode.requestFocus();
                                                setState(() {
                                                  _provider
                                                      .setReplyEventRoomMessage(
                                                          message);
                                                });
                                              },
                                              message: message,
                                              palette: widget.palette,
                                              room: widget.room,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                            },
                          ),
                          _commentField(_palleteColor),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
