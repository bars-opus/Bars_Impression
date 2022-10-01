import 'package:bars/utilities/exports.dart';

class CreatePost extends StatefulWidget {
  static final id = 'Create_posts';
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String _caption = '';
  String _artist = '';
  String _punch = '';
  String _musicLink = '';
  String _hashTag = '';

  @override
  Widget build(BuildContext context) {
    return CreatePostWidget(
      artist: _artist,
      caption: _caption,
      image: null,
      musicLink: _musicLink,
      isEditting: false,
      punch: _punch,
      imageUrl: '',
      post: null,
      hashTag: _hashTag,
    );
  }
}
