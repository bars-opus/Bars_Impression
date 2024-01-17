import 'dart:math';

import 'package:bars/utilities/exports.dart';

//These code has been tested for  better performance and potential bug prevention:
//14th August 2023 : 11:07pm
//Author: Harold Enam Kwaku Fianu (CEO BARS OPUS LTD)

class CreativesScreen extends StatefulWidget {
  static final id = 'CreativesScreen';
  final String currentUserId;
  // final String exploreLocation;
  final String profileHandle;
  final int pageIndex;
  final UserSettingsLoadingPreferenceModel userLocationSettings;
  final String liveCity;
  final String liveCountry;
  final String seeMoreFrom;
  final String isFrom;

  CreativesScreen({
    required this.currentUserId,
    // required this.exploreLocation,
    required this.profileHandle,
    required this.pageIndex,
    required this.userLocationSettings,
    required this.liveCity,
    required this.liveCountry,
    required this.seeMoreFrom,
    required this.isFrom,
  });
  @override
  _CreativesScreenState createState() => _CreativesScreenState();
}

class _CreativesScreenState extends State<CreativesScreen>
    with AutomaticKeepAliveClientMixin {
  List<UserProfessionalModel> _usersCity = [];
  List<UserProfessionalModel> _usersCountry = [];
  List<UserProfessionalModel> _usersContinent = [];
  List<UserProfessionalModel> _usersAll = [];
  final _usersCitySnapshot = <DocumentSnapshot>[];
  final _usersCountrySnapshot = <DocumentSnapshot>[];
  final _usersContinentSnapshot = <DocumentSnapshot>[];
  final _usersAllSnapshot = <DocumentSnapshot>[];
  List<Post> _posts = [];
  final _postSnapshot = <DocumentSnapshot>[];

  int limit = 10;

  bool _hasNext = true;
  // bool _isFectchingUser = false;
  late ScrollController _hideButtonController;
  // String _subtitle = '';
  int _feedCount = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _setUp();
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        Provider.of<UserData>(context, listen: false).setShowUsersTab(false);
      }
    });
  }

  _setUp() {
    _setUpFeedCount();

    widget.seeMoreFrom.isNotEmpty
        ? _setUpFeedSeeMore()
        : widget.liveCity.isNotEmpty
            ? _setUpFeedLive()
            : _setUpFeed();
  }

  _setUpFeedCount() async {
    print(widget.liveCountry);
    int feedCount = widget.liveCity.isNotEmpty
        ? await DatabaseService.numusersLiveLocation(
            widget.profileHandle, widget.liveCity, widget.liveCountry)
        : await DatabaseService.numUsersAll(
            widget.profileHandle,
          );
    if (mounted) {
      setState(() {
        _feedCount = feedCount;
      });
    }
  }

  _setUpFeed() {
    String? city = widget.userLocationSettings.city;
    bool? isAll = false;
    String? country = widget.userLocationSettings.country;
    String? continent = widget.userLocationSettings.continent;

    _setupUsers(
        city: city, country: country, isAll: isAll, from: 'City'); // For city
    _setupUsers(country: country, isAll: isAll, from: 'Country'); // For country
    _setupUsers(
        continent: continent, isAll: isAll, from: 'Continent'); // For country
    _setupUsers(isAll: true, from: ''); // For all
  }

  _setUpFeedLive() {
    //   liveCity: widget.liveCity, liveCountry: widget.liveCountry
    // String? city = widget.userLocationSettings.city;
    // String? country = widget.userLocationSettings.country;
    _setupUsers(
        city: widget.liveCity,
        country: widget.liveCountry,
        isAll: true,
        from: 'City');

    // _setupEvents(); // For all
  }

  _setUpFeedSeeMore() {
    String? city = widget.userLocationSettings.city;
    String? country = widget.userLocationSettings.country;
    String? continent = widget.userLocationSettings.continent;
    widget.seeMoreFrom.startsWith('City')
        ? _setupUsers(city: city, country: country, isAll: true, from: 'City')
        : widget.seeMoreFrom.startsWith('Country')
            ? _setupUsers(country: country, isAll: true, from: 'Country')
            : _setupUsers(
                continent: continent,
                isAll: true,
                from: 'Continent'); // For country
    // _setupEvents(); // For all
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  Set<String> addedUserIds = Set<String>();

  Set<String> addedCityCountryUserIds = Set<String>();
  // Set<String> addedCountryUserIds = Set<String>();

  Future<List<UserProfessionalModel>> _setupUsers({
    String? city,
    String? country,
    String? continent,
    required bool isAll,
    required String from,
  }) async {
    int newLimit = widget.seeMoreFrom.isNotEmpty ? 15 : limit;

    var query = userProfessionalRef.where('profileHandle',
        isEqualTo: widget.profileHandle);

    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }

    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }
    if (continent != null) {
      query = query.where('continent', isEqualTo: continent);
    }

    final randomValue = Random().nextDouble();

    // Now order by randomId
    query = query.orderBy('randomId');
    try {
      QuerySnapshot userFeedSnapShot = await query
          .where('randomId', isGreaterThanOrEqualTo: randomValue)
          .limit(newLimit)
          .get();

      if (userFeedSnapShot.docs.length < newLimit) {
        int remainingLimit = newLimit - userFeedSnapShot.docs.length;
        QuerySnapshot additionalSnapshot = await query
            .where('randomId', isLessThan: randomValue)
            .limit(remainingLimit)
            .get();
        userFeedSnapShot.docs.addAll(additionalSnapshot.docs);
      }

      List<UserProfessionalModel> users = userFeedSnapShot.docs
          .map((doc) => UserProfessionalModel.fromDoc(doc))
          .toList();

      List<UserProfessionalModel> uniqueEvents = [];
      if (from.startsWith('City')) {
        for (var event in users) {
          if (addedCityCountryUserIds.add(event.id)) {
            uniqueEvents.add(event);
          }
        }
      } else if (from.startsWith('Country')) {
        for (var event in users) {
          if (addedCityCountryUserIds.add(event.id)) {
            uniqueEvents.add(event);
          }
        }
      } else if (from.startsWith('Continent')) {
        for (var event in users) {
          if (addedCityCountryUserIds.add(event.id)) {
            uniqueEvents.add(event);
          }
        }
      } else {
        for (var event in users) {
          if (addedUserIds.add(event.id)) {
            uniqueEvents.add(event);
          }
        }
      }

      List<UserProfessionalModel>? newUsersCity;
      List<UserProfessionalModel>? newUsersCountry;
      List<UserProfessionalModel>? newUsersContinent;
      List<UserProfessionalModel>? newUsersAll;

      if (from.startsWith('Country')) {
        _usersCountrySnapshot.addAll((userFeedSnapShot.docs));
      }
      if (from.startsWith('City')) {
        _usersCitySnapshot.addAll((userFeedSnapShot.docs));
      }
      if (from.startsWith('Continent')) {
        _usersContinentSnapshot.addAll((userFeedSnapShot.docs));
      }
      if (isAll) {
        _usersAllSnapshot.addAll((userFeedSnapShot.docs));
      }

      if (widget.seeMoreFrom.isNotEmpty || widget.liveCity.isNotEmpty) {
        newUsersAll = uniqueEvents;
        print(newUsersAll.length.toString() + 'length');
      } else {
        if (country != null && city != null) {
          newUsersCity = uniqueEvents;
        } else if (country != null) {
          newUsersCountry = uniqueEvents;
        } else if (continent != null) {
          newUsersContinent = uniqueEvents;
        } else {
          newUsersAll = uniqueEvents;
        }
      }

      if (mounted) {
        setState(() {
          _usersCity = newUsersCity ?? _usersCity;
          _usersCountry = newUsersCountry ?? _usersCountry;
          _usersContinent = newUsersContinent ?? _usersContinent;
          _usersAll = newUsersAll ?? _usersAll;
        });
      }

      return users;
    } catch (e) {
      _showBottomSheetErrorMessage();
      // Consider what you want to do in case of error. Here, we return an empty list
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
          title: 'Failed to fetch creatives.',
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        // bool? isAll = widget.liveCity.isNotEmpty ? true : false;
        String? city = widget.liveCity.isEmpty
            ? widget.userLocationSettings.city
            : widget.liveCity;
        String? country = widget.liveCountry.isEmpty
            ? widget.userLocationSettings.country
            : widget.liveCountry;

        String? continent = widget.userLocationSettings.continent;
        widget.liveCity.isNotEmpty
            ? _loadMoreUsers(
                city: city,
                country: country,
              )
            : widget.seeMoreFrom.startsWith('City')
                ? _loadMoreUsers(
                    city: city,
                    country: country,
                  )
                : widget.seeMoreFrom.startsWith('Country')
                    ? _loadMoreUsers(
                        country: country,
                      )
                    : widget.seeMoreFrom.startsWith('Continent')
                        ? _loadMoreUsers(
                            continent: continent,
                          )
                        : _loadMoreUsers();
      }
    }
    return false;
  }

  Future<List<UserProfessionalModel>> _loadMoreUsers({
    // DocumentSnapshot? startAfterDocument,
    String? country,
    String? city,
    String? continent,
  }) async {
    try {
      var query = userProfessionalRef.where('profileHandle',
          isEqualTo: widget.profileHandle);

      if (country != null) {
        query = query.where('country', isEqualTo: country);
      }
      if (city != null) {
        query = query.where('city', isEqualTo: city);
      }
      if (continent != null) {
        query = query.where('continent', isEqualTo: continent);
      }

      final randomValue = Random().nextDouble();
      query = query.orderBy('randomId');

      // Apply the inequality filter after the orderBy
      query = query.where('randomId', isGreaterThanOrEqualTo: randomValue);

      QuerySnapshot userFeedSnapShot =
          await query.startAfterDocument(_usersAllSnapshot.last).limit(2).get();

      // If you didn't get enough documents, query in the other direction
      if (userFeedSnapShot.docs.length < 5) {
        int remainingLimit = 5 - userFeedSnapShot.docs.length;

        // Make an additional query to get more documents
        QuerySnapshot additionalSnapshot = await userProfessionalRef
            .where('profileHandle', isEqualTo: widget.profileHandle)
            .orderBy('randomId') // Order by must be the same as the first query
            .where('randomId', isLessThan: randomValue)
            .limit(remainingLimit)
            .get();

        // Combine the two lists of documents
        userFeedSnapShot.docs.addAll(additionalSnapshot.docs);
      }

      List<UserProfessionalModel> users = userFeedSnapShot.docs
          .map((doc) => UserProfessionalModel.fromDoc(doc))
          .toList();

      List<UserProfessionalModel> moreUsers = [];

      for (var user in users) {
        if (!addedUserIds.contains(user.id)) {
          addedUserIds.add(user.id);
          moreUsers.add(user);
        }
      }

      // Add new snapshots to existing list
      _usersAllSnapshot.addAll(userFeedSnapShot.docs);

      if (mounted) {
        setState(() {
          if (widget.seeMoreFrom.isNotEmpty || widget.liveCity.isNotEmpty) {
            _usersAll += moreUsers;
          } else if (country != null && city != null) {
            _usersCity += moreUsers;
          } else if (country != null) {
            _usersCountry += moreUsers;
          } else if (continent != null) {
            _usersContinent += moreUsers;
          } else {
            _usersAll += moreUsers;
          }
        });
      }

      return moreUsers;
    } catch (e) {
      // print('Error loading more events: $e');
      // Consider what you want to do in case of error. Here, we return an empty list
      return [];
    }
  }

