import 'package:bars/utilities/exports.dart';

class TagPage extends StatelessWidget {
  final TaggedNotificationModel currentTag;
  final String currentUserId;

  const TagPage({
    super.key,
    required this.currentTag,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return EditProfileScaffold(
        title: 'Tag',
        widget: TagWidget(
          currentTag: currentTag,
          currentUserId: currentUserId,
        ));
  }
}
