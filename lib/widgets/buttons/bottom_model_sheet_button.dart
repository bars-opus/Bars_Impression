import '../../utilities/exports.dart';

class BottomModalSheetButton extends StatelessWidget {
  final double width;
  final Widget child;

  final VoidCallback? onPressed;
  final bool isMinor;
  final bool isMini;
  final Color? buttoncolor;

  BottomModalSheetButton({
    required this.width,
    required this.child,
    required this.onPressed,
    this.isMinor = false,
    this.isMini = false,
    this.buttoncolor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.responsiveHeight(context, 1.0),
      ),
      child: Container(
        // color: Colors.blue,
        width: isMinor
            ? 177
            : isMini
                ? 120
                : width,
        height: isMinor || isMini ? 60 : null,
        child: TextButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                buttoncolor != null ? buttoncolor : Theme.of(context).cardColor,
            foregroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isMinor ? 10 : 5.0),
            ),
          ),
          onPressed: onPressed,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(
                5,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
