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
          SizedBox(height: 50),
          RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(children: [
              TextSpan(
                text: 'Registration Successful.\n',
                style: TextStyle(
                  fontSize: 18.0,
                  // fontWeight: FontWeight.bold,
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.blue,
                ),
              ),
              TextSpan(
                text:
                    'We have put together some tips to help you understand certain features of Bars Impression and to use this platform effectively.',
                style: TextStyle(
                  fontSize: 12.0,
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                ),
              ),
            ]),
          ),
          Divider(),
          SizedBox(height: 30),
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
                    "Tap and hold on a content to reveal more information.You can also slide contents (mood punch, a comment, an event question, or a forum thought) to the right for an edit action.",
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
