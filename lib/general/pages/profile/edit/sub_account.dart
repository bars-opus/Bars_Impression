import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class SubAccounts extends StatefulWidget {
  final AccountHolderAuthor user;
  final String profileHandle;

  SubAccounts({
    required this.user,
    required this.profileHandle,
  });

  @override
  _SubAccountsState createState() => _SubAccountsState();
}

class _SubAccountsState extends State<SubAccounts> {
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
                fontSize: ResponsiveHelper.responsiveFontSize(context, 16),
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
      // usersRef
      //     .doc(
      //   widget.user.userId,
      // )
      //     .update({
      //   'subAccountType': '',
      // });
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Edit Profile',
          style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Column(
                  children: [
                    EditProfileInfo(
                      editTitle: 'Select \nSub-account skills',
                      info:
                          'You can add multiple  sub-accounts skills if you offer more than one skill. For instance, main account Artist, sub-accounts: producer, video director.',
                      icon: Icons.account_box_outlined,
                    ),
                    // Text(
                    //   widget.user.subAccountType!,
                    //   style: TextStyle(fontSize: 12, color: Colors.blue),
                    // ),
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
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 16),
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
      ),
    );
  }
}
