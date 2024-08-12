import 'package:bars/utilities/exports.dart';

class TicketPurchasingIcon extends StatelessWidget {
  final String title;
  final bool onlyWhite;

  TicketPurchasingIcon({required this.title, this.onlyWhite = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: onlyWhite
                    ? Colors.white
                    : Theme.of(context).secondaryHeaderColor,
                size: ResponsiveHelper.responsiveFontSize(context, 25),
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                  color: onlyWhite
                      ? Colors.white
                      : Theme.of(context).secondaryHeaderColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  height: 1),
            ),
          ],
        ),
      ],
    );
  }
}
