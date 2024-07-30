import 'package:bars/utilities/exports.dart';

class DisplayAskAndReply extends StatefulWidget {
  final Event event;
  final Ask ask;

  const DisplayAskAndReply({super.key, required this.event, required this.ask});

  @override
  State<DisplayAskAndReply> createState() => _DisplayAskAndReplyState();
}

class _DisplayAskAndReplyState extends State<DisplayAskAndReply> {
  late Future<List<Ask>> _repliesFuture;
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

  Future<List<Ask>> _initData() async {
    final QuerySnapshot querySnapshot = await asksRef
        .doc(widget.event.id)
        .collection('eventAsks')
        .doc(widget.ask.id)
        .collection('replies')
        .limit(3)
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => Ask.fromDoc(doc)).toList();
  }

  _flushbar() {
    return mySnackBar(context, ' successful');
  }

  _deleteComment(Ask? reply) async {
    final _provider = Provider.of<UserData>(context, listen: false);
    HapticFeedback.heavyImpact();
    reply == null
        ? DatabaseService.deleteAsks(
            currentUserId: _provider.currentUserId!,
            ask: widget.ask,
            event: widget.event)
        : DatabaseService.deleteAskReply(
            event: widget.event, askId: widget.ask.id, replyId: reply.id);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  _editCommentMethod(Ask? reply) {
    reply == null
        ? DatabaseService.editAsks(
            widget.ask.id,
            _editedComment,
            widget.event,
          )
        : DatabaseService.editAsksReply(
            widget.ask.id,
            reply.id,
            _editedComment,
            widget.event,
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
                DatabaseService.addAskReply(
                  event: widget.event,
                  ask: _commentController.text,
                  user: _provider.user!,
                  askId: widget.ask.id,
                );
                _commentController.clear();
              }
            },
            hintText: 'reply to ${widget.ask.content}',
          );
        });
  }

  void _showBottomSheetEditComment(Ask ask, Ask? reply) {
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
    bool isPostAuthor = widget.event.authorId == widget.ask.authorId;

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
                      report: widget.ask.report,
                      content: widget.ask.content,
                      timestamp: widget.ask.timestamp,
                      authorId: widget.ask.authorId,
                      profileHandle: widget.ask.authorProfileHandle,
                      profileImageUrl: widget.ask.authorProfileImageUrl,
                      verified: widget.ask.authorVerification,
                      userName: widget.ask.authorName,
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
                      stream: asksRef
                          .doc(widget.event.id)
                          .collection('eventAsks')
                          .doc(widget.ask.id)
                          .collection('replies')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Expanded(
                            child: Center(
                              child: CircularProgressIndicator( color:Colors.blue,),
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
                                  Ask reply =
                                      Ask.fromDoc(snapshot.data.docs[index]);
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
    bool isAuthor = _provider.currentUserId == widget.ask.authorId;
    bool isPostAuthor = widget.event.authorId == widget.ask.authorId;

    return FutureBuilder<List<Ask>>(
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
                  report: widget.ask.report,
                  content: widget.ask.content,
                  timestamp: widget.ask.timestamp,
                  authorId: widget.ask.authorId,
                  profileHandle: widget.ask.authorProfileHandle,
                  profileImageUrl: widget.ask.authorProfileImageUrl,
                  verified: widget.ask.authorVerification,
                  userName: widget.ask.authorName,
                  from: 'Comment',
                  onPressedReport: isAuthor
                      ? () {
                          _showBottomSheetEditComment(widget.ask, null);
                        }
                      : () {
                          _navigateToPage(
                            context,
                            ReportContentPage(
                              parentContentId: widget.event.id,
                              repotedAuthorId: widget.event.authorId,
                              contentId: widget.ask.id,
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

  _replyWidget(Ask reply) {
    var _provider = Provider.of<UserData>(context, listen: false);
    bool isAuthor = _provider.currentUserId == widget.ask.authorId;
    bool isPostAuthor = widget.event.authorId == widget.ask.authorId;

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
                  parentContentId: widget.event.id,
                  repotedAuthorId: widget.event.authorId,
                  contentId: widget.ask.id,
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

  List<Widget> _buildChildren(List<Ask> replies) {
    return replies.map((reply) {
      return Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child: _replyWidget(reply));
    }).toList();
  }
}
