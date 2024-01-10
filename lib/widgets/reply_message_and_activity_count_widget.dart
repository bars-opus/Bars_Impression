import 'package:bars/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class ReplyMessageAndActivityCountWidget extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final Widget widget;

  ReplyMessageAndActivityCountWidget({
    required this.color,
    required this.height,
    required this.width,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 800),
      height: height,
      width: width,
      child: Stack(
        alignment: FractionalOffset.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
                height:  ResponsiveHelper.responsiveHeight(context, 55,),
                width: width,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(5)),
                child: widget),
          ),
          Positioned(
            bottom: -8,
            child: Icon(
              Icons.arrow_drop_down_outlined,
              color: color,
              size: ResponsiveHelper.responsiveHeight(context, 50,),
            ),
          )
        ],
      ),
    );
  }
}
