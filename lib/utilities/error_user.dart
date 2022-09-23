import 'package:bars/utilities/exports.dart';

class ErrorUser extends StatelessWidget {
  const ErrorUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ShakeTransition(
              child: new Material(
                color: Colors.transparent,
                child: Icon(
                  Icons.error_outline,
                  size: 30,
                  color: Colors.white,
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
                'We run into a problem.\nTap to refresh.',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: Container(
                width: 200,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    primary: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Colors.white,
                    onPrimary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'refresh',
                      style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}


// import 'package:bars/utilities/exports.dart';
// import 'package:store_redirect/store_redirect.dart';

// class UpdateAppInfo extends StatefulWidget {
//   final String updateNote;

//   UpdateAppInfo({
//     required this.updateNote,
//   });

//   @override
//   _UpdateAppInfoState createState() => _UpdateAppInfoState();
// }

// class _UpdateAppInfoState extends State<UpdateAppInfo> {
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Color(0xFF1a1a1a),
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         elevation: 0,
//         backgroundColor: Color(0xFF1a1a1a),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             ShakeTransition(
//               child: new Material(
//                 color: Colors.transparent,
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20),
//                     Text(
//                       'Update',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 50.0,
//                         fontWeight: FontWeight.w100,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     Text(
//                       'Is Available',
//                       style: TextStyle(
//                           fontSize: 20.0,
//                           // letterSpacing: 2,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Container(
//                 width: 20,
//                 height: 1,
//                 color: Color(0xFFD38B41),
//               ),
//             ),
//             new Material(
//               color: Colors.transparent,
//               child: Text(
//                 widget.updateNote,
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: 50),
//             Center(
//               child: Container(
//                 width: width - 100,
//                 child: TextButton(
//                   style: ElevatedButton.styleFrom(
//                     primary: ConfigBloc().darkModeOn
//                         ? Color(0xFF1a1a1a)
//                         : Colors.white,
//                     onPrimary: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(3.0),
//                     ),
//                   ),
//                   onPressed: () {
//                     StoreRedirect.redirect(
//                       androidAppId: "com.barsOpus.barsImpression",
//                       iOSAppId: "1610868894",
//                     );
//                   },
//                   child: Material(
//                     color: Colors.transparent,
//                     child: Text(
//                       'Update',
//                       style: TextStyle(
//                         color: ConfigBloc().darkModeOn
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 100),
//           ],
//         ),
//       ),
//     );
//   }
// }
