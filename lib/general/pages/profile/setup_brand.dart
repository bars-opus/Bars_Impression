import 'package:bars/utilities/exports.dart';
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
  late TextEditingController _controller;
  late PageController _pageController;
  int _index = 0;
  bool _userNameCreated = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
    _controller = TextEditingController(
      text: _userName,
    );
    selectedValue = _profileHandle.isEmpty ? values.last : _profileHandle;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setIsLoading(false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
    // if (mounted) {
    //   setState(() {
    //     _profileImage = file as File;
    //   });
    // }
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

  Future<void> createUser(String username, String userId) async {
    final _firestore = FirebaseFirestore.instance;

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot usernameDoc = await transaction
            .get(_firestore.collection('usernames').doc(username));

        if (usernameDoc.exists) {
          throw Exception('Username is not unique');
        }

        // Create the username document
        DocumentReference usernameRef =
            _firestore.collection('usernames').doc(username.toUpperCase());
        transaction.set(usernameRef, {'userId': userId});
        transaction.update(
          usersAuthorRef.doc(userId),
          {
            'userName': username.toUpperCase(),
          },
        );

        transaction.update(
          userProfessionalRef.doc(userId),
          {
            'userName': username.toUpperCase(),
          },
        );
        _userNameCreated = true;
        _updateAuthorHive(username.toUpperCase());
        Provider.of<UserData>(context, listen: false)
            .setChangeUserName(username.toUpperCase());
        animateToPage();
      });
    } catch (e) {
      // Rethrow the caught exception to handle it in the _validate method
      throw e;
    }
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

        if (newUsernameDoc.exists) {
          throw Exception('New username is not unique');
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
        animateToPage();
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
      bio: _provider.user!.bio,
      disabledAccount: _provider.user!.disabledAccount,
      dynamicLink: _provider.user!.dynamicLink,
      lastActiveDate: _provider.user!.lastActiveDate,
      profileHandle: _provider.user!.profileHandle,
      profileImageUrl: _provider.user!.profileImageUrl,
      reportConfirmed: _provider.user!.reportConfirmed,
      userId: _provider.user!.userId,
      userName: userName,
      verified: _provider.user!.verified,
    );

    // Put the new object back into the box with the same key
    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }

  _updateAuthorProfiHandleHive(String profileHandle) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      name: _provider.name,
      bio: _provider.user!.bio,
      disabledAccount: _provider.user!.disabledAccount,
      dynamicLink: _provider.user!.dynamicLink,
      lastActiveDate: _provider.user!.lastActiveDate,
      profileHandle: profileHandle,
      profileImageUrl: _provider.user!.profileImageUrl,
      reportConfirmed: _provider.user!.reportConfirmed,
      userId: _provider.user!.userId,
      userName: _provider.changeNewUserName,
      verified: _provider.user!.verified,
    );

    // Put the new object back into the box with the same key
    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }

  _updateAuthorBioAndImgeUrlHive(String bio, String profileImageUrl) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      name: _provider.name,
      bio: bio,
      disabledAccount: _provider.user!.disabledAccount,
      dynamicLink: _provider.user!.dynamicLink,
      lastActiveDate: _provider.user!.lastActiveDate,
      profileHandle: _provider.user!.profileHandle,
      profileImageUrl: profileImageUrl,
      reportConfirmed: _provider.user!.reportConfirmed,
      userId: _provider.user!.userId,
      userName: _provider.user!.userName,
      verified: _provider.user!.verified,
    );

    // Put the new object back into the box with the same key
    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }

  _validateTextToxicity(String changeUserName) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setIsLoading(true);

    TextModerator moderator = TextModerator();

    // Define the texts to be checked
    List<String> textsToCheck = [changeUserName];

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

      await changeUsername(changeUserName.toUpperCase(),
          _controller.text.toUpperCase(), _provider.currentUserId!);
      mySnackBar(context, 'Username changed successfully');
      // animateToPage(1);
    }
  }

  _validate() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setIsLoading(true);
    var _changeUserName = _provider.changeNewUserName;

    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // Check if the username has changed
      if (_changeUserName == _controller.text.toUpperCase()) {
        animateToPage();
        // mySnackBar(context, '');
      } else {
        try {
          if (_userNameCreated) {
            _validateTextToxicity(_changeUserName);
            // await changeUsername(_changeUserName.toUpperCase(),
            //     _controller.text.toUpperCase(), _provider.currentUserId!);
            // mySnackBar(context, 'Username changed successfully');
          } else {
            await createUser(_controller.text, _provider.currentUserId!);
            mySnackBar(context, 'Username set successfully');
          }
        } catch (e) {
          mySnackBar(context, e.toString());
        }
      }
    }
    _provider.setIsLoading(false);
  }

  _validateTextToxicityBio(AccountHolderAuthor user) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setIsLoading(true);

    TextModerator moderator = TextModerator();

    // Define the texts to be checked
    List<String> textsToCheck = [_provider.bio];

    // Set a threshold for toxicity that is appropriate for your app
    const double toxicityThreshold = 0.7;
    bool allTextsValid = true;

    for (String text in textsToCheck) {
      if (text.isEmpty) {
        // Handle the case where the text is empty
        _provider.setIsLoading(false);
        _submitProfileImage(user);
        // mySnackBar(context, 'Text cannot be empty.');
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

      _submitProfileImage(user); // animateToPage(1);
    }
  }

  _submitProfileImage(AccountHolderAuthor user) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    String currentUserId = _provider.currentUserId!;

    final UserSettingsLoadingPreferenceModel userLocationSettings =
        _provider.userLocationPreference!;

    if (_formKey.currentState!.validate() && !_provider.isLoading) {
      _provider.setIsLoading(true);
      _formKey.currentState?.save();
      FocusScope.of(context).unfocus();
      animateToPage();
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
      String bio = _provider.bio.trim().replaceAll('\n', ' ');

      String link = await DatabaseService.myDynamicLink(
        profileImageUrl,
        _provider.user!.userName!,
        _provider.user!.bio!,
        'https://www.barsopus.com/user_$currentUserId.uid',
      );

      try {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        batch.update(
          usersAuthorRef.doc(currentUserId),
          {
            // 'name': name,
            'profileImageUrl': profileImageUrl,
            'bio': bio,
          },
        );

        batch.update(
          userProfessionalRef.doc(currentUserId),
          {
            'profileImageUrl': profileImageUrl,
            'bio': bio,
          },
        );

        batch.update(
          usersAuthorRef.doc(currentUserId),
          {
            'dynamicLink': link,
          },
        );

        batch.update(
          userProfessionalRef.doc(currentUserId),
          {
            'dynamicLink': link,
          },
        );
        // try {
        batch.commit();
        _updateAuthorBioAndImgeUrlHive(bio, profileImageUrl);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ConfigPage(
                    // email: email,
                    )),
            (Route<dynamic> route) => false);

        mySnackBar(context, 'Your brand has been setup successfully');

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
      _provider.user!.userName!,
      _provider.user!.bio!,
      'https://www.barsopus.com/user_$currentUserId.uid',
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

      animateToPage();
      _updateAuthorProfiHandleHive(_profileHandle);
    } catch (e) {
      _showBottomSheetErrorMessage();
    }
    _provider.setIsLoading(false);
  }

  static const values = <String>[
    "Artist",
    "Producer",
    "DJ",
    "Dancer",
    "Music_Video_Director",
    "Content_creator",
    "Photographer",
    "Record_Label",
    "Brand_Influencer",
    "Event_organiser",
    "Band",
    "Instrumentalist",
    "Cover_Art_Designer",
    "Makeup_Artist",
    "Video_Vixen",
    "Blogger",
    "MC(Host)",
    "Choire",
    "Battle_Rapper",
    "Fan",
  ];

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Column(
            children: values.map((value) {
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

  animateToPage() {
    FocusScope.of(context).unfocus();
    _pageController.animateToPage(
      _index + 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
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

  _setUp() {
    var _richStye = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 40.0),
      color: Theme.of(context).secondaryHeaderColor,
      fontWeight: FontWeight.w100,
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Material(
              color: Colors.transparent,
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(text: "Set Up\n", style: _richStye),
                    TextSpan(text: "Your Brand", style: _richStye),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 2,
            color: Colors.blue,
            width: 10,
          ),
          ShakeTransition(
            duration: Duration(milliseconds: 1200),
            curve: Curves.easeOutBack,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Create a distinctive brand that others can easily recognize and connect with. Embrace your uniqueness among creatives and organizers.',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _outlineButton('Let\s Start', () => animateToPage())
        ],
      ),
    );
  }

  _loadingToNext() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      height: Provider.of<UserData>(
        context,
      ).isLoading
          ? 50
          : 0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Container(
            height: 1.0,
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).primaryColorLight,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
        ),
      ),
    );
  }

  _directionWidget(String title, String subTItle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.blue,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
              height: 1),
        ),
        DirectionWidget(
          text: subTItle,
          fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        ),
      ],
    );
  }

  _setUserName() {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _loadingToNext(),
                  _directionWidget(
                    'Select \nUsername',
                    'Choose a username for your brand. If you\'re a music creative, it can be your stage name. Remember, all usernames are converted to uppercase.',
                  ),
                  const SizedBox(height: 10),
                  new Material(
                    color: Colors.transparent,
                    child: Text(
                      _controller.text.trim().toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 16.0),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LoginField(
                    notLogin: true,
                    controller: _controller,
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
                        // assuming 20 as the maximum length
                        return 'Username cannot be longer than 20 characters';
                      } else {
                        return null;
                      }
                    },
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 60),
                  Provider.of<UserData>(context, listen: false).isLoading
                      ? const SizedBox.shrink()
                      : _outlineButton('Save Username', () {
                          _validate();
                        }),
                  const SizedBox(height: 60),
                ]),
          )),
    );
  }

  _selectAccountType() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _loadingToNext(),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: MiniCircularProgressButton(
            //     color: Colors.blue,
            //     text: 'Skip',
            //     onPressed: () {
            //       _submitProfileHandle();
            //     },
            //   ),
            // ),
            _directionWidget(
              ' Select \nAccount Type',
              'Choose an account type that allows other users to easily identify you for business purposes. You can select only one account type at a time.',
            ),
            buildRadios(),
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _loadingToNext(),
              Align(
                  alignment: Alignment.centerRight,
                  child: MiniCircularProgressButton(
                    color: Colors.blue,
                    text: 'Skip',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => ConfigPage()),
                          (Route<dynamic> route) => false);
                    },
                  )),
              _directionWidget(
                'Set\nPhoto',
                'Choose a brand picture that represents your identity. Utilize the bio text field to share more about yourself, allowing others to get to know you better.',
              ),
              Center(
                child: _provider.isLoading
                    ? SchimmerSkeleton(
                        schimmerWidget: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            radius: ResponsiveHelper.responsiveHeight(
                                context, 80.0),
                            backgroundImage: _displayProfileImage()),
                      )
                    : GestureDetector(
                        onTap: () => _handleImageFromGallery,
                        child: _profileImage == null
                            ? Icon(
                                Icons.account_circle_outlined,
                                size: ResponsiveHelper.responsiveHeight(
                                  context,
                                  150,
                                ),
                                color: Colors.grey,
                              )
                            : CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: ResponsiveHelper.responsiveHeight(
                                  context,
                                  80.0,
                                ),
                                backgroundImage: _displayProfileImage()),
                      ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(width: 1.0, color: Colors.transparent),
                  ),
                  onPressed: _handleImageFromGallery,
                  child: Text(
                    'Set Photo',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 16.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, bottom: 10.0, right: 10.0),
                child: EditProfileTextField(
                  enableBorder: false,
                  labelText: 'bio',
                  hintText: 'A piece of short information about yourself',
                  initialValue: '',
                  onSavedText: (input) => _provider.setBio(input),
                  onValidateText: (input) => input!.trim().length > 700
                      ? 'Please, enter a bio of fewer than 700 characters.'
                      : null,
                ),
              ),
              const SizedBox(height: 60),
              Provider.of<UserData>(context, listen: false).isLoading
                  ? const SizedBox.shrink()
                  : _outlineButton(
                      'Save', () => _validateTextToxicityBio(user)),

              // _submitProfileImage(user)),
            ]),
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
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
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

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        iconTheme: IconThemeData(color: Theme.of(context).secondaryHeaderColor),
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
                  onPageChanged: (int index) {
                    setState(() {
                      _index = index;
                    });
                  },
                  children: [
                    _setUp(),
                    _setUserName(),
                    _selectAccountType(),
                    _bioAndProfilePhoto(user),
                    SingleChildScrollView(
                      child: Container(
                          color: Theme.of(context).primaryColorLight,
                          height: MediaQuery.of(context).size.height - 200,
                          child: Center(
                              child: Loading(
                            color: Theme.of(context).secondaryHeaderColor,
                            title: 'Setting up brand',
                            icon: (Icons.person_outlined),
                          ))),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
