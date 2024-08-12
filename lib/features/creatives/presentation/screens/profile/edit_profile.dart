import 'package:bars/utilities/exports.dart';
import 'package:hive/hive.dart';

class EditProfileScreen extends StatefulWidget {
  final AccountHolderAuthor user;
  EditProfileScreen({
    required this.user,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  String _name = '';
  String _userName = '';
  String _bio = '';
  bool _isLoading = false;
  bool _isLoadingBooking = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name!;
    _userName = widget.user.userName!;
    _bio = widget.user.bio!;
  }

  _handleImageFromGallery() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;
    try {
      // ignore: unnecessary_null_comparison
      _provider.setIsLoading(true);
      bool isHarmful = await HarmfulContentChecker.checkForHarmfulContent(
          context, file as File);

      if (isHarmful) {
        mySnackBarModeration(context,
            'Harmful content detected. Please choose a different image. Please review');
        _provider.setIsLoading(false);
      } else {
        if (mounted) {
          setState(() {
            _provider.setIsLoading(false);
            _profileImage = file;
          });
        }
      }
    } catch (e) {
      setState(() {
        _provider.setIsLoading(false);
        _profileImage = null;
      });
      mySnackBar(context,
          'An error occured\nCheck your internet connection and try again.');
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
    if (_profileImage == null) {
      if (widget.user.profileImageUrl!.isEmpty) {
        return AssetImage(
          'assets/images/user_placeholder2.png',
        );
      } else {
        return CachedNetworkImageProvider(widget.user.profileImageUrl!);
      }
    } else {
      return FileImage(_profileImage!);
    }
  }

  _flushBar(String title, String subTitle) {
    return mySnackBar(context, '$title\n$subTitle');
  }

  _submit() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (_formKey.currentState!.validate() && !_isLoading) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      String _profileImageUrl = '';

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl!;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
          widget.user.profileImageUrl!,
          _profileImage!,
        );
      }

      String name = _name.trim().replaceAll('\n', ' ');
      String bio = _bio.trim().replaceAll('\n', ' ');
      String dynamicLink = await DatabaseService.myDynamicLink(
        _profileImageUrl,
        _provider.user!.userName!,
        _bio,
        'https://www.barsopus.com/user_${_provider.currentUserId}',
      );

      try {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        batch.update(
          usersAuthorRef.doc(widget.user.userId),
          {
            'name': name,
            'profileImageUrl': _profileImageUrl,
            'bio': bio,
            'dynamicLink': dynamicLink,
          },
        );

        batch.update(
          userProfessionalRef.doc(widget.user.userId),
          {
            'profileImageUrl': _profileImageUrl,
            'dynamicLink': dynamicLink,
          },
        );

        try {
          batch.commit();
        } catch (error) {}

        _updateAuthorHive(name, bio, _profileImageUrl, dynamicLink);

        Navigator.pop(context);
        _flushBar(
          widget.user.name!,
          "Your profile was edited successfully!!!",
        );
      } catch (e) {
        _showBottomSheetErrorMessage('Failed to save profile');

        _flushBar(
          'Error',
          "result.toString()",
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  _updateAuthorHive(
      String name, String bio, String profileImageUrl, String link) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      name: name,
      bio: bio,
      disabledAccount: _provider.user!.disabledAccount,
      dynamicLink: link,
      lastActiveDate: _provider.user!.lastActiveDate,
      profileHandle: _provider.user!.profileHandle,
      profileImageUrl: profileImageUrl,
      reportConfirmed: _provider.user!.reportConfirmed,
      userId: _provider.user!.userId,
      userName: _provider.user!.userName,
      verified: _provider.user!.verified,
      privateAccount: _provider.user!.privateAccount,
      disableChat: _provider.user!.disableChat,
    );

    // Put the new object back into the box with the same key
    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetErrorMessage(String errorTitle) {
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
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  _changeUserNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 10.0),
          ),
        ),
        DummyTextField(
          onPressed: () {
            _navigateToPage(
              context,
              EditProfileName(
                user: widget.user,
              ),
            );
          },
          text: _userName.toUpperCase(),
        ),
      ],
    );
  }

  _stageNameAndBioFields() {
    return Column(
      children: [
        EditProfileTextField(
          padding: 0,
          labelText: 'Stage name',
          hintText: 'Stage or brand or nickname',
          initialValue: _name,
          onValidateText: (input) =>
              input!.trim().length < 1 ? 'Please enter a valid nickname' : null,
          onSavedText: (input) => _name = input,
          enableBorder: false,
        ),
        EditProfileTextField(
          padding: 0,
          enableBorder: false,
          labelText: 'bio',
          hintText: 'A piece of short information about yourself',
          initialValue: _bio,
          onSavedText: (input) => _bio = input,
          onValidateText: (input) => input!.trim().length > 700
              ? 'Please, enter a bio of fewer than 700 characters.'
              : null,
        ),
      ],
    );
  }

  _loadingPortfolio(bool isBooking, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isBooking
                ? SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.blue,
                    ),
                  )
                : AnimatedCircle(
                    size: 15,
                    stroke: 2,
                    animateShape: true,
                  ),
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: isBooking ? ' Booking portfolio' : 'Brand target',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Theme.of(context).secondaryHeaderColor,
              size: ResponsiveHelper.responsiveFontSize(context, 15),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheetNoCity() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    final UserSettingsLoadingPreferenceModel _user =
        _provider.userLocationPreference!;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 600),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NoContents(
                      title: 'No City',
                      subTitle:
                          'Enter your location to setup your booking portfolio. When you enter your city, we can suggest local events taking place in that area, as well as connect you with other creatives who are also based in the same location. This facilitates meaningful connections and creates opportunities for potential business collaborations and networking.',
                      icon: Icons.location_on_outlined),
                  SizedBox(
                    height: ResponsiveHelper.responsiveHeight(context, 30),
                  ),
                  BlueOutlineButton(
                    buttonText: 'Enter city',
                    onPressed: () {
                      Navigator.pop(context);
                      _navigateToPage(
                        context,
                        EditProfileSelectLocation(
                          user: _user,
                        ),
                      );
                    },
                  ),
                ],
              )),
        );
      },
    );
  }

  _editPageOptionWidget() {
    var _provider = Provider.of<UserData>(context, listen: false);

    final UserSettingsLoadingPreferenceModel _user =
        _provider.userLocationPreference!;
    var _divider = Divider(
      thickness: .2,
      color: Colors.grey,
    );
    return Column(
      children: [
        IntroInfo(
          leadingIcon: Icons.person_outline,
          titleColor: Theme.of(context).secondaryHeaderColor,
          title: 'Account Type',
          onPressed: () {
            _navigateToPage(
              context,
              EditProfileHandle(
                user: widget.user,
              ),
            );
          },
          subTitle: "",
          icon: Icons.arrow_forward_ios_outlined,
        ),
        _divider,
        IntroInfo(
          leadingIcon: Icons.location_on_outlined,
          titleColor: Theme.of(context).secondaryHeaderColor,
          title: 'Change location',
          onPressed: () {
            _navigateToPage(
              context,
              EditProfileSelectLocation(
                user: _user,
              ),
            );
          },
          subTitle: "",
          icon: Icons.arrow_forward_ios_outlined,
        ),
        _divider,
        _isLoadingBooking
            ? _loadingPortfolio(true, () {})
            : IntroInfo(
                leadingIcon: Icons.work_outline_sharp,
                titleColor: Theme.of(context).secondaryHeaderColor,
                title: 'Booking portfolio',
                onPressed: _user.city!.isEmpty
                    ? () {
                        _showBottomSheetNoCity();
                      }
                    : () async {
                        if (_isLoadingBooking) return;
                        _isLoadingBooking = true;

                        try {
                          UserProfessionalModel? user =
                              await DatabaseService.getUserProfessionalWithId(
                            widget.user.userId!,
                          );

                          if (user != null) {
                            _navigateToPage(
                              context,
                              EditProfileProfessional(
                                user: user,
                              ),
                            );
                          } else {
                            _showBottomSheetErrorMessage(
                                'Failed to fetch booking data.');
                          }
                        } catch (e) {
                          _showBottomSheetErrorMessage(
                              'Failed to fetch booking data.');
                        } finally {
                          _isLoadingBooking = false;
                        }
                      },
                subTitle: "",
                icon: Icons.arrow_forward_ios_outlined,
              ),
        _divider,
        _loadingPortfolio(
          false,
          () {
            _navigateToPage(
                context,
                HopeIntroductionScreen(
                  isIntro: false,
                ));
          },
        ),
        _divider,
        IntroInfo(
          leadingIcon: Icons.settings_outlined,
          titleColor: Theme.of(context).secondaryHeaderColor,
          title: 'Account settings',
          onPressed: () {
            _navigateToPage(
              context,
              ProfileSettings(
                user: widget.user,
              ),
            );
          },
          subTitle: "",
          icon: Icons.arrow_forward_ios_outlined,
        ),
        _divider,
      ],
    );
  }

  _closeWidget() {
    return IconButton(
      icon: Icon(Icons.close),
      iconSize: 30.0,
      color: Colors.grey,
      onPressed: () => Navigator.pop(context),
    );
  }

  _suggestionWidget() {
    return GestureDetector(
        onTap: () => _navigateToPage(context, SuggestionBox()),
        child: Material(
            color: Colors.transparent,
            child: Text('Suggestion Box',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                ))));
  }

  _profileImageWidget() {
    var _provider = Provider.of<UserData>(
      context,
    );
    return Column(
      children: [
        _provider.isLoading
            ? SchimmerSkeleton(
                schimmerWidget: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    radius: ResponsiveHelper.responsiveHeight(context, 80.0),
                    backgroundImage: _displayProfileImage()),
              )
            : Hero(
                tag: 'container1' + widget.user.userId.toString(),
                child: GestureDetector(
                  onTap: _handleImageFromGallery,
                  child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      radius: ResponsiveHelper.responsiveHeight(context, 80.0),
                      backgroundImage: _displayProfileImage()),
                ),
              ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.transparent,
            side: BorderSide(width: 1.0, color: Colors.transparent),
          ),
          onPressed: _handleImageFromGallery,
          child: Text(
            'Set photo',
            style: TextStyle(
              color: Colors.blue,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            ),
          ),
        ),
      ],
    );
  }

  _validateTextToxicity() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setIsLoading(true);

    TextModerator moderator = TextModerator();

    // Define the texts to be checked
    List<String> textsToCheck = [_bio, _name];

    // Set a threshold for toxicity that is appropriate for your app
    const double toxicityThreshold = 0.7;
    bool allTextsValid = true;

    for (String text in textsToCheck) {
      if (text.isEmpty) {
        // Handle the case where the text is empty
        _provider.setIsLoading(false);
        _submit();
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
              'Your bio, stagename or username contains inappropriate statements. Please review');
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

      _submit();
      // animateToPage(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    final UserSettingsLoadingPreferenceModel? _user =
        _provider.userLocationPreference;

    return EditProfileScaffold(
      title: 'Edit Profile',
      widget: Form(
        key: _formKey,
        child: Column(
          children: [
            _isLoading ? LinearProgress() : const SizedBox.shrink(),
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    _profileImageWidget(),
                    const SizedBox(
                      height: 30.0,
                    ),
                    // _userNameInfo(),
                    // const SizedBox(height: 20),
                    Divider(
                      thickness: .2,
                      color: Colors.grey,
                    ),
                    Column(
                      children: [
                        _changeUserNameField(),
                        _stageNameAndBioFields(),
                      ],
                    ),

                    const SizedBox(
                      height: 40,
                    ),
                    if (_user != null) _editPageOptionWidget(),
                    _isLoading || _provider.isLoading
                        ? Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: CircularProgress(
                              isMini: true,
                              indicatorColor: Colors.blue,
                            ))
                        : Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: AlwaysWhiteButton(
                              buttonText: 'Save',
                              onPressed: () {
                                _validateTextToxicity();
                                // _submit();
                              },
                              buttonColor: Colors.blue,
                            ),
                          ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        _navigateToPage(
                            context,
                            UserBarcode(
                              profileImageUrl: widget.user.profileImageUrl!,
                              userDynamicLink: widget.user.dynamicLink!,
                              bio: widget.user.bio!,
                              userName: widget.user.userName!,
                              userId: widget.user.userId!,
                            ));
                      },
                      child: Hero(
                          tag: widget.user.userId!,
                          child: Icon(
                            Icons.qr_code,
                            color: Colors.blue,
                            size:
                                ResponsiveHelper.responsiveHeight(context, 30),
                          )),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    _closeWidget(),
                    const SizedBox(
                      height: 50.0,
                    ),
                  ],
                )),
            _suggestionWidget(),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                _navigateToPage(
                    context,
                    CompainAnIssue(
                      parentContentId: widget.user.userId!,
                      authorId: widget.user.userId!,
                      complainContentId: widget.user.userId!,
                      complainType: 'Account',
                      parentContentAuthorId: widget.user.userId!,
                    ));
              },
              child: Text(
                'Complain an issue.',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
