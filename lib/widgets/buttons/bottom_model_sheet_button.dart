import '../../utilities/exports.dart';

class BottomModalSheetButton extends StatelessWidget {
  final double width;
  final Widget child;

  final VoidCallback? onPressed;
  final bool isMinor;

  BottomModalSheetButton({
    required this.width,
    required this.child,
    required this.onPressed,
    this.isMinor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.responsiveHeight(context, 1.0),
      ),
      child: Container(
        width: isMinor ? 175 : width,
        height: isMinor ? 60 : null,
        child: TextButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
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
                ResponsiveHelper.responsiveHeight(context, 12.0),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
