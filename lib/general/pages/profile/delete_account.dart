import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class DeleteAccount extends StatefulWidget {
  static final id = 'DeleteAccount_screen';
  final AccountHolder user;
   final String reason;

  DeleteAccount({
    required this.user,
     required this.reason,
  });

  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isHidden = true;

  _submit() async {
    if (formKey.currentState!.validate() & !_isLoading) {
      formKey.currentState!.save();
      _showSelectImageDialog();
    }
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
              'Are you sure you want to delete your account',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'delete',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _reauthenticate();
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
            title: Text('Are you sure you want to delete this your account?'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('delete'),
                onPressed: () {
                  Navigator.pop(context);
                  _reauthenticate();
                },
              ),
              SimpleDialogOption(
                child: Text('cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  static final _auth = FirebaseAuth.instance;

  void _reauthenticate() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });
    try {
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        backgroundColor: Color(0xFF1a1a1a),
        margin: EdgeInsets.all(8),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Color(0xFF1a1a1a),
        progressIndicatorValueColor: AlwaysStoppedAnimation(Colors.blue),
        flushbarPosition: FlushbarPosition.TOP,
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        titleText: Text(
          'Deleting Account',
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          "Please wait...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      )..show(context);

      await _auth.signInWithEmailAndPassword(
        email: widget.user.email!,
        password: Provider.of<UserData>(context, listen: false).post2,
      );

      _delelteAccount();
    } catch (e) {
      final double width = MediaQuery.of(context).size.width;
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        titleText: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            'Request Failed',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
        ),
        messageText: Container(
            child: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            result.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
        )),
        icon: Icon(Icons.error_outline,
            size: width > 800 ? 50 : 28.0, color: Colors.blue),
        mainButton: OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: Colors.transparent,
            side: BorderSide(width: 1.0, color: Colors.transparent),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text("Ok",
              style: TextStyle(
                color: Colors.blue,
                fontSize: width > 800 ? 24 : 16,
              )),
        ),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _delelteAccount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;

    try {
      await forumsRef
          .doc(currentUserId)
          .collection('userForums')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      await postsRef
          .doc(currentUserId)
          .collection('userPosts')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      await FirebaseStorage.instance
          .ref('images/posts/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });

      await eventsRef
          .doc(currentUserId)
          .collection('userEvents')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });
      await FirebaseStorage.instance
          .ref('images/events/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });

      await usersRef
          .doc(currentUserId)
          .collection('chats')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      await FirebaseStorage.instance
          .ref('images/messageImage/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });

      await FirebaseStorage.instance
          .ref('images/users/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });

      usersRef.doc(currentUserId).delete();
      await FirebaseStorage.instance
          .ref('images/professionalPicture1/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });
      await FirebaseStorage.instance
          .ref('images/professionalPicture2/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });
      await FirebaseStorage.instance
          .ref('images/professionalPicture3/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });
      await FirebaseStorage.instance
          .ref('images/validate/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });

      await _auth.currentUser!.delete().then((value) async {
        await _auth.signOut();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomeScreen(),
            ),
            (Route<dynamic> route) => false);
      });
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      print(result);

      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        backgroundColor: Color(0xFF1a1a1a),
        margin: EdgeInsets.all(8),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        titleText: Text(
          'Request Failed',
          style: TextStyle(color: Colors.white),
        ),
        messageText: Container(
            child: Text(
          result.toString(),
          style: TextStyle(color: Colors.white),
        )),
        icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue),
        mainButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
          ),
          onPressed: () => Navigator.pop(context),
          child: Text("Ok",
              style: TextStyle(
                color: Colors.blue,
              )),
        ),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
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
                Navigator.pop(context);
              }),
          automaticallyImplyLeading: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: _isLoading
              ? Container(
                  height: width * 2,
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Shimmer.fromColors(
                        period: Duration(milliseconds: 1000),
                        baseColor: Colors.grey,
                        highlightColor: Colors.blue,
                        child: NoContents(
                          icon: (Icons.delete_forever_outlined),
                          title: 'Deleting Account',
                          subTitle: 'Just a moment...',
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                          height: 1.0,
                          child: LinearProgressIndicator(
                            backgroundColor: ConfigBloc().darkModeOn
                                ? Color(0xFF1a1a1a)
                                : Colors.grey[100],
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          )),
                      const SizedBox(height: 100),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Form(
                    key: formKey,
                    child: Container(
                      height: width * 2,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Center(
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                'Delete \nAccount',
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10),
                              child: Text(
                                _isLoading
                                    ? ''
                                    : 'Deleting your account would erase all your user data and every content you have created. Your account cannot be recovered after you have deleted it.',
                                style: TextStyle(
                                    color: ConfigBloc().darkModeOn
                                        ? Color(0xFFf2f2f2)
                                        : Color(0xFF1a1a1a),
                                    fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width > 800 ? 20 : 14,
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontSize: width > 800 ? 22 : 14,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Your Bars Impression password',
                                  hintStyle: TextStyle(
                                    fontSize: width > 800 ? 20 : 14,
                                    color: Colors.blueGrey,
                                  ),
                                  suffixIcon: IconButton(
                                      icon: _isHidden
                                          ? Icon(
                                              Icons.visibility_off,
                                              size: width > 800 ? 35 : 20.0,
                                              color: Colors.grey,
                                            )
                                          : Icon(
                                              Icons.visibility,
                                              size: width > 800 ? 35 : 20.0,
                                              color: Colors.white,
                                            ),
                                      onPressed: _toggleVisibility),
                                  icon: Icon(
                                    Icons.lock,
                                    size: width > 800 ? 35 : 20.0,
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.grey))),
                              autofillHints: [AutofillHints.password],
                              onChanged: (input) =>
                                  Provider.of<UserData>(context, listen: false)
                                      .setPost2(input),
                              onSaved: (input) =>
                                  Provider.of<UserData>(context, listen: false)
                                      .setPost2(input!),
                              validator: (input) => input!.length < 8
                                  ? 'Password must be at least 8 characters'
                                  : null,
                              obscureText: _isHidden,
                            ),
                          ),
                          SizedBox(height: 60),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _submit(),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                height: 40,
                                width: 40,
                                child: IconButton(
                                  icon: Icon(Icons.delete_forever),
                                  iconSize: 25,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.black
                                      : Colors.white,
                                  onPressed: () => _submit(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
