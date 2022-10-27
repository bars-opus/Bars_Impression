import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventInvitationActivityCard extends StatelessWidget {
  final ActivityEvent? activityEvent;
  final EventInvite invite;
  const EventInvitationActivityCard(
      {Key? key, this.activityEvent, required this.invite})
      : super(key: key);

  Future<void> _generatePalette2(context, event) async {
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(invite.eventImageUrl),
      size: Size(1110, 150),
      maximumColorCount: 20,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => EventInviteAvailable(
                from: 'Activity',
                event: event,
                palette: _paletteGenerator,
                eventInvite: invite,
                inviteCount: 0,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: DatabaseService.getInviteEventWithId(invite),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          Event event = snapshot.data;
          return GestureDetector(
              onTap: () => _generatePalette2(context, event),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: invite.attendeeStatus.isNotEmpty
                            ? Colors.transparent
                            : Colors.black26,
                        offset: Offset(10, 10),
                        blurRadius: 10.0,
                        spreadRadius: 4.0,
                      )
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: invite.attendeeStatus.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Cordially\nInvited',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      height: 0.8),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'To attend ${event.title} at  ${event.venue} on ${MyDateFormat.toDate(DateTime.parse(event.date))} at ${MyDateFormat.toTime(DateTime.parse(event.time))}.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  timeago.format(
                                    activityEvent!.timestamp!.toDate(),
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                Text(
                                  'Cordially\nInvited',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.blue,
                                      height: 0.8),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'To attend ${event.title} at  ${event.venue} on ${MyDateFormat.toDate(DateTime.parse(event.date))} at ${MyDateFormat.toTime(DateTime.parse(event.time))}.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  timeago.format(
                                    activityEvent!.timestamp!.toDate(),
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                    ),
                  )));
        });
  }
}
