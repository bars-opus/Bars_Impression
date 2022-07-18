import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class ProfileVerification extends StatefulWidget {
  final AccountHolder user;

  static final id = 'ProfileVerification_screen';

  ProfileVerification({
    required this.user,
  });
  @override
  _ProfileVerificationState createState() => _ProfileVerificationState();
}

class _ProfileVerificationState extends State<ProfileVerification> {
  String _brandType = '';
  String _govIdType = '';
  String _legalName = '';
  String _brandAudienceCustomers = '';
  String _website = '';
  String _email = '';
  String _phoneNumber = '';
  String _socialMedia = '';
  String _notableArticleLink1 = '';
  String _notableArticleLink2 = '';
  late PageController _pageController;
  int _index = 0;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandAudienceCustomersTextController =
      TextEditingController();

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  _submit() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });

      String imageUrl = await StorageService.gvIdImageUrl(
          Provider.of<UserData>(context, listen: false).postImage!);

      Verification verification = Verification(
        brandType: _brandType.isEmpty ? 'Public Figure' : _brandType,
        govIdType: _govIdType.isEmpty ? 'Driver license' : _govIdType,
        legalName: _legalName,
        verificationType: 'ThroughApp',
        profileHandle: widget.user.profileHandle!,
        brandAudienceCustomers: _brandAudienceCustomers,
        email: _email,
        phoneNumber: _phoneNumber,
        website: _website,
        socialMedia: _socialMedia,
        notableAricle1: _notableArticleLink1,
        notableAricle2: _notableArticleLink2,
        gvIdImageUrl: imageUrl,
        userId: widget.user.id!,
        timestamp: Timestamp.fromDate(DateTime.now()),
        id: '',
      );
      try {
        DatabaseService.requestVerification(verification);
        final double width = MediaQuery.of(context).size.width;
        Navigator.pop(context);
        Flushbar(
          margin: EdgeInsets.all(8),
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Text(
            'Thank you',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            "Request submitted successfully.",
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      } catch (e) {
        final double width = MediaQuery.of(context).size.width;
        Flushbar(
          margin: EdgeInsets.all(8),
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Text(
            'Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
        print(e.toString());
      }
      setState(() {
        _brandType = '';
        _govIdType = '';
        _website = '';
        _phoneNumber = '';
        _legalName = '';
        _email = '';
        _brandAudienceCustomers = '';
        _isLoading = false;
      });
    }
  }

  static const brandType = <String>[
    "Public Figure",
    "Business/Institution",
  ];
  String selectedBrandType = brandType.last;

  Widget buildBrandType() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: brandType.map((mostHelpfulFeature) {
          final selected = this.selectedBrandType == mostHelpfulFeature;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
            value: mostHelpfulFeature,
            groupValue: selectedBrandType,
            title: Text(
              mostHelpfulFeature,
              style: TextStyle(color: color, fontSize: 14),
            ),
            activeColor: Colors.blue,
            onChanged: (brandType) => setState(
              () {
                _brandType = this.selectedBrandType = brandType!;
              },
            ),
          );
        }).toList()),
      );

  static const govIdType = <String>[
    "Driver license",
    "Passport",
    "Voters Id Card",
  ];
  String selectedGovIdType = govIdType.last;

  Widget buildConfirmBrandAuthenticity() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: govIdType.map((govIdType) {
          final selected = this.selectedGovIdType == govIdType;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
            value: govIdType,
            groupValue: selectedGovIdType,
            title: Text(
              govIdType,
              style: TextStyle(color: color, fontSize: 14),
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
        Provider.of<UserData>(context, listen: false)
            .setPostImage(file as File);
      }
    }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.5),
    );
    return croppedImage!;
  }

  _displayPostImage() {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: _handleImage,
      child: Container(
        // ignore: unnecessary_null_comparison
        child: Provider.of<UserData>(context).postImage == null
            ? Container(
                height: width / 4,
                width: width / 4,
                decoration: BoxDecoration(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  MdiIcons.image,
                  color: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Color(0xFFf2f2f2),
                  size: 30,
                ),
              )
            : Image(
                height: width / 4,
                width: width / 4,
                image: FileImage(
                    File(Provider.of<UserData>(context).postImage!.path)),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
        appBar: AppBar(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn
                  ? Color(0xFFf2f2f2)
                  : Color(0xFF1a1a1a)),
          leading: IconButton(
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
            key: _formKey,
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (int index) {
                setState(() {
                  _index = index;
                });
              },
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Container(
                      height: width * 2,
                      width: double.infinity,
                      child: Column(
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
                                    color: ConfigBloc().darkModeOn
                                        ? Color(0xFFf2f2f2)
                                        : Color(0xFF1a1a1a),
                                    fontSize: 40),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 2,
                            color: Colors.blue,
                            width: 10,
                          ),
                          ShakeTransition(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Text(
                                'Bars Impression verification adds a blue check to a verified account to establish the truth, accuracy, and validity of the presence of a brand, public figure, or celebrities.',
                                style: TextStyle(
                                    color: ConfigBloc().darkModeOn
                                        ? Color(0xFFf2f2f2)
                                        : Color(0xFF1a1a1a),
                                    fontSize: 14),
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
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    child: Container(
                      height: width * 2,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DirectionWidget(
                              text: 'Select Brand Type',
                              fontSize: 20,
                            ),
                            SizedBox(height: 20),
                            buildBrandType(),
                            ContentField(
                              labelText: 'Contact email',
                              hintText: "Contact email",
                              initialValue: widget.user.mail!,
                              onSavedText: (input) => _email = input,
                              onValidateText: (email) => email.isEmpty
                                  ? 'Contant email cannot be empty'
                                  : null,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'We\"ll use this for communication about your account',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ContentField(
                              labelText: 'Contact phone number',
                              hintText: "Contact phone number",
                              initialValue: widget.user.contacts!,
                              onSavedText: (input) => _phoneNumber = input,
                              onValidateText: (phoneNumber) =>
                                  phoneNumber.isEmpty
                                      ? 'Contant phone number cannot be empty'
                                      : null,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Include the + symbol, country code and area code.',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 70.0),
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
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: width * 2,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DirectionWidget(
                              text: 'Organization Name',
                              fontSize: 20,
                            ),
                            SizedBox(height: 20),
                            ContentField(
                              labelText: widget.user.name!,
                              hintText: "The full legal name ",
                              initialValue: widget.user.name!,
                              onSavedText: (input) => _legalName = input,
                              onValidateText: (legalName) => legalName.isEmpty
                                  ? 'Orgnization name cannot be empty'
                                  : null,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'The full legal name of your organization for example Bar Impression  LLC',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                            buildConfirmBrandAuthenticity(),
                            Center(
                              child: _displayPostImage(),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 70.0),
                                child: AlwaysWhiteButton(
                                    onPressed: () {
                                      animateToPage();
                                    },
                                    buttonText: "Continue"),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: width * 2,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DirectionWidget(
                              text: 'Confirm Notability',
                              fontSize: 20,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              color: Colors.blue[100],
                              height: 100,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: TextFormField(
                                  controller:
                                      _brandAudienceCustomersTextController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines:
                                      _brandAudienceCustomersTextController
                                                  .text.length >
                                              300
                                          ? 10
                                          : null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  validator: (brandAudience) =>
                                      brandAudience!.isEmpty
                                          ? 'Kindly leave an advice'
                                          : null,
                                  onSaved: (input) =>
                                      _brandAudienceCustomers = input!,
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'What do you think?...',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ContentField(
                              labelText: 'Social media account',
                              hintText:
                                  "Link to any of your social media account",
                              initialValue: '',
                              onSavedText: (input) => _socialMedia = input,
                              onValidateText: (suggestion) => suggestion.isEmpty
                                  ? 'Social link media cannot be empty'
                                  : null,
                            ),
                            ContentField(
                              labelText: 'Website',
                              hintText: "Link to your website",
                              initialValue: '',
                              onSavedText: (input) => _website = input,
                              onValidateText: (_) {},
                            ),
                            ContentField(
                              labelText: 'Notable article 1',
                              hintText: "link to articles about you",
                              initialValue: '',
                              onSavedText: (input) =>
                                  _notableArticleLink1 = input,
                              onValidateText: (_) {},
                            ),
                            ContentField(
                              labelText: 'Notable article 2',
                              hintText: "link to articles about you",
                              initialValue: '',
                              onSavedText: (input) =>
                                  _notableArticleLink2 = input,
                              onValidateText: (_) {},
                            ),
                            FadeAnimation(
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
                                          primary: Colors.blue,
                                          elevation: 20.0,
                                          onPrimary: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
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
                                        onPressed: _submit),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
