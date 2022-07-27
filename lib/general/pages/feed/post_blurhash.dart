import 'package:bars/utilities/exports.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class PostBlurHash extends StatelessWidget {
  final Post post;

  const PostBlurHash({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: FractionalOffset.bottomCenter,
      children: <Widget>[
        BlurHash(
          hash: post.blurHash.isEmpty
              ? 'LpQ0aNRkM{M{~qWBayWB4nofj[j['
              : post.blurHash,
          // image: post.imageUrl,
          imageFit: BoxFit.cover,
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
            Colors.black.withOpacity(.7),
            Colors.black.withOpacity(.7)
          ])),
        ),
      ],
    );
  }
}
