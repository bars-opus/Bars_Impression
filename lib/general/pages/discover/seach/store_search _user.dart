import 'package:bars/utilities/exports.dart';

class StoreSearchUsers extends StatefulWidget {
  static final id = 'StoreSearchUsers';
  final Future<QuerySnapshot>? users;

  StoreSearchUsers({required this.users});

  @override
  _StoreSearchUsersState createState() => _StoreSearchUsersState();
}

class _StoreSearchUsersState extends State<StoreSearchUsers> {
  _buildUserTile(AccountHolder user) {
    return SearchUserTile(
        userName: user.userName!.toUpperCase(),
        profileHandle: user.profileHandle!,
        verified: user.verified,
        company: user.company!,
        profileImageUrl: user.profileImageUrl!,
        bio: user.bio!,
        // score: user.score!,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        currentUserId:
                            Provider.of<UserData>(context).currentUserId!,
                        userId: user.id!,
                        user: user,
                      )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          body: SafeArea(
            child: Container(
                // ignore: unnecessary_null_comparison
                child: widget.users == null
                    ? Center(
                        child: NoContents(
                            title: "Searh for users. ",
                            subTitle:
                                'Enter username, \ndon\'t enter a user\'s nickname.',
                            icon: Icons.search))
                    : FutureBuilder<QuerySnapshot>(
                        future: widget.users,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return SearchUserSchimmer();
                          }
                          if (snapshot.data!.docs.length == 0) {
                            return Center(
                              child: RichText(
                                  text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "No users found. ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey)),
                                  TextSpan(
                                      text: '\nCheck username and try again.'),
                                ],
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
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
                                          AccountHolder? user =
                                              AccountHolder.fromDoc(
                                                  snapshot.data!.docs[index]);
                                          return _buildUserTile(user);
                                        },
                                        childCount: snapshot.data!.docs.length,
                                      ),
                                    ),
                                  ]),
                            ),
                          );
                        })),
          )),
    );
  }
}
