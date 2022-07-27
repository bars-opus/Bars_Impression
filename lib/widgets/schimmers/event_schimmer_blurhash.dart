import 'package:bars/utilities/exports.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class EventSchimmerBlurHash extends StatelessWidget {
  final Event event;

  const EventSchimmerBlurHash({Key? key, required this.event})
      : super(key: key);

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
            Container(
              height: width / 2,
              width: width / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ConfigBloc().darkModeOn
                    ? Color(0xFF1a1a1a)
                    : Color(0xFFf2f2f2),
              ),
              child: BlurHash(
                hash: event.blurHash.isEmpty
                    ? 'LpQ0aNRkM{M{~qWBayWB4nofj[j['
                    : event.blurHash,
                imageFit: BoxFit.cover,
              ),
            ),
            // ),
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
                                          ? Colors.black
                                          : Colors.grey,
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
                          padding: const EdgeInsets.only(top: 5.0, right: 0),
                          child: Material(
                              color: Colors.transparent,
                              child: SchimmerSkeleton(
                                schimmerWidget: Container(
                                  height: 15,
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
                                          ? Colors.black
                                          : Colors.grey,
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
                          padding: const EdgeInsets.only(top: 5.0, right: 0),
                          child: Material(
                              color: Colors.transparent,
                              child: SchimmerSkeleton(
                                schimmerWidget: Container(
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
