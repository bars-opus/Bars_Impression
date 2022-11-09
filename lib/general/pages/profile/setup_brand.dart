import 'package:bars/general/pages/discover/discover_user.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

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
  String _bio = '';
  String selectedValue = '';
  String query = "";
  late TextEditingController _controller;
  late PageController _pageController;
  int _index = 0;

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
    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;
    if (mounted) {
      setState(() {
        _profileImage = file as File;
      });
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
    // ignore: unnecessary_null_comparison
    if (_profileImage == null) {
      return AssetImage(
        ConfigBloc().darkModeOn
            ? 'assets/images/user_placeholder.png'
            : 'assets/images/user_placeholder2.png',
      );
    } else {
      return FileImage(_profileImage!);
    }
  }

  _validate() async {
    if (_formKey.currentState!.validate() &
        !Provider.of<UserData>(context, listen: false).isLoading) {
      Provider.of<UserData>(context, listen: false).setIsLoading(true);
      _formKey.currentState?.save();
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('userName', isEqualTo: _userName)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length > 0) {
        Provider.of<UserData>(context, listen: false).setIsLoading(false);
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
        return Flushbar(
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
            'Sorry $_userName is already in use by another user try using a different username',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            "",
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
      } else {
        String currentUserId =
            Provider.of<UserData>(context, listen: false).currentUserId!;
        FocusScope.of(context).unfocus();

        try {
          await usersRef.doc(currentUserId).update({
            'userName': _userName,
          });
          usersAuthorRef.doc(currentUserId).update({
            'userName': _userName,
          });

          animateToPage();
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
      }
    }
    Provider.of<UserData>(context, listen: false).setIsLoading(false);
  }

  _submitProfileImage(AccountHolder user) async {
    String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    if (_formKey.currentState!.validate() &&
        !Provider.of<UserData>(context, listen: false).isLoading) {
      Provider.of<UserData>(context, listen: false).setIsLoading(true);
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

      try {
        await usersRef.doc(currentUserId).update({
          'profileImageUrl': _profileImageUrl,
          'bio': Provider.of<UserData>(context, listen: false).post6,
        });
        await usersAuthorRef.doc(currentUserId).update({
          'profileImageUrl': _profileImageUrl,
          'bio': Provider.of<UserData>(context, listen: false).post6,
        });

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DiscoverUser(
                currentUserId: FirebaseAuth.instance.currentUser!.uid,
                isWelcome: true,
              ),
            ));
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
          titleText: ShakeTransition(
            axis: Axis.vertical,
            curve: Curves.easeInOutBack,
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: width > 800 ? 22 : 14,
              ),
            ),
          ),
          messageText: Text(
            "Your brand has been setup successfully",
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
          duration: Duration(seconds: 2),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
        Provider.of<UserData>(context, listen: false).setIsLoading(false);
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
      Provider.of<UserData>(context, listen: false).setIsLoading(false);
    }
  }

  _submitProfileHandle() async {
    Provider.of<UserData>(context, listen: false).setIsLoading(true);
    String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    if (_profileHandle.isEmpty) {
      _profileHandle = 'Fan';
    }
    try {
      await usersRef.doc(currentUserId).update({
        'profileHandle': _profileHandle,
      });
      await usersAuthorRef.doc(currentUserId).update({
        'profileHandle': _profileHandle,
      });

      animateToPage();
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
    Provider.of<UserData>(context, listen: false).setIsLoading(false);
  }

  static const values = <String>[
    "Artist",
    "Producer",
    "Cover_Art_Designer",
    "Music_Video_Director",
    "DJ",
    "Battle_Rapper",
    "Photographer",
    "Dancer",
    "Video_Vixen",
    "Makeup_Artist",
    "Record_Label",
    "Brand_Influencer",
    "Blogger",
    "MC(Host)",
    "Fan",
  ];

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: values.map((value) {
          final selected = this.selectedValue == value;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
            value: value,
            groupValue: selectedValue,
            title: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
              ),
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

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor: ConfigBloc().darkModeOn || _index == 4
            ? Color(0xFF1a1a1a)
            : Color(0xFFf2f2f2),
        appBar: AppBar(
          backgroundColor: ConfigBloc().darkModeOn || _index == 4
              ? Color(0xFF1a1a1a)
              : Color(0xFFf2f2f2),
          iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn
                  ? Color(0xFFf2f2f2)
                  : Color(0xFF1a1a1a)),
          automaticallyImplyLeading: true,
          leading: _index == 4
              ? const SizedBox.shrink()
              : IconButton(
                  icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                  onPressed: () {
                    _index != 0 ? animateBack() : Navigator.pop(context);
                  }),
          elevation: 0,
        ),
        body: FutureBuilder(
            future: usersRef
                .doc(
                    Provider.of<UserData>(context, listen: false).currentUserId)
                .get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Color(0xFFf2f2f2),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 1.0,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Shimmer.fromColors(
                          period: Duration(milliseconds: 1000),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.white,
                          child: RichText(
                              text: TextSpan(
                            children: [
                              TextSpan(text: '\nPlease Wait... '),
                            ],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              }
              AccountHolder user = AccountHolder.fromDoc(snapshot.data);
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
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Center(
                              child: Hero(
                                tag: "survey",
                                child: Material(
                                  color: Colors.transparent,
                                  child: RichText(
                                    textScaleFactor:
                                        MediaQuery.of(context).textScaleFactor,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "Set Up\n",
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w100,
                                            )),
                                        TextSpan(
                                          text: "Your Brand",
                                          style: TextStyle(
                                            fontSize: 40,
                                            color: ConfigBloc().darkModeOn
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
                              duration: Duration(milliseconds: 1200),
                              curve: Curves.easeOutBack,
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Text(
                                  'Set up a unique brand so others can easily recognize and connect with you. Stand out from the other creators. You are unique.',
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
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 40),
                                  child: Container(
                                    width: 250.0,
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                          side: BorderSide(
                                            width: 1.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            'Let\s Start',
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        onPressed: () => animateToPage()),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Provider.of<UserData>(context, listen: false)
                                        .isLoading
                                    ? SizedBox(
                                        height: 1.0,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.grey[100],
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.blue),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Select \nUsername',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 20.0,
                                              height: 1),
                                        ),
                                        DirectionWidget(
                                          text:
                                              'Select a unique username for your brand. The username can be your stage name if you are a music creative. Please note that all usernames are converted to uppercase',
                                          fontSize: 14,
                                        ),
                                        SizedBox(height: 10),
                                        new Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            _userName.toUpperCase(),
                                            style: TextStyle(
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.blueGrey[100]
                                                  : Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                  bottom: 10.0,
                                                  right: 10.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: TextFormField(
                                                  autofocus: true,
                                                  controller: _controller,
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .characters,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  autovalidateMode:
                                                      AutovalidateMode.always,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: ConfigBloc()
                                                            .darkModeOn
                                                        ? Colors.blueGrey[100]
                                                        : Colors.black,
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blue,
                                                          width: 3.0),
                                                    ),
                                                    enabledBorder:
                                                        new UnderlineInputBorder(
                                                            borderSide:
                                                                new BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                    hintText:
                                                        'A unique name to be identified with',
                                                    hintStyle: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                    labelText: 'Username',
                                                  ),
                                                  autofillHints: [
                                                    AutofillHints.name
                                                  ],
                                                  validator: (input) => input!
                                                              .trim()
                                                              .length <
                                                          1
                                                      ? 'Choose a username'
                                                      : input
                                                              .trim()
                                                              .contains(' ')
                                                          ? 'Username cannot contain space, use ( _ or - )'
                                                          : input
                                                                  .trim()
                                                                  .contains('@')
                                                              ? 'Username cannot contain @'
                                                              : null,
                                                  onSaved: (input) =>
                                                      _userName = input!.trim(),
                                                ),
                                              ),
                                            ),
                                            Provider.of<UserData>(context,
                                                        listen: false)
                                                    .isLoading
                                                ? const SizedBox.shrink()
                                                : FadeAnimation(
                                                    0.5,
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 60.0,
                                                                bottom: 40),
                                                        child: Container(
                                                          width: 250.0,
                                                          child: OutlinedButton(
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.blue,
                                                              side: BorderSide(
                                                                  width: 1.0,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Text(
                                                                'Save Username',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              _validate();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            const SizedBox(
                                              height: 50.0,
                                            ),
                                          ],
                                        )
                                      ]),
                                ),
                              ],
                            )),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Provider.of<UserData>(context, listen: false)
                                      .isLoading
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: SizedBox(
                                        height: 1.0,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.grey[100],
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.blue),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: ShakeTransition(
                                    curve: Curves.easeOutBack,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        elevation: 0.0,
                                        foregroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        _submitProfileHandle();
                                      },
                                      child: Text(
                                        'Skip',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  ' Select \nAccount Type',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20.0,
                                      height: 1),
                                ),
                              ),
                              DirectionWidget(
                                text:
                                    'Select an account type to help other users easily identify you for business purposes. You can only select one account type at a time. Some account types might have additional features.',
                                fontSize: 14,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  buildRadios(),
                                  const SizedBox(
                                    height: 50.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Provider.of<UserData>(context, listen: false)
                                        .isLoading
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: SizedBox(
                                          height: 1.0,
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.grey[100],
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.blue),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      elevation: 0.0,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DiscoverUser(
                                            currentUserId: user.id!,
                                            isWelcome: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Skip',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Set\nPhoto',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20.0,
                                        height: 1),
                                  ),
                                ),
                                DirectionWidget(
                                  text:
                                      'Select an avatar or brand picture. You can also provide information about yourself in the bio text field so others can get to know you more.',
                                  fontSize: 14,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () => _handleImageFromGallery,
                                    child: CircleAvatar(
                                        backgroundColor: ConfigBloc().darkModeOn
                                            ? Color(0xFF1a1a1a)
                                            : Color(0xFFf2f2f2),
                                        radius: 80.0,
                                        backgroundImage:
                                            _displayProfileImage()),
                                  ),
                                ),
                                Center(
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
                                        color: Colors.blue,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10.0, right: 10.0),
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
                                              color: Colors.blue, width: 3.0),
                                        ),
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.grey)),
                                        hintText:
                                            'A piece of information about yourself',
                                        hintStyle: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        labelText: 'Bio',
                                      ),
                                      validator: (input) => input!
                                                  .trim()
                                                  .length >
                                              700
                                          ? 'Please, enter a bio of fewer than 700 characters.'
                                          : null,
                                      onSaved: (input) => Provider.of<UserData>(
                                              context,
                                              listen: false)
                                          .setPost6(input!),
                                    ),
                                  ),
                                ),
                                Provider.of<UserData>(context, listen: false)
                                        .isLoading
                                    ? const SizedBox.shrink()
                                    : FadeAnimation(
                                        0.5,
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 60.0, bottom: 40),
                                            child: Container(
                                              width: 250.0,
                                              child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.blue,
                                                    side: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.blue),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      'Save ',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      _submitProfileImage(
                                                          user)),
                                            ),
                                          ),
                                        ),
                                      ),
                              ]),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                            color: Color(0xFF1a1a1a),
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                                child: Loading(
                              title: 'Setting up brand',
                              icon: (Icons.person),
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
