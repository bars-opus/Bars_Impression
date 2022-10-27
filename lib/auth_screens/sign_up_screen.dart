import 'package:bars/utilities/exports.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/scheduler.dart';

class SignpsScreen extends StatefulWidget {
  static final id = 'Signup_screen';

  @override
  _SignpsScreenState createState() => _SignpsScreenState();
}

class _SignpsScreenState extends State<SignpsScreen>
    with SingleTickerProviderStateMixin {
  late Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMoreDelayedAnimation;
  late AnimationController animationController;

  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  bool _isHidden = true;
  bool _isLoading = false;

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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setPost1(_email);
      Provider.of<UserData>(context, listen: false).setPost2(_password);
      Provider.of<UserData>(context, listen: false).setPost3(_name);
    });
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

      await AuthService.signUpUser(
        context,
        // _name,
        Provider.of<UserData>(context, listen: false).post3,
        // _email,
        Provider.of<UserData>(context, listen: false).post1,
        // _password,
        Provider.of<UserData>(context, listen: false).post2,
      );

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
                    child: SafeArea(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FadeAnimation(
                              1,
                              Container(
                                  width: 90.0,
                                  height: 90.0,
                                  child: Image.asset(
                                    'assets/images/bars.png',
                                  )),
                            ),
                            Form(
                              key: _formKey,
                              child: AutofillGroup(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          animation.value * width, 0.0, 0.0),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 10.0),
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width > 800 ? 20 : 14,
                                          ),
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: InputDecoration(
                                              labelText: 'Nickname',
                                              labelStyle: TextStyle(
                                                fontSize: width > 800 ? 22 : 14,
                                                color: Colors.grey,
                                              ),
                                              hintText:
                                                  'Stage, brand, or nickname',
                                              hintStyle: TextStyle(
                                                fontSize: width > 800 ? 20 : 14,
                                                color: Colors.blueGrey,
                                              ),
                                              icon: Icon(
                                                Icons.person,
                                                size: width > 800 ? 35 : 20.0,
                                                color: Colors.grey,
                                              ),
                                              enabledBorder:
                                                  new UnderlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color: Colors
                                                                  .grey))),
                                          autofillHints: [AutofillHints.name],
                                          onChanged: (input) =>
                                              Provider.of<UserData>(context,
                                                      listen: false)
                                                  .setPost3(input),
                                          onSaved: (input) =>
                                              Provider.of<UserData>(context,
                                                      listen: false)
                                                  .setPost3(input!),
                                          validator: (input) => input!
                                                  .trim()
                                                  .isEmpty
                                              ? 'Please enter a name'
                                              : input.length < 2
                                                  ? 'username is too short'
                                                  : input.length > 24
                                                      ? 'username is too long'
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
                                            horizontal: 30.0, vertical: 10.0),
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width > 800 ? 20 : 14,
                                          ),
                                          decoration: InputDecoration(
                                              labelText: 'Email',
                                              labelStyle: TextStyle(
                                                fontSize: width > 800 ? 22 : 14,
                                                color: Colors.grey,
                                              ),
                                              hintText: 'example@mail.com',
                                              hintStyle: TextStyle(
                                                fontSize: width > 800 ? 20 : 14,
                                                color: Colors.blueGrey,
                                              ),
                                              icon: Icon(
                                                Icons.email,
                                                size: width > 800 ? 35 : 20.0,
                                                color: Colors.grey,
                                              ),
                                              enabledBorder:
                                                  new UnderlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color: Colors
                                                                  .grey))),
                                          autofillHints: [AutofillHints.email],
                                          onChanged: (input) =>
                                              Provider.of<UserData>(context,
                                                      listen: false)
                                                  .setPost1(input),
                                          onSaved: (input) =>
                                              Provider.of<UserData>(context,
                                                      listen: false)
                                                  .setPost1(input!.trim()),
                                          validator: (email) => email != null &&
                                                  !EmailValidator.validate(
                                                      email.trim())
                                              ? 'Please enter your email'
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          muchDelayedAnimation.value * width,
                                          0.0,
                                          0.0),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 10.0),
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width > 800 ? 20 : 14,
                                          ),
                                          decoration: InputDecoration(
                                              labelText: 'Password',
                                              labelStyle: TextStyle(
                                                fontSize: width > 800 ? 22 : 14,
                                                color: Colors.grey,
                                              ),
                                              suffixIcon: IconButton(
                                                  icon: _isHidden
                                                      ? Icon(
                                                          Icons.visibility_off,
                                                          size: width > 800
                                                              ? 35
                                                              : 20.0,
                                                          color: Colors.grey,
                                                        )
                                                      : Icon(
                                                          Icons.visibility,
                                                          size: width > 800
                                                              ? 35
                                                              : 20.0,
                                                          color: Colors.white,
                                                        ),
                                                  onPressed: _toggleVisibility),
                                              hintText: 'At least 8 characters',
                                              hintStyle: TextStyle(
                                                fontSize: width > 800 ? 20 : 14,
                                                color: Colors.blueGrey,
                                              ),
                                              icon: Icon(
                                                Icons.lock,
                                                size: width > 800 ? 35 : 20.0,
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
                                          validator: (input) => input!.length <
                                                  8
                                              ? 'Password must be at least 8 characters'
                                              : input.length > 24
                                                  ? 'Password is too long'
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
                                              tag: 'Sign Up',
                                              child: Container(
                                                width: 250.0,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    elevation: 20.0,
                                                    onPrimary: Colors.blue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                  ),
                                                  onPressed:
                                                      //  () => Navigator.of(
                                                      //         context)
                                                      //     .pushAndRemoveUntil(
                                                      //         MaterialPageRoute(
                                                      //             builder: (context) =>
                                                      //                 SignpsScreenVerifyEmail()),
                                                      //         (Route<dynamic>
                                                      //                 route) =>
                                                      //             false),
                                                      _submit,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Register',
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
                                            SizedBox(
                                                height:
                                                    width > 800 ? 40.0 : 20),
                                            FadeAnimation(
                                              2,
                                              Container(
                                                width: 250.0,
                                                child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    primary: Colors.blue,
                                                    side: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.white,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Back',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: width > 800
                                                            ? 24
                                                            : 16,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 80.0),
                                            FadeAnimation(
                                              2,
                                              GestureDetector(
                                                onTap: () =>
                                                    Navigator.pushNamed(
                                                        context, Password.id),
                                                child: Text('Forgot Password?',
                                                    style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize:
                                                          width > 800 ? 18 : 12,
                                                    ),
                                                    textAlign: TextAlign.right),
                                              ),
                                            ),
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
                                        : const SizedBox.shrink(),
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
