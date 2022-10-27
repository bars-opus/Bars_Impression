import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class DirectionWidgetWithIcon extends StatelessWidget {
  final String text;

  final String title;
  final Icon icon;

  double? fontSize = 14;
  FontWeight fontWeight;
  double sizedBox;

  DirectionWidgetWithIcon(
      {required this.text,
      required this.icon,
      this.fontWeight = FontWeight.normal,
      this.sizedBox = 40,
      required this.fontSize,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ShakeTransition(
              duration: Duration(milliseconds: 1200),
              curve: Curves.easeOutBack,
              child: Text(
                text,
                style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ShakeTransition(
              duration: Duration(milliseconds: 1500),
              curve: Curves.easeOutBack,
              child: Container(
                height: 2,
                color: Colors.blue,
                width: width / 8,
              ),
            ),
            SizedBox(height: sizedBox),
          ]),
    );
  }
}
