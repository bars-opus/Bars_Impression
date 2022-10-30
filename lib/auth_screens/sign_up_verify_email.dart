import 'package:bars/utilities/exports.dart';

class SignpsScreenVerifyEmail extends StatefulWidget {
  static final id = 'Signup_screen';

  @override
  _SignpsScreenVerifyEmailState createState() =>
      _SignpsScreenVerifyEmailState();
}

class _SignpsScreenVerifyEmailState extends State<SignpsScreenVerifyEmail>
    with SingleTickerProviderStateMixin {
  late Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMoreDelayedAnimation;
  late AnimationController animationController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _isVerifiedUSer();
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));

    muchMoreDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.9, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();
  }

  _isVerifiedUSer() async {
    final _auth = FirebaseAuth.instance;

    _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!_isVerified) {
      _submit();
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }

    Timer(Duration(minutes: 4), () async {
      if (mounted) {
        if (!_isVerified) {
          await _auth.currentUser!.delete().then((value) async {
            await _auth.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Intro(),
                ),
                (Route<dynamic> route) => false);
          });
        }
      }
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        backgroundColor: Colors.white,
        margin: EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        titleText: Text(
          'Registration cancelled.',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        icon: Icon(
          MdiIcons.checkCircleOutline,
          size: 30.0,
          color: Colors.blue,
        ),
        messageText: RichText(
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: TextSpan(children: [
            TextSpan(
                text: "Failed to verify email.",
                style: TextStyle(fontSize: 14, color: Colors.black)),
          ]),
        ),
        duration: Duration(seconds: 2),
        isDismissible: true,
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    });
  }

  _submit() async {
    final user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
    Flushbar(
      maxWidth: MediaQuery.of(context).size.width,
      backgroundColor: Colors.white,
      margin: EdgeInsets.all(8),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      titleText: Text(
        'Done.',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      icon: Icon(
        MdiIcons.checkCircleOutline,
        size: 30.0,
        color: Colors.blue,
      ),
      messageText: RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(children: [
          TextSpan(
              text: "Verification sent.",
              style: TextStyle(fontSize: 14, color: Colors.black)),
        ]),
      ),
      duration: Duration(seconds: 2),
      isDismissible: true,
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
if(mounted){
 setState(() {
      _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

}
   
    if (_isVerified) {
      timer?.cancel();
      return AuthService.verifyUseer(
        context,
        Provider.of<UserData>(context, listen: false).post3,
        Provider.of<UserData>(context, listen: false).post1,
      );
    }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String email = Provider.of<UserData>(context, listen: false).post1;
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            backgroundColor: Color(0xFF1a1a1a),
            body: Align(
              alignment: Alignment.center,
              child: Container(
                width: width,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FadeAnimation(
                              1,
                              Icon(
                                Icons.mail_outline,
                                size: 100,
                                color: Colors.white,
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: AutofillGroup(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: Text(
                                        'A verification link has been sent to $email. Sign in to your email and verify your account to register',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 40.0),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      height: _isLoading ? 0.0 : 250,
                                      width: double.infinity,
                                      curve: Curves.easeInOut,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Hero(
                                              tag: 'Sign Up',
                                              child: Container(
                                                width: 250.0,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    elevation: 20.0,
                                                    foregroundColor: Colors.blue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                  ),
                                                  onPressed: _submit,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Re-send ',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: width > 800
                                                            ? 24
                                                            : 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //     height:
                                            //         width > 800 ? 40.0 : 20),
                                            // FadeAnimation(
                                            //   2,
                                            //   Container(
                                            //     width: 250.0,
                                            //     child: OutlinedButton(
                                            //       style:
                                            //           OutlinedButton.styleFrom(
                                            //         primary: Colors.blue,
                                            //         side: BorderSide(
                                            //           width: 1.0,
                                            //           color: Colors.white,
                                            //         ),
                                            //         shape:
                                            //             RoundedRectangleBorder(
                                            //           borderRadius:
                                            //               BorderRadius.circular(
                                            //                   20.0),
                                            //         ),
                                            //       ),
                                            //       child: Padding(
                                            //         padding:
                                            //             const EdgeInsets.all(
                                            //                 8.0),
                                            //         child: Text(
                                            //           'Back',
                                            //           style: TextStyle(
                                            //             color: Colors.white,
                                            //             fontSize: width > 800
                                            //                 ? 24
                                            //                 : 16,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       onPressed: () =>
                                            //           Navigator.pop(context),
                                            //     ),
                                            //   ),
                                            // ),
                                            // SizedBox(height: 80.0),
                                            // FadeAnimation(
                                            //   2,
                                            //   GestureDetector(
                                            //     onTap: () =>
                                            //         Navigator.pushNamed(
                                            //             context, Password.id),
                                            //     child: Text('Forgot Password?',
                                            //         style: TextStyle(
                                            //           color: Colors.blueGrey,
                                            //           fontSize:
                                            //               width > 800 ? 18 : 12,
                                            //         ),
                                            //         textAlign: TextAlign.right),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Provider.of<UserData>(context,
                                                listen: false)
                                            .isLoading
                                        ? SizedBox(
                                            height: 0.5,
                                            child: LinearProgressIndicator(
                                              backgroundColor:
                                                  Colors.transparent,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          )
                                        : const SizedBox.shrink()
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
