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
                    'We want to keep Bars Impression safe for all users, therefore certain words are not encourged on Bars Impression. A word that is  hate speech, threatening, harrasment, bullying, pornographic, incites violence, or contains nudity or graphic or gratuitous violence.These voilates the terms of use of Bars Impression as it is stated in section 3 under Safety.',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFFf2f2f2)
                            : Color(0xFF1a1a1a),
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.contentType,
                      style: TextStyle(
                          color: ConfigBloc().darkModeOn
                              ? Color(0xFFf2f2f2)
                              : Color(0xFF1a1a1a),
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '3.1 You will not solicit login information or access an account belonging to someone else.\n3.2 You will not collect or use the Content and Information of other users without their prior permission.\n3.3 You will not impersonate other users and non-users of Bars Impression in a manner intended to mislead, confuse, or deceive others.3.4 You will not bully, intimidate, or harass any user.\n3.5 You will not post content that is: hate speech, threatening, pornographic, incites violence, or contains nudity or graphic or gratuitous violence.\n3.6 You will not upload viruses or other malicious code.\n3.7 You will not post unauthorized commercial communications (such as spam).\n3.8 You will not develop or operate a third-party application containing alcohol-related, dating, or other mature content (including advertisements) without having appropriate age-based restrictions in place.\n3.9 You will not engage in unlawful multi-level marketing, such as pyramid schemes, in connection with your use of Bars Impression.\n3.10 You will not use Bars Impression to do anything unlawful, misleading, malicious, or discriminatory.\n3.11 You will not do anything that could disable, overburden, or impair the proper working or appearance of Bars Impression, such as a denial of service attack or interference with page rendering or other Bars Impression Service functionality.\n3.12 You may not use Bars Impression for any unlawful purposes or in furtherance of illegal activities.\n3.13 You will not engage in, facilitate, or encourage any violations of these Terms.',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFFf2f2f2)
                            : Color(0xFF1a1a1a),
                        fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                  GestureDetector(
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
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
