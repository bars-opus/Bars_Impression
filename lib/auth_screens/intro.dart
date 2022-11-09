import 'package:bars/utilities/exports.dart';

class Intro extends StatefulWidget {
  static final id = 'Intro_screen';

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
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
                      height: MediaQuery.of(context).size.width + 50,
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
                                height: 50,
                                child: AnimatedTextKit(
                                    animatedTexts: [
                                      FadeAnimatedText(
                                        'WELCOME',
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      FadeAnimatedText(
                                        'BIENVENU(E)',
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      FadeAnimatedText(
                                        'BIENVENIDOS',
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      FadeAnimatedText(
                                        'WOEZOR',
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      FadeAnimatedText(
                                        'KAABO',
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      FadeAnimatedText(
                                        'KARIBU',
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      FadeAnimatedText(
                                        'أهلا بك',
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      FadeAnimatedText(
                                        '欢迎',
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                    repeatForever: true,
                                    pause: const Duration(milliseconds: 3000),
                                    displayFullTextOnTap: true,
                                    stopPauseOnTap: true),
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text:
                                          'We are connecting all music creatives. We are bringing the whole music industry together. Connect and make history with legends.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            ShakeTransition(
                              axis: Axis.vertical,
                              child: WelcomeInfo(
                                title: 'Meet people',
                                subTitle:
                                    "Discover and get discovered. Get to know the best music creatives from artists, dancers, battle rappers, video vixens, cover art designers, brand influencers, producers, video directors, DJs, photographers, bloggers, and record labels.  People in the music industry can connect for business and collaborations.",
                                icon: Icon(
                                  Icons.people_outline,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            ShakeTransition(
                              child: WelcomeInfo(
                                title: 'Create a brand',
                                subTitle:
                                    "Different account types to help you easily create and grow your brand. Set up a unique profile that influences people to connect and work with you.",
                                icon: Icon(
                                  Icons.person_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            ShakeTransition(
                              child: WelcomeInfo(
                                title: 'What is on your mind?',
                                subTitle:
                                    "Express yourself and let others know what you think. Create forums to discuss news and events. You can also ask questions about projects you are working on if you find it difficult. Just tell us what is on your mind.",
                                icon: Icon(
                                  Icons.forum_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            ShakeTransition(
                              axis: Axis.vertical,
                              child: WelcomeInfo(
                                title: 'Attend meet and experience',
                                subTitle:
                                    "Explore events and have fun attending and making new friends. A  platform for event organizers to promote upcoming events. Attend, meet, and experience.",
                                icon: Icon(
                                  Icons.event_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            ShakeTransition(
                              axis: Axis.vertical,
                              child: WelcomeInfo(
                                title: 'Punch your mood',
                                subTitle:
                                    "Post and share pictures with friends and express the mood of your picture by relating it with lyrics of songs. Other users can get a direct link to the song and artist's lyrics used. bExpress yourself in a creative way and promote your favorite artists.",
                                icon: Icon(
                                  Icons.photo_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FadeAnimation(
                      1,
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60.0, bottom: 40),
                          child: Container(
                            width: 250.0,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  side: BorderSide(
                                    width: 1.0,
                                    color: Colors.blue,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Get Started',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => WelcomeScreen(),
                                      ),
                                    )),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
