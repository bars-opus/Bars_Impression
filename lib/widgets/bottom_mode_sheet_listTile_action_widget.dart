import 'package:bars/utilities/exports.dart';

class BottomModelSheetListTileActionWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final String colorCode;
  final bool dontPop;

  BottomModelSheetListTileActionWidget(
      {required this.onPressed,
      required this.text,
      this.dontPop = false,
      required this.icon,
      required this.colorCode});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BottomModalSheetButton(
        onPressed: dontPop
            ? () {
                onPressed();
              }
            : () {
                Navigator.pop(context);
                onPressed();
              },
       
        width: width.toDouble(),
        child: BottomModelSheetListTileWidget(
          icon: icon,
          colorCode: colorCode,
          text: text,
        ));
  }
}
