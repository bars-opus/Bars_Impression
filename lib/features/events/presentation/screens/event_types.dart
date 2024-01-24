import 'dart:math';

import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

//15th August 2023 : 12:49am
//Author: Harold Enam Kwaku Fianu (CEO BARS OPUS LTD)

// This is a StatefulWidget that takes several parameters including the current user's ID,
// event types, page index, user information, city, country, "see more" location,
// number of days to sort by, and where the event originates from. These parameters are u
//sed to display and filter the list of events.

class EventTypes extends StatefulWidget {
  static final id = 'EventTypes';
  final String currentUserId;
  final String types;
  final int pageIndex;
  final UserSettingsLoadingPreferenceModel userLocationSettings;
  // final bool isLiveLocation;
  final String liveCity;
  final String liveCountry;
  final String seeMoreFrom;
  final int sortNumberOfDays;
  final String isFrom;

  EventTypes({
    required this.currentUserId,
    required this.types,
    required this.pageIndex,
    required this.userLocationSettings,
    // required this.isLiveLocation,
    required this.liveCity,
    required this.liveCountry,
    required this.seeMoreFrom,
    required this.sortNumberOfDays,
    required this.isFrom,
  });
  @override
  _EventTypesState createState() => _EventTypesState();
}

class _EventTypesState extends State<EventTypes>
    with AutomaticKeepAliveClientMixin {
  List<Event> _eventsCity = [];
  List<Event> _eventsCountry = [];
  List<Event> _eventsAll = [];

  List<Event> _eventsThisWeek = [];
  List<Event> _eventFree = [];

  final _eventCitySnapshot = <DocumentSnapshot>[];
  final _eventCountrySnapshot = <DocumentSnapshot>[];
  late final _eventAllSnapshot = <DocumentSnapshot>[];

  late final _eventFreeSnapshot = <DocumentSnapshot>[];
  late final _eventThisWeekSnapshot = <DocumentSnapshot>[];

  List<Event> _eventFollowing = [];

  late final _eventFollowingSnapshot = <DocumentSnapshot>[];

  int limit = 10;
  int _feedCount = 0;

  late ScrollController _hideButtonController;

  final now = DateTime.now();
  List<WorkRequestOrOfferModel> _userWorkRequest = [];

  // final _oneWeekAgo = DateTime.now().subtract(Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _setUp();

    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        Provider.of<UserData>(context, listen: false).setShowEventTab(true);
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        Provider.of<UserData>(context, listen: false).setShowEventTab(false);
      }
    });
  }

