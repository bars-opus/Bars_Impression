import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class CommentContentField extends StatelessWidget {
  final String hintText;
  final bool autofocus;
  final TextEditingController controller;
  final VoidCallback onSend;

  CommentContentField({
    this.autofocus = false,
    required this.hintText,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Theme.of(context).primaryColorLight,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: ListTile(
          title: TextField(
            autofocus: autofocus,
            cursorColor: Colors.blue,
            controller: controller,
            keyboardAppearance: MediaQuery.of(context).platformBrightness,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: controller.text.length > 100 ? 5 : null,
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              hintStyle: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
            onSubmitted: (string) {
              onSend();
            },
          ),
          trailing: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: CircularButton(
                color: controller.text.trim().length > 0
                    ? Colors.blue
                    : Colors.transparent,
                icon: Icon(Icons.send,
                    color: controller.text.trim().length > 0
                        ? Colors.white
                        : Colors.grey),
                onPressed: onSend),
          ),
        ),
      ),
    );
  }
}
