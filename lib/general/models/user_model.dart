import 'package:bars/utilities/exports.dart';

class AccountHolder {
  final String? id;
  final String? name;
  final String? userName;
  final String? profileImageUrl;
  final String? email;
  final String? bio;
  final String? favouritePunchline;
  final String? favouriteArtist;
  final String? favouriteSong;
  final String? favouriteAlbum;
  final String? company;
  final String? city;
  final String? continent;
  final String? country;
  final String? skills;
  final String? performances;
  final String? collaborations;
  final String? awards;
  final String? management;
  final String? contacts;
  final String? profileHandle;
  final String? website;
  final String? otherSites1;
  final String? otherSites2;
  final String? mail;
  final String? verified;
  final int? score;
  final String? professionalPicture1;
  final String? professionalPicture2;
  final String? professionalPicture3;
  final String? professionalVideo1;
  final String? professionalVideo2;
  final String? professionalVideo3;
  final bool? hideUploads;
  final bool? disableChat;
  final bool? privateAccount;
  final bool? enableBookingOnChat;
  final bool? disableAdvice;
  final bool? disableContentSharing;
  final bool? disableMoodPunchReaction;
  final bool? disableMoodPunchVibe;
  final bool? dontShowContentOnExplorePage;
  final String? specialtyTags;
  final String? subAccountType;
  final String? genreTags;
  final String? report;
  final String? reportConfirmed;
  final bool? hideAdvice;
  final bool? noBooking;
  final bool? disabledAccount;
  final bool? isEmailVerified;
  final String? androidNotificationToken;
  final String? blurHash;
  final Timestamp? timestamp;

  AccountHolder({
    required this.id,
    required this.name,
    required this.enableBookingOnChat,
    required this.userName,
    required this.profileImageUrl,
    required this.email,
    required this.bio,
    required this.favouritePunchline,
    required this.favouriteArtist,
    required this.favouriteSong,
    required this.favouriteAlbum,
    required this.company,
    required this.country,
    required this.skills,
    required this.performances,
    required this.collaborations,
    required this.awards,
    required this.management,
    required this.city,
    required this.continent,
    required this.contacts,
    required this.subAccountType,
    required this.profileHandle,
    required this.isEmailVerified,
    required this.website,
    required this.otherSites1,
    required this.otherSites2,
    required this.mail,
    required this.verified,
    required this.score,
    required this.professionalPicture1,
    required this.professionalPicture2,
    required this.professionalPicture3,
    required this.hideUploads,
    required this.privateAccount,
    required this.disableAdvice,
    required this.disableChat,
    required this.report,
    required this.reportConfirmed,
    required this.hideAdvice,
    required this.genreTags,
    required this.noBooking,
    required this.disabledAccount,
    required this.androidNotificationToken,
    required this.timestamp,
    required this.disableContentSharing,
    required this.disableMoodPunchReaction,
    required this.disableMoodPunchVibe,
    required this.dontShowContentOnExplorePage,
    required this.specialtyTags,
    required this.professionalVideo1,
    required this.professionalVideo2,
    required this.professionalVideo3,
    required this.blurHash,
  });

  factory AccountHolder.fromDoc(DocumentSnapshot doc) {
    return AccountHolder(
      id: doc.id,
      name: doc['name'] ?? '',
      userName: doc['userName'] ?? '',
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      bio: doc['bio'] ?? '',
      favouritePunchline: doc['favouritePunchline'] ?? '',
      favouriteArtist: doc['favouriteArtist'] ?? '',
      favouriteSong: doc['favouriteSong'] ?? '',
      favouriteAlbum: doc['favouriteAlbum'] ?? '',
      company: doc['company'] ?? '',
      country: doc['country'] ?? '',
      city: doc['city'] ?? '',
      continent: doc['continent'] ?? '',
      skills: doc['skills'] ?? '',
      performances: doc['performances'] ?? '',
      collaborations: doc['collaborations'] ?? '',
      awards: doc['awards'] ?? '',
      management: doc['management'] ?? '',
      contacts: doc['contacts'] ?? '',
      profileHandle: doc['profileHandle'] ?? 'Fan',
      website: doc['website'] ?? '',
      otherSites1: doc['otherSites1'] ?? '',
      otherSites2: doc['otherSites2'] ?? '',
      mail: doc['mail'] ?? '',
      verified: doc['verified'] ?? '',
      score: doc['score'] ?? 0,
      professionalPicture1: doc['professionalPicture1'] ?? '',
      professionalPicture2: doc['professionalPicture2'] ?? '',
      professionalPicture3: doc['professionalPicture3'] ?? '',
      professionalVideo1: doc['professionalVideo1'] ?? '',
      professionalVideo2: doc['professionalVideo2'] ?? '',
      professionalVideo3: doc['professionalVideo3'] ?? '',
      report: doc['report'] ?? '',
      reportConfirmed: doc['reportConfirmed'] ?? '',
      blurHash: doc['blurHash'] ?? '',
      specialtyTags: doc['specialtyTags'] ?? '',
      hideUploads: doc['hideUploads'] ?? false,
      privateAccount: doc['privateAccount'] ?? false,
      disableAdvice: doc['disableAdvice'] ?? false,
      disableChat: doc['disableChat'] ?? false,
      disableContentSharing: doc['disableContentSharing'] ?? false,
      disableMoodPunchReaction: doc['disableMoodPunchReaction'] ?? false,
      disableMoodPunchVibe: doc['disableMoodPunchVibe'] ?? false,
      dontShowContentOnExplorePage:
          doc['dontShowContentOnExplorePage'] ?? false,
      enableBookingOnChat: doc['enableBookingOnChat'] ?? false,
      hideAdvice: doc['hideAdvice'] ?? false,
      noBooking: doc['noBooking'] ?? false,
      isEmailVerified: doc['isEmailVerified'] ?? false,
      disabledAccount: doc['disabledAccount'] ?? false,
      androidNotificationToken: doc['androidNotificationToken'] ?? '',
      timestamp: doc['timestamp'],
      genreTags: doc['genreTags'] ?? '',
      subAccountType: doc['subAccountType'] ?? '',
    );
  }
}
