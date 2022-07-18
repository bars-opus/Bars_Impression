import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class ContentField extends StatelessWidget {
  String initialValue = '';
  String labelText = '';
  String hintText = '';
  final Function(String) onSavedText;
  final Function onValidateText;

  ContentField({
    required this.onSavedText,
    required this.onValidateText,
    required this.initialValue,
    required this.hintText,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            initialValue: initialValue,
            style: TextStyle(
              fontSize: 16,
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                labelText: labelText,
                labelStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                enabledBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey))),
            validator: (String) => onValidateText(String),
            onChanged: onSavedText,
            onSaved: (_) => onSavedText,
          ),
        ));
  }
}
