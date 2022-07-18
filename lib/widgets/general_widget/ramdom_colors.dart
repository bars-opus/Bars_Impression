import 'package:bars/utilities/exports.dart';

class RandomColorsContainer extends StatelessWidget {
  final RandomColor _randomColor = RandomColor();
  final List<ColorHue> _hueType = <ColorHue>[
    ColorHue.green,
    ColorHue.red,
    ColorHue.pink,
    ColorHue.purple,
    ColorHue.blue,
    ColorHue.yellow,
    ColorHue.orange
  ];

  final ColorSaturation _colorSaturation = ColorSaturation.random;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _randomColor.randomColor(
          colorHue: ColorHue.multiple(colorHues: _hueType),
          colorSaturation: _colorSaturation,
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      height: 1.0,
      width: 25.0,
    );
  }
}
