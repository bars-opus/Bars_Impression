import 'package:bars/utilities/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timeago/timeago.dart' as timeago;

class PunchView extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final AccountHolder author;
  PunchView(
      {required this.currentUserId, required this.post, required this.author});

  @override
  _PunchViewState createState() => _PunchViewState();
}

class _PunchViewState extends State<PunchView> {
  _buildPunchView() {
    final width = MediaQuery.of(context).size.width;
    return FocusedMenuHolder(
      menuWidth: width,
      menuOffset: 10,
      blurBackgroundColor:
          ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white10,
      openWithTap: false,
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                widget.post.authorId == widget.currentUserId
                    ? 'Edit mood punched'
                    : 'Go to ${widget.author.name}\' profile ',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => widget.post.authorId == widget.currentUserId
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditPost(
                        post: widget.post,
                        currentUserId: widget.currentUserId,
                      ),
                    ),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              currentUserId:
                                  Provider.of<UserData>(context).currentUserId,
                              userId: widget.author.id!,
                              user: widget.author,
                            )))),
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Go to punchline ',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PunchWidget(
                        currentUserId: widget.currentUserId,
                        post: widget.post,
                        author: widget.author)))),
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
                          parentContentId: widget.post.id,
                          repotedAuthorId: widget.post.authorId,
                          contentId: widget.post.id!,
                          contentType: 'Mood punched',
                        )))),
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Suggestion Box',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => SuggestionBox()))),
      ],
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => widget.currentUserId == widget.author.id!
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditPost(
                          post: widget.post,
                          currentUserId: widget.currentUserId,
                        ),
                      ),
                    )
                  : widget.author.profileHandle!.startsWith('Fan')
                      ? () {}
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileProfessionalProfile(
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId,
                                    user: widget.author,
                                    userId: widget.author.id!,
                                  ))),
              backgroundColor: ConfigBloc().darkModeOn
                  ? Color(0xFF1a1a1a)
                  : Color(0xFFf2f2f2),
              foregroundColor: Colors.grey,
              icon:
                  widget.currentUserId == widget.author.id! ? Icons.edit : null,
              label: widget.currentUserId == widget.author.id!
                  ? 'Edit your vibe'
                  : '',
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 10),
                    blurRadius: 10.0,
                    spreadRadius: 4.0,
                  )
                ],
                borderRadius: BorderRadius.circular(30),
                color:
                    ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Colors.white,
              ),
              height: Responsive.isDesktop(context) ? 400 : 300,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProfileScreen(
                                          currentUserId:
                                              Provider.of<UserData>(context)
                                                  .currentUserId,
                                          userId: widget.author.id!,
                                          user: null,
                                        ))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Material(
                                  color: Colors.transparent,
                                  child: Container(
                                      child: Row(children: <Widget>[
                                    Hero(
                                      tag: 'author' + widget.post.id.toString(),
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: ConfigBloc().darkModeOn
                                            ? Color(0xFF1a1a1a)
                                            : Color(0xFFf2f2f2),
                                        backgroundImage: widget
                                                .author.profileImageUrl!.isEmpty
                                            ? AssetImage(
                                                ConfigBloc().darkModeOn
                                                    ? 'assets/images/user_placeholder.png'
                                                    : 'assets/images/user_placeholder2.png',
                                              ) as ImageProvider
                                            : CachedNetworkImageProvider(
                                                widget.author.profileImageUrl!),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: RichText(
                                              textScaleFactor:
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${widget.author.userName}\n",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: ConfigBloc()
                                                                  .darkModeOn
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text:
                                                          "${widget.author.profileHandle!}\n",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.white
                                                            : Colors.black,
                                                      )),
                                                  TextSpan(
                                                      text:
                                                          "${widget.author.company}",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.white
                                                            : Colors.black,
                                                      )),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ])),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Hero(
                          tag: 'punch' + widget.post.id.toString(),
                          child: Material(
                            color: Colors.transparent,
                            child: SingleChildScrollView(
                              child: Text(
                                '" ${widget.post.punch} " '.toLowerCase(),
                                maxLines:
                                    MediaQuery.of(context).textScaleFactor > 1.2
                                        ? 2
                                        : 4,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Hero(
                      tag: 'artist' + widget.post.id.toString(),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          '${widget.post.artist} ',
                          style: TextStyle(
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                            fontSize: width > 500 && width < 800
                                ? 16
                                : width > 800
                                    ? 20
                                    : 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.0),
                    Hero(
                      tag: 'artist2' + widget.post.id.toString(),
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          ),
                          height: 1.0,
                          child: Text(
                            '${widget.post.artist} ',
                            style: TextStyle(
                              fontSize: width > 500 && width < 800
                                  ? 16
                                  : width > 800
                                      ? 20
                                      : 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    BarsTextFooter(
                      text: timeago.format(
                        widget.post.timestamp.toDate(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Positioned(
                          left: 0.0,
                          top: 0.0,
                          child: Container(
                            height: 10,
                            width: 10,
                            color: Colors.blue,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Hero(
                            tag: 'caption' + widget.post.id.toString(),
                            child: Material(
                              color: Colors.transparent,
                              child: SingleChildScrollView(
                                child: Text(
                                  '${widget.post.caption} '.toLowerCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  maxLines:
                                      MediaQuery.of(context).textScaleFactor >
                                              1.2
                                          ? 1
                                          : 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            subtitle: SizedBox(
              height: 5.0,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AllPostEnlarged(
                      currentUserId: widget.currentUserId,
                      post: widget.post,
                      feed: 'Feed',
                      author: widget.author)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildPunchView(),
      ],
    );
  }
}
