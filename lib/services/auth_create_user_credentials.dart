import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

class AuthCreateUserCredentials extends StatefulWidget {
  const AuthCreateUserCredentials({Key? key}) : super(key: key);

  @override
  State<AuthCreateUserCredentials> createState() =>
      _AuthCreateUserCredentialsState();
}

class _AuthCreateUserCredentialsState extends State<AuthCreateUserCredentials> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      signUpUser(context);
    });
  }

  signUpUser(
    BuildContext context,
  ) async {
    mySnackBar(context, 'Registering account\nPlease wait...');

    final signedInHandler = FirebaseAuth.instance.currentUser!;
    // ignore: unnecessary_null_comparison
    if (signedInHandler != null) {
      try {
        await DatabaseService.createUserProfileInFirestore(signedInHandler,
            Provider.of<UserData>(context, listen: false).name);
        Provider.of<UserData>(context, listen: false).currentUserId =
            signedInHandler.uid;

        Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SetUpBrand()),
            (Route<dynamic> route) => false);
      } catch (e) {
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        mySnackBar(context, result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
