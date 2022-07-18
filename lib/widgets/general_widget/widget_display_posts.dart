import 'package:bars/utilities/exports.dart';

class DisplayPosts extends StatelessWidget {
  final FontWeight fontWeight;
  final String title;
  final Color color;
  final VoidCallback onPressed;

  DisplayPosts(
      {required this.fontWeight,
      required this.title,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        title,
        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.2),
        style: TextStyle(
          color: color,
          fontSize: 14.0,
          fontWeight: fontWeight,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
