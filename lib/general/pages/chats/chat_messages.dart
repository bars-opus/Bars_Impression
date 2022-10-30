// ignore_for_file: unnecessary_null_comparison

import 'package:bars/general/models/user_author_model.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatMessageScreen extends StatefulWidget {
  final AccountHolderAuthor user;
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
  bool _isBlockingUser = false;
  int _chatMessageCount = 0;
  bool _isLoading = false;
  bool _restrictChat = false;
  late ScrollController _hideButtonController;
  late ScrollController _hideAppBarController;
  // var _isVisible;
  final FocusNode _focusNode = FocusNode();
  bool _heartAnim = false;

  bool _dragging = false;

  void initState() {
    super.initState();
    _setupIsBlockedUser();
    _setupIsBlockingUser();
    _setUpMessageCount();
    // _isVisible = true;
    _restrictChat = widget.chat == null ? false : widget.chat!.restrictChat;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _clear();
      Provider.of<UserData>(context, listen: false).setPost9('');
      Provider.of<UserData>(context, listen: false).setIsLoading(false);
      Provider.of<UserData>(context, listen: false).setBool1(true);
    });

    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (mounted) {
          // setState(() {
          //   _isVisible = true;
          // });
          Provider.of<UserData>(context, listen: false).setBool1(true);
        }
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (mounted) {
          Provider.of<UserData>(context, listen: false).setBool1(false);
          // setState(() {
          //   _isVisible = false;
          // });
        }
      }
    });
    _hideAppBarController = new ScrollController();
    _hideAppBarController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (mounted) {
          // setState(() {
          //   _isVisible = true;
          // });
          Provider.of<UserData>(context, listen: false).setBool1(true);
        }
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (mounted) {
          // setState(() {
          //   _isVisible = false;
          // });
          Provider.of<UserData>(context, listen: false).setBool1(false);
        }
      }
    });
  }

  _setUpMessageCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numChatsMessages(
      currentUserId,
      widget.user.id!,
    ).listen((chatMessageCount) {
      if (mounted) {
        setState(() {
          _chatMessageCount = chatMessageCount;
        });
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

  _setupIsBlockingUser() async {
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
    HapticFeedback.mediumImpact();
    DatabaseService.deleteMessage(
        currentUserId: widget.currentUserId,
        userId: widget.user.id!,
        message: message);
    message.mediaUrl.isEmpty
        ? () {}
        : FirebaseStorage.instance
            .refFromURL(message.mediaUrl)
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
    HapticFeedback.heavyImpact();
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
                color: Colors.black,
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
            title: Text(
              'Pick image',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Camera',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImage();
                  },
                ),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImage();
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

  _displayMessageImage(ChatMessage message, String currentUserId) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MessageImage(
                      message: message,
                    ))),
        child: Hero(
          tag: 'image ${message.id}',
          child: Container(
            height: width / 2,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: currentUserId == message.authorId
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
              image: DecorationImage(
                image: CachedNetworkImageProvider(message.mediaUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildMessage(
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
                ? _deleteMessage(
                    message,
                  )
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
                return Provider.of<UserData>(context, listen: false).bool1
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
                        // _isVisible = true;
                        Provider.of<UserData>(context, listen: false)
                            .setBool1(true);
                      });
              }
            }),
      ],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Draggable(
          onDragCompleted: () {
            HapticFeedback.heavyImpact();
            return Provider.of<UserData>(context, listen: false).bool1
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
                    // _isVisible = true;
                    Provider.of<UserData>(context, listen: false)
                        .setBool1(true);
                  });
          },
          affinity: Axis.horizontal,
          axis: Axis.horizontal,
          feedback: Padding(
            padding: EdgeInsets.only(
                top: message.mediaUrl.isEmpty ? 8.0 : width / 4),
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
                const SizedBox(
                  height: 5,
                ),
                message.replyingMessage.isEmpty
                    ? const SizedBox.shrink()
                    : _repliedMessageContent(message, currentUserId),
                DragTarget<bool>(builder: (context, data, rejectedData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Provider.of<UserData>(context, listen: false)
                                      .postImage !=
                                  null ||
                              _isreplying
                          ? Colors.grey
                          : currentUserId == message.authorId
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
                                  message.mediaUrl.isEmpty
                                      ? const SizedBox.shrink()
                                      : _displayMessageImage(
                                          message, currentUserId),
                                  Material(
                                    color: Colors.transparent,
                                    child: message.report.isNotEmpty
                                        ? BarsTextStrikeThrough(
                                            fontSize: 12,
                                            text: message.content,
                                          )
                                        : HyperLinkText(
                                            from: 'Message',
                                            text: message.content,
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

  _buildReceivedContentMessage(
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
                ? _deleteMessage(
                    message,
                  )
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
                return Provider.of<UserData>(context, listen: false).bool1
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
                        // _isVisible = true;
                        Provider.of<UserData>(context, listen: false)
                            .setBool1(true);
                      });
              }
            }),
      ],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Draggable(
          onDragCompleted: () {
            HapticFeedback.heavyImpact();
            return Provider.of<UserData>(context, listen: false).bool1
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
                    // _isVisible = true;
                    Provider.of<UserData>(context, listen: false)
                        .setBool1(true);
                  });
          },
          affinity: Axis.horizontal,
          axis: Axis.horizontal,
          feedback: Padding(
            padding: EdgeInsets.only(
                top: message.mediaUrl.isEmpty ? 8.0 : width / 4),
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
                const SizedBox(
                  height: 5,
                ),
                DragTarget<bool>(builder: (context, data, rejectedData) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: currentUserId == message.authorId
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ViewSentContent(
                                        contentId: message.sendContentId,
                                        contentType: message.sendPostType,
                                      ))),
                          title: Column(
                            crossAxisAlignment:
                                currentUserId == message.authorId
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: <Widget>[
                              Material(
                                color: Colors.transparent,
                                child: Text(
                                  message.sendContentTitle,
                                  style: TextStyle(color: Colors.blue),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          leading: message.sendPostType.startsWith('Forum')
                              ? null
                              : currentUserId != message.authorId
                                  ? Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: message.mediaUrl.isEmpty
                                          ? Icon(
                                              Icons.account_circle_rounded,
                                              color: Colors.white,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: message.mediaUrl,
                                              height: 40.0,
                                              width: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                    )
                                  : null,
                          trailing: message.sendPostType.startsWith('Forum')
                              ? null
                              : currentUserId != message.authorId
                                  ? null
                                  : Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: message.mediaUrl.isEmpty
                                          ? Icon(
                                              Icons.account_circle_rounded,
                                              color: Colors.white,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: message.mediaUrl,
                                              height: 40.0,
                                              width: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment:
                                  currentUserId == message.authorId
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: <Widget>[
                                Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      message.content,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.blueGrey,
                                      ),
                                      textAlign:
                                          currentUserId == message.authorId
                                              ? TextAlign.right
                                              : TextAlign.left,
                                    )),
                                Text(
                                    timeago.format(
                                      message.timestamp.toDate(),
                                    ),
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey[700])),
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

                                        Timer(Duration(milliseconds: 350), () {
                                          setState(() {
                                            _heartAnim = false;
                                          });
                                        });
                                      }
                                    },
                                  ),
                          ),
                        ),
                        Divider(),
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

  _repliedMessageContent(ChatMessage message, String currentUserId) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: currentUserId == message.authorId
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
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
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "replied:\n${message.replyingAuthor}: \n",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          )),
                      TextSpan(
                          text: message.replyingMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.teal[800],
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
    );
  }

  _displayImage() {
    final width = MediaQuery.of(context).size.width;

    return Provider.of<UserData>(context).postImage == null
        ? const SizedBox.shrink()
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
                              Provider.of<UserData>(context, listen: false)
                                  .postImage!
                                  .path)),
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
                    ? const SizedBox.shrink()
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
                                      ? const SizedBox.shrink()
                                      : GestureDetector(
                                          onTap: _showSelectImageDialog,
                                          child: Icon(
                                            MdiIcons.camera,
                                            color: Colors.grey,
                                          ),
                                        )
                                  : const SizedBox.shrink(),
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
                                        HapticFeedback.mediumImpact();

                                        // Provider.of<UserData>(context,
                                        //                 listen: false)
                                        //             .messageCount <
                                        //         1
                                        _chatMessageCount < 1
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
        author: Provider.of<UserData>(context, listen: false).user!,
        currentUserId: widget.currentUserId,
        userId: widget.user.id!,
        messageInitiator: currentUser.userName!,
        restrictChat: false,
        mediaUrl: '',
        sendContentId: '',
        mediaType: '',
        replyingAuthor: '',
        sendContentTitle: '',
        replyingMessage: '',
        reportConfirmed: '',
        liked: '',
        message: _adviceControler.text,
        sendPostType: '',
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
      mediaUrl: imageUrl,
      mediaType: 'Image',
      replyingAuthor: Provider.of<UserData>(context, listen: false).post7 ==
              widget.currentUserId
          ? 'Me'
          : widget.user.userName!,
      replyingMessage: Provider.of<UserData>(context, listen: false).post8,
      reportConfirmed: '',
      sendContentTitle: '',
      liked: '',
      message: _adviceControler.text.isEmpty ? "Image" : _adviceControler.text,
      sendContentId: '',
      sendPostType: '',
      author: Provider.of<UserData>(context, listen: false).user!,
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
  }

  _submitMessageWithoutImage() async {
    HapticFeedback.mediumImpact();
    if (Provider.of<UserData>(context, listen: false).post9.isNotEmpty) {
      DatabaseService.chatMessage(
        author: Provider.of<UserData>(context, listen: false).user!,
        currentUserId: widget.currentUserId,
        userId: widget.user.id!,
        mediaUrl: '',
        sendContentTitle: '',
        mediaType: '',
        replyingAuthor: Provider.of<UserData>(context, listen: false).post7 ==
                widget.currentUserId
            ? 'Me'
            : widget.user.userName!,
        replyingMessage: Provider.of<UserData>(context, listen: false).post8,
        reportConfirmed: '',
        liked: '',
        message: _adviceControler.text,
        sendContentId: '',
        sendPostType: '',
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
                                  height: Provider.of<UserData>(
                                    context,
                                  ).bool1
                                      ? 60
                                      : 0.0,
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
                                                        ? const SizedBox
                                                            .shrink()
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
                                    ? const SizedBox.shrink()
                                    : AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: _isBlockedUser ||
                                                _isBlockingUser ||
                                                widget.chat!.disableChat ||
                                                _restrictChat ||
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .user!
                                                    .disableChat!
                                            ? 60
                                            : 0.0,
                                        child: ListTile(
                                          leading: IconButton(
                                            icon: Icon(Icons.info_outline),
                                            iconSize: 25.0,
                                            color: widget.chat!.restrictChat ||
                                                    _restrictChat ||
                                                    _isBlockingUser ||
                                                    widget.chat!.disableChat
                                                ? Colors.grey
                                                : Colors.transparent,
                                            onPressed: () => () {},
                                          ),
                                          title: Text(
                                              widget.chat!.disableChat
                                                  ? 'Disabled chat'
                                                  : _restrictChat
                                                      ? 'Restricted chat'
                                                      : _isBlockingUser
                                                          ? 'Unblock to send message'
                                                          : widget.chat!
                                                                  .disableChat
                                                              ? widget.user
                                                                      .userName! +
                                                                  ' is not interested in receiving new messages'
                                                              : '',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey,
                                              )),
                                          onTap: () => () {},
                                        ),
                                      )
                              ],
                            ),
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

                                                return message
                                                        .sendContentId.isEmpty
                                                    ? _buildMessage(
                                                        message,
                                                      )
                                                    : _buildReceivedContentMessage(
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
                                    _isBlockingUser ||
                                    widget.chat!.disableChat ||
                                    _restrictChat ||
                                    Provider.of<UserData>(context,
                                            listen: false)
                                        .user!
                                        .disableChat!
                                ? const SizedBox.shrink()
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
                  : const SizedBox.shrink(),
              _isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black87,
                      child: Text(
                        'Sending..',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
