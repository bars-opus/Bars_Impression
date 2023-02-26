import 'package:bars/utilities/exports.dart';

class CreateContentsHome extends StatefulWidget {
  final double width;

  CreateContentsHome({
    required this.width,
  });

  static final id = 'Create';

  @override
  _CreateContentsHome createState() => _CreateContentsHome();
}

class _CreateContentsHome extends State<CreateContentsHome> {
  double boxWidth = 0;
  double box1height = 0;
  double box2height = 0;
  bool _showInfo = false;

  @override
  void initState() {
    super.initState();
    _setShowInfo();
  }

  _setShowInfo() async {
    Timer(Duration(milliseconds: 1), () {
      if (mounted) {
        // setState(() {
        boxWidth = widget.width;
        box1height = 160;

        box2height = 120;
        // });
      }
    });
    Timer(Duration(seconds: 1), () {
      if (mounted) {
        // setState(() {
        //   boxWidth = widget.width;
        //   box1height = 160;
        _showInfo = true;
        // box2height = 120;
        // });
      }
    });
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        // setState(() {
        //   boxWidth = widget.width;
        //   box1height = 160;
        _showInfo = false;
        // box2height = 120;
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AccountHolder user = Provider.of<UserData>(context).user!;
    final String currentUserId = Provider.of<UserData>(context).currentUserId!;
    return SingleChildScrollView(
      child: Container(
        color: Colors.black.withOpacity(.9),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ListView(
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '    Shortcuts',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  // Text(
                  //   "Shortcuts",
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 0,
                  //   ),
                  // ),
                ),
                const SizedBox(
                  height: 5,
                ),
                AnimatedSize(
                  curve: Curves.easeInOutBack,
                  duration: Duration(seconds: 1),
                  // bottom: _showInfo ? 290 : 130,
                  child: Container(
                    width: boxWidth,
                    height: box1height,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                        // bottomRight: Radius.circular(8.0),
                        // bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Create',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CreateButton(
                                icon: Icons.photo,
                                text: 'punch',
                                user: user,
                                onPressed: () async {
                                  Provider.of<UserData>(context, listen: false)
                                      .setShortcutBool(false);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CreatePost(
                                          // user: user,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              CreateButton(
                                text: 'Forum',
                                user: user,
                                onPressed: () {
                                  Provider.of<UserData>(context, listen: false)
                                      .setShortcutBool(false);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CreateForum(
                                          user: user,
                                        ),
                                      ));
                                },
                                icon: Icons.forum,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              CreateButton(
                                icon: Icons.event,
                                text: 'Event',
                                user: user,
                                onPressed: () {
                                  Provider.of<UserData>(context, listen: false)
                                      .setShortcutBool(false);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CreateEvent(
                                          user: user,
                                        ),
                                      ));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                AnimatedSize(
                  curve: Curves.easeInOutBack,
                  duration: Duration(seconds: 1),
                  child: Container(
                    width: boxWidth,
                    height: box1height,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      // borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.8,
                                  child: TextButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Provider.of<UserData>(context,
                                              listen: false)
                                          .setShortcutBool(false);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ForumPage(
                                              currentUserId: currentUserId),
                                        ),
                                      );
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        'forums',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.8,
                                  child: TextButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Provider.of<UserData>(context,
                                              listen: false)
                                          .setShortcutBool(false);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EventPage(
                                            currentUserId: currentUserId,
                                            user: user,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        'events',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 20,
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: () {
                                  Provider.of<UserData>(context, listen: false)
                                      .setShortcutBool(false);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AllPost(
                                        currentUserId: currentUserId,
                                        post: null,
                                      ),
                                    ),
                                  );
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'moods punched',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                AnimatedSize(
                  curve: Curves.easeInOutBack,
                  duration: Duration(seconds: 1),
                  child: Container(
                    width: boxWidth,
                    height: box2height,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(8.0),
                        // topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Edit',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.8,
                                  child: TextButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Provider.of<UserData>(context,
                                              listen: false)
                                          .setShortcutBool(false);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditProfileScreen(
                                              user: user,
                                            ),
                                          ));
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        'Edit profile',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.8,
                                  child: TextButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Provider.of<UserData>(context,
                                              listen: false)
                                          .setShortcutBool(false);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProfileSettings(
                                              user: user,
                                            ),
                                          ));
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        'Account settings',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ShakeTransition(
                  curve: Curves.easeInOutBack,
                  axis: Axis.vertical,
                  duration: const Duration(seconds: 1),
                  child: IconButton(
                      icon: Icon(Icons.close),
                      iconSize: 25.0,
                      color: Colors.white,
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            // _showInfoWidgets = false;
                            Provider.of<UserData>(context, listen: false)
                                .setShortcutBool(false);
                          });
                        }
                      }),
                ),

                // Column(
                //   children: [
                //     SizedBox(
                //       height: 70.0,
                //     ),
                //     Material(
                //       color: Colors.transparent,
                //       child: Text(
                //         "CREATE",
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 20,
                //             letterSpacing: 7,
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //     SizedBox(
                //       height: 5.0,
                //     ),
                //     Text(
                //       "Create forums to share ideas and discuss topics in the music industry. Create events and invite people to come and share great experiences with you. Punch your mood by posting a picture and associating the mood of the picture with music lyrics.",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 12,
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  final String text;
  final AccountHolder user;
  final IconData icon;
  final VoidCallback? onPressed;

  const CreateButton(
      {required this.text,
      required this.user,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onPressed,

      //  => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => CreateForum(
      //       user: user,
      //     ),
      //   ),
      // ),
      child: Container(
        height: width / 5,
        width: width / 5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 40.0,
            ),
            SizedBox(
              height: 5.0,
            ),
            Material(
              color: Colors.transparent,
              child: Text(
                text,
                style: TextStyle(color: Colors.black, fontSize: 10.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
