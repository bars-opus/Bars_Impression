import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class EditProfileScreen extends StatefulWidget {
  final AccountHolder user;
  EditProfileScreen({
    required this.user,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  int index = 0;
  File? _profileImage;
  String _name = '';
  String _userName = '';
  String _bio = '';
  String _profileHandle = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name!;
    _userName = widget.user.userName!;
    _bio = widget.user.bio!;
    _profileHandle = widget.user.profileHandle!;
  }

  _handleImageFromGallery() async {
    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;
    // ignore: unnecessary_null_comparison
    if (file != null) {
      if (mounted) {
        setState(() {
          _profileImage = file as File;
        });
      }
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
          ConfigBloc().darkModeOn
              ? 'assets/images/user_placeholder.png'
              : 'assets/images/user_placeholder2.png',
        );
      } else {
        return CachedNetworkImageProvider(widget.user.profileImageUrl!);
      }
    } else {
      return FileImage(_profileImage!);
    }
  }

  _submit() async {
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

      try {
        usersRef
            .doc(
          widget.user.id,
        )
            .update({
          // 'blurHash': '',
          'name': _name,
          'profileImageUrl': _profileImageUrl,
          'bio': _bio,
        });

        usersAuthorRef
            .doc(
          widget.user.id,
        )
            .update({
          'profileImageUrl': _profileImageUrl,
          'bio': _bio,
        });
        Navigator.pop(context);
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
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
            widget.user.name!,
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            "Your profile was edited successfully!!!",
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            MdiIcons.checkCircleOutline,
            size: 30.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  _dynamicLink() async {
    var linkUrl = Uri.parse(widget.user.profileImageUrl!);

    final dynamicLinkParams = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: linkUrl,
        title: widget.user.userName,
        description: widget.user.bio,
      ),
      link: Uri.parse('https://www.barsopus.com/user_${widget.user.id}'),
      uriPrefix: 'https://barsopus.com/barsImpression',
      androidParameters:
          AndroidParameters(packageName: 'com.barsOpus.barsImpression'),
      iosParameters: IOSParameters(
        bundleId: 'com.bars-Opus.barsImpression',
        appStoreId: '1610868894',
      ),
    );
    if (Platform.isIOS) {
      var link =
          await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
      Share.share(link.toString());
    } else {
      var link =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      Share.share(link.shortUrl.toString());
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
            automaticallyImplyLeading: index != 0 ? false : true,
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
            actions: [
              IconButton(
                  icon: Icon(Icons.share),
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  onPressed: () => _dynamicLink()),
            ],
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Container(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _isLoading
                                ? SizedBox(
                                    height: 2.0,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.grey[100],
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.blue),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  children: [
                                    Hero(
                                      tag: 'useravater',
                                      child: GestureDetector(
                                        onTap: () => _handleImageFromGallery,
                                        child: CircleAvatar(
                                            backgroundColor:
                                                ConfigBloc().darkModeOn
                                                    ? Color(0xFF1a1a1a)
                                                    : Color(0xFFf2f2f2),
                                            radius: 80.0,
                                            backgroundImage:
                                                _displayProfileImage()),
                                      ),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.transparent,
                                        side: BorderSide(
                                            width: 1.0,
                                            color: Colors.transparent),
                                      ),
                                      onPressed: _handleImageFromGallery,
                                      child: Text(
                                        'Set photo',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        new Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            _userName.toUpperCase(),
                                            style: TextStyle(
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.blueGrey[100]
                                                  : Colors.black,
                                              fontSize: width > 600 ? 40 : 30.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Hero(
                                          tag: 'nickName',
                                          child: new Material(
                                            color: Colors.transparent,
                                            child: Text(
                                              _name,
                                              style: TextStyle(
                                                color: ConfigBloc().darkModeOn
                                                    ? Colors.blueGrey[100]
                                                    : Colors.black,
                                                fontSize:
                                                    width > 600 ? 16 : 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Hero(
                                          tag: 'profileHandle',
                                          child: new Material(
                                            color: Colors.transparent,
                                            child: Text(
                                              _profileHandle,
                                              style: TextStyle(
                                                color: ConfigBloc().darkModeOn
                                                    ? Colors.blueGrey
                                                    : Colors.black,
                                                fontSize:
                                                    width > 600 ? 16 : 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          bottom: 10.0,
                                          right: 10.0),
                                      child: GestureDetector(
                                        onTap: () =>
                                            widget.user.verified!.isEmpty
                                                ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          EditProfileName(
                                                        user: widget.user,
                                                      ),
                                                    ))
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          VerificationNutralized(
                                                        user: widget.user,
                                                        from: 'userName',
                                                      ),
                                                    )),
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Username',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 8.8,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                _userName.toUpperCase(),
                                                style: TextStyle(
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.blueGrey[100]
                                                      : Colors.black,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              Container(
                                                height: 0.7,
                                                width: double.infinity,
                                                color: Colors.grey,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          bottom: 10.0,
                                          right: 10.0),
                                      child: Container(
                                        color: Colors.transparent,
                                        child: TextFormField(
                                          initialValue: _name,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: ConfigBloc().darkModeOn
                                                ? Colors.blueGrey[100]
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
                                                new UnderlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.grey)),
                                            hintText:
                                                'Stage or brand or nickname',
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                            labelText: 'Nickname',
                                          ),
                                          autofillHints: [AutofillHints.name],
                                          validator: (input) => input!
                                                      .trim()
                                                      .length <
                                                  1
                                              ? 'Please enter a valid nickname'
                                              : null,
                                          onSaved: (input) => _name = input!,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          bottom: 10.0,
                                          right: 10.0),
                                      child: Container(
                                        color: Colors.transparent,
                                        child: TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          initialValue: _bio,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: ConfigBloc().darkModeOn
                                                ? Colors.blueGrey[100]
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
                                                new UnderlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.grey)),
                                            hintText:
                                                'A piece of short information about yourself',
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                            labelText: 'Bio',
                                          ),
                                          validator: (input) => input!
                                                      .trim()
                                                      .length >
                                                  700
                                              ? 'Please, enter a bio of fewer than 700 characters.'
                                              : null,
                                          onSaved: (input) => _bio = input!,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: UserWebsite(
                                        padding: 5,
                                        iconSize: 20,
                                        raduis: 10,
                                        title: ' Select an Account Type',
                                        icon: Icons.person,
                                        textColor: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                        iconColor: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                        onPressed: () =>
                                            widget.user.verified!.isEmpty
                                                ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          EditProfileHandle(
                                                        user: widget.user,
                                                      ),
                                                    ))
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          VerificationNutralized(
                                                        user: widget.user,
                                                        from: 'accountType',
                                                      ),
                                                    )),
                                        containerColor: Colors.transparent,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: UserWebsite(
                                        containerColor: Colors.transparent,
                                        padding: 5,
                                        iconSize: 20,
                                        raduis: 10,
                                        title: ' Choose Your Location',
                                        icon: MdiIcons.mapMarker,
                                        textColor: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                        iconColor: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  EditProfileSelectLocation(
                                                user: widget.user,
                                              ),
                                            )),
                                      ),
                                    ),
                                    widget.user.profileHandle!
                                                .startsWith('F') ||
                                            widget.user.profileHandle!.isEmpty
                                        ? const SizedBox.shrink()
                                        : Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: UserWebsite(
                                                containerColor:
                                                    Colors.transparent,
                                                padding: 5,
                                                iconSize: 20,
                                                raduis: 10,
                                                title: ' Booking Portfolio',
                                                icon: MdiIcons.briefcaseEdit,
                                                textColor:
                                                    ConfigBloc().darkModeOn
                                                        ? Colors.white
                                                        : Colors.black,
                                                iconColor:
                                                    ConfigBloc().darkModeOn
                                                        ? Colors.white
                                                        : Colors.black,
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            EditProfileProfessional(
                                                          user: widget.user,
                                                        ),
                                                      ));
                                                }),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: UserWebsite(
                                        containerColor: Colors.transparent,
                                        iconSize: 20,
                                        padding: 5,
                                        raduis: 10,
                                        title: '  Music Preference',
                                        icon: Icons.favorite,
                                        textColor: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                        iconColor: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  EditProfileMusicPref(
                                                user: widget.user,
                                              ),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: UserWebsite(
                                        containerColor: Colors.transparent,
                                        iconSize: 20,
                                        padding: 5,
                                        raduis: 10,
                                        title: 'Account Settings',
                                        icon: Icons.settings,
                                        textColor: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                        iconColor: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ProfileSettings(
                                                user: widget.user,
                                              ),
                                            )),
                                      ),
                                    ),
                                    _isLoading
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30.0),
                                            child: SizedBox(
                                              height: 2.0,
                                              child: LinearProgressIndicator(
                                                backgroundColor:
                                                    Colors.transparent,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.blue),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.all(40.0),
                                            width: 250.0,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    ConfigBloc().darkModeOn
                                                        ? Colors.white
                                                        : Color(0xFF1d2323),
                                                elevation: 20.0,
                                                foregroundColor: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                _submit();
                                              },
                                              child: Text(
                                                'Save Profile',
                                                style: TextStyle(
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(height: 40),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      iconSize: 30.0,
                                      color: Colors.grey,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    SizedBox(
                                      height: 50.0,
                                    ),
                                  ],
                                )),
                            GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SuggestionBox())),
                                child: Material(
                                    color: Colors.transparent,
                                    child: Text('Suggestion Box',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 12,
                                        )))),
                            SizedBox(height: 30),
                            RichText(
                              textScaleFactor: MediaQuery.of(context)
                                  .textScaleFactor
                                  .clamp(0.5, 1.5),
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'You registered your account on \n',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text: MyDateFormat.toDate(
                                          widget.user.timestamp!.toDate()),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text: ', at ${MyDateFormat.toTime(
                                        widget.user.timestamp!.toDate(),
                                      )}.',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text: '\n' +
                                          timeago.format(
                                            widget.user.timestamp!.toDate(),
                                          ),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 40),
                          ],
                        ))),
              ),
            ),
          )),
    );
  }
}
