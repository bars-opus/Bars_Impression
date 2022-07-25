// ignore_for_file: unnecessary_null_comparison

import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatMessageScreen extends StatefulWidget {
  final AccountHolder user;
  final Chat? chat;
  final bool fromProfile;
  final String currentUserId;

  ChatMessageScreen(
      {required this.user,
      required this.currentUserId,
      @required required this.fromProfile,
      required this.chat});

  @override
  _ChatMessageScreenState createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final TextEditingController _adviceControler = TextEditingController();
  bool _isAdvicingUser = false;
  bool _isreplying = false;
  bool _isLiked = false;
  bool _isBlockedUser = false;
  bool _isLoading = false;
  bool _restrictChat = false;
  late ScrollController _hideButtonController;
  late ScrollController _hideAppBarController;
  var _isVisible;
  final FocusNode _focusNode = FocusNode();
  bool _heartAnim = false;

  bool _dragging = false;

  void initState() {
    super.initState();
    _setupIsBlockedUser();
    _isVisible = true;
    _restrictChat = widget.chat == null ? false : widget.chat!.restrictChat;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _clear();
      Provider.of<UserData>(context, listen: false).setPost9('');
    });

    _hideButtonController = new ScrollController();
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

  _clear() {
    if (mounted) {
      setState(() {
        Provider.of<UserData>(context, listen: false).setPost8('');
        Provider.of<UserData>(context, listen: false).setPost7('');
      });
    }
  }

  _deleteMessage(
    ChatMessage message,
  ) {
    final double width = Responsive.isDesktop(
      context,
    )
        ? 600.0
        : MediaQuery.of(context).size.width;
    DatabaseService.deleteMessage(
        currentUserId: widget.currentUserId,
        userId: widget.user.id!,
        message: message);
    message.imageUrl.isEmpty
        ? () {}
        : FirebaseStorage.instance
            .refFromURL(message.imageUrl)
            .delete()
            .catchError(
              (e) => Flushbar(
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
                  'Sorry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width > 800 ? 22 : 14,
                  ),
                ),
                messageText: Text(
                  e.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width > 800 ? 20 : 12,
                  ),
                ),
                icon: Icon(
                  Icons.info_outline,
                  size: 28.0,
                  color: Colors.blue,
                ),
                duration: Duration(seconds: 3),
                leftBarIndicatorColor: Colors.blue,
              )..show(context),
            );
  }

  _unLikeMessage(
    ChatMessage message,
  ) {
    DatabaseService.likeMessage(
        currentUserId: widget.currentUserId,
        liked: false,
        userId: widget.user.id!,
        message: message);
    if (mounted) {
      setState(() {
        _isLiked = false;
      });
    }
  }

  _likeMessage(
    ChatMessage message,
  ) {
    DatabaseService.likeMessage(
        currentUserId: widget.currentUserId,
        liked: true,
        userId: widget.user.id!,
        message: message);
    if (mounted) {
      setState(() {
        _isLiked = true;
      });
    }
  }

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog(context);
  }

  _handleImage() async {
    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;

    if (mounted) {
      Provider.of<UserData>(context, listen: false).setPostImage(file as File);
    }
  }

  _handleImageCamera() async {
    final file = await PickCropCamera.pickedMedia(cropImage: _cropImage);
    if (file == null) return;

    if (mounted) {
      Provider.of<UserData>(context, listen: false).setPostImage(file);
    }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage!;
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Pick image',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Camera',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageCamera();
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'Gallery',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _handleImage();
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
            title: Text('Pick image'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Camera'),
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageCamera();
                },
              ),
              SimpleDialogOption(
                child: Text('Gallery'),
                onPressed: () {
                  Navigator.pop(context);
                  _handleImage();
                },
              ),
              SimpleDialogOption(
                child: Text('cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  _buildBlogComment(
    ChatMessage message,
  ) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId = Provider.of<UserData>(context).currentUserId!;
    return FocusedMenuHolder(
      menuWidth: width,
      menuOffset: 1,
      blurBackgroundColor:
          ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.teal[100],
      openWithTap: false,
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                currentUserId == message.authorId ? 'Unsend' : 'Report',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => currentUserId == message.authorId
                ? _deleteMessage(message)
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportContentPage(
                              parentContentId: widget.chat!.id,
                              repotedAuthorId: message.authorId,
                              contentId: message.id,
                              contentType: 'message',
                            )))),
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Reply',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () {
              HapticFeedback.heavyImpact();
              if (mounted) {
                return _isVisible
                    ? setState(() {
                        _isreplying = true;
                        Provider.of<UserData>(context, listen: false)
                            .setPost8(message.content);
                        Provider.of<UserData>(context, listen: false)
                            .setPost7(message.authorId);

                        _focusNode.requestFocus();
                      })
                    : setState(() {
                        _isreplying = true;
                        Provider.of<UserData>(context, listen: false)
                            .setPost8(message.content);
                        Provider.of<UserData>(context, listen: false)
                            .setPost7(message.authorId);
                        _isVisible = true;
                      });
              }
            }),
      ],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Draggable(
          onDragCompleted: () {
            HapticFeedback.heavyImpact();
            return _isVisible
                ? setState(() {
                    _isreplying = true;
                    Provider.of<UserData>(context, listen: false)
                        .setPost8(message.content);
                    Provider.of<UserData>(context, listen: false)
                        .setPost7(message.authorId);

                    _focusNode.requestFocus();
                  })
                : setState(() {
                    _isreplying = true;
                    Provider.of<UserData>(context, listen: false)
                        .setPost8(message.content);
                    Provider.of<UserData>(context, listen: false)
                        .setPost7(message.authorId);
                    _isVisible = true;
                  });
          },
          affinity: Axis.horizontal,
          axis: Axis.horizontal,
          feedback: Padding(
            padding: EdgeInsets.only(
                top: message.imageUrl.isEmpty ? 8.0 : width / 4),
            child: Container(
              decoration: BoxDecoration(
                  color: currentUserId == message.authorId
                      ? Colors.white
                      : Colors.grey,
                  shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.reply,
                  color: currentUserId == message.authorId
                      ? Colors.grey
                      : Colors.white,
                ),
              ),
            ),
          ),
          child: Padding(
            padding: currentUserId == message.authorId
                ? const EdgeInsets.only(left: 30.0)
                : const EdgeInsets.only(right: 30.0),
            child: Column(
              crossAxisAlignment: currentUserId == message.authorId
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                message.replyingMessage.isEmpty
                    ? SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: currentUserId == message.authorId
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
                            child: Container(
                              width: 30,
                              height: 2,
                              color: currentUserId == message.authorId
                                  ? Colors.teal[800]
                                  : Colors.black,
                            ),
                          ),
                          AnimatedContainer(
                            curve: Curves.easeInOut,
                            duration: Duration(milliseconds: 800),
                            height: null,
                            width: _dragging ? width - 50 : width,
                            color: Colors.transparent,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: currentUserId == message.authorId
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(5.0),
                                      )
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(50.0),
                                        topRight: Radius.circular(50.0),
                                        bottomRight: Radius.circular(50.0),
                                      ),
                              ),
                              child: ListTile(
                                  title: RichText(
                                    textScaleFactor:
                                        MediaQuery.of(context).textScaleFactor,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                "${message.replyingAuthor}: \n",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.teal[800],
                                            )),
                                        TextSpan(
                                            text: message.replyingMessage,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                    textAlign: currentUserId == message.authorId
                                        ? TextAlign.end
                                        : TextAlign.start,
                                  ),
                                  onTap: () {}),
                            ),
                          ),
                        ],
                      ),
                DragTarget<bool>(builder: (context, data, rejectedData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: currentUserId == message.authorId
                          ? Colors.teal[200]
                          : Colors.white,
                      borderRadius: currentUserId == message.authorId
                          ? BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                              bottomLeft: Radius.circular(50.0),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0),
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: currentUserId == message.authorId
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: ListTile(
                              title: Column(
                                crossAxisAlignment:
                                    currentUserId == message.authorId
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: <Widget>[
                                  message.imageUrl.isEmpty
                                      ? SizedBox.shrink()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        MessageImage(
                                                          message: message,
                                                        ))),
                                            child: Hero(
                                              tag: 'image ${message.id}',
                                              child: Container(
                                                height: width / 2,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: currentUserId ==
                                                          message.authorId
                                                      ? BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  30.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  30.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  30.0),
                                                        )
                                                      : BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  30.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  30.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  30.0),
                                                        ),
                                                  image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            message.imageUrl),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  Material(
                                    color: Colors.transparent,
                                    child: message.report.isNotEmpty
                                        ? BarsTextStrikeThrough(
                                            fontSize: 12,
                                            text: message.content,
                                          )
                                        : Text(
                                            message.content,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0),
                                          ),
                                  ),
                                  Text(
                                      timeago.format(
                                        message.timestamp.toDate(),
                                      ),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[700])),
                                ],
                              ),
                              leading: currentUserId == message.authorId
                                  ? message.liked
                                      ? IconButton(
                                          icon: Icon(message.liked
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined),
                                          color: message.liked
                                              ? Colors.pink
                                              : Colors.black,
                                          onPressed: () => () {},
                                        )
                                      : null
                                  : null,
                              trailing: currentUserId == message.authorId
                                  ? null
                                  : IconButton(
                                      icon: Icon(message.liked
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined),
                                      color: message.liked
                                          ? Colors.pink
                                          : Colors.grey,
                                      onPressed: () {
                                        HapticFeedback.heavyImpact();
                                        SystemSound.play(SystemSoundType.click);
                                        if (_isLiked) {
                                          setState(() {
                                            _unLikeMessage(message);
                                          });
                                        } else {
                                          setState(() {
                                            _likeMessage(message);
                                            _heartAnim = true;
                                          });

                                          Timer(Duration(milliseconds: 350),
                                              () {
                                            setState(() {
                                              _heartAnim = false;
                                            });
                                          });
                                        }
                                      },
                                    )),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }

  _displayImage() {
    final width = MediaQuery.of(context).size.width;

    return Provider.of<UserData>(context).postImage == null
        ? SizedBox.shrink()
        : ShakeTransition(
            curve: Curves.easeOutBack,
            axis: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isLoading
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10.0, top: 5),
                              child: SizedBox(
                                height: 2.0,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.teal[300]),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Icon(Icons.close),
                                iconSize: 30.0,
                                color: Colors.white,
                                onPressed: () {
                                  Provider.of<UserData>(context, listen: false)
                                      .setPostImage(null);
                                }),
                            Text(
                              _isLoading ? "Sending message" : "Ready to send",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          height: width / 2,
                          width: width,
                          image: FileImage(File(
                              Provider.of<UserData>(context).postImage!.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ]),
              ),
            ),
          );
  }

  _displayIsReplying() {
    return !_isreplying
        ? const SizedBox.shrink()
        : ShakeTransition(
            curve: Curves.easeOutBack,
            axis: Axis.vertical,
            child: Container(
              width: double.infinity,
              color: Colors.grey,
              child: ListTile(
                  leading: Container(
                    width: 5,
                    color: Colors.teal[900],
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      iconSize: 30.0,
                      color: Colors.teal[900],
                      onPressed: () {
                        _isreplying = false;
                        Provider.of<UserData>(context, listen: false)
                            .setPost8('');
                      }),
                  title: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Replying: \n",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.teal[900],
                            )),
                        TextSpan(
                            text: "Replying: \n",
                            style: TextStyle(
                              fontSize: 5,
                              color: Colors.transparent,
                            )),
                        TextSpan(
                            text: Provider.of<UserData>(
                              context,
                            ).post8,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  onTap: () {}),
            ),
          );
  }

  _buildUserAdvice() {
    return ShakeTransition(
      curve: Curves.easeOutBack,
      axis: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        child: IconTheme(
          data: IconThemeData(
            color:
                _isAdvicingUser ? Colors.blue : Theme.of(context).disabledColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            child: Column(
              children: [
                _displayIsReplying(),
                _displayImage(),
                _isLoading
                    ? SizedBox.shrink()
                    : Material(
                        color: Colors.white,
                        elevation: 10.0,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Provider.of<UserData>(context, listen: false)
                                      .post9
                                      .isEmpty
                                  ? Provider.of<UserData>(context,
                                                  listen: false)
                                              .messageCount <
                                          1
                                      ? SizedBox.shrink()
                                      : GestureDetector(
                                          onTap: _showSelectImageDialog,
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.grey,
                                          ),
                                        )
                                  : SizedBox.shrink(),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: TextField(
                                  focusNode: _focusNode,
                                  controller: _adviceControler,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: _adviceControler.text.length > 300
                                      ? 10
                                      : null,
                                  onChanged: (message) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost9(message),
                                  decoration: InputDecoration.collapsed(
                                    hintText: Provider.of<UserData>(context)
                                                .postImage ==
                                            null
                                        ? 'Message'
                                        : 'Add caption',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                                  child: CircularButton(
                                      color: Provider.of<UserData>(context,
                                                      listen: false)
                                                  .post9
                                                  .isNotEmpty ||
                                              Provider.of<UserData>(context)
                                                      .postImage !=
                                                  null
                                          ? Colors.teal[900]!
                                          : Colors.transparent,
                                      icon: Icon(
                                        Icons.send,
                                        color: Provider.of<UserData>(context,
                                                        listen: false)
                                                    .post9
                                                    .isNotEmpty ||
                                                Provider.of<UserData>(context,
                                                            listen: false)
                                                        .postImage !=
                                                    null
                                            ? Colors.white
                                            : ConfigBloc().darkModeOn
                                                ? Colors.grey
                                                : Theme.of(context)
                                                    .disabledColor,
                                      ),
                                      onPressed: () {
                                        Provider.of<UserData>(context,
                                                        listen: false)
                                                    .messageCount <
                                                1
                                            ? _submitMessageFirstMessage()
                                            : Provider.of<UserData>(context,
                                                            listen: false)
                                                        .postImage !=
                                                    null
                                                ? _submitMessageWithImage()
                                                : _submitMessageWithoutImage();
                                      })),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submitMessageFirstMessage() async {
    final AccountHolder currentUser =
        Provider.of<UserData>(context, listen: false).user!;
    HapticFeedback.mediumImpact();
    if (Provider.of<UserData>(context, listen: false).post9.isNotEmpty) {
      DatabaseService.firstChatMessage(
        currentUserId: widget.currentUserId,
        userId: widget.user.id!,
        messageInitiator: currentUser.userName!,
        restrictChat: false,
        imageUrl: '',
        MediaType: '',
        // chat: widget.chat!,
        replyingAuthor: '',
        replyingMessage: '',
        reportConfirmed: '',
        liked: '',
        message: _adviceControler.text,
      );
      _adviceControler.clear();
      Provider.of<UserData>(context, listen: false).setPost9('');
      setState(() {
        _isAdvicingUser = false;
        _isreplying = false;
      });

      Provider.of<UserData>(context, listen: false).setPost8('');
      Provider.of<UserData>(context, listen: false).setPost7('');
    }
  }

  _submitMessageWithImage() async {
    setState(() {
      _isLoading = true;
    });
    String imageUrl = await StorageService.uploadMessageImage(
        Provider.of<UserData>(context, listen: false).postImage!);
    HapticFeedback.mediumImpact();
    DatabaseService.chatMessage(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
      imageUrl: imageUrl,
      MediaType: 'Image',
      replyingAuthor: Provider.of<UserData>(context, listen: false).post7 ==
              widget.currentUserId
          ? 'Me'
          : widget.user.userName!,
      replyingMessage: Provider.of<UserData>(context, listen: false).post8,
      reportConfirmed: '',
      liked: '',
      message: _adviceControler.text.isEmpty ? "Image" : _adviceControler.text,
    );
    _adviceControler.clear();
    Provider.of<UserData>(context, listen: false).setPost9('');
    setState(() {
      _isAdvicingUser = false;
      _isreplying = false;
      imageUrl = '';
      _isLoading = false;
    });
    Provider.of<UserData>(context, listen: false).setPostImage(null);
    Provider.of<UserData>(context, listen: false).setPost8('');
    Provider.of<UserData>(context, listen: false).setPost7('');
    // }
  }

  _submitMessageWithoutImage() async {
    HapticFeedback.mediumImpact();
    if (Provider.of<UserData>(context, listen: false).post9.isNotEmpty) {
      DatabaseService.chatMessage(
        currentUserId: widget.currentUserId,
        userId: widget.user.id!,
        imageUrl: '',
        MediaType: '',
        // chat: widget.chat!,
        replyingAuthor: Provider.of<UserData>(context, listen: false).post7 ==
                widget.currentUserId
            ? 'Me'
            : widget.user.userName!,
        replyingMessage: Provider.of<UserData>(context, listen: false).post8,
        reportConfirmed: '',
        liked: '',
        message: _adviceControler.text,
      );
      _adviceControler.clear();
      Provider.of<UserData>(context, listen: false).setPost9('');
      setState(() {
        _isAdvicingUser = false;
        _isreplying = false;
      });

      Provider.of<UserData>(context, listen: false).setPost8('');
      Provider.of<UserData>(context, listen: false).setPost7('');
    }
  }

  _pop() {
    Navigator.pop(context);
    Provider.of<UserData>(context, listen: false).setPostImage(null);
    Provider.of<UserData>(context, listen: false).setPost8('');
    Provider.of<UserData>(context, listen: false).setPost7('');
    Provider.of<UserData>(context, listen: false).setMessageCount(0);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: ConfigBloc().darkModeOn
                    ? Color(0xFF1a1a1a)
                    : Colors.grey[300]!.withOpacity(0.1),
                child: Material(
                  color: Colors.transparent,
                  child: NestedScrollView(
                      controller: _hideAppBarController,
                      headerSliverBuilder: (context, innerBoxScrolled) => [],
                      body: SafeArea(
                        child: Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  height: _isVisible ? 60 : 0.0,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () => widget.fromProfile
                                              ? () {}
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          ChatDetails(
                                                            currentUserId: widget
                                                                .currentUserId,
                                                            chat: widget.chat!,
                                                            user: widget.user,
                                                            currentUser: Provider.of<
                                                                        UserData>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .user!,
                                                          ))),
                                          child: ListTile(
                                            leading: Container(
                                              width: 110,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Platform.isIOS
                                                        ? Icons.arrow_back_ios
                                                        : Icons.arrow_back),
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.white
                                                            : Colors.black,
                                                    onPressed: _pop,
                                                  ),
                                                  SizedBox(width: 20),
                                                  Hero(
                                                    tag: widget.user.id!,
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: CircleAvatar(
                                                        radius: 20.0,
                                                        backgroundColor:
                                                            ConfigBloc()
                                                                    .darkModeOn
                                                                ? Color(
                                                                    0xFF1a1a1a)
                                                                : Colors.grey
                                                                    .withOpacity(
                                                                        0.3),
                                                        backgroundImage: widget
                                                                .user
                                                                .profileImageUrl!
                                                                .isEmpty
                                                            ? AssetImage(
                                                                ConfigBloc()
                                                                        .darkModeOn
                                                                    ? 'assets/images/user_placeholder.png'
                                                                    : 'assets/images/user_placeholder2.png',
                                                              ) as ImageProvider
                                                            : CachedNetworkImageProvider(
                                                                widget.user
                                                                    .profileImageUrl!),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      child: Text(
                                                        widget.user.userName!,
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: ConfigBloc()
                                                                  .darkModeOn
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    widget.user.verified!
                                                            .isEmpty
                                                        ? SizedBox.shrink()
                                                        : Positioned(
                                                            top: 3,
                                                            right: 0,
                                                            child: Icon(
                                                              MdiIcons
                                                                  .checkboxMarkedCircle,
                                                              size: 11,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                                RichText(
                                                  textScaleFactor:
                                                      MediaQuery.of(context)
                                                          .textScaleFactor,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: widget.user
                                                              .profileHandle!,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.grey,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                widget.chat == null
                                    ? SizedBox.shrink()
                                    : AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: _isBlockedUser ||
                                                widget.user.disableChat! ||
                                                _restrictChat ||
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .user!
                                                    .disableChat!
                                            ? 60
                                            : 0.0,
                                        child: ListTile(
                                          leading: IconButton(
                                            icon: Icon(Icons.error_outline),
                                            iconSize: 25.0,
                                            color: widget.chat!.restrictChat
                                                ? Colors.red
                                                : Colors.transparent,
                                            onPressed: () => () {},
                                          ),
                                          title: Text(
                                              widget.user.disableChat!
                                                  ? 'Disabled chat'
                                                  : _restrictChat
                                                      ? 'Restricted chat'
                                                      : '',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.red,
                                              )),
                                          onTap: () => () {},
                                        ),
                                      )
                              ],
                            ),
                            widget.user.disableChat!
                                ? Padding(
                                    padding: EdgeInsets.all(40.0),
                                    child: Text(
                                      widget.user.userName! +
                                          ' is not interested in receiving new messages',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            StreamBuilder(
                              stream: usersRef
                                  .doc(widget.currentUserId)
                                  .collection('chats')
                                  .doc(widget.user.id)
                                  .collection('chatMessage')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.docs.length < 1) {
                                    return Expanded(
                                      child: Center(
                                        child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: "What's\nUp",
                                                  style: TextStyle(
                                                    fontSize: 40,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              TextSpan(
                                                  text: "?",
                                                  style: TextStyle(
                                                    fontSize: 40,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  return Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Scrollbar(
                                        child: CustomScrollView(
                                            controller: _hideButtonController,
                                            reverse: true,
                                            slivers: [
                                          SliverList(
                                            delegate:
                                                SliverChildBuilderDelegate(
                                              (context, index) {
                                                ChatMessage message =
                                                    ChatMessage.fromDoc(snapshot
                                                        .data.docs[index]);
                                                SchedulerBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  Provider.of<UserData>(context,
                                                          listen: false)
                                                      .setMessageCount(snapshot
                                                          .data.docs.length);
                                                });

                                                return _buildBlogComment(
                                                  message,
                                                );
                                              },
                                              childCount:
                                                  snapshot.data.docs.length,
                                            ),
                                          )
                                        ])),
                                  ));
                                }
                                return Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            ),
                            _isBlockedUser ||
                                    widget.user.disableChat! ||
                                    _restrictChat ||
                                    Provider.of<UserData>(context,
                                            listen: false)
                                        .user!
                                        .disableChat!
                                ? SizedBox.shrink()
                                : _buildUserAdvice(),
                          ],
                        )),
                      )),
                ),
              ),
              _heartAnim
                  ? Animator(
                      duration: Duration(milliseconds: 300),
                      tween: Tween(begin: 0.5, end: 1.4),
                      curve: Curves.elasticOut,
                      builder: (context, anim2, child) => Transform.scale(
                            scale: anim2.value as double,
                            child: const Icon(
                              Icons.favorite,
                              size: 150.0,
                              color: Colors.pink,
                            ),
                          ))
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
