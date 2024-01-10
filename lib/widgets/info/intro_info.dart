import 'package:bars/utilities/exports.dart';

class IntroInfo extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color titleColor;
  final Color subTitleColor;
  final VoidCallback? onPressed;

  IntroInfo({
    required this.subTitle,
    required this.title,
    required this.icon,
    this.titleColor = Colors.blue,
    this.subTitleColor = Colors.grey,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(
          children: [
            TextSpan(
                text: title + '\n',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
                  color: titleColor,
                )),
            TextSpan(
              text: subTitle,
              style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: subTitleColor),
            ),
          ],
        ),
        textAlign: TextAlign.start,
      ),
      trailing: RawMaterialButton(
        shape: CircleBorder(),
        onPressed: onPressed,
        child: Icon(
          icon,
          size: ResponsiveHelper.responsiveFontSize(context, 20.0),
          color: titleColor,
        ),
      ),
      onTap: onPressed,
    );
  }
}
