import 'package:bars/utilities/exports.dart';

class DummyTextField extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  DummyTextField({required this.text, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: Theme.of(context).secondaryHeaderColor,
                    size: ResponsiveHelper.responsiveFontSize(context, 25),
                  ),
                if (icon != null) SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (icon == null)
              Divider(
                thickness: .2,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
