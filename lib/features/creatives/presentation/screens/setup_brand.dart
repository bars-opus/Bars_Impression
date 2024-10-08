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
  String _profileHandle = '';
  String selectedValue = '';
  String query = "";
  late TextEditingController _namecontroller;
  late PageController _pageController;
  int _index = 0;
  final _bioTextController = TextEditingController();
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
    _bioTextController.addListener(_oninputChanged);

    selectedValue = _profileHandle.isEmpty ? '' : _profileHandle;
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
    if (_namecontroller.text.trim().isNotEmpty ||
        _bioTextController.text.trim().isNotEmpty) {
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
    _bioTextController.dispose();
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

  Future<void> changeUsername(
      String oldUsername, String newUsername, String userId) async {
    final _firestore = FirebaseFirestore.instance;

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot oldUsernameDoc = await transaction
            .get(_firestore.collection('usernames').doc(oldUsername));

        if (!oldUsernameDoc.exists) {
          throw Exception('Old $oldUsername does not exist $newUsername');
        }

        DocumentSnapshot newUsernameDoc = await transaction
            .get(_firestore.collection('usernames').doc(newUsername));
        bool isTaken = await DatabaseService.isUsernameTaken(newUsername);

        if (isTaken || newUsernameDoc.exists) {
          throw Exception(
              'The username you entered is already taken. Please choose a different username.');
        }

        // Create the new username document
        DocumentReference newUsernameRef =
            _firestore.collection('usernames').doc(newUsername.toUpperCase());
        transaction.set(newUsernameRef, oldUsernameDoc.data());
        transaction.update(
          usersAuthorRef.doc(userId),
          {
            'userName': newUsername.toUpperCase(),
          },
        );

        transaction.update(
          userProfessionalRef.doc(userId),
          {
            'userName': newUsername.toUpperCase(),
          },
        );

        // Delete the old username document
        DocumentReference oldUsernameRef =
            _firestore.collection('usernames').doc(oldUsername);
        transaction.delete(oldUsernameRef);

        _updateAuthorHive(newUsername.toUpperCase());
        // Update the global user object
        Provider.of<UserData>(context, listen: false)
            .setChangeUserName(newUsername.toUpperCase());
        animateToPage(1);
        // widget.user.userName = newUsername;
      });
    } catch (e) {
      // Rethrow the caught exception to handle it in the _validate method
      throw e;
    }
  }

  _updateAuthorHive(String userName) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);
    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      name: _provider.name,
      bio: '',
      disabledAccount: false,
      dynamicLink: '',
      lastActiveDate: Timestamp.fromDate(DateTime.now()),
      profileHandle: '',
      profileImageUrl: '',
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

  _updateAuthorProfiHandleHive(String profileHandle, String link) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');
    var _provider = Provider.of<UserData>(context, listen: false);
    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      name: _provider.name,
      bio: '',
      disabledAccount: false,
      dynamicLink: link,
      lastActiveDate: Timestamp.fromDate(DateTime.now()),
      profileHandle: profileHandle,
      profileImageUrl: '',
      reportConfirmed: false,
      userId: _provider.currentUserId,
      userName: _provider.changeNewUserName,
      verified: false,
      privateAccount: false,
      disableChat: false,
    );
    // Put the new object back into the box with the same key
    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }

  _updateAuthorBioAndImgeUrlHive(
      String bio, String profileImageUrl, String link) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');
    var _provider = Provider.of<UserData>(context, listen: false);
    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      name: _provider.name,
      bio: bio,
      disabledAccount: false,
      dynamicLink: link,
      lastActiveDate: Timestamp.fromDate(DateTime.now()),
      profileHandle: _provider.profrilehandle,
      profileImageUrl: profileImageUrl,
      reportConfirmed: false,
      userId: _provider.currentUserId,
      userName: _provider.changeNewUserName.isEmpty
          ? _namecontroller.text.toUpperCase()
          : _provider.changeNewUserName.toUpperCase(),
      verified: false,
      privateAccount: false,
      disableChat: false,
    );
    // Put the new object back into the box with the same key
    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }

  _validateTextToxicityBio(AccountHolderAuthor user) async {
    animateToPage(1);
    // var _provider = Provider.of<UserData>(context, listen: false);
    TextModerator moderator = TextModerator();
    // Define the texts to be checked
    List<String> textsToCheck = [_bioTextController.text.trim()];
    // Set a threshold for toxicity that is appropriate for your app
    const double toxicityThreshold = 0.7;
    bool allTextsValid = true;
    for (String text in textsToCheck) {
      if (text.isEmpty) {
        // Handle the case where the text is empty
        _submitProfileImage(user);
        allTextsValid = false;
        break; // Exit loop as there is an empty text
      }
      Map<String, dynamic>? analysisResult = await moderator.moderateText(text);
      // Check if the API call was successful
      if (analysisResult != null) {
        double toxicityScore = analysisResult['attributeScores']['TOXICITY']
            ['summaryScore']['value'];
        if (toxicityScore >= toxicityThreshold) {
          // If any text's score is above the threshold, show a Snackbar and set allTextsValid to false
          mySnackBarModeration(context,
              'Your bio,contains inappropriate content. Please review');
          allTextsValid = false;
          animateBack();
          break; // Exit loop as we already found inappropriate content
        }
      } else {
        // Handle the case where the API call failed
        mySnackBar(context, 'Try again.');
        animateBack();
        allTextsValid = false;
        break; // Exit loop as there was an API error
      }
    }
    // Animate to the next page if all texts are valid
    if (allTextsValid) {
      _submitProfileImage(user); // animateToPage(1);
    }
  }

  _validate(BuildContext context) async {
    var _changeUserName =
        Provider.of<UserData>(context, listen: false).changeNewUserName;
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // Check if the username has changed
      if (_changeUserName == _namecontroller.text.trim()) {
        Navigator.pop(context);
      } else {
        try {
          // var currentUser = Provider.of<UserData>(context, listen: false).user;
          await _usernameService.validateTextToxicity(
              context, _changeUserName, _namecontroller, true, _pageController);
          // _validateTextToxicity(_changeUserName);
        } catch (e) {
          mySnackBar(context, e.toString());
        }
      }
    }
  }

  _submitProfileImage(AccountHolderAuthor user) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    String currentUserId = _provider.currentUserId!;
    if (_formKey.currentState!.validate() && !_provider.isLoading) {
      _provider.setIsLoading(true);
      _formKey.currentState?.save();
      FocusScope.of(context).unfocus();

      String _profileImageUrl = '';
      if (_profileImage == null) {
        _profileImageUrl = '';
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
          '',
          _profileImage!,
        );
      }

      String profileImageUrl = _profileImageUrl;
      String bio = _bioTextController.text.trim().replaceAll('\n', ' ');

      try {
        String link = await DatabaseService.myDynamicLink(
          profileImageUrl,
          _provider.changeNewUserName.isEmpty
              ? _namecontroller.text.toUpperCase()
              : _provider.changeNewUserName.toUpperCase(),
          bio,
          'https://www.barsopus.com/user_$currentUserId',
        );
        WriteBatch batch = FirebaseFirestore.instance.batch();
        batch.update(
          usersAuthorRef.doc(currentUserId),
          {
            'dynamicLink': link,
            'profileImageUrl': profileImageUrl,
            'bio': bio,
          },
        );

        batch.update(
          userProfessionalRef.doc(currentUserId),
          {
            'dynamicLink': link,
            'profileImageUrl': profileImageUrl,
            'bio': bio,
          },
        );
        batch.commit();
        _updateAuthorBioAndImgeUrlHive(bio, profileImageUrl, link);
        _bioTextController.clear();
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

  _submitProfileHandle() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    _provider.setIsLoading(true);
    String currentUserId = _provider.currentUserId!;
    if (_profileHandle.isEmpty) {
      _profileHandle = 'Fan';
    }
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String link = await DatabaseService.myDynamicLink(
      '',
      _provider.changeNewUserName,
      '',
      'https://www.barsopus.com/user_$currentUserId',
    );

    batch.update(
      usersAuthorRef.doc(currentUserId),
      {
        'profileHandle': _profileHandle,
        'dynamicLink': link,
      },
    );

    batch.update(
      userProfessionalRef.doc(currentUserId),
      {
        'profileHandle': _profileHandle,
        'dynamicLink': link,
      },
    );
    try {
      batch.commit();
      _provider.setProfileHandle(_profileHandle);
      animateToPage(1);
      _updateAuthorProfiHandleHive(_profileHandle, link);
    } catch (e) {
      _showBottomSheetErrorMessage();
    }
    _provider.setIsLoading(false);
  }

  static const values = <String>[
    "Artist",
    "Band",
    "Battle_Rapper",
    "Blogger",
    "Brand_Influencer",
    'Caterers',
    "Choire",
    "Content_creator",
    "Dancer",
    'Decorator',
    "DJ",
    "Event_organiser",
    "Graphic_Designer",
    "Instrumentalist",
    "Makeup_Artist",
    "MC(Host)",
    "Videographer",
    "Photographer",
    "Producer",
    'Sound_and_Light',
    "Record_Label",
    "Video_Vixen",
    "Fan",
  ];

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.black,
        ),
        child: Column(
            children: values.map((value) {
          var _provider = Provider.of<UserData>(context, listen: false);

          final selected = this.selectedValue == value;
          final color = selected
              ? Colors.blue
              : _provider.int2 == 2
                  ? Colors.black
                  : Colors.white;

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
                _profileHandle = this.selectedValue = value!;
                _submitProfileHandle();
              },
            ),
          );
        }).toList()),
      );

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

  _animatedText(String text) {
    return TyperAnimatedText(
      text,
      textStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Theme.of(context).secondaryHeaderColor,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      ),
    );
  }

  _setUp() {
    var _provider = Provider.of<UserData>(
      context,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            _animatedContainer(_provider.int2 == 0 ? 100 : 10,
                SizedBox(height: 0), Duration(seconds: 2), null),
            Center(
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _animatedContainer2(
                        _provider.int3 == 8 ? 100 : 0,
                        70,
                        Center(
                          child: Text(
                            'Hell',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 40.0),
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Duration(seconds: 2),
                        null),
                    if (_provider.int2 != 4)
                      _provider.int2 != 0
                          ? AnimatedCircle(
                              size: 30,
                              animateSize: true,
                              animateShape: true,
                            )
                          : AnimatedCircle(
                              size: 80,
                              animateSize: true,
                              animateShape: _provider.int3 == 8 ? false : true,
                            ),
                  ],
                ),
              ),
            ),
            if (_provider.int2 != 4)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: 2,
                  color: Colors.blue,
                  width: 10,
                ),
              ),
            const SizedBox(height: 50),
            ShakeTransition(
              child: Text(
                'Welcome to Bars Impression.',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_provider.int2 == 0)
              AnimatedTextKit(
                  repeatForever: false,
                  totalRepeatCount: 1,
                  animatedTexts: [
                    _animatedText(
                      "I'm Hope, your personal creative assistant. I'm here to help you build your brand, improve your skills, and connect with other creatives and organizers.\n\nI would be your personal help thoughout this journey, with time, i would explain what i would assist you with but for now lets start with setting up your brand.",
                    ),
                  ]),
            const SizedBox(height: 50),
            if (_provider.int2 == 0)
              if (_provider.int3 == 9)
                ShakeTransition(
                  axis: Axis.vertical,
                  duration: Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  child: _outlineButton('Let\s Start', () {
                    _provider.setFlorenceActive(true);
                    _provider.setInt2(1);
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
        _animatedContainer(
            value ? 30 : 0,
            Text(
              title,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
                  height: 1),
            ),
            Duration(seconds: 2),
            null),
        DirectionWidget(
          alwaysWhite: true,
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
                      color: Colors.white,
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
                          'Choose a username for your brand. If you\'re a music creative, it can be your stage name. Remember, all usernames are converted to uppercase.',
                          false,
                          _provider.int2 == 1),
                      const SizedBox(height: 40),
                      if (_provider.int2 == 1)
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
                              hintText: 'A unique name to be identified with',
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
              'Choose an account type that allows other users to easily identify you for business purposes. You can select only one account type at a time.',
              true,
              _provider.int2 == 2,
            ),
            _animatedContainer3(
              _provider.int2 == 2,
              buildRadios(),
            ),
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
                    if (_provider.int2 == 3)
                      !_provider.isLoading
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: MiniCircularProgressButton(
                                color: Colors.blue,
                                text: _bioTextController.text.isNotEmpty ||
                                        _profileImage != null
                                    ? 'Save'
                                    : 'Skip',
                                onPressed:
                                    _bioTextController.text.trim().isNotEmpty ||
                                            _profileImage != null
                                        ? () {
                                            _validateTextToxicityBio(user);
                                          }
                                        : () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ConfigPage()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          },
                              ))
                          : SizedBox(),
                    _directionWidget(
                      'Set photo and bio',
                      'Choose a brand picture that represents your identity. Utilize the bio text field to share more about yourself, allowing others to get to know you better.',
                      false,
                      _provider.int2 == 3,
                    ),
                    if (_provider.int2 == 3)
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
                                        radius:
                                            ResponsiveHelper.responsiveHeight(
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
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
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
                                          width: 1.0,
                                          color: Colors.transparent),
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
                              if (_provider.int2 == 3)
                                ShakeTransition(
                                  offset: -140,
                                  curve: Curves.easeOutBack,
                                  child: UnderlinedTextField(
                                    isFlorence: true,
                                    autofocus: false,
                                    controler: _bioTextController,
                                    labelText: 'bio',
                                    hintText:
                                        'A piece of short information about yourself',
                                    onValidateText: (input) => input!
                                                .trim()
                                                .length >
                                            700
                                        ? 'Please, enter a bio of fewer than 700 characters.'
                                        : null,
                                  ),
                                ),
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

  _animatedContainerWrapper(bool value, Widget child) {
    return IgnorePointer(
      ignoring: !value,
      child: AnimatedOpacity(
          opacity: value ? 1.0 : 0.0,
          duration: Duration(milliseconds: 1300),
          curve: Curves.easeInOut,
          child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          _setUp(),
          // if (_provider.florenceActive)
          _animatedContainerWrapper(
            _provider.florenceActive,
            Scaffold(
              backgroundColor: Colors.black.withOpacity(.8),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                    color: Theme.of(context).secondaryHeaderColor),
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
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _setUserName(),
                            _selectAccountType(),
                            _bioAndProfilePhoto(user),
                            SingleChildScrollView(
                              child: Container(
                                  color: Colors.transparent,
                                  height:
                                      MediaQuery.of(context).size.height - 200,
                                  child: Center(
                                      child: Loading(
                                    color: Colors.white,
                                    title: 'Setting up brand',
                                    icon: (FontAwesomeIcons.circle),
                                  ))),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
