import 'package:bars/utilities/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForumViewWidget extends StatelessWidget {
  final String currentUserId;
  final AccountHolder author;
  final Forum forum;
  final String thougthCount;
  final String titleHero;
  final String subtitleHero;
  final VoidCallback onPressedThougthScreen;

  ForumViewWidget({
    required this.forum,
    required this.author,
    required this.currentUserId,
    required this.titleHero,
    required this.subtitleHero,
    required this.onPressedThougthScreen,
    required this.thougthCount,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              currentUserId == author.id!
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditForum(
                            forum: forum, currentUserId: currentUserId),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                                currentUserId: currentUserId,
                                userId: forum.authorId,
                              )));
            },
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Color(0xFFf2f2f2),
            foregroundColor: Colors.grey,
            icon:
                currentUserId == author.id! ? Icons.edit : Icons.account_circle,
            label: currentUserId == author.id! ? 'Edit forum' : 'Profile page ',
          ),
        ],
      ),
      child: ListTile(
        title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: titleHero,
                child: Material(
                    color: Colors.transparent,
                    child: forum.report.isNotEmpty
                        ? BarsTextStrikeThrough(
                            fontSize: 16,
                            text: forum.title,
                          )
                        : BarsTextTitle(
                            text: forum.title,
                          )),
              ),
              SizedBox(
                height: 3.0,
              ),
              Hero(
                tag: subtitleHero,
                child: Material(
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
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Thoughts:    ',
                        style: TextStyle(
                            fontSize: 12,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black)),
                    TextSpan(
                        text: thougthCount,
                        style: TextStyle(
                            fontSize: 12,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black)),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(height: 10.0, width: 10.0, color: Colors.blue),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'What do you think ?',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                  BarsTextFooter(
                    text: timeago.format(
                      forum.timestamp.toDate(),
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
        onTap: onPressedThougthScreen,
      ),
    );
  }
}
