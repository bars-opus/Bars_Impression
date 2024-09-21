import 'package:bars/utilities/exports.dart';

class BottomModelSheetListTileActionWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final String colorCode;
  final bool dontPop;
    final bool isLoading;


  BottomModelSheetListTileActionWidget(
      {required this.onPressed,
      required this.text,
      this.dontPop = false,
        this.isLoading = false,
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
          isLoading: isLoading,
          icon: icon,
          colorCode: colorCode,
          text: text,
        ));
  }
}
