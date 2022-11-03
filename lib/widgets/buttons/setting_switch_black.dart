import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class SettingSwitchBlack extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool value;
  final Color color;
  final Function(bool) onChanged;

  SettingSwitchBlack(
      {required this.subTitle,
      required this.title,
      this.color = Colors.blue,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        width: width - 150,
        child: RichText(
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: TextSpan(
            children: [
              TextSpan(
                  text: title + '\n',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                         Colors.black,
                  )),
              TextSpan(
                text: subTitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.start,
        ),
      ),
      Transform.scale(
          scale: 1,
          child: Switch.adaptive(
              activeColor: color,
              splashRadius: 35,
              value: value,
              onChanged: onChanged))
    ]);
  }
}
