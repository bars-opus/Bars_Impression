import 'package:bars/utilities/exports.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  _aboutBars() {
    showAboutDialog(
        context: context,
        applicationName: 'Bars Impression',
        applicationVersion: 'Version 1.3.5',
        applicationIcon: Container(
          width: 40,
          height: 40,
          child: Image.asset(
            'assets/images/barsw.png',
            color: Colors.black,
          ),
        ),
        children: [
          Column(children: <Widget>[
            RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Version Release Date: February 2023\n",
                        style: TextStyle(
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 14),
                          color: Colors.black,
                        )),
                    TextSpan(
                        text: "Language: English.",
                        style: TextStyle(
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 14),
                          color: Colors.black,
                        )),
                  ],
                )),
          ])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Color(0xFF1a1a1a),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            new Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('assets/images/barsw.png',
                          height: 100, width: 100, fit: BoxFit.cover)),
                ],
              ),
            ),
            SizedBox(height: 50),
            Divider(
              thickness: .2,
              color: Colors.grey,
            ),
            Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () async {
                  if (!await launchUrl(
                      Uri.parse('https://www.barsopus.com/contact'))) {
                    throw 'Could not launch link';
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => MyWebView(
                  //               title: '',
                  //               url: 'https://www.barsopus.com/contact',
                  //             )));
                },
                child: Text(
                  'Contact us',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () async {
                  if (!await launchUrl(
                      Uri.parse('https://www.barsopus.com/terms-of-use'))) {
                    throw 'Could not launch link';
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => MyWebView(
                  //               title: '',
                  //               url: 'https://www.barsopus.com/terms-of-use',
                  //             )));
                },
                child: Text(
                  'Terms of use',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () async {
                  if (!await launchUrl(
                      Uri.parse('https://www.barsopus.com/privacy'))) {
                    throw 'Could not launch link';
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => MyWebView(
                  //               title: '',
                  //               url: 'https://www.barsopus.com/privacy',
                  //             )));
                },
                child: Text(
                  'Privacy policies',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: _aboutBars,
                child: Text(
                  'App info',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copyright,
                  size: ResponsiveHelper.responsiveFontSize(context, 15),
                  color: Colors.white,
                ),
                Text(
                  ' BARS OPUS LTD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
