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
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            backgroundColor: Color(0xFF1a1a1a),
            body: SingleChildScrollView(
              child: Container(
                width: width,
                height: MediaQuery.of(context).size.height,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ShakeTransition(
                              curve: Curves.easeInOut,
                              duration: const Duration(milliseconds: 1400),
                              child: Text(
                                'Terms of Use.',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 40.0),
                                  color: Colors.white,
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
                                  onTap: () async {
                                    if (!await launchUrl(Uri.parse(
                                        'https://www.barsopus.com/terms-of-use'))) {
                                      throw 'Could not launch link';
                                    }
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) => MyWebView( title: '',
                                    //               url:
                                    //                   'https://www.barsopus.com/terms-of-use',
                                    //             )));
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
                                              fontSize: ResponsiveHelper
                                                  .responsiveFontSize(
                                                      context, 14.0),
                                              color: Colors.grey[400],
                                            )),
                                        TextSpan(
                                          text: 'more.',
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper
                                                .responsiveFontSize(
                                                    context, 14.0),
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
                            const SizedBox(height: 40.0),
                            ShakeTransition(
                              curve: Curves.easeInOut,
                              duration: const Duration(milliseconds: 700),
                              child: Hero(
                                tag: 'Sign Up',
                                child: AlwaysWhiteButton(
                                  textColor: Colors.black,
                                  buttonText: 'Accept',
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LoginScreenOptions(
                                            from: 'Register',
                                          ),
                                        ));
                                  },
                                  buttonColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            LoginBackButton(),
                            const SizedBox(
                              height: 60,
                            ),
                            GestureDetector(
                              onTap: () async {
              if (!await launchUrl(Uri.parse('https://www.barsopus.com/privacy'))) {
                throw 'Could not launch link';
              }
                                
                                
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => MyWebView(
                                //               title: '',
                                //               url:
                                //                   'https://www.barsopus.com/privacy',
                                //             )));
                              },
                              child: Text(
                                'Privacy',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14.0),
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
