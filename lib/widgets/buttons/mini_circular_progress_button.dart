import 'package:bars/utilities/exports.dart';

class MiniCircularProgressButton extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;
  final Color color;

  MiniCircularProgressButton(
      {required this.text, required this.onPressed, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      child: ShakeTransition(
        curve: Curves.easeOutBack,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            surfaceTintColor: Colors.transparent,
            elevation: 20.0,
            foregroundColor: color == Colors.blue ? Colors.white : Colors.blue,
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
              text,
              style: TextStyle(
                color: color == Colors.blue ? Colors.white : Colors.blue,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
