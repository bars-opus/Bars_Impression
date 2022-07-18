import 'package:bars/utilities/exports.dart';

class WelcomeInfo extends StatelessWidget {
  final String title;
  final String subTitle;
  final Icon icon;

  WelcomeInfo({
    required this.subTitle,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1,
          child: RawMaterialButton(
            shape: CircleBorder(),
            onPressed: () {},
            child: icon,
          ),
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
                      fontSize: 16,
                      color: Colors.white,
                    )),
                TextSpan(
                  text: subTitle,
                  style: TextStyle(
                    fontSize: 12,
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
