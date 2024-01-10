import 'package:bars/utilities/exports.dart';

class NoFollowers extends StatelessWidget {
  final String from;
  final String userName;

  final bool isCurrentUser;

  const NoFollowers(
      {super.key,
      required this.from,
      required this.isCurrentUser,
      required this.userName});

  @override
  Widget build(BuildContext context) {
    return EditProfileScaffold(
      title: '',
      widget: Container(
        height: ResponsiveHelper.responsiveHeight(context, 500),
        child: Center(
          child: NoContents(
            icon: (from == 'Follower'
                ? Icons.people_outline
                : Icons.person_outline),
            title: from == 'Follower' ? 'No followers yet,' : 'Not following',
            subTitle: from == 'Follower'
                ? isCurrentUser
                    ? 'You currently have no followers. This section will display the profiles of people who choose to follow you. '
                    : '$userName currently has no followers. This section will display the profiles of people who choose to follow $userName. '
                : isCurrentUser
                    ? 'You are not currently following anyone. This section will display the profiles of the people you choose to follow. '
                    : '$userName is not currently following anyone. This section will display the profiles of the people $userName choose to follow',
          ),
        ),
      ),
    );
  }
}
