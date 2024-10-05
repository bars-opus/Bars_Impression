import 'package:bars/utilities/exports.dart';

class PostSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF013e9d),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedCircle(
              size: 30,
              stroke: 2,
              animateSize: true,
              animateShape: true,
              firstColor: Colors.white,
            ),
            Container(
              width: ResponsiveHelper.responsiveWidth(context, 50),
              height: ResponsiveHelper.responsiveWidth(context, 50),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/images/welcome.png',
                      fit: BoxFit.cover)),
            ),

            // Container(
            //     width: 90.0,
            //     height: 90.0,
            //     child: Image.asset(
            //       'assets/images/florenceLauncher.png',
            //     )),
            // const SizedBox(
            //   height: 30,
            // ),
            // CircularProgress(
            //   isMini: true,
            //   indicatorColor: Colors.white,
            // )
          ],
        ),
      ),
    );
  }
}




