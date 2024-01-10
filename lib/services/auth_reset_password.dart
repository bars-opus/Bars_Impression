import 'package:bars/utilities/exports.dart';

class AuthPassWord {
  static final _auth = FirebaseAuth.instance;
  static void resetPassword(
    BuildContext context,
    String email,
  ) async {
      mySnackBar(context, 'Submiting Email\nPlease wait...');
      await _auth.sendPasswordResetEmail(
        email: email,
      );
      Navigator.pop(context);
      mySnackBar(context, 'Done, link sent to:\n$email');
   
  }
}