// This function sets up the feed of events. It decides whether to sort the feed by a specific number of days,
// and whether to display events from a specific city, country, or all events.
  _setUp() {
    widget.sortNumberOfDays != 0
        ? _setUpCountSortNumberOfDays(widget.sortNumberOfDays)
        : _setUpCount();
    // limit = widget.liveCity.isNotEmpty || widget.seeMoreFrom.isNotEmpty
    //     ? 10
    //     : limit;
    widget.seeMoreFrom.isNotEmpty
        ? _setUpFeedSeeMore()
        : widget.liveCity.isNotEmpty
            ? _setUpFeedLive()
            : _setUpFeed();
    _setupEventsFreeAndThisWeek(false);
    _setupEventsFreeAndThisWeek(true);
    if (widget.liveCity.isEmpty) _setupEventsFollowers();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var _provider = Provider.of<UserData>(context, listen: false);

      _provider.setLoadingThisWeekEvent(true);
    });
    // _setUpFeedFollowingCount();
  }

  //  These functions get the count of events from the Firestore database.
  //  The count is fetched based on the event types and date. If the event types are not specified,
  //  it fetches all events. The _setUpCountSortNumberOfDays() function additionally sorts the events by a specific number of days.

  _setUpCount() {
    widget.liveCity.isNotEmpty
        ? _setUpLiveLocationFeedCount()
        : _setUpFeedCount();
  }

  _setUpFeedCount() async {
    final currentDate = DateTime(now.year, now.month, now.day);
    int feedCount = widget.types.isEmpty
        ? await DatabaseService.numEventsAll(currentDate)
        : await DatabaseService.numEventsTypes(widget.types, currentDate);
    if (mounted) {
      setState(() {
        _feedCount = feedCount;
      });
    }
  }

  _setUpCountSortNumberOfDays(int sortNumberOfDays) async {
    final currentDate = DateTime(now.year, now.month, now.day);
    int feedCount = widget.types.isEmpty
        ? await DatabaseService.numEventsAllSortNumberOfDays(
            currentDate, sortNumberOfDays)
        : await DatabaseService.numEventsTypesSortNumberOfDays(
            widget.types, currentDate, sortNumberOfDays);
    if (mounted) {
      setState(() {
        _feedCount = feedCount;
      });
    }
  }

  _setUpLiveLocationFeedCount() async {
    final currentDate = DateTime(now.year, now.month, now.day);
    int feedCount = widget.types.isEmpty
        ? await DatabaseService.numEventsAllLiveLocation(
            widget.liveCity, widget.liveCountry, currentDate)
        : await DatabaseService.numEventsTypesLiveLocation(
            widget.types, widget.liveCity, widget.liveCountry, currentDate);
    if (mounted) {
      setState(() {
        _feedCount = feedCount;
      });
    }
  }

  // _setUpFeedFollowingCount() async {
  //   final currentDate = DateTime(now.year, now.month, now.day);
  //   int feedCount = widget.types.isEmpty
  //       ? await DatabaseService.numEventsFollowingAll(
  //           currentDate, widget.currentUserId)
  //       : await DatabaseService.numEventsFollowing(
  //           currentDate,
  //           widget.currentUserId,
  //           widget.types,
  //         );
  //   if (mounted) {
  //     setState(() {
  //       _feedCount = feedCount;
  //     });
  //   }
  // }

  // _setUpFeed(), _setUpFeedLive(), _setUpFeedSeeMore(): These functions are setting up the feed of events.
  // They call the _setupEvents function with different parameters, determining the type of events to fetch -- either all events,
  // events from a specific city, or events from a specific country.

  _setUpFeed() {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;
//
//chage greater than start date for event feedcount
//
    String? city = _userLocationSettings!.city;
    bool? isAll = false;
    String? country = _userLocationSettings.country;

    _setupEvents(
        city: city, country: country, isAll: isAll, from: 'City'); // For city
    _setupEvents(
        country: country, isAll: isAll, from: 'Country'); // For country
    _setupEvents(isAll: true, from: ''); // For all

    _setupWorkRequest(
      city ?? '',
    );
  }

  _setUpFeedLive() {
    //   liveCity: widget.liveCity, liveCountry: widget.liveCountry
    // String? city = widget.user.city;
    // String? country = widget.user.country;

    _setupEvents(
        city: widget.liveCity,
        country: widget.liveCountry,
        isAll: true,
        from: 'City');

    _setupWorkRequest(
      widget.liveCity,
    );

    // _setupEvents(); // For all
  }

  _setUpFeedSeeMore() {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    String? city = _userLocationSettings!.city;
    String? country = _userLocationSettings.country;
    widget.seeMoreFrom.startsWith('City')
        ? _setupEvents(city: city, country: country, isAll: true, from: 'City')
        : // For city
        _setupEvents(
            country: country, isAll: true, from: 'Country'); // For country

    _setupWorkRequest(city ?? '');

    // _setupEvents(); // For all
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

// The _setupEvents function is an asynchronous method that fetches a list of Event
// objects from a Firebase Firestore database. The function is flexible and
// can filter and sort the events based on various criteria provided via
// function parameters.
// Set to hold IDs of already added events.
  Set<String> addedEventIds = Set<String>();

  Set<String> addedCityCountryEventIds = Set<String>();
  Set<String> addedCountryEventIds = Set<String>();

  Future<List<Event>> _setupEvents({
    String? country,
    String? city,
    required bool isAll,
    required String from,
    int sortNumberOfDays = 0,
  }) async {
    sortNumberOfDays = widget.sortNumberOfDays;

    // Calculate current and end date based on sortNumberOfDays
    final currentDate = DateTime(now.year, now.month, now.day);
    final endDate = currentDate.add(Duration(days: sortNumberOfDays));

    // Determine newLimit based on isAll and widget.seeMoreFrom
    int newLimit = isAll
        ? 10
        : widget.seeMoreFrom.isNotEmpty
            ? 15
            : limit;

    // Construct Firestore query based on widget.types, country, city, and sortNumberOfDays
    var query = widget.types.isEmpty
        ? allEventsRef
        : allEventsRef.where('type', isEqualTo: widget.types);
    if (country != null) query = query.where('country', isEqualTo: country);
    if (city != null) query = query.where('city', isEqualTo: city);

    if (sortNumberOfDays != 0) {
      query = query.where('startDate', isLessThanOrEqualTo: endDate);
    }

    try {
      //   // Fetch and order events from Firestore
      // QuerySnapshot eventFeedSnapShot = await query.limit(10).get();

      QuerySnapshot eventFeedSnapShot = await query
          .where('startDate', isGreaterThanOrEqualTo: currentDate)
          .orderBy('startDate', descending: false)
          // // .orderBy(FieldPath.documentId)

          // .where('fundsDistributed', isEqualTo: false)
          .limit(newLimit)
          .get();

      // Transform documents to Event objects
      List<Event> events =
          eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();

// Then, in _setupEvents:

// Filter out duplicates and add events to addedEventIds
      List<Event> uniqueEvents = [];
      if (from.startsWith('City')) {
        for (var event in events) {
          if (addedCityCountryEventIds.add(event.id)) {
            uniqueEvents.add(event);
          }
        }
      } else if (from.startsWith('Country')) {
        for (var event in events) {
          if (addedCityCountryEventIds.add(event.id)) {
            uniqueEvents.add(event);
          }
        }
      } else {
        for (var event in events) {
          if (addedEventIds.add(event.id)) {
            uniqueEvents.add(event);
          }
        }
      }

      // Add documents to appropriate snapshot based on from parameter and isAll
      if (from.startsWith('Country'))
        _eventCountrySnapshot.addAll((eventFeedSnapShot.docs));
      if (from.startsWith('City'))
        _eventCitySnapshot.addAll((eventFeedSnapShot.docs));
      if (isAll) _eventAllSnapshot.addAll((eventFeedSnapShot.docs));

      // Update widget state with fetched events
      if (mounted) {
        setState(() {
          if (widget.seeMoreFrom.isNotEmpty || widget.liveCity.isNotEmpty) {
            _eventsAll = uniqueEvents;
          } else {
            if (country != null && city != null) {
              _eventsCity = uniqueEvents;
            } else if (country != null) {
              _eventsCountry = uniqueEvents;
            } else {
              _eventsAll = uniqueEvents;
            }
          }
        });
      }

      return uniqueEvents;
    } catch (e) {
      _showBottomSheetErrorMessage();
      return [];
    }
  }

  Set<String> addedEventFollowingIds = Set<String>();

  Future<List<Event>> _setupEventsFollowers() async {
    final currentDate = DateTime(now.year, now.month, now.day);

    // Construct Firestore query based on widget.types, country, city, and sortNumberOfDays
    try {
      var query = widget.types.isEmpty
          ? eventFeedsRef.doc(widget.currentUserId).collection('userEventFeed')
          : eventFeedsRef
              .doc(widget.currentUserId)
              .collection('userEventFeed')
              .where('type', isEqualTo: widget.types);

      QuerySnapshot eventFeedSnapShot = await query
          .where('startDate', isGreaterThanOrEqualTo: currentDate)
          .orderBy('startDate', descending: false)
          .orderBy(FieldPath.documentId)
          .limit(30)
          .get();

      // Transform documents to Event objects
      List<Event> events =
          eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();

      _eventFollowingSnapshot.addAll((eventFeedSnapShot.docs));

      // Update widget state with fetched events
      if (mounted) {
        setState(() {
          _eventFollowing = events;
        });
      }

      return events;
    } catch (e) {
      _showBottomSheetErrorMessage();
      return [];
    }
  }

// This function fetches free events and events of this week using the _fetchEvents() function.
// It fetches events from the user's city, the user's country, and anywhere else
// until it reaches a limit of 10 events.

  Future<List<Event>> _setupEventsFreeAndThisWeek(bool isFree) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    // Fetches the current user's data from the provider
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

// Retrieves the user's country and city information
    String country = widget.liveCountry.isNotEmpty
        ? widget.liveCountry
        : _userLocationSettings!.country!;

    String city = widget.liveCity.isNotEmpty
        ? widget.liveCity
        : _userLocationSettings!.city!;

// Initializes the remaining limit of events to fetch
    int remainingLimit = 10;
    List<Event> events = [];

// Fetches events within the user's city
    events += await _fetchEvents(
      limit: 10,
      country: country,
      city: city,
      isFree: isFree,
    );
    remainingLimit -= events
        .length; // Decrement the remaining limit by the number of fetched events

// If there's remaining limit, fetch more events from the user's country

    if (remainingLimit > 0) {
      if (widget.liveCity.isEmpty)
        events += await _fetchEvents(
          limit: remainingLimit,
          country: country,
          isFree: isFree,
        );
      remainingLimit = 10 - events.length; // Recalculate the remaining limit
    }

// If there's still remaining limit, fetch more events from anywhere
    if (remainingLimit > 0) {
      if (widget.liveCity.isEmpty)
        events += await _fetchEvents(
          limit: remainingLimit,
          isFree: isFree,
        );
    }

// Update the state with fetched events
    if (mounted) {
      isFree
          ? setState(() {
              _eventFree = events; // Update the free events state
            })
          : setState(() {
              _eventsThisWeek = events; // Update the events of this week state
            });
    }
    _provider.setLoadingThisWeekEvent(false);

    return events; // Return the fetched events
  }

  // This function is similar to _setupEvents(), but it also includes a isFree parameter for fetching free events.
  // It constructs a Firestore query based on the parameters, fetches the data, transforms the documents
  // to event objects, and updates the widget state with these fetched events.

  Set<String> addedThisWeekEventIds = Set<String>();

  Set<String> addedFreeEventIds = Set<String>();

  Future<List<Event>> _fetchEvents({
    required int limit,
    String? country,
    String? city,
    required bool isFree,
  }) async {
    int sortNumberOfDays = 7;
    final currentDate = DateTime(now.year, now.month, now.day);
    final endDate = currentDate.add(Duration(days: sortNumberOfDays));

    Query<Map<String, dynamic>> query = widget.types.isEmpty
        ? allEventsRef
        : allEventsRef.where('type', isEqualTo: widget.types);

    query =
        query.where('startDate', isGreaterThanOrEqualTo: currentDate).orderBy(
              'startDate',
            );
    // Refine the query based on the provided country and city
    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }

    if (isFree) {
      query = query.where('isFree', isEqualTo: true);
    }

    // if (sortNumberOfDays != 0) {
    if (!isFree) {
      query = query.where('startDate', isLessThanOrEqualTo: endDate);
    }
    // }

    // try {
    // Fetch events from Firestore up to the limit

    QuerySnapshot eventFeedSnapShot = await query
        // .where('startDate', isGreaterThanOrEqualTo: currentDate)
        // .orderBy('startDate', descending: false)
        .orderBy(FieldPath.documentId)
        .limit(limit)
        .get();

    // Transform the documents into Event objects

    List<Event> uniqueEvents = [];

    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (isFree) {
      if (_eventFreeSnapshot.isEmpty) {
        _eventFreeSnapshot.addAll(eventFeedSnapShot.docs);
      }
      for (var event in events) {
        if (addedFreeEventIds.add(event.id)) {
          uniqueEvents.add(event);
        }
      }
    }

    // Add the documents to the appropriate snapshot
    if (!isFree) {
      if (_eventThisWeekSnapshot.isEmpty) {
        _eventThisWeekSnapshot.addAll(eventFeedSnapShot.docs);
      }
      for (var event in events) {
        if (addedThisWeekEventIds.add(event.id)) {
          uniqueEvents.add(event);
        }
      }
    }
    // Return the fetched events
    return uniqueEvents;
    // } catch (e) {
    //   print('Failed to fetch events: $e');
    //   return [];
    // }
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
          title: 'Failed to fetch events. ',
          subTitle: 'Please check your internet connection and try again',
        );
      },
    );
  }

  // This function handles the scrolling event of the widget.
  // If the scroll reaches the end (detected by ScrollEndNotification),
  // it triggers the _loadMoreEvents function to load more events based on
  // conditions like city, country, or simply load more in general.

  bool _handleScrollNotification(ScrollNotification notification) {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        String? city = widget.liveCity.isEmpty
            ? _userLocationSettings!.city
            : widget.liveCity;
        String? country = widget.liveCountry.isEmpty
            ? _userLocationSettings!.country
            : widget.liveCountry;

        widget.liveCity.isNotEmpty
            ? _loadMoreEvents(
                city: city,
                country: country,
                documentSnapshot: _eventAllSnapshot)
            : widget.seeMoreFrom.startsWith('City')
                ? _loadMoreEvents(
                    city: city,
                    country: country,
                    documentSnapshot: _eventCitySnapshot,
                  )
                : widget.seeMoreFrom.startsWith('Country')
                    ? _loadMoreEvents(
                        country: country,
                        documentSnapshot: _eventCountrySnapshot,
                      )
                    : _loadMoreEvents(documentSnapshot: _eventAllSnapshot);
      }
    }
    return false;
  }

