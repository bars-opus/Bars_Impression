import 'package:bars/utilities/exports.dart';

class ForumSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(children: [
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Material(
                      color: Colors.transparent,
                      child: SchimmerSkeleton(
                        schimmerWidget: Container(
                          height: 15,
                          decoration:  BoxDecoration(
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
             const   SizedBox(
                  height: 3.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Material(
                      color: Colors.transparent,
                      child: SchimmerSkeleton(
                        schimmerWidget: Container(
                          height: 10,
                          decoration:  BoxDecoration(
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
               const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Material(
                      color: Colors.transparent,
                      child: SchimmerSkeleton(
                        schimmerWidget: Container(
                          height: 10,
                          width: width / 3,
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
              const  SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Material(
                      color: Colors.transparent,
                      child: SchimmerSkeleton(
                        schimmerWidget: Container(
                          height: 10,
                          width: width / 2,
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
                ColumnDivider(),
              ]))
    ]);
  }
}
