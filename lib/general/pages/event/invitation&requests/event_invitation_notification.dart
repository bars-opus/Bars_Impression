import 'package:bars/utilities/exports.dart';

class EventInvitationNotification extends StatelessWidget {
  final String currentUserId;
  final Event event;
  final PaletteGenerator palette;
  final int invitationRespondCount;
  final int attendeeRequesCount;
  const EventInvitationNotification(
      {Key? key,
      required this.currentUserId,
      required this.invitationRespondCount,
      required this.event,
      required this.palette,
      required this.attendeeRequesCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: palette.darkMutedColor == null
                ? Color(0xFF1a1a1a)
                : palette.darkMutedColor!.color,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: 100,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Platform.isIOS
                                    ? Icons.arrow_back_ios
                                    : Icons.arrow_back),
                                color: Colors.white,
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(
                                'Event Notification',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox()
                            ],
                          ),
                          TabBar(
                              labelColor: Colors.white,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: Colors.blue,
                              onTap: (int index) {
                                Provider.of<UserData>(context, listen: false)
                                    .setEventTab(index);
                              },
                              unselectedLabelColor: Colors.grey,
                              isScrollable: true,
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10.0),
                              indicatorWeight: 2.0,
                              tabs: <Widget>[
                                Row(
                                  children: [
                                    attendeeRequesCount != 0
                                        ? Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle),
                                          )
                                        : const SizedBox.shrink(),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      'Requests ',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    invitationRespondCount != 0
                                        ? Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle),
                                          )
                                        : const SizedBox.shrink(),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      'Invitations',
                                    ),
                                  ],
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                EventAttendees(
                  palette: palette,
                  dontShowAnswerWidget: false,
                  event: event,
                  from: 'Received',
                  showAppBar: false,
                ),
                EventInvites(
                  palette: palette,
                  event: event,
                  from: 'Sent',
                  letShowAppBar: false,
                ),
              ],
            )),
      ),
    );

    // Scaffold(
    //   appBar: AppBar(
    //     iconTheme: IconThemeData(
    //       color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
    //     ),
    //     automaticallyImplyLeading: true,
    //     elevation: 0,
    //     backgroundColor:
    //         ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
    //     title: Text(
    //       'Invitation Activity',
    //       style: TextStyle(
    //           color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
    //           fontSize: 20,
    //           fontWeight: FontWeight.bold),
    //     ),
    //     centerTitle: true,
    //   ),
    //   body: ActivityEventScreen(
    //     from: 'Home',
    //     currentUserId: currentUserId,
    //     activityEventCount: count,
    //   ),
    // );
  }
}
