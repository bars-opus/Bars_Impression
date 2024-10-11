import 'package:bars/utilities/exports.dart';

//These code has been tested for  better performance and potential bug prevention:
//14th August 2023  3:14pm
//Author: Harold Enam Kwaku Fianu (CEO BARS OPUS LTD)

class EventPageView extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final int eventIndex;
  final List<Post> postList;
  final List<DocumentSnapshot> eventSnapshot;
  final int pageIndex;

  final String liveCity;
  final String liveCountry;
  // final String seeMoreFrom;
  // final int sortNumberOfDays;
  final String isFrom;

  EventPageView(
      {required ValueKey key,
      required this.currentUserId,
      required this.pageIndex,
      required this.post,
      required this.postList,
      required this.eventSnapshot,
      required this.eventIndex,
      required this.liveCity,
      required this.liveCountry,
      // required this.seeMoreFrom,
      // required this.sortNumberOfDays,
      required this.isFrom})
      : super(key: key);

  @override
  State<EventPageView> createState() => _EventPageViewState();
}

class _EventPageViewState extends State<EventPageView> {
  late PageController _pageController2;
  List<Post> _filteredPosts = [];
  final _filteredEventSnapshot = <DocumentSnapshot>[];
  double page = 0.0;
  bool _hasNext = true;
  bool _loading = false;
  int _feedCount = 0;
  int _currentPageIndex = 0;
  bool _isSnackbarShown = false;
  String _isSnackbarType = '';
  late Timer _timer;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _pageController2 = PageController(
      initialPage: widget.pageIndex,
    );
    _currentPageIndex = widget.pageIndex; // Ensure this is initialized
    _pageController2.addListener(_onPageChanged);
    _timer = Timer(Duration(seconds: 0), () {});

