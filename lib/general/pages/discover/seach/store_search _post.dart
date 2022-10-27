import 'package:bars/utilities/exports.dart';

class StoreSearchPosts extends StatefulWidget {
  static final id = 'StoreSearchPosts';

  @override
  _StoreSearchPostsState createState() => _StoreSearchPostsState();
}

class _StoreSearchPostsState extends State<StoreSearchPosts> {
  Future<QuerySnapshot>? _posts;

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

  _buildUserTile(Post post) {
    return FeedGrid(
      feed: 'All',
      currentUserId:
          Provider.of<UserData>(context, listen: false).currentUserId!,
      post: post,
      // author: author,
    );
  }

  _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
    setState(() {
      _posts = null;
    });
  }

  _clearPosts() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
    setState(() {
      _posts = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
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
                    color:
                        ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                  ),
                  cursorColor: Colors.blue,
                  controller: _controller,
                  onChanged: (input) {
                    setState(() {
                      input.isEmpty
                          ? () {}
                          : _posts =
                              DatabaseService.searchPost(input.toUpperCase());
                    });
                  },

                  // },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    border: InputBorder.none,
                    hintText: 'Enter mood punched',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.0,
                      color:
                          ConfigBloc().darkModeOn ? Colors.black : Colors.white,
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
                    if (input.isNotEmpty) {
                      input.isEmpty
                          ? () {}
                          : setState(() {
                              _posts = DatabaseService.searchPost(
                                  input.toUpperCase());
                            });
                    }
                  },
                ),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Container(
                  // ignore: unnecessary_null_comparison
                  child: _posts == null
                      ? Center(
                          child: NoContents(
                              title: "Searh for moods punched. ",
                              subTitle: 'Enter punhcline.',
                              icon: Icons.image))
                      : FutureBuilder<QuerySnapshot>(
                          future: _posts,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return GroupGridSchimmerSkeleton();
                            }
                            if (snapshot.data!.docs.length == 0) {
                              return Center(
                                child: RichText(
                                    text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "No mood punched found. ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey)),
                                    TextSpan(
                                        text:
                                            '\nCheck punchline and try again.'),
                                  ],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Scrollbar(
                                child: CustomScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    slivers: [
                                      SliverGrid(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            Post? post = Post.fromDoc(
                                                snapshot.data!.docs[index]);
                                            return FeedGrid(
                                              feed: 'All',
                                              currentUserId:
                                                  Provider.of<UserData>(context,
                                                          listen: false)
                                                      .currentUserId!,
                                              post: post,
                                            );
                                          },
                                          childCount:
                                              snapshot.data!.docs.length,
                                        ),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 5.0,
                                          crossAxisSpacing: 5.0,
                                          childAspectRatio: 1.0,
                                        ),
                                      ),
                                      // SliverList(
                                      //   delegate: SliverChildBuilderDelegate(
                                      //     (context, index) {
                                      //       Post? post = Post.fromDoc(
                                      //           snapshot.data!.docs[index]);
                                      //       return _buildUserTile(post);
                                      //     },
                                      //     childCount:
                                      //         snapshot.data!.docs.length,
                                      //   ),
                                      // ),
                                    ]),
                              ),
                            );
                          })),
            ),
          )),
    );
  }
}
