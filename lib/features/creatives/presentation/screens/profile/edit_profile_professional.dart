import 'package:bars/utilities/exports.dart';
import 'package:bars/utilities/image_handler.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';

class EditProfileProfessional extends StatefulWidget {
  final UserStoreModel user;

  EditProfileProfessional({
    required this.user,
  });

  @override
  _EditProfileProfessionalState createState() =>
      _EditProfileProfessionalState();
}

class _EditProfileProfessionalState extends State<EditProfileProfessional> {
  final _formKey = GlobalKey<FormState>();
  final _portfolioFormKey = GlobalKey<FormState>();
  final _priceFormKey = GlobalKey<FormState>();
  final _collaborationFormKey = GlobalKey<FormState>();
  final _collaboratedPeopleFormKey = GlobalKey<FormState>();
  final _rolekeyFormKey = GlobalKey<FormState>();
  final _contactsFormKey = GlobalKey<FormState>();
  final _companiesFormKey = GlobalKey<FormState>();
  Future<QuerySnapshot>? _users;
  String imageUrl = '';
  File? _imgeFile;
  bool _isLoading = false;
  bool _isLoadingImage = false;
  late PageController _pageController;
  final _nameController = TextEditingController();
  final _linkController = TextEditingController();
  final _typeController = TextEditingController();
  final _collaboratedPersonLinkController = TextEditingController();
  final _collaboratedPersonNameContrller = TextEditingController();
  final _tagNameController = TextEditingController();
  String _selectedNameToAdd = '';
  String _profileImage = '';

  // File? _storeImage;

