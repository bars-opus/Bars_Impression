import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? id;
  final String imageUrl;
  final String caption;
  final String punch;
  final String artist;
  final String musicLink;
  final String hashTag;
  final int likeCount;
  final int disLikeCount;
  final String authorId;
  final String reportConfirmed;
  final String report;
  final String blurHash;
  final String peopleTagged;
  final bool disbleSharing;
  final bool disableReaction;
  final bool disableVibe;
  final Timestamp? timestamp;

  Post({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.artist,
    required this.punch,
    required this.musicLink,
    required this.hashTag,
    required this.likeCount,
    required this.disLikeCount,
    required this.authorId,
    required this.report,
    required this.timestamp,
    required this.blurHash,
    required this.reportConfirmed,
    required this.peopleTagged,
    required this.disbleSharing,
    required this.disableReaction,
    required this.disableVibe,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      imageUrl: doc['imageUrl'],
      caption: doc['caption'],
      artist: doc['artist'],
      punch: doc['punch'],
      musicLink: doc['musicLink'],
      hashTag: doc['hashTag'],
      likeCount: doc['likeCount'],
      disLikeCount: doc['disLikeCount'],
      authorId: doc['authorId'],
      reportConfirmed: doc['reportConfirmed'],
      report: doc['report'] ?? '',
      blurHash: doc['blurHash'] ?? '',
      peopleTagged: doc['peopleTagged'],
      disbleSharing: doc['disbleSharing'] ?? '',
      disableReaction: doc['disableReaction'] ?? '',
      disableVibe: doc['disableVibe'] ?? '',
      timestamp: doc['timestamp'],
    );
  }
}
