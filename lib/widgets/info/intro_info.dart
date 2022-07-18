import 'package:bars/utilities/exports.dart';

class IntroInfo extends StatelessWidget {
  final String title;
  final String subTitle;
  final Icon icon;
  final Function? onPressed;

  IntroInfo({
    required this.subTitle,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        width: width - 150,
        child: RichText(
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: TextSpan(
            children: [
              TextSpan(
                  text: title + '\n',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  )),
              TextSpan(
                text: subTitle,
                style: TextStyle(
                  fontSize: 12,
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.start,
        ),
      ),
      Transform.scale(
        scale: 1,
        child: RawMaterialButton(
          shape: CircleBorder(),
          onPressed: () => onPressed,
          child: icon,
        ),
      )
    ]);
  }
}
