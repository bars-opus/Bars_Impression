import 'package:bars/utilities/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ThoughtView extends StatefulWidget {
  final Forum forum;
  final Thought thought;
  final String currentUserId;
  final bool isBlockedUser;

  ThoughtView(
      {required this.forum,
      required this.thought,
      required this.currentUserId,
      required this.isBlockedUser});

  @override
  State<ThoughtView> createState() => _ThoughtViewState();
}

class _ThoughtViewState extends State<ThoughtView> {
  bool _isLiked = false;
  bool _isgettingLike = true;
  int _dbLikeCount = 0;

  @override
  void initState() {
    super.initState();
    _dbLikeCount = widget.thought.count!;
    _initPostLiked();
  }

  _likePost() {
    DatabaseService.likeThought(
        user: Provider.of<UserData>(context, listen: false).user!,
        forum: widget.forum,
        thought: widget.thought);
    if (mounted) {
      setState(() {
        _isLiked = true;
        _dbLikeCount = _dbLikeCount + 1;
      });
    }
  }

  _initPostLiked() async {
    bool isLiked = await DatabaseService.didLikeThought(
      currentUserId: widget.currentUserId,
      thought: widget.thought,
    );
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
        _isgettingLike = false;
      });
    }
  }

  _unLikePost() {
    DatabaseService.unlikeThought(
        user: Provider.of<UserData>(context, listen: false).user!,
        forum: widget.forum,
        thought: widget.thought);
    if (mounted) {
      setState(() {
        _isLiked = false;
        _dbLikeCount = _dbLikeCount - 1;
      });
    }
  }

  _displayMessageImage(String currentUserId) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MessageImage(
                      mediaUrl: widget.thought.mediaUrl,
                      messageId: widget.thought.id,
                    ))),
        child: Hero(
          tag: 'image ${widget.thought.id}',
          child: Container(
            height: width / 2,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: currentUserId == widget.thought.authorId
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.thought.mediaUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildTransportReceived(Thought thought) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ViewSentContent(
                          contentId: thought.mediaType,
                          contentType: thought.content.startsWith('User')
                              ? 'User'
                              : thought.content.startsWith('Event')
                                  ? 'Event'
                                  : thought.content.startsWith('Forum')
                                      ? 'Forum'
                                      : thought.content
                                              .startsWith('Mood Punched')
                                          ? 'Mood Punched'
                                          : '',
                        ))),
            title: Column(
              crossAxisAlignment:
                  widget.currentUserId == widget.thought.authorId
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Text(
                    'View content',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            leading: widget.currentUserId != widget.thought.authorId
                ? Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: thought.content.startsWith('Forum')
                        ? Icon(
                            Icons.forum,
                            color: Colors.white,
                          )
                        : thought.mediaUrl.isEmpty
                            ? Icon(
                                Icons.account_circle_rounded,
                                color: Colors.white,
                              )
                            : CachedNetworkImage(
                                imageUrl: thought.mediaUrl,
                                height: 40.0,
                                width: 40.0,
                                fit: BoxFit.cover,
                              ),
                  )
                : null,
            trailing: widget.currentUserId != widget.thought.authorId
                ? null
                : Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: thought.content.startsWith('Forum')
                        ? Icon(
                            Icons.forum,
                            color: Colors.white,
                          )
                        : thought.mediaUrl.isEmpty
                            ? Icon(
                                Icons.account_circle_rounded,
                                color: Colors.white,
                              )
                            : CachedNetworkImage(
                                imageUrl: thought.mediaUrl,
                                height: 40.0,
                                width: 40.0,
                                fit: BoxFit.cover,
                              ),
                  ),
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId = Provider.of<UserData>(context).currentUserId!;
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
                'Reply',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ReplyThoughtsScreen(
                          currentUserId: currentUserId,
                          forum: widget.forum,
                          isBlocked: widget.isBlockedUser,
                          thought: widget.thought,
                        )))),
        FocusedMenuItem(
          title: Container(
            width: width / 2,
            child: Text(
              'View likes',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ThoughtLikeAccounts(
                thought: widget.thought,
              ),
            ),
          ),
        ),
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                currentUserId == widget.thought.authorId
                    ? 'Edit your thought'
                    : widget.thought.authorProfileHanlde.startsWith('Fan') ||
                            widget.thought.authorProfileHanlde.isEmpty
                        ? 'View profile '
                        : 'View booking page ',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => currentUserId == widget.thought.authorId
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditThought(
                        thought: widget.thought,
                        currentUserId: currentUserId,
                        forum: widget.forum,
                      ),
                    ),
                  )
                : widget.thought.authorProfileHanlde.startsWith('Fan') ||
                        widget.thought.authorProfileHanlde.isEmpty
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  currentUserId: Provider.of<UserData>(context)
                                      .currentUserId!,
                                  userId: widget.thought.authorId,
                                  user: null,
                                )))
                    : () async {
                        AccountHolder user =
                            await DatabaseService.getUserWithId(
                                widget.thought.authorId);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfileProfessionalProfile(
                                      currentUserId:
                                          Provider.of<UserData>(context)
                                              .currentUserId!,
                                      user: user,
                                      userId: widget.thought.authorId,
                                    )));
                      }),
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
              onPressed: (_) {
                currentUserId == widget.thought.authorId
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditThought(
                            thought: widget.thought,
                            currentUserId: currentUserId,
                            forum: widget.forum,
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
              backgroundColor: Colors.blue,
              foregroundColor:
                  ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
              icon:
                  currentUserId == widget.thought.authorId ? Icons.edit : null,
              label: currentUserId == widget.thought.authorId
                  ? 'Edit your thought'
                  : '',
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: currentUserId == widget.thought.authorId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: currentUserId == widget.thought.authorId
                  ? const EdgeInsets.only(
                      left: 50.0, bottom: 5.0, top: 10.0, right: 15)
                  : const EdgeInsets.only(
                      right: 50.0, bottom: 5.0, top: 10.0, left: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: currentUserId == widget.thought.authorId
                        ? Colors.blue[100]
                        : Colors.white,
                    borderRadius: currentUserId == widget.thought.authorId
                        ? BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(30.0))
                        : BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(30.0))),
                child: Column(
                  children: [
                    widget.thought.imported
                        ? _buildTransportReceived(widget.thought)
                        : const SizedBox.shrink(),
                    widget.thought.imported
                        ? const SizedBox.shrink()
                        : widget.thought.mediaUrl.isEmpty
                            ? const SizedBox.shrink()
                            : _displayMessageImage(currentUserId),
                    ListTile(
                      trailing: currentUserId == widget.thought.authorId
                          ? null
                          : _isgettingLike
                              ? null
                              : Stack(
                                  alignment: FractionalOffset.bottomCenter,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                          size: 20.0,
                                          _isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined),
                                      color:
                                          _isLiked ? Colors.pink : Colors.grey,
                                      onPressed: () {
                                        HapticFeedback.heavyImpact();
                                        SystemSound.play(SystemSoundType.click);
                                        if (_isLiked) {
                                          setState(() {
                                            _unLikePost();
                                          });
                                        } else {
                                          _likePost();
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ThoughtLikeAccounts(
                                            thought: widget.thought,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        NumberFormat.compact().format(
                                          widget.thought.likeCount,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      leading: currentUserId == widget.thought.authorId
                          ? widget.thought.likeCount == 0
                              ? const SizedBox.shrink()
                              : GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ThoughtLikeAccounts(
                                        thought: widget.thought,
                                      ),
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: FractionalOffset.bottomCenter,
                                    children: [
                                      IconButton(
                                        icon: Icon(size: 20.0, Icons.favorite),
                                        color: Colors.black,
                                        onPressed: () {},
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        NumberFormat.compact().format(
                                          widget.thought.likeCount,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                          : CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  widget.thought.authorProfileImageUrl.isEmpty
                                      ? AssetImage(
                                          'assets/images/user_placeholder2.png',
                                        ) as ImageProvider
                                      : CachedNetworkImageProvider(
                                          widget.thought.authorProfileImageUrl),
                            ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:
                            currentUserId != widget.thought.authorId
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            currentUserId == widget.thought.authorId
                                ? 'Me'
                                : widget.thought.authorName,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(widget.thought.authorProfileHanlde,
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
                        crossAxisAlignment:
                            currentUserId == widget.thought.authorId
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Container(
                              color: Colors.blue,
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
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId!,
                                    userId: widget.thought.authorId,
                                    user: null,
                                  ))),
                    ),
                  ],
                ),
              ),
            ),
            widget.thought.count! != 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReplyThoughtsScreen(
                              thought: widget.thought,
                              currentUserId: currentUserId,
                              forum: widget.forum,
                              isBlocked: widget.isBlockedUser,
                            ),
                          ),
                        );
                      },
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: timeago.format(
                                  widget.thought.timestamp!.toDate(),
                                ),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                )),
                            TextSpan(
                                text: " View ${NumberFormat.compact().format(
                                  widget.thought.count,
                                )} replies",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        timeago.format(
                          widget.thought.timestamp!.toDate(),
                        ),
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
