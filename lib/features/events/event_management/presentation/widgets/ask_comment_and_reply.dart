import 'package:bars/utilities/exports.dart';

class DisplayAskAndReply extends StatefulWidget {
  final Post post;
  final CommentModel comment;

  const DisplayAskAndReply(
      {super.key, required this.post, required this.comment});

  @override
  State<DisplayAskAndReply> createState() => _DisplayAskAndReplyState();
}

class _DisplayAskAndReplyState extends State<DisplayAskAndReply> {
  late Future<List<CommentModel>> _repliesFuture;
  final TextEditingController _commentController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  String _editedComment = '';

  @override
  void initState() {
    super.initState();
    _repliesFuture = _initData();
    _commentController.addListener(_onAskTextChanged);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _isTypingNotifier.dispose();

    super.dispose();
  }

  void _onAskTextChanged() {
    if (_commentController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  Future<List<CommentModel>> _initData() async {
    final QuerySnapshot querySnapshot = await commentsRef
        .doc(widget.post.id)
        .collection('comments')
        .doc(widget.comment.id)
        .collection('replies')
        .limit(3)
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => CommentModel.fromDoc(doc)).toList();
  }

  _flushbar() {
    return mySnackBar(context, ' successful');
  }

  _deleteComment(CommentModel? reply) async {
    final _provider = Provider.of<UserData>(context, listen: false);
    HapticFeedback.heavyImpact();
    reply == null
        ? DatabaseService.deleteComments(
            currentUserId: _provider.currentUserId!,
            comment: widget.comment,
            post: widget.post)
        : DatabaseService.deleteCommentReply(
            post: widget.post, askId: widget.comment.id, replyId: reply.id);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  _editCommentMethod(CommentModel? reply) {
    reply == null
        ? DatabaseService.editAsks(
            widget.comment.id,
            _editedComment,
            widget.post,
          )
        : DatabaseService.editCommentReply(
            widget.comment.id,
            reply.id,
            _editedComment,
            widget.post,
          );
    _commentController.clear();
    Navigator.pop(context);
    setState(() {
      _editedComment = '';
    });
  }

  _commentField(
    bool autofocus,
  ) {
    final _provider = Provider.of<UserData>(context, listen: false);
    return ValueListenableBuilder(
        valueListenable: _isTypingNotifier,
        builder: (BuildContext context, bool isTyping, Widget? child) {
          return CommentContentField(
            autofocus: autofocus,
            controller: _commentController,
            onSend: () {
              HapticFeedback.mediumImpact();
              if (_commentController.text.trim().isNotEmpty) {
                DatabaseService.addCommentReply(
                  post: widget.post,
                  comment: _commentController.text,
                  user: _provider.user!,
                  askId: widget.comment.id,
                );
                _commentController.clear();
              }
            },
            hintText: 'reply to ${widget.comment.content}',
          );
        });
  }

  void _showBottomSheetEditComment(CommentModel ask, CommentModel? reply) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EditCommentContent(
          content: ask.content,
          newContentVaraible: '',
          contentType: 'Question',
          onPressedDelete: () {
            _deleteComment(reply);
            _flushbar();
          },
          onPressedSave: () {
            HapticFeedback.mediumImpact();
            if (_editedComment.trim().isNotEmpty) {
              _editCommentMethod(reply);
              _flushbar();
            }
          },
          onSavedText: (string) => _editedComment = string,
        );
      },
    );
  }

  void _showBottomSheetSeeAllReplies(bool autoFocus) {
    bool isPostAuthor = widget.post.authorId == widget.comment.authorId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.3,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TicketPurchasingIcon(
                      // icon: Icons.payment,
                      title: '',
                    ),
                    Authorview(
                      isreplyWidget: true,
                      showReply: false,
                      report: widget.comment.report,
                      content: widget.comment.content,
                      timestamp: widget.comment.timestamp,
                      authorId: widget.comment.authorId,
                      shopType: widget.comment.authorshopType,
                      profileImageUrl: widget.comment.authorProfileImageUrl,
                      verified: widget.comment.authorVerification,
                      userName: widget.comment.authorName,
                      from: 'Comment',
                      onPressedReport: () {},
                      onPressedReply: () {},
                      onPressedSeeAllReplies: () {},
                      isPostAuthor: isPostAuthor,
                      replyCount: 0,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    StreamBuilder(
                      stream: commentsRef
                          .doc(widget.post.id)
                          .collection('comments')
                          .doc(widget.comment.id)
                          .collection('replies')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                          );
                        }
                        return Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Scrollbar(
                              child: CustomScrollView(slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  CommentModel reply = CommentModel.fromDoc(
                                      snapshot.data.docs[index]);
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: _replyWidget(reply),
                                  );
                                },
                                childCount: snapshot.data.docs.length,
                              ),
                            )
                          ])),
                        ));
                      },
                    ),
                    _commentField(
                      autoFocus,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    bool isAuthor = _provider.currentUserId == widget.comment.authorId;
    bool isPostAuthor = widget.post.authorId == widget.comment.authorId;

    return FutureBuilder<List<CommentModel>>(
      future: _repliesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for _repliesFuture to complete
          return SizedBox.shrink();
          //  CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Show some error UI
          return Text('Error: ${snapshot.error}');
        } else {
          final replies = snapshot.data!;
          final isExpanded = replies.isNotEmpty;
          return ValueListenableBuilder<bool>(
            valueListenable: ValueNotifier<bool>(isExpanded),
            builder: (context, isExpanded, child) {
              return

                  //  Column(
                  //   children: [
                  ExpansionTile(
                collapsedIconColor: Colors.transparent,
                initiallyExpanded: isExpanded,
                onExpansionChanged: (bool expanded) {},
                title: Authorview(
                  showSeeAllReplies: replies.length < 4 ? false : true,
                  isPostAuthor: isPostAuthor,
                  replyCount: replies.length,
                  report: widget.comment.report,
                  content: widget.comment.content,
                  timestamp: widget.comment.timestamp,
                  authorId: widget.comment.authorId,
                  shopType: widget.comment.authorshopType,
                  profileImageUrl: widget.comment.authorProfileImageUrl,
                  verified: widget.comment.authorVerification,
                  userName: widget.comment.authorName,
                  from: 'Comment',
                  onPressedReport: isAuthor
                      ? () {
                          _showBottomSheetEditComment(widget.comment, null);
                        }
                      : () {
                          _navigateToPage(
                            context,
                            ReportContentPage(
                              parentContentId: widget.post.id,
                              repotedAuthorId: widget.post.authorId,
                              contentId: widget.comment.id,
                              contentType: 'vibe',
                            ),
                          );
                        },
                  onPressedReply: () {
                    _showBottomSheetSeeAllReplies(true);
                  },
                  onPressedSeeAllReplies: () {
                    _showBottomSheetSeeAllReplies(false);
                  },
                ),
                children: isExpanded ? _buildChildren(replies) : [],
              );
            },
          );
        }
      },
    );
  }

  _replyWidget(CommentModel reply) {
    var _provider = Provider.of<UserData>(context, listen: false);
    bool isAuthor = _provider.currentUserId == widget.comment.authorId;
    bool isPostAuthor = widget.post.authorId == widget.comment.authorId;

    return Authorview(
      isreplyWidget: true,
      report: reply.report,
      content: reply.content,
      timestamp: reply.timestamp,
      authorId: reply.authorId,
      shopType: reply.authorshopType,
      profileImageUrl: reply.authorProfileImageUrl,
      verified: reply.authorVerification,
      userName: reply.authorName,
      from: 'Reply',
      showReply: false,
      onPressedReport: isAuthor
          ? () {
              _showBottomSheetEditComment(reply, reply);
            }
          : () {
              _navigateToPage(
                context,
                ReportContentPage(
                  parentContentId: widget.post.id,
                  repotedAuthorId: widget.post.authorId,
                  contentId: widget.comment.id,
                  contentType: 'vibe',
                ),
              );
            },
      onPressedReply: () {},
      onPressedSeeAllReplies: () {},
      isPostAuthor: isPostAuthor,
      replyCount: 0,
    );
  }

  List<Widget> _buildChildren(List<CommentModel> replies) {
    return replies.map((reply) {
      return Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child: _replyWidget(reply));
    }).toList();
  }
}
