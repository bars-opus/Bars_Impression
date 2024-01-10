import 'package:bars/utilities/exports.dart';

class UserListTile extends StatelessWidget {
  final AccountHolderAuthor user;
  final VoidCallback onPressed;

  UserListTile({required this.user, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ListTile(
          leading: user.profileImageUrl!.isEmpty
              ? Icon(
                  Icons.account_circle,
                  size: ResponsiveHelper.responsiveHeight(context, 60.0),
                  color: Colors.grey,
                )
              : CircleAvatar(
                  radius: ResponsiveHelper.responsiveHeight(context, 25.0),
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage:
                      CachedNetworkImageProvider(user.profileImageUrl!),
                ),
          title: Align(
            alignment: Alignment.topLeft,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(user.userName!,
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).secondaryHeaderColor,
                      )),
                ),
                user.verified!
                    ? const SizedBox.shrink()
                    : Positioned(
                        top: 3,
                        right: 0,
                        child: Icon(
                          MdiIcons.checkboxMarkedCircle,
                          size:
                              ResponsiveHelper.responsiveHeight(context, 12.0),
                          color: Colors.blue,
                        ),
                      ),
              ],
            ),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Container(
                      color: Colors.yellow,
                      height: 1.0,
                      width: 25.0,
                    ),
                  ),
                ],
              ),
              Text(user.profileHandle!,
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                    color: Colors.blue,
                  )),
              Text(
                user.bio!,
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.grey[350],
              )
            ],
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
