import 'package:bars/utilities/exports.dart';
import 'package:flutter/rendering.dart';

class DjsLocation extends StatefulWidget {
  static final id = 'DjsLocation';
  final String currentUserId;
  final AccountHolder user;
  final String locationType;

  DjsLocation({
    required this.currentUserId,
    required this.user,
    required this.locationType,
  });
  @override
  _DjsLocationState createState() => _DjsLocationState();
}

class _DjsLocationState extends State<DjsLocation>
    with AutomaticKeepAliveClientMixin {
  List<AccountHolder> _userList = [];
  final _userSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    widget.locationType.startsWith('City')
        ? _setupUsers()
        : widget.locationType.startsWith('Country')
            ? setupCountryUsers()
            : widget.locationType.startsWith('Continent')
                ? _setupContinentUsers()
                : () {};
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
        widget.locationType.startsWith('City')
            ? _loadMoreUsers()
            : widget.locationType.startsWith('Country')
                ? _loadMoreCountryUsers()
                : widget.locationType.startsWith('Continent')
                    ? _loadMoreContinentUsers()
                    : () {};
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
        .where('profileHandle', isEqualTo: 'DJ')
        .where('city', isEqualTo: widget.user.city)
        .where('country', isEqualTo: widget.user.country)
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
        .where('profileHandle', isEqualTo: 'DJ')
        .where('city', isEqualTo: widget.user.city)
        .where('country', isEqualTo: widget.user.country)
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

  setupCountryUsers() async {
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: 'DJ')
        .where('country', isEqualTo: widget.user.country)
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

  _loadMoreCountryUsers() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: 'DJ')
        .where('country', isEqualTo: widget.user.country)
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

  _setupContinentUsers() async {
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: 'DJ')
        .where('continent', isEqualTo: widget.user.continent)
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

  _loadMoreContinentUsers() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: 'DJ')
        .where('continent', isEqualTo: widget.user.continent)
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
                          exploreLocation: widget.locationType,
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
                    title: 'DJs',
                  ),
                )
              : Center(
                  child: UserSchimmer(),
                ),
    );
  }
}
