import 'package:bars/utilities/exports.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/scheduler.dart';

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
  String _email = '';
  String _password = '';
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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setPost1(_email);
      Provider.of<UserData>(context, listen: false).setPost2(_password);
    });
  }

  _submit() async {
    if (formKey.currentState!.validate() & !_isLoading) {
      formKey.currentState!.save();
      loginUser(context, _email, _password);
      FocusScope.of(context).unfocus();
    }
  }

  final _auth = FirebaseAuth.instance;
  void loginUser(BuildContext context, String email, String password) async {
    try {
      final double width = MediaQuery.of(context).size.width;
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
          'Signing In',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 22 : 14,
          ),
        ),
        messageText: Text(
          "Please wait...",
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 20 : 12,
          ),
        ),
        duration: Duration(seconds: 3),
      )..show(context);
      setState(() {
        _isLoading = true;
      });
      await _auth.signInWithEmailAndPassword(
        email: Provider.of<UserData>(context, listen: false).post1,
        password: Provider.of<UserData>(context, listen: false).post2,
      );
      Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DiscoverUser(
            currentUserId: FirebaseAuth.instance.currentUser!.uid,
            isWelcome: true,
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        titleText: Text(
          'Sign In Successful',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: Icon(
          MdiIcons.checkCircleOutline,
          size: 30.0,
          color: Colors.blue,
        ),
        messageText: Text(
          "Welcome Back...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    } catch (e) {
      final double width = MediaQuery.of(context).size.width;
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        titleText: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            'Sign In Failed',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
        ),
        messageText: Container(
            child: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            result.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
        )),
        icon: Icon(Icons.error_outline,
            size: width > 800 ? 50 : 28.0, color: Colors.blue),
        mainButton: OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: Colors.transparent,
            side: BorderSide(width: 1.0, color: Colors.transparent),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text("Ok",
              style: TextStyle(
                color: Colors.blue,
                fontSize: width > 800 ? 24 : 16,
              )),
        ),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
      print(e.toString());
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _isLoading
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: SizedBox(
                                    height: 1.0,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.blue,
                                      valueColor: AlwaysStoppedAnimation(
                                        Color(0xFF1a1a1a),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FadeAnimation(
                                  1,
                                  Container(
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
                                Form(
                                  key: formKey,
                                  child: AutofillGroup(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Transform(
                                          transform: Matrix4.translationValues(
                                              animation.value * width,
                                              0.0,
                                              0.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30.0,
                                                vertical: 10.0),
                                            child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: width > 800 ? 20 : 14,
                                              ),
                                              decoration: InputDecoration(
                                                  labelText: 'Email',
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelStyle: TextStyle(
                                                    fontSize:
                                                        width > 800 ? 22 : 14,
                                                    color: Colors.grey,
                                                  ),
                                                  hintText:
                                                      'Email used to register for Bars Impression',
                                                  hintStyle: TextStyle(
                                                    fontSize:
                                                        width > 800 ? 20 : 14,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  icon: Icon(
                                                    Icons.email,
                                                    size:
                                                        width > 800 ? 35 : 20.0,
                                                    color: Colors.grey,
                                                  ),
                                                  enabledBorder:
                                                      new UnderlineInputBorder(
                                                          borderSide:
                                                              new BorderSide(
                                                                  color: Colors
                                                                      .grey))),
                                              autofillHints: [
                                                AutofillHints.email
                                              ],
                                              onChanged: (input) =>
                                                  Provider.of<UserData>(context,
                                                          listen: false)
                                                      .setPost1(input),
                                              onSaved: (input) =>
                                                  Provider.of<UserData>(context,
                                                          listen: false)
                                                      .setPost1(input!.trim()),
                                              validator: (email) => email !=
                                                          null &&
                                                      !EmailValidator.validate(
                                                          email.trim())
                                                  ? 'Please enter your email'
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        Transform(
                                          transform: Matrix4.translationValues(
                                              delayedAnimation.value * width,
                                              0.0,
                                              0.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30.0,
                                                vertical: 10.0),
                                            child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: width > 800 ? 20 : 14,
                                              ),
                                              decoration: InputDecoration(
                                                  labelText: 'Password',
                                                  labelStyle: TextStyle(
                                                    fontSize:
                                                        width > 800 ? 22 : 14,
                                                    color: Colors.grey,
                                                  ),
                                                  hintText:
                                                      'At least 8 characters',
                                                  hintStyle: TextStyle(
                                                    fontSize:
                                                        width > 800 ? 20 : 14,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  suffixIcon: IconButton(
                                                      icon: _isHidden
                                                          ? Icon(
                                                              Icons
                                                                  .visibility_off,
                                                              size: width > 800
                                                                  ? 35
                                                                  : 20.0,
                                                              color:
                                                                  Colors.grey,
                                                            )
                                                          : Icon(
                                                              Icons.visibility,
                                                              size: width > 800
                                                                  ? 35
                                                                  : 20.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      onPressed:
                                                          _toggleVisibility),
                                                  icon: Icon(
                                                    Icons.lock,
                                                    size:
                                                        width > 800 ? 35 : 20.0,
                                                    color: Colors.grey,
                                                  ),
                                                  enabledBorder:
                                                      new UnderlineInputBorder(
                                                          borderSide:
                                                              new BorderSide(
                                                                  color: Colors
                                                                      .grey))),
                                              autofillHints: [
                                                AutofillHints.password
                                              ],
                                              onChanged: (input) =>
                                                  Provider.of<UserData>(context,
                                                          listen: false)
                                                      .setPost2(input),
                                              onSaved: (input) =>
                                                  Provider.of<UserData>(context,
                                                          listen: false)
                                                      .setPost2(input!),
                                              validator: (input) => input!
                                                          .length <
                                                      8
                                                  ? 'Password must be at least 8 characters'
                                                  : null,
                                              obscureText: _isHidden,
                                            ),
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
                                                  tag: 'Sign In',
                                                  child: Container(
                                                    width: 250.0,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.white,
                                                        elevation: 20.0,
                                                        onPrimary: Colors.blue,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                      ),
                                                      onPressed: _submit,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Sign In',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                width > 800
                                                                    ? 24
                                                                    : 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: width > 800
                                                        ? 40.0
                                                        : 20),
                                                FadeAnimation(
                                                  1,
                                                  Container(
                                                    width: 250.0,
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        primary: Colors.blue,
                                                        side: BorderSide(
                                                          width: 1.0,
                                                          color: Colors.white,
                                                        ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Back',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                width > 800
                                                                    ? 24
                                                                    : 16,
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 80.0),
                                                FadeAnimation(
                                                  2,
                                                  GestureDetector(
                                                    onTap: () =>
                                                        Navigator.pushNamed(
                                                            context,
                                                            Password.id),
                                                    child: Text(
                                                        'Forgot Password?',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: width > 800
                                                              ? 18
                                                              : 12,
                                                        ),
                                                        textAlign:
                                                            TextAlign.right),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
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
        );
      },
    );
  }
}
