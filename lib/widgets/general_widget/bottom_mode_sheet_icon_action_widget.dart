import 'package:bars/utilities/exports.dart';

class BottomModelSheetIconActionWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final bool dontPop;
  final Color? textcolor;
  final Color? buttoncolor;

  final bool minor;
  final bool mini;

  BottomModelSheetIconActionWidget(
      {required this.onPressed,
      required this.text,
      required this.icon,
      this.dontPop = false,
      this.textcolor,
      this.buttoncolor,
      this.minor = false,
      this.mini = false});

  @override
  Widget build(BuildContext context) {
    return BottomModalSheetButton(
        isMinor: minor,
        isMini: mini,
        buttoncolor: buttoncolor,
        onPressed: dontPop
            ? () {
                onPressed();
              }
            : () {
                Navigator.pop(context);
                onPressed();
              },
        width: ResponsiveHelper.responsiveWidth(context, mini ? 120 : 177),

        // mini ? 120 : 185,
        child: BottomModelSheetIconsWidget(
          minor: minor,
          mini: mini,
          textcolor: textcolor,
          icon: icon,
          text: text,
        ));
  }
}
