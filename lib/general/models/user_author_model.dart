import 'package:bars/utilities/exports.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'user_author_model.g.dart';

@HiveType(typeId: 7) // Use unique IDs for different classes

class AccountHolderAuthor {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String? userName;
  @HiveField(2)
  final String? profileImageUrl;
  @HiveField(3)
  final bool? verified;
  @HiveField(4)
  final String? profileHandle;
  @HiveField(5)
  final String? name;
  @HiveField(6)
  final String? bio;
  @HiveField(8)
  final String? dynamicLink;
  @HiveField(9)
  final bool? disabledAccount;

  @HiveField(10)
  final bool? reportConfirmed;

   @HiveField(11)
  final Timestamp? lastActiveDate;

  AccountHolderAuthor({
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.bio,
    required this.profileHandle,
    required this.verified,
    required this.name,
    required this.dynamicLink,
    required this.disabledAccount,
    required this.reportConfirmed,    required this.lastActiveDate,

  });

  factory AccountHolderAuthor.fromDoc(DocumentSnapshot doc) {
    return AccountHolderAuthor(
      userId: doc.id,
      userName: doc['userName'] ?? '',
      profileImageUrl: doc['profileImageUrl'],
      bio: doc['bio'] ?? '',
      profileHandle: doc['profileHandle'] ?? 'Fan',
      dynamicLink: doc['dynamicLink'] ?? '',
      verified: doc['verified'] ?? false,
      disabledAccount: doc['disabledAccount'] ?? false,
      reportConfirmed: doc['reportConfirmed'] ?? false,
      name: doc['name'] ?? '',
       lastActiveDate: doc['lastActiveDate'] ?? Timestamp.fromDate(DateTime.now()),
    );
  }

  factory AccountHolderAuthor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AccountHolderAuthor(
      userId: doc.id,
      name: data['name'] ?? '',
      dynamicLink: data['dynamicLink'] ?? '',
      lastActiveDate: doc['lastActiveDate'] ?? Timestamp.fromDate(DateTime.now()),

      userName: data['userName'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      bio: data['bio'] ?? '',
      profileHandle: data['profileHandle'] ?? 'Fan',
      verified: data['verified'] ?? false,
      disabledAccount: data['disabledAccount'] ?? false,
      reportConfirmed: data['reportConfirmed'] ?? false,
      // disableChat: data['disableChat'] ?? false,
      // other fields...
    );
  }
}
