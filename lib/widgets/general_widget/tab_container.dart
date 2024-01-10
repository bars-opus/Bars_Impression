import 'package:bars/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class TabContainer extends StatelessWidget {
  final Widget containerText;

  TabContainer({required this.containerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  ResponsiveHelper.responsiveHeight(context, 2.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 10),
            blurRadius: 10.0,
            spreadRadius: 4.0,
          )
        ],
      ),
      child: SingleChildScrollView(
        child: containerText,
      ),
    );
  }
}
