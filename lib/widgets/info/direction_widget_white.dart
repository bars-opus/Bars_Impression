import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class DirectionWidgetWhite extends StatelessWidget {
  final String text;

  double fontSize;
  FontWeight fontWeight;
  double sizedBox;

  DirectionWidgetWhite(
      {required this.text,
      this.fontWeight = FontWeight.normal,
      this.sizedBox = 40,
      this.fontSize = 14});

 
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            ShakeTransition(
              duration: Duration(milliseconds: 1500),
              curve: Curves.easeOutBack,
              child: Container(
                height: 2,
                color: Colors.blue,
                width: width / 8,
              ),
            ),
            SizedBox(height: 10),
            ShakeTransition(
              duration: Duration(milliseconds: 1200),
              curve: Curves.easeOutBack,
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize:   ResponsiveHelper.responsiveFontSize(context,fontSize!), 
                  fontWeight: fontWeight,
                ),
              ),
            ),
            SizedBox(height: sizedBox),
          ]),
    );
  }
}
