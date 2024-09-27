import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class SubAccounts extends StatefulWidget {
  final AccountHolderAuthor user;
  final String storeType;

  SubAccounts({
    required this.user,
    required this.storeType,
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
                  // _clearSubAcount();
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
              Divider(
                thickness: .2,
              ),
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
                    // _clearSubAcount();
                  },
                ),
              ),
              Divider(
                thickness: .2,
              ),
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

  // _clearSubAcount() {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => EditstoreTypeSubAccount(
  //                 user: widget.user,
  //                 storeType: widget.storeType,
  //               )));
  //   try {} catch (e) {}
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
                          'You can add multiple  sub-accounts skills if you offer more than one skill. For instance, main account Salon, sub-accounts: producer, video director.',
                      icon: Icons.account_box_outlined,
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
