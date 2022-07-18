import 'package:bars/utilities/exports.dart';

class AvatarCircularButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  AvatarCircularButton({required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: ConfigBloc().darkModeOn ? Colors.blue : Color(0xFF1a1a1a),
          elevation: 20.0,
          onPrimary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
