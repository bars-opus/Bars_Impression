import 'package:bars/utilities/exports.dart';
import 'package:email_validator/email_validator.dart';

class EditProfileProfessional extends StatefulWidget {
  final AccountHolder user;

  EditProfileProfessional({
    required this.user,
  });

  @override
  _EditProfileProfessionalState createState() =>
      _EditProfileProfessionalState();
}

class _EditProfileProfessionalState extends State<EditProfileProfessional> {
  final _formKey = GlobalKey<FormState>();
  String _company = '';
  String _skills = '';
  String _performances = '';
  String _collaborations = '';
  String _awards = '';
  String _management = '';
  String _contacts = '';
  String _profileHandle = '';
  String _website = '';
  String _otherSites1 = '';
  String _otherSites2 = '';
  String _mail = '';
  File? _professionalPicture1;
  File? _professionalPicture2;
  File? _professionalPicture3;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _company = widget.user.company!;
    _skills = widget.user.skills!;
    _performances = widget.user.performances!;
    _collaborations = widget.user.collaborations!;
    _awards = widget.user.awards!;
    _management = widget.user.management!;
    _contacts = widget.user.contacts!;
    _profileHandle = widget.user.profileHandle!;
    _website = widget.user.website!;
    _otherSites1 = widget.user.otherSites1!;
    _otherSites2 = widget.user.otherSites2!;
    _mail = widget.user.mail!;
  }

  _submit() async {
    if (_formKey.currentState!.validate() & !_isLoading) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      String _professionalPicture1Url = '';
      // ignore: unnecessary_null_comparison
      if (_professionalPicture1 == null) {
        _professionalPicture1Url = widget.user.professionalPicture1!;
      } else {
        _professionalPicture1Url =
            await StorageService.uploadUserprofessionalPicture1(
          widget.user.professionalPicture1!,
          _professionalPicture1!,
        );
      }

      String _professionalPicture2Url = '';
      // ignore: unnecessary_null_comparison
      if (_professionalPicture2 == null) {
        _professionalPicture2Url = widget.user.professionalPicture2!;
      } else {
        _professionalPicture2Url =
            await StorageService.uploadUserprofessionalPicture2(
          widget.user.professionalPicture2!,
          _professionalPicture2!,
        );
      }
      String _professionalPicture3Url = '';
      // ignore: unnecessary_null_comparison
      if (_professionalPicture3 == null) {
        _professionalPicture3Url = widget.user.professionalPicture3!;
      } else {
        _professionalPicture3Url =
            await StorageService.uploadUserprofessionalPicture3(
          widget.user.professionalPicture3!,
          _professionalPicture3!,
        );
      }

      try {
        usersRef
            .doc(
          widget.user.id,
        )
            .update({
          'company': _company,
          'skills': _skills,
          'performances': _performances,
          'collaborations': _collaborations,
          'awards': _awards,
          'management': _management,
          'contacts': _contacts,
          'website': _website,
          'otherSites1': _otherSites1,
          'otherSites2': _otherSites2,
          'professionalPicture1': _professionalPicture1Url,
          'professionalPicture2': _professionalPicture2Url,
          'professionalPicture3': _professionalPicture3Url,
          'mail': _mail,
        });
      } catch (e) {
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
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
            result.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.error_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }
      Navigator.pop(context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage!;
  }

  _handleImage() async {
    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;
    // ignore: unnecessary_null_comparison
    if (file != null) {
      if (mounted) {
        setState(() {
          _professionalPicture1 = file as File;
        });
      }
    }
  }

  _handleImage2() async {
    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;
    if (mounted) {
      setState(() {
        _professionalPicture2 = file as File;
      });
    }
  }

  _handleImage3() async {
    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;
    if (mounted) {
      setState(() {
        _professionalPicture3 = file as File;
      });
    }
  }

  _displayPostImage() {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    // ignore: unnecessary_null_comparison
    if (_professionalPicture1 == null) {
      if (widget.user.professionalPicture1!.isEmpty) {
        return Container(
          height: width / 4,
          width: width / 4,
          decoration: BoxDecoration(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            MdiIcons.image,
            color:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
            size: 30,
          ),
        );
      } else {
        return Container(
          height: width / 4,
          width: width / 4,
          decoration: BoxDecoration(
              image: DecorationImage(
            image:
                CachedNetworkImageProvider(widget.user.professionalPicture1!),
            fit: BoxFit.cover,
          )),
        );
      }
    } else {
      return Container(
        height: width / 4,
        width: width / 4,
        child: Image(
          image: FileImage(_professionalPicture1!),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  _displayPostImage2() {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    // ignore: unnecessary_null_comparison
    if (_professionalPicture2 == null) {
      if (widget.user.professionalPicture2!.isEmpty) {
        return Container(
          height: width / 4,
          width: width / 4,
          decoration: BoxDecoration(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            MdiIcons.image,
            color:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
            size: 30,
          ),
        );
      } else {
        return Container(
          height: width / 4,
          width: width / 4,
          decoration: BoxDecoration(
              image: DecorationImage(
            image:
                CachedNetworkImageProvider(widget.user.professionalPicture2!),
            fit: BoxFit.cover,
          )),
        );
      }
    } else {
      return Container(
        height: width / 4,
        width: width / 4,
        child: Image(
          image: FileImage(_professionalPicture2!),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  _displayPostImage3() {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    // ignore: unnecessary_null_comparison
    if (_professionalPicture3 == null) {
      if (widget.user.professionalPicture3!.isEmpty) {
        return Container(
          height: width / 4,
          width: width / 4,
          decoration: BoxDecoration(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            MdiIcons.image,
            color:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
            size: 30,
          ),
        );
      } else {
        return Container(
          height: width / 4,
          width: width / 4,
          decoration: BoxDecoration(
              image: DecorationImage(
            image:
                CachedNetworkImageProvider(widget.user.professionalPicture3!),
            fit: BoxFit.cover,
          )),
        );
      }
    } else {
      return Container(
        height: width / 4,
        width: width / 4,
        child: Image(
          image: FileImage(_professionalPicture3!),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  _displayButton() {
    if (widget.user.professionalPicture1!.isNotEmpty ||
        widget.user.professionalPicture2!.isNotEmpty ||
        widget.user.professionalPicture3!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Container(
          width: 250.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 20.0,
              onPrimary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text(
              'Done',
              style: TextStyle(
                color:
                    ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.blue,
                fontSize: 16.0,
              ),
            ),
            onPressed: () => _submit(),
          ),
        ),
      );
    } else {
      // ignore: unnecessary_null_comparison
      return _professionalPicture1 == null ||
              // ignore: unnecessary_null_comparison
              _professionalPicture2 == null ||
              // ignore: unnecessary_null_comparison
              _professionalPicture3 == null
          ? Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                  width: double.infinity,
                  color: Colors.blue,
                  child: ListTile(
                    title: Text(
                        'Add three professional images in order for you to be able to save your booking information',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        )),
                    leading: IconButton(
                      icon: Icon(Icons.error_outline),
                      iconSize: 20.0,
                      color: Colors.white,
                      onPressed: () => () {},
                    ),
                  )),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Container(
                width: 250.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 20.0,
                    onPrimary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: ConfigBloc().darkModeOn
                          ? Color(0xFF1a1a1a)
                          : Colors.blue,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () => _submit(),
                ),
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                      child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                EditProfileInfo(
                                  editTitle: 'Booking \nportfolio',
                                  info:
                                      'Enter your professional information to make it easy for other users to get to know you for business and recommendation purposes. Kindly read the instruction under each text filed carefully before filling the forms. ',
                                  icon: Icons.work,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  initialValue: _company,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 3.0),
                                    ),
                                    enabledBorder: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.grey)),
                                    hintText: " example (Black Records)",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    labelText: 'Record Label / Organization',
                                  ),
                                  validator: (input) => input!.trim().length < 1
                                      ? 'Please enter a valid  company name'
                                      : null,
                                  onSaved: (input) => _company = input!,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Enter the company or organization you are associated with or signed to.",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  initialValue: _skills,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 3.0),
                                    ),
                                    enabledBorder: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.grey)),
                                    hintText:
                                        " example (rapping, singing, dancing)",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    labelText: 'Skills',
                                  ),
                                  validator: (input) => input!.trim().length < 1
                                      ? 'Please enter some skills'
                                      : null,
                                  onSaved: (input) => _skills = input!,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Enter your skills in your field of work as a musician, producer, video director, or any of the above account types. Separate each skill with a comma(,).",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                _profileHandle.startsWith('M') ||
                                        _profileHandle.startsWith("B") ||
                                        _profileHandle.startsWith("V") ||
                                        _profileHandle.startsWith("P")
                                    ? SizedBox.shrink()
                                    : SizedBox(
                                        height: 20.0,
                                      ),
                                _profileHandle.startsWith('M') ||
                                        _profileHandle.startsWith("B") ||
                                        _profileHandle.startsWith("V") ||
                                        _profileHandle.startsWith("P")
                                    ? SizedBox.shrink()
                                    : TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        initialValue: _performances,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: ConfigBloc().darkModeOn
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 3.0),
                                          ),
                                          enabledBorder: new OutlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.grey)),
                                          hintText: " At least 3 ",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey),
                                          labelText: 'Performances/exhibitions',
                                        ),
                                        validator: (input) => input!
                                                    .trim()
                                                    .length <
                                                1
                                            ? 'Please, enter at least 3 performances/exhibitions'
                                            : null,
                                        onSaved: (input) =>
                                            _performances = input!,
                                      ),
                                _profileHandle.startsWith('M') ||
                                        _profileHandle.startsWith("B") ||
                                        _profileHandle.startsWith("V") ||
                                        _profileHandle.startsWith("P")
                                    ? SizedBox.shrink()
                                    : SizedBox(height: 10),
                                _profileHandle.startsWith('M') ||
                                        _profileHandle.startsWith("B") ||
                                        _profileHandle.startsWith("V") ||
                                        _profileHandle.startsWith("P")
                                    ? SizedBox.shrink()
                                    : Text(
                                        "Enter any event or ceremony you've performed at based on your account type, for example, BET 2019, World Art exhibition.",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  initialValue: _collaborations,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 3.0),
                                    ),
                                    enabledBorder: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.grey)),
                                    hintText: " At least 5",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    labelText: 'Top Collaborations/Projects',
                                  ),
                                  validator: (input) => input!.trim().length < 1
                                      ? 'Please, enter some collaborations/projects.'
                                      : null,
                                  onSaved: (input) => _collaborations = input!,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "With artists, producers, designers or organizers",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                _profileHandle.startsWith('V')
                                    ? SizedBox.shrink()
                                    : SizedBox(
                                        height: 20.0,
                                      ),
                                _profileHandle.startsWith('V')
                                    ? SizedBox.shrink()
                                    : TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        initialValue: _awards,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: ConfigBloc().darkModeOn
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 3.0),
                                          ),
                                          enabledBorder: new OutlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.grey)),
                                          hintText:
                                              "Separate each award with a comma(,) ",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey),
                                          labelText: 'Awards',
                                        ),
                                        onSaved: (input) => _awards = input!,
                                      ),
                                _profileHandle.startsWith('V')
                                    ? SizedBox.shrink()
                                    : SizedBox(height: 10),
                                _profileHandle.startsWith('V')
                                    ? SizedBox.shrink()
                                    : Text(
                                        "Please enter any awards, prizes or plaques received. For example (6 BETs, 2 Grammys, 9 AFRIMAS ).",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Divider(color: Colors.grey),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.email,
                                          color: Colors.blue,
                                          size: 20.0,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          'Booking Contact',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Enter your booking and management information. You can only one phone number with an email.  ',
                                      style: TextStyle(
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        height: 2,
                                        color: Colors.blue,
                                        width: width / 3,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      initialValue: _management,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue, width: 3.0),
                                        ),
                                        enabledBorder: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.grey)),
                                        hintText: "The company managing you",
                                        hintStyle: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        labelText: 'Management',
                                      ),
                                      validator: (input) => input!
                                                  .trim()
                                                  .length <
                                              1
                                          ? 'Please enter management/manager'
                                          : null,
                                      onSaved: (input) => _management = input!,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      " Enter the name of your manager or any company managing you.",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      maxLines: null,
                                      initialValue: _contacts,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue, width: 3.0),
                                        ),
                                        enabledBorder: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.grey)),
                                        hintText:
                                            " Phone number of your manager",
                                        hintStyle: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        labelText: 'Phone number',
                                      ),
                                      autofillHints: [
                                        AutofillHints.telephoneNumberDevice,
                                      ],
                                      validator: (input) =>
                                          input!.trim().length < 1
                                              ? 'Please enter a phone number'
                                              : null,
                                      onSaved: (input) => _contacts = input!,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Enter the phone number of your manager or the company managing you.",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      initialValue: _mail,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue, width: 3.0),
                                        ),
                                        enabledBorder: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.grey)),
                                        hintText: " Enter your email address",
                                        hintStyle: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        labelText: 'Email',
                                      ),
                                      autofillHints: [AutofillHints.email],
                                      validator: (email) => email != null &&
                                              !EmailValidator.validate(email)
                                          ? 'Please enter your email'
                                          : null,
                                      onSaved: (input) => _mail = input!,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Please, enter an email to help people contact you if they don't hear from your manager..",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Divider(color: Colors.grey),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.web,
                                              color: Colors.blue,
                                              size: 20.0,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              'Your Works',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          'Enter the following hyperlinks to some of your works. You can enter a hyperlink directly to your website,  or any other platform. When adding a hyperlink, the URL should be directly copied from a browser and not an app.  ',
                                          style: TextStyle(
                                            color: ConfigBloc().darkModeOn
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 2,
                                            color: Colors.blue,
                                            width: width / 3,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40.0,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          initialValue: _website,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: ConfigBloc().darkModeOn
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 3.0),
                                            ),
                                            enabledBorder:
                                                new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.grey)),
                                            hintText: " Enter hyperlink",
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                            labelText: 'Website',
                                          ),
                                          onSaved: (input) => _website = input!,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Enter a hyperlink to your website.",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          initialValue: _otherSites1,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: ConfigBloc().darkModeOn
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 3.0),
                                            ),
                                            enabledBorder:
                                                new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.grey)),
                                            hintText:
                                                "Enter a hyperlink to your video channel.",
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                            labelText: 'video channel Url',
                                          ),
                                          onSaved: (input) =>
                                              _otherSites1 = input!,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Enter a hyperlink to your video channel where people can see your works. ",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          initialValue: _otherSites2,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: ConfigBloc().darkModeOn
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 3.0),
                                            ),
                                            enabledBorder:
                                                new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.grey)),
                                            hintText:
                                                "Enter another place to find your works",
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                            labelText: 'Other Places',
                                          ),
                                          validator: (input) => input!
                                                      .trim()
                                                      .length <
                                                  1
                                              ? 'Please enter a link to your works'
                                              : null,
                                          onSaved: (input) =>
                                              _otherSites2 = input!,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Enter a link to any other site where users can see your works. Please copy an URL link of an app website and past it here. ",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Divider(color: Colors.grey),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.photo_album_outlined,
                                          color: Colors.blue,
                                          size: 20.0,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          'Your Gallery',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Your gallery displays professional images about you.',
                                      style: TextStyle(
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        height: 2,
                                        color: Colors.blue,
                                        width: width / 3,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: _handleImage,
                                          child: _displayPostImage(),
                                        ),
                                        GestureDetector(
                                          onTap: _handleImage2,
                                          child: _displayPostImage2(),
                                        ),
                                        GestureDetector(
                                          onTap: _handleImage3,
                                          child: _displayPostImage3(),
                                        )
                                      ],
                                    ),
                                    _isLoading
                                        ? SizedBox.shrink()
                                        : _displayButton(),
                                    SizedBox(
                                      height: 40,
                                    )
                                  ],
                                ),
                                _isLoading
                                    ? SizedBox(
                                        height: 1.0,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.grey[100],
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.blue),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ))),
                ),
              ),
            ),
          )),
    );
  }
}
