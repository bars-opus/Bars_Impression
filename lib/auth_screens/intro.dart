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

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
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
                                    context, 50),
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
                                  title: 'Attend, meet and experience',
                                  subTitle:
                                      "Explore events happening around you and have fun attending them, while making new friends. Unforgettable experiences to your fingertips. ",
                                  icon: Icons.event_outlined
                                  ),
                            ),
                            ShakeTransition(
                              axis: Axis.vertical,
                              child: WelcomeInfo(
                                title: 'Book Creatives',
                                subTitle:
                                    "Connect with the finest music creatives in your area, and book them to perform at your events or collaborate on your projects. Discover and be discovered.  ",
                                icon: Icons.people_outline,
                                // _iconData(Icons.people_outline),
                              ),
                            ),
                            ShakeTransition(
                              child: WelcomeInfo(
                                title: 'Stay Connected',
                                subTitle:
                                    "Stay connected with the friends you've made at events and continue expanding your network for endless opportunities.",
                                icon: Icons.person_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.responsiveHeight(context, 30),
                    ),
                    BlueOutlineButton(buttonText: 'Get Started', onPressed: () {  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WelcomeScreen(),
                                ),
                              ); },),
                   
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
