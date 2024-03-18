import 'package:bars/utilities/exports.dart';

class UserPayouts extends StatefulWidget {
  static final id = 'UserPayouts';
  final String currentUserId;
  UserPayouts({
    required this.currentUserId,
  });

  @override
  _UserPayoutsState createState() => _UserPayoutsState();
}

class _UserPayoutsState extends State<UserPayouts>
    with AutomaticKeepAliveClientMixin {
  List<EventPayoutModel> _payoutList = [];

  DocumentSnapshot? _lastInviteDocument;
  DocumentSnapshot? _lastFiletedActivityDocument;

  int limit = 5;
  bool _hasNext = true;
  String _isSortedBy = '';

  bool _isLoading = true;

  final now = DateTime.now();

  late ScrollController _hideButtonController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _setUpInvites();

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

  _setUpInvites() async {
    try {
      QuerySnapshot ticketOrderSnapShot = await userPayoutRequestRef
          .doc(widget.currentUserId)
          .collection('payoutRequests')
          // .where('timestamp', isGreaterThanOrEqualTo: currentDate)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      List<EventPayoutModel> ticketOrder = ticketOrderSnapShot.docs
          .map((doc) => EventPayoutModel.fromDoc(doc))
          .toList();
      if (ticketOrderSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = ticketOrderSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _payoutList = ticketOrder;
          _isLoading = false;
        });
      }
      if (ticketOrderSnapShot.docs.length < 10) {
        _hasNext = false; // No more documents to load
      }

      return ticketOrder;
    } catch (e) {
      print('Error fetching initial invites: $e');
      // Handle the error appropriately.
      return [];
    }
  }

  _loadMoreInvites() async {
    try {
      Query activitiesQuery = userPayoutRequestRef
          .doc(widget.currentUserId)
          .collection('payoutRequests')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);

      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();

      List<EventPayoutModel> morePosts = postFeedSnapShot.docs
          .map((doc) => EventPayoutModel.fromDoc(doc))
          .toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _payoutList.addAll(morePosts);
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
  //     Query activitiesQuery = userPayoutRequestRef
  //         .doc(widget.currentUserId)
  //         .collection('payoutRequests')
  //         .where('startDate', isGreaterThanOrEqualTo: currentDate)
  //         .orderBy('timestamp', descending: true)
  //         .limit(10);

  //     if (_lastInviteDocument != null) {
  //       activitiesQuery =
  //           activitiesQuery.startAfterDocument(_lastInviteDocument!);
  //     }

  //     QuerySnapshot userFeedSnapShot = await activitiesQuery.get();
  //     List<EventPayoutModel> activities =
  //         userFeedSnapShot.docs.map((doc) => EventPayoutModel.fromDoc(doc)).toList();

  //     if (mounted) {
  //       setState(() {
  //         _payoutList.addAll(
  //             activities.where((activity) => !_payoutList.contains(activity)));
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
  //     Query activitiesQuery = userPayoutRequestRef
  //         .doc(widget.currentUserId)
  //         .collection('payoutRequests')
  //         .where('startDate', isGreaterThanOrEqualTo: currentDate)
  //         .orderBy('timestamp', descending: true)
  //         .limit(10);
  //     // if _lastInviteDocument is not null, start after it
  //     if (_lastInviteDocument != null) {
  //       activitiesQuery =
  //           activitiesQuery.startAfterDocument(_lastInviteDocument!);
  //     }

  //     QuerySnapshot userFeedSnapShot = await activitiesQuery.get();
  //     List<EventPayoutModel> activities =
  //         userFeedSnapShot.docs.map((doc) => EventPayoutModel.fromDoc(doc)).toList();

  //     if (mounted) {
  //       setState(() {
  //         _payoutList +=
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
              _payoutList.clear();
            } catch (e) {
              _showBottomSheetErrorMessage('Error clearing notifications ');
            }
          },
          title: 'Are you sure you want to clear your ticket payouts.',
          subTitle: '',
        );
      },
    );
  }

  Future<void> deleteActivityDocsInBatches() async {
    // get the first batch of documents to be deleted
    var snapshot = await userPayoutRequestRef
        .doc(widget.currentUserId)
        .collection('payoutRequests')
        .limit(500)
        .get();

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
    _payoutList.clear();

    // call the function recursively to delete the next batch
    return deleteActivityDocsInBatches();
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _buildActivityBuilder(
    List<EventPayoutModel> _payoutList,
  ) {
    var _textStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Colors.grey,
    );

    return Scrollbar(
      child: CustomScrollView(
        // controller: _hideButtonController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                EventPayoutModel invite = _payoutList[index];
                bool _isRefunded = invite.status == 'processed';
                bool _isLoading = false;
                var _textStyle2 = TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: Theme.of(context).secondaryHeaderColor,
                  decoration: _isRefunded
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                );

                return GestureDetector(
                  onTap: () async {
                    _isLoading = true;
                    try {
                      Event? event =
                          await DatabaseService.getEventWithId(invite.eventId);

                      if (event != null) {
                        _navigateToPage(EventEnlargedScreen(
                          currentUserId: widget.currentUserId,
                          event: event,
                          type: event.type,
                        ));
                      } else {
                        _showBottomSheetErrorMessage('Failed to fetch event.');
                      }
                    } catch (e) {
                      _showBottomSheetErrorMessage('Failed to fetch event');
                    } finally {
                      _isLoading = false;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                textScaleFactor:
                                    MediaQuery.of(context).textScaleFactor,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '\nEvent:                   ',
                                      style: _textStyle,
                                    ),
                                    TextSpan(
                                      text: invite.eventTitle,
                                      style: _textStyle2,
                                    ),
                                    TextSpan(
                                      text: '\nStatus:                  ',
                                      style: _textStyle,
                                    ),
                                    TextSpan(
                                      text: invite.status,
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 14.0),
                                        color: invite.status == 'pending'
                                            ? Colors.red
                                            : Colors.blue,
                                        decoration: _isRefunded
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\nApproved time:    ',
                                      style: _textStyle,
                                    ),
                                    TextSpan(
                                      text: MyDateFormat.toDate(
                                          invite.timestamp.toDate()),
                                      style: _textStyle2,
                                    ),
                                    TextSpan(
                                      text: '\nId:                         ',
                                      style: _textStyle,
                                    ),
                                    TextSpan(
                                      text: invite.id,
                                      style: _textStyle2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
              childCount: _payoutList.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshData() async {
    await _setUpInvites();
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    // int  .count = _provider.activityCount - 1;

    super.build(context);
    // final width =
    //      MediaQuery.of(context).size.width;

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
                  backgroundColor: Theme.of(context).primaryColorLight,
                  title: Text(
                    'Ticket sales payout',
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
                      : _payoutList.isEmpty
                          ? Expanded(
                              child: Center(
                              child: NoContents(
                                icon: (MdiIcons.transfer),
                                title: 'No payouts,',
                                subTitle:
                                    'All your ticket sales payouts would appear here.',
                              ),
                            ))
                          : Expanded(
                              child: _buildActivityBuilder(
                              _payoutList,
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

// //display
// class Display extends StatelessWidget {
//   // final AccountHolder user;

//   // Display({
//   //   // required this.user,
//   // });
//   // @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//           textScaleFactor:
//               MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.2)),
//       child: FadeAnimation(
//         1,
//         Container(
//           height: 35,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               AnimatedTextKit(
//                   animatedTexts: [
//                     FadeAnimatedText(
//                       'Attend',
//                       textStyle: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     FadeAnimatedText(
//                       'Meet',
//                       textStyle: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     FadeAnimatedText(
//                       'Experience...',
//                       textStyle: Theme.of(context).textTheme.titleMedium,
//                     ),
//                   ],
//                   repeatForever: true,
//                   pause: const Duration(milliseconds: 3000),
//                   displayFullTextOnTap: true,
//                   stopPauseOnTap: true),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
