import 'package:bars/utilities/exports.dart';
import 'package:hive/hive.dart';

class UsernameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> changeUsername(BuildContext context, String oldUsername,
      String newUsername, bool isSetUp, PageController? pageController) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    try {
      _provider.setIsLoading(true);
      await _firestore.runTransaction((transaction) async {
        if (oldUsername.isNotEmpty) {
          DocumentSnapshot oldUsernameDoc = await transaction
              .get(_firestore.collection('usernames').doc(oldUsername));

          if (!oldUsernameDoc.exists) {
            throw ('Old username does not exist');
          }
        }

        DocumentSnapshot newUsernameDoc = await transaction
            .get(_firestore.collection('usernames').doc(newUsername));
        bool isTaken = await DatabaseService.isUsernameTaken(newUsername);

        if (isTaken || newUsernameDoc.exists) {
          throw ('The username you entered is already taken. Please choose a different username.');
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
        DocumentReference userDocRef =
            usersAuthorRef.doc(_provider.currentUserId);
        DocumentReference userProfessionalDocRef =
            userProfessionalRef.doc(_provider.currentUserId);

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
        if (oldUsername.isNotEmpty) {
          DocumentReference oldUsernameRef =
              _firestore.collection('usernames').doc(oldUsername);
          transaction.delete(oldUsernameRef);
        }

        isSetUp
            ? _updateAuthorBioAndImgeUrlHive(
                context, newUsername.toUpperCase(), dynamicLink)
            : _updateAuthorHive(
                context, newUsername.toUpperCase(), dynamicLink);
        _provider.setChangeUserName(newUsername.toUpperCase());
        mySnackBar(context, 'Username changed successfully');
        if (!isSetUp) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          _provider.setInt2(2);
          if (pageController != null)
            pageController.animateToPage(
              1,
              duration: Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            );
        }
      });
      _provider.setIsLoading(false);
    } catch (e) {
      _provider.setIsLoading(false);
      mySnackBar(context, e.toString());
    }
  }

  Future<void> validateTextToxicity(
      BuildContext context,
      String changeUserName,
      TextEditingController controller,
      bool isSetUp,
      PageController? pageController) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setIsLoading(true);

    TextModerator moderator = TextModerator();

    List<String> textsToCheck = [controller.text.trim().toUpperCase()];

    const double toxicityThreshold = 0.7;
    bool allTextsValid = true;

    for (String text in textsToCheck) {
      Map<String, dynamic>? analysisResult = await moderator.moderateText(text);

      if (analysisResult != null) {
        double toxicityScore = analysisResult['attributeScores']['TOXICITY']
            ['summaryScore']['value'];

        if (toxicityScore >= toxicityThreshold) {
          mySnackBarModeration(context,
              'Your username contains inappropriate content. Please review');
          _provider.setIsLoading(false);

          allTextsValid = false;
          break;
        }
      } else {
        _provider.setIsLoading(false);
        mySnackBar(context, 'Try again.');
        allTextsValid = false;
        break;
      }
    }

    if (allTextsValid) {
      _provider.setIsLoading(false);

      await changeUsername(context, changeUserName.trim().toUpperCase(),
          controller.text.trim().toUpperCase(), isSetUp, pageController);
    }
  }

  _updateAuthorBioAndImgeUrlHive(
      BuildContext context, String userName, String dynamicLink) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      name: _provider.name,
      bio: _provider.user!.bio,
      disabledAccount: false,
      dynamicLink: dynamicLink,
      lastActiveDate: Timestamp.fromDate(DateTime.now()),
      profileHandle: _provider.profrilehandle,
      profileImageUrl: _provider.user!.profileImageUrl,
      reportConfirmed: false,
      userId: _provider.currentUserId,
      userName: userName,
      verified: false,
      privateAccount: false,
      disableChat: false,
    );

    // Put the new object back into the box with the same key
    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }

  void _updateAuthorHive(
      BuildContext context, String userName, String dynamicLink) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

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

    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }
}
