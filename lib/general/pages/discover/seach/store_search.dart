import 'package:bars/utilities/exports.dart';

class StoreSearch extends StatefulWidget {
  final User? user;

  StoreSearch({required this.user});

  static final id = 'StoreSearch';

  @override
  _StoreSearchState createState() => _StoreSearchState();
}

class _StoreSearchState extends State<StoreSearch> {
  // Future<QuerySnapshot>? _users;
  // Future<QuerySnapshot>? _posts;

  // String query = "";
  // final _controller = new TextEditingController();
  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  // _buildUserTile(AccountHolder user) {
  //   return SearchUserTile(
  //       userName: user.userName!.toUpperCase(),
  //       profileHandle: user.profileHandle!,
  //       verified: user.verified,
  //       company: user.company!,
  //       profileImageUrl: user.profileImageUrl!,
  //       bio: user.bio!,
  //       score: user.score!,
  //       onPressed: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (_) => ProfileScreen(
  //                       currentUserId:
  //                           Provider.of<UserData>(context).currentUserId!,
  //                       userId: user.id!,
  //                     )));
  //       });
  // }

  // _clearSearch() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
  //   setState(() {
  //     _users = null;
  //   });
  // }

  // _clearPosts() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
  //   setState(() {
  //     _posts = null;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
            // title:
            //  Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Material(
            //     color: ConfigBloc().darkModeOn
            //         ? Color(0xFFf2f2f2)
            //         : Color(0xFF1a1a1a),
            //     elevation: 1.0,
            //     borderRadius: BorderRadius.all(Radius.circular(30.0)),
            //     child: TextField(
            //       autofocus: true,
            //       style: TextStyle(
            //         color:
            //             ConfigBloc().darkModeOn ? Colors.black : Colors.white,
            //       ),
            //       cursorColor: Colors.blue,
            //       controller: _controller,
            //       onChanged: (input) {
            //         setState(() {
            //           _users = DatabaseService.searchUsers(input.toUpperCase());
            //         });
            //       },

            //       // },
            //       decoration: InputDecoration(
            //         contentPadding:
            //             EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            //         border: InputBorder.none,
            //         hintText: 'Enter username',
            //         prefixIcon: Icon(
            //           Icons.search,
            //           size: 20.0,
            //           color:
            //               ConfigBloc().darkModeOn ? Colors.black : Colors.white,
            //         ),
            //         hintStyle: TextStyle(
            //           fontSize: 16.0,
            //           color: Colors.grey,
            //         ),
            //         suffixIcon: IconButton(
            //           icon: Icon(
            //             Icons.clear,
            //             size: 15.0,
            //             color: ConfigBloc().darkModeOn
            //                 ? Colors.black
            //                 : Colors.white,
            //           ),
            //           onPressed: _clearSearch,
            //         ),
            //       ),
            //       onSubmitted: (input) {
            //         if (input.isNotEmpty) {
            //           setState(() {
            //             _users =
            //                 DatabaseService.searchUsers(input.toUpperCase());
            //           });
            //         }
            //       },
            //     ),
            //   ),
            // ),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Search\nContent\n',
                            style: TextStyle(
                              fontSize: 20,
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        TextSpan(
                          text:
                              'Select a content category and start searching.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreSearchUsers(),
                          ),
                        ),
                        child: Container(
                          height: width / 2.3,
                          width: width / 2.3,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: Colors.grey,
                                size: 50,
                              ),
                              Text(
                                'Users',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreSearchPosts(),
                          ),
                        ),
                        child: Container(
                          height: width / 2.3,
                          width: width / 2.3,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 50,
                              ),
                              Text(
                                'Moods\npunched',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreSearchForum(),
                          ),
                        ),
                        child: Container(
                          height: width / 2.3,
                          width: width / 2.3,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.forum,
                                color: Colors.grey,
                                size: 50,
                              ),
                              Text(
                                'Forums',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreSearchEvents(),
                          ),
                        ),
                        child: Container(
                          height: width / 2.3,
                          width: width / 2.3,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event,
                                color: Colors.grey,
                                size: 50,
                              ),
                              Text(
                                'Events',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
          // GestureDetector(
          //   onTap: () => FocusScope.of(context).unfocus(),
          //   child: SafeArea(
          //     child: Container(
          //         // ignore: unnecessary_null_comparison
          //         child: _users == null
          //             ? Center(
          //                 child: NoContents(
          //                     title: "Searh for users. ",
          //                     subTitle:
          //                         'Enter username, \ndon\'t enter a user\'s nickname.',
          //                     icon: Icons.search))
          //             : FutureBuilder<QuerySnapshot>(
          //                 future: _users,
          //                 builder: (BuildContext context,
          //                     AsyncSnapshot<QuerySnapshot> snapshot) {
          //                   if (!snapshot.hasData) {
          //                     return SearchUserSchimmer();
          //                   }
          //                   if (snapshot.data!.docs.length == 0) {
          //                     return Center(
          //                       child: RichText(
          //                           text: TextSpan(
          //                         children: [
          //                           TextSpan(
          //                               text: "No users found. ",
          //                               style: TextStyle(
          //                                   fontSize: 20,
          //                                   fontWeight: FontWeight.bold,
          //                                   color: Colors.blueGrey)),
          //                           TextSpan(
          //                               text:
          //                                   '\nCheck username and try again.'),
          //                         ],
          //                         style: TextStyle(
          //                             fontSize: 14, color: Colors.grey),
          //                       )),
          //                     );
          //                   }
          //                   return Padding(
          //                     padding: const EdgeInsets.only(top: 30.0),
          //                     child: Scrollbar(
          //                       child: CustomScrollView(
          //                           physics:
          //                               const AlwaysScrollableScrollPhysics(),
          //                           slivers: [
          //                             SliverList(
          //                               delegate: SliverChildBuilderDelegate(
          //                                 (context, index) {
          //                                   AccountHolder? user =
          //                                       AccountHolder.fromDoc(
          //                                           snapshot.data!.docs[index]);
          //                                   return _buildUserTile(user);
          //                                 },
          //                                 childCount:
          //                                     snapshot.data!.docs.length,
          //                               ),
          //                             ),
          //                           ]),
          //                     ),
          //                   );
          //                 })),
          //   ),
          // ),

          ),
    );
  }
}
