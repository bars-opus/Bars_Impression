import 'package:bars/utilities/exports.dart';

class DisclaimerWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  DisclaimerWidget({
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 30),
        ),
        Icon(
          icon,
          color: Theme.of(context).unselectedWidgetColor,
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
              color: Theme.of(context).unselectedWidgetColor,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 30),
        ),
        Container(
          color: Colors.grey,
          height: 1,
          width: ResponsiveHelper.responsiveWidth(context, 70),
        ),
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 20),
        ),
        ShakeTransition(
          child: RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(
              children: [
                TextSpan(
                  text: subTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
