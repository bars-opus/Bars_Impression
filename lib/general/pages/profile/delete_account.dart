import 'package:bars/utilities/exports.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:hive/hive.dart';

// ignore: must_be_immutable
class DeleteAccount extends StatefulWidget {
  static final id = 'DeleteAccount_screen';
  final AccountHolderAuthor user;

  DeleteAccount({
    required this.user,
  });

  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  late PageController _pageController;
  int _index = 0;
  final _passwordController = TextEditingController();
  String reathenticateType = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
    deleteUserAccount();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  deleteUserAccount() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      List<UserInfo> providerData = user.providerData;
      bool isGoogleSignIn = false;
      bool isAppleSignIn = false;

      for (UserInfo userInfo in providerData) {
        if (userInfo.providerId == GoogleAuthProvider.PROVIDER_ID) {
          isGoogleSignIn = true;
        } else if (userInfo.providerId == "apple.com") {
          isAppleSignIn = true;
        }
      }

      if (isGoogleSignIn) {
        reathenticateType = 'Google';
      } else if (isAppleSignIn) {
        reathenticateType = 'Apple';
      } else {
        reathenticateType = 'Email';
      }
    }
  }

  _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
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

  static final _auth = FirebaseAuth.instance;

  _deActivate() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(
      usersAuthorRef.doc(widget.user.userId),
      {
        'disabledAccount': true,
      },
    );

    batch.update(
      usersGeneralSettingsRef.doc(widget.user.userId),
      {
        'disabledAccount': true,
        'androidNotificationToken': '',
      },
    );

    try {
      batch.commit();
      _deleteHive();
      await _auth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Intro(),
        ),
      );

      mySnackBar(context, 'Your profile was deactivated successfully!!!');
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      _showBottomSheetErrorMessage('Failed to deactivate account', result);
      // Handle the error appropriately
    }
    // try {
    //   usersAuthorRef
    //       .doc(
    //     widget.user.userId,
    //   )
    //       .update({
    //     'disabledAccount': true,
    //   });

    // } catch (e) {

    //   String error = e.toString();
    //   String result = error.contains(']')
    //       ? error.substring(error.lastIndexOf(']') + 1)
    //       : error;
    //   _showBottomSheetErrorMessage('Failed to delete account', result);

    // }
  }

  // Future<void> _deleteDocuments(String collectionPath, String userId) async {
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection(collectionPath)
  //       .where('userId', isEqualTo: userId)
  //       .get();
  //   for (var docSnapshot in querySnapshot.docs) {
  //     await docSnapshot.reference.delete();
  //   }
  // }

  Future<void> _deleteStorageFolder(String folderPath) async {
    ListResult listResult =
        await FirebaseStorage.instance.ref(folderPath).listAll();
    for (var item in listResult.items) {
      await item.delete();
    }
  }

  // Future<void> deleteSentInvite(String currentUserId) async {
  //   QuerySnapshot snapshot = await sentEventIviteRef
  //       .where('inviteeId', isEqualTo: currentUserId)
  //       .get();

  //   WriteBatch batch = FirebaseFirestore.instance.batch();

  //   snapshot.docs.forEach((doc) {
  //     batch.delete(doc.reference);
  //   });

  //   await batch.commit();
  // }

  // Future<void> deleteAdvice(String currentUserId) async {
  //   QuerySnapshot snapshot =
  //       await userAdviceRef.where('authorId', isEqualTo: currentUserId).get();

  //   WriteBatch batch = FirebaseFirestore.instance.batch();

  //   snapshot.docs.forEach((doc) {
  //     batch.delete(doc.reference);
  //   });

  //   await batch.commit();
  // }

  // Future<void> deleteEventAsks(String currentUserId) async {
  //   QuerySnapshot snapshot =
  //       await asksRef.where('authorId', isEqualTo: currentUserId).get();

  //   WriteBatch batch = FirebaseFirestore.instance.batch();

  //   snapshot.docs.forEach((doc) {
  //     batch.delete(doc.reference);
  //   });

  //   await batch.commit();
  // }

  // Future<void> deleteChatrRoomMessages(String currentUserId) async {
  //   QuerySnapshot snapshot = await eventsChatRoomsConverstionRef
  //       .where('senderId', isEqualTo: currentUserId)
  //       .get();

  //   WriteBatch batch = FirebaseFirestore.instance.batch();

  //   snapshot.docs.forEach((doc) {
  //     batch.delete(doc.reference);
  //   });

  //   await batch.commit();
  // }

  Future<void> deleteChatRoom(String currentUserId) async {
    QuerySnapshot snapshot = await eventsChatRoomsRef
        .where('senderId', isEqualTo: currentUserId)
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    snapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    await batch.commit();
  }

  // Future<void> deleteNewEventTicketOrder(String currentUserId) async {
  //   QuerySnapshot snapshot = await newEventTicketOrderRef
  //       .where('userOrderId', isEqualTo: currentUserId)
  //       .get();

  //   WriteBatch batch = FirebaseFirestore.instance.batch();

  //   snapshot.docs.forEach((doc) {
  //     batch.delete(doc.reference);
  //   });

  //   await batch.commit();
  // }

  // Future<void> deleteAllEvents(String currentUserId) async {
  //   QuerySnapshot snapshot =
  //       await allEventsRef.where('authorId', isEqualTo: currentUserId).get();

  //   WriteBatch batch = FirebaseFirestore.instance.batch();

  //   snapshot.docs.forEach((doc) {
  //     batch.delete(doc.reference);
  //   });

  //   await batch.commit();
  // }

  Future<void> deleteAllSenderMessages(String currentUserId) async {
    QuerySnapshot snapshot =
        await messageRef.where('senderId', isEqualTo: currentUserId).get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    snapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    await batch.commit();
  }

  Future<void> deleteAllReceiverMessages(String currentUserId) async {
    QuerySnapshot snapshot =
        await messageRef.where('receiverId', isEqualTo: currentUserId).get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    snapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    await batch.commit();
  }

  // Future<void> deleteFollowers(String currentUserId) async {
  //   QuerySnapshot snapshot =
  //       await followersRef.where('userId', isEqualTo: currentUserId).get();

  //   WriteBatch batch = FirebaseFirestore.instance.batch();

  //   snapshot.docs.forEach((doc) {
  //     batch.delete(doc.reference);
  //   });

  //   await batch.commit();
  // }

  void _reauthenticate() async {
    FocusScope.of(context).unfocus();
    try {
      mySnackBar(context, 'Deleting Account\nPlease wait...');

      await _auth.signInWithEmailAndPassword(
        email: _auth.currentUser!.email!,
        password: _passwordController.text.trim(),
      );

      animateForward();
      _deleteAccount(context);
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      _showBottomSheetErrorMessage('Authentication failed', result);
    }
  }

  // nT4CrmVLB6VPaQglyq0vgqAbF452
  // f9iDwxBuw0XniGUP7ROtIhKKd6n2
  // Ys0gvO4DO8cJeYEZGUZZX56oPCv2

  // v2K3Pi4HuHcQ3LyIOwKkdT2uSo63

  // zlhI0sU1InSWF4FThGLTzwuvJGG3

  // dAh8m9fBLbSG2nA4KX3Y1R1mG8r1

  // hjtiDuoaDOdtpG07sS7aPNJZY2J3

  // fiTBRa9hOJaownGdbv8jaoq5yO13

  Future<void> deletePaystackData(
      String subAccountId, String transferId) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('deletePaystackData');

    try {
      final result = await callable.call(<String, dynamic>{
        'subAccountId': subAccountId,
        'transferId': transferId,
      });

      // Use the data returned from the callable function
      print(result.data);
    } on FirebaseFunctionsException catch (e) {
      // Handle Firebase Functions exceptions
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      // Handle other exceptions
      print(e);
    }
  }

  void _deleteAccount(BuildContext context) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    await deletePaystackData(_provider.userLocationPreference!.subaccountId!,
        _provider.userLocationPreference!.transferRecepientId!);
    final String currentUserId = _provider.currentUserId!;

    print(currentUserId);

    final String userName = _provider.user!.userName!;
    FocusScope.of(context).unfocus();
    // try {

    // Define all storage paths
    List<String> storagePaths = [
      'images/events/$currentUserId',
      'images/messageImage/$currentUserId',
      'images/users/$currentUserId',
      'images/professionalPicture1/$currentUserId',
      'images/professionalPicture2/$currentUserId',
      'images/professionalPicture3/$currentUserId',
      'images/posts/$currentUserId',
      'images/validate/$currentUserId',
    ];

    for (var path in storagePaths) {
      await _deleteStorageFolder(path);
    }

    await deleteAllSenderMessages(currentUserId);
    await deleteAllReceiverMessages(currentUserId);

    // Delete user user_workRequest
    final CollectionReference userWorkRequest = FirebaseFirestore.instance
        .collection('user_workRequest')
        .doc(currentUserId)
        .collection('workRequests');
    final QuerySnapshot userWorkRequestSnapshot = await userWorkRequest.get();
    for (var doc in userWorkRequestSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete user user_advice
    final CollectionReference userAdvice = FirebaseFirestore.instance
        .collection('new_userAdvice')
        .doc(currentUserId)
        .collection('userAdvice');
    final QuerySnapshot userAdviceSnapshot = await userAdvice.get();
    for (var doc in userAdviceSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete user user_workRequest
    final CollectionReference userFollower = FirebaseFirestore.instance
        .collection('new_followers')
        .doc(currentUserId)
        .collection('userFollowers');
    final QuerySnapshot userFollowerSnapshot = await userFollower.get();
    for (var doc in userFollowerSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete user newUsersInvite
    final CollectionReference newUsersInvite = FirebaseFirestore.instance
        .collection('new_usersInvite')
        .doc(currentUserId)
        .collection('userEventFeed');
    final QuerySnapshot newUsersInviteSnapshot = await newUsersInvite.get();
    for (var doc in newUsersInviteSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete user newActivities
    final CollectionReference newActivities = FirebaseFirestore.instance
        .collection('new_activities')
        .doc(currentUserId)
        .collection('userActivities');
    final QuerySnapshot newActivitiesSnapshot = await newActivities.get();
    for (var doc in newActivitiesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete user new_eventFeeds
    final CollectionReference eventFeeds = FirebaseFirestore.instance
        .collection('new_eventFeeds')
        .doc(currentUserId)
        .collection('userEventFeed');
    final QuerySnapshot eventFsnapshot = await eventFeeds.get();
    for (var doc in eventFsnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete user new_userTicketOrder
    final CollectionReference newUserTicketOrder = FirebaseFirestore.instance
        .collection('new_userTicketOrder')
        .doc(currentUserId)
        .collection('eventInvite');
    final QuerySnapshot newUserTicketOrderSnapshot =
        await newUserTicketOrder.get();
    for (var doc in newUserTicketOrderSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete user new_userTicketOrder
    final CollectionReference newTicketId = FirebaseFirestore.instance
        .collection('new_ticketId')
        .doc(currentUserId)
        .collection('eventInvite');
    final QuerySnapshot newTicketIdSnapshot = await newTicketId.get();
    for (var doc in newTicketIdSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete user newEvents
    final CollectionReference newEvents = FirebaseFirestore.instance
        .collection('new_events')
        .doc(currentUserId)
        .collection('userEvents');
    final QuerySnapshot newEventsSnapshot = await newEvents.get();
    for (var doc in newEventsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete user userName
    await FirebaseFirestore.instance
        .collection('usernames')
        .doc(userName)
        .delete();

    // Delete user user_author
    await FirebaseFirestore.instance
        .collection('user_author')
        .doc(currentUserId)
        .delete();

    // Delete user user_location_settings
    await FirebaseFirestore.instance
        .collection('user_location_settings')
        .doc(currentUserId)
        .delete();

    // Delete user user_professsional
    await FirebaseFirestore.instance
        .collection('user_professsional')
        .doc(currentUserId)
        .delete();

    // Delete user user_general_settings
    await FirebaseFirestore.instance
        .collection('user_general_settings')
        .doc(currentUserId)
        .delete();
    await _auth.currentUser!.delete();
    await _deleteHive();

    // await _auth.signOut();
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Intro()),
          (Route<dynamic> route) => false);
    });

    HapticFeedback.lightImpact();
    mySnackBar(context, 'Account deleted');
  }

  _deleteHive() async {
    // Helper function to clear a box
    Future<void> _clearBox<T>(String boxName) async {
      Box<T> box;
      if (Hive.isBoxOpen(boxName)) {
        box = Hive.box<T>(boxName);
      } else {
        box = await Hive.openBox<T>(boxName);
      }
      await box.clear();
    }

    // Clear all the required Hive boxes
    await _clearBox<ChatMessage>('chatMessages');
    await _clearBox<AccountHolderAuthor>('accountHolderAuthor');
    await _clearBox<Chat>('chats');
    await _clearBox<TicketIdModel>('ticketIds');
    await _clearBox<AccountHolderAuthor>('currentUser');
    await _clearBox<UserSettingsLoadingPreferenceModel>(
        'accountLocationPreference');
  }

  // _deleteHive() async {
  //   if (Hive.isBoxOpen('chatMessages')) {
  //     final box = Hive.box<ChatMessage>('chatMessages');
  //     await box.clear();
  //   } else {
  //     final box = await Hive.openBox<ChatMessage>('chatMessages');
  //     await box.clear();
  //   }

  //   if (Hive.isBoxOpen('accountHolderAuthor')) {
  //     final box = Hive.box<AccountHolderAuthor>('accountHolderAuthor');
  //     await box.clear();
  //   } else {
  //     final box =
  //         await Hive.openBox<AccountHolderAuthor>('accountHolderAuthor');
  //     await box.clear();
  //   }
  //   if (Hive.isBoxOpen('chats')) {
  //     final box = Hive.box<Chat>('chats');
  //     await box.clear();
  //   } else {
  //     final box = await Hive.openBox<Chat>('chats');
  //     await box.clear();
  //   }

  //   if (Hive.isBoxOpen('ticketIds')) {
  //     final box = Hive.box<TicketIdModel>('ticketIds');
  //     await box.clear();
  //   } else {
  //     final box = await Hive.openBox<TicketIdModel>('ticketIds');
  //     await box.clear();
  //   }

  //   if (Hive.isBoxOpen('currentUser')) {
  //     final box = Hive.box<AccountHolderAuthor>('currentUser');
  //     await box.clear();
  //   } else {
  //     final box = await Hive.openBox<AccountHolderAuthor>('currentUser');
  //     await box.clear();
  //   }

  //   if (Hive.isBoxOpen('accountLocationPreference')) {
  //     final box = Hive.box<UserSettingsLoadingPreferenceModel>(
  //         'accountLocationPreference');
  //     await box.clear();
  //   } else {
  //     final box = await Hive.openBox<UserSettingsLoadingPreferenceModel>(
  //         'accountLocationPreference');
  //     await box.clear();
  //   }
  // }

  Future<void> reauthenticateWithApple(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the ID token from the user
      String? idToken = await user.getIdToken();

      // Create an OAuthCredential using the ID token and provider ID
      OAuthCredential credential =
          OAuthProvider('apple.com').credential(idToken: idToken);

      try {
        // Reauthenticate the user with the credential
        animateForward();
        await user.reauthenticateWithCredential(credential);
        deletedDeactivatedAccountRef.add({
          'author': widget.user.userName,
          'timestamp': Timestamp.fromDate(DateTime.now()),
        });
        _deleteAccount(context);
        // Reauthentication successful
      } catch (error) {
        // Handle reauthentication error
      }
    }
  }

  Future<void> reauthenticateWithGoogle() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        try {
          animateForward();
          await user.reauthenticateWithCredential(credential);

          await deletedDeactivatedAccountRef.add({
            'author': widget.user.userName,
            'timestamp': Timestamp.fromDate(DateTime.now()),
          });

          _deleteAccount(context);
          // Reauthentication successful
        } catch (error) {
          // Handle reauthentication error
        }
      }
    }
  }

  animateBack() {
    _pageController.animateToPage(
      _index - 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateForward() {
    _pageController.animateToPage(
      _index + 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _showBottomConfirm(String title, String subTitle, String buttonText,
      VoidCallback onPressed) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: buttonText,
          onPressed: onPressed,
          title: title,
          subTitle: subTitle,
        );
      },
    );
  }

  _why() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Material(
              color: Colors.transparent,
              child: Text(
                'Why?',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.responsiveHeight(
                    context,
                    40,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'We would like to know why you want to delete your account. This information helps improve our platform.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IntroInfo(
              subTitleColor: Theme.of(context).secondaryHeaderColor,
              title: 'Non-beneficial',
              subTitle:
                  "Bars Impression platform is not helpful to you in any way.",
              icon: Icons.arrow_forward_ios_outlined,
              onPressed: () {
                animateForward();
              },
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IntroInfo(
              subTitleColor: Theme.of(context).secondaryHeaderColor,
              onPressed: () {
                animateForward();
              },
              title: 'Issues with content',
              subTitle:
                  'You don\'t like the type of content shared on Bars Impression.',
              icon: Icons.arrow_forward_ios_outlined,
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ContentFieldBlack(
              labelText: 'Other reasons',
              hintText: "Specify any other reasons",
              initialValue: '',
              onSavedText: (input) => '',
              onValidateText: () {},
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  _deactivateInstead() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Material(
              color: Colors.transparent,
              child: Text(
                'Deactivate your account instead?',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IntroInfo(
              subTitleColor: Theme.of(context).secondaryHeaderColor,
              title: 'Deactivating your account is temporary.',
              subTitle:
                  "Your information and contents would be hidden until you reactivate your account again",
              icon: Icons.arrow_forward_ios_outlined,
              onPressed: () {
                _showBottomConfirm(
                    'Are you sure you want deactivate your account?',
                    'Your information and contents would be hidden until you reactivate your account again',
                    'Deactivate', () {
                  _deActivate();
                });
              },
            ),
          ),
          Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {
                animateForward();
              },
              child: IntroInfo(
                subTitleColor: Theme.of(context).secondaryHeaderColor,
                onPressed: () {
                  animateForward();
                },
                title: 'Deleting your account is permanent.',
                subTitle:
                    'Deleting your account would erase all your user data and every content you have created. Your account cannot be recovered after you have deleted it.',
                icon: Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          Divider(color: Colors.grey),
        ],
      ),
    );
  }

  _googleSignIn() {
    return SignInWithButton(
        icon: FontAwesomeIcons.google,
        buttonText: 'Sign in with Google',
        onPressed: () {
          reauthenticateWithGoogle();
        });
  }

  _appleSignIn() {
    return SignInWithButton(
      buttonText: 'Sign in with Apple',
      onPressed: () {
        reauthenticateWithApple(context);
      },
      icon: FontAwesomeIcons.apple,
    );
  }

  _deleteWidget() {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Container(
          height: width * 2,
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'You have to re-atheticate to make sure nobody is trying to delete you account.',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    16,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 2,
                color: Colors.blue,
                width: 10,
              ),
              const SizedBox(
                height: 30,
              ),
              reathenticateType.startsWith('Apple')
                  ? _appleSignIn()
                  : reathenticateType.startsWith('Google')
                      ? _googleSignIn()
                      : ShakeTransition(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10),
                            child: Text(
                              'Enter your password to delete your account.',
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                  context,
                                  14,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
              if (reathenticateType.startsWith('Email'))
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: LoginField(
                    notLogin: true,
                    controller: _passwordController,
                    hintText: 'At least 8 characters',
                    labelText: 'Password',
                    onValidateText: (input) => input!.length < 8
                        ? 'Password must be at least 8 characters'
                        : input.length > 24
                            ? 'Password is too long'
                            : null,
                    icon: Icons.email,
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isHidden ? Icons.visibility_off : Icons.visibility,
                          size: width > 800 ? 35 : 20.0,
                          color: Colors.grey,
                        ),
                        onPressed: _toggleVisibility),
                  ),
                ),
              const SizedBox(height: 60),
              if (reathenticateType.startsWith('Email'))
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    _showBottomConfirm(
                        'Are you sure you want delete your account?',
                        ' All your user data and every content you have created.',
                        'Delete Account', () {
                      _reauthenticate();
                    });
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      height: ResponsiveHelper.responsiveHeight(
                        context,
                        40,
                      ),
                      width: ResponsiveHelper.responsiveHeight(
                        context,
                        40,
                      ),
                      child: IconButton(
                          icon: Icon(Icons.delete_forever),
                          iconSize: ResponsiveHelper.responsiveHeight(
                            context,
                            25,
                          ),
                          color: Theme.of(context).primaryColorLight,
                          onPressed: () {
                            _showBottomConfirm(
                                'Are you sure you want delete your account?',
                                ' All your user data and every content you have created.',
                                'Delete Account', () {
                              Navigator.pop(context);
                              _reauthenticate();
                            });
                          }
                          // => _submit(),
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Theme.of(context).secondaryHeaderColor),
        leading: _index == 3
            ? const SizedBox.shrink()
            : IconButton(
                icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                onPressed: () {
                  _index != 0 ? animateBack() : Navigator.pop(context);
                }),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: formKey,
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                _index = index;
              });
            },
            children: [
              _why(),
              _deactivateInstead(),
              _deleteWidget(),
              SingleChildScrollView(
                child: Container(
                    color: Theme.of(context).primaryColor,
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                      child: Loading(
                        color: Theme.of(context).secondaryHeaderColor,
                        icon: (Icons.delete_outline_rounded),
                        title: 'Deleting account',
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
