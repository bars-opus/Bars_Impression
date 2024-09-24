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
  final String? storeType;
  @HiveField(5)
  // final String? name;
  // @HiveField(6)
  final String? bio;
  @HiveField(6)
  final String? dynamicLink;
  @HiveField(7)
  final bool? disabledAccount;
  @HiveField(8)
  final bool? reportConfirmed;
  @HiveField(9)
  final Timestamp? lastActiveDate;
  // @HiveField(12)
  // final bool? privateAccount;
    @HiveField(10)
  final bool? disableChat;

  AccountHolderAuthor({
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.bio,
    required this.storeType,
    required this.verified,
    // required this.name,
    required this.dynamicLink,
    required this.disabledAccount,
    required this.reportConfirmed,
    required this.lastActiveDate,
    // required this.privateAccount,
     required this.disableChat,
  });

  factory AccountHolderAuthor.fromDoc(DocumentSnapshot doc) {
    return AccountHolderAuthor(
      userId: doc.id,
      userName: doc['userName'] ?? '',
      profileImageUrl: doc['profileImageUrl'],
      bio: doc['bio'] ?? '',
      storeType: doc['storeType'] ?? 'Fan',
      dynamicLink: doc['dynamicLink'] ?? '',
      verified: doc['verified'] ?? false,
      disabledAccount: doc['disabledAccount'] ?? false,
      reportConfirmed: doc['reportConfirmed'] ?? false,
      // privateAccount: doc['privateAccount'] ?? false,
            disableChat: doc['disableChat'] ?? false,

      
      // name: doc['name'] ?? '',
      lastActiveDate:
          doc['lastActiveDate'] ?? Timestamp.fromDate(DateTime.now()),
    );
  }

  factory AccountHolderAuthor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AccountHolderAuthor(
      userId: doc.id,
      // name: data['name'] ?? '',
      dynamicLink: data['dynamicLink'] ?? '',
      lastActiveDate:
          doc['lastActiveDate'] ?? Timestamp.fromDate(DateTime.now()),

      userName: data['userName'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      bio: data['bio'] ?? '',
      storeType: data['storeType'] ?? 'Fan',
      verified: data['verified'] ?? false,
      disabledAccount: data['disabledAccount'] ?? false,
      reportConfirmed: data['reportConfirmed'] ?? false,
      // privateAccount: data['privateAccount'] ?? false,
        disableChat: data['disableChat'] ?? false,
      
      // other fields...
    );
  }
}

