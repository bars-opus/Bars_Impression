import 'package:bars/utilities/exports.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static signUpUser(
      BuildContext context, String name, String email, String password) async {
    mySnackBar(context, 'Registering account\nPlease wait...');
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => SignpsScreenVerifyEmail(
                  email: email,
                )),
        (Route<dynamic> route) => false);
  }

  static verifyUseer(
    BuildContext context,
    String email,
  ) async {
    try {
      User? signedInHandler = FirebaseAuth.instance.currentUser;
      Provider.of<UserData>(context, listen: false).setIsLoading(false);

      if (signedInHandler != null) {
        await DatabaseService.createUserProfileInFirestore(signedInHandler,
            Provider.of<UserData>(context, listen: false).name);

        Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
        mySnackBar(context, 'Registration Successful.');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ConfigPage()),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      mySnackBar(context, 'Sign up failed\n$result.toString(),');
    }
  }
}
