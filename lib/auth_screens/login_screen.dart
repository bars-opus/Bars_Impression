import 'package:bars/utilities/exports.dart';

class LoginScreen extends StatefulWidget {
  static final id = 'Login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMoreDelayedAnimation;
  late AnimationController animationController;

  final formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isHidden = true;

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
            curve: Interval(0.30, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();
  }

  @override
  void dispose() {
     animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _submit() async {
    if (formKey.currentState!.validate() &
        !Provider.of<UserData>(context, listen: false).isLoading) {
      formKey.currentState!.save();
      loginUser(context, _emailController.text.trim(),
          _passwordController.text.trim());
      FocusScope.of(context).unfocus();
    }
  }

  void _showBottomSheetErrorMessage(String error) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: 'Log In  Failed',
          subTitle: error,
        );
      },
    );
  }

  final _auth = FirebaseAuth.instance;
  void loginUser(BuildContext context, String email, String password) async {
    try {
      mySnackBar(context, 'Signing In\nPlease wait...');

      setState(() {
        _isLoading = true;
      });
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ConfigPage()),
          (Route<dynamic> route) => false);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => ConfigPage(),
      //   ),
      // );

      mySnackBar(context, 'Sign In  Successful\nWelcome Back...');
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;

      _showBottomSheetErrorMessage(result);

      setState(() {
        _isLoading = false;
      });
    }
  }

  _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor: Color(0xFF1a1a1a),
          body: Container(
            width: width,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 60.0,
                          height: 60.0,
                          child: Image.asset(
                            'assets/images/bars.png',
                          ),
                        ),
                        Transform(
                          transform: Matrix4.translationValues(
                              animation.value * width, 0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: LoginField(
                              controller: _emailController,
                              hintText: 'example@mail.com',
                              labelText: 'Email',
                              onValidateText: (email) => email != null &&
                                      !EmailValidator.validate(email.trim())
                                  ? 'Please enter your email'
                                  : null,
                              icon: Icons.email,
                            ),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.translationValues(
                              delayedAnimation.value * width, 0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: LoginField(
                              obscureText: _isHidden,
                              controller: _passwordController,
                              hintText: 'At least 8 characters',
                              labelText: 'Password',
                              onValidateText: (input) => input!.length < 8
                                  ? 'Password must be at least 8 characters'
                                  : input.length > 24
                                      ? 'Password is too long'
                                      : null,
                              icon: Icons.email,
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isHidden
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: ResponsiveHelper.responsiveHeight(
                                        context, 20.0),
                                    color: Colors.grey,
                                  ),
                                  onPressed: _toggleVisibility),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: _isLoading
                              ? 0.0
                              : ResponsiveHelper.responsiveHeight(context, 250),
                          width: double.infinity,
                          curve: Curves.easeInOut,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Hero(
                                  tag: 'Sign In',
                                  child: AlwaysWhiteButton(
                                    textColor: Colors.black,
                                    buttonText: 'Sign In',
                                    onPressed: () {
                                      _submit();
                                    },
                                    buttonColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                LoginBackButton(),
                                const SizedBox(height: 80.0),
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, Password.id),
                                  child: Text('Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 12.0),
                                      ),
                                      textAlign: TextAlign.right),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isLoading)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 0.5,
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
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
      },
    );
  }
}
