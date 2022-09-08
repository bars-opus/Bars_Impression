import 'package:bars/utilities/exports.dart';

class EventSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SchimmerSkeleton(
              schimmerWidget: Container(
                height: width / 2,
                width: width / 4,
                decoration: BoxDecoration(
                  color: ConfigBloc().darkModeOn
                      ? Colors.black.withOpacity(.5)
                      : Colors.black.withOpacity(.5),
                ),
                child: Container(
                  width: width / 1.5,
                  height: 50,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: width / 1.5,
                    height: MediaQuery.of(context).size.width / 2,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Material(
                            color: Colors.transparent,
                            child: SchimmerSkeleton(
                              schimmerWidget: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, right: 60),
                                child: Container(
                                  height: 15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.black.withOpacity(.5)
                                        : Colors.black.withOpacity(.5),
                                  ),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 60),
                          child: Material(
                              color: Colors.transparent,
                              child: SchimmerSkeleton(
                                schimmerWidget: Container(
                                  height: 15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.black.withOpacity(.5)
                                        : Colors.black.withOpacity(.5),
                                  ),
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 0),
                          child: Material(
                              color: Colors.transparent,
                              child: SchimmerSkeleton(
                                schimmerWidget: Container(
                                  height: 15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.black.withOpacity(.5)
                                        : Colors.black.withOpacity(.5),
                                  ),
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 0),
                          child: Material(
                              color: Colors.transparent,
                              child: SchimmerSkeleton(
                                schimmerWidget: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.black.withOpacity(.5)
                                        : Colors.black.withOpacity(.5),
                                  ),
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 0),
                          child: Material(
                              color: Colors.transparent,
                              child: SchimmerSkeleton(
                                schimmerWidget: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.black.withOpacity(.5)
                                        : Colors.black.withOpacity(.5),
                                  ),
                                ),
                              )),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, right: 0),
                              child: Material(
                                  color: Colors.transparent,
                                  child: SchimmerSkeleton(
                                    schimmerWidget: Container(
                                      height: 10,
                                      width: width / 2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.black.withOpacity(.5)
                                            : Colors.black.withOpacity(.5),
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, left: 0),
                              child: Material(
                                  color: Colors.transparent,
                                  child: SchimmerSkeleton(
                                    schimmerWidget: Container(
                                      height: 10,
                                      width: width / 2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.black.withOpacity(.5)
                                            : Colors.black.withOpacity(.5),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, right: 0),
                              child: Material(
                                  color: Colors.transparent,
                                  child: SchimmerSkeleton(
                                    schimmerWidget: Container(
                                      height: 10,
                                      width: width / 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.black.withOpacity(.5)
                                            : Colors.black.withOpacity(.5),
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, left: 0),
                              child: Material(
                                  color: Colors.transparent,
                                  child: SchimmerSkeleton(
                                    schimmerWidget: Container(
                                      height: 10,
                                      width: width / 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.black.withOpacity(.5)
                                            : Colors.black.withOpacity(.5),
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                              ),
                              child: Material(
                                  color: Colors.transparent,
                                  child: SchimmerSkeleton(
                                    schimmerWidget: Container(
                                      height: 10,
                                      width: width / 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.black.withOpacity(.5)
                                            : Colors.black.withOpacity(.5),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Divider(),
        )
      ],
    );
  }
}
