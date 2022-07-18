import 'package:cloud_firestore/cloud_firestore.dart';

class Survey {
  final String? id;
  final String lessHelpfulFeature;
  final String mostHelpfulFeature;
  final String moreImprovement;
  final String overRallSatisfaction;
  final String suggesttion;
  final String authorId;
  final Timestamp timestamp;

  Survey({
    required this.lessHelpfulFeature,
    required this.mostHelpfulFeature,
    required this.moreImprovement,
    required this.overRallSatisfaction,
    required this.suggesttion,
    required this.id,
    required this.authorId,
    required this.timestamp,
  });

  factory Survey.fromDoc(DocumentSnapshot doc) {
    return Survey(
      id: doc.id,
      lessHelpfulFeature: doc['lessHelpfulFeature'],
      mostHelpfulFeature: doc['mostHelpfulFeature'],
      moreImprovement: doc['moreImprovement'],
      overRallSatisfaction: doc['overRallSatisfaction'],
      suggesttion: doc['suggesttion'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}