    _filteredPosts = widget.postList;
  }

  @override
  void dispose() {
    _pageController2.removeListener(_onPageChanged);
    _pageController2.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _onPageChanged() {
    if (_timer.isActive) {
      _timer.cancel();
    }

    _timer = Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSnackbarShown = false;
        });
      }
    });
    int pageIndex = _pageController2.page!.round();
    if (_currentPageIndex != pageIndex) {
      _updateEvents(pageIndex);
      _currentPageIndex = pageIndex;
    }
  }

  Future<void> _setUpFeedCount(String type) async {
    final currentDate = DateTime(now.year, now.month, now.day);
    try {
      int feedCount = type.startsWith('All')
          ? await DatabaseService.numEventsAll(currentDate)
          : await DatabaseService.numEventsTypes(type, currentDate);
      if (mounted) {
        setState(() {
          _feedCount = feedCount;
        });
      }
    } catch (e) {
      // Handle error...
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController2.addListener(_onPageChanged);
    });
  }

  Map<int, String> eventTypes = {
    0: 'All',
    1: 'Parties',
    2: 'Music_concerts',
    3: 'Festivals',
    4: 'Club_nights',
    5: 'Pub_events',
    6: 'Games/Sports',
    7: 'Religious',
    8: 'Business',
    9: 'Others',
  };

  void _updateEvents(int pageIndex) async {
    HapticFeedback.lightImpact();
    if (eventTypes.containsKey(pageIndex)) {
      _updating(pageIndex, eventTypes[pageIndex]!);
    }
  }

  _updating(int pageIndex, String type) {
    _setUpFeedCount(type);
    if (mounted) {
      setState(() {
        pageIndex = _pageController2.page?.round() ?? 0;
        _isSnackbarShown = true;
        _isSnackbarType = type;
      });
    }
    if (pageIndex != 0) {
      _filteredPosts =
          widget.postList.where((post) => post.shopType == type).toList();
      _filteredEventSnapshot.clear();
      widget.liveCity.isNotEmpty
          ? _setupPosts(
              type: type,
              city: widget.liveCity,
              country: widget.liveCountry,
            )
          : widget.isFrom.isNotEmpty
              ? _setUpCityCountry(type)
              : _setupPosts(type: type);
    } else {
      widget.liveCity.isNotEmpty
          ? _setupPosts(
              type: 'All',
              city: widget.liveCity,
              country: widget.liveCountry,
            )
          : widget.isFrom.isNotEmpty
              ? _setUpCityCountry('All')
              : _setupPosts(type: 'All');
    }
  }

  _setUpCityCountry(
    String type,
  ) {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    return widget.isFrom.startsWith('City')
        ? _setupPosts(
            city: _userLocationSettings!.city,
            country: _userLocationSettings.country,
            type: type,
          )
        : _setupPosts(
            country: _userLocationSettings!.country,
            type: type,
          );
  }

  Set<String> addedEventIds = Set<String>();

  Future<List<Post>> _setupPosts({
    required String type,
    String? country,
    String? city,
    int sortNumberOfDays = 0,
  }) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    // final currentDate = DateTime(now.year, now.month, now.day);
    // // Calculate the end date based on the sortNumberOfDays
    // final endDate = currentDate.add(Duration(days: sortNumberOfDays));
    var query =

        // (type.startsWith('All'))
        //     ? allEventsRef.where('showOnExplorePage', isEqualTo: true)
        //     :

        allEventsRef
            .where('showOnExplorePage', isEqualTo: true)
            .where('shopType', isEqualTo: type);

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
      QuerySnapshot postFeedSnapShot = await query
          // .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
          // .orderBy('clossingDay', descending: false)
          .limit(2)
          .get();

      List<Post> posts =
          postFeedSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();

      List<Post> uniqueEvents = [];

      for (var post in posts) {
        if (addedEventIds.add(post.id!)) {
          uniqueEvents.add(post);
        }
      }

      if (mounted) {
        setState(() {
          _filteredPosts = posts;
          _filteredEventSnapshot.addAll((postFeedSnapShot.docs));
          _loading = false;
        });
      }
      return posts;
    } catch (e) {
      _showBottomSheetErrorMessage();
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      // You might want to return null or an empty list in case of error
      return [];
    }
  }

  void _showBottomSheetErrorMessage() {
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
          title: 'Failed to fetch posts.',
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  _noEvent(String type) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: Center(
              child: NoContents(
                icon: Icons.event,
                subTitle:
                    'There are no upcoming $type\s at the moment. We would update you if new $type\s are created. You can swipe left or right to explore other events.',
                title: 'No $type',
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 10,
            child: IconButton(
              icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back_ios),
              iconSize: 30.0,
              color: Theme.of(context).secondaryHeaderColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        alignment: FractionalOffset.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController2,
            onPageChanged: _updateEvents,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              String eventType = '';
              switch (index) {
                case 0:
                  eventType = 'Salon';

                  break;
                case 1:
                  eventType = 'Barbershop';

                  break;
                case 2:
                  eventType = 'Spa';

                  break;
                // case 3:
                //   eventType = 'Festivals';

                //   break;
                // case 4:
                //   eventType = 'Club_nights';

                //   break;
                // case 5:
                //   eventType = 'Pub_events';

                //   break;
                // case 6:
                //   eventType = 'Games/Sports';

                //   break;
                // case 7:
                //   eventType = 'Religious';

                //   break;
                // case 8:
                //   eventType = 'Business';

                //   break;
                // case 9:
                //   eventType = 'Others';

                //   break;
              }

              return _loading
                  ? CircularProgress(
                      isMini: false,
                    )
                  : _feedCount.isNegative
                      ? _noEvent(eventType)
                      : EventPages(
                          types: eventType,
                          post: widget.post,
                          currentUserId: widget.currentUserId,
                          postList: _filteredPosts,
                          eventSnapshot: _filteredEventSnapshot.isEmpty
                              ? widget.eventSnapshot
                              : _filteredEventSnapshot,
                          eventIndex: widget.eventIndex,
                          liveCity: widget.liveCity,
                          liveCountry: widget.liveCountry,
                          // sortNumberOfDays: widget.sortNumberOfDays,
                          isFrom: widget.isFrom,
                        );
            },
          ),
          Positioned(
            bottom: 70,
            child: InfoWidget(
              info: _isSnackbarType.startsWith('Others')
                  ? 'You are now browsing $_isSnackbarType'
                  : 'You are now browsing $_isSnackbarType',
              onPressed: () {},
              show: _isSnackbarShown,
            ),
          ),
        ],
      ),
    );
  }
}
