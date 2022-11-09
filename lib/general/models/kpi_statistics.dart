import 'package:cloud_firestore/cloud_firestore.dart';

class KPI {
  String id;
  int booking;
  int event;
  int forum;
  int moodPunched;
  int moodPunchedVideoAccessed;
  int actualllyBooked;
  int advicesSent;
  int asksSent;
  int comentSent;
  int thoughtSent;
  int eventAttend;
  int createdMoodPunched;
  int createForum;
  int createEvennt;

  KPI({
    required this.booking,
    required this.moodPunchedVideoAccessed,
    required this.actualllyBooked,
    required this.moodPunched,
    required this.event,
    required this.asksSent,
    required this.id,
    required this.forum,
    required this.comentSent,
    required this.advicesSent,
    required this.eventAttend,
    required this.thoughtSent,
    required this.createEvennt,
    required this.createForum,
    required this.createdMoodPunched,
  });

  factory KPI.fromDoc(DocumentSnapshot doc) {
    return KPI(
      id: doc.id,
      booking: doc['booking'] ?? 0,
      moodPunchedVideoAccessed: doc['moodPunchedVideoAccessed'] ?? 0,
      moodPunched: doc['moodPunched'] ?? 0,
      event: doc['event'] ?? 0,
      actualllyBooked: doc['actualllyBooked'] ?? 0,
      asksSent: doc['asksSent'] ?? 0,
      forum: doc['forum'] ?? 0,
      comentSent: doc['comentSent'] ?? 0,
      advicesSent: doc['advicesSent'] ?? 0,
      thoughtSent: doc['thoughtSent'] ?? 0,
      eventAttend: doc['eventAttend'] ?? 0,
      createEvennt: doc['createEvent'] ?? 0,
      createForum: doc['createForum'] ?? 0,
      createdMoodPunched: doc['createdMoodPunched'] ?? 0,
    );
  }
}
