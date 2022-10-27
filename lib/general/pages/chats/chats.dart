import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class Chats extends StatefulWidget {
  static final id = 'Chats';
  final String currentUserId;
  final String? userId;
  // final int activityChatCount;

  Chats({
    required this.currentUserId,
    required this.userId,
    // required this.activityChatCount,
  });

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {


  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            title: Text(
              'Chats',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: usersRef
                    .doc(widget.currentUserId)
                    .collection('chats')
                    .orderBy('newMessageTimestamp', descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return Expanded(
                        child: Center(
                          child: NoContents(
                            icon: (MdiIcons.send),
                            title: 'No Chats.',
                            subTitle:
                                'Your chats and messages would appear here. ',
                          ),
                        ),
                      );
                    }
                    return Expanded(
                        child: Scrollbar(
                            child: CustomScrollView(slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            Chat chats =
                                Chat.fromDoc(snapshot.data.docs[index]);

                            String userId = snapshot.data.docs[index].id;
                            var lastMessage =
                                snapshot.data.docs[index]['lastMessage'];
                            var seen = snapshot.data.docs[index]['seen'];

                            return FutureBuilder(
                                future: DatabaseService.getUserWithId(userId),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox.shrink();
                                  }
                                  AccountHolder author = snapshot.data;

                                  return _display(
                                    author: author,
                                    chats: chats,
                                    lastMessage: lastMessage,
                                    seen: seen,
                                    userId: userId,
                                  );
                                });
                          },
                          childCount: snapshot.data.docs.length,
                        ),
                      )
                    ])));
                  }
                  return Expanded(
                    child: Center(
                      child: SizedBox(
                        height: 250,
                        width: 250,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.teal,
                          ),
                          strokeWidth: 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}

//display
// ignore: must_be_immutable
class _display extends StatelessWidget {
  final AccountHolder author;
  final Chat chats;
  String lastMessage;
  String seen;
  final String userId;

  _display({
    required this.author,
    required this.chats,
    required this.lastMessage,
    required this.seen,
    required this.userId,
  });
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: FocusedMenuHolder(
        menuWidth: width,
        menuOffset: 1,
        blurBackgroundColor:
            ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white10,
        openWithTap: false,
        onPressed: () {},
        menuItems: [
          FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Report chat',
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ReportContentPage(
                          contentId: userId,
                          contentType: author.userName!,
                          parentContentId: userId,
                          repotedAuthorId: currentUserId,
                        ))),
          ),
        ],
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaleFactor:
                  MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
          child: Container(
            decoration: ConfigBloc().darkModeOn
                ? BoxDecoration(
                    color:
                        seen == 'seen' ? Colors.transparent : Color(0xFF1f2022),
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
                    color:
                        seen == 'seen' ? Colors.transparent : Colors.teal[50],
                  ),
            child: Column(
              children: [
                ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Hero(
                        tag: userId,
                        child: Material(
                          color: Colors.transparent,
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: ConfigBloc().darkModeOn
                                ? Color(0xFF1a1a1a)
                                : Color(0xFFf2f2f2),
                            backgroundImage: author.profileImageUrl!.isEmpty
                                ? AssetImage(
                                    ConfigBloc().darkModeOn
                                        ? 'assets/images/user_placeholder.png'
                                        : 'assets/images/user_placeholder2.png',
                                  ) as ImageProvider
                                : CachedNetworkImageProvider(
                                    author.profileImageUrl!),
                          ),
                        ),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: seen == 'seen'
                                ? Colors.transparent
                                : Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text(
                            timeago.format(
                              chats.newMessageTimestamp.toDate(),
                            ),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: chats.restrictChat
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            )),
                      ],
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Text(
                                author.userName!,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            author.verified!.isEmpty
                                ? const SizedBox.shrink()
                                : Positioned(
                                    top: 3,
                                    right: 0,
                                    child: Icon(
                                      MdiIcons.checkboxMarkedCircle,
                                      size: 11,
                                      color: Colors.blue,
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        Wrap(
                          children: [
                            chats.mediaType.isEmpty
                                ? const SizedBox.shrink()
                                : Icon(
                                    MdiIcons.image,
                                    size: 20,
                                    color: seen == 'seen'
                                        ? Colors.grey
                                        : Colors.blue,
                                  ),
                            Text(
                              lastMessage,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: seen == 'seen'
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: seen == 'seen'
                                    ? Colors.grey
                                    : Colors.teal[800],
                                overflow: TextOverflow.ellipsis,
                                decoration: chats.restrictChat
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChatMessageScreen(
                                    fromProfile: false,
                                    currentUserId: currentUserId,
                                    chat: chats,
                                    user: author,
                                  )));
                      usersRef
                          .doc(currentUserId)
                          .collection('chats')
                          .doc(userId)
                          .update({
                        'seen': 'seen',
                      });
                    }),
                ConfigBloc().darkModeOn
                    ? Divider(
                        color: Colors.grey[850],
                      )
                    : Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
