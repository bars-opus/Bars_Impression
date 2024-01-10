import 'package:bars/utilities/exports.dart';

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

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _submit() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      if (mounted)
        setState(() {
          _isLoading = true;
        });
      _provider.setName(_nameController.text.trim());
      try {
        await AuthService.signUpUser(
            context,
            _nameController.text.trim(),
            _emailController.text.trim().toLowerCase(),
            _passwordController.text.trim());
        Provider.of<UserData>(context, listen: false).setName(
          _nameController.text.trim(),
        );
      } catch (e) {
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        _showBottomSheetErrorMessage(result);
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      }

      if (mounted)
        setState(() {
          _isLoading = false;
        });
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

  _toggleVisibility() {
    if (mounted)
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
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: width,
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
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
                                  controller: _nameController,
                                  hintText: 'Stage, brand, or nickname',
                                  labelText: 'name',
                                  onValidateText: (input) =>
                                      input!.trim().isEmpty
                                          ? 'Please enter a name'
                                          : input.length < 2
                                              ? 'username is too short'
                                              : input.length > 24
                                                  ? 'username is too long'
                                                  : null,
                                  icon: Icons.person_2_outlined,
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
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 10.0),
                                child: LoginField(
                                  controller: _passwordController,
                                  hintText: 'At least 8 characters',
                                  labelText: 'Password',
                                  onValidateText: (input) => input!.length < 8
                                      ? 'Password must be at least 8 characters'
                                      : input.length > 24
                                          ? 'Password is too long'
                                          : null,
                                  icon: Icons.lock_outline_rounded,
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
                            const SizedBox(height: 40.0),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: _isLoading
                                  ? 0.0
                                  : ResponsiveHelper.responsiveHeight(
                                      context, 250),
                              width: double.infinity,
                              curve: Curves.easeInOut,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Hero(
                                      tag: 'Sign In',
                                      child: AlwaysWhiteButton(
                                        textColor: Colors.black,
                                        buttonText: 'Create account',
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
                                      onTap: () => Navigator.pushNamed(
                                          context, Password.id),
                                      child: Text('Forgot Password?',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: ResponsiveHelper
                                                .responsiveFontSize(
                                                    context, 12.0),
                                          ),
                                          textAlign: TextAlign.right),
                                    ),
                                    const SizedBox(
                                      height: 40,
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
            ),
          );
        });
  }
}
