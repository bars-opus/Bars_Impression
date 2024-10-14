import 'package:bars/utilities/exports.dart';

class Search extends StatefulWidget {
  // final String currentUserId;

  Search({
    super.key,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();

  Future<QuerySnapshot>? _ticketOrder;
  final FocusNode _addressSearchfocusNode = FocusNode();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _searchController.dispose();
    _addressSearchfocusNode.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  _cancelSearch() {
    FocusScope.of(context).unfocus();
    _clearSearch();
    Navigator.pop(context);
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    Provider.of<UserData>(context, listen: false).addressSearchResults = [];
  }

  _buildUserTile(AccountHolderAuthor user) {
    return SearchUserTile(
        userName: user.userName!.toUpperCase(),
        shopType:
            user.accountType != 'Client' ? user.shopType! : user.accountType!,
        verified: user.verified!,
        profileImageUrl: user.profileImageUrl!,
        // bio: ,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        currentUserId:
                            Provider.of<UserData>(context, listen: false)
                                .currentUserId!,
                        userId: user.userId!,
                        user: user.accountType == 'Client' ? user : null,
                        accountType: user.accountType!,
                      )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SearchContentField(
                  autoFocus: true,
                  showCancelButton: true,
                  cancelSearch: _cancelSearch,
                  controller: _searchController,
                  focusNode: _addressSearchfocusNode,
                  hintText: 'Type name here...',
                  onClearText: () {
                    _clearSearch();
                  },
                  onTap: () {},
                  onChanged: (input) {
                    if (input.trim().isNotEmpty)
                      _debouncer.run(() {
                        setState(() {
                          _ticketOrder = DatabaseService.searchUsers(
                            input.toUpperCase(),
                          );
                        });
                      });
                  }),
            ),
            _ticketOrder == null
                ? Center(
                    child: Padding(
                    padding: EdgeInsets.only(
                        top: ResponsiveHelper.responsiveHeight(context, 200)),
                    child: NoContents(
                        title: "Search . ",
                        subTitle: 'Enter the name of the shop or worker.',
                        icon: Icons.search),
                  ))
                : FutureBuilder<QuerySnapshot>(
                    future: _ticketOrder,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(child: SearchUserSchimmer());
                      }
                      if (snapshot.data!.docs.length == 0) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: ResponsiveHelper.responsiveHeight(
                                  context, 250)),
                          child: Center(
                            child: RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "No shop or worker found. ",
                                        style: TextStyle(
                                            fontSize: ResponsiveHelper
                                                .responsiveFontSize(
                                                    context, 20),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey)),
                                    TextSpan(
                                        text:
                                            '\nCheck the name and try again.'),
                                  ],
                                  style: TextStyle(
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 14),
                                      color: Colors.grey),
                                )),
                          ),
                        );
                      }
                      return Expanded(
                        child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    AccountHolderAuthor? user =
                                        AccountHolderAuthor.fromDoc(
                                            snapshot.data!.docs[index]);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: _buildUserTile(user),
                                      //  EventsFeedAttendingWidget(
                                      //   ticketOrder: ticketOrder,
                                      //   currentUserId: widget.currentUserId,
                                      //   ticketList: [],
                                      // ),
                                    );
                                  },
                                  childCount: snapshot.data!.docs.length,
                                ),
                              ),
                            ]),
                      );
                    }),
          ],
        ),
      ),
    );
  }
}





// class Search extends StatefulWidget {
//   @override
//   State<Search> createState() => _SearchState();
// }