  final FocusNode _nameSearchfocusNode = FocusNode();
  final _roleController = TextEditingController();
  final _priceDuratioController = TextEditingController();

  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onAskTextChanged);
    _linkController.addListener(_onAskTextChanged);
    _typeController.addListener(_onAskTextChanged);
    _tagNameController.addListener(_onAskTextChanged);
    _collaboratedPersonNameContrller.addListener(_onAskTextChanged);
    _collaboratedPersonLinkController.addListener(_onAskTextChanged);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      clear();

      _addLists();
    });
  }

  _addLists() {
    var _provider = Provider.of<UserData>(context, listen: false);
    processCurrency(_provider);

    _provider.setNoBooking(widget.user.noBooking);
    _provider.setOverview(widget.user.overview);
    _provider.setTermsAndConditions(widget.user.terms);
    _provider.setCurrency(widget.user.currency);

    // Add user awards
    List<PortfolioModel> awards = widget.user.awards;
    awards.forEach((award) => _provider.setAwards(award));

    // // Add user companies
    List<AppointmentSlotModel> appointments = widget.user.appointmentSlots;
    appointments
        .forEach((appointment) => _provider.setAppointmentSlots(appointment));

    Map<String, DateTimeRange> openingHours = widget.user.openingHours;
    _provider.setOpeningHours(openingHours);

    // Add user contact
    List<PortfolioContactModel> contacts = widget.user.contacts;
    contacts.forEach((contact) => _provider.setBookingContacts(contact));

    // Add links to work
    List<PortfolioModel> links = widget.user.links;
    links.forEach((link) => _provider.setLinksToWork(link));

    // // Add performance
    List<PortfolioModel> services = widget.user.services;
    services.forEach((services) => _provider.setServices(services));

    // Add skills
    // List<PortfolioModel> skills = widget.user.skills;
    // skills.forEach((skill) => _provider.setSkills(skill));

    // Add genre tags
    // List<PortfolioModel> genreTags = widget.user.genreTags;
    // genreTags.forEach((genre) => _provider.setGenereTags(genre));

    // Add collaborations
    // List<PortfolioCollaborationModel> collaborations =
    //     widget.user.collaborations;
    // collaborations
    //     .forEach((collaboration) => _provider.setCollaborations(collaboration));

    // Add price
    // List<PriceModel> priceTags = widget.user.priceTags;
    // priceTags.forEach((priceTags) => _provider.setPriceRate(priceTags));

    // Add professional image urls
    List<String> imageUrls = widget.user.professionalImageUrls;
    _provider.setProfessionalImages(imageUrls);
  }

  void processCurrency(UserData provider) {
    // Check if widget.userPortfolio.currency is null or empty
    if (widget.user.currency == null || widget.user.currency.trim().isEmpty) {
      // Handle the case where currency is null or empty
      provider.setCurrency('');
      return;
    }

    // Proceed with normal processing if currency is not null or empty
    final List<String> currencyPartition =
        widget.user.currency.trim().replaceAll('\n', ' ').split("|");

    String _currency = currencyPartition.length > 1 ? currencyPartition[1] : '';

    // Check if _currency has at least 3 characters before accessing _currency[2]
    if (_currency.length >= 2) {
      provider.setCurrency(_currency);
      // print(_currency);
    } else {
      // Handle the case where _currency does not have enough characters
      provider.setCurrency('');
    }
  }

  clear() {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.awards.clear();
    // _provider.company.clear();
    _provider.bookingContacts.clear();
    _provider.linksToWork.clear();
    _provider.services.clear();
    _provider.skills.clear();
    _provider.genreTages.clear();
    _provider.collaborations.clear();
    _provider.professionalImages.clear();
    _provider.priceRate.clear();
    _provider.appointmentSlots.clear();
    _provider.openingHours.clear();
    _provider.setProfessionalImageFile1(null);
    _provider.setProfessionalImageFile2(null);
    _provider.setProfessionalImageFile3(null);
    _provider.setTermsAndConditions('');
    _provider.setOverview('');
    _provider.setCurrency('');
  }

  void _onAskTextChanged() {
    if (_nameController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _linkController.dispose();
    _typeController.dispose();
    _nameSearchfocusNode.dispose();
    _roleController.dispose();
    _priceDuratioController.dispose();
  }

  //Method to create ticket
  void _add(String from) {
    var _provider = Provider.of<UserData>(context, listen: false);
    if (_portfolioFormKey.currentState!.validate()) {
      final portfolio = PortfolioModel(
        id: UniqueKey().toString(),
        name: _nameController.text,
        link: _linkController.text,
      );

      // adds ticket to ticket list
      // from.startsWith('Performance')
      //     ? _provider.setPerformances(portfolio)
      //     :
      from.startsWith('Award')
          ? _provider.setAwards(portfolio)
          : from.startsWith('Skills')
              ? _provider.setSkills(portfolio)
              : from.startsWith('Links')
                  ? _provider.setLinksToWork(portfolio)
                  : from.startsWith('Services')
                      ? _provider.setServices(portfolio)
                      : _provider.setServices(portfolio);
      _nameController.clear();
      _linkController.clear();
    }
  }

  //Method to create ticket
  void _addContact(bool isEmail
      // String from,
      ) {
    var _provider = Provider.of<UserData>(context, listen: false);
    if (_contactsFormKey.currentState!.validate()) {
      final portfolio = PortfolioContactModel(
          id: UniqueKey().toString(),
          email: isEmail ? _nameController.text : '',
          number: _linkController.text
          // number: !isEmail ? int.parse(_linkController.text) : 0,
          );

      // adds ticket to ticket list
      _provider.setBookingContacts(portfolio);

      // Reset ticket variables

      _nameController.clear();
      _linkController.clear();
    }
  }

  //Method to create ticket
  void _addPriceList() {
    var _provider = Provider.of<UserData>(context, listen: false);
    if (_priceFormKey.currentState!.validate()) {
      final portfolio = PriceModel(
        id: UniqueKey().toString(),
        name: _nameController.text,
        price: _typeController.text,
        value: _roleController.text,
        duruation: _priceDuratioController.text,
      );

      // adds ticket to ticket list
      _provider.setPriceRate(portfolio);

      // Reset ticket variables

      _nameController.clear();
      _typeController.clear();
      _roleController.clear();
      _priceDuratioController.clear();
    }
  }

  //Method to create ticket
  void _addCompany() {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (_companiesFormKey.currentState!.validate()) {
      // final portfolio = PortfolioCompanyModel(
      //   id: UniqueKey().toString(),
      //   link: _linkController.text,
      //   name: _nameController.text,
      //   type: _typeController.text,
      //   verified: false,
      // );
      // adds ticket to ticket list
      // _provider.setCompanies(portfolio);

      // Reset ticket variables

      _nameController.clear();
      _linkController.clear();
      _typeController.clear();
    }
  }

  //Method to create ticket
  void _addCollaboration() {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (_collaborationFormKey.currentState!.validate()) {
      final portfolio = PortfolioCollaborationModel(
        id: UniqueKey().toString(),
        link: _linkController.text,
        name: _nameController.text,
        people: List.from(_provider.collaboratedPeople),
      );

      // adds ticket to ticket list
      _provider.setCollaborations(portfolio);

      // Reset ticket variables
      Navigator.pop(context);
      _nameController.clear();
      _linkController.clear();
      _provider.collaboratedPeople.clear();
    }
  }

  //Method to create ticket
  void _addCollaboratedPeople() {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (_collaboratedPeopleFormKey.currentState!.validate()) {
      final portfolio = CollaboratedPeople(
        id: UniqueKey().toString(),
        name: _collaboratedPersonNameContrller.text.trim().isEmpty
            ? _selectedNameToAdd
            : _collaboratedPersonNameContrller.text.trim(),
        externalProfileLink: _collaboratedPersonLinkController.text.trim(),
        internalProfileLink: _provider.Salon,
        role: _roleController.text,
        profileImageUrl: _profileImage,
      );

      // adds ticket to ticket list
      _provider.setCollaboratedPeople(portfolio);

      // _provider.setSalon('');
      _selectedNameToAdd = '';
      _profileImage = '';
      _roleController.clear();
      // _taggedUserExternalLink = '';

      _users = null;
      _collaboratedPersonNameContrller.clear();
      _collaboratedPersonLinkController.clear();

      Navigator.pop(context);
      Navigator.pop(context);
    }
    // Reset ticket variables
  }

  animateToPage() {
    _pageController.animateToPage(
      Provider.of<UserData>(context, listen: false).int1 + 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateBack() {
    _pageController.animateToPage(
      Provider.of<UserData>(context, listen: false).int1 - 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _submit() async {
    if (_formKey.currentState!.validate() & !_isLoading) {
      // final accountUserStoreBox = Hive.box<UserStoreModel>('accountUserStore');

      _formKey.currentState!.save();
      var _provider = Provider.of<UserData>(context, listen: false);

      setState(() {
        _isLoading = true;
      });

      // Retry helper function
      Future<T> retry<T>(Future<T> Function() function,
          {int retries = 3}) async {
        for (int i = 0; i < retries; i++) {
          try {
            return await function();
          } catch (e) {}
        }
        throw Exception('Failed after $retries attempts');
      }

      // try {
      List<Future<String>> imageUploadFutures = [];

      if (_provider.professionalImageFile1 != null) {
        imageUploadFutures
            .add(retry(() => StorageService.uploadUserprofessionalPicture1(
                  '',
                  _provider.professionalImageFile1!,
                )));
      }

      if (_provider.professionalImageFile2 != null) {
        imageUploadFutures
            .add(retry(() => StorageService.uploadUserprofessionalPicture2(
                  '',
                  _provider.professionalImageFile2!,
                )));
      }

      if (_provider.professionalImageFile3 != null) {
        imageUploadFutures
            .add(retry(() => StorageService.uploadUserprofessionalPicture3(
                  '',
                  _provider.professionalImageFile3!,
                )));
      }

      // Wait for all image uploads to complete
      List<String> professionalImageUrls =
          await Future.wait(imageUploadFutures);

      // Add existing image urls
      if (_provider.professionalImageFile1 == null &&
          _provider.professionalImages.length > 0) {
        professionalImageUrls.add(_provider.professionalImages[0]);
      }
      if (_provider.professionalImageFile2 == null &&
          _provider.professionalImages.length > 1) {
        professionalImageUrls.add(_provider.professionalImages[1]);
      }
      if (_provider.professionalImageFile3 == null &&
          _provider.professionalImages.length > 2) {
        professionalImageUrls.add(_provider.professionalImages[2]);
      }

      _provider.setProfessionalImages(professionalImageUrls);

      UserStoreModel _userStore = UserStoreModel(
        userId: widget.user.userId,
        shopName: _provider.name,
        shopLogomageUrl: '',
        shopType: _provider.shopType,
        verified: widget.user.verified,
        terms: _provider.termAndConditions,
        city: _provider.city,
        country: _provider.country,
        overview: _provider.overview,
        accountType: _provider.accountType,
        noBooking: _provider.noBooking,
        awards: _provider.awards,
        contacts: _provider.bookingContacts,
        links: _provider.linksToWork,
        // priceTags: _provider.priceRate,
        services: _provider.services,
        professionalImageUrls: _provider.professionalImages,
        dynamicLink: widget.user.dynamicLink,
        randomId: widget.user.randomId,
        currency: _provider.currency,
        transferRecepientId: widget.user.transferRecepientId,
        maxCapacity: widget.user.maxCapacity ?? 0,
        amenities: widget.user.amenities,
        averageRating: widget.user.averageRating ?? 0,
        openingHours: _provider.openingHours,
        appointmentSlots: _provider.appointmentSlots,
        address: _provider.address,
      );

      try {
        await retry(() => userProfessionalRef.doc(widget.user.userId).update({
              'awards':
                  _provider.awards.map((awards) => awards.toJson()).toList(),
              'contacts': _provider.bookingContacts
                  .map((bookingContacts) => bookingContacts.toJson())
                  .toList(),
              'links': _provider.linksToWork
                  .map((linksToWork) => linksToWork.toJson())
                  .toList(),
              'noBooking': false,
              'overview': _provider.overview,
              'services': _provider.services
                  .map((services) => services.toJson())
                  .toList(),
              'appointmentSlots': _provider.appointmentSlots
                  .map((appointmentSlots) => appointmentSlots.toJson())
                  .toList(),
              'openingHours': _provider.openingHours.map((key, value) {
                return MapEntry(key, {
                  'start': value.start.toIso8601String(),
                  'end': value.end.toIso8601String(),
                });
              }),
              'professionalImageUrls': _provider.professionalImages,
              'terms': _provider.termAndConditions,
              'currency': _provider.currency,
            }));

        // await HiveUtils.updateUserLocation(
        //   context,
        //   _provider.userStore!.city,
        //   _provider.userStore!.country,
        //   _provider.userStore!.shopType,
        // );

        // _provider.setUserStore(_userStore);

        DocumentSnapshot doc =
            await userProfessionalRef.doc(widget.user.userId).get();

        // Assuming 'Event' is a class that can be constructed from a Firestore document
        UserStoreModel updatedUser = UserStoreModel.fromDoc(doc);
        _provider.setUserStore(updatedUser);

        // accountUserStoreBox.put(_userStore.userId, _userStore);
        Navigator.pop(context);
        // Navigator.pop(context);
        // _navigateToPage(
        //   context,
        //   DiscographyWidget(
        //     currentUserId: widget.user.userId,
        //     userIndex: 0,
        //     userPortfolio: updatedUser,
        //   ),
        // );
        mySnackBar(context, 'Saved successfully.');
      } catch (e) {
        _showBottomSheetErrorMessage('', e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _validateTextToxicity() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setIsLoading(true);

    TextModerator moderator = TextModerator();

    // Define the texts to be checked
    List<String> textsToCheck = [
      _provider.overview,
      _provider.termAndConditions
    ];

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
              'Your overview, or terms and conditions contains inappropriate statements. Please review');
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

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage!;
  }

  _handleImage(String from) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;
    setState(() {
      _isLoadingImage = true;
    });
    bool isHarmful = await HarmfulContentChecker.checkForHarmfulContent(
        context, file as File);

    if (isHarmful) {
      mySnackBarModeration(context,
          'Harmful content detected. Please choose a different image. Please review');
      setState(() {
        _isLoadingImage = false;
      });
    } else {
      if (mounted) {
        setState(() {
          _isLoadingImage = false;
          from.startsWith('one')
              ? _provider.setProfessionalImageFile1(file)
              : from.startsWith('two')
                  ? _provider.setProfessionalImageFile2(file)
                  : _provider.setProfessionalImageFile3(file);
        });
      }
    }

    // if (file != null) {
    // if (mounted) {
    //   setState(() {
    //     from.startsWith('one')
    //         ? _provider.setProfessionalImageFile1(file as File)
    //         : from.startsWith('two')
    //             ? _provider.setProfessionalImageFile2(file as File)
    //             : _provider.setProfessionalImageFile3(file as File);
    //   });
    // }
    // }
  }

  _displayPostImage(
    String from,
  ) {
    var _provider = Provider.of<UserData>(
      context,
    );
    // final width = MediaQuery.of(context).size.width;

    if (from.startsWith('one')) {
      if (_provider.professionalImages.isNotEmpty) {
        imageUrl = _provider.professionalImages[0];
        _imgeFile = _provider.professionalImageFile1;
      } else {
        _imgeFile = _provider.professionalImageFile1;
      }
    } else if (from.startsWith('two')) {
      if (_provider.professionalImages.length > 1) {
        imageUrl = _provider.professionalImages[1];
        _imgeFile = _provider.professionalImageFile2;
      } else {
        _imgeFile = _provider.professionalImageFile2;
      }
    } else {
      if (_provider.professionalImages.length > 2) {
        imageUrl = _provider.professionalImages[2];
        _imgeFile = _provider.professionalImageFile3;
      } else {
        _imgeFile = _provider.professionalImageFile3;
      }
    }

    if (_imgeFile == null) {
      if (imageUrl.isEmpty) {
        return Container(
          height: ResponsiveHelper.responsiveWidth(
            context,
            100,
          ),
          width: ResponsiveHelper.responsiveWidth(
            context,
            100,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            MdiIcons.image,
            color: Theme.of(context).primaryColor,
            size: ResponsiveHelper.responsiveWidth(
              context,
              50,
            ),
          ),
        );
      } else {
        return Container(
          height: ResponsiveHelper.responsiveWidth(
            context,
            100,
          ),
          width: ResponsiveHelper.responsiveWidth(
            context,
            100,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(imageUrl, errorListener: (_) {
                return;
              }),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    } else {
      return Container(
        height: ResponsiveHelper.responsiveHeight(
          context,
          100,
        ),
        width: ResponsiveHelper.responsiveHeight(
          context,
          100,
        ),
        child: Image(
          image: FileImage(_imgeFile!),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  String? validateWebsiteUrl(String? value) {
    final pattern =
        r'^(https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(:[0-9]{1,5})?(\/.*)?$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'URL cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid URL';
    } else {
      return null;
    }
  }

  _textField(
    String labelText,
    String hintText,
    bool autofocus,
    final TextEditingController controller,
    Function(String) onChanged,
    // bool isNumber,
    bool isLink,
  ) {
    return TextFormField(
        controller: controller,
        style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.normal),
        keyboardType: TextInputType.text,
        maxLines: null,
        autofocus: autofocus,
        keyboardAppearance: MediaQuery.of(context).platformBrightness,
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged,
        validator: isLink
            ? validateWebsiteUrl
            // (value) {
            //     String pattern =
            //         r'^(https?:\/\/)?([a-zA-Z0-9.-]+)(:[0-9]{1,5})?(\/.*)?$';
            //     // r'^(https?:\/\/)?(([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?)$';
            //     RegExp regex = new RegExp(pattern);
            //     if (!regex.hasMatch(value!))
            //       return 'Enter a valid URL';
            //     else
            //       return null;
            //   }
            : (input) =>
                input!.trim().length < 1 ? 'This field cannot be empty' : null,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 3.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              color: Colors.grey),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.grey)),
        ));
  }

  String? validatePhoneNumber(String? value) {
    final String pattern =
        r'^\+?(\d{1,3})?[- .]?\(?\d{1,4}\)?[- .]?\d{1,4}[- .]?\d{1,9}(\s?(ext|x)\s?\d{1,5})?$';
    final RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid phone number';
    } else {
      return null;
    }
  }

  _textFieldContact(
    String labelText,
    String hintText,
    bool autofocus,
    final TextEditingController controller,
    Function(String) onChanged,
    bool isEmail,
    // bool isLink,
  ) {
    return TextFormField(
        controller: controller,
        style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.normal),
        keyboardType: isEmail
            ? TextInputType.text
            : TextInputType.numberWithOptions(decimal: true),
        maxLines: null,
        autofocus: autofocus,
        keyboardAppearance: MediaQuery.of(context).platformBrightness,
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged,
        validator: isEmail
            ? (email) => email != null && !EmailValidator.validate(email.trim())
                ? 'Please enter a valid email'
                : null
            : validatePhoneNumber,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 3.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              color: Colors.grey),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.grey)),
        ));
  }

  void _showBottomTaggedPeopleRole(
      String nameLabel, String nameHint, List<PortfolioModel> portfolios) {
    var _size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AnimatedBuilder(
              animation: Listenable.merge([_nameController, _linkController]),
              builder: (BuildContext context, Widget? child) {
                return Form(
                  key: _portfolioFormKey,
                  child: Container(
                    height: _size.height.toDouble() / 1.2,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          portfolios.length < 6 &&
                                  _nameController.text.length > 0 &&
                                  nameLabel == 'Skills'
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: MiniCircularProgressButton(
                                    onPressed: () {
                                      portfolios.length > 5
                                          ? _showBottomSheetErrorMessage(
                                              nameLabel.toLowerCase(), '')
                                          : _add(nameLabel);
                                    },
                                    text: "Add",
                                    color: Colors.blue,
                                  ),
                                )
                              : portfolios.length < 6 &&
                                      _nameController.text.length > 0 &&
                                      _linkController.text.length > 0
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: MiniCircularProgressButton(
                                        onPressed: () {
                                          portfolios.length > 5
                                              ? _showBottomSheetErrorMessage(
                                                  nameLabel.toLowerCase(), '')
                                              : _add(nameLabel);
                                        },
                                        text: "Add",
                                        color: Colors.blue,
                                      ),
                                    )
                                  : ListTile(
                                      leading: portfolios.length > 0
                                          ? SizedBox.shrink()
                                          : IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                            ),
                                      trailing: portfolios.length < 1
                                          ? SizedBox.shrink()
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Done',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                    ),
                          if (portfolios.length > 5 &&
                              _nameController.text.length > 0 &&
                              _linkController.text.length > 0)
                            Text(
                              'You cannot add more than six ${nameLabel.toLowerCase()}',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          const SizedBox(
                            height: 40,
                          ),
                          _textField(
                            nameLabel,
                            nameHint,
                            true,
                            _nameController,
                            (value) {
                              setState(() {});
                            },
                            // false,
                            false,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (nameLabel != 'Skills')
                            _textField(
                              'link to $nameLabel',
                              'link to $nameLabel',
                              false,
                              _linkController,
                              (value) {
                                setState(() {});
                              },
                              // false,
                              true,
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            nameLabel.startsWith('Performance')
                                ? 'Link to ${nameLabel.toLowerCase()} fields cannot be empty. These links are necessary to provide people with a deeper understanding of your abilities. Each link should direct to a video of the respective ${nameLabel.toLowerCase()}, providing additional context and clarification.'
                                : nameLabel.startsWith('Awards')
                                    ? 'You are required to add the award with its year and category you have won in the Award text field, e.g., Excellence Award 2023, Best Talent. \n\nLinks to ${nameLabel.toLowerCase()} fields cannot be empty. These links are necessary to provide people with a deeper understanding of your abilities. Each link should direct to a video or article of you receiving the award, providing additional context and clarification.'
                                    : 'Link to ${nameLabel.toLowerCase()} fields cannot be empty. These links are necessary to provide people with a deeper understanding of your abilities. Each link should direct to a definition or explanation of the respective ${nameLabel.toLowerCase()}, providing additional context and clarification.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
      },
    );
  }

  // void _showBottomCompany(List<PortfolioCompanyModel> portfolios) {
  //   var _size = MediaQuery.of(context).size;
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return AnimatedBuilder(
  //             animation: Listenable.merge([_nameController, _linkController]),
  //             builder: (BuildContext context, Widget? child) {
  //               return Form(
  //                 key: _companiesFormKey,
  //                 child: Container(
  //                   height: _size.height.toDouble() / 1.3,
  //                   decoration: BoxDecoration(
  //                       color: Theme.of(context).primaryColorLight,
  //                       borderRadius: BorderRadius.circular(30)),
  //                   child: Scaffold(
  //                     backgroundColor: Colors.transparent,
  //                     body: Padding(
  //                       padding: const EdgeInsets.all(20.0),
  //                       child: ListView(
  //                         children: [
  //                           portfolios.length < 6 &&
  //                                   _nameController.text.length > 0 &&
  //                                   _linkController.text.length > 0
  //                               ? Align(
  //                                   alignment: Alignment.centerRight,
  //                                   child: MiniCircularProgressButton(
  //                                     onPressed: () {
  //                                       _addCompany();
  //                                     },
  //                                     text: "Add",
  //                                     color: Colors.blue,
  //                                   ),
  //                                 )
  //                               : ListTile(
  //                                   leading: portfolios.length > 0
  //                                       ? SizedBox.shrink()
  //                                       : IconButton(
  //                                           icon: const Icon(Icons.close),
  //                                           onPressed: () {
  //                                             Navigator.pop(context);
  //                                           },
  //                                           color: Theme.of(context)
  //                                               .secondaryHeaderColor,
  //                                         ),
  //                                   trailing: portfolios.length < 1
  //                                       ? SizedBox.shrink()
  //                                       : GestureDetector(
  //                                           onTap: () {
  //                                             Navigator.pop(context);
  //                                           },
  //                                           child: Text(
  //                                             'Done',
  //                                             style: TextStyle(
  //                                                 fontSize: ResponsiveHelper
  //                                                     .responsiveFontSize(
  //                                                         context, 14.0),
  //                                                 color: Colors.blue,
  //                                                 fontWeight: FontWeight.bold),
  //                                           ),
  //                                         ),
  //                                 ),
  //                           const SizedBox(
  //                             height: 30,
  //                           ),
  //                           if (portfolios.length > 5 &&
  //                               _nameController.text.length > 0 &&
  //                               _linkController.text.length > 0)
  //                             Padding(
  //                               padding: const EdgeInsets.only(bottom: 30.0),
  //                               child: Text(
  //                                 'You cannot add more than six contacts',
  //                                 style: TextStyle(
  //                                     fontSize:
  //                                         ResponsiveHelper.responsiveFontSize(
  //                                             context, 14.0),
  //                                     color: Colors.red,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           _textField(
  //                             'company',
  //                             'Company / organization name',
  //                             true,
  //                             _nameController,
  //                             (value) {
  //                               setState(() {});
  //                             },
  //                             // false,
  //                             false,
  //                           ),
  //                           const SizedBox(
  //                             height: 20,
  //                           ),
  //                           _textField(
  //                             'Type',
  //                             'Eg. record label, NGO, management',
  //                             true,
  //                             _typeController,
  //                             (value) {
  //                               setState(() {});
  //                             },
  //                             // false,
  //                             false,
  //                           ),
  //                           const SizedBox(
  //                             height: 20,
  //                           ),
  //                           _textField(
  //                             'link to company',
  //                             'website or socal media of company',
  //                             false,
  //                             _linkController,
  //                             (value) {
  //                               setState(() {});
  //                             },
  //                             // false,
  //                             true,
  //                           ),
  //                           const SizedBox(
  //                             height: 20,
  //                           ),
  //                           Text(
  //                             'The link fields for the company and type must not be left empty. These links are essential for individuals to gain a comprehensive understanding of the companies you are associated with. Each link should direct to a website or webpage that provides detailed information about the respective company',
  //                             style: Theme.of(context).textTheme.bodyMedium,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             });
  //       });
  //     },
  //   );
  // }

// The _showBottomContact method is responsible for displaying a modal bottom sheet with a form for contact-related input.
// It accepts a boolean isEmail to determine whether it should display an email input field or a phone number input field,
// and a list of PortfolioContactModel objects, presumably to display existing
// Refactor method
  void _showBottomContact(
      bool isEmail, List<PortfolioContactModel> portfolios) {
    TextEditingController controller =
        isEmail ? _nameController : _linkController;
    String nameLabel = isEmail ? 'email' : 'phone number';
    String nameHint = isEmail ? 'example@mail.com' : '123 456 7890';
    var _size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AnimatedBuilder(
                animation: controller, // Use the controller as the Listenable
                builder: (BuildContext context, Widget? child) {
                  return Form(
                    key: _contactsFormKey,
                    child: Container(
                      height: _size.height.toDouble() / sheetHeightFraction,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(30)),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView(
                            children: [
                              portfolios.length < 6 &&
                                      controller.text.length > 0
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: MiniCircularProgressButton(
                                        onPressed: () {
                                          _addContact(isEmail);
                                        },
                                        text: "Add",
                                        color: Colors.blue,
                                      ),
                                    )
                                  : _buildActionButtonsContacts(portfolios),
                              if (portfolios.length > 5 &&
                                  controller.text.length > 0)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: Text(
                                    'You cannot add more than six ',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              _textFieldContact(
                                nameLabel,
                                nameHint,
                                true,
                                controller,
                                (value) {
                                  setState(() {});
                                },
                                // !isEmail,
                                isEmail,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          });
        });
  }

  _buildActionButtonsContacts(List<PortfolioContactModel> portfolios) {
    return ListTile(
      leading: portfolios.length > 0
          ? SizedBox.shrink()
          : IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Theme.of(context).secondaryHeaderColor,
            ),
      trailing: portfolios.length < 1
          ? SizedBox.shrink()
          : GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Done',
                style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  _contactTypeWidget(IconData icon, String type) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(
          width: 20,
        ),
        Text(
          type,
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ],
    );
  }

  void _showBottomSheetContactType(
    List<PortfolioContactModel> contacts,
  ) {
    final width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: 230,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
                child: MyBottomModelSheetAction(actions: [
                  const SizedBox(
                    height: 40,
                  ),
                  BottomModalSheetButton(
                      onPressed: () async {
                        await Future.delayed(Duration(milliseconds: 300));
                        Navigator.pop(context);
                        _showBottomContact(true, contacts);
                      },
                      width: width.toDouble(),
                      child: _contactTypeWidget(Icons.email_outlined, "Email")),
                  BottomModalSheetButton(
                    onPressed: () async {
                      await Future.delayed(Duration(milliseconds: 300));
                      Navigator.pop(context);
                      _showBottomContact(false, contacts);
                    },
                    width: width.toDouble(),
                    child: _contactTypeWidget(Icons.phone, "Number"),
                  ),
                ])));
      },
    );
  }

  // The _showBottomPrice method is responsible for displaying
  // a modal bottom sheet that contains a form for price-related input
  double sheetHeightFraction = 1.3;
  double paddingSize = 20;

  _priceTextField(
    String labelText,
    String hintText,
    final TextEditingController controller,
    Function(String) onChanged,
  ) {
    return TextFormField(
        controller: controller,
        style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.normal),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        maxLines: null,
        autofocus: true,
        keyboardAppearance: MediaQuery.of(context).platformBrightness,
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged,
        validator: (value) {
          String pattern = r'^\d+(\.\d{1,2})?$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value!))
            return 'Enter a valid price';
          else
            return null;
        },
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 3.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              color: Colors.grey),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.grey)),
        ));
  }

