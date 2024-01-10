import 'package:bars/utilities/exports.dart';

class SignUpButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  SignUpButton({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
   
    return Container(
      width: ResponsiveHelper.responsiveWidth(context, 250),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0.0,
          foregroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.responsiveFontSize(context, 8.0),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.black,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            ),
          ),
        ),
      ),
    );
  }
}
