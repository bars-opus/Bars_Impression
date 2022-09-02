import 'package:bars/utilities/exports.dart';

class EditProfileHandle extends StatefulWidget {
  final AccountHolder user;

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

  _submit() async {
    if (_profileHandle.isEmpty) {
      _profileHandle = 'Fan';
    }
    try {
      widget.user.verified!.isEmpty
          ? usersRef
              .doc(
              widget.user.id,
            )
              .update({
              'profileHandle': _profileHandle,
            })
          : _unVerify();
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

  _unVerify() {
    usersRef
        .doc(
      widget.user.id,
    )
        .update({
      'profileHandle': _profileHandle,
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

  static const values = <String>[
    "Artist",
    "Producer",
    "Cover_Art_Designer",
    "Music_Video_Director",
    "DJ",
    "Battle_Rapper",
    "Photographer",
    "Dancer",
    "Video_Vixen",
    "Makeup_Artist",
    "Record_Label",
    "Brand_Influencer",
    "Blogger",
    "MC(Host)",
    "Fan",
  ];

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: values.map((value) {
          final selected = this.selectedValue == value;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
            value: value,
            groupValue: selectedValue,
            title: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
              ),
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
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EditProfileInfo(
                            editTitle: 'Select \nAccount Type',
                            info:
                                'Select an account type to help other users easily identify you for business purposes. You can only select one account type at a time.',
                            icon: Icons.account_circle,
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
              ),
            ),
          )),
    );
  }
}