// _loadMoreEvents({String? country, String? city, int sortNumberOfDays = 0}):
// This function is used to load more events from a Firestore database by constructing
// a query based on the provided country, city, and sortNumberOfDays. The function concatenates
// the newly fetched events to the existing events list (_eventsAll, _eventsCity, or _eventsCountry)
// and updates the state accordingly.

  Future<List<Event>> _loadMoreEvents({
    String? country,
    String? city,
    required List<DocumentSnapshot> documentSnapshot,
    int sortNumberOfDays = 0,
  }) async {
    final currentDate = DateTime(now.year, now.month, now.day);
    final endDate = currentDate.add(Duration(days: sortNumberOfDays));

    var query = widget.types.isEmpty
        ? allEventsRef
        : allEventsRef.where('type', isEqualTo: widget.types);

    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }

    if (sortNumberOfDays != 0) {
      query = query.where('startDate', isLessThanOrEqualTo: endDate);
    }

    try {
      QuerySnapshot eventFeedSnapShot = await query
          .where('startDate', isGreaterThanOrEqualTo: currentDate)
          .orderBy('startDate', descending: false)
          .startAfterDocument(documentSnapshot.last)
          .limit(2)
          .get();

      List<Event> events =
          eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();

      List<Event> moreEvents = [];

      for (var event in events) {
        if (!addedEventIds.contains(event.id)) {
          addedEventIds.add(event.id);
          moreEvents.add(event);
        }
      }

      documentSnapshot.addAll(eventFeedSnapShot.docs);

      if (mounted) {
        setState(() {
          if (widget.seeMoreFrom.isNotEmpty || widget.liveCity.isNotEmpty) {
            _eventsAll.addAll(moreEvents);
          }
          if (country != null && city != null) {
            _eventsCity.addAll(moreEvents.where((event) => event.city == city));
          }
          if (country != null) {
            _eventsCountry
                .addAll(moreEvents.where((event) => event.country == country));
          }
          if (city == null && country == null) {
            _eventsAll.addAll(moreEvents);
          }
        });
      }

      return moreEvents;
    } catch (e) {
      print('Error loading more events: $e');
      return [];
    }
  }

  // Future<List<Event>> _loadMoreEvents({
  //   String? country,
  //   String? city,
  //   required List<DocumentSnapshot> documentSnapshot,
  //   int sortNumberOfDays = 0,
  // }) async {
  //   // sortNumberOfDays = widget.sortNumberOfDays;
  //   final currentDate = DateTime(now.year, now.month, now.day);
  //   final endDate = currentDate.add(Duration(days: sortNumberOfDays));

  //   var query = widget.types.isEmpty
  //       ? allEventsRef
  //       : allEventsRef.where('type', isEqualTo: widget.types);

  //   if (country != null) {
  //     query = query.where('country', isEqualTo: country);
  //   }
  //   if (city != null) {
  //     query = query.where('city', isEqualTo: city);
  //   }
  // if (sortNumberOfDays != 0) {
  //   query = query.where('startDate', isLessThanOrEqualTo: endDate);
  // }

  //   try {
  //     QuerySnapshot eventFeedSnapShot = await query
  //         // .where('startDate', isGreaterThanOrEqualTo: currentDate)
  //         // .orderBy('startDate', descending: false)
  //         // .orderBy(FieldPath.documentId)
  //         .startAfterDocument(documentSnapshot.last)
  //         .limit(2)
  //         .get();

  //     List<Event> events = eventFeedSnapShot.docs
  //         .map((doc) => Event.fromDoc(doc))
  //         .where((event) => addedEventIds.add(event.id))
  //         .toList();
  //     List<Event> moreEvents = _eventsAll + events;

  //     documentSnapshot.addAll((eventFeedSnapShot.docs));

  //     if (mounted) {
  //       setState(() {
  //         // Add events to respective lists only if they have not been added before.
  //         for (var event in moreEvents) {
  //           if (!addedEventIds.contains(event.id)) {
  //             addedEventIds.add(event.id);
  //             if (widget.seeMoreFrom.isNotEmpty || widget.liveCity.isNotEmpty) {
  //               _eventsAll.add(event);
  //             }
  //             if (country != null && city != null && event.city == city) {
  //               _eventsCity.add(event);
  //             }
  //             if (country != null && event.country == country) {
  //               _eventsCountry.add(event);
  //             }
  //             if (city == null && country == null) {
  //               _eventsAll.add(event);
  //             }
  //           }
  //         }
  //       });
  //     }

  //     return events;
  //   } catch (e) {
  //     print('Error loading more events: $e');
  //     return [];
  //   }
  // }

