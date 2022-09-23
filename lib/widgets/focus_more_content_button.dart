import 'package:flutter/material.dart';

class FocusMoreContentButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;

  FocusMoreContentButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(5)),
      child: IconButton(
        icon: icon,
        iconSize: 20.0,
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
