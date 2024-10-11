import 'package:bars/utilities/exports.dart';

//These code has been tested for  better performance and potential bug prevention:
//14th August 2023  7:34pm
//Author: Harold Enam Kwaku Fianu (CEO BARS OPUS LTD)

class EventPages extends StatefulWidget {
  final String currentUserId;
  final String types;
  final Post post;
  final int eventIndex;
  final List<Post> postList;
  final List<DocumentSnapshot> eventSnapshot;
  final String liveCity;
  final String liveCountry;
  final String isFrom;
  // final int sortNumberOfDays;

  EventPages({
    required this.postList,
    required this.eventSnapshot,
    required this.currentUserId,
    required this.post,
    required this.eventIndex,
    required this.types,
    required this.liveCity,
    required this.liveCountry,
    // required this.sortNumberOfDays,
    required this.isFrom,
  });

  @override
  _EventPagesState createState() => _EventPagesState();
}

class _EventPagesState extends State<EventPages> {
  late PageController _pageController2;
  double page = 0.0;
  int limit = 2;
  int _currentPageIndex = 0;
  List<Post> postList = [];
  List<DocumentSnapshot> eventSnapshot = [];
  final now = DateTime.now();
  bool hasMoreEvents = true;

  @override
  void initState() {
    super.initState();
    _pageController2 = PageController(
      initialPage: widget.eventIndex,
    );
    _currentPageIndex = widget.eventIndex;
    postList = List.from(widget.postList);
    eventSnapshot = List.from(widget.eventSnapshot);
  }

  @override
  void dispose() {
    _pageController2.dispose();
    super.dispose();
  }

  Future<List<Post>> _loadMoreEvents({
    String? country,
    String? city,
    int sortNumberOfDays = 0,
  }) async {
    // sortNumberOfDays = widget.sortNumberOfDays;
    final currentDate = DateTime(now.year, now.month, now.day);
    // final endDate = currentDate.add(Duration(days: sortNumberOfDays));

    var query =
        // widget.types.startsWith('All')
        //     ? allEventsRef.where('showOnExplorePage', isEqualTo: true)
        //     :
        allEventsRef
            .where('showOnExplorePage', isEqualTo: true)
            .where('shopType', isEqualTo: widget.types);

    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }
    // if (sortNumberOfDays != 0) {
    //   query = query.where('clossingDay', isLessThanOrEqualTo: endDate);
    // }

    try {
      QuerySnapshot eventFeedSnapShot = await query
          // .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
          // .orderBy('clossingDay', descending: false)
          .startAfterDocument(eventSnapshot.last)
          .limit(2)
          .get();

      List<Post> posts =
          eventFeedSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();

// Add new events to existing list
      postList.addAll(posts);
// Add new snapshots to existing list
      eventSnapshot.addAll((eventFeedSnapShot.docs));
      if (mounted) {
        setState(() {});
      }
      return posts;
    } catch (e) {
      // print('Error loading more events: $e');
      // Consider what you want to do in case of error. Here, we return an empty list
      return [];
    }
  }

  _loadMoreCityCountry() {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    return widget.isFrom.startsWith('City')
        ? _loadMoreEvents(
            city: _userLocationSettings!.city,
            country: _userLocationSettings.country,
          )
        : _loadMoreEvents(
            country: _userLocationSettings!.country,
          );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      controller: _pageController2,
      itemCount: hasMoreEvents
          ? postList.length + 1
          : postList.length, // Add an additional empty page
      onPageChanged: (i) async {
        // Update the current page index first
        _currentPageIndex = i;
        if (i == postList.length) {
          List<Post> newEvents = await (widget.liveCity.isNotEmpty
              ? _loadMoreEvents(
                  city: widget.liveCity,
                  country: widget.liveCountry,
                )
              : widget.isFrom.isNotEmpty
                  ? _loadMoreCityCountry()
                  : _loadMoreEvents());
          // If no more events were loaded, navigate back to the previous page
          if (newEvents.isEmpty) {
            _pageController2.animateToPage(
              (_currentPageIndex - 1).clamp(0, postList.length - 1),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            // Display a Snackbar
            HapticFeedback.lightImpact();
            mySnackBar(context, 'no more events to load');
          }
        }
      },
      itemBuilder: (context, index) {
        if (index == postList.length) {
          // This is the additional empty page, display a loading spinner
          return CircularProgress(
            isMini: false,
          );
        }
        final post = postList[index];
        return EventEnlargedScreen(
          currentUserId: widget.currentUserId,
          post: post,
          type: widget.types,
          showPrivateEvent: false,
        );
      },
    );
  }
}
