import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class ContentFieldBlack extends StatelessWidget {
  String initialValue = '';
  String labelText = '';
  String hintText = '';
  final Function(String) onSavedText;
  final Function(String)? onChanged;
  final Function onValidateText;
  final TextInputType textInputType;

  final bool onlyBlack;

  ContentFieldBlack({
    required this.onSavedText,
    required this.onValidateText,
    required this.initialValue,
    required this.hintText,
    required this.labelText,
    this.onlyBlack = true,
    this.onChanged,
    this.textInputType = TextInputType.multiline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          child: TextFormField(
            keyboardType: textInputType,
            // TextInputType.multiline,
            maxLines: null,
            cursorColor: Colors.blue,
            textCapitalization: TextCapitalization.sentences,
            keyboardAppearance: MediaQuery.of(context).platformBrightness,
            initialValue: initialValue,
            style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
                color: onlyBlack
                    ? Colors.black
                    : Theme.of(context).secondaryHeaderColor,
                fontWeight: FontWeight.normal),
            decoration: InputDecoration(
                focusColor: Colors.blue,
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.grey),
                labelText: labelText,
                labelStyle: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: Colors.grey,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey))),
            validator: (string) => onValidateText(string),
            onChanged: onChanged == null ? onSavedText : onChanged,
            onSaved: (_) => onSavedText,
          ),
        ));
  }
}
