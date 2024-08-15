import 'package:bars/utilities/exports.dart';

class SearchUserTile extends StatelessWidget {
  final String profileImageUrl;
  final String userName;
  final String profileHandle;
  final String bio;
  final bool verified;
  final VoidCallback onPressed;

  SearchUserTile(
      {required this.bio,
      required this.userName,
      required this.profileImageUrl,
      required this.profileHandle,
      required this.verified,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColorLight,
      ),
      child: ListTile(
        leading: profileImageUrl.isEmpty
            ? Icon(
                Icons.account_circle,
                size: ResponsiveHelper.responsiveHeight(context, 60.0),
                color: Colors.grey,
              )
            : CircleAvatar(
                radius: ResponsiveHelper.responsiveHeight(context, 25.0),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                backgroundImage: CachedNetworkImageProvider(profileImageUrl,   errorListener: (_) {
                                  return;
                                }),
              ),
        title: NameText(
          fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
          name: userName.toUpperCase().trim().replaceAll('\n', ' '),
          verified: verified,
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
                    color: Colors.purple,
                    height: 1.0,
                    width: 25.0,
                  ),
                ),
              ],
            ),
            Text(profileHandle,
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                  color: Colors.blue,
                )),
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              maxLines: 3,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Bio:  ",
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 10.0),
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    text: bio,
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 20.0,
            ),
            Divider(
              thickness: .2,
              color: Colors.grey[350],
            )
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}
