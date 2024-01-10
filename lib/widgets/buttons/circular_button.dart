import 'package:bars/utilities/exports.dart';

class CircularButton extends StatelessWidget {
  final Color color;
  final Icon icon;
  final VoidCallback? onPressed;

  CircularButton(
      {required this.color, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: ResponsiveHelper.responsiveFontSize(context, 40.0),
      height: ResponsiveHelper.responsiveFontSize(context, 40.0),
      decoration:
          BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 10),
          blurRadius: 10.0,
          spreadRadius: 4.0,
        )
      ]),
      child: RawMaterialButton(
        shape: CircleBorder(),
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}
