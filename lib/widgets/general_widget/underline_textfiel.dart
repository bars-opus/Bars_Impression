import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class UnderlinedTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controler;
  final Function onValidateText;
  final bool isNumber;
  final bool autofocus;

  // String initialValue = '';
  // String labelText = '';
  // String hintText = '';

  // final bool enableBorder;
  // final Function(String) onSavedText;
  // final Function onValidateText;
  // final bool autofocus;
  // final bool isNumber;

  UnderlinedTextField(
      {
      // required this.onSavedText,
      // required this.onValidateText,
      // required this.initialValue,
      // required this.hintText,
      // required this.labelText,
      // required this.enableBorder,
      // this.autofocus = false,
      // this.isNumber = false,
      required this.labelText,
      required this.hintText,
      this.isNumber = false,
      this.autofocus = true,
      required this.controler,
      required this.onValidateText});

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.bodyLarge;
    var labelStyle = TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        color: Colors.blue);
    var hintStyle = TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        color: Colors.grey);
    return TextFormField(
      controller: controler,
      keyboardType: isNumber
          ? TextInputType.numberWithOptions()
          : TextInputType.multiline,
      keyboardAppearance: MediaQuery.of(context).platformBrightness,
      style: style,
      maxLines: null,
      autofocus: autofocus,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        labelText: labelText,
        hintText: hintText,
        labelStyle: labelStyle,
        hintStyle: hintStyle,
      ),
      validator: (string) => onValidateText(string),
    );
  }
}
