import 'package:bars/utilities/exports.dart';

class EditContent extends StatelessWidget {
  final Function onPressed;
  final String text;

  EditContent({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(text,
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12,),
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                )),
            IconButton(
              icon: Icon(Icons.edit),
              iconSize: ResponsiveHelper.responsiveHeight(context, 25,),
              color: Colors.blue,
              onPressed: () => onPressed,
            )
          ],
        ));
  }
}
