import 'package:bars/utilities/exports.dart';

class EventSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: width / 2,
        width: width / 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SchimmerSkeleton(
              schimmerWidget: Container(
                height: width / 2,
                width: width / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Color(0xFFf2f2f2),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: width / 2,
              width: width / 1.5,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    new SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    new SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    new SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    new SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    new SchimmerSkeleton(
                      schimmerWidget: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 10),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.grey,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ])),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
