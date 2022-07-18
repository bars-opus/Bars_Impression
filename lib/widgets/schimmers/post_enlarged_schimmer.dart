import 'package:bars/utilities/exports.dart';

class PostSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width =
        Responsive.isDesktop(context) ? 700 : MediaQuery.of(context).size.width;

    return Center(
      child: Stack(alignment: FractionalOffset.bottomCenter, children: <Widget>[
        Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: ConfigBloc().darkModeOn ? Colors.grey[800] : Colors.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: ClipRRect(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: width,
                  decoration: BoxDecoration(
                    color: ConfigBloc().darkModeOn
                        ? Colors.grey[800]
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.6),
                          Colors.black.withOpacity(.6),
                        ],
                      ),
                    ),
                    child: ListView(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
            child: Container(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SchimmerSkeleton(
                              schimmerWidget: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                height:
                                    Responsive.isDesktop(context) ? 400 : 300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}
