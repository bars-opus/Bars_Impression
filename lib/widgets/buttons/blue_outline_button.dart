import 'package:bars/utilities/exports.dart';

class BlueOutlineButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const BlueOutlineButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.responsiveWidth(context, 250),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: BorderSide(
              width: 1.0,
              color: Colors.blue,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveHelper.responsiveHeight(context, 8),
            ),
            child: Material(
              color: Colors.transparent,
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          onPressed: onPressed),
    );
  }
}
