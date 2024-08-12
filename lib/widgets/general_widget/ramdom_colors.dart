import 'package:bars/utilities/exports.dart';

class RandomColorsContainer extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(100.0),
      ),
      height: 1.0,
      width: 25.0,
    );
  }
}
