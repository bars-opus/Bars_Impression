import 'package:bars/utilities/exports.dart';

class UserStatistics extends StatelessWidget {
  final String count;
  final String title;
  final String subTitle;
  final Color countColor;
  final Color titleColor;
  final VoidCallback onPressed;

  UserStatistics(
      {required this.count,
      required this.countColor,
      required this.titleColor,
      required this.title,
      required this.subTitle,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: new Container(
        child: RichText(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
          text: TextSpan(
            children: [
              TextSpan(
                text: count,
                style: TextStyle(
                  color: countColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                ),
              ),
              TextSpan(
                text: title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        //  Column(
        //   children: <Widget>[
        //     Text(
        //       count,
        //       style: TextStyle(
        //         color: countColor,
        //         fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 5.0,
        //     ),
        //     Text(
        // title,
        // style: TextStyle(
        //   color: titleColor,
        //   fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
        //   fontWeight: FontWeight.w500,
        // ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
