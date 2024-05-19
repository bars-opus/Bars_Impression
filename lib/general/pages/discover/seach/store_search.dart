import 'package:bars/utilities/exports.dart';

class StoreSearch extends StatefulWidget {
  @override
  State<StoreSearch> createState() => _StoreSearchState();
}

class _StoreSearchState extends State<StoreSearch>
    with TickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  final FocusNode _addressSearchfocusNode = FocusNode();
  final _debouncer = Debouncer(milliseconds: 500);
  late TabController _tabController;
  final _physycsNotifier = ValueNotifier<bool>(false);

  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  Future<QuerySnapshot>? _users;
  Future<QuerySnapshot>? _event;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addressSearchfocusNode.dispose();
    _isTypingNotifier.dispose();
    _tabController.dispose();
    _debouncer.cancel();
    _focusNode.dispose();

    super.dispose();
  }

  _cancelSearch() {
    _users = null;
    _event = null;
    FocusScope.of(context).unfocus();
    _clearSearch();

    Navigator.pop(context);
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    Provider.of<UserData>(context, listen: false).addressSearchResults = [];
  }

  void _search() {
    var _provider = Provider.of<UserData>(context, listen: false);
    String input = _searchController.text.trim();
    _provider.setStoreSearchTerm(input);
    String searchTermUpper = _provider.storeSearchTerm.toUpperCase();

    if (_tabController.index == 0) {
      setState(() {
        _event = DatabaseService.searchEvent(searchTermUpper);
      });
    } else if (_tabController.index == 1) {
      setState(() {
        _users = DatabaseService.searchUsers(searchTermUpper);
      });
    }
  }

  _searchContainer() {
    return SearchContentField(
      showCancelButton: true,
      autoFocus: true,
      cancelSearch: _cancelSearch,
      controller: _searchController,
      focusNode: _focusNode,
      hintText: 'Type to search...',
      onClearText: () {
        _clearSearch();
      },
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          // _debouncer.run(() {
          _search();
          // });
        }
      },
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return Container(
      color: Theme.of(context).primaryColorLight,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
        child: DefaultTabController(
          length: 2,
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).primaryColorLight,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0.0,
                  backgroundColor: Theme.of(context).primaryColorLight,
                  primary: false,
                  title: _searchContainer(),
                  bottom: TabBar(
                    onTap: (index) {
                      _searchController.text.trim().isNotEmpty
                          ? _search()
                          : null;
                    },
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    labelColor: Theme.of(context).secondaryHeaderColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabAlignment: TabAlignment.center,
                    isScrollable: true,
                    labelPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
                    indicatorWeight: 2.0,
                    tabs: <Widget>[
                      Text(
                        style: Theme.of(context).textTheme.bodyMedium,
                        'Events',
                      ),
                      Text(
                        style: Theme.of(context).textTheme.bodyMedium,
                        'Creatives',
                      ),
                    ],
                  ),
                ),
              ),
              body: Listener(
                onPointerMove: (event) {
                  // _provider.setStoreSearchIndex(_tabController.index + 1);
                  if (_searchController.text.trim().isNotEmpty &&
                      !_physycsNotifier.value) {
                    _search();
                    _physycsNotifier.value = true;
                  }
                },
                onPointerUp: (_) => _physycsNotifier.value = false,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _physycsNotifier,
                  builder: (_, value, __) {
                    return TabBarView(
                      controller: _tabController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: <Widget>[
                        StoreSearchEvents(
                          events: _event,
                        ),
                        StoreSearchUsers(users: _users),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}










// import 'package:bars/utilities/exports.dart';

// class StoreSearch extends StatefulWidget {
//   static final id = 'StoreSearch';

//   @override
//   _StoreSearchState createState() => _StoreSearchState();
// }

// class _StoreSearchState extends State<StoreSearch>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   final _physycsNotifier = ValueNotifier<bool>(false);

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   void _search(UserData _provider) {
//     switch (_provider.storeSearchTabIndex) {
//       case 0:
//         _provider.setUserStoreSearchSnapShot(DatabaseService.searchUsers(
//             _provider.storeSearchTerm.toUpperCase()));
//         break;
//       case 1:
//         _provider.setEventStoreSearchSnapShot(DatabaseService.searchEvent(
//             _provider.storeSearchTerm.toUpperCase()));
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var _provider = Provider.of<UserData>(context, listen: false);
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//           textScaleFactor:
//               MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
//       child: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           backgroundColor: Theme.of(context).primaryColorLight,
//           appBar: PreferredSize(
//             preferredSize: Size.fromHeight(70),
//             child: AppBar(
//               elevation: 0.0,
//               backgroundColor: Theme.of(context).primaryColorLight,
//               primary: false,
//               bottom: TabBar(
//                 onTap: (index) {
//                   _provider.setStoreSearchIndex(index);
//                   _provider.storeSearchTerm.isNotEmpty
//                       ? _search(_provider)
//                       : null;
//                 },
//                 controller: _tabController,
//                 labelColor: Theme.of(context).secondaryHeaderColor,
//                 indicatorSize: TabBarIndicatorSize.label,
//                 indicatorColor: Colors.blue,
//                 unselectedLabelColor: Colors.grey,
//                 isScrollable: true,
//                 labelPadding:
//                     EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
//                 indicatorWeight: 2.0,
//                 tabs: <Widget>[
//                   Text(
//                     style: Theme.of(context).textTheme.bodyMedium,
//                     'Events',
//                   ),
//                   Text(
//                     style: Theme.of(context).textTheme.bodyMedium,
//                     'Creatives',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           body: Listener(
//             onPointerMove: (event) {
//               _provider.setStoreSearchIndex(_tabController.index + 1);
//               if (_provider.storeSearchTerm.isNotEmpty &&
//                   !_physycsNotifier.value) {
//                 _search(_provider);
//                 _physycsNotifier.value = true;
//               }
//             },
//             onPointerUp: (_) => _physycsNotifier.value = false,
//             child: ValueListenableBuilder<bool>(
//               valueListenable: _physycsNotifier,
//               builder: (_, value, __) {
//                 return TabBarView(
//                   controller: _tabController,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   children: <Widget>[
//                     StoreSearchEvents(
//                       events: _provider.eventStoreSearchSnapShot,
//                     ),
//                     StoreSearchUsers(
//                       users: _provider.userStoreSearchSnapShot,
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
