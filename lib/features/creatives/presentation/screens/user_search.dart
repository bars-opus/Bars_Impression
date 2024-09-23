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

  // _buildUserTile(AccountHolderAuthor user) {
  //   return SearchUserTile(
  //       userName: user.userName!.toUpperCase(),
  //       profileHandle: user.profileHandle!,
  //       verified: user.verified!,
  //       profileImageUrl: user.profileImageUrl!,
  //       bio: user.bio!,
  //       onPressed: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (_) => ProfileScreen(
  //                       currentUserId:
  //                           Provider.of<UserData>(context, listen: false)
  //                               .currentUserId!,
  //                       userId: user.userId!,
  //                       user: user,
  //                     )));
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    // print(widget.users);
    final theme = Theme.of(context);
//The search here is the new feature under implementation
    return Center(
      child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
          text: TextSpan(
            children: [
              TextSpan(
                  text: "Feature Comming soon. ",
                  style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey)),
              TextSpan(
                  text:
                      '\nThis feature is under implementation and would be ready in few day.'),
            ],
            style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                color: Colors.grey),
          )),
    );
  }
}
