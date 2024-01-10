import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class DirectionWidget extends StatefulWidget {
  final String text;

  double? fontSize = 14;
  FontWeight fontWeight;
  double sizedBox;

  DirectionWidget(
      {required this.text,
      this.fontWeight = FontWeight.normal,
      this.sizedBox = 40,
      required this.fontSize});

  @override
  _DirectionWidgetState createState() => _DirectionWidgetState();
}

class _DirectionWidgetState extends State<DirectionWidget> {
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
                widget.text,
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize:   ResponsiveHelper.responsiveFontSize(context, widget.fontSize!,), 
                  fontWeight: widget.fontWeight,
                ),
              ),
            ),
            SizedBox(height: widget.sizedBox),
          ]),
    );
  }
}
