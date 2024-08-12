import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class UnderlinedTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controler;
  final Function onValidateText;
  final bool isNumber;
  final bool autofocus;
  final bool isFlorence;

  UnderlinedTextField(
      {required this.labelText,
      required this.hintText,
      this.isNumber = false,
      this.isFlorence = false,
      this.autofocus = true,
      required this.controler,
      required this.onValidateText});

  @override
  Widget build(BuildContext context) {
    var style = isFlorence
        ? TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            color: Colors.black)
        : Theme.of(context).textTheme.bodyLarge;
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
