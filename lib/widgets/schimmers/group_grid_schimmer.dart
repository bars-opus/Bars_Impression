import 'package:bars/utilities/exports.dart';

class GroupGridSchimmerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
            ),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                      child: Stack(
                          alignment: FractionalOffset.bottomCenter,
                          children: <Widget>[
                        Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color:Theme.of(context).primaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 0.0,
                                        spreadRadius: 1.0,
                                      )
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Shimmer.fromColors(
                                    period: Duration(milliseconds: 1000),
                                    baseColor: Colors.black54,
                                    highlightColor: Colors.grey,
                                    child: Container(
                                      height: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomRight,
                                                colors: [
                                              Colors.black.withOpacity(.5),
                                              Colors.black.withOpacity(.5)
                                            ])),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10.0, left: 15.0, right: 15.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[]),
                              )
                            ])
                      ]));
              
              //  FutureBuilder(
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     return 
              //   },
              // );
            }));
  }
}
