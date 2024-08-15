import 'package:bars/utilities/exports.dart';

class UserHeaderListTileWidget extends StatelessWidget {
  var user;
  final Widget trailing;
  final VoidCallback onPressed;

  UserHeaderListTileWidget(
      {super.key,
      required this.user,
      this.trailing = const SizedBox.shrink(),
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      trailing: trailing,
      leading: user.profileImageUrl.isEmpty
          ? Icon(
              Icons.account_circle,
              size: ResponsiveHelper.responsiveHeight(context, 50.0),
              color: Colors.grey,
            )
          : Container(
              height: ResponsiveHelper.responsiveHeight(context, 40.0),
              width: ResponsiveHelper.responsiveHeight(context, 40.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(user.profileImageUrl!,errorListener: (_) {
                            return;
                          }),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      title: RichText(
        textScaler: MediaQuery.of(context).textScaler,
        text: TextSpan(
          children: [
            TextSpan(
                text: user.userName!.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium),
            TextSpan(
              text: "\n${user.profileHandle}",
              style: TextStyle(
                color: Colors.blue,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              ),
            )
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
