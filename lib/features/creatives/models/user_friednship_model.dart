import 'package:bars/utilities/exports.dart';



class UserFriendshipModel {
   String userId;
   String userName;
   String profileImageUrl;
   bool verified;
   String profileHandle;
   String matchReason;
   String bio;
   String dynamicLink;
   String goal;

  // final bool? reportConfirmed;

  // final Timestamp? lastActiveDate;

  // final bool? privateAccount;
  
  // final bool? disableChat;

  UserFriendshipModel({
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.bio,
    required this.profileHandle,
    required this.verified,
    required this.matchReason,
    required this.dynamicLink,
    required this.goal,
    // required this.reportConfirmed,
    // required this.lastActiveDate,
    // required this.privateAccount,
    //  required this.disableChat,
  });

  factory UserFriendshipModel.fromDoc(DocumentSnapshot doc) {
    return UserFriendshipModel(
      userId: doc.id,
      userName: doc['userName'] ?? '',
      profileImageUrl: doc['profileImageUrl'],
      bio: doc['bio'] ?? '',
      profileHandle: doc['profileHandle'] ?? 'Fan',
      dynamicLink: doc['dynamicLink'] ?? '',
      verified: doc['verified'] ?? false,
      goal: doc['goal'] ?? '',
      // reportConfirmed: doc['reportConfirmed'] ?? false,
      // privateAccount: doc['privateAccount'] ?? false,
      //       disableChat: doc['disableChat'] ?? false,

      
      matchReason: doc['matchReason'] ?? '',
      // lastActiveDate:
      //     doc['lastActiveDate'] ?? Timestamp.fromDate(DateTime.now()),
    );
  }

  factory UserFriendshipModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserFriendshipModel(
      userId: doc.id,
      matchReason: data['matchReason'] ?? '',
      dynamicLink: data['dynamicLink'] ?? '',
      // lastActiveDate:
      //     doc['lastActiveDate'] ?? Timestamp.fromDate(DateTime.now()),

      userName: data['userName'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      bio: data['bio'] ?? '',
      profileHandle: data['profileHandle'] ?? 'Fan',
      verified: data['verified'] ?? false,
      goal: data['goal'] ?? '',
      // reportConfirmed: data['reportConfirmed'] ?? false,
      // privateAccount: data['privateAccount'] ?? false,
      //   disableChat: data['disableChat'] ?? false,
      
      // other fields...
    );
  }
}

