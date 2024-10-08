import 'package:bars/utilities/exports.dart';

class SignInWithButton extends StatelessWidget {
  final String buttonText;
  final IconData icon;
  final VoidCallback? onPressed;

  SignInWithButton(
      {required this.buttonText, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: new Container(
        height: ResponsiveHelper.responsiveHeight(context, 45),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 20.0,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: onPressed,
          child: ListTile(
            focusColor: Colors.blue,
            leading: Icon(
              icon,
              color: Color(0xFF1a1a1a),
            ),
            title: Text(
              buttonText,
              style: TextStyle(
                color: Colors.black,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              ),
            ),
            onTap: onPressed,
          ),
        ),
      ),
    );
  }
}
