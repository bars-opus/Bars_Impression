import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class SubAccounts extends StatefulWidget {
  final AccountHolder user;
  final String profileHandle;

  SubAccounts({
    required this.user,
    required this.profileHandle,
  });

  @override
  _SubAccountsState createState() => _SubAccountsState();
}

class _SubAccountsState extends State<SubAccounts> {
  // bool _isArtist = false;
  // bool _isProducer = false;
  // bool _isCoverArtDesigner = false;
  // bool _isMusicVideoDirector = false;
  // bool _isDJ = false;
  // bool _isBattleRapper = false;
  // bool _isPhotographer = false;
  // bool _isDancer = false;
  // bool _isVideoVixen = false;
  // bool _isMakeupArtist = false;
  // bool _isBrandInfluencer = false;
  // bool _isBlogger = false;
  // bool _isMC = false;

  // String artist = '';
  // String producer = '';
  // String coverArtDesigner = '';
  // String musicVideoDirector = '';
  // String dJ = '';
  // String battleRapper = '';
  // String photographer = '';
  // String dancer = '';
  // String videoVixen = '';
  // String makeupArtist = '';
  // String brandInfluencer = '';
  // String blogger = '';
  // String mC = '';

  //    "a",
  // "producer",
  // "coverArtDesigner",
  // mMusi_Vide_Director",
  // dDJ",
  // bBattl_Rapper",
  // pPhotographer",
  // dDancer",
  // vVide_Vixen",
  // mMakeu_Artist",
  // "becor_Label",
  // "brand_Influencer",
  // "ml,
  // "MC(Host)",
  // "Fan",

  // final _formKey = GlobalKey<FormState>();
  // String _profileHandle = '';
  // String selectedValue = '';

  // @override
  // void initState() {
  //   super.initState();

  //   super.initState();
  //   SchedulerBinding.instance.addPostFrameCallback((_) {

  //   });
  // }

  // _submit() async {
  //   if (_profileHandle.isEmpty) {
  //     _profileHandle = 'Fan';
  //   }
  //   try {
  //     widget.user.verified!.isEmpty ? _update() : _unVerify();
  //   } catch (e) {
  //     final double width = Responsive.isDesktop(context)
  //         ? 600.0
  //         : MediaQuery.of(context).size.width;
  //     Flushbar(
  //       margin: EdgeInsets.all(8),
  //       boxShadows: [
  //         BoxShadow(
  //           color: Colors.black,
  //           offset: Offset(0.0, 2.0),
  //           blurRadius: 3.0,
  //         )
  //       ],
  //       flushbarPosition: FlushbarPosition.TOP,
  //       flushbarStyle: FlushbarStyle.FLOATING,
  //       titleText: Text(
  //         'Error',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: width > 800 ? 22 : 14,
  //         ),
  //       ),
  //       messageText: Text(
  //         e.toString(),
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: width > 800 ? 20 : 12,
  //         ),
  //       ),
  //       icon: Icon(
  //         Icons.error_outline,
  //         size: 28.0,
  //         color: Colors.blue,
  //       ),
  //       duration: Duration(seconds: 3),
  //       leftBarIndicatorColor: Colors.blue,
  //     )..show(context);
  //   }
  // }

  // _update() {
  //   usersRef
  //       .doc(
  //     widget.user.id,
  //   )
  //       .update({
  //     'profileHandle': _profileHandle,
  //   });

  //   usersAuthorRef
  //       .doc(
  //     widget.user.id,
  //   )
  //       .update({
  //     'profileHandle': _profileHandle,
  //   });
  // }

  // _unVerify() {
  //   usersRef
  //       .doc(
  //     widget.user.id,
  //   )
  //       .update({
  //     'profileHandle': _profileHandle,
  //     'verified': '',
  //   });
  //   usersAuthorRef
  //       .doc(
  //     widget.user.id,
  //   )
  //       .update({
  //     'profileHandle': _profileHandle,
  //     'verified': '',
  //   });
  //   verificationRef.doc(widget.user.id).get().then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  //   FirebaseStorage.instance
  //       .ref('images/validate/${widget.user.id}')
  //       .listAll()
  //       .then((value) {
  //     value.items.forEach((element) {
  //       FirebaseStorage.instance.ref(element.fullPath).delete();
  //     });
  //   });
  // }

