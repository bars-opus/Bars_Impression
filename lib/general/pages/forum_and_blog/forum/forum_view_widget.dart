import 'package:animations/animations.dart';
import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForumViewWidget extends StatelessWidget {
  final String currentUserId;
  final Forum forum;
  final int thoughtCount;
  final String feed;

  ForumViewWidget({
    required this.forum,
    required this.currentUserId,
    required this.feed,
    required this.thoughtCount,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openColor: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
      closedColor: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
      transitionType: ContainerTransitionType.fade,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return ListTile(
          title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                    color: Colors.transparent,
                    child: forum.report.isNotEmpty
                        ? BarsTextStrikeThrough(
                            fontSize: 16,
                            text: forum.title,
                          )
                        : BarsTextTitle(
                            text: forum.title,
                          )),
                SizedBox(
                  height: 3.0,
                ),
                Material(
                  color: Colors.transparent,
                  child: forum.report.isNotEmpty
                      ? BarsTextStrikeThrough(
                          fontSize: 12,
                          text: forum.subTitle,
                        )
                      : BarsTextSubTitle(
                          text: forum.subTitle,
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: forum.authorName,
                              style: TextStyle(
                                fontSize: 12,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                              )),
                          TextSpan(
                              text: '\nWhat do you think ?',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              )),
                          TextSpan(
                              text: '\nThoughts:    ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black)),
                          TextSpan(
                              text: thoughtCount.toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black)),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    BarsTextFooter(
                      text: timeago.format(
                        forum.timestamp!.toDate(),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1.0,
                  color: Colors.grey,
                ),
              ]),
          subtitle: SizedBox(
            height: 5.0,
          ),
        );
      },
      openBuilder:
          (BuildContext context, void Function({Object? returnValue}) action) {
        return ThoughtsScreen(
            feed: feed,
            forum: forum,
            thoughtCount: thoughtCount,
            currentUserId: currentUserId);
      },
    );
  }
}