// This function is used to fetch work requests from
// the Firestore database and updates the _userWorkRequest state.
  Future<List<WorkRequestOrOfferModel>> _setupWorkRequest(String city) async {
    Set<WorkRequestOrOfferModel> posts = {};
    final randomValue = Random().nextDouble();

    if (widget.types.isNotEmpty) {
      Query typeQuery = allWorkRequestRef
          .where('type', arrayContains: widget.types)
          .where('randomId', isGreaterThanOrEqualTo: randomValue);
      QuerySnapshot typeSnapshot = await typeQuery.limit(5).get();
      posts.addAll(typeSnapshot.docs
          .map((doc) => WorkRequestOrOfferModel.fromDoc(doc))
          .toList());

      if (typeSnapshot.docs.length < 5) {
        int remainingLimit = 5 - typeSnapshot.docs.length;
        QuerySnapshot additionalSnapshot = await allWorkRequestRef
            .where('type', arrayContains: widget.types)
            .where('randomId', isLessThan: randomValue)
            .limit(remainingLimit)
            .get();
        typeSnapshot.docs.addAll(additionalSnapshot.docs);
      }
    }

    Query locationQuery = allWorkRequestRef
        .where('availableLocations', arrayContains: city)
        .where('randomId', isGreaterThanOrEqualTo: randomValue);
    QuerySnapshot locationSnapshot = await locationQuery.limit(5).get();
    posts.addAll(locationSnapshot.docs
        .map((doc) => WorkRequestOrOfferModel.fromDoc(doc))
        .toList());

    if (mounted) {
      setState(() {
        _userWorkRequest = posts.toList();
      });
    }

    return posts.toList();
  }

  // _setupWorkRequest(String city) async {
  //   print(city + 'cccccc');
  //   QuerySnapshot postFeedSnapShot = await allWorkRequestRef
  //       .where('type', arrayContains: widget.types)
  //       .where('availableLocations', arrayContains: city)

  //       // .doc(widget.user.id)
  //       // .collection('workRequests')
  //       // .orderBy('timestamp', descending: true)
  //       .limit(5)
  //       .get();
  //   List<WorkRequestOrOfferModel> posts = postFeedSnapShot.docs
  //       .map((doc) => WorkRequestOrOfferModel.fromDoc(doc))
  //       .toList();
  //   // _postSnapshot.addAll((postFeedSnapShot.docs));
  //   if (mounted) {
  //     setState(() {
  //       // _hasNext = false;
  //       _userWorkRequest = posts;
  //     });
  //   }
  // }

