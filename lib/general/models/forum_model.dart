import 'package:cloud_firestore/cloud_firestore.dart';

class Forum {
  final String id;
  final String title;
  final String subTitle;
  final String report;
  final String reportConfirmed;
  final String authorId;
  final String linkedContentId;
  final String mediaType;
  final String mediaUrl;
  final String forumType;
  final String authorName;
  final bool isPrivate;
  final Timestamp? timestamp;
  final bool showOnExplorePage;

  Forum(
      {required this.id,
      required this.title,
      required this.subTitle,
      required this.report,
      required this.mediaType,
      required this.forumType,
      required this.mediaUrl,
      required this.reportConfirmed,
      required this.isPrivate,
      required this.showOnExplorePage,
      required this.linkedContentId,
      required this.authorId,
      required this.authorName,
      required this.timestamp});

  factory Forum.fromDoc(DocumentSnapshot doc) {
    return Forum(
      id: doc.id,
      title: doc['title'],
      subTitle: doc['subTitle'],
      authorId: doc['authorId'],
      isPrivate: doc['isPrivate'],
      mediaUrl: doc['mediaUrl'] ?? '',
      mediaType: doc['mediaType'] ?? '',
      report: doc['report'] ?? '',
      linkedContentId: doc['linkedContentId'] ?? '',
      reportConfirmed: doc['reportConfirmed'] ?? '',
      showOnExplorePage: doc['showOnExplorePage'] ?? false,
      timestamp: doc['timestamp'],
      forumType: doc['forumType'] ?? '',
      authorName: doc['authorName'] ?? '',
    );
  }
}
