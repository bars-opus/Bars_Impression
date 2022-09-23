import 'package:bars/utilities/exports.dart';

class Notifications extends StatelessWidget {
  final String currentUserId;
  final int activityCount;
  final int activityFollowerCount;
  final int activityForumCount;
  final int activityEventCount;

  static final id = 'Notifications';
  const Notifications(
      {required this.currentUserId,
      required this.activityCount,
      required this.activityForumCount,
      required this.activityEventCount,
      required this.activityFollowerCount});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              iconTheme: new IconThemeData(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
              backgroundColor: ConfigBloc().darkModeOn
                  ? Color(0xFF1a1a1a)
                  : Color(0xFFf2f2f2),
              centerTitle: true,
              title: Text('Activity',
                  style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
              bottom: TabBar(
                labelColor:
                    ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                indicatorColor: Colors.blue,
                onTap: (int index) {
                  Provider.of<UserData>(context, listen: false)
                      .setNotificaitonTab(index);
                },
                unselectedLabelColor: Colors.grey,
                labelPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                indicatorWeight: 2.0,
                isScrollable: true,
                tabs: <Widget>[
                  Row(
                    children: [
                      activityFollowerCount == 0
                          ? const SizedBox.shrink()
                          : Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text(
                        'Followers',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      activityCount == 0
                          ? const SizedBox.shrink()
                          : Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text(
                        'Punches',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      activityForumCount == 0
                          ? const SizedBox.shrink()
                          : Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text(
                        'Forums',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      activityEventCount == 0
                          ? const SizedBox.shrink()
                          : Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text(
                        'Events',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
            body: TabBarView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                ActivityFollowerScreen(
                  currentUserId: currentUserId,
                  activityFollowerCount: activityFollowerCount,
                ),
                ActivityScreen(
                  currentUserId: currentUserId,
                  activityCount: activityCount,
                ),
                ActivityForumScreen(
                  currentUserId: currentUserId,
                  activityForumCount: activityForumCount,
                ),
                ActivityEventScreen(from: '',
                  currentUserId: currentUserId,
                  activityEventCount: activityEventCount,
                ),
              ],
            )),
      ),
    );
  }
}
