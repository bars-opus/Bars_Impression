import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

// ignore: must_be_immutable
class DeleteAccount extends StatefulWidget {
  static final id = 'DeleteAccount_screen';
  final AccountHolder user;

  DeleteAccount({
    required this.user,
  });

  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  late PageController _pageController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setNull();
    });
  }

  _submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _showSelectImageDialog('delete');
    }
  }

  _showSelectImageDialog(String from) {
    return Platform.isIOS
        ? _iosBottomSheet(from)
        : _androidDialog(context, from);
  }

  _iosBottomSheet(String from) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              from.startsWith('deactivate')
                  ? 'Are you sure you want to deactivate your account?'
                  : 'Are you sure you want to delete your account?',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  from.startsWith('deactivate') ? 'deactivate' : 'delete',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  from.startsWith('deactivate')
                      ? _deActivate()
                      : _reauthenticate();
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

  _androidDialog(BuildContext parentContext, String from) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              from.startsWith('deactivate')
                  ? 'Are you sure you want to deactivate  your account?'
                  : 'Are you sure you want to delete  your account?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    from.startsWith('deactivate')
                        ? _deActivate()
                        : _reauthenticate();
                  },
                ),
              ),
              Divider(),
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

  _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  static final _auth = FirebaseAuth.instance;

  _deActivate() async {
    try {
      usersRef
          .doc(
        widget.user.id,
      )
          .update({
        'disabledAccount': true,
      });
      await _auth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Intro(),
        ),
      );
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
          "Your profile was deactivated successfully!!!",
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
  }

  void _reauthenticate() async {
    FocusScope.of(context).unfocus();
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
      deletedDeactivatedAccountRef.add({
        'author': widget.user.userName,
        'reason': Provider.of<UserData>(context, listen: false).post3,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
      animateForward();
      _deleteAccount();
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
    }
  }

  void _deleteAccount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    FocusScope.of(context).unfocus();
    try {
      forumsRef
          .doc(currentUserId)
          .collection('userForums')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      postsRef
          .doc(currentUserId)
          .collection('userPosts')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      eventsRef
          .doc(currentUserId)
          .collection('userEvents')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      eventsRef
          .doc(currentUserId)
          .collection('userEvents')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      possitiveRatingRef
          .doc(currentUserId)
          .collection('userPossitiveRating')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });
      possitveRatedRef
          .doc(currentUserId)
          .collection('userPossitiveRated')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      negativeRatingRef
          .doc(currentUserId)
          .collection('userNegativeRating')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      negativeRatingRef
          .doc(currentUserId)
          .collection('userNegativeRating')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });
      followingRef
          .doc(currentUserId)
          .collection('userFollowing')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      followingRef
          .doc(currentUserId)
          .collection('userFollowing')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      followersRef
          .doc(currentUserId)
          .collection('userFollowers')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      activitiesFollowerRef
          .doc(currentUserId)
          .collection('activitiesFollower')
          .where('fromUserId', isEqualTo: currentUserId)
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      activitiesForumRef
          .doc(currentUserId)
          .collection('userActivitiesForum')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      activitiesEventRef
          .doc(currentUserId)
          .collection('userActivitiesEvent')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      activitiesRef
          .doc(currentUserId)
          .collection('userActivities')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      activitiesAdviceRef
          .doc(currentUserId)
          .collection('userActivitiesAdvice')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      usersRef
          .doc(currentUserId)
          .collection('chats')
          .snapshots()
          .forEach((querySnapshot) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.delete();
        }
      });

      FirebaseStorage.instance
          .ref('images/posts/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });

      FirebaseStorage.instance
          .ref('images/events/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });
      FirebaseStorage.instance
          .ref('images/messageImage/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });

      FirebaseStorage.instance
          .ref('images/users/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });

      usersRef.doc(currentUserId).delete();
      FirebaseStorage.instance
          .ref('images/professionalPicture1/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });
      FirebaseStorage.instance
          .ref('images/professionalPicture2/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });
      FirebaseStorage.instance
          .ref('images/professionalPicture3/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });

      FirebaseStorage.instance
          .ref('images/validate/$currentUserId')
          .listAll()
          .then((value) {
        value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });

      usersRef.doc(_auth.currentUser!.uid).get().then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
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
      setNull();
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
  }

  animateBack() {
    _pageController.animateToPage(
      _index - 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateForward() {
    _pageController.animateToPage(
      _index + 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  setNull() {
    Provider.of<UserData>(context, listen: false).setPost2('');
    Provider.of<UserData>(context, listen: false).setPost3('');
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
          leading: _index == 3
              ? const SizedBox.shrink()
              : IconButton(
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
            key: formKey,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            'Why?',
                            style: TextStyle(
                                color: ConfigBloc().darkModeOn
                                    ? Color(0xFFf2f2f2)
                                    : Color(0xFF1a1a1a),
                                fontWeight: FontWeight.bold,
                                fontSize: 40),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'We would like to know why you want to delete your account. This information helps improve our platform.',
                          style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? Color(0xFFf2f2f2)
                                  : Color(0xFF1a1a1a),
                              fontSize: 14),
                        ),
                      ),
                      Divider(color: Colors.grey),
                      GestureDetector(
                        onTap: () {
                          Provider.of<UserData>(context, listen: false)
                              .setPost3('Non-beneficial');
                          animateForward();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: IntroInfo(
                            title: 'Non-beneficial',
                            subTitle:
                                "Bars Impression platform is not helpful to you in any way.",
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ConfigBloc().darkModeOn
                                  ? Color(0xFFf2f2f2)
                                  : Color(0xFF1a1a1a),
                              size: 20,
                            ),
                            onPressed: () {
                              Provider.of<UserData>(context, listen: false)
                                  .setPost3('Non-beneficial');
                              animateForward();
                            },
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey),
                      GestureDetector(
                        onTap: () {
                          Provider.of<UserData>(context, listen: false)
                              .setPost3('Issues with content');
                          animateForward();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: IntroInfo(
                            onPressed: () {
                              Provider.of<UserData>(context, listen: false)
                                  .setPost3('Issues with content');
                              animateForward();
                            },
                            title: 'Issues with content',
                            subTitle:
                                'You don\'t like the type of content shared on Bars Impression.',
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ConfigBloc().darkModeOn
                                  ? Color(0xFFf2f2f2)
                                  : Color(0xFF1a1a1a),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ContentField(
                          labelText: 'Other reasons',
                          hintText: "Specify any other reasons",
                          initialValue: '',
                          onSavedText: (input) =>
                              Provider.of<UserData>(context, listen: false)
                                  .setPost3(input),
                          onValidateText: () {},
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      AvatarCircularButton(
                        onPressed: () {
                          animateForward();
                        },
                        buttonText: "Next",
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            'Deactivate your account instead?',
                            style: TextStyle(
                                color: ConfigBloc().darkModeOn
                                    ? Color(0xFFf2f2f2)
                                    : Color(0xFF1a1a1a),
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () {
                            _showSelectImageDialog('deactivate');
                          },
                          child: IntroInfo(
                            title: 'Deactivating your account is temporary.',
                            subTitle:
                                "Your information and contents would be hidden until you reactivate your account again",
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.transparent,
                              size: 20,
                            ),
                            onPressed: () {
                              _showSelectImageDialog('deactivate');
                            },
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () {
                            animateForward();
                          },
                          child: IntroInfo(
                            onPressed: () {
                              animateForward();
                            },
                            title: 'Deleting your account is permanent.',
                            subTitle:
                                'Deleting your account would erase all your user data and every content you have created. Your account cannot be recovered after you have deleted it.',
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ConfigBloc().darkModeOn
                                  ? Color(0xFFf2f2f2)
                                  : Color(0xFF1a1a1a),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: width * 2,
                    width: double.infinity,
                    child: Column(
                      children: [
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
                              'Enter your password to delete your account.',
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
                              fontSize: 12.0,
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
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
                SingleChildScrollView(
                  child: Container(
                      color: Colors.grey[600],
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Loading(
                          icon: (Icons.delete_forever),
                          title: 'Deleting account',
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
