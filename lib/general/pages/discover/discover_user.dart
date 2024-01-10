import 'package:bars/utilities/exports.dart';

//These code has been tested for  better performance and potential bug prevention:
//15th August 2023  5:17
//Author: Harold Enam Kwaku Fianu (CEO BARS OPUS LTD)

class DiscoverUser extends StatefulWidget {
  final String currentUserId;
  final bool isWelcome;
  final bool isLiveLocation;
  final String liveCity;
  final String liveCountry;
  final int liveLocationIntialPage;

  static final id = 'DiscoverUser';

  DiscoverUser({
    required this.currentUserId,
    required this.isWelcome,
    required this.isLiveLocation,
    required this.liveCity,
    required this.liveCountry,
    required this.liveLocationIntialPage,
  });

  @override
  _DiscoverUserState createState() => _DiscoverUserState();
}

class _DiscoverUserState extends State<DiscoverUser>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  // final FocusNode _focusNode = FocusNode();
  int _currentPage = 0;

  // late PageController _pageController;
  // TextEditingController _searchController = TextEditingController();
  // ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  // String query = "";
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 20, initialIndex: widget.liveLocationIntialPage, vsync: this);
    _tabController.addListener(() {
      // Check if the animation is completed. This indicates that tab has fully changed
      if (!_tabController.indexIsChanging) {
        // Generate a light haptic feedback
        HapticFeedback.mediumImpact();
      }
    });
    // _searchController.addListener(_onAskTextChanged);
    // _pageController = PageController(
    //   initialPage: _currentPage,
    // );

    //   _focusNode.addListener(() {
    //     if (_focusNode.hasFocus) {
    //       _changePageToSearch();
    //     } else {
    //       _changePageBack();
    //     }
    //   });
  }

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   _debouncer.cancel();

  //   super.dispose();
  // }

  // void _onAskTextChanged() {
  //   if (_searchController.text.isNotEmpty) {
  //     _isTypingNotifier.value = true;
  //   } else {
  //     _isTypingNotifier.value = false;
  //   }
  // }

  // void _search() {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   String input = _searchController.text.trim();
  //   _provider.setStoreSearchTerm(input);
  //   String searchTermUpper = _provider.storeSearchTerm.toUpperCase();

  //   switch (_provider.storeSearchTabIndex) {
  //     case 0:
  //       _currentPage = 0;
  //       print(_provider.storeSearchTabIndex.toString() + 'vvv');
  //       _provider.setUserStoreSearchSnapShot(
  //           DatabaseService.searchUsers(searchTermUpper));
  //       break;
  //     case 1:
  //       _provider.setEventStoreSearchSnapShot(
  //           DatabaseService.searchEvent(searchTermUpper));
  //       break;
  //     // default:
  //     //   _provider.setPostStoreSearchSnapShot(
  //     //       DatabaseService.searchPost(searchTermUpper));
  //     //   break;
  //   }
  // }

  final _physycsNotifier = ValueNotifier<bool>(false);
  bool get wantKeepAlive => true;

  // _clearSearch() {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   WidgetsBinding.instance
  //       .addPostFrameCallback((_) => _searchController.clear());
  //   setState(() {
  //     _currentPage = 0;
  //     _provider.setStoreSearchTerm('');
  //     _provider.setStoreSearchIndex(0);
  //   });
  // }

  // _cancelSearch() {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   FocusScope.of(context).unfocus();
  //   _changePageBack();
  //   _clearSearch();
  //   _provider.setStoreSearchIndex(0);
  //   _provider.setUserStoreSearchSnapShot(null);
  //   _provider.setEventStoreSearchSnapShot(null);

  //   _provider.setPostStoreSearchSnapShot(null);
  //   _provider.setStoreSearchTerm('');
  // }

  // _changePageBack() {
  //   return _pageController.jumpToPage(
  //     _currentPage,
  //   );
  // }

  // void _changeTabs() {
  //   setState(() {
  //     _tabController.dispose();
  //     _tabController = TabController(length: 20, vsync: this);
  //   });
  // }

  // _changePageToSearch() {
  //   _changeTabs();
  //   return _pageController.animateToPage(
  //     _currentPage + 1,
  //     duration: const Duration(milliseconds: 10),
  //     curve: Curves.easeIn,
  //   );
  // }

  void _showBottomSheetSort(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    _sortByWidget(String text1, String text, bool isIcon) {
      return Container(
        width: width.toDouble(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width / 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: isIcon
                    ? Icon(
                        Icons.calendar_month,
                        size: 30.0,
                        color: Colors.grey,
                      )
                    : Text(
                        "$text1   ",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
              ),
            ),
            Container(
              width: width / 2.5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: height.toDouble() / 1.5,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
                child: MyBottomModelSheetAction(actions: [
                  const SizedBox(
                    height: 30,
                  ),
                  RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Sort creatives ",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: widget.isLiveLocation
                              ? '\nin ${widget.liveCity}'
                              : '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ])),
                  const SizedBox(
                    height: 30,
                  ),
                  BottomModalSheetButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                    },
                    width: width.toDouble(),
                    child: _sortByWidget('', 'Tonight', false),
                  ),
                  BottomModalSheetButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                    },
                    width: width.toDouble(),
                    child: _sortByWidget('1', 'Tommorrow', false),
                  ),
                  BottomModalSheetButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                    },
                    width: width.toDouble(),
                    child: _sortByWidget('7', 'In seven days', false),
                  ),
                  BottomModalSheetButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                    },
                    width: width.toDouble(),
                    child: _sortByWidget('14', 'In 14 days', false),
                  ),
                  BottomModalSheetButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                    },
                    width: width.toDouble(),
                    child: _sortByWidget('14', '    Calendar', true),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  BottomModalSheetButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                    },
                    width: width.toDouble(),
                    child: Text('Tonight'),
                  ),
                  BottomModalSheetButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                    },
                    width: width.toDouble(),
                    child: Text('Tonight'),
                  ),
                  BottomModalSheetButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                    },
                    width: width.toDouble(),
                    child: Text('Tonight'),
                  ),
                  BottomModalSheetButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                    },
                    width: width.toDouble(),
                    child: Text('Tonight'),
                  ),
                ])));
      },
    );
  }

  _searchContainer() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => StoreSearch(
                      // url: 'https://www.barsopus.com/terms-of-use',
                      )));
        },
        child: DummySearchContainer());
    // _searchContainer() {
    //   return SearchContentField(
    //       cancelSearch: _cancelSearch,
    //       controller: _searchController,
    //       focusNode: _focusNode,
    //       hintText: 'Type to search...',
    //       onClearText: () {
    //         _clearSearch();
    //       },
    //       onTap: () {
    //         _changePageToSearch();
    //       },
    //       onChanged: (value) {
    //         if (_searchController.text.trim().isNotEmpty) {
    //           _debouncer.run(() {
    //             _search();
    //           });
    //         }
    //       });
  }

  _liveLocationHeader() {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
          color: Colors.grey,
        ),
      ),
      title: Text(
        widget.liveCity,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  _creativesPageTab() {
    return TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).secondaryHeaderColor,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        labelPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
        indicatorWeight: 2.0,
        isScrollable: true,
        tabs: <Widget>[
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Artist',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Producer',
          ),
          Text(style: Theme.of(context).textTheme.bodySmall, 'DJ'),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Dancer',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Music_Video_Director',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Content_creator',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Photographer',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Record_Label',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Brand_Influencer',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Event_organiser',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Band',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Instrumentalist',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Cover_Art_Designer',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Makeup_Artist',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Video_Vixen',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Blogger',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'MC(Host)',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Choire',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Battle_Rapper',
          ),
          Text(
            style: Theme.of(context).textTheme.bodySmall,
            'Fans',
          ),
        ]);
  }

  _creativePage() {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    return Listener(
      onPointerMove: (event) {
        final offset = event.delta.dx;
        final index = _tabController.index;
        if (((offset > 0 && index == 0) || (offset < 0 && index == 20 - 1)) &&
            !_physycsNotifier.value) {
          _physycsNotifier.value = true;
        }
      },
      onPointerUp: (_) => _physycsNotifier.value = false,
      child: ValueListenableBuilder<bool>(
          valueListenable: _physycsNotifier,
          builder: (_, value, __) {
            return TabBarView(
              controller: _tabController,
              physics: value ? NeverScrollableScrollPhysics() : null,
              children: List.generate(20, (index) {
                String eventType = '';
                int tabIndex = 0;
                switch (index) {
                  case 0:
                    eventType = 'Artist';
                    tabIndex = 0;
                    break;
                  case 1:
                    eventType = 'Producer';
                    tabIndex = 1;
                    break;
                  case 2:
                    eventType = 'DJ';
                    tabIndex = 2;
                    break;
                  case 3:
                    eventType = 'Dancer';
                    tabIndex = 3;
                    break;
                  case 4:
                    eventType = 'Music_Video_Director';
                    tabIndex = 4;
                    break;
                  case 5:
                    eventType = 'Content_creator';
                    tabIndex = 5;
                    break;
                  case 6:
                    eventType = 'Photographer';
                    tabIndex = 6;
                    break;
                  case 7:
                    eventType = 'Record_Label';
                    tabIndex = 7;
                    break;
                  case 8:
                    eventType = 'Brand_Influencer';
                    tabIndex = 8;
                    break;
                  case 9:
                    eventType = 'Event_organiser';
                    tabIndex = 9;
                    break;
                  case 10:
                    eventType = 'Band';
                    tabIndex = 10;
                    break;
                  case 11:
                    eventType = 'Instrumentalist';
                    tabIndex = 11;
                    break;
                  case 12:
                    eventType = 'Cover_Art_Designer';
                    tabIndex = 12;
                    break;
                  case 13:
                    eventType = 'Makeup_Artist';
                    tabIndex = 13;
                    break;
                  case 14:
                    eventType = 'Video_Vixen';
                    tabIndex = 14;
                    break;
                  case 15:
                    eventType = 'Blogger';
                    tabIndex = 15;
                    break;
                  case 16:
                    eventType = 'MC(Host)';
                    tabIndex = 16;
                    break;
                  case 17:
                    eventType = 'Choire';
                    tabIndex = 17;
                    break;
                  case 18:
                    eventType = 'Battle_Rapper';
                    tabIndex = 18;
                    break;
                  case 19:
                    eventType = 'Fan';
                    tabIndex = 19;
                    break;
                }
                return eventType.startsWith('Fan')
                    ? FansScreen(
                        currentUserId: widget.currentUserId,
                        exploreLocation: '',
                      )
                    : CreativesScreen(
                        currentUserId: widget.currentUserId,
                        exploreLocation: '',
                        profileHandle: eventType.trim(),
                        pageIndex: tabIndex,
                        userLocationSettings: _userLocationSettings!,
                        //  isLiveLocation: widget.isLiveLocation,
                        liveCity: widget.liveCity,
                        liveCountry: widget.liveCountry,
                        seeMoreFrom: '', isFrom: '',
                      );
              }),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: DefaultTabController(
        length: _currentPage == 1 ? 4 : 20,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height),
            child: SafeArea(
              child: SingleChildScrollView(
                child:
                    !Provider.of<UserData>(context, listen: false).showUsersTab
                        ? Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              // 'Dsicover creatives',
                              _tabController.index == 0
                                  ? 'All Artists'
                                  : _tabController.index == 1
                                      ? 'All Producers'
                                      : _tabController.index == 2
                                          ? 'All DJ'
                                          : _tabController.index == 3
                                              ? 'All Dancer'
                                              : _tabController.index == 4
                                                  ? 'All Music_Video_Director'
                                                  : _tabController.index == 5
                                                      ? 'All Content_creator'
                                                      : _tabController.index ==
                                                              6
                                                          ? 'All Photographer'
                                                          : _tabController
                                                                      .index ==
                                                                  7
                                                              ? 'All Record_Label'
                                                              : _tabController
                                                                          .index ==
                                                                      8
                                                                  ? 'All Brand_Influencer'
                                                                  : _tabController
                                                                              .index ==
                                                                          9
                                                                      ? 'All Event_organiser'
                                                                      : _tabController.index ==
                                                                              10
                                                                          ? 'All Band'
                                                                          : _tabController.index == 11
                                                                              ? 'All Instrumentalist'
                                                                              : _tabController.index == 12
                                                                                  ? 'All Cover_Art_Designer'
                                                                                  : _tabController.index == 13
                                                                                      ? 'AllMakeup_Artists'
                                                                                      : _tabController.index == 14
                                                                                          ? 'All Video_Vixens'
                                                                                          : _tabController.index == 15
                                                                                              ? 'All Bloggers'
                                                                                              : _tabController.index == 16
                                                                                                  ? 'All MC(Host)s'
                                                                                                  : _tabController.index == 17
                                                                                                      ? 'All Choire'
                                                                                                      : _tabController.index == 18
                                                                                                          ? 'Battle_Rapper'
                                                                                                          : _tabController.index == 19
                                                                                                              ? 'All Fans'
                                                                                                              : '',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : Container(
                            height:

                                //  _focusNode.hasFocus
                                //     ? ResponsiveHelper.responsiveHeight(context, 50)
                                //     :

                                ResponsiveHelper.responsiveHeight(context, 100),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  widget.isLiveLocation
                                      ? _liveLocationHeader()
                                      : widget.isLiveLocation
                                          ? _liveLocationHeader()
                                          : _searchContainer(),
                                  // _focusNode.hasFocus
                                  //     ? const SizedBox.shrink()
                                  //     :
                                  _creativesPageTab(),
                                ],
                              ),
                            ),
                          ),
              ),
            ),
          ),
          body: _creativePage(),
          // PageView(
          //     controller: _pageController,
          //     physics: const NeverScrollableScrollPhysics(),
          //     children: [
          //       _creativePage(),
          //       GestureDetector(
          //         onTap: _cancelSearch,
          //         child: StoreSearch(),
          //       ),
          //     ]),
        ),
      ),
    );
  }
}
