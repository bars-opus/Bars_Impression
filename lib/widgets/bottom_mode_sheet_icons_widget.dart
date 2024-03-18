import 'package:bars/utilities/exports.dart';

class BottomModelSheetIconsWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  BottomModelSheetIconsWidget(
      {required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color == null ? Theme.of(context).secondaryHeaderColor : color,
          size: ResponsiveHelper.responsiveHeight(context, 25.0),
        ),
        Text(
          text,
          style: color == null
              ? Theme.of(context).textTheme.bodySmall
              : TextStyle(
                  color: color,
                  fontSize: ResponsiveHelper.responsiveHeight(context, 12.0),
                ),
        ),
      ],
    );
  }
}
