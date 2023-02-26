import 'package:bars/utilities/exports.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        backgroundColor: Color(0xFF1a1a1a),
        margin: EdgeInsets.all(8),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Color(0xFF1a1a1a),
        progressIndicatorValueColor: AlwaysStoppedAnimation(Colors.blue),
        flushbarPosition: FlushbarPosition.TOP,
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        titleText: Text(
          'Registering account',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          "Please wait...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      )..show(context);

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SignpsScreenVerifyEmail()),
          (Route<dynamic> route) => false);
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        titleText: Text(
          'Sign up failed',
          style: TextStyle(color: Colors.white),
        ),
        messageText: Container(
            child: Text(
          result.toString(),
          style: TextStyle(color: Colors.white),
        )),
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.blue),
        mainButton: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.transparent,
            side: BorderSide(width: 1.0, color: Colors.transparent),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text("Ok",
              style: TextStyle(
                color: Colors.blue,
              )),
        ),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
      print(e.toString());
    }
  }

  static verifyUseer(
    BuildContext context,
    String name,
    String email,
  ) async {
    try {
      User? signedInHandler = FirebaseAuth.instance.currentUser;

      if (signedInHandler != null) {
        _firestore.collection('/users').doc(signedInHandler.uid).set({
          'name': name,
          'email': email,
          'timestamp': Timestamp.fromDate(DateTime.now()),
          'verified': '',
          'userName': '',
          'profileImageUrl': '',
          'bio': '',
          'favouritePunchline': '',
          'favouriteArtist': '',
          'favouriteSong': '',
          'favouriteAlbum': '',
          'company': '',
          'country': '',
          'city': '',
          'continent': '',
          'skills': '',
          'performances': '',
          'collaborations': '',
          'awards': '',
          'management': '',
          'contacts': '',
          'profileHandle': '',
          'report': '',
          'score': 0,
          'reportConfirmed': '',
          'website': '',
          'otherSites1': '',
          'otherSites2': '',
          'mail': '',
          'privateAccount': false,
          'androidNotificationToken': '',
          'hideUploads': false,
          'disableAdvice': false,
          'disableChat': false,
          'enableBookingOnChat': false,
          'hideAdvice': false,
          'noBooking': false,
          'disabledAccount': false,
          'disableContentSharing': false,
          'disableMoodPunchReaction': false,
          'disableMoodPunchVibe': false,
          'dontShowContentOnExplorePage': false,
          'isEmailVerified': true,
          'specialtyTags': '',
          'blurHash': '',
          'professionalPicture1': '',
          'professionalPicture2': '',
          'professionalPicture3': '',
          'professionalVideo1': '',
          'professionalVideo2': '',
          'professionalVideo3': '',
          'genreTags': '',
          'subAccountType': '',
        });
        Provider.of<UserData>(context, listen: false).currentUserId =
            signedInHandler.uid;
        followersRef
            .doc(signedInHandler.uid)
            .collection('userFollowers')
            .doc(signedInHandler.uid)
            .set({
          'uid': signedInHandler.uid,
        });
        _firestore.collection('/usersAuthors').doc(signedInHandler.uid).set({
          'verified': '',
          'userName': '',
          'profileImageUrl': '',
          'bio': '',
          'profileHandle': '',
          'disableChat': false,
        });
        Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => TipScreen()),
            (Route<dynamic> route) => false);
        return Flushbar(
          maxWidth: MediaQuery.of(context).size.width,
          backgroundColor: Colors.white,
          margin: EdgeInsets.all(8),
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Text(
            'Registration Successful',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          icon: Icon(
            MdiIcons.checkCircleOutline,
            size: 30.0,
            color: Colors.blue,
          ),
          messageText: RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(children: [
              TextSpan(
                  text:
                      "We have put together some tips to help you understand certain features of Bars Impression and to use this platform effectively.",
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ]),
          ),
          isDismissible: false,
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        titleText: Text(
          'Sign up failed',
          style: TextStyle(color: Colors.white),
        ),
        messageText: Container(
            child: Text(
          result.toString(),
          style: TextStyle(color: Colors.white),
        )),
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.blue),
        mainButton: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.transparent,
            side: BorderSide(width: 1.0, color: Colors.transparent),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text("Ok",
              style: TextStyle(
                color: Colors.blue,
              )),
        ),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
      print(e.toString());
    }
  }
}
