import 'package:bars/utilities/exports.dart';

class EventBottomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final bool onlyWhite;
  final Color buttonColor;

  EventBottomButton(
      {required this.buttonText,
      required this.onPressed,
      this.onlyWhite = false,
      this.buttonColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                onlyWhite ? Colors.white : Theme.of(context).primaryColorLight,
            elevation: 0.0,
            foregroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveHelper.responsiveHeight(context, 8.0),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                color: buttonColor,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
