import 'package:bars/utilities/exports.dart';
import 'package:hive/hive.dart';

class EditstoreType extends StatefulWidget {
  final AccountHolderAuthor user;

  EditstoreType({
    required this.user,
  });

  @override
  _EditstoreTypeState createState() => _EditstoreTypeState();
}

class _EditstoreTypeState extends State<EditstoreType> {
  final _formKey = GlobalKey<FormState>();
  String _storeType = '';
  String selectedValue = '';

  @override
  void initState() {
    super.initState();
    _storeType = widget.user.storeType!;
    selectedValue = _storeType.isEmpty ? values.last : _storeType;
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
    if (_storeType.isEmpty) {
      _storeType = 'Fan';
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
        'storeType': _storeType,
      },
    );

    batch.update(
      userProfessionalRef.doc(widget.user.userId),
      {
        'storeType': _storeType,
      },
    );

    try {
      batch.commit();
      _updateAuthorHive(_storeType);
    } catch (error) {
      // Handle the error appropriately
    }
  }

  _updateAuthorHive(String storeType) {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of AccountHolderAuthor with the updated name
    var updatedAccountAuthor = AccountHolderAuthor(
      // name: _provider.user!.name,
      bio: _provider.user!.bio,
      disabledAccount: _provider.user!.disabledAccount,
      dynamicLink: _provider.user!.dynamicLink,
      lastActiveDate: _provider.user!.lastActiveDate,
      storeType: storeType,
      profileImageUrl: _provider.user!.profileImageUrl,
      reportConfirmed: _provider.user!.reportConfirmed,
      userId: _provider.user!.userId,
      userName: _provider.user!.userName,
      verified: _provider.user!.verified,
      // privateAccount: _provider.user!.privateAccount,
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
        'storeType': _storeType,
        'verified': false,
      },
    );

    batch.update(
      userProfessionalRef.doc(widget.user.userId),
      {
        'storeType': _storeType,
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
  ];

  Widget buildRadios() => Column(
          children: values.map((value) {
        final selected = this.selectedValue == value;
        final color =
            selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

        return RadioTheme(
          data: RadioThemeData(
              fillColor: MaterialStateProperty.all(
                  Theme.of(context).secondaryHeaderColor)),
          child: RadioListTile<String>(
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
                _storeType = this.selectedValue = value!;
                _submit();
              },
            ),
          ),
        );
      }).toList());

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
                      'Choose an account type that allows other users to easily identify you for business purposes. You can select only one account type at a time. If you are not sure about the account type to select, Learn',
                  icon: Icons.account_circle,
                  showMore: true,
                  moreOnPressed: () {
                    _showBottomMoreAboutAccountTypes();
                  },
                ),
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
