import 'package:bars/utilities/exports.dart';

class BottomModelSheetIconActionWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final bool dontPop;
    final Color? color;


  BottomModelSheetIconActionWidget({
    required this.onPressed,
    required this.text,
    required this.icon,
    this.dontPop = false,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return BottomModalSheetButton(
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
          color: color,
          icon: icon,
          text: text,
        ));
  }
}
