import 'package:bars/utilities/exports.dart';

class Loading extends StatelessWidget {
  final String title;

  final IconData icon;

  Loading({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShakeTransition(
          curve: Curves.easeInOutBack,
          axis: Axis.vertical,
          duration: Duration(milliseconds: 1300),
          child: RepeatShakeTransition(
            child: Icon(
              icon,
              color: Colors.white,
              size: 150.0,
            ),
          ),
        ),
        SizedBox(height: 10),
        FadeAnimation(
          1,
          RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(children: [
                TextSpan(
                  text: 'Please ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'wait\n',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                TextSpan(
                  text: '...',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ])),
        ),
        SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 30),
          child: SizedBox(
            height: 2.0,
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
      ],
    ));
  }
}
