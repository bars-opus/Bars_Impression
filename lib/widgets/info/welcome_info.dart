import 'package:bars/utilities/exports.dart';

class WelcomeInfo extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  WelcomeInfo({
    required this.subTitle,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       
        Icon(
          icon,
          color: Colors.grey,
          size: ResponsiveHelper.responsiveHeight(context, 30),
        ),
        Container(
          width: width,
          child: RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              children: [
                TextSpan(
                    text: title + '\n',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 20.0),
                      color: Colors.white,
                    )),
                TextSpan(
                  text: subTitle,
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
