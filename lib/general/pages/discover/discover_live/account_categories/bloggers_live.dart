import 'package:bars/utilities/exports.dart';

class BloggersLive extends StatefulWidget {
  static final id = 'BloggersLive';
  final String currentUserId;
  final String liveCity;
  final String liveCountry;
  final String exploreLocation;
  BloggersLive({
    required this.currentUserId,
    required this.liveCity,
    required this.liveCountry,
    required this.exploreLocation,
  });
  @override
  _BloggersLiveState createState() => _BloggersLiveState();
}

class _BloggersLiveState extends State<BloggersLive>
    with AutomaticKeepAliveClientMixin {
  List<AccountHolder> _userList = [];
  final _userSnapshot = <DocumentSnapshot>[];
 int limit = 5;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setupUsers();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreUsers();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setupUsers() async {
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle!', isEqualTo: 'Blogger')
        .where('city', isEqualTo: widget.liveCity)
        .limit(limit)
        .get();
    List<AccountHolder> users =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _userList = users;
      });
    }
    return users;
  }

  _loadMoreUsers() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle!', isEqualTo: 'Blogger')
        .where('country', isEqualTo: widget.liveCountry)
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();
    List<AccountHolder> moreusers =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    if (_userSnapshot.length < limit) _hasNext = false;
    List<AccountHolder> allusers = _userList..addAll(moreusers);
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _userList = allusers;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _buildUser() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scrollbar(
        controller: _hideButtonController,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _hideButtonController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  AccountHolder accountHolder = _userList[index];
                  return FutureBuilder(
                      future: DatabaseService.getUserWithId(accountHolder.id!),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return UserSchimmerSkeleton();
                        }
                        AccountHolder accountHolder = snapshot.data;

                        return UserView(
                          exploreLocation: widget.exploreLocation,
                          currentUserId: widget.currentUserId,
                          userId: accountHolder.id!,
                          user: accountHolder,
                        );
                      });
                },
                childCount: _userList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
      body: _userList.length > 0
          ? RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: () async {
                _setupUsers();
              },
              child: Padding(
                  padding: const EdgeInsets.only(top: 20), child: _buildUser()))
          : _userList.length == 0
              ? Center(
                  child: NoUsersDicovered(
                    title: 'Music\nBloggers',
                  ),
                )
              : Center(
                  child: UserSchimmer(),
                ),
    );
  }
}
