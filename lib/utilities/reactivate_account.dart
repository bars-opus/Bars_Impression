import 'package:bars/utilities/exports.dart';
import 'package:hive/hive.dart';

class ReActivateAccount extends StatefulWidget {
  final AccountHolderAuthor user;

  ReActivateAccount({
    required this.user,
  });

  @override
  _ReActivateAccountState createState() => _ReActivateAccountState();
}

class _ReActivateAccountState extends State<ReActivateAccount> {
  // void _showBottomSheetErrorMessage(String error) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return DisplayErrorHandler(
  //         buttonText: 'Ok',
  //         onPressed: () async {
  //           Navigator.pop(context);
  //         },
  //         title: 'Failed to activate account',
  //         subTitle: error,
  //       );
  //     },
  //   );
  // }

  // _reActivate() {
  //   try {
  //     usersAuthorRef
  //         .doc(
  //       widget.user.userId,
  //     )
  //         .update({
  //       'disabledAccount': false,
  //     });
  //     mySnackBar(context, 'Your account was activated successfully!!!');
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => HomeScreen(),
  //       ),
  //     );
  //   } catch (e) {
  //     String error = e.toString();
  //     String result = error.contains(']')
  //         ? error.substring(error.lastIndexOf(']') + 1)
  //         : error;
  //     _showBottomSheetErrorMessage(result);
  //   }
  // }

  _reActivate() async {
    var _user = Provider.of<UserData>(context, listen: false).user;

    WriteBatch batch = FirebaseFirestore.instance.batch();



    batch.update(
      usersAuthorRef.doc(_user!.userId),
      {
        'disabledAccount': false,
      },
    );



    batch.update(
      usersGeneralSettingsRef.doc(_user.userId),
      {
        'disabledAccount': false,
      },
    );

    try {
      batch.commit();
      _updateAuthorHive();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ConfigPage()),
          (Route<dynamic> route) => false);
      mySnackBar(context, 'Your profile was activated successfully!!!');
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      _showBottomSheetErrorMessage('Failed to activate account', result);
      // Handle the error appropriately
    }
  }

  _updateAuthorHive() {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      name: _provider.user!.name,
      bio: _provider.user!.bio,
      disabledAccount: false,
      dynamicLink: _provider.user!.dynamicLink,
      lastActiveDate: _provider.user!.lastActiveDate,
      profileHandle: _provider.user!.profileHandle,
      profileImageUrl: _provider.user!.profileImageUrl,
      reportConfirmed: _provider.user!.reportConfirmed,
      userId: _provider.user!.userId,
      userName: _provider.user!.userName,
      verified: _provider.user!.verified,
    );

    // Put the new object back into the box with the same key
    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }

  void _showBottomSheetErrorMessage(String errorTitle, String error) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: errorTitle,
          subTitle: error,
        );
      },
    );
  }

  void _showBottomSheetConfirm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: 'Activate account',
          onPressed: () async {
            Navigator.pop(context);
            _reActivate();
          },
          title: 'Are you sure you want to activate your account?',
          subTitle: '',
        );
      },
    );
  }

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
                      'Activate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 50),
                        fontWeight: FontWeight.w100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Your Account',
                      style: TextStyle(
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 20),
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
                width: ResponsiveHelper.responsiveFontSize(context, 29),
                height: ResponsiveHelper.responsiveFontSize(context, 1),
                color: Color(0xFFD38B41),
              ),
            ),
            new Material(
              color: Colors.transparent,
              child: Text(
                'Welcome Back ${widget.user.userName}. You have deactivate your account. You can reactivate your account to start exploring events and connect with others.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: ResponsiveHelper.responsiveWidth(context, 250),
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                onPressed: () {
                  _showBottomSheetConfirm(context);
                },
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    'Activate',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
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
