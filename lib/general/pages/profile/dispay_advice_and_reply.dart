import 'package:bars/utilities/exports.dart';

class DisplayAdviceAndReply extends StatefulWidget {
  final UserAdvice advice;
  final String userId;
  // var user;

  DisplayAdviceAndReply(
      {super.key,
      required this.userId,
      // required this.user,
      required this.advice});

  @override
  State<DisplayAdviceAndReply> createState() => _DisplayAdviceAndReplyState();
}

class _DisplayAdviceAndReplyState extends State<DisplayAdviceAndReply> {
  late Future<List<UserAdvice>> _repliesFuture;
  final TextEditingController _commentController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  // int _repliedComment = 0;
  String _editedComment = '';

  @override
  void initState() {
    super.initState();
    _repliesFuture = _initData();
    // _setUpRepliedCommentCount();
    _commentController.addListener(_onAskTextChanged);
  }

  // _setUpRepliedCommentCount() async {
  //   DatabaseService.numRepliedAsks(widget.userId, widget.advice.id)
  //       .listen((repliedComment) {
  //     if (mounted) {
  //       setState(() {
  //         _repliedComment = repliedComment;
  //       });
  //     }
  //   });
  // }

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

  Future<List<UserAdvice>> _initData() async {
    final QuerySnapshot querySnapshot = await userAdviceRef
        .doc(widget.userId)
        .collection('userAdvice')
        .doc(widget.advice.id)
        .collection('replies')
        .limit(3)
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => UserAdvice.fromDoc(doc)).toList();
  }

  _flushbar() {
    return mySnackBar(context, ' successful');
  }

  _deleteComment(UserAdvice? reply) async {
    final _provider = Provider.of<UserData>(context, listen: false);
    HapticFeedback.heavyImpact();
    reply == null
        ? DatabaseService.deleteAdvice(
            currentUserId: _provider.currentUserId!,
            userId: widget.userId,
            advice: widget.advice)
        : DatabaseService.deleteAdviceReply(
            userId: widget.userId,
            adviceId: widget.advice.id,
            replyId: reply.id);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  _editCommentMethod(UserAdvice? reply) {
    reply == null
        ? DatabaseService.editAdvice(
            widget.advice.id,
            _editedComment,
            widget.userId,
          )
        : DatabaseService.editAdviceReply(
            widget.advice.id,
            reply.id,
            _editedComment,
            widget.userId,
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
    return ValueListenableBuilder(
        valueListenable: _isTypingNotifier,
        builder: (BuildContext context, bool isTyping, Widget? child) {
          return CommentContentField(
            autofocus: autofocus,
            controller: _commentController,
            onSend: () {
              HapticFeedback.mediumImpact();
              if (_commentController.text.trim().isNotEmpty) {
                DatabaseService.addAdviceReply(
                  user: Provider.of<UserData>(context, listen: false).user!,
                  advice: _commentController.text,
                  adviceId: widget.advice.id,
                  userId: widget.userId,
                );
                _commentController.clear();
              }
            },
            hintText: 'reply to ${widget.advice.content}',
          );
        });
  }

  void _showBottomSheetEditComment(UserAdvice advice, UserAdvice? reply) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EditCommentContent(
          content: advice.content,
          newContentVaraible: '',
          contentType: 'Advice',
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

  void _showBottomSheetSeeAllReplies(bool autoFocus, bool isPostAuthor) {
    // bool isPostAuthor = widget.userId == widget.advice.authorId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 630),
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
                      report: widget.advice.report,
                      content: widget.advice.content,
                      timestamp: widget.advice.timestamp,
                      authorId: widget.advice.authorId,
                      profileHandle: widget.advice.authorProfileHandle,
                      profileImageUrl: widget.advice.authorProfileImageUrl,
                      verified: widget.advice.authorVerification,
                      userName: widget.advice.authorName,
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
                      stream: userAdviceRef
                          .doc(widget.userId)
                          .collection('userAdvice')
                          .doc(widget.advice.id)
                          .collection('replies')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
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
                                  UserAdvice reply = UserAdvice.fromDoc(
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
    bool isAuthor = _provider.currentUserId == widget.advice.authorId;
    bool isPostAuthor = widget.userId == widget.advice.authorId;

    return FutureBuilder<List<UserAdvice>>(
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
                  showSeeAllReplies: replies.length < 3 ? false : true,
                  report: widget.advice.report,
                  content: widget.advice.content,
                  timestamp: widget.advice.timestamp,
                  authorId: widget.advice.authorId,
                  profileHandle: widget.advice.authorProfileHandle,
                  profileImageUrl: widget.advice.authorProfileImageUrl,
                  verified: widget.advice.authorVerification,
                  userName: widget.advice.authorName,
                  from: 'Comment',
                  onPressedReport: isAuthor
                      ? () {
                          _showBottomSheetEditComment(widget.advice, null);
                        }
                      : () {
                          _navigateToPage(
                            context,
                            ReportContentPage(
                              parentContentId: widget.userId,
                              repotedAuthorId: widget.userId,
                              contentId: widget.advice.id,
                              contentType: 'advice',
                            ),
                          );
                        },
                  onPressedReply: () {
                    _showBottomSheetSeeAllReplies(true, isAuthor);
                  },
                  onPressedSeeAllReplies: () {
                    _showBottomSheetSeeAllReplies(false, isAuthor);
                  },
                  isPostAuthor: isPostAuthor,
                  replyCount: replies.length,
                ),
                children: isExpanded ? _buildChildren(replies) : [],
              );
            },
          );
        }
      },
    );
  }

  _replyWidget(UserAdvice reply) {
    var _provider = Provider.of<UserData>(context, listen: false);
    bool isAuthor = _provider.currentUserId == reply.authorId;
    bool isPostAuthor = reply.authorId == widget.userId;

    return Authorview(
      isreplyWidget: true,
      report: reply.report,
      content: reply.content,
      timestamp: reply.timestamp,
      authorId: reply.authorId,
      profileHandle: reply.authorProfileHandle,
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
                  parentContentId: widget.userId,
                  repotedAuthorId: widget.userId,
                  contentId: widget.advice.id,
                  contentType: 'advice',
                ),
              );
            },
      onPressedReply: () {},
      onPressedSeeAllReplies: () {},
      isPostAuthor: isPostAuthor,
      replyCount: 0,
    );
  }

  List<Widget> _buildChildren(List<UserAdvice> replies) {
    return replies.map((reply) {
      return Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child: _replyWidget(reply));
    }).toList();
  }
}
