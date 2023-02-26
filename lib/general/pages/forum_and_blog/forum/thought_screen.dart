import 'package:bars/utilities/exports.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ThoughtsScreen extends StatefulWidget {
  final Forum forum;
  final int thoughtCount;
  final String currentUserId;
  final String feed;

  ThoughtsScreen(
      {required this.forum,
      required this.thoughtCount,
      required this.feed,
      required this.currentUserId});

  @override
  _ThoughtsScreenState createState() => _ThoughtsScreenState();
}

class _ThoughtsScreenState extends State<ThoughtsScreen> {
  final TextEditingController _thoughtController = TextEditingController();
  bool _isThinking = false;
  bool _isBlockedUser = false;
  late ScrollController _hideButtonController;
  late ScrollController _hideButtonController2;
  late ScrollController _hideAppBarController;
  int _thoughtCount = 0;
  bool _displayWarning = false;
  bool _showInfo = false;
  bool _isLoading = false;

  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  var _isVisible;

  void initState() {
    super.initState();
    _setUpThoughts();
    _isVisible = true;
    _setupIsBlockedUser();
    _kpi();
    _displayWarning = widget.forum.report.isNotEmpty ? true : false;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setPost9('');
      Provider.of<UserData>(context, listen: false).setPostImage(null);
    });

    _hideButtonController2 = new ScrollController();
    _hideButtonController2.addListener(() {
      if (_hideButtonController2.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
      if (_hideButtonController2.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
    });

    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
    });
    _hideAppBarController = new ScrollController();
    _hideAppBarController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  _kpi() {
    kpiStatisticsRef
        .doc('0SuQxtu52SyYjhOKiLsj')
        .update({'forum': FieldValue.increment(1)});
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.forum.authorId,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
  }

  _setUpThoughts() async {
    DatabaseService.numThoughts(widget.forum.id).listen((thoughtCount) {
      if (mounted) {
        setState(() {
          _thoughtCount = thoughtCount;
          Timer(Duration(seconds: 10), () {
            if (mounted) {
              // setState(() {
              _showInfo = true;
              __setShowInfo();
              // });
            }
          });
        });
      }
    });
  }

  __setShowInfo() async {
    if (_showInfo) {
      Timer(Duration(seconds: 3), () {
        if (mounted) {
          // setState(() {
          _showInfo = false;
          // });
        }
      });
    }
  }

  // _handleImage() async {
  //   HapticFeedback.heavyImpact();
  //   final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
  //   if (file == null) return;

  //   if (mounted) {
  //     Provider.of<UserData>(context, listen: false).setPostImage(file as File);
  //   }
  // }

  // Future<File> _cropImage(File imageFile) async {
  //   File? croppedImage = await ImageCropper().cropImage(
  //     sourcePath: imageFile.path,
  //   );
  //   return croppedImage!;
  // }

  // _showSelectImageDialog() {
  //   HapticFeedback.heavyImpact();
  //   return Platform.isIOS ? _iosBottomSheet() : _androidDialog(context);
  // }

  // _iosBottomSheet() {
  //   showCupertinoModalPopup(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CupertinoActionSheet(
  //           title: Text(
  //             'Import Content',
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.black,
  //             ),
  //           ),
  //           actions: <Widget>[
  //             CupertinoActionSheetAction(
  //               child: Text(
  //                 'User',
  //                 style: TextStyle(
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (_) => ImportContentSearchUser(
  //                               currentUserId: widget.currentUserId,
  //                               forum: widget.forum,
  //                             )));
  //               },
  //             ),
  //             CupertinoActionSheetAction(
  //               child: Text(
  //                 'Mood punched',
  //                 style: TextStyle(
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (_) => ImportContentSearchPost(
  //                               currentUserId: widget.currentUserId,
  //                               forum: widget.forum,
  //                             )));
  //               },
  //             ),
  //             CupertinoActionSheetAction(
  //               child: Text(
  //                 'Event',
  //                 style: TextStyle(
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (_) => ImportContentSearchEvent(
  //                               currentUserId: widget.currentUserId,
  //                               forum: widget.forum,
  //                             )));
  //               },
  //             ),
  //             CupertinoActionSheetAction(
  //               child: Text(
  //                 'Forum',
  //                 style: TextStyle(
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (_) => ImportContentSearchForum(
  //                               currentUserId: widget.currentUserId,
  //                               forum: widget.forum,
  //                             )));
  //               },
  //             ),
  //           ],
  //           cancelButton: CupertinoActionSheetAction(
  //             child: Text(
  //               'Cancle',
  //               style: TextStyle(
  //                 color: Colors.red,
  //               ),
  //             ),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //         );
  //       });
  // }

  // _androidDialog(BuildContext parentContext) {
  //   return showDialog(
  //       context: parentContext,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: Text(
  //             'Import Content',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //             textAlign: TextAlign.center,
  //           ),
  //           children: <Widget>[
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'User',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, color: Colors.blue),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (_) => ImportContentSearchUser(
  //                                 currentUserId: widget.currentUserId,
  //                                 forum: widget.forum,
  //                               )));
  //                 },
  //               ),
  //             ),
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'Mood punched',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, color: Colors.blue),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (_) => ImportContentSearchPost(
  //                                 currentUserId: widget.currentUserId,
  //                                 forum: widget.forum,
  //                               )));
  //                 },
  //               ),
  //             ),
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'Event',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, color: Colors.blue),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (_) => ImportContentSearchEvent(
  //                                 forum: widget.forum,
  //                                 currentUserId: widget.currentUserId,
  //                               )));
  //                 },
  //               ),
  //             ),
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'Forum',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, color: Colors.blue),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (_) => ImportContentSearchForum(
  //                                 currentUserId: widget.currentUserId,
  //                                 forum: widget.forum,
  //                               )));
  //                 },
  //               ),
  //             ),
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'Cancel',
  //                 ),
  //                 onPressed: () => Navigator.pop(context),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  // _displayImage() {
  //   final width = MediaQuery.of(context).size.width;

  //   return Provider.of<UserData>(context).postImage == null
  //       ? const SizedBox.shrink()
  //       : ShakeTransition(
  //           curve: Curves.easeOutBack,
  //           axis: Axis.vertical,
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 5.0),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[800],
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           IconButton(
  //                               icon: Icon(Icons.close),
  //                               iconSize: 30.0,
  //                               color: Colors.white,
  //                               onPressed: () {
  //                                 Provider.of<UserData>(context, listen: false)
  //                                     .setPostImage(null);
  //                               }),
  //                           Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Text(
  //                               "You need to write a thought\n in order to send a media.",
  //                               style: TextStyle(
  //                                 fontSize: 12.0,
  //                                 color: Colors.white,
  //                               ),
  //                               textAlign: TextAlign.end,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Image(
  //                         height: width / 2,
  //                         width: width,
  //                         image: FileImage(File(
  //                             Provider.of<UserData>(context, listen: false)
  //                                 .postImage!
  //                                 .path)),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ]),
  //             ),
  //           ),
  //         );
  // }

  _buildThoughtTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: _isVisible ? null : 0.0,
        child: IconTheme(
          data: IconThemeData(
            color: _isThinking ? Colors.blue : Theme.of(context).disabledColor,
          ),
          child: Container(
            child: Material(
              color: Colors.white,
              elevation: 10.0,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  children: [
                    // _displayImage(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Provider.of<UserData>(context, listen: false)
                        //         .post9
                        //         .isNotEmpty
                        //     ? const SizedBox.shrink()
                        //     : GestureDetector(
                        //         onTap: _handleImage,
                        //         child: Icon(
                        //           Icons.image,
                        //           color: Colors.grey,
                        //         ),
                        //       ),
                        // Provider.of<UserData>(context, listen: false)
                        //         .post9
                        //         .isNotEmpty
                        //     ? const SizedBox.shrink()
                        //     : const SizedBox(
                        //         width: 20,
                        //       ),
                        // Provider.of<UserData>(context, listen: false)
                        //         .post9
                        //         .isNotEmpty
                        //     ? const SizedBox.shrink()
                        //     : GestureDetector(
                        //         onTap: _showSelectImageDialog,
                        //         child: Icon(
                        //           Icons.add,
                        //           color: Colors.grey,
                        //         ),
                        //       ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            autofocus: widget.thoughtCount == 0 ? true : false,
                            controller: _thoughtController,
                            keyboardType: TextInputType.multiline,
                            maxLines: _thoughtController.text.length > 300
                                ? 10
                                : null,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (thought) =>
                                Provider.of<UserData>(context, listen: false)
                                    .setPost9(thought),
                            decoration: InputDecoration.collapsed(
                              hintText: 'What do you think?...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          child: CircularButton(
                            color: Provider.of<UserData>(context, listen: false)
                                    .post9
                                    .isNotEmpty
                                ? Colors.blue
                                : Colors.transparent,
                            icon: Icon(
                              Icons.send,
                              color:
                                  Provider.of<UserData>(context, listen: false)
                                          .post9
                                          .isNotEmpty
                                      ? Colors.white
                                      : !_isVisible
                                          ? Colors.transparent
                                          : ConfigBloc().darkModeOn
                                              ? Color(0xFF1a1a1a)
                                              : Theme.of(context).disabledColor,
                            ),
                            onPressed: () async {
                              HapticFeedback.mediumImpact();
                              if (Provider.of<UserData>(context, listen: false)
                                  .post9
                                  .isNotEmpty) {
                                if (Provider.of<UserData>(context,
                                            listen: false)
                                        .postImage !=
                                    null) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  String imageUrl =
                                      await StorageService.uploadThoughtImage(
                                          Provider.of<UserData>(context,
                                                  listen: false)
                                              .postImage!);
                                  DatabaseService.thoughtOnForum(
                                    currentUserId: currentUserId,
                                    forum: widget.forum,
                                    thought: _thoughtController.text,
                                    reportConfirmed: '',
                                    user: Provider.of<UserData>(context,
                                            listen: false)
                                        .user!,
                                    isThoughtLiked: false,
                                    mediaType: 'image',
                                    mediaUrl: imageUrl,
                                    imported: false,
                                  );
                                  Provider.of<UserData>(context, listen: false)
                                      .setPost9('');
                                  _thoughtController.clear();
                                  setState(() {
                                    _isThinking = false;
                                  });
                                  kpiStatisticsRef
                                      .doc('0SuQxtu52SyYjhOKiLsj')
                                      .update({
                                    'thoughtSent': FieldValue.increment(1)
                                  });
                                  Provider.of<UserData>(context, listen: false)
                                      .setPost8('');
                                  Provider.of<UserData>(context, listen: false)
                                      .setPost7('');
                                  Provider.of<UserData>(context, listen: false)
                                      .setPost6('');
                                  Provider.of<UserData>(context, listen: false)
                                      .setPostImage(null);

                                  setState(() {
                                    _isLoading = false;
                                  });
                                } else {
                                  DatabaseService.thoughtOnForum(
                                    imported: false,
                                    currentUserId: currentUserId,
                                    forum: widget.forum,
                                    thought: _thoughtController.text,
                                    reportConfirmed: '',
                                    user: Provider.of<UserData>(context,
                                            listen: false)
                                        .user!,
                                    isThoughtLiked: false,
                                    mediaType: '',
                                    mediaUrl: '',
                                  );
                                  Provider.of<UserData>(context, listen: false)
                                      .setPost9('');
                                  _thoughtController.clear();
                                  setState(() {
                                    _isThinking = false;
                                  });
                                  kpiStatisticsRef
                                      .doc('0SuQxtu52SyYjhOKiLsj')
                                      .update({
                                    'thoughtSent': FieldValue.increment(1)
                                  });
                                  Provider.of<UserData>(context, listen: false)
                                      .setPost8('');
                                  Provider.of<UserData>(context, listen: false)
                                      .setPost7('');
                                  Provider.of<UserData>(context, listen: false)
                                      .setPost6('');
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _pop() {
    Navigator.pop(context);
    Provider.of<UserData>(context, listen: false).setPost9('');
    Provider.of<UserData>(context, listen: false).setPost8('');
    Provider.of<UserData>(context, listen: false).setPost7('');
    Provider.of<UserData>(context, listen: false).setPost6('');
    Provider.of<UserData>(context, listen: false).setPostImage(null);
  }

  _setContentWarning() {
    if (mounted) {
      setState(() {
        _displayWarning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return _displayWarning == true
        ? GestureDetector(
            onVerticalDragUpdate: (details) {},
            onHorizontalDragUpdate: (details) {
              if (details.delta.direction <= 0) {
                Navigator.pop(context);
              }
            },
            child: Material(
              child: Stack(children: <Widget>[
                ContentWarning(
                  report: widget.forum.report,
                  onPressed: _setContentWarning,
                  imageUrl: '',
                ),
                _displayWarning == true
                    ? Positioned(
                        top: 50,
                        left: 10,
                        child: IconButton(
                          icon: Icon(Platform.isIOS
                              ? Icons.arrow_back_ios
                              : Icons.arrow_back),
                          color: ConfigBloc().darkModeOn
                              ? Color(0xFF1a1a1a)
                              : Color(0xFFe8f3fa),
                          onPressed: _pop,
                        ),
                      )
                    : const SizedBox.shrink()
              ]),
            ),
          )
        : ResponsiveScaffold(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) {},
                        onHorizontalDragUpdate: (details) {
                          if (details.delta.direction <= 0) {
                            Navigator.pop(context);
                          }
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: NestedScrollView(
                              controller: _hideAppBarController,
                              headerSliverBuilder:
                                  (context, innerBoxScrolled) => [],
                              body: Container(
                                  color: ConfigBloc().darkModeOn
                                      ? Color(0xFF1a1a1a)
                                      : Color(0xFFf2f2f2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: _isVisible ? 230 : 0.0,
                                        child: Material(
                                          color: Colors.blue,
                                          child: SingleChildScrollView(
                                            child: GestureDetector(
                                              onLongPress: () => Navigator.of(
                                                      context)
                                                  .push(PageRouteBuilder(
                                                      transitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  500),
                                                      pageBuilder: (context,
                                                          animation, _) {
                                                        HapticFeedback
                                                            .heavyImpact();

                                                        return FadeTransition(
                                                          opacity: animation,
                                                          child: ExploreForums(
                                                            currentUserId: widget
                                                                .currentUserId,
                                                            feed: widget.feed,
                                                            forum: widget.forum,
                                                          ),
                                                        );
                                                      })),
                                              child: Container(
                                                color: Colors.blue,
                                                width: width,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10.0, 30, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0,
                                                                      top: 8.0,
                                                                      bottom:
                                                                          8.0),
                                                              child: IconButton(
                                                                icon: Icon(Platform
                                                                        .isIOS
                                                                    ? Icons
                                                                        .arrow_back_ios
                                                                    : Icons
                                                                        .arrow_back),
                                                                color: ConfigBloc()
                                                                        .darkModeOn
                                                                    ? Color(
                                                                        0xFF1a1a1a)
                                                                    : Color(
                                                                        0xFFe8f3fa),
                                                                onPressed: _pop,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Forum',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color: ConfigBloc()
                                                                      .darkModeOn
                                                                  ? Color(
                                                                      0xFF1a1a1a)
                                                                  : Color(
                                                                      0xFFe8f3fa),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                                Icons.info),
                                                            iconSize: 30.0,
                                                            color: Colors
                                                                .transparent,
                                                            onPressed: () {},
                                                          ),
                                                        ],
                                                      ),
                                                      Hero(
                                                        tag: 'title' +
                                                            widget.forum.id
                                                                .toString(),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: Text(
                                                            widget.forum.title,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              color: ConfigBloc()
                                                                      .darkModeOn
                                                                  ? Color(
                                                                      0xFF1a1a1a)
                                                                  : Color(
                                                                      0xFFe8f3fa),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 3.0,
                                                      ),
                                                      Hero(
                                                        tag: 'subTitle' +
                                                            widget.forum.id
                                                                .toString(),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: Text(
                                                            widget
                                                                .forum.subTitle,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 12.0,
                                                              color: ConfigBloc()
                                                                      .darkModeOn
                                                                  ? Color(
                                                                      0xFF1a1a1a)
                                                                  : Color(
                                                                      0xFFe8f3fa),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Container(
                                                        height: 70,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () => Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => ProfileScreen(
                                                                                    currentUserId: Provider.of<UserData>(context).currentUserId!,
                                                                                    userId: widget.forum.authorId,
                                                                                    user: null,
                                                                                  ))),
                                                                      child:
                                                                          RichText(
                                                                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(
                                                                            0.5,
                                                                            2.0),
                                                                        text:
                                                                            TextSpan(
                                                                          children: [
                                                                            TextSpan(
                                                                              text: 'Tap to view ' + widget.forum.authorName + "\'s profile ",
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFe8f3fa),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                    RichText(
                                                                      textScaleFactor: MediaQuery.of(
                                                                              context)
                                                                          .textScaleFactor
                                                                          .clamp(
                                                                              0.5,
                                                                              2.0),
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: 'thoughts:    ',
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFe8f3fa),
                                                                              )),
                                                                          TextSpan(
                                                                              text: NumberFormat.compact().format(_thoughtCount),
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFe8f3fa),
                                                                              )),
                                                                        ],
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          5.0,
                                                                    ),
                                                                    Text(
                                                                        timeago
                                                                            .format(
                                                                          widget
                                                                              .forum
                                                                              .timestamp!
                                                                              .toDate(),
                                                                        ),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color: ConfigBloc().darkModeOn
                                                                              ? Color(0xFF1a1a1a)
                                                                              : Color(0xFFe8f3fa),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Column(
                                                              children: [
                                                                _showInfo
                                                                    ? const SizedBox
                                                                        .shrink()
                                                                    : Container(
                                                                        width:
                                                                            50,
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            Icons.center_focus_strong,
                                                                            color: ConfigBloc().darkModeOn
                                                                                ? Colors.black
                                                                                : Colors.white,
                                                                          ),
                                                                          onPressed: () => Navigator.of(context).push(PageRouteBuilder(
                                                                              transitionDuration: const Duration(milliseconds: 500),
                                                                              pageBuilder: (context, animation, _) {
                                                                                return FadeTransition(
                                                                                  opacity: animation,
                                                                                  child: ExploreForums(
                                                                                    feed: widget.feed,
                                                                                    currentUserId: widget.currentUserId,
                                                                                    forum: widget.forum,
                                                                                  ),
                                                                                );
                                                                              })),
                                                                        ),
                                                                      ),
                                                                AnimatedInfoWidget(
                                                                  buttonColor:
                                                                      Colors
                                                                          .white,
                                                                  text:
                                                                      'Tap and hold\nto explore more forums.',
                                                                  requiredBool:
                                                                      _showInfo,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.blue,
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(0, -5),
                                                  blurRadius: 2.0,
                                                  spreadRadius: 2.0,
                                                )
                                              ],
                                              color: ConfigBloc().darkModeOn
                                                  ? Color(0xFF1a1a1a)
                                                  : Color(0xFFf2f2f2),
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(30.0),
                                                  topRight:
                                                      Radius.circular(30.0))),
                                        ),
                                      ),
                                      StreamBuilder(
                                        stream: thoughtsRef
                                            .doc(widget.forum.id)
                                            .collection('forumThoughts')
                                            .orderBy(
                                              'timestamp',
                                              descending: true,
                                            )
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (!snapshot.hasData) {
                                            return _thoughtCount == 0
                                                ? Expanded(
                                                    child: Center(
                                                      child: NoContents(
                                                        icon: (MdiIcons.brain),
                                                        title:
                                                            'No thoughts on this forum yet,',
                                                        subTitle:
                                                            'You can be the first person to tell us what you think about this forum, ',
                                                      ),
                                                    ),
                                                  )
                                                : Expanded(
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                          }
                                          return _thoughtCount == 0
                                              ? Expanded(
                                                  child: Center(
                                                    child: NoContents(
                                                      icon: (MdiIcons.brain),
                                                      title:
                                                          'No thoughts on this forum yet,',
                                                      subTitle:
                                                          'You can be the first person to tell us what you think about this forum, ',
                                                    ),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Scrollbar(
                                                      child: CustomScrollView(
                                                          controller:
                                                              _hideButtonController,
                                                          reverse: true,
                                                          slivers: [
                                                      SliverList(
                                                        delegate:
                                                            SliverChildBuilderDelegate(
                                                          (context, index) {
                                                            Thought thought =
                                                                Thought.fromDoc(
                                                                    snapshot.data
                                                                            .docs[
                                                                        index]);
                                                            return ThoughtView(
                                                              currentUserId: widget
                                                                  .currentUserId,
                                                              forum:
                                                                  widget.forum,
                                                              thought: thought,
                                                              isBlockedUser:
                                                                  _isBlockedUser,
                                                            );
                                                          },
                                                          childCount: snapshot
                                                              .data.docs.length,
                                                        ),
                                                      )
                                                    ])));
                                        },
                                      ),
                                      _isBlockedUser
                                          ? const SizedBox.shrink()
                                          : Provider.of<UserData>(context,
                                                      listen: false)
                                                  .user!
                                                  .score!
                                                  .isNegative
                                              ? const SizedBox.shrink()
                                              : _buildThoughtTF(),
                                    ],
                                  ))),
                        ),
                      ),
                    ),
                  ),
                  _isLoading
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black87,
                          child: Center(
                            child: Text(
                              'Sending..',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          );
  }
}
