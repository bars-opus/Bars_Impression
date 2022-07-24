import 'package:bars/utilities/exports.dart';

class PossitiveRating extends StatefulWidget {
  static final id = 'PossitiveRating';
  final String currentUserId;
  final AccountHolder? user;

  PossitiveRating({required this.currentUserId, required this.user});

  @override
  _PossitiveRatingState createState() => _PossitiveRatingState();
}

class _PossitiveRatingState extends State<PossitiveRating> {
  List<DocId> _users = [];
  int limit = 15;
  int limitBlog = 10;
  bool _isFetchingUsers = false;
  final _userSnapshot = <DocumentSnapshot>[];
  final _hideButtonController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setUpFeed();
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  void scrollListerner() {
    if (_hideButtonController.offset >=
            _hideButtonController.position.maxScrollExtent / 2 &&
        !_hideButtonController.position.outOfRange) {
      _loadMoreUsers();
    }
  }

  _setUpFeed() async {
    QuerySnapshot userSnapShot = await possitiveRatingRef
        .doc(widget.currentUserId)
        .collection('userPossitiveRating')
        .limit(limit)
        .get();
    List<DocId> users =
        userSnapShot.docs.map((doc) => DocId.fromDoc(doc)).toList();
    _userSnapshot.addAll((userSnapShot.docs));
    if (mounted) {
      setState(() {
        _users = users;
      });
    }
    return users;
  }

  _loadMoreUsers() async {
    if (_isFetchingUsers) return;
    _isFetchingUsers = true;
    QuerySnapshot userSnapShot = await possitiveRatingRef
        .doc(widget.currentUserId)
        .collection('userPossitiveRating')
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();
    List<DocId> moreusers =
        userSnapShot.docs.map((doc) => DocId.fromDoc(doc)).toList();
    List<DocId> allusers = _users..addAll(moreusers);
    _userSnapshot.addAll((userSnapShot.docs));
    if (mounted) {
      setState(() {
        _users = allusers;
      });
    }
  }

  _buildUserTile(AccountHolder user) {
    return UserListTile(
        user: user,
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
    return Scaffold(
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
          title: Text(
            'Possitively Rating',
            style: TextStyle(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Expanded(
                  child: _users.length > 0
                      ? Scrollbar(
                          child: CustomScrollView(slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                DocId user = _users[index];
                                return FutureBuilder(
                                  future:
                                      DatabaseService.getUserWithId(user.uid),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return FollowerUserSchimmerSkeleton();
                                    }
                                    AccountHolder user = snapshot.data;
                                    return _users.length == 0
                                        ? Expanded(
                                            child: Center(
                                              child: NoContents(
                                                icon: (Icons.people_outline),
                                                title: 'No Rating,',
                                                subTitle:
                                                    'You have not rated anybody negatively. ',
                                              ),
                                            ),
                                          )
                                        : _buildUserTile(user);
                                  },
                                );
                              },
                              childCount: _users.length,
                            ),
                          )
                        ]))
                      : FollowUserSchimmer())
            ]));
  }
}
