import 'package:bars/utilities/exports.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Swipinfo extends StatelessWidget {
  final String text;
  Color color = Colors.grey;

  Swipinfo({
   required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.arrow_left,
          color: color,
          size: 30.0,
        ),
        Icon(
          Icons.arrow_left,
          color: color,
          size: 30.0,
        ),
        Icon(
          Icons.arrow_left,
          color: color,
          size: 30.0,
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(color: color, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
