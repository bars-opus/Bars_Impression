import 'package:bars/utilities/exports.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class BarsGoogleAuthService {
  static final _auth = FirebaseAuth.instance;

  static googleSignUpUser(BuildContext context, String from) async {
    try {
      await Provider.of<UserData>(context, listen: false).googleLogin();
      mySnackBar(
          context,
          from.startsWith("Register")
              ? 'Registering account'
              : 'Signing In' + '\nPlease wait...');

      final signedInHandler = FirebaseAuth.instance.currentUser!;
      AccountHolderAuthor? profileUser =
          await DatabaseService.getUserWithId(signedInHandler.uid);
      Provider.of<UserData>(context, listen: false).currentUserId =
          signedInHandler.uid;

      if (profileUser != null && profileUser.userName!.isNotEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ConfigPage()),
            (Route<dynamic> route) => false);
        mySnackBar(context, 'Welcome Back...');
      } else {
        await DatabaseService.createUserProfileInFirestore(signedInHandler, '');
        Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ConfigPage()),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      mySnackBar(context,
          'An error occurred while signing in with Google. Please try again.');
    }
  }

  static Future<void> appleSignUpUser(BuildContext context, String from) async {
    try {
      mySnackBar(
          context,
          from.startsWith("Register")
              ? 'Registering account'
              : 'Signing In' + '\nPlease wait...');

      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
      );

      final OAuthProvider oAuthProvider = new OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      await _auth.signInWithCredential(credential);
      final signedInHandler = FirebaseAuth.instance.currentUser!;

      AccountHolderAuthor? profileUser =
          await DatabaseService.getUserWithId(signedInHandler.uid);
      Provider.of<UserData>(context, listen: false).currentUserId =
          signedInHandler.uid;

      if (profileUser != null && profileUser.userName!.isNotEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ConfigPage()),
            (Route<dynamic> route) => false);

        mySnackBar(context, 'Sign In Successful\nWelcome Back...');
      } else {
        await DatabaseService.createUserProfileInFirestore(signedInHandler, '');

        // await createUserProfileInFirestore(signedInHandler);
        Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ConfigPage()),
            (Route<dynamic> route) => false); // _successSnackBar(context);
      }
    } catch (e) {
      // Handle error
      mySnackBar(context,
          'An error occurred while signing in with Apple. Please try again.');
    }
  }
}
