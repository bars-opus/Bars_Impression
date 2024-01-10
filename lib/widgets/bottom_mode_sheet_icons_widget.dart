import 'package:bars/utilities/exports.dart';

class BottomModelSheetIconsWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  BottomModelSheetIconsWidget({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).secondaryHeaderColor,
          size: ResponsiveHelper.responsiveHeight(context, 25.0),
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
