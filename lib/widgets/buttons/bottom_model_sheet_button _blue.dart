import '../../utilities/exports.dart';

class BottomModalSheetButtonBlue extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final bool dissable;

  BottomModalSheetButtonBlue({
    required this.buttonText,
    required this.onPressed,
    this.dissable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
            width: ResponsiveHelper.responsiveHeight(context,  250,),

      // width: width.toDouble(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              dissable ? Theme.of(context).primaryColor : Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onPressed: onPressed,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              buttonText,
              style: TextStyle(
                color: dissable
                    ? Theme.of(context).secondaryHeaderColor
                    : Colors.white,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
