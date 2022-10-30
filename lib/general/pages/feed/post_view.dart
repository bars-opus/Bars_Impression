import 'package:bars/utilities/exports.dart';
import 'package:bars/widgets/general_widget/postview_widget.dart';

class PostView extends StatelessWidget {
  final String currentUserId;
  final Post post;
  final Key key;
  final List<Post> postList;
  final bool showExplore;

  PostView(
      {required this.currentUserId,
      required this.post,
      required this.key,
      required this.postList,
      required this.showExplore});

  @override
  Widget build(BuildContext context) {
    return PostViewWidget(
      post: post,
      postList: postList,
      currentUserId: currentUserId,
    );
  }
}

