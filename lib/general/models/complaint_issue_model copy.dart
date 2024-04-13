import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintIssueModel {
  final String id;
  final String parentContentId;
  final String complainContentId;
  final String authorId;
  final String parentContentAuthorId;
  final String complainType;
  final String compaintEmail;
  final String issue;
  final bool isResolve;
  final Timestamp timestamp;

  ComplaintIssueModel({
    required this.parentContentId,
    required this.complainType,
    required this.compaintEmail,
    required this.parentContentAuthorId,
    required this.complainContentId,
    required this.isResolve,
    required this.id,
    required this.authorId,
    required this.timestamp,
    required this.issue,
  });

  factory ComplaintIssueModel.fromDoc(DocumentSnapshot doc) {
    return ComplaintIssueModel(
      id: doc.id,
      parentContentId: doc['parentContentId'],
      complainType: doc['complainType'],
      parentContentAuthorId: doc['parentContentAuthorId'],
      complainContentId: doc['complainContentId'],
      compaintEmail: doc['compaintEmail'],
      isResolve: doc['isResolve'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      issue: doc['issue'],
    );
  }

  factory ComplaintIssueModel.fromJson(Map<String, dynamic> json) {
    return ComplaintIssueModel(
      id: json['id'],
      parentContentId: json['parentContentId'],
      complainType: json['complainType'],
      isResolve: json['isResolve'],
      parentContentAuthorId: json['parentContentAuthorId'],
      complainContentId: json['complainContentId'],
      compaintEmail: json['compaintEmail'],
      authorId: json['authorId'],
      timestamp: json['timestamp'],
      issue: json['issue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentContentId': parentContentId,
      'complainType': complainType,
      'isResolve': isResolve,
      'parentContentAuthorId': parentContentAuthorId,
      'complainContentId': complainContentId,
      'compaintEmail': compaintEmail,
      'authorId': authorId,
      'timestamp': timestamp,
      'issue': issue,
    };
  }
}
