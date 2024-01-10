import 'package:bars/utilities/exports.dart';

class TicketPurchasingIcon extends StatelessWidget {
  final String title;
  // final IconData icon;
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
                // size: 20.0,
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                  // fontWeight: FontWeight.bold,
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
