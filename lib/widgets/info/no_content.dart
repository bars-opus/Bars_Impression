import 'package:bars/utilities/exports.dart';

class NoContents extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  NoContents({
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(
                icon,
                color: Colors.grey,
                size: 50.0,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
                color: ConfigBloc().darkModeOn
                    ? Color(0xFFf2f2f2)
                    : Color(0xFF1a1a1a),
                fontSize: 16.0,
                height: 1),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30),
            child: Text(
              subTitle,
              style: TextStyle(color: Colors.grey, fontSize: 12.0, height: 1),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
