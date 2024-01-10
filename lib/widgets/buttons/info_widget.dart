import 'package:bars/utilities/exports.dart';
import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  final String info;
  final VoidCallback? onPressed;
  final bool show;

  InfoWidget(
      {required this.onPressed,
      required this.info,
      required this.show,
      
      });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 400),
      height: show ? ResponsiveHelper.responsiveHeight(context, 50.0) : 0.0,
      width: show ? MediaQuery.of(context).size.width - 50 : 0.0,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              info,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),

    );
  }
}
