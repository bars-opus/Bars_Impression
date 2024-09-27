import 'package:bars/auth_screens/services/auth_reset_password.dart';
import 'package:bars/utilities/exports.dart';

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
  final _emailController = TextEditingController();

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
    _emailController.dispose();

    super.dispose();
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        AuthPassWord.resetPassword(
          context,
          _emailController.text.trim(),
        );
      } catch (e) {
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        _showBottomSheetErrorMessage(result);
      }
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
          title: "Request failed",
          subTitle: error,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            backgroundColor: Theme.of(context).cardColor,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _formKey,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TicketPurchasingIcon(
                      title: '',
                    ),
                    const SizedBox(height: 50),
                    // Container(
                    //   width: 60.0,
                    //   height: 60.0,
                    //   child: Image.asset(
                    //     'assets/images/bars.png',
                    //   ),
                    // ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: LoginField(
                          controller: _emailController,
                          hintText: 'example@mail.com',
                          labelText: 'Email',
                          onValidateText: (email) => email != null &&
                                  !EmailValidator.validate(email.trim())
                              ? 'Please enter your email'
                              : null,
                          icon: Icons.email_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                            'Enter your email to reset your password. A reset link would be sent to your email',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12.0),
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Hero(
                      tag: 'Sign In',
                      child: Center(
                        child: AlwaysWhiteButton(
                          textColor: Colors.black,
                          buttonText: 'Submit Email',
                          onPressed: () {
                            _submit();
                          },
                          buttonColor: Colors.white,
                        ),
                      ),
                    ),
                    // SizedBox(height: width > 800 ? 40.0 : 20),
                    // LoginBackButton(),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
