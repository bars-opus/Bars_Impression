import 'package:bars/utilities/exports.dart';

class FeatureInfoWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String number;

  FeatureInfoWidget({
    required this.subTitle,
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: ResponsiveHelper.responsiveHeight(context, 25,),
            width: ResponsiveHelper.responsiveHeight(context, 25,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).secondaryHeaderColor,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize:  ResponsiveHelper.responsiveFontSize(context, 14,),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ),
          Container(
            width: width - 80,
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: title + '\n',
                      style: TextStyle(
                        fontSize:  ResponsiveHelper.responsiveFontSize(context, 26,),
                        color: Theme.of(context).secondaryHeaderColor,
                      )),
                  TextSpan(
                    text: subTitle,
                    style: TextStyle(
                      fontSize:  ResponsiveHelper.responsiveFontSize(context, 12,),
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ]);
  }
}
