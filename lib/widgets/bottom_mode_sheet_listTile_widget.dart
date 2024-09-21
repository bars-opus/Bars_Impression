import 'package:bars/utilities/exports.dart';

class BottomModelSheetListTileWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String colorCode;
  final bool isLoading;

  BottomModelSheetListTileWidget({
    required this.icon,
    required this.text,
    this.colorCode = '',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color newColor = colorCode.startsWith('Blue')
        ? Colors.blue
        : colorCode.startsWith('Red')
            ? Colors.red
            : colorCode.startsWith('Grey')
                ? Colors.grey
                : Theme.of(context).secondaryHeaderColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        isLoading
            ? Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 10),
                child: SizedBox(
                  height: ResponsiveHelper.responsiveHeight(context, 15),
                  width: ResponsiveHelper.responsiveHeight(context, 15),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                    strokeWidth:
                        ResponsiveHelper.responsiveFontSize(context, 2.0),
                  ),
                ),
              )
            : Icon(
                icon,
                color: newColor,
                size: ResponsiveHelper.responsiveHeight(context, 25),
              ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                color: newColor,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                fontWeight: FontWeight.normal),
            // overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
