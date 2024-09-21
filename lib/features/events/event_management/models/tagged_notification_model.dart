import 'package:cloud_firestore/cloud_firestore.dart';

class TaggedNotificationModel {
  String id;
  final String taggedParentTitle; // tagged person taggedParentTitle
  final String
      role; // the role of the tagged person either a special guess, an artist, a sponsor or stc.
  final String taggedType; // either its a crew tagged, or a guess or a sponsor.
  final bool
      verifiedTag; // if the tagged is verified by the tagged person or not
  final bool isEvent; // like to tagged person on Bars impression
  // final String? externalProfileLink; //link to tagged person to external sites
  final String? taggedParentId;
  final String? personId;
  final String? taggedParentAuthorId;
  final String taggedParentImageUrl;

  TaggedNotificationModel({
    required this.id,
    required this.taggedParentTitle,
    required this.role,
    required this.taggedType,
    required this.verifiedTag,
    required this.isEvent,
    required this.personId,
    required this.taggedParentId,
    required this.taggedParentAuthorId,
    required this.taggedParentImageUrl,
  });

  factory TaggedNotificationModel.fromDoc(DocumentSnapshot doc) {
    return TaggedNotificationModel(
      id: doc['id'],
      taggedParentTitle: doc['taggedParentTitle'],
      role: doc['role'],
      taggedType: doc['taggedType'],
      verifiedTag: doc['verifiedTag'],
      isEvent: doc['isEvent'],
      personId: doc['personId'],
      taggedParentId: doc['taggedParentId'],
      taggedParentAuthorId: doc['taggedParentAuthorId'],
      taggedParentImageUrl: doc['taggedParentImageUrl'],
    );
  }

  factory TaggedNotificationModel.fromJson(Map<String, dynamic> json) {
    return TaggedNotificationModel(
      id: json['id'],
      taggedParentTitle: json['taggedParentTitle'],
      role: json['role'],
      taggedType: json['taggedType'],
      verifiedTag: json['verifiedTag'],
      isEvent: json['isEvent'],
      personId: json['personId'],
      taggedParentId: json['taggedParentId'],
      taggedParentAuthorId: json['taggedParentAuthorId'],
      taggedParentImageUrl: json['taggedParentImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taggedParentTitle': taggedParentTitle,
      'role': role,
      'taggedType': taggedType,
      'verifiedTag': verifiedTag,
      'isEvent': isEvent,
      'personId': personId,
      'taggedParentId': taggedParentId,
      'taggedParentAuthorId': taggedParentAuthorId,
      'taggedParentImageUrl': taggedParentImageUrl,
    };
  }
}
