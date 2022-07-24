import 'package:bars/services/auth_reset_password.dart';
import 'package:bars/utilities/exports.dart';
import 'package:email_validator/email_validator.dart';

class Password extends StatefulWidget {
  static final id = 'Passsword_screeen';

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password>
    with SingleTickerProviderStateMixin {
  late Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMoreDelayedAnimation;
  late AnimationController animationController;

  final _formKey = GlobalKey<FormState>();
  late String _email;

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

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      AuthPassWord.resetPassword(context, _email);
    }
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
                                    width: 100.0,
                                    height: 100.0,
                                    child: Image.asset(
                                      'assets/images/bars.png',
                                    ))),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Transform(
                                  transform: Matrix4.translationValues(
                                      delayedAnimation.value * width, 0.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 10.0),
                                    child: TextFormField(
                                      autofillHints: [AutofillHints.email],
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          labelText: 'Email',
                                          border: UnderlineInputBorder(),
                                          labelStyle: TextStyle(
                                            fontSize: width > 800 ? 22 : 14,
                                            color: Colors.grey,
                                          ),
                                          hintText:
                                              'Email used to register for Bars Impression',
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
                                                  borderSide: new BorderSide(
                                                      color: Colors.grey))),
                                      validator: (email) => email != null &&
                                              !EmailValidator.validate(
                                                  email.trim())
                                          ? 'Please enter your email'
                                          : null,
                                      onSaved: (input) => _email = input!,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Transform(
                                  transform: Matrix4.translationValues(
                                      muchDelayedAnimation.value * width,
                                      0.0,
                                      0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 10.0),
                                    child: GestureDetector(
                                      onTap: () => () {},
                                      child: Text(
                                          'Enter your email to reset your password. A reset link would be sent to your email',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: width > 800 ? 20 : 12,
                                          ),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40.0),
                                Hero(
                                  tag: 'Sign In',
                                  child: Container(
                                    width: 250.0,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        elevation: 20.0,
                                        onPrimary: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: _submit,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Submit Email',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: width > 800 ? 24 : 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: width > 800 ? 40.0 : 20),
                                FadeAnimation(
                                  1,
                                  Container(
                                    width: 250.0,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        primary: Colors.blue,
                                        side: BorderSide(
                                          width: 1.0,
                                          color: Colors.white,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Back',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width > 800 ? 24 : 16,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40.0),
                              ],
                            ),
                          )
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
