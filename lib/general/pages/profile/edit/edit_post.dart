import 'package:bars/utilities/exports.dart';

class EditPost extends StatefulWidget {
  final Post post;
  final String currentUserId;
  static final id = 'Edit_posts';

  EditPost({required this.post, required this.currentUserId});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  Widget build(BuildContext context) {
    return CreatePostWidget(
      artist: widget.post.artist,
      caption: widget.post.caption,
      image: null,
      musicLink: widget.post.musicLink,
      isEditting: true,
      punch: widget.post.punch,
      // user: null,
      imageUrl: widget.post.imageUrl,
      post: widget.post,
      hashTag: widget.post.hashTag,
    );
  }
}
