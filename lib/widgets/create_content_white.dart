import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class ContentFieldWhite extends StatelessWidget {
  String initialValue = '';
  String labelText = '';
  String hintText = '';
  bool autofocus;

  final Function(String) onSavedText;
  final Function onValidateText;

  ContentFieldWhite({
    required this.onSavedText,
    required this.onValidateText,
    required this.initialValue,
    required this.hintText,
    required this.labelText,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          child: TextFormField(
            autofocus: autofocus,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            initialValue: initialValue,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.grey),
                labelText: labelText,
                labelStyle: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: Colors.white,
                ),
                enabledBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey))),
            validator: (string) => onValidateText(string),
            onChanged: onSavedText,
            onSaved: (_) => onSavedText,
          ),
        ));
  }
}
