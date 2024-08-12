
import 'package:bars/utilities/exports.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search>
    with TickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  final FocusNode _addressSearchfocusNode = FocusNode();
  final _debouncer = Debouncer(milliseconds: 500);
  late TabController _tabController;
  final _physycsNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  Future<QuerySnapshot>? _users;
   Future<List<DocumentSnapshot>>?   _event;
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
          _search();
        }
      },
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        EventSearch(
                          events: _event,
                        ),
                        UserSearch(users: _users),
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


