// // ignore_for_file: must_be_immutable

import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class UserProfessionalViewWidget extends StatelessWidget {
  final VoidCallback onPressedRating;
  final AccountHolder user;
  final String containerHero1;
  final int userTotal;
  final String currentUserId;
  final String workHero;
  final Widget exploreWidget;
  final int point;

  UserProfessionalViewWidget({
    required this.containerHero1,
    required this.onPressedRating,
    required this.point,
    required this.currentUserId,
    required this.user,
    required this.userTotal,
    required this.exploreWidget,
    required this.workHero,
  });

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFF1a1a1a),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: Color(0xFF1a1a1a),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      user.noBooking!
                          ? const SizedBox.shrink()
                          : PageFeatureWidget(
                              heroTag: workHero,
                              title: 'Booking \nPortfolio',
                            ),
                      exploreWidget,
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                user.noBooking!
                    ? SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 30),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ShakeTransition(
                                      child: Icon(
                                        Icons.work,
                                        color: Color(0xFF1a1a1a),
                                        size: 100.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                RichText(
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Not Available\nFor Booking\n',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          )),
                                      TextSpan(
                                        text: user.userName! +
                                            ' is working on a project and therefore not available for business at the moment, but hopes to work with you in the future.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, top: 20),
                            child: SingleChildScrollView(
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
                                  color: Color(0xFFf2f2f2),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.account_circle,
                                              color: Color(0xFF1a1a1a),
                                              size: 25.0,
                                            ),
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ProfileScreen(
                                                          currentUserId: Provider
                                                                  .of<UserData>(
                                                                      context)
                                                              .currentUserId!,
                                                          userId: user.id!,
                                                        ))),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Hero(
                                      tag: containerHero1,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFFf2f2f2),
                                        radius: width > 600 ? 120 : 80.0,
                                        backgroundImage:
                                            user.profileImageUrl!.isEmpty
                                                ? AssetImage(
                                                    'assets/images/user_placeholder2.png',
                                                  ) as ImageProvider
                                                : CachedNetworkImageProvider(
                                                    user.profileImageUrl!),
                                      ),
                                    ),
                                    // Stack(
                                    //   alignment: FractionalOffset.center,
                                    //   children: [
                                    //     Hero(
                                    //       tag: containerHero1,
                                    //       child: Material(
                                    //         color: Colors.transparent,
                                    //         child: Container(
                                    //           height: 200,
                                    //           width: width,
                                    //           decoration: BoxDecoration(
                                    //               color: Color(0xFF1a1a1a),
                                    //               borderRadius:
                                    //                   BorderRadius.circular(5),
                                    //               image: DecorationImage(
                                    //                 image:
                                    //                     CachedNetworkImageProvider(
                                    //                         user.profileImageUrl!),
                                    //                 fit: BoxFit.cover,
                                    //               )),
                                    //           // child: Container(
                                    //           //   decoration: BoxDecoration(
                                    //           //     gradient: LinearGradient(
                                    //           //       begin: Alignment.bottomRight,
                                    //           //       colors: [
                                    //           //         Colors.black
                                    //           //             .withOpacity(.6),
                                    //           //         Colors.black
                                    //           //             .withOpacity(.6),
                                    //           //       ],
                                    //           //     ),
                                    //           //   ),
                                    //           // ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    // Text(
                                    //   user.name!,
                                    //   style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize: 20.0,
                                    //     fontFamily: 'Bessita',
                                    //     fontWeight: FontWeight.w100,
                                    //   ),
                                    //     // ),
                                    //   ],
                                    // ),

                                    // SizedBox(height: 20),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   children: [
                                    //     profileWidget,
                                    //   ],
                                    // ),
                                    // SizedBox(height: 20),
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     color: Color(0xFFf2f2f2),
                                    //     borderRadius:
                                    //         BorderRadius.circular(100.0),
                                    //   ),
                                    //   child: Hero(
                                    //     tag: containerHero1,
                                    //     child: CircleAvatar(
                                    //       backgroundColor: Color(0xFFf2f2f2),
                                    //       radius: width > 600 ? 120 : 80.0,
                                    //       backgroundImage:
                                    //           user.profileImageUrl!.isEmpty
                                    //               ? AssetImage(
                                    //                   'assets/images/user_placeholder2.png',
                                    //                 ) as ImageProvider
                                    //               : CachedNetworkImageProvider(
                                    //                   user.profileImageUrl!),
                                    //     ),
                                    //   ),
                                    // ),

                                    // const SizedBox(
                                    //   height: 20,
                                    // ),
                                    // Icon(
                                    //   FontAwesomeIcons.a,
                                    //   color: palette.darkMutedColor == null
                                    //       ? Color(0xFF1a1a1a)
                                    //       : palette.darkMutedColor!.color,
                                    //   size: 40.0,
                                    // ),
                                    // // Text(
                                    // //   user.profileHandle!,
                                    // //   style: TextStyle(
                                    // //     color: Colors.black,
                                    // //     fontSize: 14.0,
                                    // //   ),
                                    // // ),
                                    // Material(
                                    //   color: Colors.transparent,
                                    //   child: Text(
                                    //     'user.company',
                                    //     style: TextStyle(
                                    //       color:
                                    //           palette.darkMutedColor == null
                                    //               ? Color(0xFF1a1a1a)
                                    //               : palette.darkMutedColor!
                                    //                   .color,
                                    //       fontSize: 12,
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    Column(
                                      children: [
                                        new Material(
                                          color: Colors.transparent,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Text(
                                              user.userName!,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // new Material(
                                        //   color: Colors.transparent,
                                        //   child: Text(
                                        //     user.profileHandle!,
                                        //     style: TextStyle(
                                        //       color: ConfigBloc().darkModeOn
                                        //           ? Color(0xFF1a1a1a)
                                        //           : Colors.black,
                                        //       fontSize: 20.0,
                                        //       fontWeight: FontWeight.bold,
                                        //       letterSpacing: 2.0,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: HyperLinkText(
                                        from: 'Link',
                                        text: user.bio,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    user.profileHandle!.startsWith('Fan')
                                        ? SizedBox.shrink()
                                        : Align(
                                            alignment: Alignment.center,
                                            child: Wrap(
                                              direction: Axis.vertical,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 200,
                                                      child: OutlinedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Color(0xFF1a1a1a),
                                                          side: BorderSide(
                                                            width: 1.0,
                                                            color: Color(
                                                                0xFF1a1a1a),
                                                          ),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        UserBooking(
                                                                          from:
                                                                              'Booking',
                                                                          user:
                                                                              user,
                                                                          currentUserId:
                                                                              currentUserId,
                                                                          userIsCall:
                                                                              1,
                                                                        ))),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: Text(
                                                            'Book me',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12.0,
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
                                    const SizedBox(height: 70),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
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
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 40),
                                    Container(
                                      width: width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // RichText(
                                          //   textScaleFactor:
                                          //       MediaQuery.of(context)
                                          //           .textScaleFactor
                                          //           .clamp(0.5, 1.5),
                                          //   text: TextSpan(
                                          //     children: [
                                          //       TextSpan(
                                          //           text: NumberFormat.compact()
                                          //               .format(point),
                                          //           style: TextStyle(
                                          //               fontSize: 30,
                                          //               color: Colors.black,
                                          //               fontWeight:
                                          //                   FontWeight.bold)),
                                          //       TextSpan(
                                          //           text: "\nBars score. ",
                                          //           style: TextStyle(
                                          //             fontSize: 14,
                                          //             color: Colors.black,
                                          //           )),
                                          //       TextSpan(
                                          //         text:
                                          //             "\nBased on $userTotal ratings. ",
                                          //         style: TextStyle(
                                          //           fontSize: 14,
                                          //           color: Colors.black,
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          //   textAlign: TextAlign.center,
                                          // ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.center,
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.center,
                                          //   children: [
                                          //     Stars(
                                          //       score: user.score!,
                                          //     ),
                                          //   ],
                                          // ),
                                          // SizedBox(
                                          //   height: 40,
                                          // ),
                                          // ShakeTransition(
                                          //   child: Container(
                                          //     color: Colors.grey,
                                          //     height: 1,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   color: Colors.grey[200],
                                    //   child: Column(
                                    //     children: [
                                    //       const SizedBox(
                                    //         height: 70,
                                    //       ),
                                    //       Text(
                                    //         'Genres',
                                    //         style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontSize: 12.0,
                                    //         ),
                                    //       ),
                                    //       const SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //       Container(
                                    //         color: Colors.grey,
                                    //         height: 1,
                                    //         width: width / 5,
                                    //       ),
                                    //       const SizedBox(
                                    //         height: 20,
                                    //       ),
                                    //       Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment
                                    //                 .center,
                                    //         children: [
                                    //           Container(
                                    //             height: width / 7,
                                    //             width: width / 7,
                                    //             decoration:
                                    //                 BoxDecoration(
                                    //                     color: Colors
                                    //                         .white,
                                    //                     boxShadow: [
                                    //                   BoxShadow(
                                    //                     color: Colors
                                    //                         .grey[200]!,
                                    //                     offset: Offset(
                                    //                         4.0, 4.0),
                                    //                     blurRadius:
                                    //                         15.0,
                                    //                     spreadRadius:
                                    //                         1.0,
                                    //                   ),
                                    //                 ]),
                                    //             child: Center(
                                    //               child: Text(
                                    //                 'Rnb',
                                    //                 style: TextStyle(
                                    //                   color:
                                    //                       Colors.black,
                                    //                   fontSize: 12.0,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           const SizedBox(
                                    //             width: 10,
                                    //           ),
                                    //           Container(
                                    //             height: width / 7,
                                    //             width: width / 7,
                                    //             color: Colors.white,
                                    //             child: Center(
                                    //               child: Text(
                                    //                 'Reggae',
                                    //                 style: TextStyle(
                                    //                   color:
                                    //                       Colors.black,
                                    //                   fontSize: 12.0,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       const SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //       Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment
                                    //                 .center,
                                    //         children: [
                                    //           Container(
                                    //             height: width / 7,
                                    //             width: width / 7,
                                    //             color: Colors.white,
                                    //             child: Center(
                                    //               child: Text(
                                    //                 'Hip\nPop',
                                    //                 style: TextStyle(
                                    //                   color:
                                    //                       Colors.black,
                                    //                   fontSize: 12.0,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           const SizedBox(
                                    //             width: 10,
                                    //           ),
                                    //           Container(
                                    //             height: width / 7,
                                    //             width: width / 7,
                                    //             color: Colors.white,
                                    //             child: Center(
                                    //               child: Text(
                                    //                 'High\nLife',
                                    //                 style: TextStyle(
                                    //                   color:
                                    //                       Colors.black,
                                    //                   fontSize: 12.0,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       const SizedBox(
                                    //         height: 70,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),

                                    // ShakeTransition(
                                    //   child: Container(
                                    //     color: Colors.grey,
                                    //     height: 1,
                                    //   ),
                                    // ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor
                                                  .clamp(0.5, 1.5),
                                          text: TextSpan(children: [
                                            TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: 'Username: ',
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 14
                                                            : 12.0,
                                                        color: Colors.grey,
                                                      )),
                                                  TextSpan(
                                                      text: user.userName,
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 16
                                                            : 12.0,
                                                        color: Colors.black,
                                                      )),
                                                  TextSpan(
                                                      text:
                                                          '\nNick name/ Stage name: ',
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 14
                                                            : 12.0,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.blueGrey
                                                            : Colors.grey,
                                                      )),
                                                  TextSpan(
                                                      text: user.name,
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 16
                                                            : 12.0,
                                                        color: Colors.black,
                                                      )),
                                                  TextSpan(
                                                      text:
                                                          '\nCity/ Country & Continent: ',
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 14
                                                            : 12.0,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.blueGrey
                                                            : Colors.grey,
                                                      )),
                                                  TextSpan(
                                                      text: user.city! + "/ ",
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 16
                                                            : 12.0,
                                                        color: Colors.black,
                                                      )),
                                                  TextSpan(
                                                      text:
                                                          user.country! + "/ ",
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 16
                                                            : 12.0,
                                                        color: Colors.black,
                                                      )),
                                                  TextSpan(
                                                      text: user.continent! +
                                                          '\n',
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 16
                                                            : 12.0,
                                                        color: Colors.black,
                                                      )),
                                                  TextSpan(
                                                    text: user.profileHandle!
                                                            .startsWith('Ar')
                                                        ? 'Music Skills:'
                                                        : user.profileHandle!
                                                                .startsWith(
                                                                    'Co')
                                                            ? 'Design Skills:'
                                                            : user.profileHandle!
                                                                    .startsWith(
                                                                        'Da')
                                                                ? 'Dance Skills:'
                                                                : user.profileHandle!
                                                                        .startsWith(
                                                                            'Ph')
                                                                    ? 'Photography Skills:'
                                                                    : user.profileHandle!
                                                                            .startsWith('Re')
                                                                        ? 'Recording Services'
                                                                        : user.profileHandle!.startsWith('Mu')
                                                                            ? 'Video Skills:'
                                                                            : user.profileHandle!.startsWith('Bl')
                                                                                ? 'Blogging Skills:'
                                                                                : user.profileHandle!.startsWith('Br')
                                                                                    ? 'Influencing Skills:'
                                                                                    : user.profileHandle!.startsWith('Ba')
                                                                                        ? 'Battling Skills:'
                                                                                        : user.profileHandle!.endsWith('J')
                                                                                            ? 'Dj Skills:'
                                                                                            : user.profileHandle!.endsWith('xen')
                                                                                                ? 'Video Peforming Skills:'
                                                                                                : user.profileHandle!.startsWith('Pr')
                                                                                                    ? 'Production Skills:'
                                                                                                    : " ",
                                                    style: TextStyle(
                                                      fontSize: width > 600
                                                          ? 14
                                                          : 12.0,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.blueGrey
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: user.skills! + "\n",
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 16
                                                            : 12.0,
                                                        color: Colors.black,
                                                      )),
                                                  TextSpan(
                                                      text: user.profileHandle!
                                                              .startsWith('Ar')
                                                          ? 'Music Performances: '
                                                          : user.profileHandle!
                                                                  .startsWith(
                                                                      'Co')
                                                              ? 'Design Exhibitions: '
                                                              : user.profileHandle!
                                                                      .startsWith(
                                                                          'Ph')
                                                                  ? 'Photo Exhibitions: '
                                                                  : user.profileHandle!
                                                                          .startsWith(
                                                                              'Da')
                                                                      ? 'Dance performancess: '
                                                                      : user.profileHandle!
                                                                              .startsWith('Ba')
                                                                          ? 'Batlle Stages: '
                                                                          : user.profileHandle!.endsWith('J')
                                                                              ? 'Performances: '
                                                                              : '',
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 14
                                                            : 12.0,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.blueGrey
                                                            : Colors.grey,
                                                      )),
                                                  TextSpan(
                                                      text: user
                                                                  .profileHandle!
                                                                  .startsWith(
                                                                      'Vi') ||
                                                              user.profileHandle!
                                                                  .startsWith(
                                                                      "Bl") ||
                                                              user.profileHandle!
                                                                  .startsWith(
                                                                      "Br") ||
                                                              user.profileHandle!
                                                                  .startsWith(
                                                                      "Re") ||
                                                              user.profileHandle!
                                                                  .endsWith(
                                                                      "xen") ||
                                                              user.profileHandle!
                                                                  .startsWith(
                                                                      "Mu") ||
                                                              user.profileHandle!
                                                                  .startsWith(
                                                                      "Pr")
                                                          ? ''
                                                          : user.performances! +
                                                              "\n",
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 16
                                                            : 12.0,
                                                        color: Colors.black,
                                                      )),
                                                  TextSpan(
                                                      text: user.profileHandle!
                                                              .startsWith('Ar')
                                                          ? 'Music Collaborations: '
                                                          : user.profileHandle!
                                                                  .startsWith(
                                                                      'Co')
                                                              ? 'Design Collaborations: '
                                                              : user.profileHandle!
                                                                      .startsWith(
                                                                          'Da')
                                                                  ? 'Danced With: '
                                                                  : user.profileHandle!
                                                                          .startsWith(
                                                                              'Ph')
                                                                      ? 'Worked With: '
                                                                      : user.profileHandle!
                                                                              .startsWith('Mu')
                                                                          ? 'Video Works: '
                                                                          : user.profileHandle!.endsWith('xen')
                                                                              ? 'Video appearances: '
                                                                              : user.profileHandle!.startsWith('Bl')
                                                                                  ? 'Blogged About: '
                                                                                  : user.profileHandle!.startsWith('Br')
                                                                                      ? 'Worked with: '
                                                                                      : user.profileHandle!.startsWith('Ba')
                                                                                          ? 'Battled Against: '
                                                                                          : user.profileHandle!.endsWith('J')
                                                                                              ? 'Dj Collaborations: '
                                                                                              : user.profileHandle!.startsWith('Re')
                                                                                                  ? 'Partners: '
                                                                                                  : user.profileHandle!.startsWith('Pr')
                                                                                                      ? 'Production Collaborations: '
                                                                                                      : '',
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 14
                                                            : 12.0,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.blueGrey
                                                            : Colors.grey,
                                                      )),
                                                  TextSpan(
                                                      text:
                                                          user.collaborations! +
                                                              "\n",
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 16
                                                            : 12.0,
                                                        color: Colors.black,
                                                      )),
                                                  TextSpan(
                                                      text: user.profileHandle!
                                                              .startsWith('Ar')
                                                          ? 'Music Awards:'
                                                          : user.profileHandle!
                                                                  .startsWith(
                                                                      'Co')
                                                              ? 'Design Awards: '
                                                              : user.profileHandle!
                                                                      .startsWith(
                                                                          'Da')
                                                                  ? 'Dance Awards: '
                                                                  : user.profileHandle!
                                                                          .startsWith(
                                                                              'Ph')
                                                                      ? 'Photography Awards: '
                                                                      : user.profileHandle!
                                                                              .startsWith('Re')
                                                                          ? 'Awards: '
                                                                          : user.profileHandle!.startsWith('Mu')
                                                                              ? 'Video Awards: '
                                                                              : user.profileHandle!.endsWith('xen')
                                                                                  ? 'Awards: '
                                                                                  : user.profileHandle!.startsWith('Bl')
                                                                                      ? 'Blogging Awards: '
                                                                                      : user.profileHandle!.startsWith('Ba')
                                                                                          ? 'Battle Awards: '
                                                                                          : user.profileHandle!.endsWith('J')
                                                                                              ? 'Dj Awards: '
                                                                                              : user.profileHandle!.startsWith('Br')
                                                                                                  ? 'Awards: '
                                                                                                  : user.profileHandle!.startsWith('Pr')
                                                                                                      ? 'Beat Production Awards: '
                                                                                                      : '',
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 14
                                                            : 12.0,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.blueGrey
                                                            : Colors.grey,
                                                      )),
                                                  TextSpan(
                                                      text: user.awards! + "\n",
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 16
                                                            : 12.0,
                                                        color: Colors.black,
                                                      )),
                                                  TextSpan(
                                                      text: 'Management: ',
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 14
                                                            : 12.0,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.blueGrey
                                                            : Colors.grey,
                                                      )),
                                                  TextSpan(
                                                      text: user.management!,
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 16
                                                            : 12.0,
                                                        color: Colors.black,
                                                      )),
                                                ],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                          ]),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),

                                    Container(
                                      color: Colors.grey[200],
                                      width: width,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.grey,
                                              height: 1,
                                              width: width / 5,
                                            ),
                                            //   ],
                                            // ),
                                            SizedBox(height: 20),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 10.0, 0.0, 20.0),
                                              child: currentUserId == user.id
                                                  ? Text(
                                                      'Your works',
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 14
                                                            : 12.0,
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  : Text(
                                                      'My works:',
                                                      style: TextStyle(
                                                        fontSize: width > 600
                                                            ? 14
                                                            : 12.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                            ),
                                            Row(
                                              mainAxisAlignment: user
                                                          .website!.isEmpty &&
                                                      user.otherSites1!
                                                          .isEmpty &&
                                                      user.otherSites2!.isEmpty
                                                  ? MainAxisAlignment.center
                                                  : MainAxisAlignment
                                                      .spaceEvenly,
                                              children: [
                                                user.website!.isEmpty
                                                    ? const SizedBox.shrink()
                                                    : Column(
                                                        children: [
                                                          InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) => WebDisclaimer(
                                                                      link: user
                                                                          .website!,
                                                                      contentType:
                                                                          user.userName! +
                                                                              '\'s Work'),
                                                                ),
                                                              );
                                                            },
                                                            child: Ink(
                                                              child: Container(
                                                                height:
                                                                    width / 4,
                                                                width:
                                                                    width / 4,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFF1a1a1a),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child: Icon(
                                                                  MdiIcons.web,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 30,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                              'Visit\n My website',
                                                              textScaleFactor:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaleFactor
                                                                      .clamp(
                                                                          0.5,
                                                                          1.2),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ],
                                                      ),
                                                user.otherSites1!.isEmpty
                                                    ? const SizedBox.shrink()
                                                    : Column(
                                                        children: [
                                                          Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (_) => WebDisclaimer(
                                                                        link: user
                                                                            .otherSites1!,
                                                                        contentType:
                                                                            user.userName! +
                                                                                '\'s Work'),
                                                                  ),
                                                                );
                                                              },
                                                              child: Ink(
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      width / 4,
                                                                  width:
                                                                      width / 4,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFF1a1a1a),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child: Icon(
                                                                    MdiIcons
                                                                        .playBoxOutline,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 30,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                              'Watch \n My Videos',
                                                              textScaleFactor:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaleFactor
                                                                      .clamp(
                                                                          0.5,
                                                                          1.2),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ],
                                                      ),
                                                user.otherSites2!.isEmpty
                                                    ? Text('No works ',
                                                        textScaleFactor:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaleFactor
                                                                .clamp(
                                                                    0.5, 1.2),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis)
                                                    : Column(
                                                        children: [
                                                          InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) => WebDisclaimer(
                                                                      link: user
                                                                          .otherSites2!,
                                                                      contentType:
                                                                          user.userName! +
                                                                              '\'s Work'),
                                                                ),
                                                              );
                                                            },
                                                            child: Ink(
                                                              child: Container(
                                                                height:
                                                                    width / 4,
                                                                width:
                                                                    width / 4,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFF1a1a1a),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child: Icon(
                                                                  Icons.work,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 30,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                              'Or\n Check Here',
                                                              textScaleFactor:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaleFactor
                                                                      .clamp(
                                                                          0.5,
                                                                          1.2),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 3),

                                user.professionalPicture1!.isEmpty
                                    ? Container(
                                        height: width / 1.3,
                                        width: width,
                                        color: Colors.grey,
                                        child: Icon(
                                          MdiIcons.image,
                                          color: Colors.white,
                                          size: 70,
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => BookingGallery(
                                                      user: user,
                                                      currentUserId:
                                                          currentUserId,
                                                    ))),
                                        child: Container(
                                          color: Colors.white,
                                          child: Container(
                                            margin: EdgeInsets.all(5.0),
                                            height: width / 1.3,
                                            width: width,
                                            decoration: BoxDecoration(
                                                color: Color(0xFF1a1a1a),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      user.professionalPicture1!),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                      ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => BookingGallery(
                                                user: user,
                                                currentUserId: currentUserId,
                                              ))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // scrollDirection:
                                      //     Axis.horizontal,
                                      children: [
                                        user.professionalPicture2!.isEmpty
                                            ? Container(
                                                height: width / 2.3,
                                                width: width / 2.3,
                                                color: Colors.grey,
                                                child: Icon(
                                                  MdiIcons.image,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                              )
                                            : Ink(
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Container(
                                                    margin: EdgeInsets.all(5.0),
                                                    height: width / 2.4,
                                                    width: width / 2.4,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF1a1a1a),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        image: DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                              user.professionalPicture2!),
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(width: 5),
                                        user.professionalPicture3!.isEmpty
                                            ? Container(
                                                height: width / 2.3,
                                                width: width / 2.3,
                                                color: Colors.grey,
                                                child: Icon(
                                                  MdiIcons.image,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                              )
                                            : Ink(
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Container(
                                                    margin: EdgeInsets.all(5.0),
                                                    height: width / 2.4,
                                                    width: width / 2.4,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF1a1a1a),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        image: DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                              user.professionalPicture3!),
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                // user.website!.isEmpty ||
                                //         user.otherSites1!.isEmpty ||
                                //         user.otherSites2!.isEmpty
                                //     ? SizedBox.shrink()
                                //     :

                                // user.contacts!.isEmpty ||
                                //         user.email!.isEmpty
                                //     ? SizedBox.shrink()
                                //     :
                                // Column(
                                //   children: [
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Container(
                                //       color: Colors.grey,
                                //       height: 1,
                                //       width: width / 5,
                                //     ),
                                //     Container(
                                //       decoration: BoxDecoration(
                                //           border: Border.all(
                                //               color: Colors.grey,
                                //               width: 1)),
                                //       width: width / 3,
                                //       child: Padding(
                                //         padding:
                                //             const EdgeInsets.all(
                                //                 5.0),
                                //         child: Align(
                                //           alignment:
                                //               Alignment.center,
                                //           child: Text(
                                //             'Booking',
                                //             style: TextStyle(
                                //               color: Colors.grey,
                                //               fontSize: 12,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //     Container(
                                //       color: Colors.grey,
                                //       height: 1,
                                //       width: width / 5,
                                //     ),
                                //   ],
                                // ),
                                // const SizedBox(height: 20),
                                // currentUserId == user.id
                                //     ? Text(
                                //         'Your booking contact',
                                //         style: TextStyle(
                                //           fontSize: width > 600
                                //               ? 14
                                //               : 12.0,
                                //           color: Colors.grey,
                                //         ),
                                //       )
                                //     : Text(
                                //         'Book me here',
                                //         style: TextStyle(
                                //           fontSize: width > 600
                                //               ? 14
                                //               : 12.0,
                                //           color: Colors.grey,
                                //         ),
                                //       ),
                                // SizedBox(
                                //   height: 30.0,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 0.0),
                                //   child: Align(
                                //     alignment: Alignment.center,
                                //     child: Container(
                                //       width: width,
                                //       child: ElevatedButton(
                                //         style: ElevatedButton
                                //             .styleFrom(
                                //           primary:
                                //               Color(0xFF1a1a1a),
                                //           onPrimary: Colors.blue,
                                //           shape:
                                //               RoundedRectangleBorder(
                                //             borderRadius:
                                //                 BorderRadius
                                //                     .circular(5.0),
                                //           ),
                                //         ),
                                //         onPressed: () =>
                                //             Navigator.push(
                                //                 context,
                                //                 MaterialPageRoute(
                                //                     builder: (_) =>
                                //                         UserBooking(
                                //                           user:
                                //                               user,
                                //                           currentUserId:
                                //                               currentUserId,
                                //                           userIsCall:
                                //                               1,
                                //                         ))),
                                //         child: Material(
                                //           color: Colors.transparent,
                                //           child: Text(
                                //             'Reveal Contact',
                                //             style: TextStyle(
                                //               color: Colors.white,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UserBooking(
                                    from: 'Booking',
                                    user: user,
                                    currentUserId: currentUserId,
                                    userIsCall: 1,
                                  ))),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          'Work with me',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UserAdviceScreen(
                                    currentUserId: currentUserId,
                                    user: user,
                                  ))),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          'Advice',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReportContentPage(
                                    parentContentId: user.id,
                                    repotedAuthorId: user.id!,
                                    contentId: user.id!,
                                    contentType: user.userName!,
                                  ))),
                      child: Material(
                          color: Colors.transparent,
                          child: Text('Report',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              )))),
                ),

                // Container(
                //   width: width,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       GestureDetector(
                //         onTap: () => Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (_) => ProfileRating(
                //                       user: user,
                //                       currentUserId: currentUserId,
                //                     ))),
                //         child: user.id == currentUserId
                //             ? Text(
                //                 'Your rating',
                //                 style: TextStyle(
                //                   fontSize: 12.0,
                //                   color: Colors.grey,
                //                 ),
                //               )
                //             : Text(
                //                 'Rate ${user.userName!} here',
                //                 style: TextStyle(
                //                   fontSize: 12.0,
                //                   color: Colors.grey,
                //                 ),
                //               ),
                //       ),
                //       const SizedBox(height: 20),
                //       user.profileHandle!.startsWith('F') ||
                //               user.profileHandle!.isEmpty
                //           ? SizedBox.shrink()
                //           : GestureDetector(
                //               onTap: () => Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (_) => UserAdviceScreen(
                //                             currentUserId: currentUserId,
                //                             user: user,
                //                           ))),
                //               child: Material(
                //                   color: Colors.transparent,
                //                   child: Text(
                //                       user.id == currentUserId
                //                           ? 'See advices'
                //                           : 'Leave an advice for ' +
                //                               user.userName!,
                //                       style: TextStyle(
                //                         color: Colors.grey,
                //                         fontSize: 12,
                //                       )))),
                //       const SizedBox(height: 20),
                //       GestureDetector(
                //           onTap: () => Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (_) => ReportContentPage(
                //                         parentContentId: user.id,
                //                         repotedAuthorId: user.id!,
                //                         contentId: user.id!,
                //                         contentType: user.userName!,
                //                       ))),
                //           child: Material(
                //               color: Colors.transparent,
                //               child: Text('Report  ' + user.userName!,
                //                   style: TextStyle(
                //                     color: Colors.red,
                //                     fontSize: 12,
                //                   )))),
                //       const SizedBox(height: 20),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 70),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 30.0,
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(
                  height: 70.0,
                ),
                GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SuggestionBox())),
                    child: Center(
                      child: Material(
                          color: Colors.transparent,
                          child: Text('Suggestion Box',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ))),
                    )),
                const SizedBox(
                  height: 70.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ResponsiveScaffold(
  //   child: Scaffold(
  //     extendBodyBehindAppBar: true,
  //     backgroundColor: Colors.transparent,
  //     appBar: AppBar(
  //         iconTheme: IconThemeData(
  //           color: Colors.white,
  //         ),
  //         automaticallyImplyLeading: true,
  //         elevation: 0,
  //         backgroundColor: Colors.transparent,
  //       ),
  //       body: Stack(
  //         children: [
  //           Container(
  //               height: MediaQuery.of(context).size.height,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                 color: ConfigBloc().darkModeOn
  //                     ? Color(0xFF1a1a1a)
  //                     : Color(0xFFeff0f2),
  //                 image: DecorationImage(
  //                   image: CachedNetworkImageProvider(user.profileImageUrl!),
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     begin: Alignment.bottomRight,
  //                     colors: [
  //                       Colors.black.withOpacity(.6),
  //                       Colors.black.withOpacity(.6),
  //                     ],
  //                   ),
  //                 ),
  //               )),
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               SizedBox(
  //                 height: 20.0,
  //               ),
  //               Padding(
  //                 padding:
  //                     const EdgeInsets.only(left: 30.0, top: 30, right: 30),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     user.noBooking!
  //                         ? const SizedBox.shrink()
  //                         : PageFeatureWidget(
  //                             heroTag: workHero,
  //                             title: 'Booking \nPortfolio',
  //                           ),
  //                     exploreWidget,
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               user.noBooking!
  //                   ? NoBooking(
  //                       user: user,
  //                     )
  //                   : Column(
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.only(
  //                               left: 20.0, right: 20, top: 20),
  //                           child: SingleChildScrollView(
  //                             child: Container(
  //                               width: width,
  //                               decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 borderRadius: BorderRadius.only(
  //                                   topLeft: Radius.circular(20),
  //                                   topRight: Radius.circular(20),
  //                                   bottomLeft: Radius.circular(10),
  //                                   bottomRight: Radius.circular(10),
  //                                 ),
  //                               ),
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 crossAxisAlignment:
  //                                     CrossAxisAlignment.center,
  //                                 children: [
  //                                   const SizedBox(
  //                                     height: 20,
  //                                   ),

  //                                   Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.end,
  //                                     children: [
  //                                       Padding(
  //                                         padding: const EdgeInsets.all(8.0),
  //                                         child: IconButton(
  //                                           icon: const Icon(
  //                                             Icons.account_circle,
  //                                             color: Color(0xFF1a1a1a),
  //                                             size: 25.0,
  //                                           ),
  //                                           onPressed: () => Navigator.push(
  //                                               context,
  //                                               MaterialPageRoute(
  //                                                   builder: (_) =>
  //                                                       ProfileScreen(
  //                                                         currentUserId: Provider
  //                                                                 .of<UserData>(
  //                                                                     context)
  //                                                             .currentUserId!,
  //                                                         userId: user.id!,
  //                                                       ))),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   const SizedBox(
  //                                     height: 30,
  //                                   ),
  //                                   Hero(
  //                                     tag: containerHero1,
  //                                     child: CircleAvatar(
  //                                       backgroundColor: Color(0xFFf2f2f2),
  //                                       radius: width > 600 ? 120 : 80.0,
  //                                       backgroundImage:
  //                                           user.profileImageUrl!.isEmpty
  //                                               ? AssetImage(
  //                                                   'assets/images/user_placeholder2.png',
  //                                                 ) as ImageProvider
  //                                               : CachedNetworkImageProvider(
  //                                                   user.profileImageUrl!),
  //                                     ),
  //                                   ),
  //                                   // Stack(
  //                                   //   alignment: FractionalOffset.center,
  //                                   //   children: [
  //                                   //     Hero(
  //                                   //       tag: containerHero1,
  //                                   //       child: Material(
  //                                   //         color: Colors.transparent,
  //                                   //         child: Container(
  //                                   //           height: 200,
  //                                   //           width: width,
  //                                   //           decoration: BoxDecoration(
  //                                   //               color: Color(0xFF1a1a1a),
  //                                   //               borderRadius:
  //                                   //                   BorderRadius.circular(5),
  //                                   //               image: DecorationImage(
  //                                   //                 image:
  //                                   //                     CachedNetworkImageProvider(
  //                                   //                         user.profileImageUrl!),
  //                                   //                 fit: BoxFit.cover,
  //                                   //               )),
  //                                   //           // child: Container(
  //                                   //           //   decoration: BoxDecoration(
  //                                   //           //     gradient: LinearGradient(
  //                                   //           //       begin: Alignment.bottomRight,
  //                                   //           //       colors: [
  //                                   //           //         Colors.black
  //                                   //           //             .withOpacity(.6),
  //                                   //           //         Colors.black
  //                                   //           //             .withOpacity(.6),
  //                                   //           //       ],
  //                                   //           //     ),
  //                                   //           //   ),
  //                                   //           // ),
  //                                   //         ),
  //                                   //       ),
  //                                   //     ),
  //                                   // Text(
  //                                   //   user.name!,
  //                                   //   style: TextStyle(
  //                                   //     color: Colors.white,
  //                                   //     fontSize: 20.0,
  //                                   //     fontFamily: 'Bessita',
  //                                   //     fontWeight: FontWeight.w100,
  //                                   //   ),
  //                                   //     // ),
  //                                   //   ],
  //                                   // ),

  //                                   // SizedBox(height: 20),
  //                                   // Row(
  //                                   //   mainAxisAlignment: MainAxisAlignment.end,
  //                                   //   children: [
  //                                   //     profileWidget,
  //                                   //   ],
  //                                   // ),
  //                                   // SizedBox(height: 20),
  //                                   // Container(
  //                                   //   decoration: BoxDecoration(
  //                                   //     color: Color(0xFFf2f2f2),
  //                                   //     borderRadius:
  //                                   //         BorderRadius.circular(100.0),
  //                                   //   ),
  //                                   //   child: Hero(
  //                                   //     tag: containerHero1,
  //                                   //     child: CircleAvatar(
  //                                   //       backgroundColor: Color(0xFFf2f2f2),
  //                                   //       radius: width > 600 ? 120 : 80.0,
  //                                   //       backgroundImage:
  //                                   //           user.profileImageUrl!.isEmpty
  //                                   //               ? AssetImage(
  //                                   //                   'assets/images/user_placeholder2.png',
  //                                   //                 ) as ImageProvider
  //                                   //               : CachedNetworkImageProvider(
  //                                   //                   user.profileImageUrl!),
  //                                   //     ),
  //                                   //   ),
  //                                   // ),

  //                                   // const SizedBox(
  //                                   //   height: 20,
  //                                   // ),
  //                                   // Icon(
  //                                   //   FontAwesomeIcons.a,
  //                                   //   color: Colors.black,
  //                                   //   size: 40.0,
  //                                   // ),
  //                                   // // Text(
  //                                   // //   user.profileHandle!,
  //                                   // //   style: TextStyle(
  //                                   // //     color: Colors.black,
  //                                   // //     fontSize: 14.0,
  //                                   // //   ),
  //                                   // // ),
  //                                   // Material(
  //                                   //   color: Colors.transparent,
  //                                   //   child: Text(
  //                                   //     'user.company',
  //                                   //     style: TextStyle(
  //                                   //       color: Colors.black,
  //                                   //       fontSize: 12,
  //                                   //     ),
  //                                   //   ),
  //                                   // ),
  //                                   const SizedBox(
  //                                     height: 40,
  //                                   ),
  //                                   Column(
  //                                     children: [
  //                                       new Material(
  //                                         color: Colors.transparent,
  //                                         child: Material(
  //                                           color: Colors.transparent,
  //                                           child: Text(
  //                                             user.userName!,
  //                                             style: TextStyle(
  //                                               color: Colors.black,
  //                                               fontSize: 20.0,
  //                                               fontWeight: FontWeight.bold,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       // new Material(
  //                                       //   color: Colors.transparent,
  //                                       //   child: Text(
  //                                       //     user.profileHandle!,
  //                                       //     style: TextStyle(
  //                                       //       color: ConfigBloc().darkModeOn
  //                                       //           ? Color(0xFF1a1a1a)
  //                                       //           : Colors.black,
  //                                       //       fontSize: 20.0,
  //                                       //       fontWeight: FontWeight.bold,
  //                                       //       letterSpacing: 2.0,
  //                                       //     ),
  //                                       //   ),
  //                                       // ),
  //                                     ],
  //                                   ),
  //                                   Padding(
  //                                     padding: const EdgeInsets.symmetric(
  //                                         horizontal: 10.0),
  //                                     child: HyperLinkText(
  //                                         from: 'Link', text: user.bio),
  //                                   ),
  //                                   const SizedBox(height: 20),
  //                                   user.profileHandle!.startsWith('Fan')
  //                                       ? SizedBox.shrink()
  //                                       : Align(
  //                                           alignment: Alignment.center,
  //                                           child: Wrap(
  //                                             direction: Axis.vertical,
  //                                             children: [
  //                                               Row(
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment
  //                                                         .center,
  //                                                 mainAxisAlignment:
  //                                                     MainAxisAlignment
  //                                                         .center,
  //                                                 children: <Widget>[
  //                                                   Container(
  //                                                     width: 200,
  //                                                     child: OutlinedButton(
  //                                                       style: OutlinedButton
  //                                                           .styleFrom(
  //                                                         primary: Color(
  //                                                             0xFF1a1a1a),
  //                                                         side: BorderSide(
  //                                                           width: 1.0,
  //                                                           color: Color(
  //                                                               0xFF1a1a1a),
  //                                                         ),
  //                                                       ),
  //                                                       onPressed: () =>
  //                                                           Navigator.push(
  //                                                               context,
  //                                                               MaterialPageRoute(
  //                                                                   builder: (_) =>
  //                                                                       UserBooking(
  //                                                                         from:
  //                                                                             'Booking',
  //                                                                         user:
  //                                                                             user,
  //                                                                         currentUserId:
  //                                                                             currentUserId,
  //                                                                         userIsCall:
  //                                                                             1,
  //                                                                       ))),
  //                                                       child: Material(
  //                                                         color: Colors
  //                                                             .transparent,
  //                                                         child: Text(
  //                                                           'Book Me',
  //                                                           style: TextStyle(
  //                                                             color: Colors
  //                                                                 .black,
  //                                                             fontSize: 12.0,
  //                                                           ),
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                   const SizedBox(height: 70),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(height: 3),
  //                         user.profileHandle!.startsWith('Fan')
  //                             ? const SizedBox.shrink()
  //                             : Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     left: 20.0, right: 20),
  //                                 child: Container(
  //                                   width: width,
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     borderRadius: BorderRadius.only(
  //                                       topLeft: Radius.circular(10),
  //                                       topRight: Radius.circular(10),
  //                                       bottomLeft: Radius.circular(10),
  //                                       bottomRight: Radius.circular(10),
  //                                     ),
  //                                   ),
  //                                   child: SingleChildScrollView(
  //                                     child: Column(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.center,
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.center,
  //                                       children: [
  //                                         const SizedBox(height: 40),
  //                                         Container(
  //                                           width: width,
  //                                           child: Column(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.center,
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.center,
  //                                             children: [
  //                                               RichText(
  //                                                 textScaleFactor:
  //                                                     MediaQuery.of(context)
  //                                                         .textScaleFactor
  //                                                         .clamp(0.5, 1.5),
  //                                                 text: TextSpan(
  //                                                   children: [
  //                                                     TextSpan(
  //                                                         text: NumberFormat
  //                                                                 .compact()
  //                                                             .format(point),
  //                                                         style: TextStyle(
  //                                                             fontSize: 30,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold)),
  //                                                     TextSpan(
  //                                                         text:
  //                                                             "\nBars score. ",
  //                                                         style: TextStyle(
  //                                                           fontSize: 14,
  //                                                           color:
  //                                                               Colors.black,
  //                                                         )),
  //                                                     TextSpan(
  //                                                       text:
  //                                                           "\nBased on $userTotal ratings. ",
  //                                                       style: TextStyle(
  //                                                         fontSize: 14,
  //                                                         color: Colors.black,
  //                                                       ),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                                 textAlign: TextAlign.center,
  //                                               ),
  //                                               Row(
  //                                                 mainAxisAlignment:
  //                                                     MainAxisAlignment
  //                                                         .center,
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment
  //                                                         .center,
  //                                                 children: [
  //                                                   Stars(
  //                                                     score: user.score!,
  //                                                   ),
  //                                                 ],
  //                                               ),

  //                                               // ShakeTransition(
  //                                               //   child: Container(
  //                                               //     color: Colors.grey,
  //                                               //     height: 1,
  //                                               //   ),
  //                                               // ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         const SizedBox(
  //                                           height: 20,
  //                                         ),
  //                                         const Divider(
  //                                           color: Colors.black,
  //                                         ),
  //                                         // Container(
  //                                         //   color: Colors.grey[200],
  //                                         //   child: Column(
  //                                         //     children: [
  //                                         //       const SizedBox(
  //                                         //         height: 70,
  //                                         //       ),
  //                                         //       Text(
  //                                         //         'Genres',
  //                                         //         style: TextStyle(
  //                                         //           color: Colors.black,
  //                                         //           fontSize: 12.0,
  //                                         //         ),
  //                                         //       ),
  //                                         //       const SizedBox(
  //                                         //         height: 10,
  //                                         //       ),
  //                                         //       Container(
  //                                         //         color: Colors.grey,
  //                                         //         height: 1,
  //                                         //         width: width / 5,
  //                                         //       ),
  //                                         //       const SizedBox(
  //                                         //         height: 20,
  //                                         //       ),
  //                                         //       Row(
  //                                         //         mainAxisAlignment:
  //                                         //             MainAxisAlignment.center,
  //                                         //         children: [
  //                                         //           Container(
  //                                         //             height: width / 7,
  //                                         //             width: width / 7,
  //                                         //             decoration: BoxDecoration(
  //                                         //                 color: Colors.white,
  //                                         //                 boxShadow: [
  //                                         //                   BoxShadow(
  //                                         //                     color: Colors
  //                                         //                         .grey[200]!,
  //                                         //                     offset: Offset(
  //                                         //                         4.0, 4.0),
  //                                         //                     blurRadius: 15.0,
  //                                         //                     spreadRadius: 1.0,
  //                                         //                   ),
  //                                         //                 ]),
  //                                         //             child: Center(
  //                                         //               child: Text(
  //                                         //                 'Rnb',
  //                                         //                 style: TextStyle(
  //                                         //                   color: Colors.black,
  //                                         //                   fontSize: 12.0,
  //                                         //                 ),
  //                                         //               ),
  //                                         //             ),
  //                                         //           ),
  //                                         //           const SizedBox(
  //                                         //             width: 10,
  //                                         //           ),
  //                                         //           Container(
  //                                         //             height: width / 7,
  //                                         //             width: width / 7,
  //                                         //             color: Colors.white,
  //                                         //             child: Center(
  //                                         //               child: Text(
  //                                         //                 'Reggae',
  //                                         //                 style: TextStyle(
  //                                         //                   color: Colors.black,
  //                                         //                   fontSize: 12.0,
  //                                         //                 ),
  //                                         //               ),
  //                                         //             ),
  //                                         //           ),
  //                                         //         ],
  //                                         //       ),
  //                                         //       const SizedBox(
  //                                         //         height: 10,
  //                                         //       ),
  //                                         //       Row(
  //                                         //         mainAxisAlignment:
  //                                         //             MainAxisAlignment.center,
  //                                         //         children: [
  //                                         //           Container(
  //                                         //             height: width / 7,
  //                                         //             width: width / 7,
  //                                         //             color: Colors.white,
  //                                         //             child: Center(
  //                                         //               child: Text(
  //                                         //                 'Hip\nPop',
  //                                         //                 style: TextStyle(
  //                                         //                   color: Colors.black,
  //                                         //                   fontSize: 12.0,
  //                                         //                 ),
  //                                         //               ),
  //                                         //             ),
  //                                         //           ),
  //                                         //           const SizedBox(
  //                                         //             width: 10,
  //                                         //           ),
  //                                         //           Container(
  //                                         //             height: width / 7,
  //                                         //             width: width / 7,
  //                                         //             color: Colors.white,
  //                                         //             child: Center(
  //                                         //               child: Text(
  //                                         //                 'High\nLife',
  //                                         //                 style: TextStyle(
  //                                         //                   color: Colors.black,
  //                                         //                   fontSize: 12.0,
  //                                         //                 ),
  //                                         //               ),
  //                                         //             ),
  //                                         //           ),
  //                                         //         ],
  //                                         //       ),
  //                                         //       const SizedBox(
  //                                         //         height: 70,
  //                                         //       ),
  //                                         //     ],
  //                                         //   ),
  //                                         // ),

  //                                         const SizedBox(
  //                                           height: 40,
  //                                         ),
  //                                         Padding(
  //                                           padding:
  //                                               const EdgeInsets.symmetric(
  //                                                   horizontal: 20.0),
  //                                           child: Align(
  //                                             alignment: Alignment.topLeft,
  //                                             child: RichText(
  //                                               textScaleFactor:
  //                                                   MediaQuery.of(context)
  //                                                       .textScaleFactor
  //                                                       .clamp(0.5, 1.5),
  //                                               text: TextSpan(children: [
  //                                                 TextSpan(
  //                                                     children: [
  //                                                       TextSpan(
  //                                                           text:
  //                                                               'Username: ',
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 14
  //                                                                     : 12.0,
  //                                                             color:
  //                                                                 Colors.grey,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text:
  //                                                               user.userName,
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 16
  //                                                                     : 12.0,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text:
  //                                                               '\nNick name/ Stage name: ',
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 14
  //                                                                     : 12.0,
  //                                                             color: ConfigBloc()
  //                                                                     .darkModeOn
  //                                                                 ? Colors
  //                                                                     .blueGrey
  //                                                                 : Colors
  //                                                                     .grey,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text: user.name,
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 16
  //                                                                     : 12.0,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text:
  //                                                               '\nCity/ Country & Continent: ',
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 14
  //                                                                     : 12.0,
  //                                                             color: ConfigBloc()
  //                                                                     .darkModeOn
  //                                                                 ? Colors
  //                                                                     .blueGrey
  //                                                                 : Colors
  //                                                                     .grey,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text: user.city! +
  //                                                               "/ ",
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 16
  //                                                                     : 12.0,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text:
  //                                                               user.country! +
  //                                                                   "/ ",
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 16
  //                                                                     : 12.0,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text:
  //                                                               user.continent! +
  //                                                                   '\n',
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 16
  //                                                                     : 12.0,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                           )),
  //                                                       TextSpan(
  //                                                         text: user
  //                                                                 .profileHandle!
  //                                                                 .startsWith(
  //                                                                     'Ar')
  //                                                             ? 'Music Skills:'
  //                                                             : user.profileHandle!
  //                                                                     .startsWith(
  //                                                                         'Co')
  //                                                                 ? 'Design Skills:'
  //                                                                 : user.profileHandle!
  //                                                                         .startsWith('Da')
  //                                                                     ? 'Dance Skills:'
  //                                                                     : user.profileHandle!.startsWith('Ph')
  //                                                                         ? 'Photography Skills:'
  //                                                                         : user.profileHandle!.startsWith('Re')
  //                                                                             ? 'Recording Services'
  //                                                                             : user.profileHandle!.startsWith('Mu')
  //                                                                                 ? 'Video Skills:'
  //                                                                                 : user.profileHandle!.startsWith('Bl')
  //                                                                                     ? 'Blogging Skills:'
  //                                                                                     : user.profileHandle!.startsWith('Br')
  //                                                                                         ? 'Influencing Skills:'
  //                                                                                         : user.profileHandle!.startsWith('Ba')
  //                                                                                             ? 'Battling Skills:'
  //                                                                                             : user.profileHandle!.endsWith('J')
  //                                                                                                 ? 'Dj Skills:'
  //                                                                                                 : user.profileHandle!.endsWith('xen')
  //                                                                                                     ? 'Video Peforming Skills:'
  //                                                                                                     : user.profileHandle!.startsWith('Pr')
  //                                                                                                         ? 'Production Skills:'
  //                                                                                                         : " ",
  //                                                         style: TextStyle(
  //                                                           fontSize:
  //                                                               width > 600
  //                                                                   ? 14
  //                                                                   : 12.0,
  //                                                           color: ConfigBloc()
  //                                                                   .darkModeOn
  //                                                               ? Colors
  //                                                                   .blueGrey
  //                                                               : Colors.grey,
  //                                                         ),
  //                                                       ),
  //                                                       TextSpan(
  //                                                           text:
  //                                                               user.skills! +
  //                                                                   "\n",
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 16
  //                                                                     : 12.0,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text: user
  //                                                                   .profileHandle!
  //                                                                   .startsWith(
  //                                                                       'Ar')
  //                                                               ? 'Music Performances: '
  //                                                               : user.profileHandle!
  //                                                                       .startsWith(
  //                                                                           'Co')
  //                                                                   ? 'Design Exhibitions: '
  //                                                                   : user.profileHandle!
  //                                                                           .startsWith('Ph')
  //                                                                       ? 'Photo Exhibitions: '
  //                                                                       : user.profileHandle!.startsWith('Da')
  //                                                                           ? 'Dance performancess: '
  //                                                                           : user.profileHandle!.startsWith('Ba')
  //                                                                               ? 'Batlle Stages: '
  //                                                                               : user.profileHandle!.endsWith('J')
  //                                                                                   ? 'Performances: '
  //                                                                                   : '',
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 14
  //                                                                     : 12.0,
  //                                                             color: ConfigBloc()
  //                                                                     .darkModeOn
  //                                                                 ? Colors
  //                                                                     .blueGrey
  //                                                                 : Colors
  //                                                                     .grey,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text: user
  //                                                                       .profileHandle!
  //                                                                       .startsWith(
  //                                                                           'Vi') ||
  //                                                                   user.profileHandle!
  //                                                                       .startsWith(
  //                                                                           "Bl") ||
  //                                                                   user
  //                                                                       .profileHandle!
  //                                                                       .startsWith(
  //                                                                           "Br") ||
  //                                                                   user
  //                                                                       .profileHandle!
  //                                                                       .startsWith(
  //                                                                           "Re") ||
  //                                                                   user
  //                                                                       .profileHandle!
  //                                                                       .endsWith(
  //                                                                           "xen") ||
  //                                                                   user.profileHandle!
  //                                                                       .startsWith(
  //                                                                           "Mu") ||
  //                                                                   user.profileHandle!
  //                                                                       .startsWith(
  //                                                                           "Pr")
  //                                                               ? ''
  //                                                               : user.performances! +
  //                                                                   "\n",
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 16
  //                                                                     : 12.0,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text: user
  //                                                                   .profileHandle!
  //                                                                   .startsWith(
  //                                                                       'Ar')
  //                                                               ? 'Music Collaborations: '
  //                                                               : user.profileHandle!
  //                                                                       .startsWith(
  //                                                                           'Co')
  //                                                                   ? 'Design Collaborations: '
  //                                                                   : user.profileHandle!
  //                                                                           .startsWith('Da')
  //                                                                       ? 'Danced With: '
  //                                                                       : user.profileHandle!.startsWith('Ph')
  //                                                                           ? 'Worked With: '
  //                                                                           : user.profileHandle!.startsWith('Mu')
  //                                                                               ? 'Video Works: '
  //                                                                               : user.profileHandle!.endsWith('xen')
  //                                                                                   ? 'Video appearances: '
  //                                                                                   : user.profileHandle!.startsWith('Bl')
  //                                                                                       ? 'Blogged About: '
  //                                                                                       : user.profileHandle!.startsWith('Br')
  //                                                                                           ? 'Worked with: '
  //                                                                                           : user.profileHandle!.startsWith('Ba')
  //                                                                                               ? 'Battled Against: '
  //                                                                                               : user.profileHandle!.endsWith('J')
  //                                                                                                   ? 'Dj Collaborations: '
  //                                                                                                   : user.profileHandle!.startsWith('Re')
  //                                                                                                       ? 'Partners: '
  //                                                                                                       : user.profileHandle!.startsWith('Pr')
  //                                                                                                           ? 'Production Collaborations: '
  //                                                                                                           : '',
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 14
  //                                                                     : 12.0,
  //                                                             color: ConfigBloc()
  //                                                                     .darkModeOn
  //                                                                 ? Colors
  //                                                                     .blueGrey
  //                                                                 : Colors
  //                                                                     .grey,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text:
  //                                                               user.collaborations! +
  //                                                                   "\n",
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 16
  //                                                                     : 12.0,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text: user
  //                                                                   .profileHandle!
  //                                                                   .startsWith(
  //                                                                       'Ar')
  //                                                               ? 'Music Awards:'
  //                                                               : user.profileHandle!
  //                                                                       .startsWith(
  //                                                                           'Co')
  //                                                                   ? 'Design Awards: '
  //                                                                   : user.profileHandle!
  //                                                                           .startsWith('Da')
  //                                                                       ? 'Dance Awards: '
  //                                                                       : user.profileHandle!.startsWith('Ph')
  //                                                                           ? 'Photography Awards: '
  //                                                                           : user.profileHandle!.startsWith('Re')
  //                                                                               ? 'Awards: '
  //                                                                               : user.profileHandle!.startsWith('Mu')
  //                                                                                   ? 'Video Awards: '
  //                                                                                   : user.profileHandle!.endsWith('xen')
  //                                                                                       ? 'Awards: '
  //                                                                                       : user.profileHandle!.startsWith('Bl')
  //                                                                                           ? 'Blogging Awards: '
  //                                                                                           : user.profileHandle!.startsWith('Ba')
  //                                                                                               ? 'Battle Awards: '
  //                                                                                               : user.profileHandle!.endsWith('J')
  //                                                                                                   ? 'Dj Awards: '
  //                                                                                                   : user.profileHandle!.startsWith('Br')
  //                                                                                                       ? 'Awards: '
  //                                                                                                       : user.profileHandle!.startsWith('Pr')
  //                                                                                                           ? 'Beat Production Awards: '
  //                                                                                                           : '',
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 14
  //                                                                     : 12.0,
  //                                                             color: ConfigBloc()
  //                                                                     .darkModeOn
  //                                                                 ? Colors
  //                                                                     .blueGrey
  //                                                                 : Colors
  //                                                                     .grey,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text:
  //                                                               user.awards! +
  //                                                                   "\n",
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 16
  //                                                                     : 12.0,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text:
  //                                                               'Management: ',
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 14
  //                                                                     : 12.0,
  //                                                             color: ConfigBloc()
  //                                                                     .darkModeOn
  //                                                                 ? Colors
  //                                                                     .blueGrey
  //                                                                 : Colors
  //                                                                     .grey,
  //                                                           )),
  //                                                       TextSpan(
  //                                                           text:
  //                                                               user.management! +
  //                                                                   "\n",
  //                                                           style: TextStyle(
  //                                                             fontSize:
  //                                                                 width > 600
  //                                                                     ? 16
  //                                                                     : 12.0,
  //                                                             color: Colors
  //                                                                 .black,
  //                                                           )),
  //                                                     ],
  //                                                     style: TextStyle(
  //                                                       color: Colors.black,
  //                                                     )),
  //                                               ]),
  //                                               textAlign: TextAlign.left,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         SizedBox(height: 20),
  //                                         // user.professionalPicture1!.isEmpty ||
  //                                         //         user.professionalPicture2!
  //                                         //             .isEmpty ||
  //                                         //         user.professionalPicture3!
  //                                         //             .isEmpty
  //                                         //     ? SizedBox.shrink()
  //                                         //     :
  //                                         // Container(
  //                                         //   color: Colors.grey,
  //                                         //   height: 1,
  //                                         //   width: width / 5,
  //                                         // ),
  //                                         Container(
  //                                           color: Colors.grey[200],
  //                                           child: Column(
  //                                             children: [
  //                                               // Padding(
  //                                               //   padding: EdgeInsets.fromLTRB(
  //                                               //       0.0, 20.0, 0.0, 30.0),
  //                                               //   child: currentUserId == user.id
  //                                               //       ? Text(
  //                                               //           'Your gallery',
  //                                               //           style: TextStyle(
  //                                               //             fontSize: width > 600
  //                                               //                 ? 14
  //                                               //                 : 12.0,
  //                                               //             color: Colors.grey,
  //                                               //           ),
  //                                               //         )
  //                                               //       : Text(
  //                                               //           'Check my gallery:',
  //                                               //           style: TextStyle(
  //                                               //             fontSize: width > 600
  //                                               //                 ? 14
  //                                               //                 : 12.0,
  //                                               //             color: Colors.grey,
  //                                               //           ),
  //                                               //         ),
  //                                               // ),
  //                                               GestureDetector(
  //                                                 onTap: () => Navigator.push(
  //                                                     context,
  //                                                     MaterialPageRoute(
  //                                                         builder: (_) =>
  //                                                             BookingGallery(
  //                                                               user: user,
  //                                                               currentUserId:
  //                                                                   currentUserId,
  //                                                             ))),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets
  //                                                           .symmetric(
  //                                                       vertical: 30.0),
  //                                                   child: Row(
  //                                                     mainAxisAlignment:
  //                                                         MainAxisAlignment
  //                                                             .spaceEvenly,
  //                                                     // scrollDirection:
  //                                                     //     Axis.horizontal,
  //                                                     children: [
  //                                                       // user.professionalPicture1!
  //                                                       //         .isEmpty
  //                                                       //     ? Container(
  //                                                       //         height: width / 4,
  //                                                       //         width: width / 4,
  //                                                       //         color:
  //                                                       //             Colors.grey,
  //                                                       //         child: Icon(
  //                                                       //           MdiIcons.image,
  //                                                       //           color: Colors
  //                                                       //               .white,
  //                                                       //           size: 70,
  //                                                       //         ),
  //                                                       //       )
  //                                                       //     : Ink(
  //                                                       //         child: Container(
  //                                                       //           height:
  //                                                       //               width / 4,
  //                                                       //           width:
  //                                                       //               width / 4,
  //                                                       //           decoration:
  //                                                       //               BoxDecoration(
  //                                                       //                   color: Color(
  //                                                       //                       0xFF1a1a1a),
  //                                                       //                   borderRadius:
  //                                                       //                       BorderRadius.circular(
  //                                                       //                           5),
  //                                                       //                   image:
  //                                                       //                       DecorationImage(
  //                                                       //                     image:
  //                                                       //                         CachedNetworkImageProvider(user.professionalPicture1!),
  //                                                       //                     fit: BoxFit
  //                                                       //                         .cover,
  //                                                       //                   )),
  //                                                       //         ),
  //                                                       //       ),
  //                                                       // SizedBox(width: 10),
  //                                                       user.professionalPicture2!
  //                                                               .isEmpty
  //                                                           ? Container(
  //                                                               height:
  //                                                                   width / 4,
  //                                                               width:
  //                                                                   width / 4,
  //                                                               color: Colors
  //                                                                   .grey,
  //                                                               child: Icon(
  //                                                                 MdiIcons
  //                                                                     .image,
  //                                                                 color: Colors
  //                                                                     .white,
  //                                                                 size: 40,
  //                                                               ),
  //                                                             )
  //                                                           : Ink(
  //                                                               child:
  //                                                                   Container(
  //                                                                 height:
  //                                                                     width /
  //                                                                         4,
  //                                                                 width:
  //                                                                     width /
  //                                                                         4,
  //                                                                 decoration: BoxDecoration(
  //                                                                     color: Color(0xFF1a1a1a),
  //                                                                     borderRadius: BorderRadius.circular(5),
  //                                                                     image: DecorationImage(
  //                                                                       image:
  //                                                                           CachedNetworkImageProvider(user.professionalPicture2!),
  //                                                                       fit: BoxFit
  //                                                                           .cover,
  //                                                                     )),
  //                                                               ),
  //                                                             ),

  //                                                       user.professionalPicture3!
  //                                                               .isEmpty
  //                                                           ? Container(
  //                                                               height:
  //                                                                   width / 4,
  //                                                               width:
  //                                                                   width / 4,
  //                                                               color: Colors
  //                                                                   .grey,
  //                                                               child: Icon(
  //                                                                 MdiIcons
  //                                                                     .image,
  //                                                                 color: Colors
  //                                                                     .white,
  //                                                                 size: 40,
  //                                                               ),
  //                                                             )
  //                                                           : Ink(
  //                                                               child:
  //                                                                   Container(
  //                                                                 height:
  //                                                                     width /
  //                                                                         4,
  //                                                                 width:
  //                                                                     width /
  //                                                                         4,
  //                                                                 decoration: BoxDecoration(
  //                                                                     color: Color(0xFF1a1a1a),
  //                                                                     borderRadius: BorderRadius.circular(5),
  //                                                                     image: DecorationImage(
  //                                                                       image:
  //                                                                           CachedNetworkImageProvider(user.professionalPicture3!),
  //                                                                       fit: BoxFit
  //                                                                           .cover,
  //                                                                     )),
  //                                                               ),
  //                                                             ),
  //                                                       user.professionalPicture3!
  //                                                               .isEmpty
  //                                                           ? Container(
  //                                                               height:
  //                                                                   width / 4,
  //                                                               width:
  //                                                                   width / 4,
  //                                                               color: Colors
  //                                                                   .grey,
  //                                                               child: Icon(
  //                                                                 MdiIcons
  //                                                                     .image,
  //                                                                 color: Colors
  //                                                                     .white,
  //                                                                 size: 40,
  //                                                               ),
  //                                                             )
  //                                                           : Ink(
  //                                                               child:
  //                                                                   Container(
  //                                                                 height:
  //                                                                     width /
  //                                                                         4,
  //                                                                 width:
  //                                                                     width /
  //                                                                         4,
  //                                                                 decoration: BoxDecoration(
  //                                                                     color: Color(0xFF1a1a1a),
  //                                                                     borderRadius: BorderRadius.circular(5),
  //                                                                     image: DecorationImage(
  //                                                                       image:
  //                                                                           CachedNetworkImageProvider(user.professionalPicture3!),
  //                                                                       fit: BoxFit
  //                                                                           .cover,
  //                                                                     )),
  //                                                               ),
  //                                                             ),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         SizedBox(height: 40),
  //                                         // user.website!.isEmpty ||
  //                                         //         user.otherSites1!.isEmpty ||
  //                                         //         user.otherSites2!.isEmpty
  //                                         //     ? SizedBox.shrink()
  //                                         //     :
  //                                         Column(
  //                                           children: [
  //                                             // Row(
  //                                             //   mainAxisAlignment:
  //                                             //       MainAxisAlignment
  //                                             //           .spaceEvenly,
  //                                             //   children: [
  //                                             //     Container(
  //                                             //       color: Colors.grey,
  //                                             //       height: 1,
  //                                             //       width: width / 5,
  //                                             //     ),
  //                                             //     Container(
  //                                             //       decoration: BoxDecoration(
  //                                             //           border: Border.all(
  //                                             //               color: Colors.grey,
  //                                             //               width: 1)),
  //                                             //       width: width / 3,
  //                                             //       child: Padding(
  //                                             //         padding:
  //                                             //             const EdgeInsets.all(
  //                                             //                 5.0),
  //                                             //         child: Align(
  //                                             //           alignment:
  //                                             //               Alignment.center,
  //                                             //           child: Text(
  //                                             //             'Work',
  //                                             //             style: TextStyle(
  //                                             //               color: Colors.grey,
  //                                             //               fontSize: 12,
  //                                             //             ),
  //                                             //           ),
  //                                             //         ),
  //                                             //       ),
  //                                             //     ),
  //                                             Container(
  //                                               color: Colors.black,
  //                                               height: 1,
  //                                               width: width / 5,
  //                                             ),
  //                                             //   ],
  //                                             // ),
  //                                             SizedBox(height: 20),
  //                                             Padding(
  //                                               padding: EdgeInsets.fromLTRB(
  //                                                   0.0, 10.0, 0.0, 20.0),
  //                                               child: Text(
  //                                                 currentUserId == user.id
  //                                                     ? 'Your works'
  //                                                     : 'My works:',
  //                                                 style: TextStyle(
  //                                                   fontSize: width > 600
  //                                                       ? 14
  //                                                       : 12.0,
  //                                                   color: Colors.black,
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                             SizedBox(height: 10),
  //                                             Container(
  //                                               color: Colors.grey[200],
  //                                               width: width,
  //                                               child: Padding(
  //                                                 padding: const EdgeInsets
  //                                                         .symmetric(
  //                                                     vertical: 30.0),
  //                                                 child: Row(
  //                                                   mainAxisAlignment:
  //                                                       MainAxisAlignment
  //                                                           .spaceEvenly,
  //                                                   children: [
  //                                                     Column(
  //                                                       children: [
  //                                                         InkWell(
  //                                                           borderRadius:
  //                                                               BorderRadius
  //                                                                   .circular(
  //                                                                       10),
  //                                                           onTap: () {
  //                                                             Navigator.push(
  //                                                               context,
  //                                                               MaterialPageRoute(
  //                                                                 builder: (_) => WebDisclaimer(
  //                                                                     link: user
  //                                                                         .website!,
  //                                                                     contentType:
  //                                                                         user.userName! +
  //                                                                             '\'s Work'),
  //                                                               ),
  //                                                             );
  //                                                           },
  //                                                           child: Ink(
  //                                                             child:
  //                                                                 Container(
  //                                                               height:
  //                                                                   width / 4,
  //                                                               width:
  //                                                                   width / 4,
  //                                                               decoration:
  //                                                                   BoxDecoration(
  //                                                                 color: Color(
  //                                                                     0xFF1a1a1a),
  //                                                                 borderRadius:
  //                                                                     BorderRadius
  //                                                                         .circular(5),
  //                                                               ),
  //                                                               child: Icon(
  //                                                                 MdiIcons
  //                                                                     .web,
  //                                                                 color: Colors
  //                                                                     .white,
  //                                                                 size: 30,
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         ),
  //                                                         SizedBox(
  //                                                             height: 10),
  //                                                         Text(
  //                                                             'Visit\n My website',
  //                                                             textScaleFactor:
  //                                                                 MediaQuery.of(
  //                                                                         context)
  //                                                                     .textScaleFactor
  //                                                                     .clamp(
  //                                                                         0.5,
  //                                                                         1.2),
  //                                                             style: TextStyle(
  //                                                                 fontSize:
  //                                                                     12,
  //                                                                 color: Colors
  //                                                                     .black),
  //                                                             textAlign:
  //                                                                 TextAlign
  //                                                                     .center,
  //                                                             overflow:
  //                                                                 TextOverflow
  //                                                                     .ellipsis),
  //                                                       ],
  //                                                     ),
  //                                                     Column(
  //                                                       children: [
  //                                                         Material(
  //                                                           color: Colors
  //                                                               .transparent,
  //                                                           child: InkWell(
  //                                                             borderRadius:
  //                                                                 BorderRadius
  //                                                                     .circular(
  //                                                                         10),
  //                                                             onTap: () {
  //                                                               Navigator
  //                                                                   .push(
  //                                                                 context,
  //                                                                 MaterialPageRoute(
  //                                                                   builder: (_) => WebDisclaimer(
  //                                                                       link: user
  //                                                                           .otherSites1!,
  //                                                                       contentType:
  //                                                                           user.userName! + '\'s Work'),
  //                                                                 ),
  //                                                               );
  //                                                             },
  //                                                             child: Ink(
  //                                                               child:
  //                                                                   Container(
  //                                                                 height:
  //                                                                     width /
  //                                                                         4,
  //                                                                 width:
  //                                                                     width /
  //                                                                         4,
  //                                                                 decoration:
  //                                                                     BoxDecoration(
  //                                                                   color: Color(
  //                                                                       0xFF1a1a1a),
  //                                                                   borderRadius:
  //                                                                       BorderRadius.circular(
  //                                                                           5),
  //                                                                 ),
  //                                                                 child: Icon(
  //                                                                   MdiIcons
  //                                                                       .playBoxOutline,
  //                                                                   color: Colors
  //                                                                       .white,
  //                                                                   size: 30,
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         ),
  //                                                         SizedBox(
  //                                                             height: 10),
  //                                                         Text(
  //                                                             'Watch \n My Videos',
  //                                                             textScaleFactor:
  //                                                                 MediaQuery.of(
  //                                                                         context)
  //                                                                     .textScaleFactor
  //                                                                     .clamp(
  //                                                                         0.5,
  //                                                                         1.2),
  //                                                             style: TextStyle(
  //                                                                 fontSize:
  //                                                                     12,
  //                                                                 color: Colors
  //                                                                     .black),
  //                                                             textAlign:
  //                                                                 TextAlign
  //                                                                     .center,
  //                                                             overflow:
  //                                                                 TextOverflow
  //                                                                     .ellipsis),
  //                                                       ],
  //                                                     ),
  //                                                     Column(
  //                                                       children: [
  //                                                         InkWell(
  //                                                           borderRadius:
  //                                                               BorderRadius
  //                                                                   .circular(
  //                                                                       10),
  //                                                           onTap: () {
  //                                                             Navigator.push(
  //                                                               context,
  //                                                               MaterialPageRoute(
  //                                                                 builder: (_) => WebDisclaimer(
  //                                                                     link: user
  //                                                                         .otherSites2!,
  //                                                                     contentType:
  //                                                                         user.userName! +
  //                                                                             '\'s Work'),
  //                                                               ),
  //                                                             );
  //                                                           },
  //                                                           child: Ink(
  //                                                             child:
  //                                                                 Container(
  //                                                               height:
  //                                                                   width / 4,
  //                                                               width:
  //                                                                   width / 4,
  //                                                               decoration:
  //                                                                   BoxDecoration(
  //                                                                 color: Color(
  //                                                                     0xFF1a1a1a),
  //                                                                 borderRadius:
  //                                                                     BorderRadius
  //                                                                         .circular(5),
  //                                                               ),
  //                                                               child: Icon(
  //                                                                 Icons.work,
  //                                                                 color: Colors
  //                                                                     .white,
  //                                                                 size: 30,
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         ),
  //                                                         SizedBox(
  //                                                             height: 10),
  //                                                         Text(
  //                                                             'Or\n Check Here',
  //                                                             textScaleFactor:
  //                                                                 MediaQuery.of(
  //                                                                         context)
  //                                                                     .textScaleFactor
  //                                                                     .clamp(
  //                                                                         0.5,
  //                                                                         1.2),
  //                                                             style: TextStyle(
  //                                                                 fontSize:
  //                                                                     12,
  //                                                                 color: Colors
  //                                                                     .black),
  //                                                             textAlign:
  //                                                                 TextAlign
  //                                                                     .center,
  //                                                             overflow:
  //                                                                 TextOverflow
  //                                                                     .ellipsis),
  //                                                       ],
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                         const SizedBox(height: 40),
  //                                         // user.contacts!.isEmpty ||
  //                                         //         user.email!.isEmpty
  //                                         //     ? SizedBox.shrink()
  //                                         //     :
  //                                         // Column(
  //                                         //   children: [
  //                                         // Row(
  //                                         //   mainAxisAlignment:
  //                                         //       MainAxisAlignment.spaceEvenly,
  //                                         //   children: [
  //                                         //     Container(
  //                                         //       color: Colors.grey,
  //                                         //       height: 1,
  //                                         //       width: width / 5,
  //                                         //     ),
  //                                         //     Container(
  //                                         //       decoration: BoxDecoration(
  //                                         //           border: Border.all(
  //                                         //               color: Colors.grey,
  //                                         //               width: 1)),
  //                                         //       width: width / 3,
  //                                         //       child: Padding(
  //                                         //         padding:
  //                                         //             const EdgeInsets.all(
  //                                         //                 5.0),
  //                                         //         child: Align(
  //                                         //           alignment:
  //                                         //               Alignment.center,
  //                                         //           child: Text(
  //                                         //             'Booking',
  //                                         //             style: TextStyle(
  //                                         //               color: Colors.grey,
  //                                         //               fontSize: 12,
  //                                         //             ),
  //                                         //           ),
  //                                         //         ),
  //                                         //       ),
  //                                         //     ),
  //                                         //     Container(
  //                                         //       color: Colors.grey,
  //                                         //       height: 1,
  //                                         //       width: width / 5,
  //                                         //     ),
  //                                         //   ],
  //                                         // ),
  //                                         // const SizedBox(height: 20),
  //                                         // currentUserId == user.id
  //                                         //     ? Text(
  //                                         //         'Your booking contact',
  //                                         //         style: TextStyle(
  //                                         //           fontSize: width > 600
  //                                         //               ? 14
  //                                         //               : 12.0,
  //                                         //           color: Colors.grey,
  //                                         //         ),
  //                                         //       )
  //                                         //     : Text(
  //                                         //         'Book me here',
  //                                         //         style: TextStyle(
  //                                         //           fontSize: width > 600
  //                                         //               ? 14
  //                                         //               : 12.0,
  //                                         //           color: Colors.grey,
  //                                         //         ),
  //                                         //       ),
  //                                         // SizedBox(
  //                                         //   height: 30.0,
  //                                         // ),
  //                                         // Padding(
  //                                         //   padding: const EdgeInsets.only(
  //                                         //       left: 0.0),
  //                                         //   child: Align(
  //                                         //     alignment: Alignment.center,
  //                                         //     child: Container(
  //                                         //       width: width,
  //                                         //       child: ElevatedButton(
  //                                         //         style: ElevatedButton
  //                                         //             .styleFrom(
  //                                         //           primary:
  //                                         //               Color(0xFF1a1a1a),
  //                                         //           onPrimary: Colors.blue,
  //                                         //           shape:
  //                                         //               RoundedRectangleBorder(
  //                                         //             borderRadius:
  //                                         //                 BorderRadius
  //                                         //                     .circular(5.0),
  //                                         //           ),
  //                                         //         ),
  //                                         //         onPressed: () =>
  //                                         //             Navigator.push(
  //                                         //                 context,
  //                                         //                 MaterialPageRoute(
  //                                         //                     builder: (_) =>
  //                                         //                         UserBooking(from: 'Booking',
  //                                         //                           user:
  //                                         //                               user,
  //                                         //                           currentUserId:
  //                                         //                               currentUserId,
  //                                         //                           userIsCall:
  //                                         //                               1,
  //                                         //                         ))),
  //                                         //         child: Material(
  //                                         //           color: Colors.transparent,
  //                                         //           child: Text(
  //                                         //             'Reveal Contact',
  //                                         //             style: TextStyle(
  //                                         //               color: Colors.white,
  //                                         //             ),
  //                                         //           ),
  //                                         //         ),
  //                                         //       ),
  //                                         //     ),
  //                                         //   ),
  //                                         // ),
  //                                         //   ],
  //                                         // ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                       ],
  //                     ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                 child: Container(
  //                   width: width,
  //                   child: ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       primary: Colors.white,
  //                       onPrimary: Colors.blue,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                     ),
  //                     onPressed: () => Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (_) => UserBooking(
  //                                   from: 'Booking',
  //                                   user: user,
  //                                   currentUserId: currentUserId,
  //                                   userIsCall: 1,
  //                                 ))),
  //                     child: Material(
  //                       color: Colors.transparent,
  //                       child: Text(
  //                         'Work with me',
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                 child: Container(
  //                   width: width,
  //                   child: ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       primary: Colors.white,
  //                       onPrimary: Colors.blue,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                     ),
  //                     onPressed: () => Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (_) => UserAdviceScreen(
  //                                   currentUserId: currentUserId,
  //                                   user: user,
  //                                 ))),
  //                     child: Material(
  //                       color: Colors.transparent,
  //                       child: Text(
  //                         'Advice',
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                 child: Container(
  //                   width: width,
  //                   child: ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       primary: Colors.white,
  //                       onPrimary: Colors.blue,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                     ),
  //                     onPressed: () => Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (_) => ProfileRating(
  //                                   user: user,
  //                                   currentUserId: currentUserId,
  //                                 ))),
  //                     child: Material(
  //                       color: Colors.transparent,
  //                       child: Text(
  //                         'Rate',
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               Center(
  //                 child: GestureDetector(
  //                     onTap: () => Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (_) => ReportContentPage(
  //                                   parentContentId: user.id,
  //                                   repotedAuthorId: user.id!,
  //                                   contentId: user.id!,
  //                                   contentType: user.userName!,
  //                                 ))),
  //                     child: Material(
  //                         color: Colors.transparent,
  //                         child: Text('Report',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 12,
  //                             )))),
  //               ),

  //               // Container(
  //               //   width: width,
  //               //   child: Column(
  //               //     mainAxisAlignment: MainAxisAlignment.center,
  //               //     crossAxisAlignment: CrossAxisAlignment.center,
  //               //     children: [
  //               //       GestureDetector(
  //               //         onTap: () => Navigator.push(
  //               //             context,
  //               //             MaterialPageRoute(
  //               //                 builder: (_) => ProfileRating(
  //               //                       user: user,
  //               //                       currentUserId: currentUserId,
  //               //                     ))),
  //               //         child: user.id == currentUserId
  //               //             ? Text(
  //               //                 'Your rating',
  //               //                 style: TextStyle(
  //               //                   fontSize: 12.0,
  //               //                   color: Colors.grey,
  //               //                 ),
  //               //               )
  //               //             : Text(
  //               //                 'Rate ${user.userName!} here',
  //               //                 style: TextStyle(
  //               //                   fontSize: 12.0,
  //               //                   color: Colors.grey,
  //               //                 ),
  //               //               ),
  //               //       ),
  //               //       const SizedBox(height: 20),
  //               //       user.profileHandle!.startsWith('F') ||
  //               //               user.profileHandle!.isEmpty
  //               //           ? SizedBox.shrink()
  //               //           : GestureDetector(
  //               //               onTap: () => Navigator.push(
  //               //                   context,
  //               //                   MaterialPageRoute(
  //               //                       builder: (_) => UserAdviceScreen(
  //               //                             currentUserId: currentUserId,
  //               //                             user: user,
  //               //                           ))),
  //               //               child: Material(
  //               //                   color: Colors.transparent,
  //               //                   child: Text(
  //               //                       user.id == currentUserId
  //               //                           ? 'See advices'
  //               //                           : 'Leave an advice for ' +
  //               //                               user.userName!,
  //               //                       style: TextStyle(
  //               //                         color: Colors.grey,
  //               //                         fontSize: 12,
  //               //                       )))),
  //               //       const SizedBox(height: 20),
  //               //       GestureDetector(
  //               //           onTap: () => Navigator.push(
  //               //               context,
  //               //               MaterialPageRoute(
  //               //                   builder: (_) => ReportContentPage(
  //               //                         parentContentId: user.id,
  //               //                         repotedAuthorId: user.id!,
  //               //                         contentId: user.id!,
  //               //                         contentType: user.userName!,
  //               //                       ))),
  //               //           child: Material(
  //               //               color: Colors.transparent,
  //               //               child: Text('Report  ' + user.userName!,
  //               //                   style: TextStyle(
  //               //                     color: Colors.red,
  //               //                     fontSize: 12,
  //               //                   )))),
  //               //       const SizedBox(height: 20),
  //               //     ],
  //               //   ),
  //               // ),

  //               const SizedBox(height: 50),
  //               Center(
  //                 child: IconButton(
  //                   icon: Icon(Icons.close),
  //                   iconSize: 30.0,
  //                   color: Colors.white,
  //                   onPressed: () => Navigator.pop(context),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 120,
  //               ),
  //               GestureDetector(
  //                   onTap: () => Navigator.push(context,
  //                       MaterialPageRoute(builder: (_) => SuggestionBox())),
  //                   child: Center(
  //                     child: Material(
  //                         color: Colors.transparent,
  //                         child: Text('Suggestion Box',
  //                             style: TextStyle(
  //                               color: Colors.grey,
  //                               fontSize: 12,
  //                             ))),
  //                   )),
  //               const SizedBox(
  //                 height: 70,
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

// import 'package:bars/utilities/exports.dart';
// import 'package:intl/intl.dart';

// class UserProfessionalViewWidget extends StatelessWidget {
//   final VoidCallback onPressedRating;
//   final AccountHolder user;
//   final String containerHero1;
//   final int userTotal;
//   final String currentUserId;
//   final String workHero;
//   final Widget exploreWidget;
//   final Widget profileWidget;
//   final int point;

//   UserProfessionalViewWidget({
//     required this.containerHero1,
//     required this.onPressedRating,
//     required this.point,
//     required this.currentUserId,
//     required this.user,
//     required this.userTotal,
//     required this.exploreWidget,
//     required this.profileWidget,
//     required this.workHero,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final width = Responsive.isDesktop(context)
//         ? 600.0
//         : MediaQuery.of(context).size.width;
//     return ResponsiveScaffold(
//       child: Scaffold(
//         backgroundColor: Color(0xFF1a1a1a),
//         appBar: AppBar(
//           iconTheme: IconThemeData(
//             color: Colors.white,
//           ),
//           automaticallyImplyLeading: true,
//           elevation: 0,
//           backgroundColor: Color(0xFF1a1a1a),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(left: 30.0, top: 30, right: 30),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     user.noBooking!
//                         ? const SizedBox.shrink()
//                         : PageFeatureWidget(
//                             heroTag: workHero,
//                             title: 'Booking \nPortfolio',
//                           ),
//                     exploreWidget,
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               user.noBooking!
//                   ? NoBooking(
//                       user: user,
//                     )
//                   : Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 20, top: 20),
//                           child: SingleChildScrollView(
//                             child: Container(
//                               width: width,
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFf2f2f2),
//                                 borderRadius: BorderRadius.circular(
//                                   20,
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     const SizedBox(height: 20),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         profileWidget,
//                                       ],
//                                     ),
//                                     const SizedBox(height: 20),
//                                     Hero(
//                                       tag: containerHero1,
//                                       child: user.profileImageUrl!.isEmpty
//                                           ? Icon(
//                                               Icons.account_circle,
//                                               size: width > 600 ? 300 : 200.0,
//                                               color: Color(0xFF1a1a1a)
//                                             )
//                                           : CircleAvatar(
//                                               radius: width > 600 ? 120 : 80.0,
//                                               backgroundColor:
//                                                   ConfigBloc().darkModeOn
//                                                       ? Color(0xFF1a1a1a)
//                                                       : Color(0xFFf2f2f2),
//                                               backgroundImage:
//                                                   CachedNetworkImageProvider(
//                                                       user.profileImageUrl!),
//                                             ),
//                                     ),
//                                     const SizedBox(
//                                       height: 20.0,
//                                     ),
//                                     Column(
//                                       children: [
//                                         new Material(
//                                           color: Colors.transparent,
//                                           child: Material(
//                                             color: Colors.transparent,
//                                             child: Text(
//                                               user.name!,
//                                               style: const TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 20.0,
//                                                 fontFamily: 'Bessita',
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         new Material(
//                                           color: Colors.transparent,
//                                           child: Text(
//                                             user.profileHandle!,
//                                             style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 20.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 2.0,
//                                             ),
//                                           ),
//                                         ),
//                                         Material(
//                                           color: Colors.transparent,
//                                           child: Text(
//                                             user.company!,
//                                             style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     HyperLinkText(
//                                       from: 'Link',
//                                       text: user.bio!,
//                                     ),
//                                     const SizedBox(height: 30),
//                                     user.profileHandle!.startsWith('Fan')
//                                         ? SizedBox.shrink()
//                                         : Align(
//                                             alignment: Alignment.center,
//                                             child: Wrap(
//                                               direction: Axis.vertical,
//                                               children: [
//                                                 Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: <Widget>[
//                                                     Container(
//                                                       width: 200,
//                                                       child: OutlinedButton(
//                                                         style: OutlinedButton
//                                                             .styleFrom(
//                                                           primary:
//                                                               Color(0xFF1a1a1a),
//                                                           side: BorderSide(
//                                                             width: 1.0,
//                                                             color: Color(
//                                                                 0xFF1a1a1a),
//                                                           ),
//                                                         ),
//                                                         onPressed:
//                                                             onPressedRating,
//                                                         child: Material(
//                                                           color: Colors
//                                                               .transparent,
//                                                           child: Text(
//                                                             user.id ==
//                                                                     currentUserId
//                                                                 ? 'Your Rating'
//                                                                 : 'Rate Me',
//                                                             style:
//                                                                 const TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 14.0,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 3),
//                         user.profileHandle!.startsWith('Fan')
//                             ? const SizedBox.shrink()
//                             : Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 20.0, right: 20),
//                                 child: Container(
//                                   width: width,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(20.0),
//                                     child: SingleChildScrollView(
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             width: width,
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 RichText(
//                                                   textScaleFactor:
//                                                       MediaQuery.of(context)
//                                                           .textScaleFactor
//                                                           .clamp(0.5, 1.5),
//                                                   text: TextSpan(
//                                                     children: [
//                                                       TextSpan(
//                                                           text: NumberFormat
//                                                                   .compact()
//                                                               .format(point),
//                                                           style: TextStyle(
//                                                               fontSize: 30,
//                                                               color:
//                                                                   Colors.black,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold)),
//                                                       TextSpan(
//                                                           text:
//                                                               "\nBars score. ",
//                                                           style: TextStyle(
//                                                             fontSize: 14,
//                                                             color: Colors.black,
//                                                           )),
//                                                       TextSpan(
//                                                         text:
//                                                             "\nBased on $userTotal ratings. ",
//                                                         style: TextStyle(
//                                                           fontSize: 14,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: [
//                                                     Stars(
//                                                       score: user.score!,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 SizedBox(
//                                                   height: 40,
//                                                 ),
//                                                 ShakeTransition(
//                                                   child: Container(
//                                                     color: Colors.grey,
//                                                     height: 1,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 40,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           RichText(
//                                             textScaleFactor:
//                                                 MediaQuery.of(context)
//                                                     .textScaleFactor
//                                                     .clamp(0.5, 1.5),
//                                             text: TextSpan(children: [
//                                               TextSpan(
//                                                   children: [
//                                                     TextSpan(
//                                                         text: 'Username: ',
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 14
//                                                               : 12.0,
//                                                           color: Colors.grey,
//                                                         )),
//                                                     TextSpan(
//                                                         text: user.userName,
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 16
//                                                               : 12.0,
//                                                           color: Colors.black,
//                                                         )),
//                                                     TextSpan(
//                                                         text:
//                                                             '\nNick name/ Stage name: ',
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 14
//                                                               : 12.0,
//                                                           color: ConfigBloc()
//                                                                   .darkModeOn
//                                                               ? Colors.blueGrey
//                                                               : Colors.grey,
//                                                         )),
//                                                     TextSpan(
//                                                         text: user.name,
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 16
//                                                               : 12.0,
//                                                           color: Colors.black,
//                                                         )),
//                                                     TextSpan(
//                                                         text:
//                                                             '\nCity/ Country & Continent: ',
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 14
//                                                               : 12.0,
//                                                           color: ConfigBloc()
//                                                                   .darkModeOn
//                                                               ? Colors.blueGrey
//                                                               : Colors.grey,
//                                                         )),
//                                                     TextSpan(
//                                                         text: user.city! + "/ ",
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 16
//                                                               : 12.0,
//                                                           color: Colors.black,
//                                                         )),
//                                                     TextSpan(
//                                                         text: user.country! +
//                                                             "/ ",
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 16
//                                                               : 12.0,
//                                                           color: Colors.black,
//                                                         )),
//                                                     TextSpan(
//                                                         text: user.continent! +
//                                                             '\n',
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 16
//                                                               : 12.0,
//                                                           color: Colors.black,
//                                                         )),
//                                                     TextSpan(
//                                                       text: user.profileHandle!
//                                                               .startsWith('Ar')
//                                                           ? 'Music Skills:'
//                                                           : user.profileHandle!
//                                                                   .startsWith(
//                                                                       'Co')
//                                                               ? 'Design Skills:'
//                                                               : user.profileHandle!
//                                                                       .startsWith(
//                                                                           'Da')
//                                                                   ? 'Dance Skills:'
//                                                                   : user.profileHandle!
//                                                                           .startsWith(
//                                                                               'Ph')
//                                                                       ? 'Photography Skills:'
//                                                                       : user.profileHandle!
//                                                                               .startsWith('Re')
//                                                                           ? 'Recording Services'
//                                                                           : user.profileHandle!.startsWith('Mu')
//                                                                               ? 'Video Skills:'
//                                                                               : user.profileHandle!.startsWith('Bl')
//                                                                                   ? 'Blogging Skills:'
//                                                                                   : user.profileHandle!.startsWith('Br')
//                                                                                       ? 'Influencing Skills:'
//                                                                                       : user.profileHandle!.startsWith('Ba')
//                                                                                           ? 'Battling Skills:'
//                                                                                           : user.profileHandle!.endsWith('J')
//                                                                                               ? 'Dj Skills:'
//                                                                                               : user.profileHandle!.endsWith('xen')
//                                                                                                   ? 'Video Peforming Skills:'
//                                                                                                   : user.profileHandle!.startsWith('Pr')
//                                                                                                       ? 'Production Skills:'
//                                                                                                       : " ",
//                                                       style: TextStyle(
//                                                         fontSize: width > 600
//                                                             ? 14
//                                                             : 12.0,
//                                                         color: ConfigBloc()
//                                                                 .darkModeOn
//                                                             ? Colors.blueGrey
//                                                             : Colors.grey,
//                                                       ),
//                                                     ),
//                                                     TextSpan(
//                                                         text:
//                                                             user.skills! + "\n",
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 16
//                                                               : 12.0,
//                                                           color: Colors.black,
//                                                         )),
//                                                     TextSpan(
//                                                         text: user
//                                                                 .profileHandle!
//                                                                 .startsWith(
//                                                                     'Ar')
//                                                             ? 'Music Performances: '
//                                                             : user.profileHandle!
//                                                                     .startsWith(
//                                                                         'Co')
//                                                                 ? 'Design Exhibitions: '
//                                                                 : user.profileHandle!
//                                                                         .startsWith(
//                                                                             'Ph')
//                                                                     ? 'Photo Exhibitions: '
//                                                                     : user.profileHandle!
//                                                                             .startsWith('Da')
//                                                                         ? 'Dance performancess: '
//                                                                         : user.profileHandle!.startsWith('Ba')
//                                                                             ? 'Batlle Stages: '
//                                                                             : user.profileHandle!.endsWith('J')
//                                                                                 ? 'Performances: '
//                                                                                 : '',
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 14
//                                                               : 12.0,
//                                                           color: ConfigBloc()
//                                                                   .darkModeOn
//                                                               ? Colors.blueGrey
//                                                               : Colors.grey,
//                                                         )),
//                                                     TextSpan(
//                                                         text: user.profileHandle!.startsWith('Vi') ||
//                                                                 user.profileHandle!
//                                                                     .startsWith(
//                                                                         "Bl") ||
//                                                                 user.profileHandle!
//                                                                     .startsWith(
//                                                                         "Br") ||
//                                                                 user.profileHandle!
//                                                                     .startsWith(
//                                                                         "Re") ||
//                                                                 user.profileHandle!
//                                                                     .endsWith(
//                                                                         "xen") ||
//                                                                 user.profileHandle!
//                                                                     .startsWith(
//                                                                         "Mu") ||
//                                                                 user.profileHandle!
//                                                                     .startsWith(
//                                                                         "Pr")
//                                                             ? ''
//                                                             : user.performances! +
//                                                                 "\n",
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 16
//                                                               : 12.0,
//                                                           color: Colors.black,
//                                                         )),
//                                                     TextSpan(
//                                                         text: user
//                                                                 .profileHandle!
//                                                                 .startsWith(
//                                                                     'Ar')
//                                                             ? 'Music Collaborations: '
//                                                             : user.profileHandle!
//                                                                     .startsWith(
//                                                                         'Co')
//                                                                 ? 'Design Collaborations: '
//                                                                 : user.profileHandle!
//                                                                         .startsWith(
//                                                                             'Da')
//                                                                     ? 'Danced With: '
//                                                                     : user.profileHandle!
//                                                                             .startsWith('Ph')
//                                                                         ? 'Worked With: '
//                                                                         : user.profileHandle!.startsWith('Mu')
//                                                                             ? 'Video Works: '
//                                                                             : user.profileHandle!.endsWith('xen')
//                                                                                 ? 'Video appearances: '
//                                                                                 : user.profileHandle!.startsWith('Bl')
//                                                                                     ? 'Blogged About: '
//                                                                                     : user.profileHandle!.startsWith('Br')
//                                                                                         ? 'Worked with: '
//                                                                                         : user.profileHandle!.startsWith('Ba')
//                                                                                             ? 'Battled Against: '
//                                                                                             : user.profileHandle!.endsWith('J')
//                                                                                                 ? 'Dj Collaborations: '
//                                                                                                 : user.profileHandle!.startsWith('Re')
//                                                                                                     ? 'Partners: '
//                                                                                                     : user.profileHandle!.startsWith('Pr')
//                                                                                                         ? 'Production Collaborations: '
//                                                                                                         : '',
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 14
//                                                               : 12.0,
//                                                           color: ConfigBloc()
//                                                                   .darkModeOn
//                                                               ? Colors.blueGrey
//                                                               : Colors.grey,
//                                                         )),
//                                                     TextSpan(
//                                                         text:
//                                                             user.collaborations! +
//                                                                 "\n",
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 16
//                                                               : 12.0,
//                                                           color: Colors.black,
//                                                         )),
//                                                     TextSpan(
//                                                         text: user
//                                                                 .profileHandle!
//                                                                 .startsWith(
//                                                                     'Ar')
//                                                             ? 'Music Awards:'
//                                                             : user.profileHandle!
//                                                                     .startsWith(
//                                                                         'Co')
//                                                                 ? 'Design Awards: '
//                                                                 : user.profileHandle!
//                                                                         .startsWith(
//                                                                             'Da')
//                                                                     ? 'Dance Awards: '
//                                                                     : user.profileHandle!
//                                                                             .startsWith('Ph')
//                                                                         ? 'Photography Awards: '
//                                                                         : user.profileHandle!.startsWith('Re')
//                                                                             ? 'Awards: '
//                                                                             : user.profileHandle!.startsWith('Mu')
//                                                                                 ? 'Video Awards: '
//                                                                                 : user.profileHandle!.endsWith('xen')
//                                                                                     ? 'Awards: '
//                                                                                     : user.profileHandle!.startsWith('Bl')
//                                                                                         ? 'Blogging Awards: '
//                                                                                         : user.profileHandle!.startsWith('Ba')
//                                                                                             ? 'Battle Awards: '
//                                                                                             : user.profileHandle!.endsWith('J')
//                                                                                                 ? 'Dj Awards: '
//                                                                                                 : user.profileHandle!.startsWith('Br')
//                                                                                                     ? 'Awards: '
//                                                                                                     : user.profileHandle!.startsWith('Pr')
//                                                                                                         ? 'Beat Production Awards: '
//                                                                                                         : '',
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 14
//                                                               : 12.0,
//                                                           color: ConfigBloc()
//                                                                   .darkModeOn
//                                                               ? Colors.blueGrey
//                                                               : Colors.grey,
//                                                         )),
//                                                     TextSpan(
//                                                         text:
//                                                             user.awards! + "\n",
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 16
//                                                               : 12.0,
//                                                           color: Colors.black,
//                                                         )),
//                                                     TextSpan(
//                                                         text: 'Management: ',
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 14
//                                                               : 12.0,
//                                                           color: ConfigBloc()
//                                                                   .darkModeOn
//                                                               ? Colors.blueGrey
//                                                               : Colors.grey,
//                                                         )),
//                                                     TextSpan(
//                                                         text: user.management! +
//                                                             "\n",
//                                                         style: TextStyle(
//                                                           fontSize: width > 600
//                                                               ? 16
//                                                               : 12.0,
//                                                           color: Colors.black,
//                                                         )),
//                                                   ],
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                   )),
//                                             ]),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                           SizedBox(height: 20),
//                                           user.professionalPicture1!.isEmpty ||
//                                                   user.professionalPicture2!
//                                                       .isEmpty ||
//                                                   user.professionalPicture3!
//                                                       .isEmpty
//                                               ? SizedBox.shrink()
//                                               : Column(
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Container(
//                                                           color: Colors.grey,
//                                                           height: 1,
//                                                           width: width / 5,
//                                                         ),
//                                                         Container(
//                                                           decoration: BoxDecoration(
//                                                               border: Border.all(
//                                                                   color: Colors
//                                                                       .grey,
//                                                                   width: 1)),
//                                                           width: width / 3,
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(5.0),
//                                                             child: Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .center,
//                                                               child: Text(
//                                                                 'Gallery',
//                                                                 style:
//                                                                     TextStyle(
//                                                                   color: Colors
//                                                                       .grey,
//                                                                   fontSize: 12,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           color: Colors.grey,
//                                                           height: 1,
//                                                           width: width / 5,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Padding(
//                                                       padding:
//                                                           EdgeInsets.fromLTRB(
//                                                               0.0,
//                                                               20.0,
//                                                               0.0,
//                                                               30.0),
//                                                       child: currentUserId ==
//                                                               user.id
//                                                           ? Text(
//                                                               'Your gallery',
//                                                               style: TextStyle(
//                                                                 fontSize:
//                                                                     width > 600
//                                                                         ? 14
//                                                                         : 12.0,
//                                                                 color:
//                                                                     Colors.grey,
//                                                               ),
//                                                             )
//                                                           : Text(
//                                                               'Check my gallery:',
//                                                               style: TextStyle(
//                                                                 fontSize:
//                                                                     width > 600
//                                                                         ? 14
//                                                                         : 12.0,
//                                                                 color:
//                                                                     Colors.grey,
//                                                               ),
//                                                             ),
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () =>
//                                                           Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                   builder: (_) =>
//                                                                       BookingGallery(
//                                                                         user:
//                                                                             user,
//                                                                         currentUserId:
//                                                                             currentUserId,
//                                                                       ))),
//                                                       child: Container(
//                                                         height: width / 1.5,
//                                                         child: ListView(
//                                                           scrollDirection:
//                                                               Axis.horizontal,
//                                                           children: [
//                                                             user.professionalPicture1!
//                                                                     .isEmpty
//                                                                 ? Container(
//                                                                     height:
//                                                                         width /
//                                                                             1.5,
//                                                                     width:
//                                                                         width /
//                                                                             1.5,
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     child: Icon(
//                                                                       MdiIcons
//                                                                           .image,
//                                                                       color: Colors
//                                                                           .white,
//                                                                       size: 70,
//                                                                     ),
//                                                                   )
//                                                                 : Ink(
//                                                                     child:
//                                                                         Container(
//                                                                       height:
//                                                                           width /
//                                                                               1.5,
//                                                                       width:
//                                                                           width /
//                                                                               1.5,
//                                                                       decoration: BoxDecoration(
//                                                                           color: Color(0xFF1a1a1a),
//                                                                           borderRadius: BorderRadius.circular(5),
//                                                                           image: DecorationImage(
//                                                                             image:
//                                                                                 CachedNetworkImageProvider(user.professionalPicture1!),
//                                                                             fit:
//                                                                                 BoxFit.cover,
//                                                                           )),
//                                                                     ),
//                                                                   ),
//                                                             SizedBox(width: 10),
//                                                             user.professionalPicture2!
//                                                                     .isEmpty
//                                                                 ? Container(
//                                                                     height:
//                                                                         width /
//                                                                             1.5,
//                                                                     width:
//                                                                         width /
//                                                                             1.5,
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     child: Icon(
//                                                                       MdiIcons
//                                                                           .image,
//                                                                       color: Colors
//                                                                           .white,
//                                                                       size: 70,
//                                                                     ),
//                                                                   )
//                                                                 : Ink(
//                                                                     child:
//                                                                         Container(
//                                                                       height:
//                                                                           width /
//                                                                               1.5,
//                                                                       width:
//                                                                           width /
//                                                                               1.5,
//                                                                       decoration: BoxDecoration(
//                                                                           color: Color(0xFF1a1a1a),
//                                                                           borderRadius: BorderRadius.circular(5),
//                                                                           image: DecorationImage(
//                                                                             image:
//                                                                                 CachedNetworkImageProvider(user.professionalPicture2!),
//                                                                             fit:
//                                                                                 BoxFit.cover,
//                                                                           )),
//                                                                     ),
//                                                                   ),
//                                                             SizedBox(width: 10),
//                                                             user.professionalPicture3!
//                                                                     .isEmpty
//                                                                 ? Container(
//                                                                     height:
//                                                                         width /
//                                                                             1.5,
//                                                                     width:
//                                                                         width /
//                                                                             1.5,
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     child: Icon(
//                                                                       MdiIcons
//                                                                           .image,
//                                                                       color: Colors
//                                                                           .white,
//                                                                       size: 70,
//                                                                     ),
//                                                                   )
//                                                                 : Ink(
//                                                                     child:
//                                                                         Container(
//                                                                       height:
//                                                                           width /
//                                                                               1.5,
//                                                                       width:
//                                                                           width /
//                                                                               1.5,
//                                                                       decoration: BoxDecoration(
//                                                                           color: Color(0xFF1a1a1a),
//                                                                           borderRadius: BorderRadius.circular(5),
//                                                                           image: DecorationImage(
//                                                                             image:
//                                                                                 CachedNetworkImageProvider(user.professionalPicture3!),
//                                                                             fit:
//                                                                                 BoxFit.cover,
//                                                                           )),
//                                                                     ),
//                                                                   ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                           SizedBox(height: 40),
//                                           user.website!.isEmpty ||
//                                                   user.otherSites1!.isEmpty ||
//                                                   user.otherSites2!.isEmpty
//                                               ? SizedBox.shrink()
//                                               : Column(
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceEvenly,
//                                                       children: [
//                                                         Container(
//                                                           color: Colors.grey,
//                                                           height: 1,
//                                                           width: width / 5,
//                                                         ),
//                                                         Container(
//                                                           decoration: BoxDecoration(
//                                                               border: Border.all(
//                                                                   color: Colors
//                                                                       .grey,
//                                                                   width: 1)),
//                                                           width: width / 3,
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(5.0),
//                                                             child: Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .center,
//                                                               child: Text(
//                                                                 'Work',
//                                                                 style:
//                                                                     TextStyle(
//                                                                   color: Colors
//                                                                       .grey,
//                                                                   fontSize: 12,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           color: Colors.grey,
//                                                           height: 1,
//                                                           width: width / 5,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: 20),
//                                                     Padding(
//                                                       padding:
//                                                           EdgeInsets.fromLTRB(
//                                                               0.0,
//                                                               10.0,
//                                                               0.0,
//                                                               20.0),
//                                                       child: currentUserId ==
//                                                               user.id
//                                                           ? Text(
//                                                               'Your works',
//                                                               style: TextStyle(
//                                                                 fontSize:
//                                                                     width > 600
//                                                                         ? 14
//                                                                         : 12.0,
//                                                                 color:
//                                                                     Colors.grey,
//                                                               ),
//                                                             )
//                                                           : Text(
//                                                               'To see my works:',
//                                                               style: TextStyle(
//                                                                 fontSize:
//                                                                     width > 600
//                                                                         ? 14
//                                                                         : 12.0,
//                                                                 color:
//                                                                     Colors.grey,
//                                                               ),
//                                                             ),
//                                                     ),
//                                                     SizedBox(height: 10),
//                                                     Container(
//                                                       width: width,
//                                                       height: MediaQuery.of(
//                                                                       context)
//                                                                   .textScaleFactor >
//                                                               1.3
//                                                           ? width / 2.3
//                                                           : width / 2.5,
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceEvenly,
//                                                         children: [
//                                                           Column(
//                                                             children: [
//                                                               InkWell(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             10),
//                                                                 onTap: () {
//                                                                   Navigator
//                                                                       .push(
//                                                                     context,
//                                                                     MaterialPageRoute(
//                                                                       builder: (_) => WebDisclaimer(
//                                                                           link: user
//                                                                               .website!,
//                                                                           contentType:
//                                                                               user.userName! + '\'s Work'),
//                                                                     ),
//                                                                   );
//                                                                 },
//                                                                 child: Ink(
//                                                                   child:
//                                                                       Container(
//                                                                     height:
//                                                                         width /
//                                                                             4,
//                                                                     width:
//                                                                         width /
//                                                                             4,
//                                                                     decoration:
//                                                                         BoxDecoration(
//                                                                       color: Color(
//                                                                           0xFF1a1a1a),
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               5),
//                                                                     ),
//                                                                     child: Icon(
//                                                                       MdiIcons
//                                                                           .web,
//                                                                       color: Colors
//                                                                           .white,
//                                                                       size: 30,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                   height: 10),
//                                                               Text(
//                                                                   'Visit\n My website',
//                                                                   textScaleFactor: MediaQuery.of(
//                                                                           context)
//                                                                       .textScaleFactor
//                                                                       .clamp(
//                                                                           0.5,
//                                                                           1.2),
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                           12,
//                                                                       color: Colors
//                                                                           .black),
//                                                                   textAlign:
//                                                                       TextAlign
//                                                                           .center,
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis),
//                                                             ],
//                                                           ),
//                                                           Column(
//                                                             children: [
//                                                               Material(
//                                                                 color: Colors
//                                                                     .transparent,
//                                                                 child: InkWell(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10),
//                                                                   onTap: () {
//                                                                     Navigator
//                                                                         .push(
//                                                                       context,
//                                                                       MaterialPageRoute(
//                                                                         builder: (_) => WebDisclaimer(
//                                                                             link:
//                                                                                 user.otherSites1!,
//                                                                             contentType: user.userName! + '\'s Work'),
//                                                                       ),
//                                                                     );
//                                                                   },
//                                                                   child: Ink(
//                                                                     child:
//                                                                         Container(
//                                                                       height:
//                                                                           width /
//                                                                               4,
//                                                                       width:
//                                                                           width /
//                                                                               4,
//                                                                       decoration:
//                                                                           BoxDecoration(
//                                                                         color: Color(
//                                                                             0xFF1a1a1a),
//                                                                         borderRadius:
//                                                                             BorderRadius.circular(5),
//                                                                       ),
//                                                                       child:
//                                                                           Icon(
//                                                                         MdiIcons
//                                                                             .playBoxOutline,
//                                                                         color: Colors
//                                                                             .white,
//                                                                         size:
//                                                                             30,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                   height: 10),
//                                                               Text(
//                                                                   'Watch \n My Videos',
//                                                                   textScaleFactor: MediaQuery.of(
//                                                                           context)
//                                                                       .textScaleFactor
//                                                                       .clamp(
//                                                                           0.5,
//                                                                           1.2),
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                           12,
//                                                                       color: Colors
//                                                                           .black),
//                                                                   textAlign:
//                                                                       TextAlign
//                                                                           .center,
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis),
//                                                             ],
//                                                           ),
//                                                           Column(
//                                                             children: [
//                                                               InkWell(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             10),
//                                                                 onTap: () {
//                                                                   Navigator
//                                                                       .push(
//                                                                     context,
//                                                                     MaterialPageRoute(
//                                                                       builder: (_) => WebDisclaimer(
//                                                                           link: user
//                                                                               .otherSites2!,
//                                                                           contentType:
//                                                                               user.userName! + '\'s Work'),
//                                                                     ),
//                                                                   );
//                                                                 },
//                                                                 child: Ink(
//                                                                   child:
//                                                                       Container(
//                                                                     height:
//                                                                         width /
//                                                                             4,
//                                                                     width:
//                                                                         width /
//                                                                             4,
//                                                                     decoration:
//                                                                         BoxDecoration(
//                                                                       color: Color(
//                                                                           0xFF1a1a1a),
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               5),
//                                                                     ),
//                                                                     child: Icon(
//                                                                       Icons
//                                                                           .work,
//                                                                       color: Colors
//                                                                           .white,
//                                                                       size: 30,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                   height: 10),
//                                                               Text(
//                                                                   'Or\n Check Here',
//                                                                   textScaleFactor: MediaQuery.of(
//                                                                           context)
//                                                                       .textScaleFactor
//                                                                       .clamp(
//                                                                           0.5,
//                                                                           1.2),
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                           12,
//                                                                       color: Colors
//                                                                           .black),
//                                                                   textAlign:
//                                                                       TextAlign
//                                                                           .center,
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                           SizedBox(height: 40),
//                                           user.contacts!.isEmpty ||
//                                                   user.email!.isEmpty
//                                               ? SizedBox.shrink()
//                                               : Column(
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceEvenly,
//                                                       children: [
//                                                         Container(
//                                                           color: Colors.grey,
//                                                           height: 1,
//                                                           width: width / 5,
//                                                         ),
//                                                         Container(
//                                                           decoration: BoxDecoration(
//                                                               border: Border.all(
//                                                                   color: Colors
//                                                                       .grey,
//                                                                   width: 1)),
//                                                           width: width / 3,
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(5.0),
//                                                             child: Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .center,
//                                                               child: Text(
//                                                                 'Booking',
//                                                                 style:
//                                                                     TextStyle(
//                                                                   color: Colors
//                                                                       .grey,
//                                                                   fontSize: 12,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           color: Colors.grey,
//                                                           height: 1,
//                                                           width: width / 5,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: 40),
//                                                     currentUserId == user.id
//                                                         ? Text(
//                                                             'Your booking contact',
//                                                             style: TextStyle(
//                                                               fontSize:
//                                                                   width > 600
//                                                                       ? 14
//                                                                       : 12.0,
//                                                               color:
//                                                                   Colors.grey,
//                                                             ),
//                                                           )
//                                                         : Text(
//                                                             'Book me here',
//                                                             style: TextStyle(
//                                                               fontSize:
//                                                                   width > 600
//                                                                       ? 14
//                                                                       : 12.0,
//                                                               color:
//                                                                   Colors.grey,
//                                                             ),
//                                                           ),
//                                                     SizedBox(
//                                                       height: 30.0,
//                                                     ),
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               left: 0.0),
//                                                       child: Align(
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Container(
//                                                           width: width,
//                                                           child: ElevatedButton(
//                                                             style:
//                                                                 ElevatedButton
//                                                                     .styleFrom(
//                                                               primary: Color(
//                                                                   0xFF1a1a1a),
//                                                               onPrimary:
//                                                                   Colors.blue,
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             5.0),
//                                                               ),
//                                                             ),
//                                                             onPressed: () =>
//                                                                 Navigator.push(
//                                                                     context,
//                                                                     MaterialPageRoute(
//                                                                         builder: (_) =>
//                                                                             UserBooking(
//                                                                               user: user,
//                                                                               currentUserId: currentUserId,
//                                                                               userIsCall: 1,
//                                                                             ))),
//                                                             child: Material(
//                                                               color: Colors
//                                                                   .transparent,
//                                                               child: Text(
//                                                                 'Reveal Contact',
//                                                                 style:
//                                                                     TextStyle(
//                                                                   color: Colors
//                                                                       .white,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                           SizedBox(height: 40),
//                                           Container(
//                                             width: width,
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () => Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (_) =>
//                                                               ProfileRating(
//                                                                 user: user,
//                                                                 currentUserId:
//                                                                     currentUserId,
//                                                               ))),
//                                                   child: user.id ==
//                                                           currentUserId
//                                                       ? Text(
//                                                           'Your rating',
//                                                           style: TextStyle(
//                                                             fontSize:
//                                                                 width > 600
//                                                                     ? 14
//                                                                     : 12.0,
//                                                             color: Colors.blue,
//                                                           ),
//                                                         )
//                                                       : Text(
//                                                           'Rate me here',
//                                                           style: TextStyle(
//                                                             fontSize:
//                                                                 width > 600
//                                                                     ? 14
//                                                                     : 12.0,
//                                                             color: Colors.blue,
//                                                           ),
//                                                         ),
//                                                 ),
//                                                 SizedBox(height: 20),
//                                                 user.profileHandle!
//                                                             .startsWith('F') ||
//                                                         user.profileHandle!
//                                                             .isEmpty
//                                                     ? SizedBox.shrink()
//                                                     : GestureDetector(
//                                                         onTap: () =>
//                                                             Navigator.push(
//                                                                 context,
//                                                                 MaterialPageRoute(
//                                                                     builder: (_) =>
//                                                                         UserAdviceScreen(
//                                                                           currentUserId:
//                                                                               currentUserId,
//                                                                           user:
//                                                                               user,
//                                                                         ))),
//                                                         child: Material(
//                                                             color: Colors
//                                                                 .transparent,
//                                                             child: Text(
//                                                                 user.id ==
//                                                                         currentUserId
//                                                                     ? 'See advices'
//                                                                     : 'Leave an advice for ' +
//                                                                         user
//                                                                             .userName!,
//                                                                 style:
//                                                                     TextStyle(
//                                                                   color: Colors
//                                                                       .blue,
//                                                                   fontSize: 12,
//                                                                 )))),
//                                                 SizedBox(height: 20),
//                                                 GestureDetector(
//                                                     onTap: () => Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (_) =>
//                                                                 ReportContentPage(
//                                                                   parentContentId:
//                                                                       user.id,
//                                                                   repotedAuthorId:
//                                                                       user.id!,
//                                                                   contentId:
//                                                                       user.id!,
//                                                                   contentType: user
//                                                                       .userName!,
//                                                                 ))),
//                                                     child: Material(
//                                                         color:
//                                                             Colors.transparent,
//                                                         child: Text(
//                                                             'Report  ' +
//                                                                 user.userName!,
//                                                             style: TextStyle(
//                                                               color: Colors.red,
//                                                               fontSize: 12,
//                                                             )))),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(height: 5),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                       ],
//                     ),
//               SizedBox(
//                 height: 40,
//               ),
//               GestureDetector(
//                   onTap: () => Navigator.push(context,
//                       MaterialPageRoute(builder: (_) => SuggestionBox())),
//                   child: Center(
//                     child: Material(
//                         color: Colors.transparent,
//                         child: Text('Suggestion Box',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ))),
//                   )),
//               SizedBox(height: 50),
//               Center(
//                 child: IconButton(
//                   icon: Icon(Icons.close),
//                   iconSize: 30.0,
//                   color: Colors.grey,
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//               SizedBox(
//                 height: 50.0,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore: must_be_immutable
class NoBooking extends StatelessWidget {
  AccountHolder user;

  NoBooking({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: ShakeTransition(
                      child: Icon(
                        Icons.work,
                        color: Color(0xFF1a1a1a),
                        size: 100.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Not Available\nFor Booking\n',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      TextSpan(
                        text: user.userName! +
                            ' is working on a project and therefore not available for business at the moment, but hopes to work with you in the future.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
