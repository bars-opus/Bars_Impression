import 'package:bars/utilities/exports.dart';
import 'package:bars/widgets/animation/shake_transition.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class SetUpBrand extends StatefulWidget {
  static final id = 'SetUpBrand_screen';

  @override
  _SetUpBrandState createState() => _SetUpBrandState();
}

class _SetUpBrandState extends State<SetUpBrand> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  File? _profileImage;
  String _shopType = '';
  String _accountType = '';
  String selectedValue = '';
  String query = "";
  late TextEditingController _namecontroller;
  late PageController _pageController;
  int _index = 0;
  // final _bioTextController = TextEditingController();
  final UsernameService _usernameService = UsernameService();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
    _namecontroller = TextEditingController(
      text: _userName,
    );
    _namecontroller.addListener(_oninputChanged);
    // _bioTextController.addListener(_oninputChanged);

    selectedValue = _shopType.isEmpty ? '' : _shopType;

    selectedValue = _accountType.isEmpty ? '' : _accountType;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      var _provider = Provider.of<UserData>(context, listen: false);
      _provider.setIsLoading(false);
      _provider.setFlorenceActive(false);
      _provider.setInt2(0);
      _provider.setInt3(0);
      _initialize();
    });
  }

  void _oninputChanged() {
    if (_namecontroller.text.trim().isNotEmpty
        // ||
        //     _bioTextController.text.trim().isNotEmpty

        ) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  _initialize() async {
    await Future.delayed(Duration(milliseconds: 580));
    FocusScope.of(context).unfocus();

    await Future.delayed(Duration(seconds: 2));
    Provider.of<UserData>(context, listen: false).setInt3(8);

    if (mounted) {}

    await Future.delayed(Duration(seconds: 10));
    if (mounted) {
      Provider.of<UserData>(context, listen: false).setInt3(9);
    }
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    // _bioTextController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  _handleImageFromGallery() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;
    // ignore: unnecessary_null_comparison
    _provider.setIsLoading(true);
    bool isHarmful = await HarmfulContentChecker.checkForHarmfulContent(
        context, file as File);
    // final isHarmful = await _checkForHarmfulContent(context, file as File);
    if (isHarmful) {
      _provider.setIsLoading(false);
      mySnackBarModeration(context,
          'Harmful content detected. Please choose a different image. Please review');
      _provider.setIsLoading(false);
    } else {
      _provider.setIsLoading(false);
      _profileImage = file;
    }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage!;
  }

  _displayProfileImage() {
    return FileImage(_profileImage!);
  }

  // Future<void> changeUsername(
  //     String oldUsername, String newUsername, String userId) async {
  //   final _firestore = FirebaseFirestore.instance;

  //   try {
  //     await _firestore.runTransaction((transaction) async {
  //       DocumentSnapshot oldUsernameDoc = await transaction
  //           .get(_firestore.collection('usernames').doc(oldUsername));

  //       if (!oldUsernameDoc.exists) {
  //         throw Exception('Old $oldUsername does not exist $newUsername');
  //       }

  //       DocumentSnapshot newUsernameDoc = await transaction
  //           .get(_firestore.collection('usernames').doc(newUsername));
  //       bool isTaken = await DatabaseService.isUsernameTaken(newUsername);

  //       if (isTaken || newUsernameDoc.exists) {
  //         throw Exception(
  //             'The username you entered is already taken. Please choose a different username.');
  //       }

  //       // Create the new username document
  //       DocumentReference newUsernameRef =
  //           _firestore.collection('usernames').doc(newUsername.toUpperCase());
  //       transaction.set(newUsernameRef, oldUsernameDoc.data());
  //       transaction.update(
  //         usersAuthorRef.doc(userId),
  //         {
  //           'userName': newUsername.toUpperCase(),
  //         },
  //       );

  //       transaction.update(
  //         userProfessionalRef.doc(userId),
  //         {
  //           'userName': newUsername.toUpperCase(),
  //         },
  //       );

  //       // Delete the old username document
  //       DocumentReference oldUsernameRef =
  //           _firestore.collection('usernames').doc(oldUsername);
  //       transaction.delete(oldUsernameRef);

  //       _updateAuthorHive(newUsername.toUpperCase());
  //       // Update the global user object
  //       Provider.of<UserData>(context, listen: false)
  //           .setChangeUserName(newUsername.toUpperCase());
  //       animateToPage(1);
  //       // widget.user.userName = newUsername;
  //     });
  //   } catch (e) {
  //     // Rethrow the caught exception to handle it in the _validate method
  //     throw e;
  //   }
  // }

  Future<void> changeUsername(
    // BuildContext context,
    // String oldUsername,
    String newUsername,
    // String userId,
    //  bool isSetUp
    // PageController? pageController
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(
      usersAuthorRef.doc(_provider.currentUserId),
      {
        'userName': newUsername,
      },
    );

    try {
      await batch.commit();

      await HiveUtils.updateAuthorHive(
        context: context,
        accountType: '',
        disabledAccount: false,
        // lastActiveDate: Timestamp.fromDate(DateTime.now()),
        shopType: '',
        profileImageUrl: '',
        reportConfirmed: false,
        verified: false,
        disableChat: false,
        name: newUsername,
        link: '',

        // context, newUsername, '', '',
        // _provider.shopType, _provider.accountType
        //
      );
      animateToPage(1);
      _provider.setIsLoading(false);
      _provider.setName(newUsername);
    } catch (e) {
      _provider.setIsLoading(false);
      mySnackBar(context, e.toString());
    }
  }

  // _updateAuthorHive(String userName) {
  //   final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   // Create a new instance of AccountHolderAuthor with the updated name
  //   var updatedAccountAuthor = AccountHolderAuthor(
  //     // name: _provider.name,
  //     // bio: '',
  //     disabledAccount: false,
  //     // isShop: _provider.user!.isShop,
  //     dynamicLink: '',
  //     lastActiveDate: Timestamp.fromDate(DateTime.now()),
  //     shopType: '',
  //     profileImageUrl: '',
  //     reportConfirmed: false,
  //     userId: _provider.currentUserId,
  //     userName: userName,
  //     verified: false,
  //     // isShop: false,
  //     disableChat: false, accountType: _provider.accountType,
  //   );
  //   // Put the new object back into the box with the same key
  //   accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  // }

  // _updateAuthorProfiHandleHive(String shopType, String link) {
  //   final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   // Create a new instance of AccountHolderAuthor with the updated name
  //   var updatedAccountAuthor = AccountHolderAuthor(
  //     // name: _provider.name,
  //     // isShop: _provider.user!.isShop,
  //     accountType: _provider.accountType,
  //     // bio: '',
  //     disabledAccount: false,
  //     dynamicLink: link,
  //     lastActiveDate: Timestamp.fromDate(DateTime.now()),
  //     shopType: shopType,
  //     profileImageUrl: '',
  //     reportConfirmed: false,
  //     userId: _provider.currentUserId,
  //     userName: _provider.changeNewUserName,
  //     verified: false,
  //     // isShop: false,
  //     disableChat: false,
  //   );
  //   // Put the new object back into the box with the same key
  //   accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  // }

  // _updateAuthorBioAndImgeUrlHive(String profileImageUrl, String link) {
  //   final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   // Create a new instance of AccountHolderAuthor with the updated name
  //   var updatedAccountAuthor = AccountHolderAuthor(
  //     // name: _provider.name,
  //     // bio: bio,
  //     // isShop: _provider.user!.isShop,
  //     accountType: _provider.accountType,
  //     disabledAccount: false,
  //     dynamicLink: link,
  //     lastActiveDate: Timestamp.fromDate(DateTime.now()),
  //     shopType: _provider.shopType,
  //     profileImageUrl: profileImageUrl,
  //     reportConfirmed: false,
  //     userId: _provider.currentUserId,
  //     userName: _provider.changeNewUserName.isEmpty
  //         ? _namecontroller.text.toUpperCase()
  //         : _provider.changeNewUserName.toUpperCase(),
  //     verified: false,
  //     // isShop: false,
  //     disableChat: false,
  //   );
  //   // Put the new object back into the box with the same key
  //   accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  // }

  _validateTextToxicityBio(AccountHolderAuthor user) async {
    // animateToPage(1);
    _submitProfileImage(user);
    // var _provider = Provider.of<UserData>(context, listen: false);
    // TextModerator moderator = TextModerator();
    // // Define the texts to be checked
    // List<String> textsToCheck = [_bioTextController.text.trim()];
    // // Set a threshold for toxicity that is appropriate for your app
    // const double toxicityThreshold = 0.7;
    // bool allTextsValid = true;
    // for (String text in textsToCheck) {
    //   if (text.isEmpty) {
    //     // Handle the case where the text is empty
    //     _submitProfileImage(user);
    //     allTextsValid = false;
    //     break; // Exit loop as there is an empty text
    //   }
    //   Map<String, dynamic>? analysisResult = await moderator.moderateText(text);
    //   // Check if the API call was successful
    //   if (analysisResult != null) {
    //     double toxicityScore = analysisResult['attributeScores']['TOXICITY']
    //         ['summaryScore']['value'];
    //     if (toxicityScore >= toxicityThreshold) {
    //       // If any text's score is above the threshold, show a Snackbar and set allTextsValid to false
    //       mySnackBarModeration(context,
    //           'Your bio,contains inappropriate content. Please review');
    //       allTextsValid = false;
    //       animateBack();
    //       break; // Exit loop as we already found inappropriate content
    //     }
    //   } else {
    //     // Handle the case where the API call failed
    //     mySnackBar(context, 'Try again.');
    //     animateBack();
    //     allTextsValid = false;
    //     break; // Exit loop as there was an API error
    //   }
    // }
    // // Animate to the next page if all texts are valid
    // if (allTextsValid) {
    //   _submitProfileImage(user); // animateToPage(1);
    // }
  }

  _validate(BuildContext context) async {
    // var _changeUserName =
    //     Provider.of<UserData>(context, listen: false).changeNewUserName;
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // Check if the username has changed
      // if (_changeUserName == _namecontroller.text.trim()) {
      //   Navigator.pop(context);
      // }
      // else {
      // try {
      // var currentUser = Provider.of<UserData>(context, listen: false).user;
      bool validated = await _usernameService.validateTextToxicity(
          context, _namecontroller.text.trim(), _pageController);

      if (validated) {
        changeUsername(_namecontroller.text.trim());
      }
      // _validateTextToxicity(_changeUserName);
      // } catch (e) {
      //   mySnackBar(context, e.toString());
      //   // }
      // }
    }
  }

  _submitProfileImage(AccountHolderAuthor user) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    String currentUserId = _provider.currentUserId!;
    if (_formKey.currentState!.validate() && !_provider.isLoading) {
      animateToPage(1);
      _provider.setIsLoading(true);
      _formKey.currentState?.save();
      FocusScope.of(context).unfocus();

      String _profileImageUrl = '';
      if (_profileImage == null) {
        _profileImageUrl = '';
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
          _provider.currentUserId!,
          _profileImage!,
        );
      }

      String profileImageUrl = _profileImageUrl;
      // String bio = _bioTextController.text.trim().replaceAll('\n', ' ');

      try {
        String link = '';

        // await DatabaseService.myDynamicLink(
        //   profileImageUrl,
        //   _provider.changeNewUserName.isEmpty
        //       ? _namecontroller.text.toUpperCase()
        //       : _provider.changeNewUserName.toUpperCase(),
        //   '',
        //   'https://www.barsopus.com/user_$currentUserId',
        // );
        WriteBatch batch = FirebaseFirestore.instance.batch();
        batch.update(
          usersAuthorRef.doc(currentUserId),
          {
            'dynamicLink': link,
            'profileImageUrl': profileImageUrl,
            // 'bio': bio,
          },
        );

        String profileType =
            _accountType.isEmpty ? _provider.accountType : _accountType;

        if (profileType == 'Worker') {
          batch.update(
            usersWokerRef.doc(currentUserId),
            {
              'profileImageUrl': profileImageUrl,
            },
          );
        }

        await batch.commit();
        HiveUtils.updateAuthorHive(
          context: context,
          accountType: _accountType,
          disabledAccount: false,
          shopType: _provider.shopType,
          profileImageUrl: _profileImageUrl,
          reportConfirmed: false,
          verified: false,
          disableChat: false,
          name: _provider.name,
          link: link,
          // context,
          // _provider.user!.userName!,
          // _profileImageUrl,
          // '',
          // _provider.shopType,
          // _provider.accountType,
        );
        // _updateAuthorBioAndImgeUrlHive(profileImageUrl, link);
        // _bioTextController.clear();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ConfigPage()),
            (Route<dynamic> route) => false);

        _provider.setIsLoading(false);
      } catch (e) {
        animateBack();
        _showBottomSheetErrorMessage();
      }
      _provider.setIsLoading(false);
    }
  }

  void _showBottomSheetErrorMessage() {
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
          title: 'Failed to setup Brand.',
          subTitle: 'Please check your internet connection and try agian.',
        );
      },
    );
  }

  // _submitshopType() async {
  //   var _provider = Provider.of<UserData>(context, listen: false);

  //   _provider.setIsLoading(true);
  //   String currentUserId = _provider.currentUserId!;
  //   if (_shopType.isEmpty) {
  //     _shopType = 'Fan';
  //   }
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   String link = await DatabaseService.myDynamicLink(
  //     '',
  //     _provider.changeNewUserName,
  //     '',
  //     'https://www.barsopus.com/user_$currentUserId',
  //   );

  //   batch.update(
  //     usersAuthorRef.doc(currentUserId),
  //     {
  //       'shopType': _shopType,
  //       'dynamicLink': link,
  //     },
  //   );

  //   batch.update(
  //     userProfessionalRef.doc(currentUserId),
  //     {
  //       'shopType': _shopType,
  //       'dynamicLink': link,
  //     },
  //   );
  //   try {
  //     batch.commit();
  //     _provider.setshopType(_shopType);
  //     animateToPage(1);
  //     // _updateAuthorProfiHandleHive(_shopType, link);
  //   } catch (e) {
  //     _showBottomSheetErrorMessage();
  //   }
  //   _provider.setIsLoading(false);
  // }

  _updateShoptAndType() {
    _updateStore();
    _submitAccountType();
  }

  _submitAccountType() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    _provider.setIsLoading(true);
    String currentUserId = _provider.currentUserId!;
    if (_accountType.isEmpty) {
      _accountType = 'Client';
    }
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(
      usersAuthorRef.doc(currentUserId),
      {
        'accountType': _accountType,
      },
    );

    try {
      await batch.commit();
      await HiveUtils.updateAuthorHive(
        context: context,
        accountType: _accountType,
        disabledAccount: false,
        // lastActiveDate: Timestamp.fromDate(DateTime.now()),
        shopType: _provider.shopType,
        profileImageUrl: '',
        reportConfirmed: false,
        verified: false,
        disableChat: false,
        name: _provider.name,
        link: '',
      );
      _provider.setAccountType(_accountType);
      _provider.setIsLoading(false);
      if (_accountType == 'Shop') Navigator.pop(context);
      animateToPage(1);
    } catch (e) {
      _provider.setIsLoading(false);
      _showBottomSheetErrorMessage();
    }
  }

  _updateStore() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    _provider.setIsLoading(true);
    String currentUserId = _provider.currentUserId!;

    if (_shopType.isEmpty) {
      _shopType = 'Client';
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(
      usersAuthorRef.doc(currentUserId),
      {
        'shopType': _shopType,
      },
    );

    await DatabaseService.createUserProfileITypeData(
        userId: currentUserId,
        accountType:
            _accountType.isEmpty ? _provider.accountType : _accountType,
        shopType: _shopType,
        name: _provider.user!.userName!,
        batch: batch);

    try {
      await batch.commit();
      // await HiveUtils.updateUserStore(
      //     context, '', _shopType, _provider.accountType);
      await HiveUtils.updateAuthorHive(
        context: context,
        accountType: _provider.accountType,
        disabledAccount: false,
        // lastActiveDate: Timestamp.fromDate(DateTime.now()),
        shopType: _shopType,
        profileImageUrl: '',
        reportConfirmed: false,
        verified: false,
        disableChat: false,
        name: _provider.name,
        link: '',
      );
      _provider.setshopType(_shopType);
      _provider.setIsLoading(false);
      // animateToPage(1);
      // _updateAuthorHive(_shopType);
    } catch (error) {
      _provider.setIsLoading(false);
      _showBottomSheetErrorMessage();
      // Handle the error appropriately
    }
  }

  static const shopType = <String>[
    "Salon",
    "Barbershop",
    "Spa",
  ];

  Widget buildRadios(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Column(
            children: shopType.map((value) {
          final selected = this.selectedValue == value;
          final color =
              selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

          return RadioListTile<String>(
            value: value,
            groupValue: selectedValue,
            title: Text(
              value,
              style: TextStyle(
                  color: color,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  fontWeight: this.selectedValue == value
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
            activeColor: Colors.blue,
            onChanged: (value) => setState(
              () {
                _shopType = this.selectedValue = value!;
                _updateShoptAndType();
                // _submitshopType();
              },
            ),
          );
        }).toList()),
      );

  static const accountType = <String>[
    "Client",
    "Shop",
    "Worker",
  ];

  Widget buildAccountTypeRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Column(
            children: accountType.map((value) {
          // var _provider = Provider.of<UserData>(context, listen: false);

          final selected = this.selectedValue == value;
          final color =
              selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

          return RadioListTile<String>(
            value: value,
            groupValue: selectedValue,
            title: Text(
              value,
              style: TextStyle(
                  color: color,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  fontWeight: this.selectedValue == value
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
            activeColor: Colors.blue,
            onChanged: (value) => setState(
              () {
                _accountType = this.selectedValue = value!;
                // _submitAccountType();
                _accountType == 'Shop'
                    ? _showBottomSheetStoreType(context)
                    : _accountType == 'Worker'
                        ? _updateShoptAndType()
                        : _submitAccountType();
              },
            ),
          );
        }).toList()),
      );

  void _showBottomSheetStoreType(BuildContext context) {
    // bool _isAuthor = user.userId == widget.currentUserId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 600),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            child: MyBottomModelSheetAction(
              actions: [
                Icon(
                  size: ResponsiveHelper.responsiveHeight(context, 25),
                  Icons.horizontal_rule,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                _selectStoreype(context),
              ],
            ),
          ),
        );
      },
    );
  }

  animateBack() {
    FocusScope.of(context).unfocus();
    _pageController.animateToPage(
      _index - 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateToPage(int index) {
    int page = _pageController.page!.toInt() + index;

    FocusScope.of(context).unfocus();
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
    _setInt2(page + 1);
  }

  _setInt2(int page) async {
    print(page.toString());
    await Future.delayed(Duration(seconds: 1));
    Provider.of<UserData>(context, listen: false).setInt2(page);
  }

  _backButton() {
    return _index == 0
        ? SizedBox.shrink()
        : IconButton(
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
            onPressed: () {
              animateBack();
            });
  }

  _outlineButton(String text, VoidCallback onPressed) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: BlueOutlineButton(buttonText: text, onPressed: onPressed),
      ),
    );
  }

  _animatedContainer(double? height, Widget child, Duration? duration,
      BoxDecoration? decoration) {
    return AnimatedContainer(
        curve: Curves.easeInOut,
        duration: duration == null ? Duration(milliseconds: 800) : duration,
        height: height,
        decoration: decoration,
        child: child);
  }

  _animatedContainer2(double? width, double height, Widget child,
      Duration? duration, BoxDecoration? decoration) {
    return AnimatedContainer(
        curve: Curves.easeInOut,
        duration: duration == null ? Duration(milliseconds: 800) : duration,
        width: width,
        height: height,
        decoration: decoration,
        child: child);
  }

  _animatedContainer3(
    bool value,
    Widget child,
  ) {
    return AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 800),
        padding: EdgeInsets.all(value ? 5 : 0),
        margin: EdgeInsets.symmetric(
            horizontal: value ? 5 : 0, vertical: value ? 20 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(value ? 20 : 0),
          color: value ? Colors.white : Colors.white.withOpacity(.4),
        ),
        child: child);
  }

  // _animatedText(String text) {
  //   return TyperAnimatedText(
  //     text,
  //     textStyle: TextStyle(
  //       fontWeight: FontWeight.normal,
  //       color: Theme.of(context).secondaryHeaderColor,
  //       fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
  //     ),
  //   );
  // }

  _setUp() {
    var _provider = Provider.of<UserData>(
      context,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            _animatedContainer(_provider.int2 == 0 ? 100 : 10,
                SizedBox(height: 0), Duration(seconds: 2), null),
            // Center(
            //   child: Material(
            //     color: Colors.transparent,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         _animatedContainer2(
            //             _provider.int3 == 8 ? 100 : 0,
            //             70,
            //             Center(
            //               child: Text(
            //                 'Hell',
            //                 style: TextStyle(
            //                   fontSize: ResponsiveHelper.responsiveFontSize(
            //                       context, 40.0),
            //                   color: Theme.of(context).secondaryHeaderColor,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ),
            //             Duration(seconds: 2),
            //             null),
            //         if (_provider.int2 != 4)
            //           _provider.int2 != 0
            //               ? AnimatedCircle(
            //                   size: 30,
            //                   animateSize: true,
            //                   animateShape: true,
            //                 )
            //               : AnimatedCircle(
            //                   size: 80,
            //                   animateSize: true,
            //                   animateShape: _provider.int3 == 8 ? false : true,
            //                 ),
            //       ],
            //     ),
            //   ),
            // ),
            // if (_provider.int2 != 4)

            const SizedBox(height: 10),
            ShakeTransition(
              curve: Curves.easeInOut,
              child: Center(
                child: RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Welcome to\n ",
                          style: Theme.of(context).textTheme.titleLarge),
                      TextSpan(
                        text: 'Florence.',
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),

              // Text(
              //   'Welcome to Bars Impression.',
              //   style: TextStyle(
              //     fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
              //     color: Theme.of(context).secondaryHeaderColor,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                height: 2,
                color: Colors.blue,
                width: 10,
              ),
            ),

            Text(
                "Lets setup your profile and then continue to explore some shops.",
                style: Theme.of(context).textTheme.bodyMedium),
            // if (_provider.int2 == 0)
//               AnimatedTextKit(
//                   repeatForever: false,
//                   totalRepeatCount: 1,
//                   animatedTexts: [
//                     _animatedText("""
// Hello! I'm Hope, your dedicated creative assistant. My goal is to help you elevate your brand, enhance your skills, and connect you with fellow creatives and organizers.

// As we embark on this journey together, I will be here to guide you at every step. I’ll provide more details about how I can assist you as we progress. For now, let’s focus on setting up your profile
// """),
//                   ]),
            const SizedBox(height: 50),
            // if (_provider.int2 == 0)
            //   if (_provider.int3 == 9)
            ShakeTransition(
              axis: Axis.vertical,
              // duration: Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: _outlineButton('Let\s Start', () {
                animateToPage(1);
                // _provider.setFlorenceActive(true);
                // _provider.setInt2(1);
              }),
            ),
          ],
        ),
      ),
    );
  }

  _directionWidget(String title, String subTItle, bool showMore, bool value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.blue,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
              height: 1),
        ),
        const SizedBox(height: 30),
        DirectionWidget(
          alwaysWhite: false,
          sizedBox: 0,
          text: subTItle,
          fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
        ),
        if (showMore)
          GestureDetector(
            onTap: () {
              _showBottomMoreAboutAccountTypes();
            },
            child: RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'If you are uncertain about where you fit in,',
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                    ),
                  ),
                  TextSpan(
                    text: '\nlearn more',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
      ],
    );
  }

  _setUserName() {
    var _provider = Provider.of<UserData>(
      context,
    );
    return SingleChildScrollView(
      child: ValueListenableBuilder(
          valueListenable: _isTypingNotifier,
          builder: (BuildContext context, bool isTyping, Widget? child) {
            return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_provider.isLoading)
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: CircularProgress(
                              isMini: true,
                              indicatorColor: Colors.blue,
                            ),
                          ),
                        ),
                      if (!_provider.isLoading)
                        _namecontroller.text.trim().isNotEmpty
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: MiniCircularProgressButton(
                                  text: 'Save',
                                  onPressed: () {
                                    _validate(context);
                                  },
                                ),
                              )
                            : SizedBox(height: 50),
                      _directionWidget(
                          'Select username',
                          'Please enter a username. If you are setting up a shop, do not use your shop name for this field. Instead, enter a username. You will receive materials later to provide your shop information.',
                          false,
                          _provider.int2 == 1),
                      const SizedBox(height: 40),
                      // if (_provider.int2 == 1)
                      ShakeTransition(
                        curve: Curves.easeOutBack,
                        axis: Axis.vertical,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: LoginField(
                            inputColor: Colors.black,
                            notLogin: true,
                            controller: _namecontroller,
                            hintText: 'A username to be identified with',
                            labelText: 'Username',
                            onValidateText: (input) {
                              if (input!.trim().length < 1) {
                                return 'Choose a username';
                              } else if (input.trim().contains(' ')) {
                                return 'Username cannot contain space, use ( _ or - )';
                              } else if (input.trim().contains('@')) {
                                return 'Username cannot contain @';
                              } else if (input.trim().length > 20) {
                                return 'Username cannot be longer than 20 characters';
                              } else {
                                return null;
                              }
                            },
                            icon: Icons.email,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ]));
          }),
    );
  }

  void _showBottomMoreAboutAccountTypes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: MoreAboutAccountTypes());
        });
      },
    );
  }

  _selectAccountType() {
    var _provider = Provider.of<UserData>(
      context,
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_provider.isLoading)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgress(
                    isMini: true,
                    indicatorColor: Colors.blue,
                  ),
                ),
              ),
            _directionWidget(
              'Select Account Type',
              'Please select an account type that best represents your role. This will help other users easily identify you for business purposes. You can select only one account type at a time.',
              true,
              _provider.int2 == 2,
            ),
            buildAccountTypeRadios(),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  _selectStoreype(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_provider.isLoading)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgress(
                    isMini: true,
                    indicatorColor: Colors.blue,
                  ),
                ),
              ),
            _directionWidget(
              'Select Account Type',
              '',
              false,
              _provider.int2 == 2,
            ),
            buildRadios(context),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  _bioAndProfilePhoto(AccountHolderAuthor user) {
    var _provider = Provider.of<UserData>(
      context,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ValueListenableBuilder(
            valueListenable: _isTypingNotifier,
            builder: (BuildContext context, bool isTyping, Widget? child) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_provider.isLoading)
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: CircularProgress(
                            isMini: true,
                            indicatorColor: Colors.blue,
                          ),
                        ),
                      ),
                    // if (_provider.int2 == 3)
                    !_provider.isLoading
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: MiniCircularProgressButton(
                              color: Colors.blue,
                              text: _profileImage != null ? 'Save' : 'Skip',
                              onPressed: _profileImage != null
                                  ? () {
                                      _validateTextToxicityBio(user);
                                    }
                                  : () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ConfigPage()),
                                          (Route<dynamic> route) => false);
                                    },
                            ))
                        : SizedBox(),
                    _directionWidget(
                      'Set photo',
                      'If you are setting up a shop, do not upload your shop logo here. Instead, upload your personal photo as the owner of the shop. You will receive materials later to provide your shop information.',
                      false,
                      _provider.int2 == 3,
                    ),
                    // if (_provider.int2 == 3)
                    ShakeTransition(
                      axis: Axis.vertical,
                      curve: Curves.easeOutBack,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            _provider.isLoading
                                ? SchimmerSkeleton(
                                    schimmerWidget: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColorLight,
                                      radius: ResponsiveHelper.responsiveHeight(
                                          context, 50.0),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => _handleImageFromGallery,
                                    child: _profileImage == null
                                        ? Icon(
                                            Icons.account_circle_outlined,
                                            size: ResponsiveHelper
                                                .responsiveHeight(
                                              context,
                                              120,
                                            ),
                                            color: Colors.grey,
                                          )
                                        : CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            radius: ResponsiveHelper
                                                .responsiveHeight(
                                              context,
                                              50.0,
                                            ),
                                            backgroundImage:
                                                _displayProfileImage()),
                                  ),
                            ShakeTransition(
                              curve: Curves.easeOutBack,
                              child: Center(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                  ),
                                  onPressed: _handleImageFromGallery,
                                  child: Text(
                                    'Set Photo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 12.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // if (_provider.int2 == 3)
                            // ShakeTransition(
                            //   offset: -140,
                            //   curve: Curves.easeOutBack,
                            //   child: UnderlinedTextField(
                            //     isFlorence: true,
                            //     autofocus: false,
                            //     controler: _bioTextController,
                            //     labelText: 'bio',
                            //     hintText:
                            //         'A piece of short information about yourself',
                            //     onValidateText: (input) => input!
                            //                 .trim()
                            //                 .length >
                            //             700
                            //         ? 'Please, enter a bio of fewer than 700 characters.'
                            //         : null,
                            //   ),
                            // ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ]);
            }),
      ),
    );
  }

  _loadingToPage() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 1.0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Shimmer.fromColors(
              period: Duration(milliseconds: 1000),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.white,
              child: RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\nPlease Wait... ',
                      ),
                    ],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // _animatedContainerWrapper(bool value, Widget child) {
  //   return IgnorePointer(
  //     ignoring: !value,
  //     child: AnimatedOpacity(
  //         opacity: value ? 1.0 : 0.0,
  //         duration: Duration(milliseconds: 1300),
  //         curve: Curves.easeInOut,
  //         child: child),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme:
              IconThemeData(color: Theme.of(context).secondaryHeaderColor),
          automaticallyImplyLeading: true,
          leading: _index == 4 ? const SizedBox.shrink() : _backButton(),
          elevation: 0,
        ),
        body: FutureBuilder(
            future: usersAuthorRef.doc(_provider.currentUserId).get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return _loadingToPage();
              }
              AccountHolderAuthor user =
                  AccountHolderAuthor.fromDoc(snapshot.data);
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      _setUp(),
                      _setUserName(),
                      _selectAccountType(),
                      _bioAndProfilePhoto(user),
                      SingleChildScrollView(
                        child: Container(
                            color: Colors.transparent,
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                                child: Loading(
                              color: Colors.blue,
                              title: 'Setting up profile',
                              icon: (FontAwesomeIcons.circle),
                            ))),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
