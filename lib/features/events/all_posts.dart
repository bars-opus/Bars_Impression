import 'package:bars/utilities/exports.dart';

class AllPosts extends StatefulWidget {
  static final id = 'AllPosts';
  final String currentUserId;
  // final String eventId;
  final String shopType;

  // final bool isUser;
  // final bool fromActivity;

  final int pageIndex;
  // final UserSettingsLoadingPreferenceModel userLocationSettings;
  final String liveCity;
  final String liveCountry;
  // final String seeMoreFrom;
  // final int sortNumberOfDays;
  // final String isFrom;

  AllPosts({
    required this.currentUserId,
    // required this.isUser,
    // required this.eventId,
    required this.shopType,
    // required this.fromActivity,

    required this.pageIndex,
    // required this.userLocationSettings,
    required this.liveCity,
    required this.liveCountry,
    // required this.seeMoreFrom,
    // required this.sortNumberOfDays,
    // required this.isFrom,
  });

  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts>
    with AutomaticKeepAliveClientMixin {
  List<Post> _postList = [];

  DocumentSnapshot? _lastInviteDocument;
  late final _allPostSnapshot = <DocumentSnapshot>[];

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
      Query allPostsSnapShot = await allPostsRef
          .where('shopType', isEqualTo: widget.shopType)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      QuerySnapshot quey = await allPostsSnapShot.get();

      List<Post> posts = quey.docs.map((doc) => Post.fromDoc(doc)).toList();
      if (quey.docs.isNotEmpty) {
        _lastInviteDocument = quey.docs.last;
        _allPostSnapshot.addAll((quey.docs));
      }
      if (mounted) {
        setState(() {
          _postList = posts;
          _isLoading = false;
        });
      }
      if (quey.docs.length < 10) {
        _hasNext = false; // No more documents to load
      }

      return posts;
    } catch (e) {
      print('Error fetching initial invites: $e');
      // Handle the error appropriately.
      return [];
    }
  }

  _loadMoreInvites() async {
    try {
      Query postQuery = allPostsRef
          .where('shopType', isEqualTo: widget.shopType)
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);

      QuerySnapshot postFeedSnapShot = await postQuery.get();

      List<Post> morePosts =
          postFeedSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _postList.addAll(morePosts);
          _hasNext = postFeedSnapShot.docs.length == limit;
        });
      }
      return _hasNext;
    } catch (e) {
      // Handle the error
      print('Error fetching more posts: $e');
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

  // void _showBottomSheetClearActivity(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return ConfirmationPrompt(
  //         buttonText: 'Clear all',
  //         onPressed: () async {
  //           Navigator.pop(context);
  //           try {
  //             setState(() {
  //               _isDeleting = true;
  //             });
  //             // Call recursive function to delete documents in chunks
  //             await deleteActivityDocsInBatches();
  //             _postList.clear();
  //             setState(() {
  //               _isDeleting = false;
  //             });
  //           } catch (e) {
  //             _showBottomSheetErrorMessage('Error clearing posts ');
  //           }
  //         },
  //         title: 'Are you sure you want to clear your posts?',
  //         subTitle: '',
  //       );
  //     },
  //   );
  // }

  // Future<void> deleteActivityDocsInBatches() async {
  //   // get the first batch of documents to be deleted

  //   Query activitiesQuery = widget.isUser
  //       ? userAffiliateRef
  //           .doc(widget.currentUserId)
  //           .collection('postsMarketers')
  //           .limit(500)
  //       : eventAffiliateRef
  //           .doc(widget.eventId)
  //           .collection('postsMarketers')
  //           .limit(500)
  //           .limit(limit);
  //   QuerySnapshot snapshot = await activitiesQuery.get();
  //   // if there's no document left, return
  //   if (snapshot.docs.isEmpty) {
  //     return;
  //   }

  //   // prepare a new batch
  //   var batch = FirebaseFirestore.instance.batch();
  //   // loop over the documents in the snapshot and delete them
  //   snapshot.docs.forEach((doc) {
  //     batch.delete(doc.reference);
  //   });

  //   // commit the deletions
  //   await batch.commit();
  //   _postList.clear();

  //   // call the function recursively to delete the next batch
  //   return deleteActivityDocsInBatches();
  // }

  Widget _buildActivityGridBuilder(List<Post> _postList) {
    return Scrollbar(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1, // A// Aspect ratio of each item
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Post post = _postList[index];
                return EventDisplayWidget(
                  currentUserId: widget.currentUserId,
                  post: post,
                  postList: _postList,
                  eventSnapshot: _allPostSnapshot,
                  pageIndex: widget.pageIndex,
                  eventPagesOnly: false,
                  liveCity: widget.liveCity,
                  liveCountry: widget.liveCountry,
                  // sortNumberOfDays: widget.sortNumberOfDays,
                  isFrom: '',
                );

                // EventDisplayWidget(
                //   currentUserId: widget.currentUserId,
                //   postList: _postList,
                //   post: post,
                //   pageIndex: 0,
                //   eventSnapshot: [],
                //   eventPagesOnly: false,
                //   liveCity: '',
                //   liveCountry: '',
                //   isFrom: '',
                //   sortNumberOfDays: 0,
                // );
              },
              childCount: _postList.length,
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
      color: Theme.of(context).primaryColorLight,
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
                  backgroundColor: Theme.of(context).primaryColorLight,
                  title: Text(
                    '${widget.shopType} images',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  actions: [
                    // _isDeleting
                    //     ? Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: SizedBox(
                    //             height: ResponsiveHelper.responsiveFontSize(
                    //                 context, 20.0),
                    //             width: ResponsiveHelper.responsiveFontSize(
                    //                 context, 20.0),
                    //             child: CircularProgressIndicator(
                    //               backgroundColor: Colors.transparent,
                    //               valueColor: new AlwaysStoppedAnimation<Color>(
                    //                 Colors.blue,
                    //               ),
                    //               strokeWidth:
                    //                   ResponsiveHelper.responsiveFontSize(
                    //                       context, 2.0),
                    //             )),
                    //       )
                    //     : GestureDetector(
                    //         onTap: () {
                    //           _showBottomSheetClearActivity(context);
                    //         },
                    //         child: Padding(
                    //           padding:
                    //               const EdgeInsets.only(top: 20.0, right: 20),
                    //           child: Text(
                    //             'Clear all',
                    //             style: TextStyle(
                    //               color: Colors.red,
                    //               fontSize: ResponsiveHelper.responsiveFontSize(
                    //                   context, 14),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
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
                          child: EventAndUserScimmerSkeleton(
                          from: 'Posts',
                        ))
                      : _postList.isEmpty
                          ? Expanded(
                              child: Center(
                              child: NoContents(
                                icon: (Icons.image),
                                title: 'No posts,',
                                subTitle:
                                    'All ${widget.shopType.toLowerCase()} images would be displayed here.',
                              ),
                            ))
                          : Expanded(
                              child: _buildActivityGridBuilder(
                              _postList,
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
