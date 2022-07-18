import 'package:bars/utilities/exports.dart';

class ExploreForumsSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SchimmerSkeleton(
      schimmerWidget: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
            Colors.black.withOpacity(.5),
            Colors.black.withOpacity(.5)
          ]),
          color: ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Colors.white,
        ),
        height: 200,
      ),
    );
  }
}
