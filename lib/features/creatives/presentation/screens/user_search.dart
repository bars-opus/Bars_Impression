import 'package:bars/utilities/exports.dart';

class UserSearch extends StatefulWidget {
  static final id = 'UserSearch';
  final bool fromFlorence;

  final Future<QuerySnapshot>? users;
  UserSearch({required this.users, this.fromFlorence = false});

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  Future<List<AccountHolderAuthor>> getUsers() async {
    QuerySnapshot<Object?> querySnapshot = await widget.users!;
    // print(widget.users.);
    if (querySnapshot.docs.isEmpty) {
      return [];
    }
    return querySnapshot.docs.map((doc) {
      return AccountHolderAuthor.fromDoc(doc);
    }).toList();
  }

  _buildUserTile(AccountHolderAuthor user) {
    return SearchUserTile(
        userName: user.userName!.toUpperCase(),
        profileHandle: user.profileHandle!,
        verified: user.verified!,
        profileImageUrl: user.profileImageUrl!,
        bio: user.bio!,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        currentUserId:
                            Provider.of<UserData>(context, listen: false)
                                .currentUserId!,
                        userId: user.userId!,
                        user: user,
                      )));
        });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.users);
    final theme = Theme.of(context);
//The search here is the new feature under implementation
    return Container(
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      color: widget.fromFlorence ? Colors.transparent : theme.primaryColorLight,
      child: widget.users == null
          ? Center(
              child: NoContents(
                  isFLorence: widget.fromFlorence,
                  textColor: widget.fromFlorence ? Colors.white : null,
                  title: "Searh for creative. ",
                  subTitle: 'Enter name of creative.',
                  icon: null))
          : FutureBuilder<List<AccountHolderAuthor>>(
              future: getUsers(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<AccountHolderAuthor>> snapshot) {
                if (!snapshot.hasData) {
                  return widget.fromFlorence
                      ? Center(
                          child: Loading(
                            shakeReapeat: false,
                            color: Colors.white,
                            title: 'processing...',
                            icon: (FontAwesomeIcons.circle),
                          ),
                        )
                      : SearchUserSchimmer();
                }
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                            text: "No users found. ",
                            style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 20),
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey)),
                        TextSpan(text: '\nCheck username and try again.'),
                      ],
                      style: TextStyle(
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 14),
                          color: Colors.grey),
                    )),
                  );
                }
                return Padding(
                  padding:
                      EdgeInsets.only(top: widget.fromFlorence ? 10 : 30.0),
                  child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              AccountHolderAuthor user = snapshot.data![index];
                              return _buildUserTile(user);
                            },
                            childCount: snapshot.data!.length,
                          ),
                        ),
                      ]),
                );
              }),
    );
  }
}
