import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class ProfileRating extends StatefulWidget {
  final String currentUserId;
  final AccountHolder user;
  ProfileRating({
    required this.user,
    required this.currentUserId,
  });

  @override
  _ProfileRatingState createState() => _ProfileRatingState();
}

class _ProfileRatingState extends State<ProfileRating> {
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
  }

  _unPossitivelyRateUser() {
    DatabaseService.unPossitivelyRateUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _isRatingUserPossitively = false;
        _possitiveRatedCount--;
      });
    }
  }

  _unNegativelyRateUser() {
    DatabaseService.unNegativelyRateUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _isRatingUserNegatively = false;
        _negativeRatedCount--;
      });
    }
  }

  _possitivelyRateUser() {
    DatabaseService.possitivelyRateUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _isRatingUserPossitively = true;
        _possitiveRatedCount++;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Rating ' + widget.user.userName! + ' + 1',
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _negativelyRateUser() {
    DatabaseService.negativelyRateUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.id!,
    );
    if (mounted) {
      setState(() {
        _isRatingUserNegatively = true;
        _negativeRatedCount++;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Rating ' + widget.user.userName! + ' - 1',
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _buildHowYouRateForYou(AccountHolder user) {
    String currentUserId = Provider.of<UserData>(context).currentUserId!;
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
              widget.user.id! == currentUserId
                  ? '${widget.user.name} you can tap below to see people you have rated. This information is not displayed to other people.'
                  : 'This is how ${widget.user.name} has rated people.',
              style: TextStyle(
                fontSize: 14,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            height: width / 3,
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () => widget.user.id == currentUserId
                            ? _possitiveRatingCount == 0
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NoAccountList(
                                            follower: 'Positive')))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PossitiveRating(
                                              currentUserId:
                                                  widget.currentUserId,
                                              user: widget.user,
                                            )))
                            : {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              NumberFormat.compact()
                                  .format(_possitiveRatingCount),
                              style: TextStyle(
                                color: widget.user.id == currentUserId
                                    ? Colors.blue
                                    : ConfigBloc().darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Positively \nRatings',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListviewDivider(),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () => widget.user.id == currentUserId
                            ? _possitiveRatingCount == 0
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NoAccountList(
                                            follower: 'Negative')))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NegativelyRating(
                                              user: widget.user,
                                              currentUserId:
                                                  widget.currentUserId,
                                            )))
                            : {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              NumberFormat.compact()
                                  .format(_negativeRatingCount),
                              style: TextStyle(
                                color: widget.user.id == currentUserId
                                    ? Colors.blue
                                    : ConfigBloc().darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Negatively \nRatings',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = Provider.of<UserData>(context).currentUserId!;
    int _point = _possitiveRatedCount - _negativeRatedCount;
    int _total = _possitiveRatedCount + _negativeRatedCount;

    usersRef.doc(widget.user.id).update({'score': _point});

    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor: Color(0xFF1a1a1a),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFF1a1a1a),
          title: Material(
            color: Colors.transparent,
            child: Text(
              ' ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.star,
                          color: Color(0xFF1a1a1a),
                          size: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Rating \nInformation',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16.0, height: 1),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 10),
                        blurRadius: 10.0,
                        spreadRadius: 4.0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.user.profileHandle!.startsWith('F') ||
                                widget.user.profileHandle!.isEmpty
                            ? SizedBox.shrink()
                            : RichText(
                                textScaleFactor: MediaQuery.of(context)
                                    .textScaleFactor
                                    .clamp(0.5, 1.5),
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          NumberFormat.compact().format(_point),
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: "\nBars score. ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      )),
                                  TextSpan(
                                      text:
                                          "\nBased on ${_point.toString()} ratings. ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      )),
                                ])),
                        widget.user.profileHandle!.startsWith('F') ||
                                widget.user.profileHandle!.isEmpty
                            ? SizedBox.shrink()
                            : Hero(
                                tag: 'userStar',
                                child: Stars(
                                  score: widget.user.score!,
                                ),
                              ),
                        SizedBox(
                          height: 40,
                        ),
                        widget.user.profileHandle!.startsWith('F') ||
                                widget.user.profileHandle!.isEmpty
                            ? SizedBox.shrink()
                            : Text(
                                widget.user.id == currentUserId
                                    ? '${widget.user.name} this is how people rate you'
                                    : 'This is how people rate ${widget.user.name} ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                )),
                        widget.user.profileHandle!.startsWith('F') ||
                                widget.user.profileHandle!.isEmpty
                            ? SizedBox.shrink()
                            : Padding(
                                padding:
                                    EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                                child: Table(
                                  border: TableBorder.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                  children: [
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20),
                                        child: Text(
                                          'Posstively Rated',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20),
                                        child: Text(
                                          NumberFormat.compact()
                                              .format(_possitiveRatedCount),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20),
                                        child: Text(
                                          'Negatively Rated',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20),
                                        child: Text(
                                          NumberFormat.compact()
                                              .format(_negativeRatedCount),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20),
                                        child: Text(
                                          'Total Rate',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20),
                                        child: Text(
                                          NumberFormat.compact().format(_total),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildHowYouRateForYou(widget.user),
                        SizedBox(
                          height: 50,
                        ),
                        widget.user.profileHandle!.startsWith('F') ||
                                widget.user.profileHandle!.isEmpty
                            ? SizedBox.shrink()
                            : widget.user.id == currentUserId
                                ? SizedBox.shrink()
                                : Text(
                                    "You can rate ${widget.user.name} by adding or subtracting to ${widget.user.name}'s stars when you press the buttons below. When you find ${widget.user.name}'s page interesting and ${widget.user.name}'s works creative enough, you may add to ${widget.user.name}'s stars else you may do otherwise. Please rate wisely and honestly.",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                color: Colors.blue, height: 1.5, width: 50),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        widget.user.profileHandle!.startsWith('F') ||
                                widget.user.profileHandle!.isEmpty
                            ? SizedBox.shrink()
                            : widget.user.id == currentUserId
                                ? SizedBox.shrink()
                                : Row(
                                    children: [
                                      Column(
                                        children: [
                                          CircularButton(
                                              color:
                                                  !_isRatingUserPossitively &&
                                                          ConfigBloc()
                                                              .darkModeOn
                                                      ? Colors.white
                                                      : _isRatingUserPossitively
                                                          ? Colors.yellow[800]!
                                                          : Colors.white,
                                              icon: Icon(
                                                Icons.star,
                                                color: _isRatingUserPossitively
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                HapticFeedback.heavyImpact();
                                                if (_isRatingUserPossitively) {
                                                  setState(() {
                                                    _unPossitivelyRateUser();
                                                  });
                                                } else {
                                                  _possitivelyRateUser();
                                                }

                                                if (_isRatingUserNegatively) {
                                                  setState(() {
                                                    _unNegativelyRateUser();
                                                  });
                                                }
                                              }),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            _isRatingUserPossitively
                                                ? 'undo'
                                                : '+ Star',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Column(
                                        children: [
                                          CircularButton(
                                              color: !_isRatingUserNegatively &&
                                                      ConfigBloc().darkModeOn
                                                  ? Colors.white
                                                  : _isRatingUserNegatively
                                                      ? Colors.blue[800]!
                                                      : Colors.white,
                                              icon: Icon(
                                                Icons.star_border,
                                                color: _isRatingUserNegatively
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                HapticFeedback.heavyImpact();
                                                if (_isRatingUserNegatively) {
                                                  setState(() {
                                                    _unNegativelyRateUser();
                                                  });
                                                } else {
                                                  _negativelyRateUser();
                                                }

                                                if (_isRatingUserPossitively) {
                                                  setState(() {
                                                    _unPossitivelyRateUser();
                                                  });
                                                }
                                              }),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            _isRatingUserNegatively
                                                ? 'undo'
                                                : '- Star',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                        SizedBox(
                          height: 30,
                        ),
                        widget.user.profileHandle!.startsWith('F') ||
                                widget.user.profileHandle!.isEmpty
                            ? SizedBox.shrink()
                            : GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => UserAdviceScreen(
                                              currentUserId:
                                                  widget.currentUserId,
                                              user: widget.user,
                                            ))),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      widget.user.id == currentUserId
                                          ? SizedBox.shrink()
                                          : CircularButton(
                                              onPressed: () {},
                                              color: Colors.blue,
                                              icon: Icon(
                                                Icons.comment,
                                                color: Colors.white,
                                              ),
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      widget.user.profileHandle!
                                                  .startsWith('F') |
                                              widget.user.profileHandle!.isEmpty
                                          ? SizedBox.shrink()
                                          : GestureDetector(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          UserAdviceScreen(
                                                            currentUserId: widget
                                                                .currentUserId,
                                                            user: widget.user,
                                                          ))),
                                              child: Material(
                                                  color: Colors.transparent,
                                                  child: Text(
                                                    widget.user.id ==
                                                            currentUserId
                                                        ? 'see advices'
                                                        : 'Leave an advice for \n ${widget.user.name}',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ))),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        SizedBox(height: 40),
                        GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SuggestionBox())),
                            child: Material(
                                color: Colors.transparent,
                                child: Text('Suggestion Box',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 12,
                                    )))),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