// Refactor method
  void _showBottomPrice(List<PriceModel> price) {
    var _size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return ValueListenableBuilder(
                valueListenable: _isTypingNotifier,
                builder: (BuildContext context, bool isTyping, Widget? child) {
                  return Form(
                    key: _priceFormKey,
                    child: Container(
                      height: _size.height.toDouble() / sheetHeightFraction,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(30)),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Padding(
                          padding: EdgeInsets.all(paddingSize),
                          child: ListView(children: [
                            price.length < 6 &&
                                    _nameController.text.length > 0 &&
                                    _typeController.text.length > 0 &&
                                    _roleController.text.length > 0 &&
                                    _priceDuratioController.text.length > 0
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: MiniCircularProgressButton(
                                      onPressed: () {
                                        _addPriceList();
                                      },
                                      text: "Add",
                                      color: Colors.blue,
                                    ),
                                  )
                                : ListTile(
                                    leading: _nameController.text.length > 0 &&
                                            _typeController.text.length > 0 &&
                                            _roleController.text.length > 0
                                        ? SizedBox.shrink()
                                        : IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ),
                                    trailing: price.length < 1
                                        ? SizedBox.shrink()
                                        : GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Done',
                                              style: TextStyle(
                                                  fontSize: ResponsiveHelper
                                                      .responsiveFontSize(
                                                          context, 14.0),
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                  ),
                            const SizedBox(height: 40),
                            if (price.length > 5 &&
                                _typeController.text.length > 0 &&
                                _priceDuratioController.text.length > 0 &&
                                _roleController.text.length > 0)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: Text(
                                  'You cannot add more than six price packages',
                                  style: TextStyle(
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 14.0),
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            _priceTextField(
                              'Price',
                              '0.00',
                              _typeController,
                              (value) {
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 20),
                            _textField(
                              'Package name',
                              'eg. Performance, Collaboration, exhibition',
                              true,
                              _nameController,
                              (value) {
                                setState(() {});
                              },
                              false,
                            ),
                            const SizedBox(height: 20),
                            _textField(
                              'Value',
                              'eg. An hour performance, 30 minutes appearance',
                              true,
                              _roleController,
                              (value) {
                                setState(() {});
                              },
                              false,
                            ),
                            const SizedBox(height: 20),
                            _textField(
                              'Duration',
                              '30 minutes, 1 hour, 2 hours',
                              true,
                              _priceDuratioController,
                              (value) {
                                setState(() {});
                              },
                              false,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'It is important for people to have comprehensive knowledge of your package options, including pricing and the corresponding value you offer. So they know what to bargain for before contacting you.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ]),
                        ),
                      ),
                    ),
                  );
                });
          });
        });
  }

  _buildUserTile(AccountHolderAuthor user) {
    var _provider = Provider.of<UserData>(context, listen: false);
    return SearchUserTile(
        verified: user.verified!,
        userName: user.userName!.toUpperCase(),
        shopType: user.shopType!,
        // company: user.company!,
        profileImageUrl: user.profileImageUrl!,
        bio: '',
        onPressed: () {
          _provider.setSalon(user.userId!);

          if (mounted) {
            setState(() {
              _profileImage = user.profileImageUrl!;
              _selectedNameToAdd = user.userName!;
            });
          }

          _addCollaboratedPeople();
        });
  }

  _cancelSearchUser() {
    if (mounted) {
      setState(() {
        _users = null;
        _clearSearchUser();
      });
    }
  }

  _clearSearchUser() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _tagNameController.clear());
    _selectedNameToAdd = '';
    _tagNameController.clear();
  }

