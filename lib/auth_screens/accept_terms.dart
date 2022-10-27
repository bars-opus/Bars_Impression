import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

class AcceptTerms extends StatefulWidget {
  static final id = 'Accept_terms';

  @override
  _AcceptTermsState createState() => _AcceptTermsState();
}

class _AcceptTermsState extends State<AcceptTerms>
    with SingleTickerProviderStateMixin {
  late Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMoreDelayedAnimation;
  late AnimationController animationController;

  final _formKey = GlobalKey<FormState>();

  // bool _isLoading = false;
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
      _set();
    });
  }

  _set() {
    setState(() {
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Provider.of<UserData>(context, listen: false).isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: SizedBox(
                                  height: 2.0,
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.grey[100],
                                    valueColor: AlwaysStoppedAnimation(
                                      Color(0xFF1a1a1a),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        Form(
                          key: _formKey,
                          child: AutofillGroup(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                FadeAnimation(
                                  1,
                                  Center(
                                    child: Text(
                                      'Terms of Use.',
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Transform(
                                  transform: Matrix4.translationValues(
                                      animation.value * width, 0.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0,
                                      vertical: 5.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => MyWebView(
                                                      url:
                                                          'https://www.barsopus.com/terms-of-use',
                                                    )));
                                      },
                                      child: RichText(
                                        textScaleFactor: MediaQuery.of(context)
                                            .textScaleFactor
                                            .clamp(0.5, 1.5),
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    'These Terms of Use govern your use of Bars Impression and provide information about the Bars Impression Service, outlined below. When you create a Bars Impression account or use Bars Impression, you agree to these terms. The Bars Impression Service is a product of Bars Opus, Ltd. These Terms of Use, therefore, constitute an agreement between you and Bars Opus, Ltd. By using or accessing Bars Impression Services, you agree to these Terms, as updated from time to time in accordance with Section 11 below. Bars Impression provides a wide range of services as part of the Bars Impression Services. We may ask you to review and accept supplemental terms that apply to your interaction with a service. To the extent those supplemental terms conflict with these Terms, the supplemental terms associated with the app, product, or service shall govern your use of such service...',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[400],
                                                )),
                                            TextSpan(
                                              text: 'more.',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ),
                                FadeAnimation(
                                  1,
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0, vertical: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => MyWebView(
                                                        url:
                                                            'https://www.barsopus.com/terms-of-use',
                                                      )));
                                        },
                                        child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    'To continue, you must review and accept the terms of use. Tap and review.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40.0),
                                Hero(
                                  tag: 'Sign Up',
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
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => LoginScreenOptions(
                                              from: 'Register',
                                            ),
                                          )),
                                      //  _submit,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Accept',
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
                                  2,
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
                                SizedBox(
                                  height: 60,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => MyWebView(
                                                  url:
                                                      'https://www.barsopus.com/privacy',
                                                )));
                                  },
                                  child: Text(
                                    'Privacy',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: width > 800 ? 18 : 12,
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
                ),
              ),
            ),
          );
        });
  }
}
