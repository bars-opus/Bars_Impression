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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
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
                  size: ResponsiveHelper.responsiveHeight(
                    context,
                    100,
                  ),
                ),
              ),
              Text(
                'We want to keep Bars Impression safe for all users, therefore certain words are not encourged on Bars Impression. A word that is  hate speech, threatening, harrasment, bullying, pornographic, incites violence, or contains nudity or graphic or gratuitous violence.These voilates the terms of use of Bars Impression.',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    14,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(
                        Uri.parse('https://www.barsopus.com/terms-of-use'))) {
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
                  child: Text(
                    'learn more',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(
                        context,
                        14,
                      ),
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
      ),
    );
  }
}
