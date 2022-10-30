import 'package:bars/utilities/exports.dart';

class StoreSearch extends StatefulWidget {
  final User? user;

  StoreSearch({required this.user});

  static final id = 'StoreSearch';

  @override
  _StoreSearchState createState() => _StoreSearchState();
}

class _StoreSearchState extends State<StoreSearch> {
  Future<QuerySnapshot>? _users;
  Future<QuerySnapshot>? _posts;
  Future<QuerySnapshot>? _events;
  Future<QuerySnapshot>? _forums;

  String query = "";
  final _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
    setState(() {
      _users = null;
    });
  }

  _nothing() {}

  _search(String input) {
    setState(() {
      _users = DatabaseService.searchUsers(input.toUpperCase());
      _events = DatabaseService.searchEvent(input.toUpperCase());
      _forums = DatabaseService.searchForum(input.toUpperCase());
      _posts = DatabaseService.searchPost(input.toUpperCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: DefaultTabController(
                length: 4,
                child: Scaffold(
                    backgroundColor: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Colors.white,
                    appBar: AppBar(
                      elevation: 0.0,
                      iconTheme: IconThemeData(
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                      ),
                      backgroundColor: ConfigBloc().darkModeOn
                          ? Color(0xFF1a1a1a)
                          : Colors.white,
                      automaticallyImplyLeading: true,
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Material(
                          color: ConfigBloc().darkModeOn
                              ? Color(0xFFf2f2f2)
                              : Color(0xFF1a1a1a),
                          elevation: 1.0,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          child: TextField(
                            autofocus: true,
                            style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            cursorColor: Colors.blue,
                            controller: _controller,
                            onChanged: (input) {
                              input.isEmpty ? _nothing() : _search(input);
                            },

                        
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              border: InputBorder.none,
                              hintText: 'Type to search...',
                              prefixIcon: Icon(
                                Icons.search,
                                size: 20.0,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 15.0,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                onPressed: _clearSearch,
                              ),
                            ),
                            onSubmitted: (input) {
                              input.isEmpty ? _nothing() : _search(input);
                            },
                          ),
                        ),
                      ),
                      bottom: TabBar(
                          labelColor: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.blue,
                          onTap: (int index) {
                            Provider.of<UserData>(context, listen: false)
                                .setEventTab(index);
                          },
                          unselectedLabelColor: Colors.grey,
                          isScrollable: true,
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10.0),
                          indicatorWeight: 2.0,
                          tabs: <Widget>[
                            const Text(
                              'Users',
                            ),
                            const Text(
                              'Events',
                            ),
                            const Text(
                              'Forums',
                            ),
                            const Text('Moods punched'),
                          ]),
                    ),
                   
                    body: TabBarView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: <Widget>[
                        StoreSearchUsers(
                          users: _users,
                        ),
                        StoreSearchEvents(
                          events: _events,
                        ),
                        StoreSearchForum(
                          forums: _forums,
                        ),
                        StoreSearchPosts(
                          posts: _posts,
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

