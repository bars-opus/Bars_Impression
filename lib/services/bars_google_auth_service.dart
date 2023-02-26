import 'package:bars/general/pages/discover/discover_user.dart';
import 'package:bars/utilities/exports.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class BarsGoogleAuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static googleSignUpUser(BuildContext context, String from) async {
    try {
      await Provider.of<UserData>(context, listen: false).googleLogin();

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
          from.startsWith("Register") ? 'Registering account' : 'Signing In',
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
      final signedInHandler = FirebaseAuth.instance.currentUser!;

      AccountHolder profileUser =
          await DatabaseService.getUserWithId(signedInHandler.uid);
      if (profileUser.userName!.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiscoverUser(
              currentUserId: FirebaseAuth.instance.currentUser!.uid,
              isWelcome: true,
            ),
          ),
        );

        Flushbar(
          maxWidth: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(8),
          flushbarPosition: FlushbarPosition.TOP,
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          titleText: Text(
            'Sign In Successful',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          icon: Icon(
            MdiIcons.checkCircleOutline,
            size: 30.0,
            color: Colors.blue,
          ),
          messageText: Text(
            "Welcome Back...",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      } else {
        // ignore: unnecessary_null_comparison
        if (signedInHandler != null) {
          _firestore.collection('/users').doc(signedInHandler.uid).set({
            'name': signedInHandler.displayName ?? '',
            'email': signedInHandler.email,
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
            'disableAdvice': true,
            'disableChat': true,
            'enableBookingOnChat': false,
            'hideAdvice': false,
            'noBooking': false,
            'disabledAccount': false,
            'disableContentSharing': false,
            'disableMoodPunchReaction': false,
            'disableMoodPunchVibe': true,
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
            'disableChat': true,
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
      }
    } catch (e) {}
  }

  static appleSignUpUser(BuildContext context, String from) async {
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
          from.startsWith("Register") ? 'Registering account' : 'Signing In',
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

      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthProvider oAuthProvider = new OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );
      await _auth.signInWithCredential(credential);
      final signedInHandler = FirebaseAuth.instance.currentUser!;

      AccountHolder profileUser =
          await DatabaseService.getUserWithId(signedInHandler.uid);
      if (profileUser.userName!.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiscoverUser(
              currentUserId: FirebaseAuth.instance.currentUser!.uid,
              isWelcome: true,
            ),
          ),
        );

        Flushbar(
          maxWidth: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(8),
          flushbarPosition: FlushbarPosition.TOP,
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          titleText: Text(
            'Sign In Successful',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          icon: Icon(
            MdiIcons.checkCircleOutline,
            size: 30.0,
            color: Colors.blue,
          ),
          messageText: Text(
            "Welcome Back...",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      } else {
        // ignore: unnecessary_null_comparison
        if (signedInHandler != null) {
          _firestore.collection('/users').doc(signedInHandler.uid).set({
            'name': signedInHandler.displayName ?? '',
            'email': signedInHandler.email,
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
            'disableAdvice': true,
            'disableChat': true,
            'enableBookingOnChat': false,
            'hideAdvice': false,
            'noBooking': false,
            'disabledAccount': false,
            'disableContentSharing': false,
            'disableMoodPunchReaction': false,
            'disableMoodPunchVibe': true,
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
      }
    } catch (e) {}
  }
}
