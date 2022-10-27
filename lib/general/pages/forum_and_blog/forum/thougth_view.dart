// import 'package:bars/utilities/exports.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class ThoughtView extends StatefulWidget {
//   final Forum forum;
//   final AccountHolder author;
//   final Thought thought;
//   final index;
//   final String currentUserId;

//   ThoughtView(
//       {required this.forum,
//       required this.author,
//       required this.thought,
//       required this.index,
//       required this.currentUserId});

//   @override
//   _ThoughtViewState createState() => _ThoughtViewState();
// }

// class _ThoughtViewState extends State<ThoughtView> {
//   RandomColor _randomColor = RandomColor();
//   final List<ColorHue> _hueType = <ColorHue>[
//     ColorHue.green,
//     ColorHue.red,
//     ColorHue.pink,
//     ColorHue.purple,
//     ColorHue.blue,
//     ColorHue.yellow,
//     ColorHue.orange
//   ];

//   ColorSaturation _colorSaturation = ColorSaturation.random;

//   void initState() {
//     super.initState();
//   }

//   _viewProfessionalProfile() async {
//     AccountHolder user =
//         await DatabaseService.getUserWithId(widget.thought.authorId);

//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (_) => ProfileProfessionalProfile(
//                   currentUserId: Provider.of<UserData>(context).currentUserId!,
//                   user: user,
//                   userId: widget.thought.authorId,
//                 )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final String currentUserId = Provider.of<UserData>(context).currentUserId!;
//     // return FutureBuilder(
//     //   future: DatabaseService.getUserWithId(widget.thought.authorId),
//     //   builder: (BuildContext context, AsyncSnapshot snapshot) {
//     //     if (!snapshot.hasData) {
//     //       return const SizedBox.shrink();
//     //     }
//     //     AccountHolder author = snapshot.data;
//     return FocusedMenuHolder(
//       menuWidth: width,
//       menuOffset: 10,
//       blurBackgroundColor:
//           ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.blueGrey[700],
//       openWithTap: false,
//       onPressed: () {},
//       menuItems: [
//         FocusedMenuItem(
//             title: Container(
//               width: width / 2,
//               child: Text(
//                 currentUserId == widget.thought.authorId
//                     ? 'Edit your thought'
//                     : widget.thought.authorProfileHanlde.startsWith('Fan') ||
//                             widget.thought.authorProfileHanlde.isEmpty
//                         ? 'View profile '
//                         : 'iew booking page ',
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             onPressed: () => currentUserId == widget.thought.authorId
//                 ? Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => EditThought(
//                         thought: widget.thought,
//                         currentUserId: widget.currentUserId,
//                         forum: widget.forum,
//                       ),
//                     ),
//                   )
//                 : widget.thought.authorProfileHanlde.startsWith('Fan') ||
//                         widget.thought.authorProfileHanlde.isEmpty
//                     ? Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => ProfileScreen(
//                                   currentUserId: Provider.of<UserData>(context)
//                                       .currentUserId!,
//                                   userId: widget.thought.authorId,
//                                 )))
//                     : _viewProfessionalProfile),
//         FocusedMenuItem(
//             title: Container(
//               width: width / 2,
//               child: Text(
//                 'Report',
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (_) => ReportContentPage(
//                           parentContentId: widget.forum.id,
//                           repotedAuthorId: widget.thought.authorId,
//                           contentId: widget.thought.id,
//                           contentType: 'thought',
//                         )))),
//       ],
//       child: Slidable(
//         startActionPane: ActionPane(
//           motion: const ScrollMotion(),
//           children: [
//             SlidableAction(
//               onPressed: null,
//               backgroundColor: Colors.cyan[800]!,
//               foregroundColor:
//                   ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
//               icon:
//                   currentUserId == widget.thought.authorId ? Icons.edit : null,
//               label: currentUserId == widget.thought.authorId
//                   ? 'Edit your vibe'
//                   : '',
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: currentUserId == widget.thought.authorId
//               ? CrossAxisAlignment.end
//               : CrossAxisAlignment.start,
//           children: <Widget>[
//             Padding(
//               padding: currentUserId == widget.thought.authorId
//                   ? const EdgeInsets.only(
//                       left: 50.0, bottom: 5.0, top: 10.0, right: 15)
//                   : const EdgeInsets.only(
//                       right: 50.0, bottom: 5.0, top: 10.0, left: 15),
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: currentUserId == widget.thought.authorId
//                         ? Colors.blue[100]
//                         : Colors.white,
//                     borderRadius: currentUserId == widget.thought.authorId
//                         ? BorderRadius.only(
//                             topLeft: Radius.circular(30.0),
//                             topRight: Radius.circular(20.0),
//                             bottomLeft: Radius.circular(30.0))
//                         : BorderRadius.only(
//                             topRight: Radius.circular(30.0),
//                             topLeft: Radius.circular(20.0),
//                             bottomRight: Radius.circular(30.0))),
//                 child: ListTile(
//                   leading: currentUserId == widget.thought.authorId
//                       ? const SizedBox.shrink()
//                       : CircleAvatar(
//                           radius: 20.0,
//                           backgroundColor: Colors.grey,
//                           backgroundImage:
//                               widget.thought.authorProfileImageUrl.isEmpty
//                                   ? AssetImage(
//                                       'assets/images/user_placeholder2.png',
//                                     ) as ImageProvider
//                                   : CachedNetworkImageProvider(
//                                       widget.thought.authorProfileImageUrl),
//                         ),
//                   title: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: currentUserId != widget.thought.authorId
//                         ? CrossAxisAlignment.start
//                         : CrossAxisAlignment.end,
//                     children: <Widget>[
//                       Text(
//                         currentUserId == widget.thought.authorId
//                             ? 'Me'
//                             : widget.thought.authorName,
//                         style: TextStyle(
//                           fontSize: 12.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(widget.thought.authorName,
//                           style: TextStyle(
//                             fontSize: 10.0,
//                             color: Colors.blueGrey,
//                           )),
//                       SizedBox(
//                         height: 5.0,
//                       ),
//                     ],
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: currentUserId == widget.thought.authorId
//                         ? CrossAxisAlignment.end
//                         : CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 2.0),
//                         child: Container(
//                           color: _randomColor.randomColor(
//                             colorHue: ColorHue.multiple(colorHues: _hueType),
//                             colorSaturation: _colorSaturation,
//                           ),
//                           height: 1.0,
//                           width: 50.0,
//                         ),
//                       ),
//                       widget.thought.report.isNotEmpty
//                           ? BarsTextStrikeThrough(
//                               fontSize: 12,
//                               text: widget.thought.content,
//                             )
//                           : Text(
//                               widget.thought.content,
//                               style: TextStyle(
//                                   color: Colors.black, fontSize: 12.0),
//                             ),
//                       SizedBox(height: 10.0),
//                     ],
//                   ),
//                   onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => ProfileScreen(
//                                 currentUserId: Provider.of<UserData>(context)
//                                     .currentUserId!,
//                                 userId: widget.thought.authorId,
//                               ))),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 30.0, bottom: 10, right: 30),
//               child: Text(
//                   timeago.format(
//                     widget.thought.timestamp.toDate(),
//                   ),
//                   style: TextStyle(fontSize: 10, color: Colors.grey)),
//             ),
//           ],
//         ),
//       ),
//     );
//     //   },
//     // );
//   }
// }

import 'package:bars/general/pages/forum_and_blog/forum/replied_thought.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ThoughtView extends StatelessWidget {
  final Forum forum;
  // final AccountHolder author;
  final Thought thought;
  // final index;
  final String currentUserId;
  final bool isBlockedUser;

  ThoughtView(
      {required this.forum,
      // required this.author,
      required this.thought,
      // required this.index,
      required this.currentUserId,
      required this.isBlockedUser});

  // static const RandomColor _randomColor =  RandomColor();
  // static const List<ColorHue> _hueType = <ColorHue>[
  //   ColorHue.green,
  //   ColorHue.red,
  //   ColorHue.pink,
  //   ColorHue.purple,
  //   ColorHue.blue,
  //   ColorHue.yellow,
  //   ColorHue.orange
  // ];

  static const ColorSaturation _colorSaturation = ColorSaturation.random;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId = Provider.of<UserData>(context).currentUserId!;
    // return FutureBuilder(
    //   future: DatabaseService.getUserWithId(widget.thought.authorId),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (!snapshot.hasData) {
    //       return const SizedBox.shrink();
    //     }
    //     AccountHolder author = snapshot.data;
    return FocusedMenuHolder(
      menuWidth: width,
      menuOffset: 10,
      blurBackgroundColor:
          ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.blueGrey[700],
      openWithTap: false,
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                currentUserId == thought.authorId
                    ? 'Edit your thought'
                    : thought.authorProfileHanlde.startsWith('Fan') ||
                            thought.authorProfileHanlde.isEmpty
                        ? 'View profile '
                        : 'View booking page ',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => currentUserId == thought.authorId
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditThought(
                        thought: thought,
                        currentUserId: currentUserId,
                        forum: forum,
                      ),
                    ),
                  )
                : thought.authorProfileHanlde.startsWith('Fan') ||
                        thought.authorProfileHanlde.isEmpty
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  currentUserId: Provider.of<UserData>(context)
                                      .currentUserId!,
                                  userId: thought.authorId,
                                )))
                    : () async {
                        AccountHolder user =
                            await DatabaseService.getUserWithId(
                                thought.authorId);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfileProfessionalProfile(
                                      currentUserId:
                                          Provider.of<UserData>(context)
                                              .currentUserId!,
                                      user: user,
                                      userId: thought.authorId,
                                    )));
                      }),
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Report',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ReportContentPage(
                          parentContentId: forum.id,
                          repotedAuthorId: thought.authorId,
                          contentId: thought.id,
                          contentType: 'thought',
                        )))),
      ],
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                currentUserId == thought.authorId
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditThought(
                            thought: thought,
                            currentUserId: currentUserId,
                            forum: forum,
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
              backgroundColor: Colors.blue,
              foregroundColor:
                  ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
              icon: currentUserId == thought.authorId ? Icons.edit : null,
              label:
                  currentUserId == thought.authorId ? 'Edit your thought' : '',
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: currentUserId == thought.authorId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: currentUserId == thought.authorId
                  ? const EdgeInsets.only(
                      left: 50.0, bottom: 5.0, top: 10.0, right: 15)
                  : const EdgeInsets.only(
                      right: 50.0, bottom: 5.0, top: 10.0, left: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: currentUserId == thought.authorId
                        ? Colors.blue[100]
                        : Colors.white,
                    borderRadius: currentUserId == thought.authorId
                        ? BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(30.0))
                        : BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(30.0))),
                child: ListTile(
                  leading: currentUserId == thought.authorId
                      ? const SizedBox.shrink()
                      : CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: thought.authorProfileImageUrl.isEmpty
                              ? AssetImage(
                                  'assets/images/user_placeholder2.png',
                                ) as ImageProvider
                              : CachedNetworkImageProvider(
                                  thought.authorProfileImageUrl),
                        ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: currentUserId != thought.authorId
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        currentUserId == thought.authorId
                            ? 'Me'
                            : thought.authorName,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(thought.authorName,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.blueGrey,
                          )),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: currentUserId == thought.authorId
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Container(
                          color: Colors.blue,
                          height: 1.0,
                          width: 50.0,
                        ),
                      ),
                      thought.report.isNotEmpty
                          ? BarsTextStrikeThrough(
                              fontSize: 12,
                              text: thought.content,
                            )
                          : Text(
                              thought.content,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0),
                            ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                                currentUserId: Provider.of<UserData>(context)
                                    .currentUserId!,
                                userId: thought.authorId,
                              ))),
                ),
              ),
            ),
            thought.count! != 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReplyThoughtsScreen(
                              thought: thought,
                              currentUserId: currentUserId,
                              forum: forum,
                              isBlocked: isBlockedUser,
                            ),
                          ),
                        );
                      },
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: timeago.format(
                                  thought.timestamp.toDate(),
                                ),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                )),
                            TextSpan(
                                text: " View ${NumberFormat.compact().format(
                                  thought.count,
                                )} replies",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        timeago.format(
                          thought.timestamp.toDate(),
                        ),
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
    //   },
    // );
  }
}
