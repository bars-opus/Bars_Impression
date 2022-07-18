import 'package:bars/utilities/exports.dart';

class PunchSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SchimmerSkeleton(
        schimmerWidget: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(.5),
              Colors.black.withOpacity(.5)
            ]),
            borderRadius: BorderRadius.circular(30),
            color: ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Colors.white,
          ),
          height: Responsive.isDesktop(context) ? 400 : 300,
        ),
      ),
    );
  }
}
