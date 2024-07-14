import 'package:bars/utilities/exports.dart';

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

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

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
  }

  @override
  void dispose() {
     animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor: Color(0xFF1a1a1a),
          body: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: ShakeTransition(
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
                      ),
                      const SizedBox(height: 40.0),
                      if (Platform.isIOS)
                        Center(
                          child: SignInWithButton(
                            buttonText: 'Sign in with Apple',
                            onPressed: () async {
                              BarsGoogleAuthService.appleSignUpUser(
                                  context, widget.from!);
                            },
                            icon: FontAwesomeIcons.apple,
                          ),
                        ),
                      Center(
                        child: SignInWithButton(
                            icon: FontAwesomeIcons.google,
                            buttonText: 'Sign in with Google',
                            onPressed: () {
                              BarsGoogleAuthService.googleSignUpUser(
                                  context, widget.from!);
                            }),
                      ),
                      Hero(
                        tag: 'Sign In',
                        child: SignInWithButton(
                            icon: Icons.email,
                            buttonText: 'Enter email and password',
                            onPressed: () => _navigateToPage(
                                  widget.from!.startsWith('Register')
                                      ? SignpsScreen()
                                      : LoginScreen(),
                                )),
                      ),
                      const SizedBox(height: 50),
                      ShakeTransition(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
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
                              iconSize: ResponsiveHelper.responsiveHeight(
                                  context, 30),
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
        );
      },
    );
  }
}
