import 'package:bars/utilities/exports.dart';
import 'package:bars/widgets/general_widget/loading_chats.dart';

class AffiliateCustomers extends StatefulWidget {
  static final id = 'AffiliateCustomers';
  final String userId;
  AffiliateCustomers({
    required this.userId,
  });

  @override
  _AffiliateCustomersState createState() => _AffiliateCustomersState();
}

class _AffiliateCustomersState extends State<AffiliateCustomers>
    with AutomaticKeepAliveClientMixin {
  List<AccountHolderAuthor?> _userList = [];
  final _userSnapshot = <DocumentSnapshot>[];
  int limit = 20;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setUpFollowing();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreFollowing();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setUpFollowing() async {
    QuerySnapshot userSnapShot = await userAffiliateBuyersRef
        .doc(widget.userId)
        .collection('buyers')
        .limit(limit)
        .get();
    // Map over snapshot documents and fetch user details
    List<AccountHolderAuthor?> users = [];
    for (var doc in userSnapShot.docs) {
      var userId = DocId.fromDoc(doc).userId;
      var user = await DatabaseService.getUserWithId(userId);
      users.add(user);
    }

    if (mounted) {
      // print(users.length.toString());
      setState(() {
        _hasNext = users.length ==
            limit; // Update hasNext based on fetched count and limit
        _userList = users;
        // _noUserIds = noUserId;
        print(_userList.length.toString());
      });
    }
    return users;
  }

  _loadMoreFollowing() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;

    QuerySnapshot userSnapShot = await userAffiliateBuyersRef
        .doc(widget.userId)
        .collection('buyers')
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();

    if (userSnapShot.docs.isEmpty) {
      _hasNext = false;
    } else {
      List<AccountHolderAuthor?> moreUsers = [];
      for (var doc in userSnapShot.docs) {
        var userId = DocId.fromDoc(doc).userId;
        var user = await DatabaseService.getUserWithId(userId);
        moreUsers.add(user);
      }
      // Update user list and snapshots
      _userList.addAll(moreUsers);
      _userSnapshot.addAll(userSnapShot.docs);
      _hasNext = userSnapShot.docs.length == limit;
    }

    if (mounted) {
      setState(() {});
    }

    _isFectchingUser = false;
    return _hasNext;
  }

  _buildUserTile(AccountHolderAuthor user) {
    return UserListTile(
        user: user,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        user: null,
                        currentUserId:
                            Provider.of<UserData>(context).currentUserId!,
                        userId: user.userId!,
                      )));
        });
  }

  _deleteAffiliateCustomers(String userId, bool isFollower) async {
    DocumentSnapshot doc = isFollower
        ? await followersRef
            .doc(widget.userId)
            .collection('new_chats')
            .doc(userId)
            .get()
        : await followingRef
            .doc(widget.userId)
            .collection('userFollowing')
            .doc(userId)
            .get();
    if (doc.exists) {
      await doc.reference.delete();
    }

    // Provide feedback to the user
    mySnackBar(context, 'Deleted successfully');

    // Consider additional UI updates or navigation aftxer deleting the chat.
    // For example, you might need to update the UI to reflect the chat has been deleted.
    setState(() {
      // Your logic to update the UI after deleting the chat
    });
  }

  _buildEventBuilder() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scrollbar(
        child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                AccountHolderAuthor? _user = _userList[index];
                return _user == null
                    ? LoadingChats(
                        deleted: true,
                        onPressed: () {},
                      )
                    : _buildUserTile(_user);
              },
              childCount: _userList.length,
            ),
          )
        ]),
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    super.build(context);
    return NestedScrollView(
      controller: _hideButtonController,
      headerSliverBuilder: (context, innerBoxScrolled) => [
        SliverAppBar(
          elevation: 0.0,
          automaticallyImplyLeading: true,
          floating: true,
          snap: true,
          pinned: true,
          iconTheme: new IconThemeData(
            color: Theme.of(context).secondaryHeaderColor,
          ),
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text(
            'Referred attendees',
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ],
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: Theme.of(context).primaryColorLight,
          child: SafeArea(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaleFactor:
                      MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.userId == _provider.currentUserId)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "These are attendees who purchase a ticket using your affiliate link.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: _userList.isNotEmpty
                        ? _buildEventBuilder()
                        : Center(child: FollowUserSchimmer()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
