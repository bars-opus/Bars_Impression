import 'package:bars/utilities/exports.dart';

class TipScreen extends StatefulWidget {
  static final id = 'TipScreen_screen';

  @override
  _TipScreenState createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(children: [
          SizedBox(height: 100),
          Center(
            child: ShakeTransition(
              child: Text('Tips',
                  style: TextStyle(color: Colors.blue, fontSize: 40)),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: Container(
              height: 2,
              color: Colors.blue,
              width: 10,
            ),
          ),
          SizedBox(height: 20),
          ShakeTransition(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: IntroInfo(
                subTitleColor:
                    ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                title: 'Reveal more information',
                subTitle:
                    "Slide a created content (mood punch, a forum, an event, or a comment) to the right to see more information.\n You can also tap and hold to reveal more information",
                icon: Icon(
                  Icons.info,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ),
          ),
          ShakeTransition(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: IntroInfo(
                subTitleColor:
                    ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                title: 'Change mood punched state',
                subTitle:
                    'Double tap a mood punched to change the state of a punch, to hide the punchline associated with the picture.',
                icon: Icon(
                  Icons.change_circle,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ),
          ),
          ShakeTransition(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: IntroInfo(
                subTitleColor:
                    ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                title: 'Suggestion Box',
                subTitle:
                    'Tap and hold on a content to reveal more actions and select the suggestion box. We want to know what you think. This is how you can help Bars Impression become the best ecosystem for you and other music creatives worldwide.',
                icon: Icon(
                  Icons.mail_rounded,
                  color: Colors.grey,
                ),
                onPressed: () {},
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
                            'Continue',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SetUpBrand(),
                              ),
                            ))),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
