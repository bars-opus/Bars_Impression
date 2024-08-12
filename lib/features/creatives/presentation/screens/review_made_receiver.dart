import 'package:bars/utilities/exports.dart';

class ReviewMadeReceiver extends StatefulWidget {
  static final id = 'ReviewMadeReceiver';
  final String userId;
  final bool isDonar;
  ReviewMadeReceiver({
    required this.userId,
    required this.isDonar,
  });

  @override
  _ReviewMadeReceiverState createState() => _ReviewMadeReceiverState();
}

class _ReviewMadeReceiverState extends State<ReviewMadeReceiver>
    with AutomaticKeepAliveClientMixin {
  List<ReviewModel> _reviewList = [];
  int limit = 20;
  bool _hasNext = true;
  bool _isLoading = true;
  late ScrollController _hideButtonController;
  DocumentSnapshot? _lastInviteDocument;

  @override
  void initState() {
    super.initState();
    widget.isDonar ? _setReceiver() : _setUpDoner();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        widget.isDonar ? _loadMoreReceiver() : _loadMoreDoners();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setUpDoner() async {
    try {
      QuerySnapshot reviewSnapShot = await newReviewMadeRef
          .doc(widget.userId)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      List<ReviewModel> review =
          reviewSnapShot.docs.map((doc) => ReviewModel.fromDoc(doc)).toList();
      if (reviewSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = reviewSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _reviewList = review;
          _isLoading = false;
          print('Donar');
        });
      }

      if (reviewSnapShot.docs.length < 10) {
        _hasNext = false; // No more documents to load
      }

      return review;
    } catch (e) {
      print('Error fetching initial invites: $e');
      // Handle the error appropriately.
      return [];
    }
  }

  _loadMoreDoners() async {
    try {
      Query reviewssQuery = newReviewMadeRef
          .doc(widget.userId)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);

      QuerySnapshot postFeedSnapShot = await reviewssQuery.get();

      List<ReviewModel> moreReviews =
          postFeedSnapShot.docs.map((doc) => ReviewModel.fromDoc(doc)).toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _reviewList.addAll(moreReviews);
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

  _setReceiver() async {
    try {
      QuerySnapshot reviewSnapShot = await newReviewReceivedRef
          .doc(widget.userId)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      List<ReviewModel> review =
          reviewSnapShot.docs.map((doc) => ReviewModel.fromDoc(doc)).toList();
      if (reviewSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = reviewSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _reviewList = review;
          _isLoading = false;
        });
      }
      if (reviewSnapShot.docs.length < 10) {
        _hasNext = false; // No more documents to load
      }

      return review;
    } catch (e) {
      print('Error fetching initial reviews: $e');
      // Handle the error appropriately.
      return [];
    }
  }

  _loadMoreReceiver() async {
    try {
      Query reviewssQuery = newReviewReceivedRef
          .doc(widget.userId)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);

      QuerySnapshot postFeedSnapShot = await reviewssQuery.get();

      List<ReviewModel> moreReviews =
          postFeedSnapShot.docs.map((doc) => ReviewModel.fromDoc(doc)).toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _reviewList.addAll(moreReviews);
          _hasNext = postFeedSnapShot.docs.length == limit;
        });
      }
      return _hasNext;
    } catch (e) {
      // Handle the error
      print('Error fetching more user reviews: $e');
      _hasNext = false;
      return _hasNext;
    }
  }

  _buildDonationBuilder(
    List<ReviewModel> _reviewList,
  ) {
    return Scrollbar(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                ReviewModel review = _reviewList[index];

                return ReviewWidget(
                  review: review,
                  fullWidth: true,
                );
              },
              childCount: _reviewList.length,
            ),
          ),
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      controller: _hideButtonController,
      headerSliverBuilder: (context, innerBoxScrolled) => [],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isLoading
              ? Expanded(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                        8,
                        (index) => EventAndUserScimmerSkeleton(
                              from: 'Reviews',
                            )),
                  ),
                )
              : _reviewList.isEmpty
                  ? Expanded(
                      child: Center(
                      child: NoContents(
                        icon: (Icons.star_outline),
                        title: widget.isDonar
                            ? 'No reviews made,'
                            : 'No reviews received,',
                        subTitle: widget.isDonar
                            ? 'All the reviews you have made would appear here.'
                            : 'All the review other creatives have made would appear here.',
                      ),
                    ))
                  : Expanded(
                      child: _buildDonationBuilder(
                      _reviewList,
                    )),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
