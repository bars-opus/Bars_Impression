import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class ViolatingTerms extends StatefulWidget {
  static final id = 'ViolatingTerms_screen';
  final String link;
  final String contentType;

  const ViolatingTerms({
    required this.link,
    required this.contentType,
  });

  @override
  _ViolatingTermsState createState() => _ViolatingTermsState();
}

class _ViolatingTermsState extends State<ViolatingTerms> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          appBar: AppBar(
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
            iconTheme: IconThemeData(
                color: ConfigBloc().darkModeOn
                    ? Color(0xFFf2f2f2)
                    : Color(0xFF1a1a1a)),
            automaticallyImplyLeading: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  ShakeTransition(
                    child: Icon(
                      Icons.warning_amber,
                      color: Colors.blue,
                      size: 100.0,
                    ),
                  ),
                  Text(
                    'We want to keep Bars Impression safe for all users, therefore certain words are not encourged on Bars Impression. A word that is  hate speech, threatening, harrasment, bullying, pornographic, incites violence, or contains nudity or graphic or gratuitous violence.These voilates the terms of use of Bars Impression.',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFFf2f2f2)
                            : Color(0xFF1a1a1a),
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  Center(
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
                      child: Text(
                        'learn more',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
