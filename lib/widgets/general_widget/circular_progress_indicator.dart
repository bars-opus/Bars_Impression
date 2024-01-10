import 'package:bars/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  late final bool isMini;
   late final Color  indicatorColor;

  CircularProgress({required this.isMini,    this.indicatorColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return isMini
        ? Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: SizedBox(
                height:  ResponsiveHelper.responsiveFontSize(context, 40.0),
                width:  ResponsiveHelper.responsiveFontSize(context, 40.0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    indicatorColor,
                  ),
                  strokeWidth:  ResponsiveHelper.responsiveFontSize(context, 2.0),
                ),
              ),
            ),
          )
        : Container(
            color: Colors.black,
            child: Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    indicatorColor,
                  ),
                  strokeWidth: 2,
                ),
              ),
            ),
          );
  }
}
