import 'package:bars/utilities/exports.dart';

class StoreSearchForum extends StatefulWidget {
  static final id = 'StoreSearchForum';


    final Future<QuerySnapshot>? forums;

  StoreSearchForum({required this.forums});

  @override
  _StoreSearchForumState createState() => _StoreSearchForumState();
}

class _StoreSearchForumState extends State<StoreSearchForum> {

  _buildUserTile(Forum forum) {
    return ForumView(
      feed: 'All',
      currentUserId:
          Provider.of<UserData>(context, listen: false).currentUserId!,
      forum: forum,
    );
  }


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
                  child: widget.forums == null
                      ? Center(
                          child: NoContents(
                              title: "Searh for forums. ",
                              subTitle: 'Enter title.',
                              icon: Icons.forum))
                      : FutureBuilder<QuerySnapshot>(
                          future: widget.forums,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return ForumSchimmer();
                            }
                            if (snapshot.data!.docs.length == 0) {
                              return Center(
                                child: RichText(
                                    text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "No forums found. ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey)),
                                    TextSpan(
                                        text: '\nCheck title and try again.'),
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
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            Forum? forum = Forum.fromDoc(
                                                snapshot.data!.docs[index]);
                                            return _buildUserTile(forum);
                                          },
                                          childCount:
                                              snapshot.data!.docs.length,
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
