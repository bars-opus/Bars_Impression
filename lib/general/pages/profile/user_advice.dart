import 'package:bars/general/pages/profile/dispay_advice_and_reply.dart';
import 'package:bars/utilities/exports.dart';

class UserAdviceScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String currentUserId;
  final bool? isBlocked;
  final bool? isBlocking;
  final bool? hideAdvice;
  final bool? disableAdvice;
  final VoidCallback updateBlockStatus;
  // var user;

  UserAdviceScreen({
    required this.userId,
    required this.currentUserId,
    required this.userName,
    required this.updateBlockStatus,
    this.isBlocked,
    this.isBlocking,
    required this.hideAdvice,
    required this.disableAdvice,
    // required this.user,
  });

  @override
  _UserAdviceScreenState createState() => _UserAdviceScreenState();
}

class _UserAdviceScreenState extends State<UserAdviceScreen> {
  final TextEditingController _adviceControler = TextEditingController();
  bool _isBlockedUser = false;
  bool _isBlockingUser = false;
  int _userAdviceCount = 0;
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  void initState() {
    super.initState();
    // _setUpUserAdvice();
    _setupIsBlockedUser();
    _adviceControler.addListener(_onAskTextChanged);
    _isBlockedUser = widget.isBlocked ?? false;
    _isBlockingUser = widget.isBlocking ?? false;
    widget.isBlocked ?? _setupIsBlocked();
    widget.isBlocking ?? _setupIsBlocking();
  }

  @override
  void dispose() {
    _adviceControler.dispose();
    _isTypingNotifier.dispose();
    super.dispose();
  }

  void _onAskTextChanged() {
    if (_adviceControler.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  Future<void> _setupIsBlocking() async {
    bool isBlockingUser = await DatabaseService.isBlokingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = isBlockingUser;
      });
    }
  }

  Future<void> _setupIsBlocked() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
  }

  // _setUpUserAdvice() async {
  //   DatabaseService.numAdvices(widget.userId).listen((userAdviceCount) {
  //     if (mounted) {
  //       widget.updateBlockStatus();
  //       setState(() {
  //         _userAdviceCount = userAdviceCount;
  //       });
  //     }
  //   });
  // }

  _buildAskTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return CommentContentField(
      autofocus: true,
      controller: _adviceControler,
      onSend: () {
        if (_adviceControler.text.trim().isNotEmpty) {
          HapticFeedback.mediumImpact();
          DatabaseService.userAdvice(
            currentUser: Provider.of<UserData>(context, listen: false).user!,
            userId: widget.userId,
            reportConfirmed: '',
            advice: _adviceControler.text.trim(),
          );
          kpiStatisticsRef
              .doc('0SuQxtu52SyYjhOKiLsj')
              .update({'advicesSent': FieldValue.increment(1)});
          _adviceControler.clear();
          _adviceControler.clear();
        }
      },
      hintText: widget.userId == currentUserId
          ? 'Reply advice'
          : 'Leave an advice for ${widget.userName}',
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetEditAdvice(
    UserAdvice userAdvice,
  ) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EditCommentContent(
            content: userAdvice.content,
            newContentVaraible: '',
            contentType: 'Advice',
            onPressedDelete: () {},
            onPressedSave: () {},
            onSavedText: (String) {},
          );
        });
  }

  _buildAsk(
    UserAdvice userAdvice,
  ) {
    return DisplayAdviceAndReply(
      advice: userAdvice,
      // user: widget.user,
      userId: widget.userId,
    );

    // Authorview(
    //   report: userAdvice.report,
    //   content: userAdvice.content,
    //   timestamp: userAdvice.timestamp,
    //   authorId: userAdvice.authorId,
    //   profileHandle: userAdvice.authorProfileHanlde,
    //   userName: userAdvice.authorName,

    //   profileImageUrl: userAdvice.authorProfileImageUrl,
    //   verified: userAdvice.authorVerification.isEmpty,
    //   from: '',
    //   onPressedReport: isAuthor
    //       ? () {
    //           _showBottomSheetEditAdvice(userAdvice);
    //         }
    //       : () {
    //           _navigateToPage(
    //             context,
    //             ReportContentPage(
    //               parentContentId: widget.userId,
    //               repotedAuthorId: userAdvice.authorId,
    //               contentId: userAdvice.id,
    //               contentType: 'Advice',
    //             ),
    //           );
    //         },
    //   onPressedReply: () {},
    //   onPressedSeeAllReplies: () {},
    //   isPostAuthor: false,
    // );
  }

  Widget _buildStreamBuilder(BuildContext context) {
    return StreamBuilder(
      stream: userAdviceRef
          .doc(widget.userId)
          .collection('userAdvice')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingContainer(context);
        }

        return snapshot.data.docs.length == 0
            ? _buildNoContentContainer(context)
            : _buildContentContainer(context, snapshot);
      },
    );
  }

  Widget _buildLoadingContainer(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildNoContentContainer(BuildContext context) {
    return Center(
      child: NoContents(
        icon: (MdiIcons.thoughtBubbleOutline),
        title: widget.userId == widget.currentUserId
            ? 'No advice for you.'
            : '\nNo advices for ${widget.userName} yet,\n',
        subTitle: widget.userId == widget.currentUserId
            ? ' Advice from fans and loved ones can provide valuable insights on how an individual can improve their craft. These public views are often aimed at providing inspiration and guidance to help the person grow and develop their skills or talents'
            : 'Be the first to offer advice to ${widget.userName}. Your advice is meant to encourage and provide insights on how a creative can improve their craft. These public views are aimed at inspiring and guiding them to enhance every aspect of their artistic craft.',
      ),
    );
  }

  Widget _buildHideAdice(BuildContext context) {
    return Expanded(
      child: Center(
        child: NoContents(
          icon: (Icons.lock),
          title: 'Hidden advice.',
          subTitle: widget.userId == widget.currentUserId
              ? 'Display your advice so that other users can read it and contribute additional insights.'
              : '${widget.userName} has chosen to keep the advices hidden for private purposes..',
        ),
      ),
    );
  }

  Widget _buildContentContainer(BuildContext context, AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                UserAdvice userAdvice =
                    UserAdvice.fromDoc(snapshot.data.docs[index]);
                return _buildAsk(
                  userAdvice,
                );
              },
              childCount: snapshot.data.docs.length,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isAuthor = widget.userId == widget.currentUserId;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TicketPurchasingIcon(
                title: '',
              ),
              widget.hideAdvice! && !_isAuthor
                  ? _buildHideAdice(context)
                  : Expanded(
                      child: _buildStreamBuilder(context),
                    ),
              if (!_isBlockingUser && !_isBlockedUser)
                if (!widget.disableAdvice!) _buildAskTF(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
