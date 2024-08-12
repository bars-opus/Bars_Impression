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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        width: width.toDouble(),
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
              padding: const EdgeInsets.all(12.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
