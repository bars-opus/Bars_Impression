import 'package:bars/utilities/exports.dart';

class BottomModelSheetListTileWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String colorCode;

  BottomModelSheetListTileWidget({
    required this.icon,
    required this.text,
    this.colorCode = '',
  });

  @override
  Widget build(BuildContext context) {
    Color newColor = colorCode.startsWith('Blue')
        ? Colors.blue
        : colorCode.startsWith('Red')
            ? Colors.red
            : Theme.of(context).secondaryHeaderColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: newColor,
          size: ResponsiveHelper.responsiveHeight(context, 25),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: TextStyle(
              color: newColor,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
