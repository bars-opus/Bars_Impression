import 'package:bars/utilities/exports.dart';

class AccountHolderAuthor {
  final String? id;

  final String? userName;
  final String? profileImageUrl;
  final String? verified;
  final String? profileHandle;
  final String? bio;

  AccountHolderAuthor({
    required this.id,
    required this.userName,
    required this.profileImageUrl,
    required this.bio,
    required this.profileHandle,
    required this.verified,
  });

  factory AccountHolderAuthor.fromDoc(DocumentSnapshot doc) {
    return AccountHolderAuthor(
      id: doc.id,
      userName: doc['userName'] ?? '',
      profileImageUrl: doc['profileImageUrl'],
      bio: doc['bio'] ?? '',
      profileHandle: doc['profileHandle'] ?? 'Fan',
      verified: doc['verified'] ?? '',
    );
  }
}
