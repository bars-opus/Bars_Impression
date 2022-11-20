import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String imageUrl;
  final String type;
  final String category;
  final String title;
  final String rate;
  final String theme;
  final String dressCode;
  final String date;
  final String venue;
  final String time;
  final String dj;
  final String guess;
  final String host;
  final String artist;
  final String authorId;
  final String authorName;
  final Timestamp? timestamp;
  final String previousEvent;
  final String triller;
  final String city;
  final String country;
  final String virtualVenue;
  final String report;
  final String reportConfirmed;
  final String blurHash;
  final String ticketSite;
  final String clossingDay;
  final bool isVirtual;
  final bool isFree;
  final String mediaType;
  final String mediaUrl;
  final bool isPrivate;
  final bool isCashPayment;
  final bool showToFollowers;
  final bool showOnExplorePage;

  Event({
    required this.id,
    required this.imageUrl,
    required this.type,
    required this.category,
    required this.title,
    required this.rate,
    required this.venue,
    required this.mediaType,
    required this.mediaUrl,
    required this.date,
    required this.theme,
    required this.dressCode,
    required this.time,
    required this.dj,
    required this.guess,
    required this.host,
    required this.artist,
    required this.authorId,
    required this.report,
    required this.reportConfirmed,
    required this.timestamp,
    required this.previousEvent,
    required this.triller,
    required this.city,
    required this.country,
    required this.virtualVenue,
    required this.ticketSite,
    required this.isVirtual,
    required this.isPrivate,
    required this.blurHash,
    required this.isFree,
    required this.isCashPayment,
    required this.showOnExplorePage,
    required this.showToFollowers,
    required this.clossingDay,
    required this.authorName,
  });

  factory Event.fromDoc(DocumentSnapshot doc) {
    return Event(
      id: doc.id,
      imageUrl: doc['imageUrl'] ?? '',
      type: doc['type'] ?? "",
      category: doc['category'] ?? "",
      title: doc['title'] ?? '',
      rate: doc['rate'] ?? '',
      venue: doc['venue'] ?? '',
      date: doc['date'] ?? '',
      theme: doc['theme'] ?? '',
      dressCode: doc['dressCode'] ?? '',
      time: doc['time'] ?? '',
      dj: doc['dj'] ?? '',
      guess: doc['guess'] ?? '',
      host: doc['host'] ?? '',
      artist: doc['artist'] ?? '',
      authorId: doc['authorId'] ?? '',
      timestamp: doc['timestamp'],
      previousEvent: doc['previousEvent'] ?? '',
      triller: doc['triller'] ?? '',
      mediaUrl: doc['mediaUrl'] ?? '',
      mediaType: doc['mediaType'] ?? '',
      city: doc['city'] ?? '',
      country: doc['country'] ?? '',
      virtualVenue: doc['virtualVenue'],
      ticketSite: doc['ticketSite'],
      report: doc['report'] ?? '',
      reportConfirmed: doc['reportConfirmed'],
      isVirtual: doc['isVirtual'] ?? false,
      isPrivate: doc['isPrivate'] ?? false,
      isFree: doc['isFree'] ?? false,
      isCashPayment: doc['isCashPayment'] ?? false,
      showToFollowers: doc['showToFollowers'] ?? false,
      showOnExplorePage: doc['showOnExplorePage'] ?? false,
      clossingDay: doc['clossingDay'] ?? '',
      blurHash: doc['blurHash'] ?? '',
      authorName: doc['authorName'] ?? '',
    );
  }
}
