import 'package:bars/utilities/exports.dart';

class LoginField extends StatelessWidget {
 
  final String hintText;
  final IconData icon;
  final IconButton? suffixIcon;
  final bool notLogin;
 final String labelText;
  final TextEditingController controller;
  final Function onValidateText;

  LoginField({
    required this.onValidateText,
    required this.icon,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.suffixIcon,
    this.notLogin = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: notLogin ? Theme.of(context).secondaryHeaderColor : Colors.white,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      ),
      autofocus: notLogin ? true : false,
      controller: controller,
      keyboardAppearance: MediaQuery.of(context).platformBrightness,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      decoration: InputDecoration(
          icon: notLogin
              ? null
              : Icon(
                  icon,
                  size: ResponsiveHelper.responsiveHeight(context, 20.0),
                  color: Colors.grey,
                ),
          suffixIcon: suffixIcon == null ? null : suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              color: Colors.grey),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            color: Colors.grey,
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.grey))),
      validator: (string) => onValidateText(string),
    );
  }
}
