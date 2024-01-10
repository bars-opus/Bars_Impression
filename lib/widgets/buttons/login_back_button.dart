import 'package:bars/utilities/exports.dart';

class LoginBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.responsiveWidth(context, 250),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          side: BorderSide(
            width: 1.0,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.responsiveFontSize(context, 8.0),
          ),
          child: Text(
            'Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            ),
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
