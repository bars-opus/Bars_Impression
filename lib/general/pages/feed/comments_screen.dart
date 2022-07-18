import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsScreen extends StatefulWidget {
  final Post post;
  final int? commentCount;
  final int likeCount;
  final int dislikeCount;
  final String currentUserId;
  final Comment? comment;

  CommentsScreen(
      {required this.post,
      required this.commentCount,
      required this.likeCount,
      required this.dislikeCount,
      required this.currentUserId,
      required this.comment});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen>
    with AutomaticKeepAliveClientMixin<CommentsScreen> {
  late ScrollController _hideButtonController;
  var _isVisible;
  int _commentCount = 0;

  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  bool _isBlockedUser = false;

  void initState() {
    super.initState();
    _setUpComments();
    _setupIsBlockedUser();
    _isVisible = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setPost9('');
    });
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.post.authorId,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
  }

  _setUpComments() async {
    DatabaseService.numComments(widget.post.id).listen((commentCount) {
      if (mounted) {
        setState(() {
          _commentCount = commentCount;
        });
      }
    });
  }

  _buildComment(Comment comment, AccountHolder author) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    return FutureBuilder(
      future: DatabaseService.getUserWithId(comment.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        AccountHolder author = snapshot.data;
        return FocusedMenuHolder(
          menuWidth: width,
          menuOffset: 1,
          blurBackgroundColor:
              ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.cyan[50],
          openWithTap: false,
          onPressed: () {},
          menuItems: [
            FocusedMenuItem(
              title: Container(
                width: width / 2,
                child: Text(
                  currentUserId == author.id!
                      ? 'Edit your vibe'
                      : author.profileHandle!.startsWith('Fan') ||
                              author.profileHandle!.isEmpty
                          ? 'Go to ${author.userName}\' profile '
                          : 'Go to ${author.userName}\' booking page ',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
              ),
              onPressed: () => currentUserId == author.id!
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditComments(
                            comment: comment,
                            currentUserId: widget.currentUserId,
                            post: widget.post),
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
                                            .currentUserId,
                                    userId: author.id!,
                                    user: null,
                                  )))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileProfessionalProfile(
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId,
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
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportContentPage(
                              parentContentId: widget.post.id,
                              repotedAuthorId: widget.post.authorId,
                              contentId: comment.id,
                              contentType: 'vibe',
                            )))),
          ],
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor:
                    MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
            child: Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      currentUserId == author.id!
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditComments(
                                    comment: comment,
                                    currentUserId: widget.currentUserId,
                                    post: widget.post),
                              ),
                            )
                          : SizedBox.shrink();
                    },
                    backgroundColor: Colors.cyan[800]!,
                    foregroundColor: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Colors.white,
                    icon: currentUserId == author.id! ? Icons.edit : null,
                    label: currentUserId == author.id! ? 'Edit your vibe' : '',
                  ),
                ],
              ),
              child: Authorview(
                report: comment.report,
                content: comment.content,
                author: author,
                timestamp: comment.timestamp,
              ),
            ),
          ),
        );
      },
    );
  }

  _buildCommentTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: _isVisible ? null : 0.0,
        child: IconTheme(
          data: IconThemeData(
            color: _isCommenting
                ? Colors.cyan[600]
                : Theme.of(context).disabledColor,
          ),
          child: Material(
            color: Colors.white,
            elevation: 10.0,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLines:
                          _commentController.text.length > 300 ? 10 : null,
                      onChanged: (input) =>
                          Provider.of<UserData>(context, listen: false)
                              .setPost9(input),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Feeling the punch? vibe with it...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                    child: CircularButton(
                      color: Provider.of<UserData>(context, listen: false)
                              .post9
                              .isNotEmpty
                          ? Colors.cyan[800]!
                          : Colors.transparent,
                      icon: Icon(
                        Icons.send,
                        color: Provider.of<UserData>(context, listen: false)
                                .post9
                                .isNotEmpty
                            ? Colors.white
                            : !_isVisible
                                ? Colors.transparent
                                : ConfigBloc().darkModeOn
                                    ? Color(0xFF1a1a1a)
                                    : Theme.of(context).disabledColor,
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (Provider.of<UserData>(context, listen: false)
                            .post9
                            .isNotEmpty) {
                          DatabaseService.commentOnPost(
                            currentUserId: currentUserId,
                            post: widget.post,
                            comment: _commentController.text,
                            reportConfirmed: '',
                          );
                          _commentController.clear();
                          Provider.of<UserData>(context, listen: false)
                              .setPost9('');
                          if (mounted) {
                            setState(() {
                              _isCommenting = false;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _pop() {
    Navigator.pop(context);
    Provider.of<UserData>(context, listen: false).setPost9('');
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ResponsiveScaffold(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Material(
            color: Colors.transparent,
            child: NestedScrollView(
              controller: _hideButtonController,
              headerSliverBuilder: (context, innerBoxScrolled) => [
                SliverAppBar(
                  title: Hero(
                    tag: 'vibe' + widget.post.id.toString(),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Vibe With Mood',
                        style: TextStyle(
                            color: ConfigBloc().darkModeOn
                                ? Color(0xFF1a1a1a)
                                : Color(0xFFe8f3fa),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0.0,
                  automaticallyImplyLeading: true,
                  leading: BackButton(
                    onPressed: _pop,
                  ),
                  expandedHeight: 120,
                  floating: true,
                  snap: true,
                  iconTheme: new IconThemeData(
                    color: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Color(0xFFe8f3fa),
                  ),
                  backgroundColor: Colors.cyan[800],
                  flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                        child: SingleChildScrollView(
                          child: Container(
                            color: Colors.cyan[800],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    widget.post.punch,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: ConfigBloc().darkModeOn
                                          ? Color(0xFF1a1a1a)
                                          : Color(0xFFe8f3fa),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Vibes:   ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: ConfigBloc().darkModeOn
                                                ? Color(0xFF1a1a1a)
                                                : Color(0xFFe8f3fa),
                                          )),
                                      TextSpan(
                                          text: NumberFormat.compact()
                                              .format(_commentCount),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: ConfigBloc().darkModeOn
                                                ? Color(0xFF1a1a1a)
                                                : Color(0xFFe8f3fa),
                                          )),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                    timeago.format(
                                      widget.post.timestamp.toDate(),
                                    ),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: ConfigBloc().darkModeOn
                                          ? Color(0xFF1a1a1a)
                                          : Color(0xFFe8f3fa),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
              body: Container(
                color: Colors.cyan[800],
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, -5),
                            blurRadius: 2.0,
                            spreadRadius: 2.0,
                          )
                        ],
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Color(0xFFf2f2f2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                          stream: commentsRef
                              .doc(widget.post.id)
                              .collection('postComments')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return _commentCount == 0
                                ? Expanded(
                                    child: Center(
                                      child: NoContents(
                                        icon: (MdiIcons.emoticonHappyOutline),
                                        title: 'No Vibes yet,',
                                        subTitle:
                                            'Can you relate to this pucnline and the mood of the puch?, then vibe with it, ',
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Scrollbar(
                                        child: CustomScrollView(
                                          slivers: [
                                            SliverList(
                                              delegate:
                                                  SliverChildBuilderDelegate(
                                                (context, index) {
                                                  Comment comment =
                                                      Comment.fromDoc(snapshot
                                                          .data.docs[index]);
                                                  return FutureBuilder(
                                                      future: DatabaseService
                                                          .getUserWithId(
                                                              comment.authorId),
                                                      builder:
                                                          (BuildContext context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return FollowerUserSchimmerSkeleton();
                                                        }
                                                        AccountHolder author =
                                                            snapshot.data;

                                                        return _buildComment(
                                                            comment, author);
                                                      });
                                                },
                                                childCount:
                                                    snapshot.data.docs.length,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                        _isBlockedUser ? SizedBox.shrink() : _buildCommentTF(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
