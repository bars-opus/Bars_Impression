import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ExploreForumsMinWidget extends StatelessWidget {
  final String currentUserId;

  final Forum forum;
  final AccountHolder author;
  final int thougthCount;
  final String feed;
  // final bool showExplore;

  ExploreForumsMinWidget(
      {required this.currentUserId,
      required this.forum,
      required this.author,
      required this.thougthCount,
      required this.feed,
      // @required this.showExplore,
      });

  Future launchURl(String url) async {
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {}
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ThoughtsScreen(
                            feed: feed,
                            forum: forum,
                            thoughtCount: thougthCount,
                            author: author,
                            currentUserId:
                                Provider.of<UserData>(context).currentUserId,
                          ))),
              child: Container(
                  color: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShakeTransition(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: Hero(
                                      tag: 'title' + forum.id.toString(),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: forum.report.isNotEmpty
                                            ? BarsTextStrikeThrough(
                                                fontSize: width > 800 ? 50 : 25,
                                                text: forum.title,
                                              )
                                            : Text(forum.title,
                                                style: TextStyle(
                                                  fontSize:
                                                      width > 800 ? 50 : 25,
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.white
                                                      : Colors.blue[800],
                                                )),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20),
                                  child: Hero(
                                    tag: 'subTitle' + forum.id.toString(),
                                    child: Material(
                                        color: Colors.transparent,
                                        child: forum.report.isNotEmpty
                                            ? BarsTextStrikeThrough(
                                                fontSize: width > 800 ? 18 : 14,
                                                text: forum.subTitle,
                                              )
                                            : Text(
                                                forum.subTitle,
                                                style: TextStyle(
                                                  fontSize:
                                                      width > 800 ? 18 : 14,
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.white
                                                      : Colors.blue[900],
                                                ),
                                              )),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                ShakeTransition(
                                  axis: Axis.vertical,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 10.0,
                                              width: 10.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color: Colors.blue,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: Material(
                                                  color: Colors.transparent,
                                                  child: Text(
                                                    'What do you think?',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.white
                                                          : Colors.blue[900],
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 35.0, right: 20),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'thoughts:    ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                        TextSpan(
                                            text: NumberFormat.compact()
                                                .format(thougthCount),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  )),
            )));
  }
}
