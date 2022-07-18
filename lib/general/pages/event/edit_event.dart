import 'package:bars/utilities/exports.dart';

class EditEvent extends StatefulWidget {
  final Event event;
  final String? currentUserId;
  static final id = 'Edit_event';

  EditEvent({required this.event, required this.currentUserId});

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  @override
  Widget build(BuildContext context) {
    return CreateEventWidget(
      artist: widget.event.artist,
      date: widget.event.date,
      dj: widget.event.dj,
      dressCode: widget.event.dressCode,
      image: null,
      host: widget.event.host,
      imageUrl: widget.event.imageUrl,
      theme: widget.event.theme,
      isEditting: true,
      guess: widget.event.guess,
      previousEvent: widget.event.previousEvent,
      ticketSite: widget.event.ticketSite,
      rate: widget.event.rate,
      title: widget.event.title,
      time: widget.event.time,
      venue: widget.event.venue,
      user: null,
      type: widget.event.type,
      city: widget.event.city,
      country: widget.event.country,
      virtualVenue: widget.event.virtualVenue,
      triller: widget.event.triller,
      event: widget.event,
      isVirtual: widget.event.isVirtual,
    );
  }
}
