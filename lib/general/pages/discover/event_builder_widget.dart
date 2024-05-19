import 'package:bars/general/pages/discover/this_week_event.dart';
import 'package:bars/utilities/exports.dart';

class EventBuilderWidget extends StatelessWidget {
  final List<Event> eventsCity;
  final List<Event> eventsFollowing;
  final List<Event> eventsThisWeek;
  final List<Event> eventFree;
  final List<DocumentSnapshot> eventsFollowingSnapshot;

  final List<DocumentSnapshot> eventCitySnapshot;
  final List<DocumentSnapshot> eventFreeSnapshot;

  final List<DocumentSnapshot> eventThisWeekSnapshot;
  final List<Event> eventsCountry;
  final List<DocumentSnapshot> eventCountrySnapshot;
  final int pageIndex; //
  final String currentUserId; // artist, producer or festivals, others
  final VoidCallback loadMoreSeeAllCountry;
  final VoidCallback loadMoreSeeAllCity;
  final String typeSpecific; // artist, producer or festivals, others
  final String liveLocation;
  final int liveLocationIntialPage;
  final String seeMoreFrom;
  final List<WorkRequestOrOfferModel> workReQuests;
  final int sortNumberOfDays;

  EventBuilderWidget({
    super.key,
    required this.pageIndex,
    required this.currentUserId,
    required this.eventsCity,
    required this.eventCitySnapshot,
    required this.eventsCountry,
    required this.eventCountrySnapshot,
    required this.loadMoreSeeAllCountry,
    required this.loadMoreSeeAllCity,
    required this.typeSpecific,
    required this.liveLocation,
    required this.liveLocationIntialPage,
    required this.seeMoreFrom,
    required this.workReQuests,
    required this.sortNumberOfDays,
    required this.eventsThisWeek,
    required this.eventFree,
    required this.eventFreeSnapshot,
    required this.eventThisWeekSnapshot,
    required this.eventsFollowing,
    required this.eventsFollowingSnapshot,
  });

  _discoverBuilder(
    List<Event> eventList,
    List<DocumentSnapshot> eventSnapshot,
    String locationCategory,
    VoidCallback loadMore,
    String typeSpecific,
    String isFromCityOrCountry,
  ) {
    return DiscoverCategoryWidget(
      currentUserId: currentUserId,
      locationCategory: locationCategory,
      type: isFromCityOrCountry.startsWith('Following') ? 'Following' : 'Event',
      typeSpecific: typeSpecific,
      pageIndex: pageIndex,
      usersSnapshot: [],
      usersList: [],
      eventsList: eventList,
      eventsSnapshot: eventSnapshot,
      postsList: [],
      postsSnapshot: [],
      loadMoreSeeAll: loadMore,
      isFrom: isFromCityOrCountry,
      sortNumberOfDays: sortNumberOfDays,
    );
  }

