import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityAdviceScreen extends StatefulWidget {
  static final id = 'ActivityAdviceScreen';
  final String currentUserId;
  final int activityAdviceCount;
  ActivityAdviceScreen(
      {required this.currentUserId, required this.activityAdviceCount});

  @override
  _ActivityAdviceScreenState createState() => _ActivityAdviceScreenState();
}

class _ActivityAdviceScreenState extends State<ActivityAdviceScreen>
    with AutomaticKeepAliveClientMixin {
  List<ActivityAdvice> _activitiesAdvice = [];
  bool _isLoading = false;
  final _activitySnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setupActivities();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreActivities();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setupActivities() async {
    QuerySnapshot userFeedSnapShot = await activitiesAdviceRef
        .doc(widget.currentUserId)
        .collection('userActivitiesAdvice')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<ActivityAdvice> activities = userFeedSnapShot.docs
        .map((doc) => ActivityAdvice.fromDoc(doc))
        .toList();
    _activitySnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _activitiesAdvice = activities;
      });
    }
    return activities;
  }

  _loadMoreActivities() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await activitiesAdviceRef
        .doc(widget.currentUserId)
        .collection('userActivitiesAdvice')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_activitySnapshot.last)
        .get();
    List<ActivityAdvice> moreusers = userFeedSnapShot.docs
        .map((doc) => ActivityAdvice.fromDoc(doc))
        .toList();
    if (_activitySnapshot.length < limit) _hasNext = false;
    List<ActivityAdvice> activities = _activitiesAdvice..addAll(moreusers);
    _activitySnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _activitiesAdvice = activities;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _submit(activiitiesAdvice) async {
    ActivityAdvice activityAdvice = ActivityAdvice(
      id: activiitiesAdvice.id,
      fromUserId: activiitiesAdvice.fromUserId,
      seen: 'seen',
      userId: activiitiesAdvice.userId,
      advice: activiitiesAdvice.advice,
      timestamp: activiitiesAdvice.timestamp,
    );
    print('sumiting');
    try {
      DatabaseService.editActivityAdvice(activityAdvice, widget.currentUserId);
    } catch (e) {
      print(e.toString());
    }
  }

  _buildActivity(ActivityAdvice activityAdvice) {
    return FutureBuilder(
      future: DatabaseService.getUserWithId(activityAdvice.fromUserId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        AccountHolder user = snapshot.data;
        return ActivityTile(
          seen: activityAdvice.seen,
          verified: user.verified!,
          profileImageUrl: user.profileImageUrl!,
          activityIndicator: "adviced you: ",
          activityTitle: '',
          activityContent: activityAdvice.advice,
          activityTime: timeago.format(
            activityAdvice.timestamp.toDate(),
          ),
          userName: user.userName!,
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            String currentUserId =
                Provider.of<UserData>(context, listen: false).currentUserId!;
            AccountHolder user =
                await DatabaseService.getUserWithId(currentUserId);

            activityAdvice.seen != 'seen'
                ? _submit(activityAdvice)
                : SizedBox.shrink();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserAdviceScreen(
                  currentUserId: currentUserId,
                  user: user,
                ),
              ),
            );
            setState(() {
              _isLoading = false;
            });
          },
        );
      },
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.activityAdviceCount == 0
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        color: Colors.red),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 2, bottom: 2),
                      child: Text(
                        NumberFormat.compact()
                            .format(widget.activityAdviceCount),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Shimmer.fromColors(
                    period: Duration(milliseconds: 1000),
                    baseColor: Colors.grey,
                    highlightColor: Colors.blue,
                    child: RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(text: 'Fetching user please Wait... '),
                      ],
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    )),
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _setupActivities(),
              child: NotificationListener<ScrollNotification>(
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
                            ActivityAdvice activityAdvice =
                                _activitiesAdvice[index];

                            return _buildActivity(activityAdvice);
                          },
                          childCount: _activitiesAdvice.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
