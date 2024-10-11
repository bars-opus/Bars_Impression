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
  final String? shopType;

  @HiveField(5)
  final String? dynamicLink;

  @HiveField(6)
  final bool? disabledAccount;

  @HiveField(7)
  final bool? reportConfirmed;

  @HiveField(8)
  final Timestamp? lastActiveDate;

  @HiveField(9)
  final bool? disableChat;

  // @HiveField(10)
  // final bool? isShop;

  @HiveField(10)
  final String? accountType;

  AccountHolderAuthor({
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.shopType,
    required this.verified,
    required this.accountType,
    required this.dynamicLink,
    required this.disabledAccount,
    required this.reportConfirmed,
    required this.lastActiveDate,
    // required this.isShop,
    required this.disableChat,
  });

  factory AccountHolderAuthor.fromDoc(DocumentSnapshot doc) {
    return AccountHolderAuthor(
      userId: doc.id,
      userName: doc['userName'] ?? '',
      profileImageUrl: doc['profileImageUrl'],
      shopType: doc['shopType'] ?? 'Fan',
      dynamicLink: doc['dynamicLink'] ?? '',
      verified: doc['verified'] ?? false,
      disabledAccount: doc['disabledAccount'] ?? false,
      reportConfirmed: doc['reportConfirmed'] ?? false,
      // isShop: doc['isShop'] ?? false,
      disableChat: doc['disableChat'] ?? false,
      accountType: doc['accountType'] ?? '',
      lastActiveDate:
          doc['lastActiveDate'] ?? Timestamp.fromDate(DateTime.now()),
    );
  }

  factory AccountHolderAuthor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AccountHolderAuthor(
      userId: doc.id,
      accountType: data['accountType'] ?? 'Client',
      dynamicLink: data['dynamicLink'] ?? '',
      lastActiveDate:
          data['lastActiveDate'] ?? Timestamp.fromDate(DateTime.now()),
      userName: data['userName'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      shopType: data['shopType'] ?? '',
      verified: data['verified'] ?? false,
      disabledAccount: data['disabledAccount'] ?? false,
      reportConfirmed: data['reportConfirmed'] ?? false,
      // isShop: data['isShop'] ?? false,
      disableChat: data['disableChat'] ?? false,
    );
  }
}
