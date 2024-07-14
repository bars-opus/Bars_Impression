import 'package:bars/utilities/exports.dart';

class UserSearch extends StatefulWidget {
  static final id = 'UserSearch';
  final Future<QuerySnapshot>? users;

  UserSearch({required this.users});

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  _buildUserTile(AccountHolderAuthor user) {
    return SearchUserTile(
        userName: user.userName!.toUpperCase(),
        profileHandle: user.profileHandle!,
        verified: user.verified!,
        // company: user.company!,
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColorLight,
      body: SafeArea(
        child: Container(
            color: theme.primaryColorLight,
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
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "No users found. ",
                                      style: TextStyle(
                                          fontSize: ResponsiveHelper
                                              .responsiveFontSize(context, 20),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey)),
                                  TextSpan(
                                      text: '\nCheck username and try again.'),
                                ],
                                style:
                                    TextStyle(fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14), color: Colors.grey),
                              )),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    AccountHolderAuthor? user =
                                        AccountHolderAuthor.fromDoc(
                                            snapshot.data!.docs[index]);
                                    return _buildUserTile(user);
                                  },
                                  childCount: snapshot.data!.docs.length,
                                ),
                              ),
                            ]),
                      );
                    })),
      ),
    );
  }
}

// class UserSearch extends StatefulWidget {
//   static final id = 'UserSearch';
//   final Future<QuerySnapshot>? users;

//   UserSearch({required this.users});

//   @override
//   _UserSearchState createState() => _UserSearchState();
// }

// class _UserSearchState extends State<UserSearch> {
//   _buildUserTile(AccountHolder user) {
//     return SearchUserTile(
//         userName: user.userName!.toUpperCase(),
//         profileHandle: user.profileHandle!,
//         verified: user.verified,
//         company: user.company!,
//         profileImageUrl: user.profileImageUrl!,
//         bio: user.bio!,
//         // score: user.score!,
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => ProfileScreen(
//                         currentUserId:
//                             Provider.of<UserData>(context).currentUserId,
//                         userId: user.id!,
//                         user: user,
//                       )));
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveScaffold(
//       child: Scaffold(
//           backgroundColor: Theme.of(context).primaryColorLight,
//           body: SafeArea(
//             child: Container(
//                 color: Theme.of(context).primaryColorLight,
//                 // ignore: unnecessary_null_comparison
//                 child: widget.users == null
//                     ? Center(
//                         child: NoContents(
//                             title: "Searh for users. ",
//                             subTitle:
//                                 'Enter username, \ndon\'t enter a user\'s nickname.',
//                             icon: Icons.search))
//                     : FutureBuilder<QuerySnapshot>(
//                         future: widget.users,
//                         builder: (BuildContext context,
//                             AsyncSnapshot<QuerySnapshot> snapshot) {
//                           if (!snapshot.hasData) {
//                             return SearchUserSchimmer();
//                           }
//                           if (snapshot.data!.docs.length == 0) {
//                             return Center(
//                               child: RichText(
//                                   text: TextSpan(
//                                 children: [
//                                   TextSpan(
//                                       text: "No users found. ",
//                                       style: TextStyle(
//                                           fontSize:  ResponsiveHelper.responsiveFontSize( context, 20),
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.blueGrey)),
//                                   TextSpan(
//                                       text: '\nCheck username and try again.'),
//                                 ],
//                                 style:
//                                     TextStyle(fontSize: 14, color: Colors.grey),
//                               )),
//                             );
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 30.0),
//                             child: Scrollbar(
//                               child: CustomScrollView(
//                                   physics:
//                                       const AlwaysScrollableScrollPhysics(),
//                                   slivers: [
//                                     SliverList(
//                                       delegate: SliverChildBuilderDelegate(
//                                         (context, index) {
//                                           AccountHolder? user =
//                                               AccountHolder.fromDoc(
//                                                   snapshot.data!.docs[index]);
//                                           return _buildUserTile(user);
//                                         },
//                                         childCount: snapshot.data!.docs.length,
//                                       ),
//                                     ),
//                                   ]),
//                             ),
//                           );
//                         })),
//           )),
//     );
//   }
// }


// import 'package:bars/utilities/exports.dart';

// class UserSearch extends StatefulWidget {
//   static final id = 'UserSearch';
//   final Future<QuerySnapshot>? users;

//   UserSearch({required this.users});

//   @override
//   _UserSearchState createState() => _UserSearchState();
// }

// class _UserSearchState extends State<UserSearch> {
//   _buildUserTile(AccountHolderAuthor user) {
//     return SearchUserTile(
//         userName: user.userName!.toUpperCase(),
//         profileHandle: user.profileHandle!,
//         verified: user.verified!,
//         profileImageUrl: user.profileImageUrl!,
//         bio: user.bio!,
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => ProfileScreen(
//                         currentUserId:
//                             Provider.of<UserData>(context, listen: false)
//                                 .currentUserId!,
//                         userId: user.userId!,
//                         user: user,
//                       )));
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//           backgroundColor: theme.primaryColorLight,
//           body: SafeArea(
//             child: Container(
//                 color: theme.primaryColorLight,
//                 child: widget.users == null
//                     ? Center(
//                         child: NoContents(
//                             title: "Searh for users. ",
//                             subTitle:
//                                 'Enter username, \ndon\'t enter a user\'s nickname.',
//                             icon: Icons.search))
//                     : FutureBuilder<QuerySnapshot>(
//                         future: widget.users,
//                         builder: (BuildContext context,
//                             AsyncSnapshot<QuerySnapshot> snapshot) {
//                           if (!snapshot.hasData) {
//                             return SearchUserSchimmer();
//                           }
//                           if (snapshot.data!.docs.length == 0) {
//                             return Center(
//                               child: RichText(   textScaleFactor: MediaQuery.of(context).textScaleFactor,
//                                   text: TextSpan(
//                                 children: [
//                                   TextSpan(
//                                       text: "No users found. ",
//                                       style: TextStyle(
//                                           fontSize:  ResponsiveHelper.responsiveFontSize( context, 20),
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.blueGrey)),
//                                   TextSpan(
//                                       text: '\nCheck username and try again.'),
//                                 ],
//                                 style:
//                                     TextStyle(fontSize: 14, color: Colors.grey),
//                               )),
//                             );
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 30.0),
//                             child: CustomScrollView(
//                                 physics: const AlwaysScrollableScrollPhysics(),
//                                 slivers: [
//                                   SliverList(
//                                     delegate: SliverChildBuilderDelegate(
//                                       (context, index) {
//                                         AccountHolderAuthor? user =
//                                             AccountHolderAuthor.fromDoc(
//                                                 snapshot.data!.docs[index]);
//                                         return _buildUserTile(user);
//                                       },
//                                       childCount: snapshot.data!.docs.length,
//                                     ),
//                                   ),
//                                 ]),
//                           );
//                         })),
//           ),
//     );
//   }
// }
