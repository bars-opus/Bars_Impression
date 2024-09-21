import 'package:bars/utilities/exports.dart';

class Loading extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final double iconSize;
  final bool shakeReapeat;

  Loading({
    required this.title,
    required this.icon,
    this.color = Colors.white,
    this.iconSize = 150.0,
    this.shakeReapeat = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          shakeReapeat
              ? ShakeTransition(
                  curve: Curves.easeInOutBack,
                  axis: Axis.vertical,
                  duration: Duration(milliseconds: 1300),
                  child: Padding(
                    padding: EdgeInsets.only(right: shakeReapeat ? 60.0 : 0),
                    child: RepeatShakeTransition(
                        child: SizedBox(
                            height:
                                ResponsiveHelper.responsiveHeight(context, 60),
                            width:
                                ResponsiveHelper.responsiveHeight(context, 60),
                            child: AnimatedCircle(
                              animateShape: true,
                            ))),
                  ),
                )
              : AnimatedCircle(
                  size: 50,
                  stroke: 3,
                  animateShape: true,
                  animateSize: true,
                ),
          // SizedBox(height: 10),
          RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(children: [
              if (shakeReapeat)
                if (title.isNotEmpty)
                  TextSpan(
                    text: 'Please wait',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                      color: color,
                    ),
                  ),
              // TextSpan(
              //   text: 'wait\n',
              //   style: TextStyle(
              //     fontSize: ResponsiveHelper.responsiveFontSize(context, 30.0),
              //     fontWeight: FontWeight.w100,
              //     color: color,
              //   ),
              // ),

              TextSpan(
                text: "\n${title}",
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: color,
                ),
              ),
              // TextSpan(
              //   text: '...',
              //   style: TextStyle(
              //     fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
              //     color: color,
              //     fontWeight: FontWeight.bold,
              //   ),
              // )
            ]),
            textAlign: TextAlign.end,
          ),
          SizedBox(height: 3),
          if (shakeReapeat)
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