// class _SearchState extends State<Search>
//     with TickerProviderStateMixin {
//   TextEditingController _searchController = TextEditingController();
//   final FocusNode _addressSearchfocusNode = FocusNode();
//   final _debouncer = Debouncer(milliseconds: 500);
//   late TabController _tabController;
//   final _physycsNotifier = ValueNotifier<bool>(false);
//   ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
//   Future<QuerySnapshot>? _users;
//    Future<List<DocumentSnapshot>>?   _event;
//   final FocusNode _focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       if (!_tabController.indexIsChanging) {
//         HapticFeedback.mediumImpact();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _addressSearchfocusNode.dispose();
//     _isTypingNotifier.dispose();
//     _tabController.dispose();
//     _debouncer.cancel();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   _cancelSearch() {
//     _users = null;
//     _event = null;
//     FocusScope.of(context).unfocus();
//     _clearSearch();
//     Navigator.pop(context);
//   }

//   _clearSearch() {
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => _searchController.clear());
//     Provider.of<UserData>(context, listen: false).addressSearchResults = [];
//   }

//   void _search() {
//     var _provider = Provider.of<UserData>(context, listen: false);
//     String input = _searchController.text.trim();
//     _provider.setStoreSearchTerm(input);
//     String searchTermUpper = _provider.storeSearchTerm.toUpperCase();

//     if (_tabController.index == 0) {
//       setState(() {
//         _event = DatabaseService.searchEvent(searchTermUpper);
//       });
//     } else if (_tabController.index == 1) {
//       setState(() {
//         _users = DatabaseService.searchUsers(searchTermUpper);
//       });
//     }
//   }

//   _searchContainer() {
//     return SearchContentField(
//       showCancelButton: true,
//       autoFocus: true,
//       cancelSearch: _cancelSearch,
//       controller: _searchController,
//       focusNode: _focusNode,
//       hintText: 'Type to search...',
//       onClearText: () {
//         _clearSearch();
//       },
//       onChanged: (value) {
//         if (value.trim().isNotEmpty) {
//           _search();
//         }
//       },
//       onTap: () {},
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).primaryColorLight,
//       child: MediaQuery(
//         data: MediaQuery.of(context).copyWith(
//             textScaleFactor:
//                 MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
//         child: DefaultTabController(
//           length: 2,
//           child: SafeArea(
//             child: Scaffold(
//               resizeToAvoidBottomInset: false,
//               backgroundColor: Theme.of(context).primaryColorLight,
//               appBar: PreferredSize(
//                 preferredSize: Size.fromHeight(100),
//                 child: AppBar(
//                   automaticallyImplyLeading: false,
//                   elevation: 0.0,
//                   backgroundColor: Theme.of(context).primaryColorLight,
//                   primary: false,
//                   title: _searchContainer(),
//                   bottom: TabBar(
//                     onTap: (index) {
//                       _searchController.text.trim().isNotEmpty
//                           ? _search()
//                           : null;
//                     },
//                     controller: _tabController,
//                     dividerColor: Colors.transparent,
//                     labelColor: Theme.of(context).secondaryHeaderColor,
//                     indicatorSize: TabBarIndicatorSize.label,
//                     indicatorColor: Colors.blue,
//                     unselectedLabelColor: Colors.grey,
//                     tabAlignment: TabAlignment.center,
//                     isScrollable: true,
//                     labelPadding:
//                         EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
//                     indicatorWeight: 2.0,
//                     tabs: <Widget>[
//                       Text(
//                         style: Theme.of(context).textTheme.bodyMedium,
//                         'Events',
//                       ),
//                       Text(
//                         style: Theme.of(context).textTheme.bodyMedium,
//                         'Creatives',
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               body: Listener(
//                 onPointerMove: (event) {
//                   if (_searchController.text.trim().isNotEmpty &&
//                       !_physycsNotifier.value) {
//                     _search();
//                     _physycsNotifier.value = true;
//                   }
//                 },
//                 onPointerUp: (_) => _physycsNotifier.value = false,
//                 child: ValueListenableBuilder<bool>(
//                   valueListenable: _physycsNotifier,
//                   builder: (_, value, __) {
//                     return TabBarView(
//                       controller: _tabController,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       children: <Widget>[
//                         EventSearch(
//                           events: _event,
//                         ),
//                         UserSearch(users: _users),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


