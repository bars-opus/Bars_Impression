import 'package:bars/utilities/exports.dart';

class CommentSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 30),
            child: Material(
                color: Colors.transparent,
                child: SchimmerSkeleton(
                  schimmerWidget: Container(
                    height:  ResponsiveHelper.responsiveHeight(context, 10,),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                          Colors.black.withOpacity(.5),
                          Colors.black.withOpacity(.5)
                        ])),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 30),
            child: Material(
                color: Colors.transparent,
                child: SchimmerSkeleton(
                  schimmerWidget: Container(
                    height:  ResponsiveHelper.responsiveHeight(context, 10,),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                          Colors.black.withOpacity(.5),
                          Colors.black.withOpacity(.5)
                        ])),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 30),
            child: Material(
                color: Colors.transparent,
                child: SchimmerSkeleton(
                  schimmerWidget: Container(
                    height:  ResponsiveHelper.responsiveHeight(context, 10,),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                          Colors.black.withOpacity(.5),
                          Colors.black.withOpacity(.5)
                        ])),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 30),
            child: Material(
                color: Colors.transparent,
                child: SchimmerSkeleton(
                  schimmerWidget: Container(
                    height:  ResponsiveHelper.responsiveHeight(context, 10,),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                          Colors.black.withOpacity(.5),
                          Colors.black.withOpacity(.5)
                        ])),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
