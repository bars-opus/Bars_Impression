import 'package:bars/utilities/exports.dart';

class SearchUserTile extends StatelessWidget {
  final String profileImageUrl;
  final String userName;
  final String profileHandle;
  // final String company;
  final String bio;
  final bool verified;
  final VoidCallback onPressed;

  SearchUserTile(
      {required this.bio,
      // required this.company,
      required this.userName,
      required this.profileImageUrl,
      required this.profileHandle,
      required this.verified,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: profileImageUrl.isEmpty
          ? Icon(
              Icons.account_circle,
              size: ResponsiveHelper.responsiveHeight(context, 60.0),
              color: Colors.grey,
            )
          : CircleAvatar(
              radius: ResponsiveHelper.responsiveHeight(context, 25.0),
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              backgroundImage: CachedNetworkImageProvider(profileImageUrl),
            ),
      title: NameText(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
        name: userName.toUpperCase().trim().replaceAll('\n', ' '),
        verified: verified,
      ),

      // Align(
      //   alignment: Alignment.topLeft,
      //   child: Stack(
      //     alignment: Alignment.bottomRight,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.only(right: 12.0),
      //         child: Text(userName,
      //             style: TextStyle(
      //               fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      //               fontWeight: FontWeight.bold,
      //               color: Theme.of(context).secondaryHeaderColor,
      //             )),
      //       ),
      //       verified
      //           ? const SizedBox.shrink()
      //           : Positioned(
      //               top: 3,
      //               right: 0,
      //               child: Icon(
      //                 MdiIcons.checkboxMarkedCircle,
      //                 size: 11,
      //                 color: Colors.blue,
      //               ),
      //             ),
      //     ],
      //   ),
      // ),
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
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
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
            color: Colors.grey[350],
          )
        ],
      ),
      onTap: onPressed,
    );
  }
}
