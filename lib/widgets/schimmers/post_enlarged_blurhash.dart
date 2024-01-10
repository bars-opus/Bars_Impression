import 'package:bars/utilities/exports.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class PostEnlargedBlurharsh extends StatelessWidget {
  final Post post;

  const PostEnlargedBlurharsh({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Center(
      child: Stack(alignment: FractionalOffset.bottomCenter, children: <Widget>[
        Stack(children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: width,
            child: BlurHash(
              hash: post.blurHash.isEmpty
                  ? 'LpQ0aNRkM{M{~qWBayWB4nofj[j['
                  : post.blurHash,
              imageFit: BoxFit.cover,
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              width: width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(.6),
                  Colors.black.withOpacity(.6),
                ],
              ))),
          SingleChildScrollView(
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
                                ResponsiveHelper.responsiveHeight(context, 300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}
