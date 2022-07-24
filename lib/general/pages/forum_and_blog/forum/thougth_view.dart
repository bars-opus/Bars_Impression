import 'package:bars/utilities/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timeago/timeago.dart' as timeago;

class ThoughtView extends StatefulWidget {
  final Forum forum;
  final AccountHolder author;
  final Thought thought;
  final index;
  final String currentUserId;

  ThoughtView(
      {required this.forum,
      required this.author,
      required this.thought,
      required this.index,
      required this.currentUserId});

  @override
  _ThoughtViewState createState() => _ThoughtViewState();
}

class _ThoughtViewState extends State<ThoughtView> {
  RandomColor _randomColor = RandomColor();
  final List<ColorHue> _hueType = <ColorHue>[
    ColorHue.green,
    ColorHue.red,
    ColorHue.pink,
    ColorHue.purple,
    ColorHue.blue,
    ColorHue.yellow,
    ColorHue.orange
  ];

  ColorSaturation _colorSaturation = ColorSaturation.random;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId = Provider.of<UserData>(context).currentUserId!;
    return FutureBuilder(
      future: DatabaseService.getUserWithId(widget.thought.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        AccountHolder author = snapshot.data;
        return FocusedMenuHolder(
          menuWidth: width,
          menuOffset: 10,
          blurBackgroundColor:
              ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.blueGrey[700],
          openWithTap: false,
          onPressed: () {},
          menuItems: [
            FocusedMenuItem(
              title: Container(
                width: width / 2,
                child: Text(
                  currentUserId == author.id!
                      ? 'Edit your thought'
                      : author.profileHandle!.startsWith('Fan') ||
                              author.profileHandle!.isEmpty
                          ? 'Go to ${author.userName}\' profile '
                          : 'Go to ${author.userName}\' booking page ',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onPressed: () => currentUserId == author.id!
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditThought(
                          thought: widget.thought,
                          currentUserId: widget.currentUserId,
                          forum: widget.forum,
                        ),
                      ),
                    )
                  : author.profileHandle!.startsWith('Fan') ||
                          author.profileHandle!.isEmpty
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId!,
                                    userId: author.id!,
                                    user: widget.author,
                                  )))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileProfessionalProfile(
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId!,
                                    user: author,
                                    userId: author.id!,
                                  ))),
            ),
            FocusedMenuItem(
                title: Container(
                  width: width / 2,
                  child: Text(
                    'Report',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportContentPage(
                              parentContentId: widget.forum.id,
                              repotedAuthorId: widget.thought.authorId,
                              contentId: widget.thought.id,
                              contentType: 'thought',
                            )))),
          ],
          child: Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Colors.cyan[800]!,
                  foregroundColor: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Colors.white,
                  icon: currentUserId == author.id! ? Icons.edit : null,
                  label: currentUserId == author.id! ? 'Edit your vibe' : '',
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: currentUserId == author.id!
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: currentUserId == author.id!
                      ? const EdgeInsets.only(
                          left: 50.0, bottom: 5.0, top: 10.0, right: 15)
                      : const EdgeInsets.only(
                          right: 50.0, bottom: 5.0, top: 10.0, left: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: currentUserId == author.id!
                            ? Colors.blue[100]
                            : Colors.white,
                        borderRadius: currentUserId == author.id!
                            ? BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(30.0))
                            : BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                topLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(30.0))),
                    child: ListTile(
                      leading: currentUserId == author.id!
                          ? SizedBox.shrink()
                          : CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.grey,
                              backgroundImage: author.profileImageUrl!.isEmpty
                                  ? AssetImage(
                                      'assets/images/user_placeholder2.png',
                                    ) as ImageProvider
                                  : CachedNetworkImageProvider(
                                      author.profileImageUrl!),
                            ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: currentUserId != author.id!
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            currentUserId == author.id!
                                ? 'Me'
                                : author.userName!,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(author.profileHandle!,
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.blueGrey,
                              )),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: currentUserId == author.id!
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Container(
                              color: _randomColor.randomColor(
                                colorHue:
                                    ColorHue.multiple(colorHues: _hueType),
                                colorSaturation: _colorSaturation,
                              ),
                              height: 1.0,
                              width: 50.0,
                            ),
                          ),
                          widget.thought.report.isNotEmpty
                              ? BarsTextStrikeThrough(
                                  fontSize: 12,
                                  text: widget.thought.content,
                                )
                              : Text(
                                  widget.thought.content,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.0),
                                ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                  currentUserId: Provider.of<UserData>(context)
                                      .currentUserId!,
                                  userId: author.id!,
                                  user: widget.author))),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, bottom: 10, right: 30),
                  child: Text(
                      timeago.format(
                        widget.thought.timestamp.toDate(),
                      ),
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
