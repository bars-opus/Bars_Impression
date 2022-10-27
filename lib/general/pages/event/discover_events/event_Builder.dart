import 'package:bars/utilities/exports.dart';

class EventBuilder extends StatefulWidget {
  final DocId docId;
  final AccountHolder user;
  final String currentUserId;

  EventBuilder(
      {required this.docId, required this.user, required this.currentUserId});

  @override
  State<EventBuilder> createState() => _EventBuilderState();
}

class _EventBuilderState extends State<EventBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService.getEventWithId(widget.docId.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          Event event = snapshot.data;

          // return FutureBuilder(
          //     future: DatabaseService.getUserWithId(event.authorId),
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       if (!snapshot.hasData) {
          //         return EventSchimmerBlurHash(
          //           event: event,
          //         );
          //       }
          //       AccountHolder author = snapshot.data;

          return EventView(
            exploreLocation: '',
            feed: 3,
            currentUserId: widget.currentUserId,
            event: event,
            // author: author,
            // eventList: _events,
            user: widget.user,
          );
        });
  }
}
