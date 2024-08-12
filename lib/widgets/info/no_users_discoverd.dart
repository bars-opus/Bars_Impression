import 'package:bars/utilities/exports.dart';

class NoUsersDicovered extends StatelessWidget {
  final String title;

  NoUsersDicovered({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
          text: TextSpan(children: [
            TextSpan(
              text: 'NO\n',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(
                  context,
                  40,
                ),
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            TextSpan(
              text: title,
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(
                  context,
                  14,
                ),
                color: Colors.grey,
              ),
            )
          ])),
    );
  }
}
