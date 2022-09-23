import 'package:bars/services/bars_google_auth_service.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
// import 'package:google_sign_in/goo gle_sign_in.dart';

class LoginScreenOptions extends StatefulWidget {
  final String? from;

  LoginScreenOptions({required this.from});

  static final id = 'Login_screen';

  @override
  _LoginScreenOptionsState createState() => _LoginScreenOptionsState();
}

class _LoginScreenOptionsState extends State<LoginScreenOptions>
    with SingleTickerProviderStateMixin {
  late Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMoreDelayedAnimation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
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

    animationController.forward();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setIsLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: SafeArea(
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ShakeTransition(
                              axis: Axis.vertical,
                              child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                      width: 90.0,
                                      height: 90.0,
                                      child: Image.asset(
                                        'assets/images/bars.png',
                                      ))),
                            ),
                            SizedBox(height: 40.0),
                            Platform.isAndroid
                                ? const SizedBox.shrink()
                                : SignInWithButton(
                                    buttonText:
                                        widget.from!.startsWith('Register')
                                            ? 'Register with Apple'
                                            : 'Sign in with Apple',
                                    onPressed: () async {
                                      BarsGoogleAuthService.appleSignUpUser(
                                          context, widget.from!);
                                      Provider.of<UserData>(context,
                                              listen: false)
                                          .setIsLoading(true);
                                    },
                                    // =>
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (_) => AcceptTerms(
                                    //         from: 'Apple',
                                    //       ),
                                    //     )),
                                    icon: Icon(
                                      FontAwesomeIcons.apple,
                                      color: Color(0xFF1a1a1a),
                                    ),
                                  ),
                            SignInWithButton(
                                icon: Icon(
                                  FontAwesomeIcons.google,
                                  color: Color(0xFF1a1a1a),
                                ),
                                buttonText: widget.from!.startsWith('Register')
                                    ? 'Register with Google'
                                    : 'Sign in with Google',
                                onPressed: () {
                                  BarsGoogleAuthService.googleSignUpUser(
                                      context, widget.from!);
                                  Provider.of<UserData>(context, listen: false)
                                      .setIsLoading(true);
                                  // GoogleSignIn().signIn();
                                  // };
                                }),
                            Hero(
                              tag: widget.from!.startsWith('Register')
                                  ? 'Sign Up'
                                  : 'Sign In',
                              child: SignInWithButton(
                                icon: Icon(
                                  Icons.email,
                                  color: Color(0xFF1a1a1a),
                                ),
                                buttonText: 'Enter email and password',
                                onPressed: () =>
                                    widget.from!.startsWith('Register')
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SignpsScreen(),
                                            ))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => LoginScreen(),
                                            )),
                              ),
                            ),
                            SizedBox(height: 50),
                            ShakeTransition(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.blue,
                                  side: BorderSide(
                                    width: 1.0,
                                    color: Colors.transparent,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(Icons.close),
                                    iconSize: 30.0,
                                    color: Colors.grey,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
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
          ),
        );
      },
    );
  }
}
