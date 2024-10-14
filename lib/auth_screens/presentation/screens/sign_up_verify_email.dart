import 'package:bars/utilities/exports.dart';

class SignpsScreenVerifyEmail extends StatefulWidget {
  static final id = 'Signup_screen';
  final String email;
  SignpsScreenVerifyEmail({
    required this.email,
  });
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
    final user = _auth.currentUser;
    Future.delayed(Duration(milliseconds: 500));
    try {
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('email sent');
        mySnackBar(
          context,
          "Verification sent to:\n${widget.email.toLowerCase()}",
        );
      }
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      mySnackBar(context, 'Request Failed\n$result,');
    }

    if (user != null && !user.emailVerified) {
      timer = Timer.periodic(Duration(seconds: 5), (_) => checkEmailVerified());
      Timer(Duration(minutes: 4), () async {
        if (mounted && !user.emailVerified) {
          Provider.of<UserData>(context, listen: false).setName(
            '',
          );
          await _auth.currentUser!.delete().then((value) async {
            await _auth.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Intro(),
                ),
                (Route<dynamic> route) => false);
          });

          mySnackBar(
            context,
            "Registration cancelled\nFailed to verify email.",
          );
        }
      });
    }
  }

  Future checkEmailVerified() async {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    await user!.reload();
    print('checking email');

    if (user.emailVerified) {
      timer?.cancel();
      setState(() {
        _isLoading = true;
      });

      return AuthService.verifyUseer(
        context,
        FirebaseAuth.instance.currentUser!.email!,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

//

  _submit() async {
    final user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
    mySnackBar(
      context,
      "Verification sent to:\n${widget.email.toLowerCase()}",
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            backgroundColor: Color(0xFF013e9d),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    width: width,
                    height: MediaQuery.of(context).size.height,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.mail_outline,
                            size:
                                ResponsiveHelper.responsiveHeight(context, 100),
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              'A verification link has been sent to ${widget.email.toLowerCase()}. Sign in to your email and verify your account to register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 14.0),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40.0),
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
                                    child: AlwaysWhiteButton(
                                      textColor: Colors.black,
                                      buttonText: 'Re-send ',
                                      onPressed: () {
                                        _submit();
                                      },
                                      buttonColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _isLoading
                              ? CircularProgress(
                                  isMini: true,
                                  indicatorColor:
                                      Colors.grey[800] ?? Colors.grey,
                                )
                              // SizedBox(
                              //     height: 0.5,
                              //     child: LinearProgressIndicator(
                              //       backgroundColor: Colors.transparent,
                              //       valueColor:
                              //           AlwaysStoppedAnimation(Colors.white),
                              //     ),
                              //   )
                              : const SizedBox.shrink()
                        ],
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
