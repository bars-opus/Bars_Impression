import 'package:bars/utilities/exports.dart';

class StoreSearchPosts extends StatefulWidget {
  static final id = 'StoreSearchPosts';

  final Future<QuerySnapshot>? posts;

  StoreSearchPosts({required this.posts});

  @override
  _StoreSearchPostsState createState() => _StoreSearchPostsState();
}

class _StoreSearchPostsState extends State<StoreSearchPosts> {
 

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Container(
                  // ignore: unnecessary_null_comparison
                  child: widget.posts == null
                      ? Center(
                          child: NoContents(
                              title: "Searh for moods punched. ",
                              subTitle: 'Enter punhcline.',
                              icon: Icons.image))
                      : FutureBuilder<QuerySnapshot>(
                          future: widget.posts,
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
                                    ]),
                              ),
                            );
                          })),
            ),
          )),
    );
  }
}
