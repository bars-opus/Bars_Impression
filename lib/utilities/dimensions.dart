import 'package:flutter/widgets.dart';

class ResponsiveHelper {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

 
  static double responsiveHeight(BuildContext context, double height) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double referenceScreenHeight = 812.0;
    return height * (screenHeight / referenceScreenHeight);
  }

  static double responsiveWidth(BuildContext context, double width) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double referenceScreenWidth = 375.0;
    return width * (screenWidth / referenceScreenWidth);
  }

  static double responsiveFontSize(BuildContext context, double fontSize) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double referenceScreenWidth =
        375.0; // The reference screen width you want to base the calculations on.
    final double referenceScreenHeight =
        812.0; // The reference screen height you want to base the calculations on.
    final double scaleFactorWidth = screenWidth / referenceScreenWidth;
    final double scaleFactorHeight = screenHeight / referenceScreenHeight;
    final double scaleFactor = (scaleFactorWidth + scaleFactorHeight) / 2;

    return fontSize * scaleFactor;
  }

  static EdgeInsetsGeometry responsiveEdgeInsets(
    BuildContext context,
    double topSize,
    double rightSize,
    double bottomSize,
    double leftSize,
  ) {
    final double top = responsiveHeight(context, topSize);
    final double right = responsiveWidth(context, rightSize);
    final double bottom = responsiveHeight(context, bottomSize);
    final double left = responsiveWidth(context, leftSize);

    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  static Widget responsiveSizedBoxWidth(
    BuildContext context,
    double widthSize,
  ) {
    return SizedBox(width: responsiveWidth(context, widthSize));
  }

  static Widget responsiveSizedBoxHeight(
    BuildContext context,
    double heightSize,
  ) {
    return SizedBox(height: responsiveHeight(context, heightSize));
  }
}
