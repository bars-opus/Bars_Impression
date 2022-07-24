import 'package:bars/utilities/exports.dart';

class NoFeed extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonText;
  final VoidCallback onPressed;

  NoFeed(
      {required this.title,
      required this.subTitle,
      required this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(title,
                  style: TextStyle(
                    fontSize: width > 800 ? 40 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 5.0,
              ),
              Text(subTitle,
                  style: TextStyle(
                    fontSize: width > 800 ? 18 : 14,
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 2.0,
                width: 10,
                color: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                child: Text(
                  "Explore with it",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: width > 800 ? 18 : 14,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              AvatarGlow(
                animate: true,
                showTwoGlows: true,
                shape: BoxShape.circle,
                glowColor: Colors.blue,
                endRadius: 100,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 3000),
                child: Container(
                  width: width > 800 ? 300 : 150,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.blue,
                      side: BorderSide(width: 1.0, color: Colors.blue),
                    ),
                    onPressed: onPressed,
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: width > 800 ? 16 : 12,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