// The _showBottomTaggedPeople method is well-structured and clear in its purpose.
// It opens a modal bottom sheet that provides a form for user input and displays a list of tagged users.
//  It appears to search and show users based on the input and also allows for adding additional people with an external link.

// Refactor method
  void _showBottomTaggedPeople() {
    var _size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _collaboratedPeopleFormKey,
                child: Container(
                  height: MediaQuery.of(context).size.height.toDouble() / 1.1,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(30)),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: DoubleOptionTabview(
                        height: _size.height,
                        onPressed: (int) {},
                        tabText1: 'From Bars Impression',
                        tabText2: 'From external link',
                        initalTab: 0,
                        widget1: ListView(
                          children: [
                            Text(
                              _tagNameController.text,
                            ),
                            SearchContentField(
                                cancelSearch: _cancelSearchUser,
                                controller: _tagNameController,
                                focusNode: _nameSearchfocusNode,
                                hintText: 'Enter username..',
                                onClearText: () {
                                  _clearSearchUser();
                                },
                                onTap: () {},
                                onChanged: (input) {
                                  if (input.isNotEmpty) {
                                    setState(() {
                                      _users = DatabaseService.searchUsers(
                                          input.toUpperCase());
                                    });
                                  }
                                }),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'Tag the person so that other users can easily reach out to them if they are interested in their work.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 12.0),
                                ),
                              ),
                            ),
                            if (_users != null)
                              FutureBuilder<QuerySnapshot>(
                                  future: _users,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    }
                                    if (snapshot.data!.docs.length == 0) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: "No users found. ",
                                                      style: TextStyle(
                                                          fontSize: ResponsiveHelper
                                                              .responsiveFontSize(
                                                                  context,
                                                                  20.0),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.blueGrey)),
                                                  TextSpan(
                                                      text:
                                                          '\nCheck username and try again.'),
                                                ],
                                                style: TextStyle(
                                                    fontSize: ResponsiveHelper
                                                        .responsiveFontSize(
                                                            context, 14.0),
                                                    color: Colors.grey),
                                              )),
                                        ),
                                      );
                                    }
                                    return SingleChildScrollView(
                                      child: SizedBox(
                                        height: _size.width,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            SingleChildScrollView(
                                              child: SizedBox(
                                                height: _size.width - 20,
                                                child: ListView.builder(
                                                  itemCount: snapshot
                                                      .data!.docs.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    AccountHolderAuthor? user =
                                                        AccountHolderAuthor
                                                            .fromDoc(snapshot
                                                                .data!
                                                                .docs[index]);
                                                    return _buildUserTile(user);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                          ],
                        ),
                        widget2: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              _collaboratedPersonNameContrller.text
                                          .trim()
                                          .isEmpty ||
                                      _collaboratedPersonLinkController.text
                                          .trim()
                                          .isEmpty
                                  ? SizedBox.shrink()
                                  : Align(
                                      alignment: Alignment.centerRight,
                                      child: MiniCircularProgressButton(
                                        onPressed: () {
                                          _addCollaboratedPeople();
                                        },
                                        text: "Add",
                                        color: Colors.blue,
                                      ),
                                    ),
                              _textField(
                                'Name',
                                'Nam of person',
                                false,
                                _collaboratedPersonNameContrller,
                                (value) {
                                  setState(() {});
                                },
                                false,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _textField(
                                '_taggedUserExternalLink',
                                'External link to profile on social media or a blog',
                                false,
                                _collaboratedPersonLinkController,
                                (value) {
                                  setState(() {});
                                },
                                true,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  'Tag the person so that other users can easily reach out to them if they are interested in their work.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 12.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        lightColor: true,
                        pageTitle: '',
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

// The _showBottomSheetCollaboration method seems well-structured and clear in its purpose.
// It opens a modal bottom sheet that provides a form for user input.
// This form changes depending on the isRole boolean parameter.

  // Define constants for magic numbers
  // double sheetHeightFraction = 1.3;
  // double paddingSize = 20.0;

// Create a method for the SizedBox
  SizedBox _sizedBox() {
    return SizedBox(height: paddingSize);
  }

// Refactor method
  void _showBottomSheetCollaboration(bool isRole) {
    TextEditingController textInputController =
        isRole ? _roleController : _nameController;
    String formLabel = isRole ? 'Role' : 'Name of collaboration';
    String formHint = isRole
        ? 'Please provide the role of the person in this collaboration.'
        : 'Please provide the name of the collaboration or project.';

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return ValueListenableBuilder(
                valueListenable: _isTypingNotifier,
                builder: (BuildContext context, bool isTyping, Widget? child) {
                  return Form(
                    key: isRole ? _rolekeyFormKey : _collaborationFormKey,
                    child:
                        Consumer<UserData>(builder: (context, userData, child) {
                      return Container(
                        height: MediaQuery.of(context).size.height.toDouble() /
                            sheetHeightFraction,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.all(paddingSize),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildListTile(
                                  isRole,
                                  Provider.of<UserData>(context, listen: false)
                                      .collaboratedPeople),
                              _sizedBox(),
                              textInputController.text.length < 1 ||
                                      _linkController.text.length < 1
                                  ? SizedBox.shrink()
                                  : _addFeaturedPerson(isRole),
                              _sizedBox(),
                              _textField(
                                formLabel,
                                formHint,
                                true,
                                textInputController,
                                (value) {
                                  setState(() {});
                                },
                                // false,
                                false,
                              ),
                              _sizedBox(),
                              isRole
                                  ? SizedBox.shrink()
                                  : _textField(
                                      'link to $formLabel',
                                      'link to $formHint',
                                      false,
                                      _linkController,
                                      (value) {
                                        setState(() {});
                                      },
                                      true,
                                    ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                isRole
                                    ? 'Please specify the role of the person in the collaboration, such as producer, organizer, manager, or any other relevant role.'
                                    : 'Include a link to the collaboration to allow individuals to view the work.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                });
          });
        });
  }

  _addFeaturedPerson(bool isRole) {
    return Align(
      alignment: Alignment.centerRight,
      child: ShakeTransition(
        curve: Curves.easeOutBack,
        child: GestureDetector(
          onTap: () {
            !isRole
                ? _showBottomSheetCollaboration(true)
                : _showBottomTaggedPeople();
          },
          child: Text(
            isRole ? 'Continue' : 'Add featured person',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  ListTile _buildListTile(
      bool isRole, List<CollaboratedPeople> _collaboratedPeople) {
    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Theme.of(context).secondaryHeaderColor,
      ),
      trailing: _collaboratedPeople.length < 1 || isRole
          ? SizedBox.shrink()
          : GestureDetector(
              onTap: () {
                _addCollaboration();
              },
              child: Text(
                'Done',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

// _showBottomTaggedPeople
  setNull() {
    Provider.of<UserData>(context, listen: false).setInt1(0);
    Provider.of<UserData>(context, listen: false).setshopType('');
    Provider.of<UserData>(context, listen: false).setEmail('');
    Provider.of<UserData>(context, listen: false).setBool5(false);
    Provider.of<UserData>(context, listen: false).setBool6(false);
    Provider.of<UserData>(context, listen: false).addressSearchResults = [];
  }

  void _showBottomSheetMore(
    String from,
    List<PortfolioModel> portfolios,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);
    final double height = MediaQuery.of(context).size.height;
    Widget _widget;

    switch (from.split(' ')[0]) {
      case 'contacts':
        _widget = PortfolioContactWidget(
          portfolios: _provider.bookingContacts,
          edit: true,
        );
        break;
      case 'price':
        _widget = PriceRateWidget(
            edit: false, prices: _provider.priceRate, seeMore: true);
        break;
      // case 'companies':
      //   _widget = PortfolioCompanyWidget(
      //       seeMore: true, portfolios: _provider.company, edit: false);
      //   break;
      case 'portfolio':
        _widget =
            PortfolioWidget(portfolios: portfolios, seeMore: true, edit: false);
        break;
      default:
        _widget = PortfolioWidget(portfolios: [], seeMore: true, edit: false);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: height / 1.3,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: _widget,
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheetErrorMessage(String from, Object e) {
    String error = e.toString();
    String result = error.contains(']')
        ? error.substring(error.lastIndexOf(']') + 1)
        : error;
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
          title: error.isEmpty
              ? 'You cannot add more than six ${from.toLowerCase()}'
              : '\n$result.toString(),',
          subTitle: '',
        );
      },
    );
  }

  // Define these once at the class level

  _addPotfolio(
    String label,
    String hint,
    String from,
    List<PortfolioModel> portfolios,
    int length,
  ) {
    double width = MediaQuery.of(context).size.width;
    var _provider = Provider.of<UserData>(context);
    var _onPressed;
    var _widget;
    final _greyTextStyle = TextStyle(
      color: Colors.grey,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
    );

    final _blueBoldTextStyle = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
    );
    switch (from.split(' ')[0]) {
      case 'price':
        _onPressed = () => _showBottomPrice(_provider.priceRate);
        _widget = PriceRateWidget(
            edit: true, prices: _provider.priceRate, seeMore: true);
        break;
      // case 'collaborations':
      //   _onPressed = () => _showBottomSheetCollaboration(false);
      //   _widget = PortfolioCollaborationWidget(
      //       collaborations: _provider.collaborations,
      //       seeMore: false,
      //       edit: true);
      //   break;
      case 'contacts':
        _onPressed =
            () => _showBottomSheetContactType(_provider.bookingContacts);
        _widget = PortfolioContactWidget(
          portfolios: _provider.bookingContacts,
          edit: true,
        );
        break;
      // case 'Links':
      //   _onPressed = () =>
      //       _showBottomTaggedPeopleRole(label, label, _provider.linksToWork);
      //   _widget = PortfolioWidget(
      //       portfolios: _provider.linksToWork, seeMore: false, edit: true);
      //   break;
      // case 'companies':
      //   _onPressed = () => _showBottomCompany(_provider.company);
      //   _widget = PortfolioCompanyWidget(
      //       portfolios: _provider.company, seeMore: false, edit: true);
      //   break;
      case 'portfolio':
        _onPressed =
            () => _showBottomTaggedPeopleRole(label, label, portfolios);
        _widget =
            PortfolioWidget(portfolios: portfolios, seeMore: false, edit: true);
        break;
      default:
        _onPressed =
            () => _showBottomTaggedPeopleRole(label, label, _provider.services);
        _widget = PortfolioWidget(
            portfolios: _provider.services, seeMore: false, edit: true);
    }

    return Column(
      children: [
        PickOptionWidget(
          title: 'Add $label',
          onPressed: length > 5
              ? () {
                  _showBottomSheetErrorMessage(label.toLowerCase(), '');
                }
              : _onPressed,
          dropDown: false,
        ),
        const SizedBox(
          height: 10,
        ),
        _widget,
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Container(
              width: length < 4 ? width - 40 : width / 1.5,
              child: Text(
                hint,
                style: _greyTextStyle,
              ),
            ),
            length < 4
                ? SizedBox.shrink()
                : GestureDetector(
                    onTap: () {
                      _showBottomSheetMore(from, portfolios);
                    },
                    child: Text(
                      "See more.",
                      style: _blueBoldTextStyle,
                    ),
                  ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  void _showCurrencyPicker() {
    UserData _provider = Provider.of<UserData>(context, listen: false);

    showCurrencyPicker(
      theme: CurrencyPickerThemeData(
        backgroundColor: Theme.of(context).primaryColorLight,
        flagSize: 25,
        titleTextStyle: TextStyle(
          fontSize: ResponsiveHelper.responsiveFontSize(context, 17.0),
        ),
        subtitleTextStyle: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 15.0),
            color: Colors.blue),
        bottomSheetHeight: MediaQuery.of(context).size.height / 1.2,
      ),
      context: context,
      showFlag: true,
      showSearchField: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        // print(currency.code.toString());
        _provider.setCurrency('${currency.name} | ${currency.code}');
      },
      favorite: _provider.userLocationPreference!.country == 'Ghana'
          ? ['GHS']
          : ['USD'],
    );
  }

  var _divider = Divider(
    thickness: .2,
    color: Colors.grey,
  );

  _handleImageFromGallery() {
    ImageHandler.handleImageFromGallery(context, true
        // Submit the image file
        // _submitProfileImage(file);
        );
  }

  _profileImageWidget() {
    var _provider = Provider.of<UserData>(
      context,
    );
    var _provider2 = Provider.of<UserData>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _provider.isLoading || _provider.isLoading2
            ? SchimmerSkeleton(
                schimmerWidget: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  radius: ResponsiveHelper.responsiveHeight(context, 50.0),
                  backgroundImage: ImageHandler.displayProfileImage(
                    widget.user.shopLogomageUrl,
                    _provider.logoImage,
                  ),
                ),
              )
            : Hero(
                tag: 'container1' + widget.user.userId.toString(),
                child: GestureDetector(
                  onTap: _handleImageFromGallery,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    radius: ResponsiveHelper.responsiveHeight(context, 50.0),
                    backgroundImage: ImageHandler.displayProfileImage(
                      widget.user.shopLogomageUrl,
                      _provider.logoImage,
                    ),
                  ),
                ),
              ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.transparent,
            side: BorderSide(width: 1.0, color: Colors.transparent),
          ),
          onPressed: _handleImageFromGallery,
          child: Text(
            'Set shop logo',
            style: TextStyle(
              color: Colors.blue,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            ),
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        // Divider(
        //   thickness: .2,
        //   color: Colors.grey,
        // ),
        // Column(
        //   children: [
        //     // _changeUserNameField(),
        //     _stageNameAndBioFields(),
        //   ],
        // ),
        // _stageNameAndBioFields(),
      ],
    );
  }

  void _showBottomSheetEditOpeningHours() {
    var _provider = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(12),
              child: EditOpeningHours(
                openingHours: _provider.openingHours,
              )),
        );
      },
    );
  }

  List<ShopWorkerModel> dummyWorkers = [
    ShopWorkerModel(
      id: '1',
      name: 'Alice Johnson',
      role: ['Hair Stylist', 'Color Specialist'],
      services: ['Haircut', 'Hair Stylist', 'Hair Coloring', 'Blow Dry'],
      profileImageUrl: 'https://example.com/images/alice.jpg',
    ),
    ShopWorkerModel(
      id: '2',
      name: 'Bob Smith',
      role: ['Massage Therapist', 'Wellness Coach'],
      services: ['Swedish Massage', 'x', 'Deep Tissue Massage', 'Aromatherapy'],
      profileImageUrl: 'https://example.com/images/bob.jpg',
    ),
  ];

  void _showBottomSheetAddApointments() {
    var _provider = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(12),
              child: EditApointmentSlot(
                openingHours: _provider.openingHours,
                // services: ['Hair Stylist', 'Wellness Coach'],
                workers: dummyWorkers,
              )),
        );
      },
    );
  }

  _logoToOpeningSection() {
    var _provider = Provider.of<UserData>(
      context,
    );

    final UserSettingsLoadingPreferenceModel _userLocation =
        _provider.userLocationPreference!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(children: [
        _profileImageWidget(),
        const SizedBox(
          height: 30,
        ),
        _divider,
        IntroInfo(
          leadingIcon: Icons.person_outline,
          titleColor: Theme.of(context).secondaryHeaderColor,
          title: 'Account Type',
          onPressed: () {
            _navigateToPage(
              context,
              EditshopType(
                user: _provider.user!,
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
                user: _userLocation,
                accountType: widget.user.accountType!,
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
          title: 'Add Currency',
          onPressed: () {
            // Navigator.pop(context);
            _showCurrencyPicker();
          },
          subTitle: "",
          icon: Icons.arrow_forward_ios_outlined,
        ),
        _divider,
        const SizedBox(
          height: 30,
        ),
        EditProfileTextField(
          enableBorder: false,
          labelText: 'Overview',
          hintText: "  Highlight key points",
          initialValue: widget.user.overview,
          onValidateText: (input) =>
              input!.trim().length < 1 ? 'Not less than a word' : null,
          onSavedText: (input) => _provider.setOverview(input),
        ),
        Text(
          "Provide a broad perspective of your creativity, usually highlighting key points or essential information without going into specific details.",
          style: TextStyle(
            color: Colors.grey,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        PickOptionWidget(
          title: 'Change Opening hours',
          onPressed: () {
            _showBottomSheetEditOpeningHours();
          },
          dropDown: false,
        ),
        _provider.openingHours.isEmpty
            ? NoAppointmentWidget()
            : OpeninHoursWidget(
                openingHours: _provider.openingHours,
              ),
        const SizedBox(
          height: 30,
        ),
      ]),
    );
  }

  _appointmentServiceSection() {
    var _provider = Provider.of<UserData>(
      context,
    );

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PickOptionWidget(
          title: 'Add apoinment slots',
          onPressed: () {
            _showBottomSheetAddApointments();
          },
          dropDown: false,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TicketGroup(
          fromPrice: false,
          appointmentSlots: _provider.appointmentSlots,
          openingHours: widget.user.openingHours,
          edit: true,
          bookingShop: widget.user,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          "Provide a broad perspective of your creativity, usually highlighting key points or essential information without going into specific details.",
          style: TextStyle(
            color: Colors.grey,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
          ),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
    ]);
  }

  _imageSection() {
    var _provider = Provider.of<UserData>(
      context,
    );

    bool _imageFileNull = _provider.professionalImageFile1 != null &&
        _provider.professionalImageFile2 != null &&
        _provider.professionalImageFile3 != null;
    bool imageUrlIsEmpty = _provider.professionalImages.isEmpty;
    bool _portfolioIsEmpty =
        // _provider.skills.isEmpty ||
        _provider.linksToWork.isEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(children: [
        _addPotfolio(
            'Awards',
            'Please provide up to six of the most prestigious awards you have won in your creative field. These can include any notable accolades or recognitions you have received for your work.',
            'portfolio',
            _provider.awards,
            _provider.awards.length),

        // _addPotfolio(
        //     'Collaborations',
        //     'Please provide up to six examples of your best collaborations. These can include notable projects or partnerships where you have worked alongside other talented individuals or organizations.',
        //     'collaborations',
        //     [],
        //     _provider.collaborations.length),
        _addPotfolio(
            'Contacts',
            'Please provide up to four contacts for your management team. These contact details will allow individuals to reach out and book you for collaborations and business opportunities.',
            'contacts',
            [],
            _provider.bookingContacts.length),

        // const SizedBox(
        //   height: 30,
        // ),
        // _addPotfolio(
        //     'Prices',
        //     'Please provide your price list and rates for collaborations, exhibitions, and services. This will allow potential clients and collaborators to have a clear understanding of your pricing structure and make informed decisions when considering working with you.',
        //     'price',
        //     [],
        //     _provider.priceRate.length),
        _addPotfolio(
            'Links',
            'Showcase your work and allow others to see the visual representation of your Salonic creations. This will provide an opportunity for people to gain a better understanding of the quality and style of your work.',
            'portfolio',
            _provider.linksToWork,
            _provider.linksToWork.length),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _handleImage('one'),
              child: _displayPostImage(
                'one',
              ),
            ),
            GestureDetector(
              onTap: () => _handleImage('two'),
              child: _displayPostImage('two'),
            ),
            GestureDetector(
              onTap: () => _handleImage('three'),
              child: _displayPostImage('three'),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        _isLoadingImage
            ? LinearProgress()
            : Text(
                "Kindly include three professional images on the booking page. These images will provide other users with a clearer insight into the individual they will be engaging with.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                ),
              ),
        const SizedBox(
          height: 30,
        ),
        EditProfileTextField(
          enableBorder: false,
          labelText: 'Terms and conditions',
          hintText: " optional (terms and conditions)",
          initialValue: widget.user.terms,
          onValidateText: (input) => null,
          onSavedText: (input) => _provider.setTermsAndConditions(input),
        ),
        Text(
          '(Optional) To ensure transparency and clarify expectations, it is essential for users to include a section for \'Terms and Conditions\' on their booking page. This will outline the agreed-upon terms, conditions, and obligations that both parties must adhere to throughout the booking process.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
          ),
        ),
        const SizedBox(
          height: 70,
        ),
        _isLoading || _provider.isLoading
            ? CircularProgress(
                isMini: true,
                indicatorColor: Colors.blue,
              )
            :

            // !_portfolioIsEmpty
            //     ? imageUrlIsEmpty || _imageFileNull
            //         ?

            Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 40),
                  child: AlwaysWhiteButton(
                    buttonText: 'Save',
                    onPressed: () {
                      _submit();
                    },

                    // _validateTextToxicity,
                    //  _submit,
                    buttonColor: Colors.blue,
                  ),
                ),
              ),
        // : SizedBox.shrink()
        // : SizedBox.shrink(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );

    final UserSettingsLoadingPreferenceModel _userLocation =
        _provider.userLocationPreference!;

    bool _imageFileNull = _provider.professionalImageFile1 != null &&
        _provider.professionalImageFile2 != null &&
        _provider.professionalImageFile3 != null;
    bool imageUrlIsEmpty = _provider.professionalImages.isEmpty;
    bool _portfolioIsEmpty =
        // _provider.skills.isEmpty ||
        _provider.linksToWork.isEmpty;

    return EditProfileScaffold(
      title: '',
      widget: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _logoToOpeningSection(),
            _appointmentServiceSection(),
            _imageSection(),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
