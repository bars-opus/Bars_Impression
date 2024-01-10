import 'package:bars/utilities/exports.dart';
import 'package:flutter/gestures.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch, // Allow scroll with touch input devices
        PointerDeviceKind.mouse, // Allow scroll with mouse input devices
      };
}
