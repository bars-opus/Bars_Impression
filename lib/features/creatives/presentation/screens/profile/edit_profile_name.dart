import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';

class EditProfileName extends StatefulWidget {
  final AccountHolderAuthor user;

  EditProfileName({
    required this.user,
  });

  @override
  _EditProfileNameState createState() => _EditProfileNameState();
}

class _EditProfileNameState extends State<EditProfileName> {
  final _formKey = GlobalKey<FormState>();
  String query = "";
  late TextEditingController _controller;

  late FocusNode _focusNode;
  final UsernameService _usernameService = UsernameService();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false)
          .setChangeUserName(widget.user.userName!);
    });
    _controller = TextEditingController(
      text: widget.user.userName,
    );
    _focusNode = FocusNode();
    Future.delayed(Duration(milliseconds: 500), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  _validate(BuildContext context) async {
    var _changeUserName =
        Provider.of<UserData>(context, listen: false).changeNewUserName;
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // Check if the username has changed
      if (_changeUserName == _controller.text.trim()) {
        Navigator.pop(context);
      } else {
        try {
          // var currentUser = Provider.of<UserData>(context, listen: false).user;
          await _usernameService.validateTextToxicity(
              context, _changeUserName, _controller, false, null);

          // _validateTextToxicity(_changeUserName);
        } catch (e) {
          mySnackBar(context, e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    return EditProfileScaffold(
      title: '',
      widget: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // if (_provider.isLoading) LinearProgress(),
              const SizedBox(
                height: 30,
              ),
              EditProfileInfo(
                  editTitle: 'Select \nUsername',
                  info:
                      'Select a unique username for your brand. The username can be your stage name if you are a music creator. Please note that all usernames are converted to uppercase.',
                  icon: MdiIcons.accountDetails),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, bottom: 10.0, right: 10.0),
                child: Container(
                  color: Colors.transparent,
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    keyboardAppearance:
                        MediaQuery.of(context).platformBrightness,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    autovalidateMode: AutovalidateMode.always,
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 3.0),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      hintText: 'A unique name to be identified with',
                      hintStyle: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 12.0),
                          color: Colors.grey),
                      labelText: 'Username',
                    ),
                    autofillHints: [AutofillHints.name],
                    validator: (input) {
                      if (input!.trim().length < 1) {
                        return 'Choose a username';
                      } else if (input.trim().contains(' ')) {
                        return 'Username cannot contain space, use ( _ or - )';
                      } else if (input.trim().contains('@')) {
                        return 'Username cannot contain @';
                      } else if (input.trim().length > 20) {
                        // assuming 20 as the maximum length
                        return 'Username cannot be longer than 20 characters';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              _provider.isLoading
                  ? Center(
                      child: SizedBox(
                        height:
                            ResponsiveHelper.responsiveHeight(context, 20.0),
                        width: ResponsiveHelper.responsiveHeight(context, 20.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : AlwaysWhiteButton(
                      buttonColor: Colors.blue,
                      buttonText: 'Save',
                      onPressed: () {
                        if (_controller.text.trim().isNotEmpty)
                          _validate(context);
                      },
                    ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
