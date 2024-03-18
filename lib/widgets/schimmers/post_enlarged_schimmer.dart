import 'package:bars/utilities/exports.dart';

class PostSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF1a1a1a),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 90.0,
                height: 90.0,
                child: Image.asset(
                  'assets/images/bars.png',
                )),
            const SizedBox(
              height: 30,
            ),
            CircularProgress(
              isMini: true,
              indicatorColor: Colors.grey[800] ?? Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
