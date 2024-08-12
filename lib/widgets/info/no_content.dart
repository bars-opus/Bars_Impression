import 'package:bars/utilities/exports.dart';

class NoContents extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData? icon;
  final Color color;
  final Color? textColor;
  final bool isFLorence;

  NoContents({
    required this.title,
    required this.subTitle,
    required this.icon,
    this.color = Colors.grey,
    this.textColor,
    this.isFLorence = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isFLorence)
            AnimatedCircle(
              size: 30,
              stroke: 2,
              animateSize: true,
              animateShape: true,
            ),
          if (icon != null)
            Icon(
              icon,
              color: color,
              size: ResponsiveHelper.responsiveHeight(context, 50.0),
            ),
          SizedBox(height: 10),
          Text(
            title,
            style: textColor != null
                ? TextStyle(
                    color: textColor,
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
                    fontWeight: FontWeight.bold)
                : Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3),
          Padding(
            padding: EdgeInsets.only(left: isFLorence ? 0.0 : 30.0, right: 30),
            child: Text(
              subTitle,
              style: textColor != null
                  ? TextStyle(
                      color: textColor,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                    )
                  : Theme.of(context).textTheme.bodyMedium,
              textAlign: isFLorence ? TextAlign.start : TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
