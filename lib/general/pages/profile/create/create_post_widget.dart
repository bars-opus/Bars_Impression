// ignore_for_file: unnecessary_null_comparison

import 'dart:ui';
import 'package:bars/utilities/exports.dart';
import 'package:blurhash/blurhash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

// ignore: must_be_immutable
class CreatePostWidget extends StatefulWidget {
  File? image;
  String artist;
  String caption;
  String punch;
  String hashTag;
  String imageUrl;
  String musicLink;
  final bool isEditting;
  final Post? post;

  CreatePostWidget(
      {required this.image,
      required this.artist,
      required this.caption,
      required this.imageUrl,
      required this.hashTag,
      required this.punch,
      required this.musicLink,
      required this.isEditting,
      required this.post});

  @override
  _CreatePostWidgetState createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget>
    with AutomaticKeepAliveClientMixin<CreatePostWidget> {
  Future<QuerySnapshot>? _users;
  final _formKey = GlobalKey<FormState>();
  int _index = 0;
  bool _isLoading = false;
  bool _showSheet = false;
  int _show = 0;
  String selectedValue = '';
  String _hashTag = '';
  late PageController _pageController;

  final musiVideoLink =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

  @override
  void initState() {
    _hashTag = widget.hashTag;
    selectedValue = _hashTag.isEmpty ? values.last : _hashTag;

    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setPost1(widget.artist);
      Provider.of<UserData>(context, listen: false).setPost2(widget.musicLink);
      Provider.of<UserData>(context, listen: false).setPost3(widget.punch);
      Provider.of<UserData>(context, listen: false).setPost4(widget.caption);
      Provider.of<UserData>(context, listen: false).setPost5(widget.hashTag);
      Provider.of<UserData>(context, listen: false).setPostImage(null);
      Provider.of<UserData>(context, listen: false).setPostImage(null);
    });