// This function is used to fetch work requests
// from the Firestore database and updates the _userWorkRequest state.
  Future<void> _refresh() async {
    addedCityCountryEventIds.clear();
    addedCountryEventIds.clear();
    addedThisWeekEventIds.clear();
    addedFreeEventIds.clear();

    addedEventIds.clear();
    _eventsCity.clear();
    _eventsCountry.clear();
    _eventsAll.clear();
    _eventsThisWeek.clear();
    _eventCitySnapshot.clear();
    _eventCountrySnapshot.clear();
    _eventAllSnapshot.clear();
    _eventFreeSnapshot.clear();
    _eventThisWeekSnapshot.clear();

    _setUp();
  }

// This function returns a NoEventInfoWidget widget which is
// probably displayed when there are no events to display.
  _noEvents() {
    return NoEventInfoWidget(
      isEvent: true,
      liveLocationIntialPage: widget.pageIndex,
      from: '',
      specificType: widget.types,
      liveLocation: widget.liveCity,
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

// This is the main function that Flutter calls to build the widget.
// It uses conditions to decide what to render: _noEvents()
// if there are no events, _buildRefreshIndicator() if there are
// events, or _buildEventAndUserScimmer() in all other cases.

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_feedCount.isNegative) {
      return _noEvents();
    }
    if (_eventsCity.length > 0 ||
        _eventsCountry.length > 0 ||
        _eventsAll.length > 0) {
      return _buildRefreshIndicator();
    }
    return _buildEventAndUserScimmer();
  }

  Widget _buildRefreshIndicator() {
    return RefreshIndicator(
      backgroundColor: Colors.grey[300],
      onRefresh: _refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scrollbar(
          controller: _hideButtonController,
          child: CustomScrollView(
            controller: _hideButtonController,
            slivers: <Widget>[
              EventBuilderWidget(
                liveLocationIntialPage: widget.pageIndex,
                currentUserId: widget.currentUserId,
                eventCitySnapshot: _eventCitySnapshot,
                eventCountrySnapshot: _eventCountrySnapshot,
                eventsCity: _eventsCity,
                eventsCountry: _eventsCountry,
                pageIndex: widget.pageIndex,
                loadMoreSeeAllCity: () {
                  _navigateToPage(
                      context,
                      SeeMore(
                        userLocationSettings: widget.userLocationSettings,
                        currentUserId: widget.currentUserId,
                        liveCity: widget.liveCity,
                        liveCountry: widget.liveCountry,
                        pageIndex: widget.pageIndex,
                        types: widget.types,
                        isEvent: true,
                        isFrom: 'City',
                        sortNumberOfDays: 0,
                      ));
                },
                loadMoreSeeAllCountry: () {
                  _navigateToPage(
                      context,
                      SeeMore(
                        userLocationSettings: widget.userLocationSettings,
                        currentUserId: widget.currentUserId,
                        liveCity: widget.liveCity,
                        liveCountry: widget.liveCountry,
                        pageIndex: widget.pageIndex,
                        types: widget.types,
                        isEvent: true,
                        isFrom: 'Country',
                        sortNumberOfDays: 0,
                      ));
                },
                typeSpecific: widget.types,
                liveLocation: widget.liveCity,
                seeMoreFrom: widget.seeMoreFrom,
                workReQuests: _userWorkRequest,
                sortNumberOfDays: widget.sortNumberOfDays,
                eventFree: _eventFree,
                eventsThisWeek: _eventsThisWeek,
                eventFreeSnapshot: _eventFreeSnapshot,
                eventThisWeekSnapshot: _eventThisWeekSnapshot,
                eventsFollowingSnapshot: _eventFollowingSnapshot,
                eventsFollowing: _eventFollowing,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Event event = _eventsAll[index];
                    return EventDisplayWidget(
                      currentUserId: widget.currentUserId,
                      event: event,
                      eventList: _eventsAll,
                      eventSnapshot: _eventAllSnapshot,
                      pageIndex: widget.pageIndex,
                      eventPagesOnly: false,
                      liveCity: widget.liveCity,
                      liveCountry: widget.liveCountry,
                      sortNumberOfDays: widget.sortNumberOfDays,
                      isFrom: widget.isFrom,
                    );
                  },
                  childCount: _eventsAll.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventAndUserScimmer() {
    return Center(
      child: EventAndUserScimmer(
        from: 'Event',
        showWithoutSegment:
            widget.liveCity.isNotEmpty || widget.seeMoreFrom.isNotEmpty
                ? true
                : false,
      ),
    );
  }
}
