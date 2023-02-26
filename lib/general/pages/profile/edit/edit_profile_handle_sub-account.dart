import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EditProfileHandleSubAccount extends StatefulWidget {
  final AccountHolder user;

  final String profileHandle;

  EditProfileHandleSubAccount({
    required this.user,
    required this.profileHandle,
  });

  @override
  _EditProfileHandleSubAccountState createState() =>
      _EditProfileHandleSubAccountState();
}

class _EditProfileHandleSubAccountState
    extends State<EditProfileHandleSubAccount> {
  bool _isArtist = false;
  bool _isProducer = false;
  bool _isCoverArtDesigner = false;
  bool _isMusicVideoDirector = false;
  bool _isDJ = false;
  bool _isBattleRapper = false;
  bool _isPhotographer = false;
  bool _isDancer = false;
  bool _isVideoVixen = false;
  bool _isMakeupArtist = false;
  bool _isBrandInfluencer = false;
  bool _isBlogger = false;
  bool _isMC = false;
  int _selectCount = 0;

  String artist = '';
  String producer = '';
  String coverArtDesigner = '';
  String musicVideoDirector = '';
  String dJ = '';
  String battleRapper = '';
  String photographer = '';
  String dancer = '';
  String videoVixen = '';
  String makeupArtist = '';
  String brandInfluencer = '';
  String blogger = '';
  String mC = '';

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog(context);
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'You can select only three sub-accounts',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[],
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
              'You can select only three sub-accounts',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
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

  _submit() async {
    try {
      Navigator.pop(context);
      usersRef
          .doc(
        widget.user.id,
      )
          .update({
        'subAccountType': artist +
            producer +
            coverArtDesigner +
            musicVideoDirector +
            dJ +
            battleRapper +
            photographer +
            videoVixen +
            blogger +
            dancer +
            makeupArtist +
            brandInfluencer +
            mC
      });
    } catch (e) {
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
          Icons.error_outline,
          size: 28.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool _isArtist =
    //     widget.user.subAccountType!.contains('Artist') ? true : false;

    // bool _isProducer =
    //     widget.user.subAccountType!.contains('Producer') ? true : false;
    // bool _isCoverArtDesigner =
    //     widget.user.subAccountType!.contains('Cover_Art_Designer')
    //         ? true
    //         : false;
    // bool _isMusicVideoDirector =
    //     widget.user.subAccountType!.contains('Musi_Vide_Director')
    //         ? true
    //         : false;
    // bool _isDJ = widget.user.subAccountType!.contains('DJ') ? true : false;
    // bool _isBattleRapper =
    //     widget.user.subAccountType!.contains('Battle_Rapper') ? true : false;
    // bool _isPhotographer =
    //     widget.user.subAccountType!.contains('Photographer') ? true : false;
    // bool _isDancer =
    //     widget.user.subAccountType!.contains('Dancer') ? true : false;
    // bool _isVideoVixen =
    //     widget.user.subAccountType!.contains('Video_Vixen') ? true : false;
    // bool _isMakeupArtist =
    //     widget.user.subAccountType!.contains('Makeup_Artist') ? true : false;
    // bool _isBrandInfluencer =
    //     widget.user.subAccountType!.contains('Brand_Influencer') ? true : false;
    // bool _isBlogger =
    //     widget.user.subAccountType!.contains('Blogger') ? true : false;
    // bool _isMC =
    //     widget.user.subAccountType!.contains('MC(Host)') ? true : false;

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
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EditProfileInfo(
                            editTitle: 'Select \nSub-account skills',
                            info:
                                'You can add multiple  sub-accounts skills if you offer more than one skill. For instance, main account Artist, sub-accounts: producer, video director.',
                            icon: Icons.account_box_outlined,
                          ),
                          _isArtist ||
                                  _isProducer ||
                                  _isBattleRapper ||
                                  _isBlogger ||
                                  _isBrandInfluencer ||
                                  _isCoverArtDesigner ||
                                  _isDJ ||
                                  _isDancer ||
                                  _isMakeupArtist ||
                                  _isMusicVideoDirector ||
                                  _isPhotographer ||
                                  _isProducer ||
                                  _isVideoVixen
                              ? Align(
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
                                        _submit();
                                      },
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ))
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            artist +
                                producer +
                                coverArtDesigner +
                                musicVideoDirector +
                                dJ +
                                battleRapper +
                                photographer +
                                videoVixen +
                                blogger +
                                dancer +
                                makeupArtist +
                                brandInfluencer +
                                mC,
                            // Provider.of<UserData>(context, listen: false)
                            //     .post15
                            //     .toString(),
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          widget.profileHandle.startsWith('Artist')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Artist',
                                  _isArtist,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isArtist = !_isArtist;
                                            artist =
                                                _isArtist ? ' | Artist' : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('Producer')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Producer',
                                  _isProducer,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isProducer = !_isProducer;
                                            producer = _isProducer
                                                ? ' | Producer'
                                                : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('Cover')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Cover_Art_Designer',
                                  _isCoverArtDesigner,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isCoverArtDesigner =
                                                !_isCoverArtDesigner;
                                            coverArtDesigner =
                                                _isCoverArtDesigner
                                                    ? ' | Cover_Art_Designer'
                                                    : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('Music')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Music_Video_Director',
                                  _isMusicVideoDirector,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isMusicVideoDirector =
                                                !_isMusicVideoDirector;
                                            musicVideoDirector =
                                                _isMusicVideoDirector
                                                    ? ' | Music_Video_Director'
                                                    : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('DJ')
                              ? const SizedBox.shrink()
                              : tile(
                                  'DJ',
                                  _isDJ,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isDJ = !_isDJ;
                                            dJ = _isDJ ? ' | DJ' : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('Battle_Rapper')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Battle_Rapper',
                                  _isBattleRapper,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isBattleRapper = !_isBattleRapper;
                                            battleRapper = _isBattleRapper
                                                ? ' | Battle_Rapper'
                                                : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('Photographer')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Photographer',
                                  _isPhotographer,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isPhotographer = !_isPhotographer;
                                            photographer = _isPhotographer
                                                ? ' | Photographer'
                                                : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('Dancer')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Dancer',
                                  _isDancer,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isDancer = !_isDancer;
                                            dancer =
                                                _isDancer ? ' | Dancer' : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('Video_Vixen')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Video_Vixen',
                                  _isVideoVixen,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isVideoVixen = !_isVideoVixen;
                                            videoVixen = _isVideoVixen
                                                ? ' | Video_Vixen'
                                                : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('Makeup_Artist')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Makeup_Artist',
                                  _isMakeupArtist,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isMakeupArtist = !_isMakeupArtist;
                                            makeupArtist = _isMakeupArtist
                                                ? ' | Makeup_Artist'
                                                : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('Brand_Influencer')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Brand_Influencer',
                                  _isBrandInfluencer,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isBrandInfluencer =
                                                !_isBrandInfluencer;
                                            brandInfluencer = _isBrandInfluencer
                                                ? ' | Brand_Influencer'
                                                : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('Blogger')
                              ? const SizedBox.shrink()
                              : tile(
                                  'Blogger',
                                  _isBlogger,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isBlogger = !_isBlogger;
                                            blogger =
                                                _isBlogger ? ' | Blogger' : '';
                                            _selectCount++;
                                          });
                                        }),
                          widget.profileHandle.startsWith('MC(Host)')
                              ? const SizedBox.shrink()
                              : tile(
                                  'MC(Host)',
                                  _isMC,
                                  _selectCount == 3
                                      ? () {
                                          _showSelectImageDialog();
                                        }
                                      : () {
                                          setState(() {
                                            _isMC = !_isMC;
                                            mC = _isMC ? ' | MC(Host)' : '';
                                            _selectCount++;
                                          });
                                        })
                        ],
                      )),
                ),
              ),
            ),
          )),
    );
  }

  Widget tile(
    String title,
    bool isTaped,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(
        title,
        style:
            TextStyle(fontSize: 14, color: isTaped ? Colors.blue : Colors.grey),
      ),
      trailing: Icon(
          color: isTaped ? Colors.blue : Colors.grey,
          isTaped ? Icons.check_box_rounded : Icons.check_box_outline_blank),
      onTap: onTap,
    );
  }
}