  // static const values = <String>[
  //   "Artist",
  //   "Producer",
  //   "Cover_Art_Designer",
  //   "Music_Video_Director",
  //   "DJ",
  //   "Battle_Rapper",
  //   "Photographer",
  //   "Dancer",
  //   "Video_Vixen",
  //   "Makeup_Artist",
  //   "Record_Label",
  //   "Brand_Influencer",
  //   "Blogger",
  //   "MC(Host)",
  //   "Fan",
  // ];

  // Widget buildRadios() => Theme(
  //       data: Theme.of(context).copyWith(
  //         unselectedWidgetColor:
  //             ConfigBloc().darkModeOn ? Colors.white : Colors.black,
  //       ),
  //       child: Column(
  //           children: values.map((value) {
  //         final selected = this.selectedValue == value;
  //         final color = selected
  //             ? Colors.blue
  //             : ConfigBloc().darkModeOn
  //                 ? Colors.white
  //                 : Colors.black;

  //         return RadioListTile<String>(
  //           value: value,
  //           groupValue: selectedValue,
  //           title: Text(
  //             value,
  //             style: TextStyle(
  //               color: color,
  //               fontSize: 14,
  //             ),
  //           ),
  //           activeColor: Colors.blue,
  //           onChanged: (value) => setState(
  //             () {
  //               _profileHandle = this.selectedValue = value!;
  //               _submit();
  //             },
  //           ),
  //         );
  //       }).toList()),
  //     );

  // _pop() {
  //   Navigator.pop(context);
  // }

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog(context);
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'This action would clear your current sub-accounts to enable you re-select new sub-accounts.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'edit',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _clearSubAcount();
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
              'This action would clear your current sub-accounts to enable you re-select new sub-accounts.',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'edit',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _clearSubAcount();
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

  _clearSubAcount() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EditProfileHandleSubAccount(
                  user: widget.user,
                  profileHandle: widget.profileHandle,
                )));
    try {
      usersRef
          .doc(
        widget.user.id,
      )
          .update({
        'subAccountType': '',
      });
    } catch (e) {}
  }

  // _submit() async {
  //   try {
  //     usersRef
  //         .doc(
  //       widget.user.id,
  //     )
  //         .update({
  //       'subAccountType': artist +
  //           producer +
  //           coverArtDesigner +
  //           musicVideoDirector +
  //           dJ +
  //           battleRapper +
  //           photographer +
  //           videoVixen +
  //           blogger +
  //           dancer +
  //           makeupArtist +
  //           brandInfluencer +
  //           mC
  //     });
  //   } catch (e) {
  //     final double width = Responsive.isDesktop(context)
  //         ? 600.0
  //         : MediaQuery.of(context).size.width;
  //     Flushbar(
  //       margin: EdgeInsets.all(8),
  //       boxShadows: [
  //         BoxShadow(
  //           color: Colors.black,
  //           offset: Offset(0.0, 2.0),
  //           blurRadius: 3.0,
  //         )
  //       ],
  //       flushbarPosition: FlushbarPosition.TOP,
  //       flushbarStyle: FlushbarStyle.FLOATING,
  //       titleText: Text(
  //         'Error',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: width > 800 ? 22 : 14,
  //         ),
  //       ),
  //       messageText: Text(
  //         e.toString(),
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: width > 800 ? 20 : 12,
  //         ),
  //       ),
  //       icon: Icon(
  //         Icons.error_outline,
  //         size: 28.0,
  //         color: Colors.blue,
  //       ),
  //       duration: Duration(seconds: 3),
  //       leftBarIndicatorColor: Colors.blue,
  //     )..show(context);
  //   }
  // }

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
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Column(
                      children: [
                        EditProfileInfo(
                          editTitle: 'Select \nSub-account skills',
                          info:
                              'You can add multiple  sub-accounts skills if you offer more than one skill. For instance, main account Artist, sub-accounts: producer, video director.',
                          icon: Icons.account_box_outlined,
                        ),
                        Text(
                          widget.user.subAccountType!,
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: () => _showSelectImageDialog(),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Edit sub_accounts',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
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
          )),
    );
  }
}
