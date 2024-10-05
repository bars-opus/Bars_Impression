import 'package:bars/utilities/exports.dart';

class Intro extends StatefulWidget {
  static final id = 'Intro_screen';

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  _fadeText(String text) {
    return FadeAnimatedText(
      text,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 40.0),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _createEventDoc(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CreateEventDoc();
      },
    );
  }

  void _createWorkRequestDoc(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CreateWorkRequestDoc(
          fromWelcome: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF013e9d),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            ShakeTransition(
                              child: Container(
                                height: ResponsiveHelper.responsiveHeight(
                                    context, 60),
                                // color: Colors.red,
                                // alignment: Alignment.topCenter,
                                child: AnimatedTextKit(
                                    animatedTexts: [
                                      _fadeText(
                                        'WELCOME',
                                      ),
                                      _fadeText(
                                        'BIENVENU(E)',
                                      ),
                                      _fadeText(
                                        'BIENVENIDOS)',
                                      ),
                                      _fadeText(
                                        'WOEZOR)',
                                      ),
                                      _fadeText(
                                        'KAABO)',
                                      ),
                                      _fadeText(
                                        'KARIBU)',
                                      ),
                                      _fadeText(
                                        'أهلا بك',
                                      ),
                                      _fadeText(
                                        '欢迎',
                                      ),
                                    ],
                                    repeatForever: true,
                                    pause: const Duration(milliseconds: 3000),
                                    displayFullTextOnTap: true,
                                    stopPauseOnTap: true),
                              ),
                            ),
                            //
                            const SizedBox(height: 50),
                            ShakeTransition(
                              axis: Axis.vertical,
                              child: WelcomeInfo(
                                title: 'In all aspects, You are covered',
                                subTitle:
                                    "From birthdays to weddings, parties to concerts, we simplifies every aspect. Unforgettable experience at your fingertips. ",
                                icon: Icons.event_outlined,
                                showMore: true,
                                moreOnpressed: () {
                                  _createEventDoc(context);
                                },
                              ),
                            ),
                            ShakeTransition(
                              axis: Axis.vertical,
                              child: WelcomeInfo(
                                moreOnpressed: () {
                                  _createWorkRequestDoc(context);
                                },
                                title: 'Book creatives',
                                subTitle:
                                    "Explore and engage with a diverse pool of talented creatives from various backgrounds. Book them to perform at your events or collaborate on your projects. \nBe creative with creatives.  ",
                                icon: Icons.call_outlined, showMore: true,
                                // _iconData(Icons.people_outline),
                              ),
                            ),
                            ShakeTransition(
                              child: WelcomeInfo(
                                moreOnpressed: () {},
                                title: 'Stay connected',
                                subTitle:
                                    "Stay connected with the friends you've made at events and continue expanding your network for endless opportunities.",
                                icon: Icons.people_outline,
                                showMore: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.responsiveHeight(context, 30),
                    ),
                    BlueOutlineButton(
                      color: Colors.white,
                      buttonText: 'Get Started',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WelcomeScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: ResponsiveHelper.responsiveHeight(context, 60),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
