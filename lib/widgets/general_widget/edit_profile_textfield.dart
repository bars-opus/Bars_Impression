import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class EditProfileTextField extends StatelessWidget {
  String initialValue = '';
  String labelText = '';
  String hintText = '';

  final bool enableBorder;
  final Function(String) onSavedText;
  final Function onValidateText;
  final bool autofocus;
  final bool isNumber;
  final double padding;

  EditProfileTextField({
    required this.onSavedText,
    required this.onValidateText,
    required this.initialValue,
    required this.hintText,
    required this.labelText,
    required this.enableBorder,
    this.autofocus = false,
    this.isNumber = false,
    this.padding = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(padding),
        child: Container(
          child: TextFormField(
            autofocus: autofocus,
            style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                color: Theme.of(context).secondaryHeaderColor,
                fontWeight: FontWeight.normal),
            keyboardType: isNumber
                ? TextInputType.numberWithOptions()
                : TextInputType.text,
            maxLines: null,
            keyboardAppearance: MediaQuery.of(context).platformBrightness,
            textCapitalization: TextCapitalization.sentences,
            initialValue: initialValue.trim(),
            cursorColor: Colors.blue,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 3.0),
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                    color: Colors.grey),
                labelText: labelText,
                labelStyle: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Theme.of(context).secondaryHeaderColor,
                    fontWeight: FontWeight.normal),
                enabledBorder: enableBorder
                    ? OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey))
                    : UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey))),
            validator: (string) => onValidateText(string),
            onChanged: onSavedText,
            onSaved: (_) => onSavedText,
          ),
        ));
  }
}
