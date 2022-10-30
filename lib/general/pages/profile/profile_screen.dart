import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:bars/utilities/exports.dart';
import 'package:bars/widgets/general_widget/punch_expanded_profile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  static final id = 'Profile_screen';
  final String userId;
  ProfileScreen({required this.currentUserId, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _isFollowing = false;
  bool _isAFollower = false;
  bool _isBlockedUser = false;
  bool _isBlockingUser = false;
  int _followerCount = 0;
  int _followingCount = 0;
  int pointCoint = 0;
  List<Post> _posts = [];
  List<Forum> _forums = [];
  List<Event> _events = [];
  late AccountHolder _profileUser;
  int _moodPunched = 0;
  int _negativeRatedCount = 0;
  int _possitiveRatedCount = 0;
  int _artistFavoriteCount = 0;
  int _artistPunch = 0;
  double coseTope = 10;

  @override
  void initState() {
    super.initState();
    widget.userId.isEmpty ? () {} : setUp();
  }

  setUp() {
    _setupIsFollowing();
    _setUpFollowers();
    _setUpFollowing();
    _setupIsBlockedUser();
    _setupIsBlocking();
    _setupIsAFollowerUser();
    _setupPosts();
    _setUpForums();
    _setUpEvents();
    _setUpPossitiveRated();
    _setUpNegativeRated();
    _setUpProfileUser();
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );

    if (mounted) {
      setState(() {
        _isFollowing = isFollowingUser;
      });
    }
  }

  _setupIsAFollowerUser() async {
    bool isAFollower = await DatabaseService.isAFollowerUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isAFollower = isAFollower;
      });
    }
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
  }

  _setupIsBlocking() async {
    bool isBlockingUser = await DatabaseService.isBlokingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = isBlockingUser;
      });
    }
  }

  _setUpFollowers() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    if (mounted) {
      setState(() {
        _followerCount = userFollowerCount;
      });
    }
  }

  _setUpFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    if (mounted) {
      setState(() {
        _followingCount = userFollowingCount;
      });
    }
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.userId);
    if (mounted) {
      setState(() {
        _posts = posts;
      });
    }
  }

  _setUpForums() async {
    List<Forum> forums = await DatabaseService.getUserForums(widget.userId);
    if (mounted) {
      setState(() {
        _forums = forums;
      });
    }
  }

  _setUpEvents() async {
    List<Event> events = await DatabaseService.getUserEvents(widget.userId);
    if (mounted) {
      setState(() {
        _events = events;
      });
    }
  }

  _setUpProfileUser() async {
    AccountHolder profileUser =
        await DatabaseService.getUserWithId(widget.userId);
    if (mounted) {
      setState(() {
        _profileUser = profileUser;
      });
    }
  }

  _followOrUnfollow(AccountHolder user) {
    HapticFeedback.heavyImpact();
    if (_isFollowing) {
      _showSelectImageDialog2(user, 'unfollow');
    } else {
      _followUser(user);
    }
  }

  _blockOrUnBlock(AccountHolder user) {
    HapticFeedback.heavyImpact();
    if (_isBlockingUser) {
      _showSelectImageDialog2(user, 'unBlock');
    } else {
      _showSelectImageDialog2(user, 'block');
    }
  }

  _unBlockser(AccountHolder user) {
    DatabaseService.unBlockUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = false;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'unBlocked ' + user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _blockser(AccountHolder user) async {
    AccountHolder fromUser =
        await DatabaseService.getUserWithId(widget.currentUserId);
    DatabaseService.blockUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
      user: fromUser,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = true;
      });
    }
    if (_isAFollower) {
      DatabaseService.unfollowUser(
        currentUserId: widget.userId,
        userId: widget.currentUserId,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color(0xFFD38B41),
      content: Text(
        'Blocked ' + user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _setUpPossitiveRated() async {
    int userPossitiveRatedCount =
        await DatabaseService.numPosstiveRated(widget.userId);
    if (mounted) {
      setState(() {
        _possitiveRatedCount = userPossitiveRatedCount;
      });
    }
  }

  _setUpNegativeRated() async {
    int userNegativeRatedCount =
        await DatabaseService.numNegativeRated(widget.userId);
    if (mounted) {
      setState(() {
        _negativeRatedCount = userNegativeRatedCount;
      });
    }
  }

  _unfollowUser(AccountHolder user) {
    DatabaseService.unfollowUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isFollowing = false;
        _followerCount--;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Unfollowed ' + user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _followUser(AccountHolder user) async {
    DatabaseService.followUser(
      currentUserId: widget.currentUserId,
      user: user,
    );

    if (mounted) {
      setState(() {
        _isFollowing = true;
        _followerCount++;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color(0xFFD38B41),
      content: Text(
        'Followed ' + user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _displayButton(AccountHolder user, int point) {
    final width = MediaQuery.of(context).size.width;
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Padding(
            padding: EdgeInsets.fromLTRB(
              20.0,
              30.0,
              20.0,
              10.0,
            ),
            child: Column(
              children: <Widget>[
                user.userName!.isEmpty
                    ? const SizedBox.shrink()
                    : user.score!.isNegative
                        ? _displayBannnedUploadNote(user)
                        : Wrap(
                            direction: Axis.vertical,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: width > 600
                                        ? 200
                                        : width < 400
                                            ? 120
                                            : 150.0,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: ConfigBloc().darkModeOn
                                            ? Colors.blueGrey[100]
                                            : Colors.white,
                                        onPrimary: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CreatePost(
                                              // user: user,
                                              ),
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          'Punch',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: width > 600 ? 20 : 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: width > 600
                                        ? 200
                                        : width < 400
                                            ? 120
                                            : 150.0,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: ConfigBloc().darkModeOn
                                            ? Colors.blueGrey[100]
                                            : Colors.white,
                                        onPrimary: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CreateContents(
                                            user: user,
                                          ),
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          'Create',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: width > 600 ? 20 : 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ],
                          ),
                user.id == Provider.of<UserData>(context).currentUserId
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          user.userName!.isEmpty
                              ? GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditProfileScreen(
                                          user: user,
                                        ),
                                      )),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "Hello ${user.name},",
                                            style: TextStyle(
                                              fontSize: width > 800 ? 14 : 12,
                                              color: Colors.blue,
                                            )),
                                        TextSpan(
                                            text:
                                                '\nYou registered with a nickname, please tap on edit profile below to choose your username, select an account type and to provide the necessary information to set up your profile. Without your username, you cannot be discovered on the discover page, you cannot punch your mood, create a blog, forum, or event.',
                                            style: TextStyle(
                                              fontSize: width > 800 ? 14 : 12,
                                              color: Colors.blue,
                                            )),
                                        TextSpan(
                                            text:
                                                '\n\nPlease note that all usernames on this platform are converted to uppercase.',
                                            style: TextStyle(
                                              fontSize: width > 800 ? 14 : 12,
                                              color: Colors.blue,
                                            )),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          SizedBox(
                            height: 30.0,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfileScreen(
                                    user: user,
                                  ),
                                )),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                user.userName!.isEmpty
                                    ? AvatarGlow(
                                        animate: true,
                                        showTwoGlows: true,
                                        shape: BoxShape.circle,
                                        glowColor: Colors.blue,
                                        endRadius: 30,
                                        duration:
                                            const Duration(milliseconds: 2000),
                                        repeatPauseDuration:
                                            const Duration(milliseconds: 3000),
                                        child: Container())
                                    : const SizedBox.shrink(),
                                Container(
                                    width: 200,
                                    color: Colors.transparent,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Edit Profile',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: width > 600 ? 14 : 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            ))
        : Padding(
            padding: EdgeInsets.fromLTRB(
              20.0,
              30.0,
              20.0,
              20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: _isFollowing ? Colors.grey : Color(0xFFD38B41),
                      onPrimary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () => _followOrUnfollow(user),
                    child: Text(
                      _isFollowing ? ' unfollow' : 'follow',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: _isFollowing ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

//  Navigator.push(
//                 context,
//                 PageRouteBuilder(
//                   pageBuilder: (context, animation1, animation2) =>
//                       AllPostEnlarged(
//                     feed: 'Profile',
//                     currentUserId: widget.currentUserId,
//                     post: post,
//                     author: _profileUser,
//                   ),
//                   transitionDuration: Duration(seconds: 0),
//                 ),
//               ),

  Widget buildBlur({
    required Widget child,
    double sigmaX = 10,
    double sigmaY = 10,
    BorderRadius? borderRadius,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );
  _buildTilePost(Post post) {
    final width = MediaQuery.of(context).size.width;
    return GridTile(
        child: Tooltip(
      showDuration: Duration(seconds: 10),
      padding: EdgeInsets.all(20.0),
      message: post.punch + '\n\n' + post.caption,
      child: Stack(alignment: FractionalOffset.center, children: <Widget>[
        OpenContainer(
          openColor: ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Colors.white,
          closedColor:
              ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Colors.white,
          transitionType: ContainerTransitionType.fade,
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return Stack(alignment: Alignment.center, children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: ConfigBloc().darkModeOn
                      ? Color(0xFF1f2022)
                      : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: CachedNetworkImageProvider(post.imageUrl),
                      fit: BoxFit.cover,
                    )),
                    child: post.report.isNotEmpty
                        ? buildBlur(
                            borderRadius: BorderRadius.circular(0),
                            child: Container(
                              color: Colors.black.withOpacity(.8),
                            ))
                        : Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    colors: [
                                  Colors.black.withOpacity(.7),
                                  Colors.black.withOpacity(.7),
                                ])),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: width > 600 ? 150 : 100.0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 1.0),
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: post.report.isNotEmpty
                              ? Alignment.center
                              : Alignment.bottomCenter,
                          child: post.report.isNotEmpty
                              ? Icon(
                                  MdiIcons.eyeOff,
                                  color: Colors.grey,
                                  size: 30.0,
                                )
                              : Text(
                                  ' " ${post.punch} " '.toLowerCase(),
                                  style: TextStyle(
                                    fontSize: width > 600 ? 16 : 12.0,
                                    color: Colors.white,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 3),
                                        blurRadius: 2.0,
                                        spreadRadius: 1.0,
                                      )
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 7,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ),
                      SizedBox(height: 3.0),
                      SizedBox(height: 2.0),
                      post.report.isNotEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 2.0,
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 3.0),
                                    child: Text(
                                      ' @ ${post.artist} ',
                                      style: TextStyle(
                                        fontSize: 5.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ]),
              )
            ]);
          },
          openBuilder: (BuildContext context,
              void Function({Object? returnValue}) action) {
            return PunchExpandedProfileWidget(
              author: _profileUser,
              feed: 'Profile',
              currentUserId: widget.currentUserId,
              post: post,
            );
          },
        )
      ]),
    ));
  }

  _buildMusicPreference(AccountHolder user) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProfileMusicPref(
                      user: user,
                      currentUserId: widget.currentUserId,
                    ))),
        child: Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 0.5,
          ),
          children: [
            TableRow(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  'Favorite Musician',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  user.favouriteArtist!,
                  style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  'Favorite Song',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  user.favouriteSong!,
                  style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  'Favorite Album',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  user.favouriteAlbum!,
                  style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  _buildStatistics(AccountHolder user) {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    return Container(
      color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
      height: 150.0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
        child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              UserStatistics(
                count: NumberFormat.compact().format(_followerCount),
                countColor: user.id != currentUserId
                    ? Colors.grey
                    : ConfigBloc().darkModeOn
                        ? Colors.white
                        : Colors.black,
                titleColor: user.id != currentUserId
                    ? Colors.grey
                    : ConfigBloc().darkModeOn
                        ? Colors.white
                        : Colors.black,
                onPressed: () => user.id == currentUserId
                    ? _followerCount == 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => NoAccountList(
                                      follower: 'Follower',
                                    )))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FollowerFollowing(
                                      currentUserId: currentUserId,
                                      followerCount: _followerCount,
                                      followingCount: _followingCount,
                                      follower: 'Follower',
                                    )))
                    : () {},
                title: 'Followers',
                subTitle: 'The number of accounts following you.',
              ),
              ListviewDivider(),
              UserStatistics(
                countColor: user.id != currentUserId
                    ? Colors.grey
                    : ConfigBloc().darkModeOn
                        ? Colors.white
                        : Colors.black,
                titleColor: user.id != currentUserId
                    ? Colors.grey
                    : ConfigBloc().darkModeOn
                        ? Colors.white
                        : Colors.black,
                count: NumberFormat.compact().format(_followingCount),
                onPressed: () => user.id == currentUserId
                    ? _followingCount == 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => NoAccountList(
                                      follower: 'Following',
                                    )))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FollowerFollowing(
                                      followerCount: _followerCount,
                                      currentUserId: currentUserId,
                                      followingCount: _followingCount,
                                      follower: 'Following',
                                    )))
                    : () {},
                title: 'Following',
                subTitle: 'The number of accounts you are following.',
              ),
              ListviewDivider(),
              UserStatistics(
                countColor: Colors.grey,
                titleColor: Colors.grey,
                count: NumberFormat.compact().format(_posts.length.toDouble()),
                onPressed: () => setState(() {
                  _moodPunched = 0;
                }),
                title: 'Moods Punched',
                subTitle: "The number of moods you've punched.",
              ),
              ListviewDivider(),
              UserStatistics(
                countColor: Colors.grey,
                titleColor: Colors.grey,
                count: NumberFormat.compact().format(_forums.length.toDouble()),
                onPressed: () => setState(() {
                  _moodPunched = 1;
                }),
                title: 'Forums',
                subTitle: "The number of forums you've published.",
              ),
              ListviewDivider(),
              UserStatistics(
                countColor: Colors.grey,
                titleColor: Colors.grey,
                count: NumberFormat.compact().format(_events.length.toDouble()),
                onPressed: () => setState(() {
                  _moodPunched = 2;
                }),
                title: 'Events',
                subTitle: "The number of events you've published.",
              ),
            ]),
      ),
    );
  }

  _buildArtistStatistics(AccountHolder user) {
    return Container(
      color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
      height: MediaQuery.of(context).textScaleFactor > 1.2 ? 200 : 150.0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
        child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              UserStatistics(
                countColor:
                    ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                titleColor:
                    ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                count: NumberFormat.compact().format(_artistPunch),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllArtistPosts(
                      currentUserId: widget.currentUserId,
                      artist: user.userName!,
                      artistPunch: _artistPunch,
                      post: null,
                    ),
                  ),
                ),
                title: 'Punches Used',
                subTitle:
                    "The number of moods punched with ${user.userName}'s puncline.",
              ),
              ListviewDivider(),
              UserStatistics(
                countColor:
                    ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                titleColor:
                    ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                count: NumberFormat.compact().format(_artistFavoriteCount),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => FavoriteArtists(
                              currentUserId: widget.currentUserId,
                              artist: user.userName!,
                              user: user,
                              artistFavoriteCount: _artistFavoriteCount,
                            ))),
                title: 'As Favorite Artist',
                subTitle:
                    'The number of accounts listing ${user.userName} as favorite artist.',
              ),
              ListviewDivider(),
              UserStatistics(
                countColor:
                    user.id != Provider.of<UserData>(context).currentUserId
                        ? Colors.grey
                        : ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                titleColor:
                    user.id != Provider.of<UserData>(context).currentUserId
                        ? Colors.grey
                        : ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                count: NumberFormat.compact().format(_followerCount),
                onPressed: () => user.id ==
                        Provider.of<UserData>(context, listen: false)
                            .currentUserId
                    ? _followerCount == 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => NoAccountList(
                                      follower: 'Followers',
                                    )))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FollowerFollowing(
                                      currentUserId: widget.currentUserId,
                                      followingCount: _followingCount - 1,
                                      follower: 'Followers',
                                      followerCount: _followerCount,
                                    )))
                    : () {},
                title: 'Followers',
                subTitle: 'The number of accounts following you.',
              ),
              ListviewDivider(),
              UserStatistics(
                countColor: user.id !=
                        Provider.of<UserData>(context, listen: false)
                            .currentUserId
                    ? Colors.grey
                    : ConfigBloc().darkModeOn
                        ? Colors.white
                        : Colors.black,
                titleColor: user.id !=
                        Provider.of<UserData>(context, listen: false)
                            .currentUserId
                    ? Colors.grey
                    : ConfigBloc().darkModeOn
                        ? Colors.white
                        : Colors.black,
                count: NumberFormat.compact().format(_followingCount),
                onPressed: () => user.id ==
                        Provider.of<UserData>(context, listen: false)
                            .currentUserId
                    ? _followingCount == 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => NoAccountList(
                                      follower: 'Following',
                                    )))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FollowerFollowing(
                                      currentUserId: widget.currentUserId,
                                      followingCount: _followingCount,
                                      followerCount: _followerCount,
                                      follower: 'Following',
                                    )))
                    : () {},
                title: 'Following',
                subTitle: 'The number of accounts you are following.',
              ),
              ListviewDivider(),
              UserStatistics(
                countColor: Colors.grey,
                titleColor: Colors.grey,
                count: NumberFormat.compact().format(_posts.length),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _moodPunched = 0;
                    });
                  }
                },
                title: 'Moods Punched',
                subTitle: "The number of moods you've punched.",
              ),
              ListviewDivider(),
              UserStatistics(
                countColor: Colors.grey,
                titleColor: Colors.grey,
                count: NumberFormat.compact().format(_forums.length),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _moodPunched = 1;
                    });
                  }
                },
                title: 'Forums',
                subTitle: "The number of forums you've published.",
              ),
              ListviewDivider(),
              UserStatistics(
                countColor: Colors.grey,
                titleColor: Colors.grey,
                count: NumberFormat.compact().format(_events.length),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _moodPunched = 2;
                    });
                  }
                },
                title: 'Events',
                subTitle: "The number of events you've published.",
              ),
            ]),
      ),
    );
  }

  _buildDisplayPosts() {
    List<GridTile> tiles = [];
    _posts.forEach((post) => tiles.add(_buildTilePost(post)));
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      shrinkWrap: true,
      children: tiles,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  _buildDisplayForum() {
    List<ProfileForumView> forumViews = [];
    _forums.forEach((forum) {
      forumViews.add(ProfileForumView(
        feed: 'Profile',
        currentUserId: widget.currentUserId,
        forum: forum,
        author: _profileUser,
      ));
    });
    return Column(children: forumViews);
  }

  _buildDisplayEvent() {
    List<EventProfileView> eventViews = [];
    _events.forEach((event) {
      eventViews.add(EventProfileView(
        exploreLocation: '',
        allEvents: false,
        feed: 4,
        currentUserId: widget.currentUserId,
        event: event,
        user: _profileUser,
      ));
    });
    return Column(children: eventViews);
  }

  _buildMoodPunched(AccountHolder user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DisplayPosts(
              title: 'Mood Punched',
              color: _moodPunched == 0 ? Colors.blue : Colors.grey,
              fontWeight:
                  _moodPunched == 0 ? FontWeight.bold : FontWeight.normal,
              onPressed: () => setState(() {
                _moodPunched = 0;
              }),
            ),
            SizedBox(
              width: 30.0,
            ),
            DisplayPosts(
              title: 'Forums',
              color: _moodPunched == 1 ? Colors.blue : Colors.grey,
              fontWeight:
                  _moodPunched == 1 ? FontWeight.bold : FontWeight.normal,
              onPressed: () => setState(() {
                _moodPunched = 1;
              }),
            ),
            SizedBox(
              width: 30.0,
            ),
            DisplayPosts(
              title: 'Events',
              color: _moodPunched == 2 ? Colors.blue : Colors.grey,
              fontWeight:
                  _moodPunched == 2 ? FontWeight.bold : FontWeight.normal,
              onPressed: () => setState(() {
                _moodPunched = 2;
              }),
            ),
          ],
        ),
      ),
    );
  }

  _buildDisplay(AccountHolder user) {
    if (_moodPunched == 0) {
      return Column(
        children: <Widget>[
          // _buildToggleButton(user),
          _buildDisplayPosts(),
        ],
      );
    } else if (_moodPunched == 1) {
      return Column(
        children: <Widget>[
          _buildDisplayForum(),
        ],
      );
    } else if (_moodPunched == 2) {
      return Column(
        children: <Widget>[_buildDisplayEvent()],
      );
    }
  }

  _displayBannnedUploadNote(AccountHolder user) {
    return Text(
        '${user.name}, your rating is less than -10, for this reason, you cannot be able to upload anything on this platform until your rating is a positive number.',
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center);
  }

  _dynamicLink() async {
    var linkUrl = Uri.parse(_profileUser.profileImageUrl!);

    final dynamicLinkParams = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: linkUrl,
        title: _profileUser.userName,
        description: _profileUser.bio,
      ),
      link: Uri.parse('https://www.barsopus.com/user_${_profileUser.id}'),
      uriPrefix: 'https://barsopus.com/barsImpression',
      androidParameters:
          AndroidParameters(packageName: 'com.barsOpus.barsImpression'),
      iosParameters: IOSParameters(
        bundleId: 'com.bars-Opus.barsImpression',
        appStoreId: '1610868894',
      ),
    );
    if (Platform.isIOS) {
      var link =
          await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
      Share.share(link.toString());
    } else {
      var link =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      Share.share(link.shortUrl.toString());
    }
  }

  _showSelectImageDialog(AccountHolder user) {
    return Platform.isIOS
        ? _iosBottomSheet(user)
        : _androidDialog(context, user);
  }

  _showSelectImageDialog2(AccountHolder user, String from) {
    return Platform.isIOS
        ? _iosBottomSheet2(user, from)
        : _androidDialog2(context, user, from);
  }

  _iosBottomSheet2(AccountHolder user, String from) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              from.startsWith('unfollow')
                  ? 'Are you sure you want to unfollow ${user.userName}?'
                  : from.startsWith('block')
                      ? 'Are you sure you want to block ${user.userName}?'
                      : from.startsWith('unBlock')
                          ? 'Are you sure you want to unblock ${user.userName}?'
                          : '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  child: Text(
                    from.startsWith('unfollow')
                        ? 'unFollow'
                        : from.startsWith('block')
                            ? 'block'
                            : from.startsWith('unBlock')
                                ? 'unBlock'
                                : '',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    from.startsWith('unfollow')
                        ? _unfollowUser(user)
                        : from.startsWith('block')
                            ? _blockser(user)
                            : from.startsWith('unBlock')
                                ? _unBlockser(user)
                                : () {};
                  }),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancle',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog2(BuildContext parentContext, AccountHolder user, String from) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              from.startsWith('unfollow')
                  ? 'Are you sure you want to unfollow ${user.userName}?'
                  : from.startsWith('block')
                      ? 'Are you sure you want to block ${user.userName}?'
                      : from.startsWith('unBlock')
                          ? 'Are you sure you want to unblock ${user.userName}?'
                          : '',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    from.startsWith('unfollow')
                        ? 'unFollow'
                        : from.startsWith('block')
                            ? 'block'
                            : from.startsWith('unBlock')
                                ? 'unBlock'
                                : '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    from.startsWith('unfollow')
                        ? _unfollowUser(user)
                        : from.startsWith('block')
                            ? _blockser(user)
                            : from.startsWith('unBlock')
                                ? _unBlockser(user)
                                : () {};
                  },
                ),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        });
  }

  _chat() async {
    AccountHolderAuthor user =
        await DatabaseService.getUserAuthorWithId(_profileUser.id!);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatMessageScreen(
          user: user,
          currentUserId: widget.currentUserId,
          fromProfile: true,
          chat: null,
        ),
      ),
    );
  }

  _iosBottomSheet(AccountHolder user) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Actions',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  child: Text(
                    'Message',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () => user.profileHandle!.startsWith('Fan')
                      ? _chat()
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StartChat(
                              user: user,
                              currentUserId: widget.currentUserId,
                            ),
                          ))),
              CupertinoActionSheetAction(
                  child: Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () => _dynamicLink()),
              CupertinoActionSheetAction(
                  child: Text(
                    _isFollowing ? 'unFollow' : 'Follow',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _followOrUnfollow(user);
                  }),
              CupertinoActionSheetAction(
                  child: Text(
                    _isBlockingUser ? 'unBlock' : 'Block',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _blockOrUnBlock(user);
                  }),
              CupertinoActionSheetAction(
                child: Text(
                  'Report',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ReportContentPage(
                                parentContentId: widget.userId,
                                repotedAuthorId: widget.userId,
                                contentId: widget.userId,
                                contentType: 'user',
                              )));
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancle',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog(BuildContext parentContext, AccountHolder user) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Message',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StartChat(
                            user: user,
                            currentUserId: widget.currentUserId,
                          ),
                        ));
                  },
                ),
              ),
              Center(
                child: SimpleDialogOption(
                    child: Text(
                      'Share',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () => _dynamicLink()),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    _isFollowing ? 'unFollow' : 'Follow',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _followOrUnfollow(user);
                  },
                ),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    _isBlockingUser ? 'unBlock' : 'Block',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _blockOrUnBlock(user);
                  },
                ),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Report',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReportContentPage(
                                  parentContentId: widget.userId,
                                  repotedAuthorId: widget.userId,
                                  contentId: widget.userId,
                                  contentType: user.userName!,
                                )));
                  },
                ),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        });
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    int _point = _possitiveRatedCount - _negativeRatedCount;

    final width =
        Responsive.isDesktop(context) ? 600 : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: FutureBuilder(
          future:
              widget.userId.isEmpty ? null : usersRef.doc(widget.userId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                color: Color(0xFF1a1a1a),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.grey,
                          ),
                          strokeWidth: 1,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Shimmer.fromColors(
                        period: Duration(milliseconds: 1000),
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.white,
                        child: RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Loading ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey)),
                            TextSpan(text: 'Profile\nPlease Wait... '),
                          ],
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        )),
                      ),
                    ],
                  ),
                ),
              );
            }

            AccountHolder user = AccountHolder.fromDoc(snapshot.data);

            DatabaseService.numFavoriteArtist(user.userName!.toUpperCase())
                .listen((artistCount) {
              if (mounted) {
                setState(() {
                  _artistFavoriteCount = artistCount;
                });
              }
            });

            DatabaseService.numArtistPunch(
                    widget.currentUserId, user.userName!.toUpperCase())
                .listen((artistPunch) {
              if (mounted) {
                setState(() {
                  _artistPunch = artistPunch;
                });
              }
            });

            return _isBlockedUser || user.disabledAccount!
                ? UserNotFound(
                    userName: user.userName!,
                  )
                : user.reportConfirmed!.isNotEmpty
                    ? UserBanned(
                        userName: user.userName!,
                      )
                    : Scaffold(
                        appBar: AppBar(
                          iconTheme: IconThemeData(
                            color: Colors.white,
                          ),
                          automaticallyImplyLeading:
                              widget.currentUserId == widget.userId
                                  ? false
                                  : true,
                          actions: <Widget>[
                            widget.currentUserId == widget.userId
                                ? Row(
                                    children: <Widget>[
                                      ConfigBloc().darkModeOn
                                          ? Shimmer.fromColors(
                                              period:
                                                  Duration(milliseconds: 1000),
                                              baseColor: Colors.blueGrey,
                                              highlightColor: Colors.white,
                                              child: Text('lights off',
                                                  style: TextStyle(
                                                    color: Colors.blueGrey,
                                                  )),
                                            )
                                          : Shimmer.fromColors(
                                              period:
                                                  Duration(milliseconds: 1000),
                                              baseColor: Colors.white,
                                              highlightColor: Colors.grey,
                                              child: Text(
                                                'lights on',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                      IconButton(
                                          icon: Icon(
                                            ConfigBloc().darkModeOn
                                                ? FontAwesomeIcons.lightbulb
                                                : FontAwesomeIcons
                                                    .solidLightbulb,
                                          ),
                                          iconSize: 20,
                                          color: ConfigBloc().darkModeOn
                                              ? Colors.blueGrey
                                              : Colors.white,
                                          onPressed: () async {
                                            HapticFeedback.heavyImpact();
                                            ConfigBloc().add(DarkModeEvent(
                                                !ConfigBloc().darkModeOn));
                                          }),
                                    ],
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                    ),
                                    color: Colors.white,
                                    onPressed: () =>
                                        _showSelectImageDialog(user),
                                  ),
                          ],
                          elevation: 0,
                          backgroundColor: Color(0xFF1a1a1a),
                        ),
                        backgroundColor: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Colors.white,
                        body: SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height - 150,
                            width: width.toDouble(),
                            child: RefreshIndicator(
                              backgroundColor: Colors.white,
                              onRefresh: () async {
                                _setupIsFollowing();
                                _setUpFollowers();
                                _setUpFollowing();
                                _setupIsBlocking();
                                _setupPosts();
                                _setUpForums();
                                _setUpEvents();
                                _setUpPossitiveRated();
                                _setUpNegativeRated();
                                // _setUpProfileUser();
                              },
                              child: ListView(children: <Widget>[
                                Container(
                                  color: Color(0xFF1a1a1a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 30.0,
                                      right: 30,
                                      bottom: 30,
                                      top: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right:
                                                      user.verified!.isNotEmpty
                                                          ? 18.0
                                                          : 0.0),
                                              child: new Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  user.userName!.toUpperCase(),
                                                  style: TextStyle(
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.blueGrey
                                                            : Colors.white,
                                                    fontSize:
                                                        width > 600 ? 40 : 30.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            user.verified!.isEmpty
                                                ? const SizedBox.shrink()
                                                : Positioned(
                                                    top: 5,
                                                    right: 0,
                                                    child: Icon(
                                                      MdiIcons
                                                          .checkboxMarkedCircle,
                                                      size: 20,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF1a1a1a),
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          child: Hero(
                                            tag: 'useravater',
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xFF1a1a1a),
                                              radius: width > 600 ? 120 : 80.0,
                                              backgroundImage: user
                                                      .profileImageUrl!.isEmpty
                                                  ? AssetImage(
                                                      'assets/images/user_placeholder.png',
                                                    ) as ImageProvider
                                                  : CachedNetworkImageProvider(
                                                      user.profileImageUrl!),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Hero(
                                              tag: 'nickName',
                                              child: new Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  user.name!,
                                                  style: TextStyle(
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.blueGrey
                                                            : Colors.white,
                                                    fontSize:
                                                        width > 600 ? 16 : 14.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Hero(
                                              tag: 'profileHandle',
                                              child: new Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  user.profileHandle!,
                                                  style: TextStyle(
                                                    color: ConfigBloc()
                                                            .darkModeOn
                                                        ? Colors.blueGrey[300]
                                                        : Colors.white,
                                                    fontSize:
                                                        width > 600 ? 30 : 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            user.profileHandle!
                                                        .startsWith('F') ||
                                                    user.profileHandle!.isEmpty
                                                ? const SizedBox.shrink()
                                                : Text(
                                                    user.company!,
                                                    style: TextStyle(
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.blueGrey
                                                          : Colors.white,
                                                      fontSize:
                                                          width > 600 ? 16 : 14,
                                                    ),
                                                  ),
                                            // user.profileHandle!
                                            //             .startsWith('F') ||
                                            //         user.profileHandle!.isEmpty
                                            //     ? const SizedBox.shrink()
                                            //     : Row(
                                            //         crossAxisAlignment:
                                            //             CrossAxisAlignment
                                            //                 .start,
                                            //         mainAxisAlignment:
                                            //             MainAxisAlignment
                                            //                 .center,
                                            //         children: [
                                            //           Stars(score: user.score!),
                                            //         ],
                                            //       ),
                                            user.profileHandle!
                                                        .startsWith('F') ||
                                                    user.profileHandle!.isEmpty
                                                ? const SizedBox.shrink()
                                                : SizedBox(
                                                    height: 10.0,
                                                  ),
                                            user.profileHandle!
                                                        .startsWith('F') ||
                                                    user.profileHandle!.isEmpty
                                                ? const SizedBox.shrink()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        ProfileProfessionalProfile(
                                                                          user:
                                                                              user,
                                                                          currentUserId:
                                                                              widget.currentUserId,
                                                                          userId:
                                                                              '',
                                                                        ))),
                                                        child: Container(
                                                          width: 35,
                                                          height: 35,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                'B',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      // GestureDetector(
                                                      //   onTap: () =>
                                                      //       Navigator.push(
                                                      //           context,
                                                      //           MaterialPageRoute(
                                                      //               builder: (_) =>
                                                      //                   ProfileRating(
                                                      //                     user:
                                                      //                         user,
                                                      //                     currentUserId:
                                                      //                         widget.currentUserId,
                                                      //                   ))),
                                                      //   child: Container(
                                                      //     width: 35,
                                                      //     height: 35,
                                                      //     decoration:
                                                      //         BoxDecoration(
                                                      //       color: Colors
                                                      //           .transparent,
                                                      //       shape:
                                                      //           BoxShape.circle,
                                                      //       border: Border.all(
                                                      //           width: 1.0,
                                                      //           color: Colors
                                                      //               .white),
                                                      //     ),
                                                      //     child: Padding(
                                                      //       padding:
                                                      //           const EdgeInsets
                                                      //               .all(1.0),
                                                      //       child: Align(
                                                      //         alignment:
                                                      //             Alignment
                                                      //                 .center,
                                                      //         child: Text(
                                                      //           'R',
                                                      //           style:
                                                      //               TextStyle(
                                                      //             color: Colors
                                                      //                 .white,
                                                      //             fontSize: 14,
                                                      //           ),
                                                      //           textAlign:
                                                      //               TextAlign
                                                      //                   .center,
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        UserAdviceScreen(
                                                                          user:
                                                                              user,
                                                                          currentUserId:
                                                                              widget.currentUserId,
                                                                        ))),
                                                        child: Container(
                                                          width: 35,
                                                          height: 35,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                'A',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Divider(
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Bio',
                                            style: TextStyle(
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.blueGrey[100]
                                                  : Colors.grey,
                                              fontSize: width > 600 ? 16 : 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        HyperLinkText(
                                          from: 'Profile',
                                          text: user.bio!,
                                        ),
                                        _displayButton(user, _point),
                                      ],
                                    ),
                                  ),
                                ),
                                ConfigBloc().darkModeOn
                                    ? Divider(color: Colors.white)
                                    : const SizedBox.shrink(),
                                SizedBox(
                                  height: 30.0,
                                ),
                                !user.profileHandle!.startsWith('Ar') ||
                                        user.profileHandle!.isEmpty
                                    ? _buildStatistics(user)
                                    : _buildArtistStatistics(user),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _buildMusicPreference(user),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    'Favorite Punchline',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20,
                                      bottom: 20,
                                      top: 20),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                '"${user.favouritePunchline}"',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      color: Colors.grey,
                                      height: 1,
                                      width: width / 4,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      width: width / 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'contents',
                                            style: TextStyle(
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.grey
                                                  : Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.grey,
                                      height: 1,
                                      width: width / 4,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                _buildMoodPunched(user),
                                SizedBox(
                                  height: 30.0,
                                ),
                                _buildDisplay(user),
                                SizedBox(
                                  height: 40.0,
                                ),
                              ]),
                            ),
                          ),
                        ));
          }),
    );
  }
}
