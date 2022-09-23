import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';

class RecordLabels extends StatefulWidget {
  static final id = 'RecordLabels';
  final String currentUserId;
  final String exploreLocation;

  RecordLabels({
    required this.currentUserId,
    required this.exploreLocation,
  });
  @override
  _RecordLabelsState createState() => _RecordLabelsState();
}

class _RecordLabelsState extends State<RecordLabels>
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
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        Provider.of<UserData>(context, listen: false).setShowUsersTab(true);
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        Provider.of<UserData>(context, listen: false).setShowUsersTab(false);
      }
    });
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
        .where('profileHandle', isEqualTo: 'Record_Label')
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
        .where('profileHandle', isEqualTo: 'Record_Label')
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 800),
        backgroundColor:
            ConfigBloc().darkModeOn ? Colors.grey[800] :  Color(0xFFf2f2f2),
        content: SizedBox(
            height: 15,
            child: Text(
              'Loading...',
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ))));
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
          ? Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: RefreshIndicator(
                backgroundColor: Colors.white,
                onRefresh: () async {
                  _setupUsers();
                },
                child: _buildUser(),
              ),
            )
          : _userList.length == 0
              ? Center(
                  child: SizedBox.shrink(),
                )
              : Center(
                  child: UserSchimmer(),
                ),
    );
  }
}
