import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class DecisionContainer extends StatefulWidget {
  final String questions;
  final String answer1;
  final String answer2;
  final Color answer1Color;
  final Color answer2Color;
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;
  bool isPicked1;
  bool isPicked2;

  DecisionContainer({
    required this.questions,
    required this.answer1,
    required this.answer2,
    required this.onPressed1,
    required this.onPressed2,
    this.isPicked1 = false,
    this.isPicked2 = false,
    this.answer1Color = Colors.blue,
    this.answer2Color = Colors.blue,
  });

  @override
  _DecisionContainerState createState() => _DecisionContainerState();
}

class _DecisionContainerState extends State<DecisionContainer> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShakeTransition(
          curve: Curves.easeOutBack,
          duration: Duration(milliseconds: 1500),
          child: Container(
            height: 2,
            color: Colors.blue,
            width: width / 8,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ShakeTransition(
          curve: Curves.easeOutBack,
          duration: Duration(milliseconds: 1200),
          child: Container(
            width: width - 50,
            child: Text(
              widget.questions,
              style: TextStyle(
                color:
                    ConfigBloc().darkModeOn ? Colors.white : Color(0xFF1a1a1a),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          decoration: BoxDecoration(
            color: ConfigBloc().darkModeOn ? Colors.blue : Color(0xFF1a1a1a),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: widget.isPicked1
                              ? Colors.white
                              : Colors.transparent,
                          onPrimary: Colors.blue,
                        ),
                        child: Text(
                          widget.answer1,
                          style: TextStyle(
                            color: ConfigBloc().darkModeOn || widget.isPicked1
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        onPressed: widget.onPressed1,
                      ),
                    ),
                    widget.isPicked1 || widget.isPicked2
                        ? const SizedBox.shrink()
                        : Container(
                            height: 40,
                            width: 1,
                            color: ConfigBloc().darkModeOn
                                ? Colors.black
                                : Colors.white,
                          ),
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: widget.isPicked2
                                ? Colors.white
                                : Colors.transparent,
                            onPrimary: Colors.blue,
                          ),
                          child: Text(
                            widget.answer2,
                            style: TextStyle(
                              color: ConfigBloc().darkModeOn || widget.isPicked2
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          onPressed: widget.onPressed2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
