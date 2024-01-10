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
          color: Theme.of(context).primaryColorLight,
        ),
        height: ResponsiveHelper.responsiveHeight(context, 200,),
      ),
    );
  }
}
