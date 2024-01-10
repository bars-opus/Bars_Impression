import 'package:bars/utilities/exports.dart';

class Loading extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final double iconSize;

  Loading({
    required this.title,
    required this.icon,
    this.color = Colors.white,
    this.iconSize = 150.0,
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
                color: color,
                size: iconSize,
              ),
            ),
          ),
          SizedBox(height: 10),
          RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(children: [
                TextSpan(
                  text: 'Please ',
                  style: TextStyle(
                    fontSize:  ResponsiveHelper.responsiveFontSize(context, 20.0),
                    color: color,
                  ),
                ),
                TextSpan(
                  text: 'wait\n',
                  style: TextStyle(
                    fontSize:  ResponsiveHelper.responsiveFontSize(context, 20.0),
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                TextSpan(
                  text: title,
                  style: TextStyle( 
                    fontSize:  ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: color,
                  ),
                ),
                TextSpan(
                  text: '...',
                  style: TextStyle(
                    fontSize:  ResponsiveHelper.responsiveFontSize(context, 18.0),
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ])),
          SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 30),
            child: SizedBox(
              height: 1.0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ]));
  }
}
