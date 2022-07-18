import 'package:flutter/material.dart';

import 'package:bars/utilities/exports.dart';

class BlackWhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double buttonWidth;
  final Color textColor;
  final Color buttonColor;

  BlackWhiteButton(
      {required this.onPressed,
      this.buttonWidth = 250.0,
      this.buttonColor = Colors.white,
      required this.textColor,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          elevation: 20.0,
          onPrimary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
