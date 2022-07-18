import 'package:flutter/material.dart';

class ListviewDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
     const   SizedBox(
          width: 20.0,
        ),
      const  VerticalDivider(
          color: Colors.grey,
        ),
       const SizedBox(
          width: 20.0,
        ),
      ],
    );
  }
}
