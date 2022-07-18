import 'package:bars/utilities/exports.dart';

class InkBoxColumn extends StatelessWidget {
  final String text;
  final Icon icon;
  final VoidCallback onPressed;
  final double size;

  InkBoxColumn(
      {required this.text,
      required this.icon,
      required this.size,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap:  onPressed,
          child: Ink(
            child: Container(
              height: height / size,
              width: height / size,
              decoration: BoxDecoration(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: icon,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