    _pageController = PageController(
      initialPage: 0,
    );
  }

  _handleImage() async {
    HapticFeedback.heavyImpact();

    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;

    if (mounted) {
      Provider.of<UserData>(context, listen: false).setPostImage(file as File);
    }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.5),
    );
    return croppedImage!;
  }

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog(context);
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to delete this mood punched?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'delete',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _deletePost();
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
              'Are you sure you want to delete this  mood punched?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _deletePost();
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

  _deletePost() {
    HapticFeedback.heavyImpact();

    final double width = Responsive.isDesktop(
      context,
    )
        ? 600.0
        : MediaQuery.of(context).size.width;
    String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.deletePunch(
        currentUserId: currentUserId, post: widget.post!);
    FirebaseStorage.instance
        .refFromURL(widget.post!.imageUrl)
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
              e.contains(']')
                  ? e.substring(e.lastIndexOf(']') + 1).toString()
                  : e.toString(),
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
    Navigator.pop(context);
    Flushbar(
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
        'Done!!',
        style: TextStyle(
          color: Colors.white,
          fontSize: width > 800 ? 22 : 14,
        ),
      ),
      messageText: Text(
        "Deleted successfully. Refresh your punch page",
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
      duration: Duration(seconds: 2),
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  _submitEdit() async {
    HapticFeedback.heavyImpact();

    if (_formKey.currentState!.validate() &
        !Provider.of<UserData>(context, listen: false).isLoading) {
      _formKey.currentState?.save();
      String _imageUrl = widget.post!.imageUrl;
      Post post = Post(
        blurHash: widget.post!.blurHash,
        id: widget.post!.id,
        imageUrl: _imageUrl,
        caption: Provider.of<UserData>(context, listen: false).post4!,
        artist:
            Provider.of<UserData>(context, listen: false).post1.toUpperCase(),
        hashTag: Provider.of<UserData>(context, listen: false).post5,
        punch: Provider.of<UserData>(context, listen: false).post3,
        musicLink: Provider.of<UserData>(context, listen: false).post2,
        likeCount: 0,
        disLikeCount: 0,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: widget.post!.timestamp,
        report: '',
        reportConfirmed: '',
        disableReaction: false,
        disableVibe: false,
        disbleSharing: false,
        peopleTagged: '',
        mediaType: '',
        authorHandleType:
            Provider.of<UserData>(context, listen: false).user!.profileHandle!,
        authorIdProfileImageUrl: Provider.of<UserData>(context, listen: false)
            .user!
            .profileImageUrl!,
        authorName:
            Provider.of<UserData>(context, listen: false).user!.userName!,
        authorVerification:
            Provider.of<UserData>(context, listen: false).user!.verified!,
      );
      try {
        DatabaseService.editPunch(post);
        Navigator.pop(context);
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
        Flushbar(
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
            'Done!!',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            "Edited successfully. Refresh your punch page",
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            MdiIcons.checkCircleOutline,
            size: 30.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 2),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      } catch (e) {
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        Flushbar(
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
            'Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            result.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.error_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }
    }
  }

  _submitCreate() async {
    HapticFeedback.heavyImpact();
    if (_formKey.currentState!.validate() &&
        !Provider.of<UserData>(context, listen: false).isLoading) {
      _formKey.currentState?.save();
      animateForward();

      setState(() {
        _isLoading = true;
      });
      FocusScope.of(context).unfocus();
      String imageUrl = await StorageService.uploadPost(
          Provider.of<UserData>(context, listen: false).postImage!);

      Uint8List bytes =
          await (Provider.of<UserData>(context, listen: false).postImage!)
              .readAsBytes();
      var blurHash = await BlurHash.encode(bytes, 4, 3);

      Post post = Post(
        blurHash: blurHash,
        imageUrl: imageUrl,
        caption: Provider.of<UserData>(context, listen: false).post4!,
        artist:
            Provider.of<UserData>(context, listen: false).post1.toUpperCase(),
        hashTag: Provider.of<UserData>(context, listen: false).post5,
        punch: Provider.of<UserData>(context, listen: false).post3,
        musicLink: Provider.of<UserData>(context, listen: false).post2,
        reportConfirmed: '',
        report: '',
        likeCount: 0,
        disLikeCount: 0,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: Timestamp.fromDate(DateTime.now()),
        id: '',
        disableReaction: false,
        disableVibe: false,
        disbleSharing: false,
        peopleTagged: '',
        mediaType: '',
        authorHandleType:
            Provider.of<UserData>(context, listen: false).user!.profileHandle!,
        authorIdProfileImageUrl: Provider.of<UserData>(context, listen: false)
            .user!
            .profileImageUrl!,
        authorName:
            Provider.of<UserData>(context, listen: false).user!.userName!,
        authorVerification:
            Provider.of<UserData>(context, listen: false).user!.verified!,
      );
      try {
        DatabaseService.createPost(post);
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
        final AccountHolder user =
            Provider.of<UserData>(context, listen: false).user!;
        Navigator.pop(context);
        Flushbar(
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
            user.userName!,
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            "Your mood was punched successfully.",
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            MdiIcons.checkCircleOutline,
            size: 30.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 2),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      } catch (e) {
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        Flushbar(
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
            'Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            result.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.error_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          isDismissible: false,
          // duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }

      setState(() {
        widget.caption = '';
        widget.artist = '';
        widget.musicLink = '';
        widget.punch = '';
        widget.hashTag = '';
        _isLoading = false;
        setNull();
      });
    }
  }

  _buildUserTile(AccountHolder user) {
    return SearchUserTile(
        verified: user.verified,
        userName: user.userName!.toUpperCase(),
        profileHandle: user.profileHandle!,
        company: user.company!,
        profileImageUrl: user.profileImageUrl!,
        bio: user.bio!,
        score: user.score!,
        onPressed: () {
          Provider.of<UserData>(context, listen: false)
              .setPost1(user.userName!);
          setState(() {
            widget.artist = user.userName!;
            _showSheet = _show == 3 ? false : true;
            _show = _show == 1
                ? 2
                : _show == 2
                    ? 3
                    : 0;
          });
        });
  }

  _displayPostImage() {
    if (widget.imageUrl.isNotEmpty) {
      return Container(
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: CachedNetworkImageProvider(widget.imageUrl),
            fit: BoxFit.cover,
          )),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(.5),
              Colors.black.withOpacity(.5),
            ])),
          ));
    } else {
      return Container(
          height: double.infinity,
          width: double.infinity,
          color:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          child: _display());
    }
  }

  _display() {
    if (widget.imageUrl.isNotEmpty) {
      return Container(
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: CachedNetworkImageProvider(widget.imageUrl),
            fit: BoxFit.cover,
          )),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(.5),
              Colors.black.withOpacity(.5),
            ])),
          ));
    } else {
      return Container(
        child: Provider.of<UserData>(context).postImage == null
            ? Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black,
              )
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: FileImage(
                      File(Provider.of<UserData>(context).postImage!.path)),
                  fit: BoxFit.cover,
                )),
                child: Container(
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                    Colors.black.withOpacity(.5),
                    Colors.black.withOpacity(.5),
                  ])),
                )),
      );
    }
  }

  animateForward() {
    _pageController.animateToPage(
      _index + 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  _validateVideo() {
    if (_formKey.currentState!.validate()) {
      return setState(() {
        _show = 3;
      });
    } else {
      Flushbar(
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
          'Not valid',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        messageText: Text(
          'Enter a valid video link',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    }
    // return !musiVideoLink.hasMatch(input)
    //     ? "Enter a valid music video link"
    //     : null;
  }

  static const values = <String>[
    "Hustle",
    "Love",
    "Money",
    "Success",
    "Motivation",
    "Inspiration",
    "Struggle",
    "Pain",
    "Prayer",
    "Hood",
    "Friendship",
    "Family",
    "Hard-work",
    "Happiness"
  ];

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: values.map((value) {
          final selected = this.selectedValue == value;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
              value: value,
              groupValue: selectedValue,
              title: Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                ),
              ),
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(
                  () {
                    _hashTag = this.selectedValue = value!;
                    _showSheet = _show == 3 ? false : true;
                    _show = _show == 1
                        ? 2
                        : _show == 2
                            ? 3
                            : 0;
                  },
                );
                Provider.of<UserData>(context, listen: false)
                    .setPost5(_hashTag);
              });
        }).toList()),
      );

  Widget buildBlur({
    required Widget child,
    double sigmaX = 20,
    double sigmaY = 20,
    BorderRadius? borderRadius,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );
  setNull() {
    Provider.of<UserData>(context, listen: false).setPostImage(null);
    Provider.of<UserData>(context, listen: false).setPost1('');
    Provider.of<UserData>(context, listen: false).setPost2('');
    Provider.of<UserData>(context, listen: false).setPost3('');
    Provider.of<UserData>(context, listen: false).setPost4('');
    Provider.of<UserData>(context, listen: false).setPost5('');
  }

  _pop() {
    Navigator.pop(context);
    setNull();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    AccountHolder? _user = Provider.of<UserData>(context, listen: false).user;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor: Color(0xFFf2f2f2),
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            child: Form(
              key: _formKey,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  alignment: FractionalOffset.center,
                  children: <Widget>[
                    Stack(
                        alignment: FractionalOffset.center,
                        children: <Widget>[
                          _displayPostImage(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, left: 10.0, right: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: PageView(
                                controller: _pageController,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Provider.of<UserData>(context,
                                                        listen: false)
                                                    .post5
                                                    .isEmpty &&
                                                !widget.isEditting
                                            ? const SizedBox.shrink()
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _show = 3;
                                                    _showSheet = true;
                                                  });
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      '#',
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      Provider.of<UserData>(
                                                              context,
                                                              listen: false)
                                                          .post5,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        Provider.of<UserData>(context,
                                                            listen: false)
                                                        .postImage ==
                                                    null &&
                                                widget.imageUrl.isEmpty
                                            ? AvatarGlow(
                                                animate: true,
                                                showTwoGlows: true,
                                                shape: BoxShape.circle,
                                                glowColor: Colors.blue,
                                                endRadius: 100,
                                                duration: const Duration(
                                                    milliseconds: 2000),
                                                repeatPauseDuration:
                                                    const Duration(
                                                        milliseconds: 3000),
                                                child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                          width: 2,
                                                          color: Colors.white,
                                                        )),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        MdiIcons.image,
                                                        color: Colors.white,
                                                        size: 80,
                                                      ),
                                                      onPressed: () =>
                                                          _handleImage(),
                                                    )),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: buildBlur(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                      ),
                                                      height: width / 1.5,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(30.0),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                child: Hero(
                                                                  tag: !widget
                                                                          .isEditting
                                                                      ? '1'
                                                                      : 'punch' +
                                                                          widget
                                                                              .post!
                                                                              .id
                                                                              .toString(),
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child:
                                                                        TextFormField(
                                                                      autofocus: widget
                                                                              .isEditting
                                                                          ? false
                                                                          : true,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      maxLines:
                                                                          null,
                                                                      textCapitalization:
                                                                          TextCapitalization
                                                                              .sentences,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      initialValue: widget
                                                                              .isEditting
                                                                          ? widget
                                                                              .punch
                                                                          : '',
                                                                      decoration: InputDecoration(
                                                                          hintText:
                                                                              "Enter a punchline to express your mood",
                                                                          hintStyle: TextStyle(
                                                                              fontSize:
                                                                                  14,
                                                                              color: Colors
                                                                                  .grey),
                                                                          labelText:
                                                                              'Punchline',
                                                                          labelStyle: TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white),
                                                                          enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.grey))),
                                                                      onChanged: (input) => Provider.of<UserData>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .setPost3(
                                                                              input),
                                                                      onSaved: (input) => Provider.of<UserData>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .setPost3(
                                                                              input!),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Hero(
                                                                tag: !widget
                                                                        .isEditting
                                                                    ? '2'
                                                                    : 'caption' +
                                                                        widget
                                                                            .post!
                                                                            .id
                                                                            .toString(),
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      TextFormField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        null,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    initialValue: widget
                                                                            .isEditting
                                                                        ? widget
                                                                            .caption
                                                                        : '',
                                                                    decoration: InputDecoration(
                                                                        hintText: "A brief story about your punch and mood",
                                                                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                                                                        labelText: 'Punch Annotation (optional)',
                                                                        labelStyle: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                        enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.grey))),
                                                                    onChanged: (input) => Provider.of<UserData>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .setPost4(
                                                                            input),
                                                                    onSaved: (input) => Provider.of<UserData>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .setPost4(
                                                                            input!),
                                                                  ),
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
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _show = 1;
                                              _showSheet = true;
                                            });
                                          },
                                          child: Text(
                                            Provider.of<UserData>(context,
                                                    listen: false)
                                                .post1,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Provider.of<UserData>(context,
                                                            listen: false)
                                                        .postImage ==
                                                    null &&
                                                widget.imageUrl.isEmpty
                                            ? GestureDetector(
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            FeatureInfo(
                                                              feature: 'Punch',
                                                            ))),
                                                child: RichText(
                                                    textScaleFactor:
                                                        MediaQuery.of(context)
                                                            .textScaleFactor
                                                            .clamp(0.5, 1.5),
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                        text: _user!.name,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '\nPunch your mood by posting a picture and associating the mood of the picture with music lyrics. You can honor your favorite artist by punching your mood using their punchline. Tap on the image icon above, and let\'s start.',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '...more',
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ]),
                                                    textAlign:
                                                        TextAlign.center),
                                              )
                                            : Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 70,
                                                  ),
                                                  Provider.of<UserData>(
                                                            context,
                                                          ).post2.isEmpty &&
                                                          !widget.isEditting
                                                      ? const SizedBox.shrink()
                                                      : IconButton(
                                                          icon: const Icon(
                                                            MdiIcons
                                                                .playCircleOutline,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _show = 2;
                                                              _showSheet = true;
                                                            });
                                                          },
                                                        ),
                                                  const SizedBox(
                                                    height: 70,
                                                  ),
                                                  widget.isEditting
                                                      ? Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.white,
                                                          ),
                                                          child: Container(
                                                            height: Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 40
                                                                : 30,
                                                            width: Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 40
                                                                : 30,
                                                            child: IconButton(
                                                                icon: Icon(Icons
                                                                    .delete_forever),
                                                                iconSize: 25,
                                                                color: Colors
                                                                    .black,
                                                                onPressed:
                                                                    _showSelectImageDialog),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink()
                                                ],
                                              ),
                                      ]),
                                  Container(
                                      color: Colors.transparent,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              200,
                                      child: Center(
                                          child: Loading(
                                        title: 'Punching mood',
                                        icon: (FontAwesomeIcons.faceLaugh),
                                      ))),
                                ],
                              ),
                            ),
                          ),
                        ]),
                    _isLoading
                        ? const SizedBox.shrink()
                        : Positioned(
                            top: 35,
                            left: 5,
                            child: IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  _showSheet
                                      ? setState(() {
                                          _showSheet = false;
                                          _show = 0;
                                        })
                                      : _pop();
                                }),
                          ),
                    Positioned(
                      top: 40,
                      right: 5,
                      child: Provider.of<UserData>(context, listen: false)
                                  .post3
                                  .isEmpty ||
                              _showSheet == true
                          ? const SizedBox.shrink()
                          : Provider.of<UserData>(context, listen: false)
                                  .post1
                                  .isNotEmpty
                              ? const SizedBox.shrink()
                              : AnimatedContainer(
                                  duration: Duration(milliseconds: 700),
                                  width: 80,
                                  child: ShakeTransition(
                                    curve: Curves.easeOutBack,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 20.0,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showSheet = true;
                                          _show = 1;
                                        });
                                      },
                                      child: Text(
                                        'Next',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                    ),
                    _isLoading
                        ? const SizedBox.shrink()
                        : Positioned(
                            top: 40,
                            right: 5,
                            child: _showSheet
                                ? Provider.of<UserData>(context, listen: false)
                                        .post1
                                        .isEmpty
                                    ? const SizedBox.shrink()
                                    : AnimatedContainer(
                                        duration: Duration(milliseconds: 700),
                                        width: _showSheet ? 80 : 0.0,
                                        child: ShakeTransition(
                                          curve: Curves.easeOutBack,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              elevation: 20.0,
                                              foregroundColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            onPressed: _show == 2
                                                ? () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    Provider.of<UserData>(
                                                                context,
                                                                listen: false)
                                                            .post2
                                                            .isEmpty
                                                        ? setState(() {
                                                            _show = 3;
                                                          })
                                                        : _validateVideo();
                                                  }
                                                : () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    setState(() {
                                                      _showSheet = _show == 3
                                                          ? false
                                                          : true;
                                                      _show = _show == 1
                                                          ? 2
                                                          : _show == 2
                                                              ? 3
                                                              : 0;
                                                    });
                                                  },
                                            child: Text(
                                              _show == 2 &&
                                                      Provider.of<UserData>(
                                                              context,
                                                              listen: false)
                                                          .post2
                                                          .isEmpty
                                                  ? 'Skip'
                                                  : _show == 3 &&
                                                          Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .post5
                                                              .isEmpty
                                                      ? 'Skip'
                                                      : 'Next',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                : Provider.of<UserData>(context, listen: false)
                                            .post1
                                            .isNotEmpty &&
                                        Provider.of<UserData>(context,
                                                listen: false)
                                            .post3
                                            .isNotEmpty
                                    ? Provider.of<UserData>(context,
                                                        listen: false)
                                                    .postImage !=
                                                null ||
                                            widget.imageUrl.isNotEmpty
                                        ? ShakeTransition(
                                            curve: Curves.easeOutBack,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                elevation: 0.0,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                widget.isEditting
                                                    ? _submitEdit()
                                                    : _submitCreate();
                                              },
                                              child: Text(
                                                widget.isEditting
                                                    ? 'Save'
                                                    : 'Punch mood',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox()
                                    : SizedBox(),
                          ),
                    Positioned(
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.linearToEaseOut,
                        height: _showSheet ? height - 100 : 0.0,
                        width: width,
                        decoration: BoxDecoration(
                          color: ConfigBloc().darkModeOn
                              ? Color(0xFF1a1a1a)
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: _show == 1
                              ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      widget.artist.isNotEmpty
                                          ? AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              height: widget.artist.isEmpty
                                                  ? 0.0
                                                  : null,
                                              curve: Curves.easeInOut,
                                              child: Text(
                                                widget.artist,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Container(
                                              child: _users == null
                                                  ? DirectionWidget(
                                                      text:
                                                          "${_user!.userName}, enter the name of the artist punchline you are using. If there are multiple artists featured on the song, make sure you enter the  name of the specific artist\'s punchline you used.  It helps other users to interact with the artist's account if they like the punchline.",
                                                      fontSize: null,
                                                    )
                                                  : ShakeTransition(
                                                      child: DirectionWidget(
                                                        fontSize: null,
                                                        text:
                                                            "${_user!.userName}, we are trying to see if the artist's name you entered is on Bars Impression. You can still punch your mood even if the artist is not available. If the artist is available, you can tap on the artist to make sure the name you've entered is correct. It helps other users to interact with the artist if they like the punchline.",
                                                      ),
                                                    )),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        autofocus: true,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        initialValue: Provider.of<UserData>(
                                                context,
                                                listen: false)
                                            .post1
                                            .toString(),
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        onChanged: (input) {
                                          if (input.isNotEmpty) {
                                            setState(() {
                                              _users =
                                                  DatabaseService.searchUsers(
                                                      input.toUpperCase());
                                            });
                                          }
                                          Provider.of<UserData>(context,
                                                  listen: false)
                                              .setPost1(input);
                                        },
                                        onSaved: (input) =>
                                            Provider.of<UserData>(context,
                                                    listen: false)
                                                .setPost1(input!),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: ConfigBloc().darkModeOn
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                            hintText:
                                                "Enter the name of the artist punchline used",
                                            hintStyle: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey,
                                            ),
                                            labelText: 'Artist',
                                            labelStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                            enabledBorder:
                                                new UnderlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.grey))),
                                      ),
                                      _users == null
                                          ? const SizedBox.shrink()
                                          : FutureBuilder<QuerySnapshot>(
                                              future: _users,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                                if (snapshot
                                                        .data!.docs.length ==
                                                    0) {
                                                  return Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: RichText(
                                                          text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  "No users found. ",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blueGrey)),
                                                          TextSpan(
                                                              text:
                                                                  '\nCheck username and try again.'),
                                                        ],
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey),
                                                      )),
                                                    ),
                                                  );
                                                }
                                                return SingleChildScrollView(
                                                  child: Container(
                                                    height: width,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        SingleChildScrollView(
                                                          child: Container(
                                                            height: width - 20,
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  snapshot
                                                                      .data!
                                                                      .docs
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                AccountHolder?
                                                                    user =
                                                                    AccountHolder.fromDoc(
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]);
                                                                return _buildUserTile(
                                                                    user);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                    ],
                                  ),
                                )
                              : _show == 2
                                  ? Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DirectionWidget(
                                            fontSize: null,
                                            text:
                                                " Provide a music Video link to the music of the punchline used.",
                                          ),
                                          TextFormField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            textCapitalization:
                                                TextCapitalization.characters,
                                            initialValue: Provider.of<UserData>(
                                                    context,
                                                    listen: false)
                                                .post2
                                                .toString(),
                                            autovalidateMode:
                                                AutovalidateMode.always,
                                            onChanged: (input) {
                                              Provider.of<UserData>(context,
                                                      listen: false)
                                                  .setPost2(input);
                                            },
                                            onSaved: (input) =>
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .setPost2(input!),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            validator: (input) => !musiVideoLink
                                                    .hasMatch(input!)
                                                ? "Enter a valid music video link"
                                                : null,
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Link to Music (optional)',
                                                hintStyle: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey,
                                                ),
                                                labelText: 'Music Video',
                                                labelStyle: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                                enabledBorder:
                                                    new UnderlineInputBorder(
                                                        borderSide:
                                                            new BorderSide(
                                                                color: Colors
                                                                    .grey))),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DirectionWidget(
                                            fontSize: null,
                                            text: _user!.name! +
                                                ", select a tag that goes with your mood.",
                                          ),
                                          buildRadios(),
                                        ],
                                      ),
                                    ),
                        ),
                      ),
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
}
