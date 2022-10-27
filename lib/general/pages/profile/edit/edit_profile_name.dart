import 'package:bars/utilities/exports.dart';

class EditProfileName extends StatefulWidget {
  final AccountHolder user;

  EditProfileName({
    required this.user,
  });

  @override
  _EditProfileNameState createState() => _EditProfileNameState();
}

class _EditProfileNameState extends State<EditProfileName> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  bool _isLoading = false;
  String query = "";
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.user.userName,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _validate(BuildContext context) async {
    if (_formKey.currentState!.validate() & !_isLoading) {
      _formKey.currentState!.save();

      if (_userName != widget.user.userName) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('users')
            .where('userName', isEqualTo: _userName)
            .get();

        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length > 0) {
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
              'Sorry $_userName is already in use by another user. Try using a different name',
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
          final double width = Responsive.isDesktop(context)
              ? 600.0
              : MediaQuery.of(context).size.width;
          if (_formKey.currentState!.validate() && !_isLoading) {
            _formKey.currentState!.save();
            FocusScope.of(context).unfocus();
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
            try {
              widget.user.verified!.isEmpty
                  ? usersRef
                      .doc(
                      widget.user.id,
                    )
                      .update({
                      'userName': _userName,
                    })
                  : _unVerify();

              widget.user.verified!.isEmpty
                  ? Navigator.pop(context)
                  : _pop(context);

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
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width > 800 ? 22 : 14,
                  ),
                ),
                messageText: Text(
                  'Username changed successfully',
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
                duration: Duration(seconds: 1),
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
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        }
      } else {
        widget.user.verified!.isEmpty ? Navigator.pop(context) : _pop(context);
      }
    }
  }

  _unVerify() {
    usersRef
        .doc(
      widget.user.id,
    )
        .update({
      'userName': _userName,
      'verified': '',
    });
    verificationRef.doc(widget.user.id).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    FirebaseStorage.instance
        .ref('images/validate/${widget.user.id}')
        .listAll()
        .then((value) {
      value.items.forEach((element) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      });
    });
  }

  _pop(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            title: Text(
              'Edit Profile ',
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    EditProfileInfo(
                                        editTitle: 'Select \nUsername',
                                        info:
                                            'Select a unique username for your brand. The username can be your stage name if you are a music creator. Please note that all usernames are converted to uppercase.',
                                        icon: MdiIcons.accountDetails),
                                    Hero(
                                      tag: 'name',
                                      child: new Material(
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
                                              // onChanged: (input) {
                                              //   _validate();
                                              // },
                                              controller: _controller,
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              keyboardType:
                                                  TextInputType.multiline,

                                              maxLines: null,
                                              autovalidateMode:
                                                  AutovalidateMode.always,
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
                                                  : input.trim().contains(' ')
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
                                        _isLoading
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30.0),
                                                child: SizedBox(
                                                  height: 2.0,
                                                  child:
                                                      LinearProgressIndicator(
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.white
                                                            : Color(0xFF1d2323),
                                                    elevation: 20.0,
                                                    onPrimary: Colors.blue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _validate(context);
                                                  },
                                                  child: Text(
                                                    'Save Profile',
                                                    style: TextStyle(
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        SizedBox(
                                          height: 50.0,
                                        ),
                                      ],
                                    )
                                  ]),
                            )
                          ],
                        ))),
              ),
            ),
          )),
    );
  }
}