  _performanceRequest(BuildContext context,
      UserSettingsLoadingPreferenceModel user, String typeSpecific) {
    final width = MediaQuery.of(context).size.width;

    var list = workReQuests.length;

    var baseHeight = ResponsiveHelper.responsiveHeight(
        context, 200.0); // Height of one item in the list
    var additionalHeight = ResponsiveHelper.responsiveHeight(context, 150.0);
    // Additional height per item in the list for list sizes greater than 1

    num height2 = (list > 0) ? baseHeight + (list - 1) * additionalHeight : 0;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: height2.toDouble(),
        width: width,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(.3),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            ListTile(
              title: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Available now!",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    TextSpan(
                      text:
                          '\nThe following creatives are ready to offer their services in ${user.city!} for $typeSpecific, at their specified rates."',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              ),
            ),
            Divider( thickness: .2,),
            PortfolioWorkRequestWidget(
              edit: false,
              seeMore: false,
              workReQuests: workReQuests,
              onTapToGoTODiscovery: true,
            ),
          ],
        ),
      ),
    );
  }

  _sliverListEvent(
    BuildContext context,
    bool isFree,
  ) {
    List<Event> currentEventList = isFree ? eventFree : eventsThisWeek;
    List<DocumentSnapshot> currentEventSnapShot =
        isFree ? eventFreeSnapshot : eventThisWeekSnapshot;
    var _provider = Provider.of<UserData>(context, listen: false);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == currentEventList.length) {
            // Return additional container here
            return currentEventList.length < 10
                ? SizedBox.shrink()
                : isFree
                    ? SizedBox.shrink()
                    : GestureDetector(
                        onTap: () {
                          _navigateToPage(
                              context,
                              SeeMore(
                                userLocationSettings:
                                    _provider.userLocationPreference!,
                                currentUserId: currentUserId,
                                liveCity: '',
                                liveCountry: '',
                                pageIndex: pageIndex,
                                types: typeSpecific,
                                isEvent: true,
                                isFrom: '',
                                sortNumberOfDays: 7,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: ResponsiveHelper.responsiveHeight(
                              context,
                              600,
                            ),
                            width: ResponsiveHelper.responsiveHeight(
                              context,
                              300,
                            ),
                            color: Colors.blue,
                            // decoration: BoxDecoration(
                            //     color: Theme.of(context).cardColor, shape: BoxShape.circle),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      // color: Colors.blue,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.white,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  'See more',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 14.0),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
          }

          Event event = currentEventList[index];

          return ThisWeekEvent(
            event: event,
            currentEventList: currentEventList,
            currentEventSnapShot: currentEventSnapShot,
            sortNumberOfDays: sortNumberOfDays,
          );
        },
        childCount: currentEventList.length + 1,
      ),
    );
  }

  _buildLoading(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: SchimmerSkeleton(
        schimmerWidget: Container(
          height: ResponsiveHelper.responsiveHeight(context, 450),
          width: ResponsiveHelper.responsiveHeight(context, width),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ]),
            //
          ),
        ),
      ),
    );
  }

  _thisWeekEvents(BuildContext context, bool isFree,
      UserSettingsLoadingPreferenceModel user, String typeSpecific) {
    List<Event> currentEventList = isFree ? eventFree : eventsThisWeek;
    var _provider = Provider.of<UserData>(
      context,
    );

    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 40,
        ),
        currentEventList.isEmpty
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: isFree
                              ? "Free ${typeSpecific.toLowerCase()}\nin ${user.country!.isEmpty ? 'your country' : user.country}"
                              : typeSpecific.endsWith('events')
                                  ? "All events\nHappening\nthis week "
                                  : "$typeSpecific\nHappening\nthis week ",
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontWeight: FontWeight.w400,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 30.0),
                          )),
                      TextSpan(
                        text: isFree
                            ? '\nDiscover free ${typeSpecific.toLowerCase()} happening in ${user.country!.isEmpty ? 'your country' : user.country} and make unforgettable memories. Join the excitement and experience the vibrant culture firsthand.'
                            : '\nLet\'s create unforgettable memories and forge lifelong friendships. Explore, attend, and experience every moment of the exciting ${typeSpecific.toLowerCase()} awaiting you this week',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                ),
              ),
        const SizedBox(
          height: 10,
        ),
        _provider.loadingThisWeekEvent
            ? _buildLoading(context)
            : currentEventList.length < 1
                ? Container(
                    height: ResponsiveHelper.responsiveHeight(context, 200),
                    width: ResponsiveHelper.responsiveHeight(context, width),
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: NoContents(
                          title: isFree
                              ? 'Free ${typeSpecific.toLowerCase()} in ${user.country}'
                              : '${typeSpecific.toLowerCase()} This week',
                          subTitle: isFree
                              ? 'There are no free  ${typeSpecific.toLowerCase()} in ${user.country} at the moment. We would keep you updated if new ${typeSpecific.toLowerCase()} become available.'
                              : 'There are no ${typeSpecific.toLowerCase()} in ${user.country} at the moment. We would keep you updated if new ${typeSpecific.toLowerCase()} become available.',
                          icon: FontAwesomeIcons.zero),
                    ))
                : Container(
                    height: ResponsiveHelper.responsiveHeight(context, 450),
                    width: ResponsiveHelper.responsiveHeight(context, width),
                    color: Theme.of(context).primaryColor,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      slivers: [_sliverListEvent(context, isFree)],
                    )),
      ],
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _weeks(
    BuildContext context,
  ) {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;
    return Column(
      children: [
        Table(
          border: TableBorder.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
          children: [
            TableRow(children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _navigateToPage(
                      context,
                      DiscoverEventScreen(
                        currentUserId: currentUserId,
                        userLocationSettings: _userLocationSettings!,
                        isLiveLocation: true,
                        liveCity: '',
                        liveCountry: '',
                        liveLocationIntialPage: liveLocationIntialPage,
                        sortNumberOfDays: 1,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20),
                  child: Text(
                    'Tonight',
                    style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _navigateToPage(
                      context,
                      DiscoverEventScreen(
                        currentUserId: currentUserId,
                        userLocationSettings: _userLocationSettings!,
                        isLiveLocation: true,
                        liveCity: '',
                        liveCountry: '',
                        liveLocationIntialPage: liveLocationIntialPage,
                        sortNumberOfDays: 1,
                      ));
                },
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _navigateToPage(
                        context,
                        DiscoverEventScreen(
                          currentUserId: currentUserId,
                          userLocationSettings: _userLocationSettings!,
                          isLiveLocation: true,
                          liveCity: '',
                          liveCountry: '',
                          liveLocationIntialPage: liveLocationIntialPage,
                          sortNumberOfDays: 2,
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20),
                    child: Text(
                      'Tomorrow',
                      style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ]),
            TableRow(children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _navigateToPage(
                      context,
                      DiscoverEventScreen(
                        currentUserId: currentUserId,
                        userLocationSettings: _userLocationSettings!,
                        isLiveLocation: true,
                        liveCity: '',
                        liveCountry: '',
                        liveLocationIntialPage: liveLocationIntialPage,
                        sortNumberOfDays: 7,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20),
                  child: Text(
                    'in 7 days',
                    style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _navigateToPage(
                      context,
                      DiscoverEventScreen(
                        currentUserId: currentUserId,
                        userLocationSettings: _userLocationSettings!,
                        isLiveLocation: true,
                        liveCity: '',
                        liveCountry: '',
                        liveLocationIntialPage: liveLocationIntialPage,
                        sortNumberOfDays: 14,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20),
                  child: Text(
                    'in 14 days',
                    style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ])
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;
    int _tab = pageIndex;
    String _typeSpecific = _tab == 0
        ? ' events'
        : _tab == 1
            ? 'Parties'
            : _tab == 2
                ? 'Music_concerts'
                : _tab == 3
                    ? 'Festivals'
                    : _tab == 4
                        ? 'Club_nights'
                        : _tab == 5
                            ? 'Pub_events'
                            : _tab == 6
                                ? 'Games/Sports'
                                : _tab == 7
                                    ? 'Religious'
                                    : _tab == 8
                                        ? 'Business'
                                        : _tab == 9
                                            ? 'Others'
                                            : '';
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 1,
            color: Theme.of(context).primaryColor,
          ),
          if (liveLocation.isEmpty && seeMoreFrom.isEmpty)
            NoEventInfoWidget(
              from: 'Location',
              specificType: typeSpecific,
              liveLocation: liveLocation,
              liveLocationIntialPage: liveLocationIntialPage,
              isEvent: true,
            ),
          if (liveLocation.isEmpty)
            if (sortNumberOfDays == 0 && seeMoreFrom.isEmpty) _weeks(context),
          if (_userLocationSettings!.city!.isEmpty && liveLocation.isEmpty)
            CategoryContainerEmpty(
              containerSubTitle:
                  'Enter your city, country, and continent to unlock a world of events happening around you.\n',
              containerTitle: 'Please set up your location to get started',
              noLocation: true,
              height: 100,
              liveLocation: false,
              liveLocationIntialPage: liveLocationIntialPage,
              isEvent: true,
            ),
          if (sortNumberOfDays == 0 && seeMoreFrom.isEmpty)
            _thisWeekEvents(
                context, false, _userLocationSettings, _typeSpecific),
          if (liveLocation.isEmpty)
            if (sortNumberOfDays == 0 && seeMoreFrom.isEmpty)
              eventsFollowing.length == 0
                  ? NoEventInfoWidget(
                      from: 'by people you follow',
                      specificType: typeSpecific,
                      liveLocation: liveLocation,
                      liveLocationIntialPage: liveLocationIntialPage,
                      isEvent: true,
                    )
                  : _discoverBuilder(
                      eventsFollowing,
                      eventsFollowingSnapshot,
                      _userLocationSettings.city!,
                      loadMoreSeeAllCity,
                      _typeSpecific,
                      'Following',
                    ),
          if (sortNumberOfDays == 0 && seeMoreFrom.isEmpty)
            const SizedBox(
              height: 40,
            ),
          if (_userLocationSettings.city!.isNotEmpty && liveLocation.isEmpty)
            seeMoreFrom.isNotEmpty
                ? SizedBox.shrink()
                : eventsCity.length == 0
                    ? NoEventInfoWidget(
                        from: _userLocationSettings.city!,
                        specificType: typeSpecific,
                        liveLocation: liveLocation,
                        liveLocationIntialPage: liveLocationIntialPage,
                        isEvent: true,
                      )
                    : _discoverBuilder(
                        eventsCity,
                        eventCitySnapshot,
                        _userLocationSettings.city!,
                        loadMoreSeeAllCity,
                        _typeSpecific,
                        'City',
                      ),
          if (sortNumberOfDays == 0 && seeMoreFrom.isEmpty)
            const SizedBox(
              height: 40,
            ),
          if (_userLocationSettings.country!.isNotEmpty && liveLocation.isEmpty)
            seeMoreFrom.isNotEmpty
                ? SizedBox.shrink()
                : eventsCountry.length == 0
                    ? NoEventInfoWidget(
                        from: _userLocationSettings.country!,
                        specificType: typeSpecific,
                        liveLocation: liveLocation,
                        liveLocationIntialPage: liveLocationIntialPage,
                        isEvent: true,
                      )
                    : _discoverBuilder(
                        eventsCountry,
                        eventCountrySnapshot,
                        _userLocationSettings.country!,
                        loadMoreSeeAllCountry,
                        _typeSpecific,
                        'Country'),
          if (sortNumberOfDays == 0 && seeMoreFrom.isEmpty)
            _performanceRequest(context, _userLocationSettings, _typeSpecific),
          if (sortNumberOfDays == 0 && seeMoreFrom.isEmpty)
            _thisWeekEvents(
                context, true, _userLocationSettings, _typeSpecific),
          if (sortNumberOfDays == 0 && seeMoreFrom.isEmpty)
            AroundTheWorldWidget(),
        ],
      ),
    );
  }
}
