import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class Authorview extends StatelessWidget {
  final String userName;
  final String shopType;
  final String profileImageUrl;
  final bool verified;
  final String authorId;
  final String report;
  final String content;
  final String from;
  final bool isreplyWidget;
  final bool showReply;
  final bool isPostAuthor;
  final bool showSeeAllReplies;
  final int replyCount;
  final Timestamp timestamp;
  final VoidCallback onPressedReport;
  final VoidCallback onPressedReply;
  final VoidCallback onPressedSeeAllReplies;

  Authorview({
    required this.content,
    required this.report,
    required this.timestamp,
    required this.userName,
    required this.shopType,
    required this.profileImageUrl,
    required this.verified,
    required this.authorId,
    required this.from,
    required this.onPressedReport,
    this.isreplyWidget = false,
    this.showReply = true,
    required this.onPressedReply,
    required this.onPressedSeeAllReplies,
    required this.replyCount,
    this.showSeeAllReplies = false,
    required this.isPostAuthor,
  });

  _action(BuildContext context, String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
          ),
          overflow: TextOverflow.ellipsis,
          textScaler: MediaQuery.of(context).textScaler,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    String currentUserId = Provider.of<UserData>(context).currentUserId!;
    bool isAuthor = currentUserId == authorId;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
      child: FocusedMenuHolder(
        menuWidth: width.toDouble(),
        menuItemExtent: 60,
        menuOffset: 10,
        blurBackgroundColor: Colors.transparent,
        openWithTap: false,
        onPressed: () {},
        menuItems: [
          FocusedMenuItem(
              title: _action(
                context,
                isAuthor ? 'Edit' : 'Report',
              ),
              onPressed: onPressedReport),
          FocusedMenuItem(
            title: _action(
              context,
              'Suggest',
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SuggestionBox()));
            },
          ),
        ],
        child: Container(
          color: Theme.of(context).cardColor,
          child: ListTile(
            leading: profileImageUrl.isEmpty
                ? Icon(
                    Icons.account_circle,
                    size: isreplyWidget
                        ? ResponsiveHelper.responsiveHeight(context, 35.0)
                        : ResponsiveHelper.responsiveHeight(context, 40.0),
                    color: Colors.grey,
                  )
                : CircleAvatar(
                    radius: isreplyWidget
                        ? ResponsiveHelper.responsiveHeight(context, 15.0)
                        : ResponsiveHelper.responsiveHeight(context, 18.0),
                    backgroundColor: Colors.blue,
                    backgroundImage: CachedNetworkImageProvider(profileImageUrl,
                        errorListener: (_) {
                      return;
                    }),
                  ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NameText(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                  name: userName.toUpperCase().trim().replaceAll('\n', ' '),
                  verified: verified,
                ),
                RichText(
                    textScaler: MediaQuery.of(context).textScaler,
                    text: TextSpan(children: [
                      TextSpan(
                          text: shopType,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 10),
                            color: Colors.blue,
                          )),
                      TextSpan(
                          text: isPostAuthor ? '  Author' : '',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 10),
                            color: Colors.red,
                          ))
                    ])),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Container(
                    color: from.startsWith('Comment')
                        ? Colors.cyan[800]
                        : Color(0xFFFF2D55),
                    height: 1.0,
                    width: 50.0,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: report.isNotEmpty
                      ? Text(
                          content,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12),
                            color: Colors.grey,
                            decorationColor: Colors.grey,
                            decorationStyle: TextDecorationStyle.solid,
                            decoration: TextDecoration.lineThrough,
                          ),
                          maxLines: 5,
                        )
                      : HyperLinkText(
                          from: from,
                          text: content,
                        ),
                ),
                Text(
                    timeago.format(
                      timestamp.toDate(),
                    ),
                    style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 10),
                        color: Colors.grey)),
                if (showReply)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: onPressedReply,
                        child: RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: TextSpan(children: [
                              TextSpan(
                                text: 'Reply: ',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 12),
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ])),
                      ),
                      showSeeAllReplies
                          ? GestureDetector(
                              onTap: onPressedSeeAllReplies,
                              child: Text(
                                replyCount < 3
                                    ? ''
                                    : 'See all ${replyCount.toString()} replies',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 12),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  )
              ],
            ),
            onTap: () => authorId.isEmpty
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UserNotFound(
                              userName: 'user',
                            )))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              user: null,
                              currentUserId: currentUserId,
                              userId: authorId, accountType: shopType,
                            ))),
          ),
        ),
      ),
    );
  }
}
