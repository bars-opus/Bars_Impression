import 'package:bars/utilities/exports.dart';

class DisclaimerWidgetOnColor extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final bool onColoredBackground;

  DisclaimerWidgetOnColor({
    required this.title,
    required this.subTitle,
    required this.icon,
    this.onColoredBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Color color = onColoredBackground
        ? Theme.of(context).primaryColorLight
        : Theme.of(context).secondaryHeaderColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 30),
        ),
        Icon(
          icon,
          color: color,
          size: ResponsiveHelper.responsiveHeight(context, 50),
        ),
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 30),
        ),
        ShakeTransition(
          axis: Axis.vertical,
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 30),
        ),
        Container(
          color: color,
          height: 1,
          width: width / 8,
        ),
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 20),
        ),
        ShakeTransition(
          child: RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              children: [
                TextSpan(
                  text: subTitle,
                  style: TextStyle(
                    color: color,
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
