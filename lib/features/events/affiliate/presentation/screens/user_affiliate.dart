import 'package:bars/utilities/exports.dart';

class UserAffilate extends StatefulWidget {
  static final id = 'UserAffilate';
  final String currentUserId;
  final String eventId;
  final String marketingType;

  final bool isUser;

  UserAffilate({
    required this.currentUserId,
    required this.isUser,
    required this.eventId,
    required this.marketingType,
  });

  @override
  _UserAffilateState createState() => _UserAffilateState();
}

class _UserAffilateState extends State<UserAffilate>
    with AutomaticKeepAliveClientMixin {
  List<AffiliateModel> _affiliateList = [];

  DocumentSnapshot? _lastInviteDocument;
  // DocumentSnapshot? _lastFiletedActivityDocument;

  int limit = 5;
  bool _hasNext = true;
  // String _isSortedBy = '';

  bool _isLoading = true;

  final now = DateTime.now();

  late ScrollController _hideButtonController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _setUpAffiliates();
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

  _setUpAffiliates() async {
    // try {
    Query ticketOrderSnapShot = await widget.isUser
        ? userAffiliateRef
            .doc(widget.currentUserId)
            .collection('affiliateMarketers')
            // .where('timestamp', isGreaterThanOrEqualTo: currentDate)
            .orderBy('timestamp', descending: true)
            .limit(10)
        : eventAffiliateRef
            .doc(widget.eventId)
            .collection('affiliateMarketers')
            .where('marketingType', isEqualTo: widget.marketingType)
            // .where('timestamp', isGreaterThanOrEqualTo: currentDate)
            // .orderBy('timestamp', descending: true)
            .limit(10);

    QuerySnapshot quey = await ticketOrderSnapShot.get();

    List<AffiliateModel> affiliate =
        quey.docs.map((doc) => AffiliateModel.fromDoc(doc)).toList();
    if (quey.docs.isNotEmpty) {
      _lastInviteDocument = quey.docs.last;
    }
    if (mounted) {
      setState(() {
        _affiliateList = affiliate;
        _isLoading = false;
      });
    }
    if (quey.docs.length < 10) {
      _hasNext = false; // No more documents to load
    }

    return affiliate;
    // } catch (e) {
    //   print('Error fetching initial invites: $e');
    //   // Handle the error appropriately.
    //   return [];
    // }
  }

  _loadMoreInvites() async {
    try {
      Query activitiesQuery = widget.isUser
          ? userAffiliateRef
              .doc(widget.currentUserId)
              .collection('affiliateMarketers')
              .orderBy('timestamp', descending: true)
              .startAfterDocument(_lastInviteDocument!)
              .limit(limit)
          : eventAffiliateRef
              .doc(widget.eventId)
              .collection('affiliateMarketers')
              .where('marketingType', isEqualTo: widget.marketingType)
              // .where('timestamp', isGreaterThanOrEqualTo: currentDate)
              // .orderBy('timestamp', descending: true)
              .startAfterDocument(_lastInviteDocument!)
              .limit(limit);

      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();

      List<AffiliateModel> morePosts = postFeedSnapShot.docs
          .map((doc) => AffiliateModel.fromDoc(doc))
          .toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _affiliateList.addAll(morePosts);
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

  // _setupActivities() async {
  // final currentDate = DateTime(now.year, now.month, now.day);

  //   try {
  //     Query activitiesQuery = userRefundRequestsRef
  //         .doc(widget.currentUserId)
  //         .collection('refundRequests')
  //         .where('startDate', isGreaterThanOrEqualTo: currentDate)
  //         .orderBy('timestamp', descending: true)
  //         .limit(10);

  //     if (_lastInviteDocument != null) {
  //       activitiesQuery =
  //           activitiesQuery.startAfterDocument(_lastInviteDocument!);
  //     }

  //     QuerySnapshot userFeedSnapShot = await activitiesQuery.get();
  //     List<AffiliateModel> activities =
  //         userFeedSnapShot.docs.map((doc) => AffiliateModel.fromDoc(doc)).toList();

  //     if (mounted) {
  //       setState(() {
  //         _affiliateList.addAll(
  //             activities.where((activity) => !_affiliateList.contains(activity)));
  //         _hasNext = userFeedSnapShot.docs.length == 10;
  //         if (userFeedSnapShot.docs.isNotEmpty) {
  //           _lastInviteDocument = userFeedSnapShot.docs.last;
  //         }
  //         _isLoading = false;
  //       });
  //     }
  //     return activities;
  //   } catch (e) {
  //     // Handle the error
  //     print('Error fetching user activities: $e');
  //     return []; // Return an empty list or a suitable default value
  //   }
  // }

  // _setupActivities() async {
  //       final currentDate = DateTime(now.year, now.month, now.day);

  //   try {
  //     Query activitiesQuery = userRefundRequestsRef
  //         .doc(widget.currentUserId)
  //         .collection('refundRequests')
  //         .where('startDate', isGreaterThanOrEqualTo: currentDate)
  //         .orderBy('timestamp', descending: true)
  //         .limit(10);
  //     // if _lastInviteDocument is not null, start after it
  //     if (_lastInviteDocument != null) {
  //       activitiesQuery =
  //           activitiesQuery.startAfterDocument(_lastInviteDocument!);
  //     }

  //     QuerySnapshot userFeedSnapShot = await activitiesQuery.get();
  //     List<AffiliateModel> activities =
  //         userFeedSnapShot.docs.map((doc) => AffiliateModel.fromDoc(doc)).toList();

  //     if (mounted) {
  //       setState(() {
  //         _affiliateList +=
  //             activities; // append new activities to the existing list
  //         _hasNext = userFeedSnapShot.docs.length == 10;
  //         if (userFeedSnapShot.docs.isNotEmpty) {
  //           _lastInviteDocument = userFeedSnapShot.docs.last;
  //           _lastFiletedActivityDocument = userFeedSnapShot.docs.last;
  //         } else {
  //           _lastInviteDocument = null; // Or your suitable default value
  //           _lastFiletedActivityDocument =
  //               null; // Or your suitable default value
  //         }
  //         _isLoading = false;
  //       });
  //     }
  //     return activities;
  //   } catch (e) {
  //     // Handle the error
  //     print('Error fetching user activities: $e');
  //     return []; // Return an empty list or a suitable default value
  //   }
  // }

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
              // Call recursive function to delete documents in chunks
              await deleteActivityDocsInBatches();
              _affiliateList.clear();
            } catch (e) {
              _showBottomSheetErrorMessage('Error clearing affiliate ');
            }
          },
          title: 'Are you sure you want to clear your affiliate data?',
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
            .collection('affiliateMarketers')
            .limit(500)
        : eventAffiliateRef
            .doc(widget.eventId)
            .collection('affiliateMarketers')
            .limit(500)
            .limit(limit);

    QuerySnapshot snapshot = await activitiesQuery.get();

    // var snapshot = await   userAffiliateRef
    //     .doc(widget.currentUserId)
    //     .collection('affiliateMarketers')
    //     .limit(500)
    //     .get();

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
    _affiliateList.clear();

    // call the function recursively to delete the next batch
    return deleteActivityDocsInBatches();
  }

  _buildActivityBuilder(
    List<AffiliateModel> _affiliateList,
  ) {
    return Scrollbar(
      child: CustomScrollView(
        // controller: _hideButtonController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                AffiliateModel affiliate = _affiliateList[index];

                return AffiliateWidget(
                  isUser: widget.isUser,
                  affiliate: affiliate,
                  currentUserId: widget.currentUserId,
                );
              },
              childCount: _affiliateList.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshData() async {
    await _setUpAffiliates();
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
                    'Affiliates',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        _showBottomSheetClearActivity(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 20),
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
                      : _affiliateList.isEmpty
                          ? Expanded(
                              child: Center(
                              child: NoContents(
                                icon: (Icons.attach_money),
                                title: 'No affiliate,',
                                subTitle:
                                    'All your affiliate data would be displayed here.',
                              ),
                            ))
                          : Expanded(
                              child: _buildActivityBuilder(
                              _affiliateList,
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
