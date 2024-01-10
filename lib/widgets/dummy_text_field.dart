

import 'package:bars/utilities/exports.dart';

class DummyTextField extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  DummyTextField({required this.text, required this.onPressed});

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
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).secondaryHeaderColor,
                fontSize:  ResponsiveHelper.responsiveFontSize(context, 14.0),
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 0.7,
              width: double.infinity,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
