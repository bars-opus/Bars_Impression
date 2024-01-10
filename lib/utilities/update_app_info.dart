import 'package:bars/utilities/exports.dart';
import 'package:store_redirect/store_redirect.dart';

class UpdateAppInfo extends StatefulWidget {
  final String updateNote;

  final String version;

  UpdateAppInfo({
    required this.updateNote,
    required this.version,
  });

  @override
  _UpdateAppInfoState createState() => _UpdateAppInfoState();
}

class _UpdateAppInfoState extends State<UpdateAppInfo> {
  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Color(0xFF1a1a1a),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ShakeTransition(
              child: new Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:ResponsiveHelper.responsiveFontSize(context, 50),
                        fontWeight: FontWeight.w100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Is Available',
                      style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
                          // letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 20,
                height: 1,
                color: Color(0xFFD38B41),
              ),
            ),
            new Material(
              color: Colors.transparent,
              child: Text(
                widget.updateNote,
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: Container(
                width:ResponsiveHelper.responsiveHeight(context, 250),
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  onPressed: () {
                    StoreRedirect.redirect(
                      androidAppId: "com.barsOpus.barsImpression",
                      iOSAppId: "1610868894",
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100),
            Text(
              'New version: ${widget.version}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
