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
  String _accountType = '';
  String selectedStoreValue = '';
  String selectedAccountValue = '';

  @override
  void initState() {
    super.initState();
    _storeType = widget.user.storeType!;
    _accountType = widget.user.accountType!;
    selectedStoreValue = _storeType.isEmpty ? values.last : _storeType;
    selectedAccountValue = _accountType.isEmpty ? values.last : _accountType;
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

  _updateAccountType() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (_accountType.isEmpty) {
      _accountType = 'Client';
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(
      usersAuthorRef.doc(widget.user.userId),
      {
        'accountType': _accountType,
      },
    );

    batch.update(
      userProfessionalRef.doc(widget.user.userId),
      {
        'accountType': _accountType,
      },
    );

    try {
      await batch.commit();
      // await HiveUtils.updateUserStore(
      //     context,
      //     _provider.userStore!.storeLogomageUrl,
      //     _provider.userStore!.storeType,
      //     _accountType);
      await HiveUtils.updateAuthorHive(
          context,
          _provider.user!.userName!,
          _provider.user!.profileImageUrl!,
          _provider.user!.dynamicLink!,
          _provider.user!.storeType!,
          _accountType);
      // _updateAuthorHive(_storeType);
    } catch (error) {
      // Handle the error appropriately
    }
  }

  _updateStore() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (_storeType.isEmpty) {
      _storeType = 'Shop';
    }

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
      await batch.commit();
      // await HiveUtils.updateUserStore(
      //     context,
      //     _provider.userStore!.storeLogomageUrl,
      //     _storeType,
      //     _provider.userStore!.accountType!);
      await HiveUtils.updateAuthorHive(
          context,
          _provider.user!.userName!,
          _provider.user!.profileImageUrl!,
          _provider.user!.dynamicLink!,
          _storeType,
          _provider.user!.accountType!);
      // _updateAuthorHive(_storeType);
    } catch (error) {
      // Handle the error appropriately
    }
  }

  // _updateAuthorHive(String storeType) {
  //   final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');
  //   final accountUserStoreBox = Hive.box<UserStoreModel>('accountUserStore');

  //   var _provider = Provider.of<UserData>(context, listen: false);

  //   // Create a new instance of AccountHolderAuthor with the updated name
  //   var updatedAccountAuthor = AccountHolderAuthor(
  //     isShop: _provider.user!.isShop,
  //     // name: _provider.user!.name,
  //     bio: _provider.user!.bio,
  //     disabledAccount: _provider.user!.disabledAccount,
  //     dynamicLink: _provider.user!.dynamicLink,
  //     lastActiveDate: _provider.user!.lastActiveDate,
  //     storeType: storeType,
  //     profileImageUrl: _provider.user!.profileImageUrl,
  //     reportConfirmed: _provider.user!.reportConfirmed,
  //     userId: _provider.user!.userId,
  //     userName: _provider.user!.userName,
  //     verified: _provider.user!.verified,
  //     // isShop: _provider.user!.isShop,
  //     disableChat: _provider.user!.disableChat,
  //   );

  //   var updatedUserStore = UserStoreModel(
  //       userId: _provider.userStore!.userId,
  //       userName: _provider.userStore!.userName,
  //       storeLogomageUrl: _provider.userStore!.storeLogomageUrl,
  //       storeType: storeType,
  //       verified: _provider.userStore!.verified,
  //       terms: _provider.userStore!.terms,
  //       city: _provider.userStore!.city,
  //       country: _provider.userStore!.country,
  //       overview: _provider.userStore!.overview,
  //       noBooking: _provider.userStore!.noBooking,
  //       awards: _provider.userStore!.awards,
  //       contacts: _provider.userStore!.contacts,
  //       links: _provider.userStore!.links,
  //       priceTags: _provider.userStore!.priceTags,
  //       services: _provider.userStore!.services,
  //       professionalImageUrls: _provider.userStore!.professionalImageUrls,
  //       dynamicLink: _provider.userStore!.dynamicLink,
  //       randomId: _provider.userStore!.randomId,
  //       currency: _provider.userStore!.currency,
  //       transferRecepientId: _provider.userStore!.transferRecepientId);

  //   // Put the new object back into the box with the same key
  //       accountUserStoreBox.put(updatedUserStore.userId, updatedUserStore);

  //   accountAuthorbox.put(updatedAccountAuthor.userId, updatedAccountAuthor);
  // }

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
    "Salon",
    "Barbershop",
    "Spa",
    // "Blogger",
    // "Brand_Influencer",
    // 'Caterers',
    // "Choire",
    // "Content_creator",
    // "Dancer",
    // 'Decorator',
    // "DJ",
    // "Event_organiser",
    // "Graphic_Designer",
    // "Instrumentalist",
    // "Makeup_Salon",
    // "MC(Host)",
    // "Videographer",
    // "Photographer",
    // "Producer",
    // 'Sound_and_Light',
    // "Record_Label",
    // "Video_Vixen",
    // "Fan",
  ];

  Widget buildRadios(BuildContext context) => Column(
          children: values.map((value) {
        final selected = this.selectedStoreValue == value;
        final color =
            selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

        return RadioTheme(
          data: RadioThemeData(
              fillColor: MaterialStateProperty.all(
                  Theme.of(context).secondaryHeaderColor)),
          child: RadioListTile<String>(
            value: value,
            groupValue: selectedStoreValue,
            title: Text(
              value,
              style: TextStyle(
                  color: color,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  fontWeight: this.selectedStoreValue == value
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
            activeColor: Colors.blue,
            onChanged: (value) => setState(
              () {
                _storeType = this.selectedStoreValue = value!;
                Navigator.pop(context);
                _updateStore();
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

  _selectStoreype(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_provider.isLoading)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgress(
                    isMini: true,
                    indicatorColor: Colors.blue,
                  ),
                ),
              ),
            // _directionWidget(
            //   'Select Account Type',
            //   '',
            //   false,
            //   _provider.int2 == 2,
            // ),
            buildRadios(context),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheetStoreType(BuildContext context) {
    // bool _isAuthor = user.userId == widget.currentUserId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 600),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            child: MyBottomModelSheetAction(
              actions: [
                Icon(
                  size: ResponsiveHelper.responsiveHeight(context, 25),
                  Icons.horizontal_rule,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                _selectStoreype(context),
              ],
            ),
          ),
        );
      },
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

  static const accountType = <String>[
    "Client",
    "Shop",
    "Worker",
  ];

  Widget buildAccountTypeRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Column(
            children: accountType.map((value) {
          var _provider = Provider.of<UserData>(context, listen: false);

          final selected = this.selectedAccountValue == value;
          final color =
              selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

          return RadioListTile<String>(
            value: value,
            groupValue: selectedAccountValue,
            title: Text(
              value,
              style: TextStyle(
                  color: color,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  fontWeight: this.selectedAccountValue == value
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
            activeColor: Colors.blue,
            onChanged: (value) => setState(
              () {
                _accountType = this.selectedAccountValue = value!;
                _updateAccountType();
                if (_accountType == 'Shop') _showBottomSheetStoreType(context);
              },
            ),
          );
        }).toList()),
      );

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
                            children: <Widget>[buildAccountTypeRadios()],
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
