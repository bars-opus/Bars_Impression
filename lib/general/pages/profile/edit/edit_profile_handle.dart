import 'package:bars/utilities/exports.dart';
import 'package:hive/hive.dart';

class EditProfileHandle extends StatefulWidget {
  final AccountHolderAuthor user;

  EditProfileHandle({
    required this.user,
  });

  @override
  _EditProfileHandleState createState() => _EditProfileHandleState();
}

class _EditProfileHandleState extends State<EditProfileHandle> {
  final _formKey = GlobalKey<FormState>();
  String _profileHandle = '';
  String selectedValue = '';

  @override
  void initState() {
    super.initState();
    _profileHandle = widget.user.profileHandle!;
    selectedValue = _profileHandle.isEmpty ? values.last : _profileHandle;
  }

  void _showBottomSheetErrorMessage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: 'Failed to update profile handle.',
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  _submit() async {
    if (_profileHandle.isEmpty) {
      _profileHandle = 'Fan';
    }
    try {
      // widget.user.verified! ? _update() : _unVerify();
      _update();
    } catch (e) {
      _showBottomSheetErrorMessage();
    }
  }

  _update() {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(
      usersAuthorRef.doc(widget.user.userId),
      {
        'profileHandle': _profileHandle,
      },
    );

    batch.update(
      userProfessionalRef.doc(widget.user.userId),
      {
        'profileHandle': _profileHandle,
      },
    );

    try {
      batch.commit();
      _updateAuthorHive(_profileHandle);
    } catch (error) {
      // Handle the error appropriately
    }
  }

  _updateAuthorHive(String profileHandle) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      name: _provider.user!.name,
      bio: _provider.user!.bio,
      disabledAccount: _provider.user!.disabledAccount,
      dynamicLink: _provider.user!.dynamicLink,
      lastActiveDate: _provider.user!.lastActiveDate,
      profileHandle: profileHandle,
      profileImageUrl: _provider.user!.profileImageUrl,
      reportConfirmed: _provider.user!.reportConfirmed,
      userId: _provider.user!.userId,
      userName: _provider.user!.userName,
      verified: _provider.user!.verified,
      privateAccount: _provider.user!.privateAccount,
      disableChat: _provider.user!.disableChat,
    );

    // Put the new object back into the box with the same key
    accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  }

  _unVerify() {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(
      usersAuthorRef.doc(widget.user.userId),
      {
        'profileHandle': _profileHandle,
        'verified': false,
      },
    );

    batch.update(
      userProfessionalRef.doc(widget.user.userId),
      {
        'profileHandle': _profileHandle,
        'verified': false,
      },
    );

    verificationRef.doc(widget.user.userId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    FirebaseStorage.instance
        .ref('images/validate/${widget.user.userId}')
        .listAll()
        .then((value) {
      value.items.forEach((element) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      });
    });
  }

  static const values = <String>[
    "Artist",
    "Band",
    "Battle_Rapper",
    "Blogger",
    "Brand_Influencer",
    'Caterers',
    "Choire",
    "Content_creator",
    // "Cover_Art_Designer",
    "Dancer",
    'Decorator',
    "DJ",
    "Event_organiser",
    "Graphic_Designer",
    "Instrumentalist",
    "Makeup_Artist",
    "MC(Host)",
    "Videographer",
    "Photographer",
    "Producer",
    'Sound_and_Light',
    "Record_Label",
    "Video_Vixen",
    "Fan",

    // "Producer",
    // "DJ",
    // "Dancer",
    // "Music_Video_Director",
    // "Content_creator",
    // "Photographer",
    // "Record_Label",
    // "Brand_Influencer",
    // "Event_organiser",
    // "Band",
    // "Instrumentalist",
    // "Cover_Art_Designer",
    // "Makeup_Artist",
    // "Video_Vixen",
    // "Blogger",
    // "MC(Host)",
    // "Choire",
    // "Battle_Rapper",
    // "Fan",
  ];

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Column(
            children: values.map((value) {
          final selected = this.selectedValue == value;
          final color =
              selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

          return RadioListTile<String>(
            value: value,
            groupValue: selectedValue,
            title: Text(
              value,
              style: TextStyle(
                  color: color,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  fontWeight: this.selectedValue == value
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
            activeColor: Colors.blue,
            onChanged: (value) => setState(
              () {
                _profileHandle = this.selectedValue = value!;
                _submit();
              },
            ),
          );
        }).toList()),
      );

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomMoreAboutAccountTypes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: MoreAboutAccountTypes());
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditProfileScaffold(
      title: '',
      widget: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EditProfileInfo(
                  editTitle: 'Select \nAccount Type',
                  info:
                      'Choose an account type that allows other users to easily identify you for business purposes. You can select only one account type at a time.',
                  icon: Icons.account_circle,
                  showMore: true,
                  moreOnPressed: () {
                    _showBottomMoreAboutAccountTypes();
                  },
                ),
                // _profileHandle.startsWith('Fan') ||
                //         _profileHandle.startsWith('Record_Label')
                //     ? const SizedBox.shrink()
                //     : GestureDetector(
                //         onTap: () => navigateToPage(
                //             context,
                //             SubAccounts(
                //               user: widget.user,
                //               profileHandle: _profileHandle,
                //             )),
                //         child: Row(
                //           children: [
                //             Icon(
                //               Icons.add,
                //               color: Colors.blue,
                //               size: 20,
                //             ),
                //             Text(
                //               'Add sub-accounts',
                //               style: TextStyle(
                //                 color: Colors.blue,
                //                 fontSize: ResponsiveHelper.responsiveFontSize(
                //                     context, 12.0),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[buildRadios()],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
