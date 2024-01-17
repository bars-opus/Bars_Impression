// import 'package:bars/utilities/exports.dart';

// class FansScreen extends StatefulWidget {
//   static final id = 'FansScreen';
//   final String currentUserId;
//   final String exploreLocation;

//   FansScreen({
//     required this.currentUserId,
//     required this.exploreLocation,
//   });
//   @override
//   _FansScreenState createState() => _FansScreenState();
// }

// class _FansScreenState extends State<FansScreen> with AutomaticKeepAliveClientMixin {
//   List<AccountHolderAuthor> _userList = [];
//   final _userSnapshot = <DocumentSnapshot>[];
//   int limit = 5;
//   bool _hasNext = true;
//   bool _isFectchingUser = false;
//   late ScrollController _hideButtonController;

//   @override
//   void initState() {
//     super.initState();
//     _setupUsers();
//     _hideButtonController = ScrollController();
//     _hideButtonController.addListener(() {
//       if (_hideButtonController.position.userScrollDirection ==
//           ScrollDirection.forward) {
//         Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
//       }
//       if (_hideButtonController.position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         Provider.of<UserData>(context, listen: false).setShowUsersTab(false);
//       }
//     });
//   }

//   bool _handleScrollNotification(ScrollNotification notification) {
//     if (notification is ScrollEndNotification) {
//       if (_hideButtonController.position.extentAfter == 0) {
//         _loadMoreUsers();
//       }
//     }
//     return false;
//   }

//   @override
//   void dispose() {
//     _hideButtonController.dispose();
//     super.dispose();
//   }

//   _setupUsers() async {
//     QuerySnapshot userFeedSnapShot = await usersAuthorRef
//         .where('profileHandle', isEqualTo: 'Fan')
//         .where('dontShowContentOnExplorePage', isEqualTo: true)
//         .limit(limit)
//         .get();
//     List<AccountHolderAuthor> users = userFeedSnapShot.docs
//         .map((doc) => AccountHolderAuthor.fromDoc(doc))
//         .toList()
//       ..shuffle();
//     _userSnapshot.addAll((userFeedSnapShot.docs));
//     if (mounted) {
//       setState(() {
//         _hasNext = false;
//         _userList = users;
//       });
//     }
//     return users;
//   }

//   _loadMoreUsers() async {
//     if (_isFectchingUser) return;
//     _isFectchingUser = true;
//     QuerySnapshot userFeedSnapShot = await usersAuthorRef
//         .where('profileHandle', isEqualTo: 'Fan')
//         .where('dontShowContentOnExplorePage', isEqualTo: true)
//         .limit(limit)
//         .startAfterDocument(_userSnapshot.last)
//         .get();
//     List<AccountHolderAuthor> moreusers = userFeedSnapShot.docs
//         .map((doc) => AccountHolderAuthor.fromDoc(doc))
//         .toList()
//       ..shuffle();
//     if (_userSnapshot.length < limit) _hasNext = false;
//     List<AccountHolderAuthor> allusers = _userList..addAll(moreusers);
//     _userSnapshot.addAll((userFeedSnapShot.docs));
//     if (mounted) {
//       setState(() {
//         _userList = allusers;
//       });
//     }
//     _hasNext = false;
//     _isFectchingUser = false;

//     return _hasNext;
//   }

//   _buildUser() {
//     return NotificationListener<ScrollNotification>(
//       onNotification: _handleScrollNotification,
//       child: Scrollbar(
//         controller: _hideButtonController,
//         child: CustomScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           controller: _hideButtonController,
//           slivers: [
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   AccountHolderAuthor accountHolder = _userList[index];
//                   return Placeholder();

//                   // UserView(
//                   //   userSnapshot: _userSnapshot,
//                   //   userList: _userList,
//                   //   currentUserId: widget.currentUserId,
//                   //   userId: accountHolder.id!,
//                   //   user: accountHolder,
//                   //   pageIndex: 0,
//                   // );
//                 },
//                 childCount: _userList.length,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool get wantKeepAlive => true;
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: _userList.length > 0
//           ? Padding(
//               padding: const EdgeInsets.only(top: 20.0),
//               child: RefreshIndicator(
//                 backgroundColor: Colors.white,
//                 onRefresh: () async {
//                   _setupUsers();
//                 },
//                 child: _buildUser(),
//               ),
//             )
//           : _userList.length == 0
//               ? Center(child: const SizedBox.shrink())
//               : Center(
//                   child: EventAndUserScimmer(
//                     from: 'User',
//                     showWithoutSegment: false,
//                   ),
//                 ),
//     );
//   }
// }
