import 'package:flutter/material.dart';

class SignInWithButton extends StatelessWidget {
  final String buttonText;
  final Icon icon;
  final VoidCallback? onPressed;

  SignInWithButton(
      {required this.buttonText, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
   return Padding(
      padding: const EdgeInsets.all(5.0),
      child: new ConstrainedBox(
        constraints: BoxConstraints(minHeight: 45.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 20.0,
            foregroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: onPressed,
          child: ListTile(
            focusColor: Colors.blue,
            leading: icon,
            title: Text(
              buttonText,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            onTap: onPressed,
          ),
        ),
      ),
    );
  }
}
