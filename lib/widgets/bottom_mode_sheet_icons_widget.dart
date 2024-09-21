import 'package:bars/utilities/exports.dart';

class BottomModelSheetIconsWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textcolor;
  final bool minor;
  final bool mini;

  BottomModelSheetIconsWidget(
      {required this.icon,
      required this.text,
      this.mini = false,
      this.textcolor,
      this.minor = false});

  @override
  Widget build(BuildContext context) {
    return minor
        ? Text(
            text,
            style: textcolor == null
                ? Theme.of(context).textTheme.bodySmall
                : TextStyle(
                    color: textcolor,
                    fontSize: ResponsiveHelper.responsiveHeight(
                        context, minor ? 10 : 12.0),
                  ),
          )
        : mini
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    icon,
                    color: textcolor,
                    size: ResponsiveHelper.responsiveHeight(context, 16.0),
                  ),
                  Text(
                    text,
                    style: textcolor == null
                        ? Theme.of(context).textTheme.bodySmall
                        : TextStyle(
                            color: textcolor,
                            fontSize: ResponsiveHelper.responsiveHeight(
                                context, 10.0),
                          ),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(
                    icon,
                    color: textcolor == null
                        ? Theme.of(context).secondaryHeaderColor
                        : textcolor,
                    size: ResponsiveHelper.responsiveHeight(context, 25.0),
                  ),
                  if (text.isNotEmpty)
                    const SizedBox(
                      height: 5,
                    ),
                  if (text.isNotEmpty)
                    Text(
                      text,
                      style: textcolor == null
                          ? Theme.of(context).textTheme.bodySmall
                          : TextStyle(
                              color: textcolor,
                              fontSize: ResponsiveHelper.responsiveHeight(
                                  context, 10.0),
                            ),
                    ),
                ],
              );
  }
}
