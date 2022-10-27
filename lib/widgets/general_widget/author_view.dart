import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class Authorview extends StatelessWidget {
  final String userName;
  final String profileHandle;
  final String profileImageUrl;
  final String verified;
  final String authorId;
  final String report;
  final String content;
  final String from;
  final Timestamp timestamp;

  Authorview({
    required this.content,
    required this.report,
    required this.timestamp,
    required this.userName,
    required this.profileHandle,
    required this.profileImageUrl,
    required this.verified,
    required this.authorId,
    required this.from,
  });

  // RandomColor _randomColor = RandomColor();
  // final List<ColorHue> _hueType = <ColorHue>[
  //   ColorHue.green,
  //   ColorHue.red,
  //   ColorHue.pink,
  //   ColorHue.purple,
  //   ColorHue.blue,
  //   ColorHue.yellow,
  //   ColorHue.orange
  // ];

  // ColorSaturation _colorSaturation = ColorSaturation.random;

  @override
  Widget build(BuildContext context) {
    String currentUserId = Provider.of<UserData>(context).currentUserId!;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
      child: ListTile(
        leading: profileImageUrl.isEmpty
            ? Icon(
                Icons.account_circle,
                size: 45.0,
                color: Colors.grey,
              )
            : CircleAvatar(
                radius: 20.0,
                backgroundColor: ConfigBloc().darkModeOn
                    ? Color(0xFF1a1a1a)
                    : Color(0xFFf2f2f2),
                backgroundImage: CachedNetworkImageProvider(profileImageUrl),
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
                    userName,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color:
                          ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                verified.isEmpty
                    ? const SizedBox.shrink()
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
            Text(profileHandle,
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                )),
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
                  ? BarsTextStrikeThrough(
                      fontSize: 12,
                      text: content,
                    )
                  : HyperLinkText(
                      from: '',
                      text: content,
                    ),
            ),
            Text(
                timeago.format(
                  timestamp.toDate(),
                ),
                style: TextStyle(fontSize: 10, color: Colors.grey)),
            SizedBox(height: 10.0),
            SizedBox(
              height: 5.0,
            ),
            ConfigBloc().darkModeOn
                ? Divider(
                    color: Colors.white,
                  )
                : Divider(),
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
                          currentUserId: currentUserId,
                          userId: authorId,
                        ))),
      ),
    );
  }
}
