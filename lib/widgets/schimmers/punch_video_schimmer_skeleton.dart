import 'package:bars/utilities/exports.dart';

class PunchVideoSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width =
        Responsive.isDesktop(context) ? 700 : MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              SchimmerSkeleton(
                schimmerWidget: Container(
                  height: width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                        Colors.black.withOpacity(.5),
                        Colors.black.withOpacity(.5)
                      ])),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: SchimmerSkeleton(
                    schimmerWidget: Container(
                      height: 30,
                      width: width / 3,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                            Colors.black.withOpacity(.5),
                            Colors.black.withOpacity(.5)
                          ])),
                    ),
                  )),
              SizedBox(height: 2),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: SchimmerSkeleton(
                    schimmerWidget: Container(
                      height: 20,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                            Colors.black.withOpacity(.5),
                            Colors.black.withOpacity(.5)
                          ])),
                    ),
                  )),
              SizedBox(height: 5),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: SchimmerSkeleton(
                    schimmerWidget: Container(
                      height: 10,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                            Colors.black.withOpacity(.5),
                            Colors.black.withOpacity(.5)
                          ])),
                    ),
                  )),
              SizedBox(height: 1),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: SchimmerSkeleton(
                    schimmerWidget: Container(
                      height: 10,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                            Colors.black.withOpacity(.5),
                            Colors.black.withOpacity(.5)
                          ])),
                    ),
                  )),
              SizedBox(height: 30),
            ]),
      ),
    );
  }
}
