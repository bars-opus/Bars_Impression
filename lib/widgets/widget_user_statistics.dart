import 'package:bars/utilities/exports.dart';

class UserStatistics extends StatelessWidget {
  final String count;
  final String title;
  final String subTitle;
  final Color countColor;
  final Color titleColor;
  final VoidCallback onPressed;

  UserStatistics(
      {required this.count,
      required this.countColor,
      required this.titleColor,
      required this.title,
      required this.subTitle,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: new Container(
        width: 150.0,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Text(
                count,
                style: TextStyle(
                  color: countColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                subTitle,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
