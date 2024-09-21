import 'package:bars/utilities/exports.dart';

class IntroInfo extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color titleColor;
  final Color subTitleColor;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;

  IntroInfo({
    required this.subTitle,
    required this.title,
    required this.icon,
    this.titleColor = Colors.blue,
    this.subTitleColor = Colors.grey,
    this.leadingIcon,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leadingIcon != null)
            isLoading
                ? Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 10),
                    child: SizedBox(
                      height: ResponsiveHelper.responsiveHeight(context, 15),
                      width: ResponsiveHelper.responsiveHeight(context, 15),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                        strokeWidth:
                            ResponsiveHelper.responsiveFontSize(context, 2.0),
                      ),
                    ),
                  )
                : Container(
                    // color: Colors.red,
                    height: ResponsiveHelper.responsiveHeight(context, 45),
                    width: ResponsiveHelper.responsiveHeight(context, 45),
                    child: Icon(
                      size: ResponsiveHelper.responsiveFontSize(context, 20.0),
                      leadingIcon,
                      color: Colors.blue,
                    ),
                  ),
          Expanded(
            child: RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: title,
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: titleColor,
                      )),
                  if (subTitle.isNotEmpty)
                    TextSpan(
                      text: '\n' + subTitle,
                      style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: subTitleColor),
                    ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            height: ResponsiveHelper.responsiveHeight(context, 45),
            width: ResponsiveHelper.responsiveHeight(context, 45),
            child: Icon(
              icon,
              size: ResponsiveHelper.responsiveFontSize(context,
                  icon == Icons.arrow_forward_ios_outlined ? 15 : 20.0),
              color: titleColor,
            ),
          ),
        ],
      ),
    );
  }
}
