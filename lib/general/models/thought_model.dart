import 'package:cloud_firestore/cloud_firestore.dart';

class Thought {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String authorProfileHanlde;
  final String authorProfileImageUrl;
  final String authorVerification;
  final String report;
  final String mediaType;
  final String mediaUrl;
  bool imported;
  final int? count;
  final int? likeCount;
  final String reportConfirmed;
  final Timestamp? timestamp;

  Thought({
    required this.id,
    required this.content,
    required this.imported,
    required this.authorId,
    required this.report,
    required this.count,
    required this.likeCount,
    required this.mediaType,
    required this.mediaUrl,
    required this.reportConfirmed,
    required this.timestamp,
    required this.authorName,
    required this.authorProfileHanlde,
    required this.authorProfileImageUrl,
    required this.authorVerification,
  });

  factory Thought.fromDoc(DocumentSnapshot doc) {
    return Thought(
      id: doc.id,
      content: doc['content'],
      authorId: doc['authorId'],
      report: doc['report'] ?? '',
      imported: doc['imported'] ?? false,
      mediaUrl: doc['mediaUrl'] ?? '',
      mediaType: doc['mediaType'] ?? '',
      count: doc['count'] ?? 0,
      likeCount: doc['likeCount'] ?? 0,
      reportConfirmed: doc['reportConfirmed'] ?? '',
      timestamp: doc['timestamp'],
      authorName: doc['authorName'] ?? '',
      authorProfileHanlde: doc['authorProfileHanlde'] ?? '',
      authorProfileImageUrl: doc['authorProfileImageUrl'] ?? '',
      authorVerification: doc['authorVerification'] ?? '',
    );
  }
}
