import 'package:bars/utilities/exports.dart';

class UserTags extends StatefulWidget {
  static final id = 'UserTags';
  final String currentUserId;
  final String eventId;
  final String marketingType;

  final bool isUser;
  final bool fromActivity;

  UserTags({
    required this.currentUserId,
    required this.isUser,
    required this.eventId,
    required this.marketingType,
    required this.fromActivity,
  });

  @override
  _UserTagsState createState() => _UserTagsState();
}

class _UserTagsState extends State<UserTags>
    with AutomaticKeepAliveClientMixin {
  List<TaggedNotificationModel> _tagList = [];

  DocumentSnapshot? _lastInviteDocument;
  // DocumentSnapshot? _lastFiletedActivityDocument;

  int limit = 5;
  bool _hasNext = true;
  // String _isSortedBy = '';

  bool _isLoading = true;
  bool _isDeleting = false;

  final now = DateTime.now();

  late ScrollController _hideButtonController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _setUpTags();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(
    ScrollNotification notification,
  ) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreInvites();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setUpTags() async {
    try {
      Query ticketOrderSnapShot = await userTagRef
          .doc(widget.currentUserId)
          .collection('tags')
          // .orderBy('timestamp', descending: true)
          .limit(limit);

      QuerySnapshot quey = await ticketOrderSnapShot.get();

      List<TaggedNotificationModel> tags =
          quey.docs.map((doc) => TaggedNotificationModel.fromDoc(doc)).toList();
      if (quey.docs.isNotEmpty) {
        _lastInviteDocument = quey.docs.last;
      }
      if (mounted) {
        setState(() {
          _tagList = tags;
          _isLoading = false;
        });
      }
      if (quey.docs.length < 10) {
        _hasNext = false; // No more documents to load
      }

      return tags;
    } catch (e) {
      print('Error fetching initial invites: $e');
      // Handle the error appropriately.
      return [];
    }
  }

  _loadMoreInvites() async {
    try {
      Query activitiesQuery = userTagRef
          .doc(widget.currentUserId)
          .collection('tags')
          // .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);

      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();

      List<TaggedNotificationModel> morePosts = postFeedSnapShot.docs
          .map((doc) => TaggedNotificationModel.fromDoc(doc))
          .toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _tagList.addAll(morePosts);
          _hasNext = postFeedSnapShot.docs.length == limit;
        });
      }
      return _hasNext;
    } catch (e) {
      // Handle the error
      print('Error fetching more user activities: $e');
      _hasNext = false;
      return _hasNext;
    }
  }

  void _showBottomSheetErrorMessage(String errorTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: errorTitle,
          subTitle: 'Check your internet connection and try again.',
        );
      },
    );
  }

  void _showBottomSheetClearActivity(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: 'Clear all',
          onPressed: () async {
            Navigator.pop(context);
            try {
              setState(() {
                _isDeleting = true;
              });
              // Call recursive function to delete documents in chunks
              await deleteActivityDocsInBatches();
              _tagList.clear();
              setState(() {
                _isDeleting = false;
              });
            } catch (e) {
              _showBottomSheetErrorMessage('Error clearing tags ');
            }
          },
          title: 'Are you sure you want to clear your tags?',
          subTitle: '',
        );
      },
    );
  }

  Future<void> deleteActivityDocsInBatches() async {
    // get the first batch of documents to be deleted

    Query activitiesQuery = widget.isUser
        ? userAffiliateRef
            .doc(widget.currentUserId)
            .collection('tagsMarketers')
            .limit(500)
        : eventAffiliateRef
            .doc(widget.eventId)
            .collection('tagsMarketers')
            .limit(500)
            .limit(limit);
    QuerySnapshot snapshot = await activitiesQuery.get();
    // if there's no document left, return
    if (snapshot.docs.isEmpty) {
      return;
    }

    // prepare a new batch
    var batch = FirebaseFirestore.instance.batch();
    // loop over the documents in the snapshot and delete them
    snapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    // commit the deletions
    await batch.commit();
    _tagList.clear();

    // call the function recursively to delete the next batch
    return deleteActivityDocsInBatches();
  }

  _buildActivityBuilder(
    List<TaggedNotificationModel> _tagList,
  ) {
    return Scrollbar(
      child: CustomScrollView(
        // controller: _hideButtonController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                TaggedNotificationModel tags = _tagList[index];

                return TagWidget(
                  // isUser: widget.isUser,
                  // tags: tags,
                  currentUserId: widget.currentUserId, currentTag: tags,
                  // fromActivity: false,
                );
              },
              childCount: _tagList.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshData() async {
    await _setUpTags();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Material(
      color: Theme.of(context).cardColor,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scrollbar(
          controller: _hideButtonController,
          child: NestedScrollView(
            controller: _hideButtonController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  pinned: false,
                  centerTitle: false,
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Theme.of(context).cardColor,
                  title: Text(
                    'Tags',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  actions: [
                    _isDeleting
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: ResponsiveHelper.responsiveFontSize(
                                    context, 20.0),
                                width: ResponsiveHelper.responsiveFontSize(
                                    context, 20.0),
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue,
                                  ),
                                  strokeWidth:
                                      ResponsiveHelper.responsiveFontSize(
                                          context, 2.0),
                                )),
                          )
                        : GestureDetector(
                            onTap: () {
                              _showBottomSheetClearActivity(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, right: 20),
                              child: Text(
                                'Clear all',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ];
            },
            body: RefreshIndicator(
              color: Colors.blue,
              onRefresh: refreshData,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isLoading
                      ? Expanded(
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                                8,
                                (index) => EventAndUserScimmerSkeleton(
                                      from: 'Event',
                                    )),
                          ),
                        )
                      : _tagList.isEmpty
                          ? Expanded(
                              child: Center(
                              child: NoContents(
                                icon: (Icons.attach_money),
                                title: 'No tags,',
                                subTitle:
                                    'All your tags data would be displayed here.',
                              ),
                            ))
                          : Expanded(
                              child: _buildActivityBuilder(
                              _tagList,
                            )),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
