import 'package:bars/utilities/exports.dart';

class OnCalendarEventList extends StatelessWidget {
  final List<Event> events;
 final List<Event> eventList;
 final List<DocumentSnapshot> eventSnapshot;
  final String currentUserId;

  OnCalendarEventList({
    Key? key,
    required this.events,
    required this.eventList,
    required this.eventSnapshot,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height.toDouble(),
      width: width.toDouble(),
     
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          Event event = events[index];
          return EventDisplayWidget(
            currentUserId: currentUserId,
            event: event,
            eventList: eventList,
            pageIndex: 0,
            eventSnapshot: eventSnapshot,
            eventPagesOnly: true,
            liveCity: '',
            liveCountry: '',
            sortNumberOfDays: 0,
            isFrom: '',
          );
        },
      ),
    );
  }
}
