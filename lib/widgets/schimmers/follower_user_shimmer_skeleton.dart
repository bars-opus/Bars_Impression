import 'package:bars/utilities/exports.dart';

class FollowerUserSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: ResponsiveHelper.responsiveHeight(
                context,
                50,
              ),
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
                SchimmerSkeleton(
                  schimmerWidget: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFf2f2f2),
                      radius: ResponsiveHelper.responsiveHeight(
                        context,
                        25,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: SchimmerSkeleton(
                        schimmerWidget: Container(
                          height: ResponsiveHelper.responsiveHeight(
                            context,
                            10,
                          ),
                          width: ResponsiveHelper.responsiveHeight(
                            context,
                            100,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ]),
                            //
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: SchimmerSkeleton(
                        schimmerWidget: Container(
                          height: ResponsiveHelper.responsiveHeight(
                            context,
                            10,
                          ),
                          width: ResponsiveHelper.responsiveHeight(
                            context,
                            200,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ]),
                            //
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ResponsiveHelper.responsiveHeight(
                          context,
                          10,
                        ),
                      ),
                      child: RandomColorsContainer(),
                    ),
                  ],
                )
              ]),
            ),
            ColumnDivider(),
          ],
        ),
      )
    ]);
  }
}
