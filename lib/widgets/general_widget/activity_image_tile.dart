import 'package:bars/utilities/exports.dart';

class ActivityImageTile extends StatelessWidget {
  final String seen;
  final String profileImageUrl;
  final String activityIndicator;
  final String activityTitle;
  final String activityContent;
  final String activityTime;
  final String userName;
  final String verified;

  final String activityImage;

  final VoidCallback onPressed;

  ActivityImageTile({
    required this.seen,
    required this.activityContent,
    required this.activityTime,
    required this.activityTitle,
    required this.profileImageUrl,
    required this.verified,
    required this.userName,
    required this.activityImage,
    required this.activityIndicator,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: ConfigBloc().darkModeOn
              ? BoxDecoration(
                  color:
                      seen == 'seen' ? Colors.transparent : Color(0xFF2B2B28),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                      BoxShadow(
                        color: seen == 'seen'
                            ? Colors.transparent
                            : Colors.black45,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: seen == 'seen'
                            ? Colors.transparent
                            : Colors.black45,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      )
                    ])
              : BoxDecoration(
                  color: seen == 'seen' ? Colors.transparent : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                      BoxShadow(
                        color: seen == 'seen'
                            ? Colors.transparent
                            : Colors.grey[500]!,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color:
                            seen == 'seen' ? Colors.transparent : Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      )
                    ]),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: ConfigBloc().darkModeOn
                  ? Color(0xFF1a1a1a)
                  : Color(0xFFf2f2f2),
              backgroundImage: profileImageUrl.isEmpty
                  ? AssetImage(
                      ConfigBloc().darkModeOn
                          ? 'assets/images/user_placeholder.png'
                          : 'assets/images/user_placeholder2.png',
                    ) as ImageProvider
                  : CachedNetworkImageProvider(profileImageUrl),
            ),
            trailing: CachedNetworkImage(
              imageUrl: activityImage,
              height: 40.0,
              width: 40.0,
              fit: BoxFit.cover,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text(
                        userName,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: seen == 'seen'
                              ? FontWeight.normal
                              : FontWeight.bold,
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    verified.isEmpty
                        ? SizedBox.shrink()
                        : Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(
                              MdiIcons.checkboxMarkedCircle,
                              size: 11,
                              color: Colors.blue,
                            ),
                          ),
                  ],
                ),
                RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: activityIndicator,
                          style: TextStyle(
                            fontSize: 14,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          )),
                      TextSpan(
                          text: activityTitle + '\n',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          )),
                      TextSpan(
                          text: activityContent,
                          style: TextStyle(
                            fontSize: 16,
                            color: seen == 'seen' ? Colors.grey : Colors.blue,
                          )),
                    ],
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            subtitle: Text(
              activityTime,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            onTap: onPressed,
          ),
        ),
      ],
    );
  }
}
