import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';

class EditProfileName extends StatefulWidget {
  final AccountHolderAuthor user;

  EditProfileName({
    required this.user,
  });

  @override
  _EditProfileNameState createState() => _EditProfileNameState();
}

class _EditProfileNameState extends State<EditProfileName> {
  final _formKey = GlobalKey<FormState>();
  String query = "";
  late TextEditingController _controller;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false)
          .setChangeUserName(widget.user.userName!);
    });
    _controller = TextEditingController(
      text: widget.user.userName,
    );
    _focusNode = FocusNode();
    Future.delayed(Duration(milliseconds: 500), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Future<void> changeUsername(String oldUsername, String newUsername) async {
  //   final _firestore = FirebaseFirestore.instance;
  //   var _provider = Provider.of<UserData>(context, listen: false);

  //   try {
  //     _provider.setIsLoading(true);
  //     await _firestore.runTransaction((transaction) async {
  //       DocumentSnapshot oldUsernameDoc = await transaction
  //           .get(_firestore.collection('usernames').doc(oldUsername));

  //       if (!oldUsernameDoc.exists) {
  //         throw Exception('Old username does not exist');
  //       }

  //       DocumentSnapshot newUsernameDoc = await transaction
  //           .get(_firestore.collection('usernames').doc(newUsername));

  //       if (newUsernameDoc.exists) {
  //         throw ('The username you entered is already taken. Please choose a different username.');
  //       }
  //       String dynamicLink = await DatabaseService.myDynamicLink(
  //         _provider.user!.profileImageUrl!,
  //         newUsername.toUpperCase(),
  //         _provider.user!.bio!,
  //         'https://www.barsopus.com/user_${_provider.currentUserId}',
  //       );
  //       // Create the new username document
  //       DocumentReference newUsernameRef =
  //           _firestore.collection('usernames').doc(newUsername.toUpperCase());
  //       transaction.set(newUsernameRef, oldUsernameDoc.data());
  //       transaction.update(
  //         usersAuthorRef.doc(widget.user.userId),
  //         {
  //           'userName': newUsername.toUpperCase(),
  //           'dynamicLink': dynamicLink,
  //         },
  //       );

  //       transaction.update(
  //         userProfessionalRef.doc(widget.user.userId),
  //         {
  //           'userName': newUsername.toUpperCase(),
  //           'dynamicLink': dynamicLink,
  //         },
  //       );

  //       // Delete the old username document
  //       DocumentReference oldUsernameRef =
  //           _firestore.collection('usernames').doc(oldUsername);
  //       transaction.delete(oldUsernameRef);

  //       // Update the global user object

  //       _updateAuthorHive(newUsername.toUpperCase(), dynamicLink);
  //       Provider.of<UserData>(context, listen: false)
  //           .setChangeUserName(newUsername.toUpperCase());
  //       mySnackBar(context, 'Username changed successfully');
  //       Navigator.pop(context);
  //       Navigator.pop(context);
  //       // widget.user.userName = newUsername;
  //     });
  //     _provider.setIsLoading(false);
  //   } catch (e) {
  //     _provider.setIsLoading(false);
  //     mySnackBar(context, e.toString());
  //     // Rethrow the caught exception to handle it in the _validate method
  //     // throw e;
  //   }
  // }

  Future<void> changeUsername(String oldUsername, String newUsername) async {
    final _firestore = FirebaseFirestore.instance;
    var _provider = Provider.of<UserData>(context, listen: false);

    try {
      _provider.setIsLoading(true);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot oldUsernameDoc = await transaction
            .get(_firestore.collection('usernames').doc(oldUsername));

        if (!oldUsernameDoc.exists) {
          throw Exception('Old username does not exist');
        }

        DocumentSnapshot newUsernameDoc = await transaction
            .get(_firestore.collection('usernames').doc(newUsername));
        bool isTaken = await DatabaseService.isUsernameTaken(newUsername);

        if (isTaken || newUsernameDoc.exists) {
          throw Exception(
              'The username you entered is already taken. Please choose a different username.');
        }

        String dynamicLink = await DatabaseService.myDynamicLink(
          _provider.user!.profileImageUrl!,
          newUsername.toUpperCase(),
          _provider.user!.bio!,
          'https://www.barsopus.com/user_${_provider.currentUserId}',
        );

        // Create the new username document
        DocumentReference newUsernameRef =
            _firestore.collection('usernames').doc(newUsername.toUpperCase());

        // Set up the data for the new username
        Map<String, dynamic> newUsernameData = {
          'userId': _provider.currentUserId,
          // Add any other data that needs to be associated with the username here
        };

        // Update the user's document with the new username and dynamic link
        DocumentReference userDocRef = usersAuthorRef.doc(widget.user.userId);
        DocumentReference userProfessionalDocRef =
            userProfessionalRef.doc(widget.user.userId);

        Map<String, dynamic> userUpdateData = {
          'userName': newUsername.toUpperCase(),
          'dynamicLink': dynamicLink,
          // Include any other user fields that need to be updated
        };

        // Perform the updates
        transaction.set(newUsernameRef, newUsernameData);
        transaction.update(userDocRef, userUpdateData);
        transaction.update(userProfessionalDocRef, userUpdateData);

        // Delete the old username document
        DocumentReference oldUsernameRef =
            _firestore.collection('usernames').doc(oldUsername);
        transaction.delete(oldUsernameRef);

        // Update the global user object and UI
        _updateAuthorHive(newUsername.toUpperCase(), dynamicLink);
        _provider.setChangeUserName(newUsername.toUpperCase());
        mySnackBar(context, 'Username changed successfully');

        // Navigate back twice to exit the current screen and any dialog that might be open
        Navigator.pop(context);
        Navigator.pop(context);
      });
      _provider.setIsLoading(false);
    } catch (e) {
      _provider.setIsLoading(false);
      mySnackBar(context, e.toString());
    }
  }

  _validateTextToxicity(String changeUserName) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setIsLoading(true);

    TextModerator moderator = TextModerator();

    // Define the texts to be checked
    List<String> textsToCheck = [_controller.text.trim().toUpperCase()];

    // Set a threshold for toxicity that is appropriate for your app
    const double toxicityThreshold = 0.7;
    bool allTextsValid = true;

    for (String text in textsToCheck) {
      Map<String, dynamic>? analysisResult = await moderator.moderateText(text);

      // Check if the API call was successful
      if (analysisResult != null) {
        double toxicityScore = analysisResult['attributeScores']['TOXICITY']
            ['summaryScore']['value'];

        if (toxicityScore >= toxicityThreshold) {
          // If any text's score is above the threshold, show a Snackbar and set allTextsValid to false
          mySnackBarModeration(context,
              'Your username contains inappropriate content. Please review');
          _provider.setIsLoading(false);

          allTextsValid = false;
          break; // Exit loop as we already found inappropriate content
        }
      } else {
        // Handle the case where the API call failed
        _provider.setIsLoading(false);
        mySnackBar(context, 'Try again.');
        allTextsValid = false;
        break; // Exit loop as there was an API error
      }
    }

    // Animate to the next page if all texts are valid
    if (allTextsValid) {
      _provider.setIsLoading(false);

      await changeUsername(changeUserName.trim().toUpperCase(),
          _controller.text.trim().toUpperCase());

      // animateToPage(1);
    }
  }

  _validate(BuildContext context) async {
    var _changeUserName =
        Provider.of<UserData>(context, listen: false).changeNewUserName;
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // Check if the username has changed
      if (_changeUserName == _controller.text.trim()) {
        Navigator.pop(context);
      } else {
        try {
          _validateTextToxicity(_changeUserName);
        } catch (e) {
          mySnackBar(context, e.toString());
        }
      }
    }
  }

  _updateAuthorHive(String userName, String dynamicLink) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      name: _provider.user!.name,
      bio: _provider.user!.bio,
      disabledAccount: _provider.user!.disabledAccount,
      dynamicLink: dynamicLink,
      lastActiveDate: _provider.user!.lastActiveDate,
      profileHandle: _provider.user!.profileHandle,
      profileImageUrl: _provider.user!.profileImageUrl,
      reportConfirmed: _provider.user!.reportConfirmed,
      userId: _provider.user!.userId,
      userName: userName,
      verified: _provider.user!.verified,
      privateAccount: _provider.user!.privateAccount,
      disableChat: _provider.user!.disableChat,
    );

    // Put the new object back into the box with the same key
    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    return EditProfileScaffold(
      title: '',
      widget: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // if (_provider.isLoading) LinearProgress(),
              const SizedBox(
                height: 30,
              ),
              EditProfileInfo(
                  editTitle: 'Select \nUsername',
                  info:
                      'Select a unique username for your brand. The username can be your stage name if you are a music creator. Please note that all usernames are converted to uppercase.',
                  icon: MdiIcons.accountDetails),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, bottom: 10.0, right: 10.0),
                child: Container(
                  color: Colors.transparent,
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    autovalidateMode: AutovalidateMode.always,
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 3.0),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      hintText: 'A unique name to be identified with',
                      hintStyle: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 12.0),
                          color: Colors.grey),
                      labelText: 'Username',
                    ),
                    autofillHints: [AutofillHints.name],
                    validator: (input) {
                      if (input!.trim().length < 1) {
                        return 'Choose a username';
                      } else if (input.trim().contains(' ')) {
                        return 'Username cannot contain space, use ( _ or - )';
                      } else if (input.trim().contains('@')) {
                        return 'Username cannot contain @';
                      } else if (input.trim().length > 20) {
                        // assuming 20 as the maximum length
                        return 'Username cannot be longer than 20 characters';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              _provider.isLoading
                  ? Center(
                      child: SizedBox(
                        height:
                            ResponsiveHelper.responsiveHeight(context, 20.0),
                        width: ResponsiveHelper.responsiveHeight(context, 20.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : AlwaysWhiteButton(
                      buttonColor: Colors.blue,
                      buttonText: 'Save',
                      onPressed: () {
                        if (_controller.text.trim().isNotEmpty)
                          _validate(context);
                      },
                    ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
