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
  final _formKey = GlobalKey<FormState>();
  bool _disableChat = false;
  bool _enableBookingOnChat = false;
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
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
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
            title: Text('Are you sure you want to log out of this account?'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Log Out'),
                onPressed: () {
                  _logOutUser(context);
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
            primary: Colors.transparent,
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

  _aboutBars() {
    showAboutDialog(
        context: context,
        applicationName: 'Bars Impression',
        applicationVersion: 'Version 1.1.6',
        applicationIcon: Container(
          width: 40,
          height: 40,
          child: Image.asset(
            'assets/images/barsw.png',
            color: Colors.black,
          ),
        ),
        children: [
          Column(children: <Widget>[
            RichText(
                text: TextSpan(
              children: [
                TextSpan(
                    text: "Version Release Date: August 2022\n",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    )),
                TextSpan(
                    text: "Language: English.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    )),
              ],
            )),
          ])
        ]);
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
          'Could luanch mail',
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

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
            title: Text(
              'Settings',
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
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                      child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Divider(color: Colors.grey),
                                SettingSwitch(
                                  title: 'Disable Chat',
                                  subTitle:
                                      'Others users can\'t chat with you.',
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
                                    },
                                  ),
                                ),
                                widget.user.profileHandle!.startsWith('Fan')
                                    ? SizedBox.shrink()
                                    : Divider(color: Colors.grey),
                                widget.user.profileHandle!.startsWith('Fan')
                                    ? SizedBox.shrink()
                                    : SettingSwitch(
                                        title: 'Enable chat booking',
                                        subTitle:
                                            'Your management contact appears on your chat details.',
                                        value: _enableBookingOnChat,
                                        onChanged: (value) => setState(
                                          () {
                                            _enableBookingOnChat = this
                                                ._enableBookingOnChat = value;
                                            usersRef
                                                .doc(
                                              widget.user.id,
                                            )
                                                .update({
                                              'enableBookingOnChat':
                                                  _enableBookingOnChat,
                                            });
                                          },
                                        ),
                                      ),
                                widget.user.profileHandle!.startsWith('Fan')
                                    ? SizedBox.shrink()
                                    : Divider(color: Colors.grey),
                                widget.user.profileHandle!.startsWith('Fan')
                                    ? SizedBox.shrink()
                                    : SettingSwitch(
                                        title: 'Disable Advice',
                                        subTitle:
                                            'Others users can\'t leave an advice for but can read previousely sent advices.',
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
                                    ? SizedBox.shrink()
                                    : Divider(color: Colors.grey),
                                widget.user.profileHandle!.startsWith('Fan')
                                    ? SizedBox.shrink()
                                    : SettingSwitch(
                                        title: 'Hide Advices',
                                        subTitle:
                                            'Others can\'t read your advices but can still send new advices .',
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
                                    ? SizedBox.shrink()
                                    : Divider(color: Colors.grey),
                                widget.user.profileHandle!.startsWith('Fan')
                                    ? SizedBox.shrink()
                                    : SettingSwitch(
                                        title: 'Not Avaliable For Booking',
                                        subTitle:
                                            'Others users can\'t book you.',
                                        value: _noBooking,
                                        onChanged: (value) => setState(
                                          () {
                                            _noBooking =
                                                this._noBooking = value;
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
                                Divider(color: Colors.grey),

                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlockedAccounts(),
                                      )),
                                  child: IntroInfo(
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
                                          ? Color(0xFFf2f2f2)
                                          : Color(0xFF1a1a1a),
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
                                    title: 'Delete Accounts',
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DeleteAccount(
                                                  user: widget.user,
                                                ))),
                                    subTitle: "Delete you user account",
                                    icon: Icon(
                                      Icons.delete_outline_outlined,
                                      size: 20,
                                      color: ConfigBloc().darkModeOn
                                          ? Color(0xFFf2f2f2)
                                          : Color(0xFF1a1a1a),
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
                                    title: 'Take a survey',
                                    subTitle:
                                        "Take a survey and let us know what you think about Bars Impression",
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: ConfigBloc().darkModeOn
                                          ? Color(0xFFf2f2f2)
                                          : Color(0xFF1a1a1a),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.grey),
                                Platform.isIOS
                                    ? GestureDetector(
                                        onTap: () => Share.share(
                                            'https://apps.apple.com/us/app/bars-impression/id1610868894'),
                                        child: IntroInfo(
                                          title: 'Share',
                                          onPressed: () => Share.share(
                                              'https://apps.apple.com/us/app/bars-impression/id1610868894'),
                                          subTitle:
                                              "Share Bars Impression with others",
                                          icon: Icon(
                                            Icons.share,
                                            color: ConfigBloc().darkModeOn
                                                ? Color(0xFFf2f2f2)
                                                : Color(0xFF1a1a1a),
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () => Share.share(
                                            'https://play.google.com/store/apps/details?id=com.barsOpus.barsImpression'),
                                        child: IntroInfo(
                                          title: 'Share',
                                          onPressed: () => Share.share(
                                              'https://play.google.com/store/apps/details?id=com.barsOpus.barsImpression'),
                                          subTitle:
                                              "Share Bars Impression with others",
                                          icon: Icon(
                                            Icons.share,
                                            color: ConfigBloc().darkModeOn
                                                ? Color(0xFFf2f2f2)
                                                : Color(0xFF1a1a1a),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                Divider(color: Colors.grey),

                                // GestureDetector(
                                //   onTap: () => Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (_) => ProfileVerification(
                                //           user: widget.user,
                                //         ),
                                //       )),
                                //   child: IntroInfo(
                                //     title: 'Request Verification',
                                //     onPressed: () => Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (_) => ProfileVerification(
                                //             user: widget.user,
                                //           ),
                                //         )),
                                //     subTitle:
                                //         "Share Bars Impression with others",
                                //     icon: Icon(
                                //       MdiIcons.checkboxMarkedCircle,
                                //       size: 20,
                                //       color: Colors.blue,
                                //     ),
                                //   ),
                                // ),
                                // Divider(color: Colors.grey),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 60.0, bottom: 40),
                                    child: Container(
                                      width: 250.0,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          primary: Colors.blue,
                                          side: BorderSide(
                                              width: 1.0, color: Colors.blue),
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
                                GestureDetector(
                                  onTap: _aboutBars,
                                  child: Text(
                                    'App Info.',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _sendMail('mailto:support@barsopus.com');
                                  }),
                                  child: Text(
                                    'Contact us',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                SizedBox(height: 70),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => MyWebView(
                                                  url:
                                                      'https://www.barsopus.com/',
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
                                                  url:
                                                      'https://www.barsopus.com/',
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
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.blue),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ))),
                ),
              ),
            ),
          )),
    );
  }
}
