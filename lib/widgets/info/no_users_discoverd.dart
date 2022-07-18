import 'package:bars/utilities/exports.dart';

class NoUsersDicovered extends StatelessWidget {
  final String title;
  // final String subTitle;


  NoUsersDicovered(
      {required this.title,
      // @required this.subTitle,

  });

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'NO\n',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: title,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        )
                      ])
      ),
    );
  }
}
