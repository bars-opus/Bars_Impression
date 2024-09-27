import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

// ignore: must_be_immutable
class ProfileVerification extends StatefulWidget {
  final AccountHolderAuthor user;

  static final id = 'ProfileVerification_screen';

  ProfileVerification({
    required this.user,
  });
  @override
  _ProfileVerificationState createState() => _ProfileVerificationState();
}

class _ProfileVerificationState extends State<ProfileVerification> {
  String _newsCoverage = '';
  String _govIdType = '';
  String _wikipedia = '';
  // String _website = '';
  String _socialMedia = '';
  String _otherLink = '';
  late PageController _pageController;
  int _index = 0;

  // bool _isLoading = false;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setNull();
    });
  }

  // _submit() async {
  //   if (!_isLoading) {
  //     animateToPage();
  //     String imageUrl = await StorageService.gvIdImageUrl(
  //         Provider.of<UserData>(context, listen: false).image!);
  //     String vImageUrl = await StorageService.virIdImageUrl(
  //         Provider.of<UserData>(context, listen: false).image!);
  //     Verification verification = Verification(
  //       newsCoverage: _newsCoverage,
  //       govIdType: _govIdType,
  //       verificationType: 'ThroughApp',
  //       storeType: widget.user.storeType!,
  //       wikipedia: _wikipedia,
  //       // email: widget.user.email!,
  //       // phoneNumber: widget.user.contacts!,
  //       website: _website,
  //       socialMedia: _socialMedia,
  //       validationImage: vImageUrl,
  //       otherLink: _otherLink,
  //       gvIdImageUrl: imageUrl,
  //       status: 'Submitted for review',
  //       rejectedReason: '',
  //       userId: widget.user.userId!,
  //       timestamp: Timestamp.fromDate(DateTime.now()),
  //     );
  //     try {
  //       DatabaseService.requestVerification(verification);
  //       final double width = MediaQuery.of(context).size.width;
  //       mySnackBar(context, 'Thank you\n Request submitted successfully');
  //       _pop();
  //       // Flushbar(
  //       //   margin: EdgeInsets.all(8),
  //       //   boxShadows: [
  //       //     BoxShadow(
  //       //       color: Colors.black,
  //       //       offset: Offset(0.0, 2.0),
  //       //       blurRadius: 3.0,
  //       //     )
  //       //   ],
  //       //   flushbarPosition: FlushbarPosition.TOP,
  //       //   flushbarStyle: FlushbarStyle.FLOATING,
  //       //   titleText: Text(
  //       //     'Thank you',
  //       //     style: TextStyle(
  //       //       color: Colors.white,
  //       //       fontSize: width > 800 ? 22 : 14,
  //       //     ),
  //       //   ),
  //       //   messageText: Text(
  //       //     "Request submitted successfully.",
  //       //     style: TextStyle(
  //       //       color: Colors.white,
  //       //       fontSize: width > 800 ? 20 : 12,
  //       //     ),
  //       //   ),
  //       //   icon: Icon(
  //       //     Icons.info_outline,
  //       //     size: 28.0,
  //       //     color: Colors.blue,
  //       //   ),
  //       //   duration: Duration(seconds: 3),
  //       //   leftBarIndicatorColor: Colors.blue,
  //       // )..show(context);
  //     } catch (e) {
  //       _showBottomSheetErrorMessage();

  //       // final double width = MediaQuery.of(context).size.width;
  //       // String error = e.toString();
  //       // String result = error.contains(']')
  //       //     ? error.substring(error.lastIndexOf(']') + 1)
  //       //     : error;
  //       // mySnackBar(context, 'Error\n$result.toString()');
  //       // Flushbar(
  //       //   margin: EdgeInsets.all(8),
  //       //   boxShadows: [
  //       //     BoxShadow(
  //       //       color: Colors.black,
  //       //       offset: Offset(0.0, 2.0),
  //       //       blurRadius: 3.0,
  //       //     )
  //       //   ],
  //       //   flushbarPosition: FlushbarPosition.TOP,
  //       //   flushbarStyle: FlushbarStyle.FLOATING,
  //       //   titleText: Text(
  //       //     'Error',
  //       //     style: TextStyle(
  //       //       color: Colors.white,
  //       //       fontSize: width > 800 ? 22 : 14,
  //       //     ),
  //       //   ),
  //       //   messageText: Text(
  //       //     e.toString(),
  //       //     style: TextStyle(
  //       //       color: Colors.white,
  //       //       fontSize: width > 800 ? 20 : 12,
  //       //     ),
  //       //   ),
  //       //   icon: Icon(
  //       //     Icons.info_outline,
  //       //     size: 28.0,
  //       //     color: Colors.blue,
  //       //   ),
  //       //   duration: Duration(seconds: 3),
  //       //   leftBarIndicatorColor: Colors.blue,
  //       // )..show(context);
  //       print(e.toString());
  //     }
  //   }
  // }

  static const govIdType = <String>[
    "Driver license",
    "Passport",
    "Document of incorporation",
  ];
  String selectedGovIdType = '';

  Widget buildConfirmBrandAuthenticity() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Column(
            children: govIdType.map((govIdType) {
          final selected = this.selectedGovIdType == govIdType;
          final color =
              selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

          return RadioListTile<String>(
            value: govIdType,
            groupValue: selectedGovIdType,
            title: Text(
              govIdType,
              style: TextStyle(
                color: color,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
              ),
            ),
            activeColor: Colors.blue,
            onChanged: (govIdType) => setState(
              () {
                _govIdType = this.selectedGovIdType = govIdType!;
              },
            ),
          );
        }).toList()),
      );

  animateBack() {
    _pageController.animateToPage(
      _index - 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateBack2() {
    _pageController.animateToPage(
      _index - 2,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateToPage() {
    _pageController.animateToPage(
      _index + 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  _handleImage() async {
    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;
    // ignore: unnecessary_null_comparison
    if (file != null) {
      if (mounted) {
        Provider.of<UserData>(context, listen: false).setImage(file as File);
      }
    }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
    );
    return croppedImage!;
  }

  _handleImage2() async {
    final file = await PickCropImage.pickedMedia(cropImage: _cropImage2);
    if (file == null) return;
    // ignore: unnecessary_null_comparison
    if (file != null) {
      if (mounted) {
        Provider.of<UserData>(context, listen: false).setImage(file as File);
      }
    }
  }

  _handleImageCamera() async {
    final file = await PickCropCamera.pickedMedia(cropImage: _cropImage);
    if (file == null) return;

    if (mounted) {
      Provider.of<UserData>(context, listen: false).setImage(file);
    }
  }

  Future<File> _cropImage2(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
    );
    return croppedImage!;
  }

  _displayGovIdImage() {
    final width = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 800),
      height: _govIdType.isNotEmpty ? width / 3 : 0.0,
      width: width / 3,
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _handleImage,
        child: Container(
          // ignore: unnecessary_null_comparison
          child: Provider.of<UserData>(context).image == null
              ? Container(
                  height: width / 3,
                  width: width / 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    MdiIcons.image,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                )
              : Image(
                  height: width / 3,
                  width: width / 3,
                  image: FileImage(
                      File(Provider.of<UserData>(context).image!.path)),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog(context);
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Pick image',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 16),
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Camera',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageCamera();
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'Gallery',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _handleImage2();
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancle',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Pick image',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(
                thickness: .2,
              ),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Camera',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageCamera();
                  },
                ),
              ),
              Divider(
                thickness: .2,
              ),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImage2();
                  },
                ),
              ),
              Divider(
                thickness: .2,
              ),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        });
  }

  _showSelectImageDialog2() {
    return Platform.isIOS ? _iosBottomSheet2() : _androidDialog2(context);
  }

  // _gotToEditProfile() async {
  //   UserStoreModel user =
  //       await DatabaseService.getUserProfessionalWithId(
  //     widget.user.userId!,
  //   );
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => EditProfileProfessional(
  //           user: user,
  //         ),
  //       ));
  // }

  _iosBottomSheet2() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Account  Information\n',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 20),
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text:
                        'We have noticed that some information about your account has not been provided. You must provide the necessary information required for account verification.\n(bio, username, profile photo, company, contact, email, management, skills, website, or any other social media platform and 3 professional photos).\n\nRestart your verification request process after providing the information required.',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
              textScaler:
                  TextScaler.linear(MediaQuery.of(context).textScaleFactor),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // widget.user.storeType!.startsWith('Fan')
                  //     ? Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (_) => EditProfileScreen(
                  //             user: widget.user,
                  //           ),
                  //         ))
                  //     : _gotToEditProfile();
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancle',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog2(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Account  Information\n',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 20),
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text:
                        'We have noticed that some information about your account has not been provided. You must provide the necessary information required for account verification.\n(bio, username, profile photo, company, contact, email, management, skills, website, or any other social media platform and 3 professional photos).\n\nRestart your verification request process after providing the information required.',
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
              textScaler:
                  TextScaler.linear(MediaQuery.of(context).textScaleFactor),
            ),
            children: <Widget>[
              Divider(
                thickness: .2,
              ),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Edit profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // widget.user.storeType!.startsWith('Fan')
                    //     ? Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (_) => EditProfileScreen(
                    //             user: widget.user,
                    //           ),
                    //         ))
                    //     : _gotToEditProfile();
                  },
                ),
              ),
              Divider(
                thickness: .2,
              ),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        });
  }

  _displayValidationImage() {
    final width = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 800),
      // height: Provider.of<UserData>(context).contact.isEmpty ? 0.0 : width / 3,
      width: width / 3,
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _showSelectImageDialog,
        child: Container(
          // ignore: unnecessary_null_comparison
          child: Provider.of<UserData>(context).image == null
              ? Icon(
                  MdiIcons.camera,
                  color:
                      // Provider.of<UserData>(context).contact.isEmpty
                      //     ? Colors.transparent
                      //     :
                      Colors.grey,
                  size: 150,
                )
              : Image(
                  height: width / 3,
                  width: width / 3,
                  image: FileImage(
                      File(Provider.of<UserData>(context).image!.path)),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  showNotabilityWarning() {
    // final width = Responsive.isDesktop(context)
    // ? 600.0
    // : MediaQuery.of(context).size.width;
    mySnackBar(context,
        'Action denied\nKindly enter atleast two links in order to continue');
    // Flushbar(
    //   margin: EdgeInsets.all(8),
    //   boxShadows: [
    //     BoxShadow(
    //       color: Colors.black,
    //       offset: Offset(0.0, 2.0),
    //       blurRadius: 3.0,
    //     )
    //   ],
    //   flushbarPosition: FlushbarPosition.TOP,
    //   flushbarStyle: FlushbarStyle.FLOATING,
    //   titleText: Text(
    //     'Action denied',
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontSize: width > 800 ? 22 : 14,
    //     ),
    //   ),
    //   messageText: Text(
    //     "Kindly enter atleast two links in order to continue",
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontSize: width > 800 ? 20 : 12,
    //     ),
    //   ),
    //   icon: Icon(
    //     MdiIcons.checkCircleOutline,
    //     size: 30.0,
    //     color: Colors.blue,
    //   ),
    //   duration: Duration(seconds: 3),
    //   leftBarIndicatorColor: Colors.blue,
    // )..show(context);
  }

  _pop() {
    Navigator.pop(context);
    _setNull();
  }

  _setNull() {
    _otherLink = '';
    _govIdType = '';
    // _website = '';
    _newsCoverage = '';
    _wikipedia = '';
    Provider.of<UserData>(context, listen: false).setImage(null);
    Provider.of<UserData>(context, listen: false).setImage(null);
    // Provider.of<UserData>(context, listen: false).setContact('');
    // _isLoading = false;
  }

  _setCode() {
    //contact is used to store the code for a moment but would be deleted after the process
    // Provider.of<UserData>(context, listen: false).setContact(
    //     widget.user.id!.substring(0, 3) +
    //         Timestamp.fromDate(DateTime.now()..microsecond)
    //             .toString()
    //             .substring(43, 45));
    // Timer(Duration(minutes: 1), () {
    //   Provider.of<UserData>(context, listen: false).setContact('');
    // });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: DatabaseService.getVerificationUser(widget.user.userId!),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
              width: width,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            );
          }
          Verification _verification = snapshot.data;
          return _verification.userId.isNotEmpty ||
                  _verification.email.isNotEmpty
              ? VerificationInfo(
                  user: widget.user,
                  verification: _verification,
                )
              : Scaffold(
                  backgroundColor: _index == 7
                      ? Colors.blue
                      : Theme.of(context).primaryColor,
                  appBar: AppBar(
                    backgroundColor: _index == 7
                        ? Colors.blue
                        : Theme.of(context).primaryColor,
                    iconTheme:
                        IconThemeData(color: Theme.of(context).primaryColor),
                    leading: _index == 7
                        ? const SizedBox.shrink()
                        : IconButton(
                            icon: Icon(Platform.isIOS
                                ? Icons.arrow_back_ios
                                : Icons.arrow_back),
                            onPressed: () {
                              _index != 0 ? animateBack() : _pop();
                            }),
                    automaticallyImplyLeading: true,
                    elevation: 0,
                  ),
                  body: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (int index) {
                        setState(() {
                          _index = index;
                        });
                      },
                      children: [
                        Container(
                          height: width * 2,
                          width: double.infinity,
                          child: ListView(
                            children: [
                              Icon(
                                MdiIcons.checkboxMarkedCircle,
                                size: 50,
                                color: Colors.blue,
                              ),
                              Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Request \nVerification',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 40),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 150),
                                child: Container(
                                  height: 1.5,
                                  color: Colors.blue,
                                  width: 10,
                                ),
                              ),
                              ShakeTransition(
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Text(
                                    'A blue check is added to a verified account to establish the authenticity of that account. You will need to confirm your identity with Bars Impression in order to be Verified. This helps encourage and maintain trust between users.',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 14),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              FadeAnimation(
                                0.5,
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 70.0),
                                    child: AlwaysWhiteButton(
                                        onPressed: () {
                                          animateToPage();
                                        },
                                        buttonText: "Start"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: width * 2,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView(
                              children: [
                                Center(
                                  child: Text(
                                    'Requirements',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 30),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                DirectionWidget(
                                  text:
                                      'Specific requirements must be met in order to be verifified.',
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14),
                                  sizedBox: 10,
                                ),
                                SizedBox(height: 30),
                                ShakeTransition(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7.0),
                                    child: FeatureInfoWidget(
                                      title: 'Adherence to Terms of Use.',
                                      subTitle:
                                          'Your account must be active with a record of adherence to the Bars Impression Terms of Use.',
                                      number: '1',
                                    ),
                                  ),
                                ),
                                ShakeTransition(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7.0),
                                    child: FeatureInfoWidget(
                                      title: 'Account Information: ',
                                      subTitle:
                                          'You must provide the necessary information required for setting up your brand. Information such as username, profile image, and bio, must be provided for account types of fans.  Other account types such as Salon, producer, cover art designer, music video director, DJ, battle rapper, photographer, dancer, video vixen, Makeup Salon, record label, brand influencer, blogger, and mC(Host) must provide the necessary booking information.',
                                      number: '2',
                                    ),
                                  ),
                                ),
                                ShakeTransition(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7.0),
                                    child: FeatureInfoWidget(
                                      title: 'Active: ',
                                      subTitle:
                                          'You must have logged into your account in the last two months.',
                                      number: '3',
                                    ),
                                  ),
                                ),
                                ShakeTransition(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: FeatureInfoWidget(
                                      title: 'Ineligible accounts',
                                      subTitle:
                                          'Certain accounts are ineligible for verification.\nParody, newsfeed, commentary, unofficial fan accounts, Pets, and fictional characters.',
                                      number: '4',
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 70.0),
                                    child:
                                        widget.user.storeType!.startsWith('Fan')
                                            ? AlwaysWhiteButton(
                                                onPressed: () {
                                                  widget.user.profileImageUrl!
                                                              .isNotEmpty &&
                                                          widget.user.userName!
                                                              .isNotEmpty &&
                                                          widget.user.bio!
                                                              .isNotEmpty
                                                      ? animateToPage()
                                                      : _showSelectImageDialog2();
                                                },
                                                buttonText: "Continue")
                                            : AlwaysWhiteButton(
                                                onPressed: () {
                                                  // widget.user.skills!.isNotEmpty &&
                                                  //         widget.user.otherSites1!
                                                  //             .isNotEmpty &&
                                                  //         widget.user.otherSites2!
                                                  //             .isNotEmpty &&
                                                  //         widget.user.website!
                                                  //             .isNotEmpty &&
                                                  //         widget.user.management!
                                                  //             .isNotEmpty &&
                                                  //         widget.user.contacts!
                                                  //             .isNotEmpty &&
                                                  //         widget.user.mail!
                                                  //             .isNotEmpty &&
                                                  //         widget
                                                  //             .user
                                                  //             .professionalPicture1!
                                                  //             .isNotEmpty &&
                                                  //         widget
                                                  //             .user
                                                  //             .professionalPicture2!
                                                  //             .isNotEmpty &&
                                                  //         widget
                                                  //             .user
                                                  //             .professionalPicture3!
                                                  //             .isNotEmpty &&
                                                  //         widget
                                                  //             .user
                                                  //             .profileImageUrl!
                                                  //             .isNotEmpty &&
                                                  //         widget.user.userName!
                                                  //             .isNotEmpty &&
                                                  //         widget.user.company!
                                                  //             .isNotEmpty &&
                                                  //         widget.user.bio!
                                                  //             .isNotEmpty
                                                  //     ? animateToPage()
                                                  //     : _showSelectImageDialog2();
                                                },
                                                buttonText: "Continue"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: width * 2,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'Authenticity',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 30),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                DirectionWidget(
                                  text: _govIdType.isEmpty
                                      ? 'You will need to confirm your identity with Bars Impression to be Verified. This helps encourage and maintain trust between users on the platform.  Provide a photo of a valid official government-issued identification document, such as your Driver’s License or Passport if you are and individual. Companies, brands, or organizations are required to provide their document of incorporation.'
                                      : 'Attach an image of your $_govIdType and lets continue',
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14),
                                  sizedBox: 10,
                                ),
                                SizedBox(height: 10),
                                _govIdType.isEmpty
                                    ? buildConfirmBrandAuthenticity()
                                    : const SizedBox.shrink(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Center(
                                    child: _displayGovIdImage(),
                                  ),
                                ),
                                Provider.of<UserData>(context).image == null
                                    ? const SizedBox.shrink()
                                    : Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 70.0),
                                          child: AlwaysWhiteButton(
                                              onPressed: () {
                                                animateToPage();
                                              },
                                              buttonText: "Continue"),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: width * 2,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView(
                              children: [
                                Center(
                                  child: Text(
                                    'Notability: 1',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 30),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                DirectionWidget(
                                  text:
                                      'Your account must represent or otherwise be associated with a prominently recognized individual or brand. Add articles, social media accounts, and other links that show your account is in the public interest. ',
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14),
                                  sizedBox: 10,
                                ),
                                SizedBox(height: 20),
                                ContentFieldBlack(
                                  labelText: 'Wikipedia',
                                  hintText: "Wikipedia link",
                                  initialValue: _wikipedia,
                                  onSavedText: (input) => _wikipedia = input,
                                  onValidateText: () {},
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Provide a link to a stable Wikipedia article about you',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 12),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ContentFieldBlack(
                                  labelText: 'News coverage',
                                  hintText: "News coverage link",
                                  initialValue: _newsCoverage,
                                  onSavedText: (input) => _newsCoverage = input,
                                  onValidateText: () {},
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Provide news articles that are about or reference yourself multiple times in the article. These articles must be from recognized news organizations and cannot be blog or self-published content.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 12),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 70.0),
                                    child: AlwaysWhiteButton(
                                        onPressed: () {
                                          _wikipedia.isEmpty &&
                                                  _newsCoverage.isEmpty
                                              ? showNotabilityWarning()
                                              : animateToPage();
                                        },
                                        buttonText: "Continue"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: width * 2,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView(
                              children: [
                                Center(
                                  child: Text(
                                    'Notability: 2',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 30),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                DirectionWidget(
                                  text:
                                      'Your account must represent or otherwise be associated with a prominently recognized individual or brand. Add articles, social media accounts, and other links that show your account is in the public interest. ',
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14),
                                  sizedBox: 10,
                                ),
                                ContentFieldBlack(
                                  labelText: 'Social media',
                                  hintText: "link to any social account",
                                  initialValue: _socialMedia,
                                  onSavedText: (input) => _socialMedia = input,
                                  onValidateText: () {},
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Provide a link to any of your social media accounts that are in the public interest.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 12),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                ContentFieldBlack(
                                  labelText: 'Other link',
                                  hintText: "link",
                                  initialValue: _otherLink,
                                  onSavedText: (input) => _otherLink = input,
                                  onValidateText: () {},
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'You can provide an additional link to confirm your notability.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 12),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 70.0),
                                    child: AlwaysWhiteButton(
                                        onPressed: () {
                                          _socialMedia.isEmpty &&
                                                  _otherLink.isEmpty
                                              ? showNotabilityWarning()
                                              : animateToPage();
                                        },
                                        buttonText: "Continue"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: width * 2,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView(children: [
                              Center(
                                child: Text(
                                  'Validation',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 30),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Provider.of<UserData>(context).image == null
                                  ? DirectionWidget(
                                      text:
                                          // Provider.of<UserData>(context,
                                          //             listen: false)
                                          //         .contact
                                          //         .isEmpty
                                          //     ? 'This final step requires you to provide a picture of yourself holding a paper with a generated code.\nYou can generate the code by tapping on the button below.\nYou have 5 minutes to boldly write the code on paper and take a picture with it for submission.'
                                          //     :
                                          'You have 5 minutes to boldly write the code on paper and take a picture with it for submission',
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 14),
                                      sizedBox: 10,
                                    )
                                  : DirectionWidget(
                                      text:
                                          'You can submit your request for review',
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 14),
                                      sizedBox: 10,
                                    ),
                              Center(
                                child: Text(
                                  // Provider.of<UserData>(context,
                                  //         listen: false)
                                  //     .contact,'
                                  '',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 30),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: _displayValidationImage(),
                              ),
                              Provider.of<UserData>(context).image == null
                                  ? Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 70.0),
                                        child: AnimatedContainer(
                                          curve: Curves.easeInOut,
                                          duration: Duration(milliseconds: 800),
                                          height:
                                              // Provider.of<UserData>(context)
                                              //         .contact
                                              //         .isEmpty
                                              //     ? 35.0
                                              //     :
                                              0.0,
                                          child: AlwaysWhiteButton(
                                              onPressed: () {
                                                _setCode();
                                              },
                                              buttonText: "Generate Code"),
                                        ),
                                      ),
                                    )
                                  : FadeAnimation(
                                      0.5,
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 60.0, bottom: 40),
                                          child: Container(
                                            width: 250.0,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  elevation: 20.0,
                                                  foregroundColor: Colors.blue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: Text(
                                                    'Submit Request',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {}
                                                // _submit
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ]),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                              color: Colors.blue,
                              height: MediaQuery.of(context).size.height - 200,
                              child: Center(
                                  child: Loading(
                                title: 'Submitting request',
                                icon: (MdiIcons.checkboxMarkedCircle),
                              ))),
                        )
                      ],
                    ),
                  ),
                );
        });
  }
}
