import 'package:bars/utilities/exports.dart';
import 'package:bars/widgets/info/direction_widget_with_icon.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/scheduler.dart';

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
  File? _professionalPicture1;
  File? _professionalPicture2;
  File? _professionalPicture3;
  bool _isLoading = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setInt1(0);
      Provider.of<UserData>(context, listen: false).setPostImage(null);
      Provider.of<UserData>(context, listen: false)
          .setPost1(widget.user.company!);
      Provider.of<UserData>(context, listen: false)
          .setPost2(widget.user.skills!);
      Provider.of<UserData>(context, listen: false)
          .setPost3(widget.user.performances!);
      Provider.of<UserData>(context, listen: false)
          .setPost4(widget.user.collaborations!);
      Provider.of<UserData>(context, listen: false)
          .setPost5(widget.user.awards!);
      Provider.of<UserData>(context, listen: false)
          .setPost6(widget.user.management!);
      Provider.of<UserData>(context, listen: false)
          .setPost7(widget.user.contacts!);
      Provider.of<UserData>(context, listen: false)
          .setPost8(widget.user.profileHandle!);
      Provider.of<UserData>(context, listen: false)
          .setPost9(widget.user.website!);
      Provider.of<UserData>(context, listen: false)
          .setPost10(widget.user.otherSites1!);
      Provider.of<UserData>(context, listen: false)
          .setPost11(widget.user.otherSites2!);
      Provider.of<UserData>(context, listen: false)
          .setPost12(widget.user.mail!);
    });
    _pageController = PageController(
      initialPage: 0,
    );
  }

  _validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      animateToPage();
    }
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
          'company': Provider.of<UserData>(context, listen: false).post1,
          'skills': Provider.of<UserData>(context, listen: false).post2,
          'performances': Provider.of<UserData>(context, listen: false).post3,
          'collaborations': Provider.of<UserData>(context, listen: false).post4,
          'awards': Provider.of<UserData>(context, listen: false).post5,
          'management': Provider.of<UserData>(context, listen: false).post6,
          'contacts': Provider.of<UserData>(context, listen: false).post7,
          'website': Provider.of<UserData>(context, listen: false).post9,
          'otherSites1': Provider.of<UserData>(context, listen: false).post10,
          'otherSites2': Provider.of<UserData>(context, listen: false).post11,
          'professionalPicture1': _professionalPicture1Url,
          'professionalPicture2': _professionalPicture2Url,
          'professionalPicture3': _professionalPicture3Url,
          'mail': Provider.of<UserData>(context, listen: false).post12,
          'score': 1,
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
              backgroundColor: Colors.white,
              elevation: 20.0,
              foregroundColor: Colors.blue,
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
                        'Add three professional images in order to be able to save your booking information',
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
                    backgroundColor: Colors.white,
                    elevation: 20.0,
                    foregroundColor: Colors.blue,
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

  setNull() {
    Provider.of<UserData>(context, listen: false).setPostImage(null);
    Provider.of<UserData>(context, listen: false).setInt1(0);
    Provider.of<UserData>(context, listen: false).setPost1('');
    Provider.of<UserData>(context, listen: false).setPost2('');
    Provider.of<UserData>(context, listen: false).setPost3('');
    Provider.of<UserData>(context, listen: false).setPost4('');
    Provider.of<UserData>(context, listen: false).setPost5('');
    Provider.of<UserData>(context, listen: false).setPost6('');
    Provider.of<UserData>(context, listen: false).setPost7('');
    Provider.of<UserData>(context, listen: false).setPost8('');
    Provider.of<UserData>(context, listen: false).setPost9('');
    Provider.of<UserData>(context, listen: false).setPost10('');
    Provider.of<UserData>(context, listen: false).setPost11('');
    Provider.of<UserData>(context, listen: false).setPost12('');
    Provider.of<UserData>(context, listen: false).setPost13('');
    Provider.of<UserData>(context, listen: false).setBool1(false);
    Provider.of<UserData>(context, listen: false).setBool2(false);
    Provider.of<UserData>(context, listen: false).setBool3(false);
    Provider.of<UserData>(context, listen: false).setBool4(false);
    Provider.of<UserData>(context, listen: false).setBool5(false);
    Provider.of<UserData>(context, listen: false).setBool6(false);
    Provider.of<UserData>(context, listen: false).addressSearchResults = [];
  }

  _pop() {
    Navigator.pop(context);

    setNull();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
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
            leading: IconButton(
                icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                onPressed: () {
                  Provider.of<UserData>(context, listen: false).int1 != 0
                      ? animateBack()
                      : _pop();
                }),
            centerTitle: true,
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _formKey,
                child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int index) {
                      Provider.of<UserData>(context, listen: false)
                          .setInt1(index);
                    },
                    children: [
                      SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                EditProfileInfo(
                                  editTitle: 'Booking \nportfolio',
                                  info:
                                      'Enter your professional information to make it easy for other users to get to know you for business and recommendation purposes.  Read the instruction under each text field carefully before filling out the forms.',
                                  icon: Icons.work,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  initialValue: widget.user.company,
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
                                  onSaved: (input) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost1(input!),
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
                                  initialValue: widget.user.skills,
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
                                        "example (rapping, singing, dancing)",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    labelText: 'Skills',
                                  ),
                                  validator: (input) => input!.trim().length < 1
                                      ? 'Please enter some skills'
                                      : null,
                                  onSaved: (input) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost2(input!),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Enter your skills in your field of work as a musician, producer, video director, or any of the above account types. Separate each skill with a comma(,).",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                widget.user.profileHandle!.startsWith('M') ||
                                        widget.user.profileHandle!
                                            .startsWith("B") ||
                                        widget.user.profileHandle!
                                            .startsWith("V") ||
                                        widget.user.profileHandle!
                                            .startsWith("P")
                                    ? const SizedBox.shrink()
                                    : SizedBox(
                                        height: 20.0,
                                      ),
                                widget.user.profileHandle!.startsWith('M') ||
                                        widget.user.profileHandle!
                                            .startsWith("B") ||
                                        widget.user.profileHandle!
                                            .startsWith("V") ||
                                        widget.user.profileHandle!
                                            .startsWith("P")
                                    ? const SizedBox.shrink()
                                    : TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        initialValue: widget.user.performances,
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
                                            ? 'Please, enter at least three performances/exhibitions'
                                            : null,
                                        onSaved: (input) =>
                                            Provider.of<UserData>(context,
                                                    listen: false)
                                                .setPost3(input!),
                                      ),
                                widget.user.profileHandle!.startsWith('M') ||
                                        widget.user.profileHandle!
                                            .startsWith("B") ||
                                        widget.user.profileHandle!
                                            .startsWith("V") ||
                                        widget.user.profileHandle!
                                            .startsWith("P")
                                    ? const SizedBox.shrink()
                                    : SizedBox(height: 10),
                                widget.user.profileHandle!.startsWith('M') ||
                                        widget.user.profileHandle!
                                            .startsWith("B") ||
                                        widget.user.profileHandle!
                                            .startsWith("V") ||
                                        widget.user.profileHandle!
                                            .startsWith("P")
                                    ? const SizedBox.shrink()
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
                                  initialValue: widget.user.collaborations,
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
                                  onSaved: (input) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost4(input!),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "With artists, producers, designers, or organizers",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                widget.user.profileHandle!.startsWith('V')
                                    ? const SizedBox.shrink()
                                    : SizedBox(
                                        height: 20.0,
                                      ),
                                widget.user.profileHandle!.startsWith('V')
                                    ? const SizedBox.shrink()
                                    : TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        initialValue: widget.user.awards,
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
                                        onSaved: (input) =>
                                            Provider.of<UserData>(context,
                                                    listen: false)
                                                .setPost5(input!),
                                      ),
                                widget.user.profileHandle!.startsWith('V')
                                    ? const SizedBox.shrink()
                                    : SizedBox(height: 10),
                                widget.user.profileHandle!.startsWith('V')
                                    ? const SizedBox.shrink()
                                    : Text(
                                        "Please enter any awards, prizes or plaques received. For example (6 BETs, 2 Grammys, and 9 AFRIMAS ).",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Center(
                                  child: AlwaysWhiteButton(
                                      onPressed: _validate,
                                      buttonText: "Continue"),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                DirectionWidgetWithIcon(
                                  text:
                                      'Enter your booking and management information. You can only add one phone number with an email.',
                                  fontSize: null,
                                  icon: Icon(
                                    Icons.email,
                                    color: Color.fromRGBO(33, 150, 243, 1),
                                  ),
                                  title: 'Booking Contact',
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  initialValue: widget.user.management,
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
                                    hintText: "The company managing you",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    labelText: 'Management',
                                  ),
                                  validator: (input) => input!.trim().length < 1
                                      ? 'Please enter management/manager'
                                      : null,
                                  onSaved: (input) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost6(input!),
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
                                  initialValue: widget.user.contacts,
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
                                        borderSide:
                                            new BorderSide(color: Colors.grey)),
                                    hintText: " Phone number of your manager",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    labelText: 'Phone number',
                                  ),
                                  autofillHints: [
                                    AutofillHints.telephoneNumberDevice,
                                  ],
                                  validator: (input) => input!.trim().length < 1
                                      ? 'Please enter a phone number'
                                      : null,
                                  onSaved: (input) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost7(input!),
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
                                  initialValue: widget.user.mail,
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
                                    hintText: "Enter your email address",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    labelText: 'Email',
                                  ),
                                  autofillHints: [AutofillHints.email],
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(email)
                                      ? 'Please enter a valid email'
                                      : null,
                                  onSaved: (input) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost12(input!),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Please, enter an email to help people contact you if they don't hear from your manager.",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Center(
                                  child: AlwaysWhiteButton(
                                      onPressed: _validate,
                                      buttonText: "Continue"),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                DirectionWidgetWithIcon(
                                  text:
                                      'Enter the following hyperlinks to some of your works. You can enter a hyperlink directly to your website,  or any other platform. The URL should be directly copied from a browser and not an app when adding a hyperlink.',
                                  fontSize: null,
                                  icon: Icon(
                                    Icons.work,
                                    color: Colors.blue,
                                  ),
                                  title: 'Your Works',
                                ),
                                const SizedBox(
                                  height: 40.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  initialValue: widget.user.website,
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
                                    hintText: " Enter hyperlink",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    labelText: 'Website',
                                  ),
                                  onSaved: (input) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost9(input!),
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
                                  initialValue: widget.user.otherSites1,
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
                                        "Enter a hyperlink to your video channel.",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    labelText: 'Video channel Url',
                                  ),
                                  onSaved: (input) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost10(input!),
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
                                  initialValue: widget.user.otherSites2,
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
                                        "Enter another place to find your works",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    labelText: 'Other Places',
                                  ),
                                  validator: (input) => input!.trim().length < 1
                                      ? 'Please enter a link to your works'
                                      : null,
                                  onSaved: (input) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost11(input!),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Enter a link to any other site where users can see your works. Please copy an URL link of an app website and paste it here. ",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Center(
                                  child: AlwaysWhiteButton(
                                      onPressed: _validate,
                                      buttonText: "Continue"),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                DirectionWidgetWithIcon(
                                  text:
                                      'Your gallery displays professional images of you.',
                                  fontSize: null,
                                  icon: Icon(
                                    Icons.photo_album_outlined,
                                    color: Color.fromRGBO(33, 150, 243, 1),
                                  ),
                                  title: 'Your Gallery',
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
                                const SizedBox(
                                  height: 50,
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
                                    : _displayButton(),
                                const SizedBox(
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          )),
    );
  }
}
