import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class UserWebsite extends StatelessWidget {
  final String title;
  Color arrowColor = Colors.grey;
  final IconData icon;
  final Color textColor;
  final double iconSize;
  final Color iconColor;
  final double raduis;
  final double padding;
  final Color? containerColor;
  final Color borderColor;
  final VoidCallback onPressed;

  UserWebsite(
      {required this.icon,
      required this.title,
      required this.containerColor,
      required this.raduis,
      required this.padding,
      this.arrowColor = Colors.grey,
      required this.iconSize,
      required this.textColor,
      required this.iconColor,
      required this.onPressed,
      this.borderColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          child: ListTile(
        leading: Padding(
          padding: EdgeInsets.all(padding),
          child: Icon(
            icon,
            size: ResponsiveHelper.responsiveFontSize(context, iconSize),
            color: iconColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.normal,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_outlined,
          color: arrowColor,
          size: ResponsiveHelper.responsiveFontSize(context, 20),
        ),
      )),
    );
  }
}
