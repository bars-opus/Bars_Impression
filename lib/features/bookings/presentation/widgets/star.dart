import 'package:flutter/material.dart';

class Star extends StatelessWidget {
  final bool isFilled;
  final bool isMini;
  final Function()? onTap;

  Star({required this.isFilled, this.onTap,  required this.isMini});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isFilled ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: isMini? 20 : 40.0,
      ),
    );
  }
}
