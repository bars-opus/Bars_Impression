import 'package:bars/utilities/exports.dart';

class BlogSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: SchimmerSkeleton(
                schimmerWidget: Container(
                  height: width > 800 ? 70 : 50,
                  width: width > 800 ? 70 : 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(.5),
                            Colors.black.withOpacity(.5)
                          ])),
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
                SchimmerSkeleton(
                  schimmerWidget: Container(
                    width: width / 1.5,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(.5),
                              Colors.black.withOpacity(.5)
                            ])),
                  ),
                ),
                SizedBox(height: 2),
                SchimmerSkeleton(
                  schimmerWidget: Container(
                    width: width / 1.5,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(.5),
                              Colors.black.withOpacity(.5)
                            ])),
                  ),
                ),
                SizedBox(height: 2),
                SchimmerSkeleton(
                  schimmerWidget: Container(
                    width: width / 1.5,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(.5),
                              Colors.black.withOpacity(.5)
                            ])),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                  child: RandomColorsContainer(),
                ),
              ],
            ),
          ]),
      Padding(
          padding: const EdgeInsets.only(left: 70.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SchimmerSkeleton(
                schimmerWidget: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(.5),
                              Colors.black.withOpacity(.5)
                            ])),
                  ),
                ),
              ),
              SizedBox(
                height: 3.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
              ),
              SizedBox(
                height: 3.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
              ),
              SizedBox(
                height: 3.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
              ),
              SizedBox(
                height: 3.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
              ),
              SizedBox(
                height: 3.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
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
          )),
      ColumnDivider(),
    ]);
  }
}
