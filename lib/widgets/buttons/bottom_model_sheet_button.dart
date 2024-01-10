import '../../utilities/exports.dart';

class BottomModalSheetButton extends StatelessWidget {
  final double width;
  final Widget child;

  final VoidCallback? onPressed;

  BottomModalSheetButton(
      {required this.width, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.responsiveHeight(context, 1.0),
      ),
      child: Container(
        width: width,
        child: TextButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
            foregroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
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
