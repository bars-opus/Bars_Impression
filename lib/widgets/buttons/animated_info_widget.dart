import 'package:flutter/material.dart';

class AnimatedInfoWidget extends StatelessWidget {
  final String text;
  final bool requiredBool;
  final Color buttonColor;
  final double fontSize;

  AnimatedInfoWidget({
    required this.text,
    required this.requiredBool,
    this.buttonColor = Colors.blue,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimatedContainer(
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 800),
          height: requiredBool ? 20.0 : 0.0,
          width: requiredBool ? 20.0 : 0.0,
          decoration: BoxDecoration(
              color: buttonColor, borderRadius: BorderRadius.circular(100)),
        ),
        const SizedBox(
          width: 5,
        ),
        AnimatedContainer(
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 800),
          height: requiredBool ? null : 0.0,
          width: requiredBool ? null : 0.0,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: buttonColor,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
