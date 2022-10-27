import 'package:bars/utilities/exports.dart';

class ProfileProfessionalProfile extends StatefulWidget {
  final String currentUserId;
  final AccountHolder user;

  final String userId;
  ProfileProfessionalProfile({
    required this.user,
    required this.userId,
    required this.currentUserId,
  });

  @override
  _ProfileProfessionalProfileState createState() =>
      _ProfileProfessionalProfileState();
}

class _ProfileProfessionalProfileState
    extends State<ProfileProfessionalProfile> {
  bool _isRatingUserPossitively = false;
  int _possitiveRatedCount = 0;
  int _possitiveRatingCount = 0;
  bool _isRatingUserNegatively = false;
  int _negativeRatedCount = 0;
  int _negativeRatingCount = 0;

  void initState() {
    super.initState();
    _setUpIsPossitivelyRating();
    _setUpPossitiveRated();
    _setUpPossitiveRating();
    _setUpIsNegativelyRating();
    _setUpNegativeRated();
    _setUpNegativeRating();
  }

  _setUpIsPossitivelyRating() async {
    bool isRattingUserPossitively =
        await DatabaseService.isPossitivelyRatingUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _isRatingUserPossitively = isRattingUserPossitively;
      });
    }
    return _isRatingUserPossitively;
  }

  _setUpIsNegativelyRating() async {
    bool isRattingUserNegatively = await DatabaseService.isNegativelyRatingUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _isRatingUserNegatively = isRattingUserNegatively;
      });
    }
    return _isRatingUserNegatively;
  }

  _setUpPossitiveRated() async {
    int userPossitiveRatedCount = await DatabaseService.numPosstiveRated(
      widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _possitiveRatedCount = userPossitiveRatedCount;
      });
    }
    return _possitiveRatedCount;
  }

  _setUpNegativeRated() async {
    int userNegativeRatedCount = await DatabaseService.numNegativeRated(
      widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _negativeRatedCount = userNegativeRatedCount;
      });
    }
    return _negativeRatedCount;
  }

  _setUpPossitiveRating() async {
    int userPossitiveRatingCount = await DatabaseService.numPossitiveRating(
      widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _possitiveRatingCount = userPossitiveRatingCount;
      });
    }
    return _possitiveRatingCount;
  }

  _setUpNegativeRating() async {
    int userNegativeRatingCount = await DatabaseService.numNegativeRating(
      widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _negativeRatingCount = userNegativeRatingCount;
      });
    }
    return _negativeRatingCount;
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = Provider.of<UserData>(context).currentUserId!;
    int _point = _possitiveRatedCount - _negativeRatedCount;
    int _total = _possitiveRatedCount + _negativeRatedCount;

    usersRef.doc(widget.user.id).update({'score': _point});

    return UserProfessionalViewWidget(
      workHero: 'work' + widget.user.id.toString(),
      containerHero1: 'container1' + widget.user.id.toString(),
      exploreWidget: const SizedBox.shrink(),
      user: widget.user,
      point: _point,
      userTotal: _total,
      currentUserId: currentUserId,
      onPressedRating: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileRating(
                    user: widget.user,
                    currentUserId: widget.currentUserId,
                  ))),
    );
  }
}
