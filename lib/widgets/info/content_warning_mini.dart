import 'package:bars/utilities/exports.dart';

class ContentWarningMini extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShakeTransition(
            child: Icon(
              MdiIcons.eyeOff,
              color: Colors.grey,
              size: 50.0,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Material(
            color: Colors.transparent,
            child: Text(
              "REPORTED\nCONTENT",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
