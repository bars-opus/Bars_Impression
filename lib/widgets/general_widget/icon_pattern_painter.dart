import 'dart:math' as math;

import 'package:bars/utilities/exports.dart';

class IconPatternPainter extends CustomPainter {
  final math.Random random = math.Random();

  final double padding = 8.0; // Define the padding around each icon

  // A list of icons to be used in the pattern
  final List<IconData> icons = [
    Icons.favorite_border_outlined,
    Icons.music_note_outlined,

  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Define the maximum icon size for calculating spacing
    final maxIconSize = 80.0;

    // Calculate the number of icons based on the canvas size, icon size, and padding
    final iconsPerRow = (size.width / (maxIconSize + padding)).floor();
    final iconsPerColumn = (size.height / (maxIconSize + padding)).floor();

    for (int i = 0; i < iconsPerRow; i++) {
      for (int j = 0; j < iconsPerColumn; j++) {
        // Randomly choose an icon
        final iconData = icons[random.nextInt(icons.length)];

        // Calculate the position with padding and prevent overlap
        final position = Offset(
          i * (maxIconSize + padding) + padding,
          j * (maxIconSize + padding) + padding,
        );

        // Randomly generate a size up to the maximum size
        final iconSize = (random.nextDouble() * (maxIconSize - 12)) + 12;

        // Randomly generate a color
        // final color = Color.fromRGBO(
        //   random.nextInt(256),
        //   random.nextInt(256),
        //   random.nextInt(256),
        //   1,
        // );

        // Use TextPainter to draw text (icons are also text)
        final textPainter = TextPainter(textDirection: TextDirection.ltr);
        final textSpan = TextSpan(
          text: String.fromCharCode(iconData.codePoint),
          style: TextStyle(
            fontSize: iconSize,
            fontFamily: iconData.fontFamily,
            package: iconData.fontPackage,
            color: Colors.grey,
          ),
        );

        // Layout the text
        textPainter.text = textSpan;
        textPainter.layout();

        // Paint the text (icon) onto the canvas
        textPainter.paint(canvas, position);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
