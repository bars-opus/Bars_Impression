import 'package:bars/utilities/exports.dart';

class PageHint extends StatelessWidget {
  final String body;
  final String title;
  final String more;
  final double height;

  PageHint(
      {required this.body,
      required this.title,
      this.more = '',
      this.height = 70});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height,
          ),
          Text(
            title,
            style: TextStyle(
                color: ConfigBloc().darkModeOn ? Colors.grey : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(children: [
                TextSpan(
                  text: body + '...',
                  style: TextStyle(
                    color: ConfigBloc().darkModeOn ? Colors.grey : Colors.black,
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text: more,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ]),
              textAlign: TextAlign.center)
        ]);
  }
}
