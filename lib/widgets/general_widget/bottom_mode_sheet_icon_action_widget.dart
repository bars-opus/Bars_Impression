import 'package:bars/utilities/exports.dart';

class BottomModelSheetIconActionWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final bool dontPop;
  final Color? color;
  final bool minor;

  BottomModelSheetIconActionWidget(
      {required this.onPressed,
      required this.text,
      required this.icon,
      this.dontPop = false,
      this.color,
      this.minor = false});

  @override
  Widget build(BuildContext context) {
    return BottomModalSheetButton(
        isMinor: minor,
        onPressed: dontPop
            ? () {
                onPressed();
              }
            : () {
                Navigator.pop(context);
                onPressed();
              },
        width: ResponsiveHelper.responsiveWidth(context, 177),
        child: BottomModelSheetIconsWidget(
          minor: minor,
          color: color,
          icon: icon,
          text: text,
        ));
  }
}