//

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _userBuilder(
    List<UserProfessionalModel> usersList,
    List<DocumentSnapshot> usersSnapshot,
    String locationCategory,
    VoidCallback loadMore,
  ) {
    return DiscoverCategoryWidget(
      currentUserId: widget.currentUserId,
      locationCategory: locationCategory,
      type: 'User',
      typeSpecific: widget.profileHandle,
      pageIndex: widget.pageIndex,
      usersSnapshot: usersSnapshot,
      usersList: usersList,
      eventsList: [],
      eventsSnapshot: [],
      postsList: [],
      postsSnapshot: [],
      loadMoreSeeAll: loadMore,
      isFrom: widget.seeMoreFrom,
      sortNumberOfDays: 0,
    );
  }

  Future<void> _refresh() async {
    addedCityCountryUserIds.clear();
    addedUserIds.clear();

    _setUp();
    // _setupUsers(
    //     city: widget.userLocationSettings.city, country: widget.userLocationSettings.country); // For city

    // _setupUsers(country: widget.userLocationSettings.country); // For country
    // _setupUsers(continent: widget.userLocationSettings.continent); // For country
    // _setupUsers();

    // _setupPosts();
  }

  _userFan(UserProfessionalModel user) {
    var _provider = Provider.of<UserData>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        // color: Theme.of(context).cardColor,
        child: ListTile(
          leading: user.profileImageUrl.isEmpty
              ? Icon(
                  Icons.account_circle,
                  size: ResponsiveHelper.responsiveHeight(context, 50.0),
                  color: Colors.grey,
                )
              : CircleAvatar(
                  radius: ResponsiveHelper.responsiveHeight(context, 25.0),
                  backgroundColor: Colors.blue,
                  backgroundImage:
                      CachedNetworkImageProvider(user.profileImageUrl),
                ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              NameText(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                name: user.userName.toUpperCase().trim().replaceAll('\n', ' '),
                verified: user.verified,
              ),
              RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(children: [
                    TextSpan(
                        text: user.profileHandle,
                        style: TextStyle(
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 10),
                          color: Colors.blue,
                        )),
                  ])),
              SizedBox(
                height: 5.0,
              ),
              // RichText(
              //     textScaleFactor: MediaQuery.of(context).textScaleFactor,
              //     text: TextSpan(children: [
              //       TextSpan(
              //         text: 'bio: ',
              //         style: TextStyle(
              //           fontSize:
              //               ResponsiveHelper.responsiveFontSize(context, 12),
              //           color: Colors.grey,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       TextSpan(
              //         text: user,
              //         style: TextStyle(
              //           fontSize:
              //               ResponsiveHelper.responsiveFontSize(context, 12),
              //           color: Colors.grey,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ])),
            ],
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        user: null,
                        currentUserId: _provider.currentUserId!,
                        userId: user.id,
                      ))),
        ),
      ),
    );
  }

  Widget _buildBody2() {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    // final AccountHolder _user =
    //     Provider.of<UserData>(context, listen: false).user!;
    final userCity = _userLocationSettings!.city;
    final userCountry = _userLocationSettings.country;
    final userContinent = _userLocationSettings.continent;
    final hasCity = userCity!.isNotEmpty;
    final hasCountry = userCountry!.isNotEmpty;
    final hasContinent = userContinent!.isNotEmpty;

    return widget.seeMoreFrom.isNotEmpty || widget.liveCity.isNotEmpty
        ? NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: Scrollbar(
              controller: _hideButtonController,
              child: CustomScrollView(
                controller: _hideButtonController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const Divider(
                          thickness: .1,
                          color: Colors.black, // replace with your color
                        ),
                        widget.liveCity.isNotEmpty
                            ? const SizedBox.shrink()
                            : NoEventInfoWidget(
                                from: 'Location',
                                specificType: widget.profileHandle,
                                liveLocation: widget.liveCity,
                                liveLocationIntialPage: widget.pageIndex,
                                isEvent: false,
                              ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        UserProfessionalModel userProfessional =
                            _usersAll[index];
                        return UserView(
                          userSnapshot: _usersAllSnapshot,
                          userList: _usersAll,
                          currentUserId: widget.currentUserId,
                          userProfessional: userProfessional,
                          pageIndex: widget.pageIndex,
                          liveCity: widget.liveCity,
                          liveCountry: widget.liveCountry,
                          isFrom: widget.isFrom,
                        );
                      },
                      childCount: _usersAll.length,
                    ),
                  ),
                ],
              ),
            ),
          )
        : NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: Scrollbar(
              controller: _hideButtonController,
              child: CustomScrollView(
                controller: _hideButtonController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          thickness: .1,
                          color: Colors.black, // replace with your color
                        ),
                        if (widget.liveCity.isEmpty)
                          NoEventInfoWidget(
                            from: 'Location',
                            specificType: widget.profileHandle,
                            liveLocation: widget.liveCity,
                            liveLocationIntialPage: widget.pageIndex,
                            isEvent: false,
                          ),
                        if (widget.liveCity.isEmpty)
                          const Divider(
                            thickness: .1,
                            color: Colors.black, // replace with your color
                          ),
                        if (!hasCity)
                          _userLocationSettings.city!.isEmpty &&
                                  widget.liveCity.isEmpty
                              ? CategoryContainerEmpty(
                                  liveLocationIntialPage: widget.pageIndex,
                                  containerSubTitle:
                                      'Enter your city, and countryto unlock a world of ${widget.profileHandle.toLowerCase()}\'s living around you.\n',
                                  containerTitle:
                                      'Please set up your location to get started',
                                  noLocation: true,
                                  height: 100,
                                  liveLocation: false,
                                  isEvent: false,
                                )
                              : const SizedBox.shrink(),
                        if (hasCity)
                          _usersCity.length == 0
                              ? _noUsers()
                              : _userBuilder(
                                  _usersCity, _usersCitySnapshot, userCity, () {
                                  _navigateToPage(
                                      context,
                                      SeeMore(
                                        userLocationSettings:
                                            widget.userLocationSettings,
                                        // profileHandle: _profileHandle,
                                        currentUserId: widget.currentUserId,
                                        liveCity: widget.liveCity,
                                        liveCountry: widget.liveCountry,
                                        pageIndex: widget.pageIndex,
                                        types: widget.profileHandle,
                                        // seeMoreFrom: 'City',
                                        isEvent: false, isFrom: 'City',sortNumberOfDays: 0,
                                      ));
                                }),
                        if (hasCountry && _usersCountry.isNotEmpty)
                          _usersCountry.length == 0
                              ? _noUsers()
                              : _userBuilder(_usersCountry,
                                  _usersCountrySnapshot, userCountry, () {
                                  _navigateToPage(
                                      context,
                                      SeeMore(
                                        userLocationSettings:
                                            widget.userLocationSettings,
                                        currentUserId: widget.currentUserId,
                                        liveCity: widget.liveCity,
                                        liveCountry: widget.liveCountry,
                                        pageIndex: widget.pageIndex,
                                        types: widget.profileHandle,
                                        isEvent: false,
                                        isFrom: 'Country', sortNumberOfDays: 0,
                                      ));
                                }),
                        if (hasContinent && _usersContinent.isNotEmpty)
                          _usersContinent.length == 0
                              ? _noUsers()
                              : _userBuilder(_usersContinent,
                                  _usersContinentSnapshot, userContinent, () {
                                  _navigateToPage(
                                      context,
                                      SeeMore(
                                        userLocationSettings:
                                            widget.userLocationSettings,
                                        currentUserId: widget.currentUserId,
                                        liveCity: widget.liveCity,
                                        liveCountry: widget.liveCountry,
                                        pageIndex: widget.pageIndex,
                                        types: widget.profileHandle,
                                        isEvent: false,
                                        isFrom: 'Continent',sortNumberOfDays: 0,
                                      ));
                                }),
                        AroundTheWorldWidget(),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        UserProfessionalModel user = _usersAll[index];
                        return widget.profileHandle == 'Fan'
                            ? _userFan(user)
                            : UserView(
                                userSnapshot: _usersAllSnapshot,
                                userList: _usersAll,
                                currentUserId: widget.currentUserId,
                                userProfessional: user,
                                pageIndex: widget.pageIndex,
                                liveCity: '',
                                liveCountry: '',
                                isFrom: '',
                              );
                      },
                      childCount: _usersAll.length,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _noUsers() {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    // final AccountHolder _user =
    //     Provider.of<UserData>(context, listen: false).user!;
    bool _isLive = widget.liveCity.isNotEmpty ? true : false;
    String from = '';

    if (_usersCity.isEmpty) {
      from = _isLive ? widget.liveCity : _userLocationSettings!.city!;
    }
    if (_usersCountry.isEmpty) {
      from = _isLive ? widget.liveCountry : _userLocationSettings!.country!;
    }
    if (_usersContinent.isEmpty) {
      from = _userLocationSettings!.continent!;
    }
    if (_usersAll.isEmpty) {
      from = '';
    } // No need for else if (_eventsAll.isEmpty) because from is already ''.

    return NoEventInfoWidget(
      isEvent: true,
      liveLocationIntialPage: widget.pageIndex,
      from: from,
      specificType: widget.profileHandle,
      liveLocation: widget.liveCity,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _feedCount.isNegative
        ? _noUsers()
        : _usersCity.length > 0 ||
                _usersCountry.length > 0 ||
                _usersContinent.length > 0 ||
                _usersAll.length > 0
            ? RefreshIndicator(
                backgroundColor: Colors.grey[300],
                onRefresh: _refresh,
                child: _buildBody2())
            : Center(
                child: EventAndUserScimmer(
                  from: 'User',
                  showWithoutSegment: widget.liveCity.isNotEmpty ||
                          widget.seeMoreFrom.isNotEmpty
                      ? true
                      : false,
                ),
              );
  }
}
