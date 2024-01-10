import 'package:bars/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class LinearProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.responsiveHeight(context, 2.0),
      child: LinearProgressIndicator(
        backgroundColor: Colors.grey[100],
        valueColor: AlwaysStoppedAnimation(Colors.blue),
      ),
    );
  }
}
