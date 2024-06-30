import 'package:bars/utilities/exports.dart';

class BottomModelSheetIconsWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final bool minor;

  BottomModelSheetIconsWidget(
      {required this.icon, required this.text, this.color, this.minor = false});

  @override
  Widget build(BuildContext context) {
    return minor
        ? Row(
            children: [
              // Icon(
              //   icon,
              //   color: color == null
              //       ? Theme.of(context).secondaryHeaderColor
              //       : color,
              //   size: ResponsiveHelper.responsiveHeight(
              //       context, minor ? 15 : 25.0),
              // ),
              // const SizedBox(
              //   width: 10,
              // ),
              Text(
                text,
                style: color == null
                    ? Theme.of(context).textTheme.bodySmall
                    : TextStyle(
                        color: color,
                        fontSize: ResponsiveHelper.responsiveHeight(
                            context, minor ? 10 : 12.0),
                      ),
              ),
            ],
          )
        : Column(
            children: [
              Icon(
                icon,
                color: color == null
                    ? Theme.of(context).secondaryHeaderColor
                    : color,
                size: ResponsiveHelper.responsiveHeight(
                    context,25.0),
              ),
              Text(
                text,
                style: color == null
                    ? Theme.of(context).textTheme.bodySmall
                    : TextStyle(
                        color: color,
                        fontSize: ResponsiveHelper.responsiveHeight(
                            context, minor ? 10 : 12.0),
                      ),
              ),
            ],
          );
  }
}
