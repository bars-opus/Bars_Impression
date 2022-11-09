import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class ProfileSettings extends StatefulWidget {
  final AccountHolder user;

  ProfileSettings({
    required this.user,
  });

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool _disableChat = false;
  bool _disableAdvice = false;
  bool _hideAdvice = false;
  bool _noBooking = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _disableChat = widget.user.disableChat!;
    _disableAdvice = widget.user.disableAdvice!;
    _hideAdvice = widget.user.hideAdvice!;
    _noBooking = widget.user.noBooking!;
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
              'Are you sure you want to log out of this account?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  _logOutUser(context);
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
              'Are you sure you want to log out of this account?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    _logOutUser(context);
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

  static final _auth = FirebaseAuth.instance;
  static void _logOutUser(BuildContext context) async {
    try {
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        backgroundColor: Color(0xFF1a1a1a),
        margin: EdgeInsets.all(8),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Color(0xFF1a1a1a),
        progressIndicatorValueColor: AlwaysStoppedAnimation(Colors.blue),
        flushbarPosition: FlushbarPosition.TOP,
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        titleText: Text(
          'Loging Out',
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          "Please wait...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      )..show(context);

      await _auth.signOut();
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        backgroundColor: Color(0xFF1a1a1a),
        margin: EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        titleText: Text(
          'Log Out Failed',
          style: TextStyle(color: Colors.white),
        ),
        messageText: Container(
            child: Text(
          result.toString(),
          style: TextStyle(color: Colors.white),
        )),
        icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue),
        mainButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
          ),
          onPressed: () => Navigator.pop(context),
          child: Text("Ok",
              style: TextStyle(
                color: Colors.blue,
              )),
        ),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
      print(e.toString());
    }
  }

  Future<void> _sendMail(String url) async {
    final double width = Responsive.isDesktop(
      context,
    )
        ? 600.0
        : MediaQuery.of(context).size.width;
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
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
          'Sorry',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 22 : 14,
          ),
        ),
        messageText: Text(
          'Could\'nt launch mail',
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
      )..show(context);
    }
  }

  _dynamicLink() async {
    var linkUrl = widget.user.profileImageUrl!.isEmpty
        ? Uri.parse(
            'https://firebasestorage.googleapis.com/v0/b/bars-5e3e5.appspot.com/o/IMG_8574.PNG?alt=media&token=ccb4e3b1-b5dc-470f-abd0-63edb5ed549f')
        : Uri.parse(widget.user.profileImageUrl!);

    final dynamicLinkParams = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: linkUrl,
        title: widget.user.userName,
        description: widget.user.bio,
      ),
      link: Uri.parse('https://www.barsopus.com/user_${widget.user.id}'),
      uriPrefix: 'https://barsopus.com/barsImpression',
      androidParameters:
          AndroidParameters(packageName: 'com.barsOpus.barsImpression'),
      iosParameters: IOSParameters(
        bundleId: 'com.bars-Opus.barsImpression',
        appStoreId: '1610868894',
      ),
    );
    var link =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    Share.share(link.shortUrl.toString());
    // if (Platform.isIOS) {
    //   var link =
    //       await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    //   Share.share(link.toString());
    // } else {
    //   var link =
    //       await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    //   Share.share(link.shortUrl.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            title: Text(
              'Account Settings',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 10, bottom: 10, left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SettingSwitch(
                                title: 'Disable Chat',
                                subTitle: 'Other users can\'t chat with you.',
                                value: _disableChat,
                                onChanged: (value) => setState(
                                  () {
                                    _disableChat = this._disableChat = value;
                                    usersRef
                                        .doc(
                                      widget.user.id,
                                    )
                                        .update({
                                      'disableChat': _disableChat,
                                    });
                                    usersAuthorRef
                                        .doc(
                                      widget.user.id,
                                    )
                                        .update({
                                      'disableChat': _disableChat,
                                    });
                                  },
                                ),
                              ),
                              widget.user.profileHandle!.startsWith('Fan')
                                  ? const SizedBox.shrink()
                                  : Divider(color: Colors.grey),
                              widget.user.profileHandle!.startsWith('Fan')
                                  ? const SizedBox.shrink()
                                  : SettingSwitch(
                                      title: 'Disable Advice',
                                      subTitle:
                                          'Other users can\'t leave advice but can read previously sent advice.',
                                      value: _disableAdvice,
                                      onChanged: (value) => setState(
                                        () {
                                          _disableAdvice =
                                              this._disableAdvice = value;
                                          usersRef
                                              .doc(
                                            widget.user.id,
                                          )
                                              .update({
                                            'disableAdvice': _disableAdvice,
                                          });
                                        },
                                      ),
                                    ),
                              widget.user.profileHandle!.startsWith('Fan')
                                  ? const SizedBox.shrink()
                                  : Divider(color: Colors.grey),
                              widget.user.profileHandle!.startsWith('Fan')
                                  ? const SizedBox.shrink()
                                  : SettingSwitch(
                                      title: 'Hide Advices',
                                      subTitle:
                                          'Other users can\'t read your advice but can still send new advice.',
                                      value: _hideAdvice,
                                      onChanged: (value) => setState(
                                        () {
                                          _hideAdvice =
                                              this._hideAdvice = value;
                                          usersRef
                                              .doc(
                                            widget.user.id,
                                          )
                                              .update({
                                            'hideAdvice': _hideAdvice,
                                          });
                                        },
                                      ),
                                    ),
                              widget.user.profileHandle!.startsWith('Fan')
                                  ? const SizedBox.shrink()
                                  : Divider(color: Colors.grey),
                              widget.user.profileHandle!.startsWith('Fan')
                                  ? const SizedBox.shrink()
                                  : SettingSwitch(
                                      title: 'Not Avaliable For Booking',
                                      subTitle: 'Other users can\'t book you.',
                                      value: _noBooking,
                                      onChanged: (value) => setState(
                                        () {
                                          _noBooking = this._noBooking = value;
                                          usersRef
                                              .doc(
                                            widget.user.id,
                                          )
                                              .update({
                                            'noBooking': _noBooking,
                                          });
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        )),
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 10, bottom: 10, left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlockedAccounts(),
                                    )),
                                child: IntroInfo(
                                  titleColor: ConfigBloc().darkModeOn
                                      ? Color(0xFFf2f2f2)
                                      : Color(0xFF1a1a1a),
                                  title: 'Blocked Accounts',
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlockedAccounts(),
                                      )),
                                  subTitle: "Accounts you have blocked.",
                                  icon: Icon(
                                    Icons.block_rounded,
                                    size: 20,
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Divider(color: Colors.grey),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DeleteAccount(
                                              user: widget.user,
                                            ))),
                                child: IntroInfo(
                                  titleColor: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                  title: 'Delete Account',
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DeleteAccount(
                                                user: widget.user,
                                              ))),
                                  subTitle: "Delete your user account",
                                  icon: Icon(
                                    Icons.delete_outline_outlined,
                                    size: 20,
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 10, bottom: 10, left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProfileVerification(
                                        user: widget.user,
                                      ),
                                    )),
                                child: IntroInfo(
                                  title: widget.user.verified!.isNotEmpty
                                      ? 'Verified account'
                                      : 'Request Verification',
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProfileVerification(
                                          user: widget.user,
                                        ),
                                      )),
                                  subTitle: widget.user.verified!.isNotEmpty
                                      ? 'Your account has been verified'
                                      : "Verify your account",
                                  icon: Icon(
                                    MdiIcons.checkboxMarkedCircle,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Divider(color: Colors.grey),
                              GestureDetector(
                                onTap: () => _dynamicLink(),
                                child: IntroInfo(
                                  title: 'Share Account',
                                  onPressed: () => _dynamicLink(),
                                  subTitle:
                                      "Share your account with other people.",
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Divider(color: Colors.grey),
                              GestureDetector(
                                onTap: () => _dynamicLink(),
                                child: IntroInfo(
                                  title: 'Invite people',
                                  onPressed: () => _dynamicLink(),
                                  subTitle:
                                      "Invite your friends and other music creatives to use Bars impression.",
                                  icon: Icon(
                                    Icons.people,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Divider(color: Colors.grey),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => FeatureSurvey())),
                                child: IntroInfo(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => FeatureSurvey())),
                                  title: 'Take a Survey',
                                  subTitle:
                                      "Take a survey and let us know what you think about Bars Impression.",
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.5,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60.0, bottom: 40),
                      child: Container(
                        width: 250.0,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: BorderSide(width: 1.0, color: Colors.blue),
                          ),
                          child: Hero(
                            tag: 'logout',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                'Log Out',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          onPressed: _showSelectImageDialog,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 30.0,
                    color: ConfigBloc().darkModeOn
                        ? Color(0xFFf2f2f2)
                        : Color(0xFF1a1a1a),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AboutUs())),
                      child: Text(
                        'About Us.',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _sendMail('mailto:support@barsopus.com');
                      }),
                      child: Text(
                        'Contact us',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MyWebView(
                                    url: 'https://www.barsopus.com/',
                                  )));
                    },
                    child: Text(
                      'BARS IMPRESSION',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        letterSpacing: 7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MyWebView(
                                    url: 'https://www.barsopus.com/',
                                  )));
                    },
                    child: Text(
                      'from Bars Opus',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _isLoading
                      ? SizedBox(
                          height: 2.0,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.grey[100],
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          )),
    );
  }
}
