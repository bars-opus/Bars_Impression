import 'package:bars/utilities/exports.dart';

class AlwaysWhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double buttonWidth;
  final Color buttonColor;
  final Color textColor;

  AlwaysWhiteButton({
    required this.onPressed,
    this.buttonWidth = 250.0,
    this.buttonColor = Colors.white,
    required this.buttonText,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.responsiveWidth(context, buttonWidth),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Colors.transparent,
          backgroundColor: buttonColor,
          elevation: 3.0,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.responsiveFontSize(context, 5.0),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
            ),
          ),
        ),
      ),
    );
  }
}
