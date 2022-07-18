import 'package:bars/utilities/exports.dart';


class UserSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SchimmerSkeleton(
        schimmerWidget: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: const CircleAvatar(
            backgroundColor: Color(0xFFf2f2f2),
            radius: 25.0,
          ),
        ),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[ Material(
                        color: Colors.transparent,
                        child: SchimmerSkeleton(
                          schimmerWidget: Container(
                            height: 10,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: SchimmerSkeleton(
                          schimmerWidget: Container(
                            height: 10,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.5)
                                  ]),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                        child: RandomColorsContainer(),
                      ),
                   
            Column(
              children: <Widget>[
                Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
                const SizedBox(height: 5),
                Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
                const SizedBox(height: 5),
                Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
                const SizedBox(height: 5),
                Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
                const SizedBox(height: 5),
                Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
                const SizedBox(height: 5),
                Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
                const SizedBox(height: 5),
                Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )),
                const SizedBox(height: 5),
                Material(
                    color: Colors.transparent,
                    child: SchimmerSkeleton(
                      schimmerWidget: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.5)
                                ])),
                      ),
                    )), ColumnDivider(),
              ],
            )]));
    
  }
}
