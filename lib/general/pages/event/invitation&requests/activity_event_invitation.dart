import 'package:bars/utilities/exports.dart';

class ActivityEventInvitation extends StatelessWidget {
  final String currentUserId;

  final int count;
  const ActivityEventInvitation(
      {Key? key, required this.currentUserId, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          title: Text(
            'Invitation Activity',
            style: TextStyle(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ActivityEventScreen(
          from: 'Home',
          currentUserId: currentUserId,
          activityEventCount: count,
        ),
      ),
    );
  }
}
