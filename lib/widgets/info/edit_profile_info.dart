import 'package:bars/utilities/exports.dart';

class EditProfileInfo extends StatelessWidget {
  final String editTitle;
  final String info;
  final IconData icon;
  final Color color;
  final Color iconColor;

  final Color blackOWhiteTextColor;

  final bool showMore;
  final VoidCallback? moreOnPressed;

  EditProfileInfo({
    required this.editTitle,
    required this.info,
    required this.icon,
    this.color = Colors.blue,
    this.blackOWhiteTextColor = Colors.white,
    this.iconColor = Colors.white,
    this.showMore = false,
    this.moreOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: ResponsiveHelper.responsiveHeight(context, 20.0),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              editTitle,
              style: TextStyle(
                  color: color,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 18.0),
                  height: 1),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        GestureDetector(
          onTap: showMore ? moreOnPressed : () {},
          child: RichText(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
            text: TextSpan(
              children: [
                TextSpan(
                  text: info,
                  style: TextStyle(
                    color: color == Colors.blue
                        ? Theme.of(context).secondaryHeaderColor
                        : blackOWhiteTextColor,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                  ),
                ),
                if (showMore)
                  TextSpan(
                    text: ' more',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 1,
            color: color,
            width: width / 5,
          ),
        ),
      ],
    );
  }
}
