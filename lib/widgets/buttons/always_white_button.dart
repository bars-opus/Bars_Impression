import 'package:flutter/material.dart';

import 'package:bars/utilities/exports.dart';

class AlwaysWhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double buttonWidth;
  final Color buttonColor;

  AlwaysWhiteButton(
      {required this.onPressed,
      this.buttonWidth = 250.0,
      this.buttonColor = Colors.white,
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
            color: Colors.blue,
            // fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
