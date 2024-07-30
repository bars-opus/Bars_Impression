import 'package:bars/utilities/exports.dart';

class Event {
  String id;
  final String title;
  final String theme;
  final Timestamp startDate;
  final String address;
  final String imageUrl;
  List<Schedule> schedule;
  List<TicketModel> ticket;
  List<TaggedEventPeopleModel> taggedPeople;
  List<String> contacts;
  final String termsAndConditions;
  final String type;
  final String category;
  final String rate;
  final String dressCode;
  final String venue;
  final String time;
  final String authorId;
  final String authorName;
  final Timestamp? timestamp;
  final String previousEvent;
  final String triller;
  final String city;
  final String country;
  final String virtualVenue;
  final String report;
  final String reportConfirmed;
  final String blurHash;
  final String ticketSite;
  final String improvemenSuggestion;

  final Timestamp clossingDay;
  final bool isVirtual;
  final bool isFree;
  final bool isPrivate;
  final bool isCashPayment;
  final bool showToFollowers;
  final bool showOnExplorePage;
  final bool fundsDistributed;
  final String dynamicLink;
  final String subaccountId;
  final String transferRecepientId;
  final bool isAffiliateEnabled;
  final bool isAffiliateExclusive;
  final double totalAffiliateAmount;
  final String latLng;

  Event({
    required this.id,
    required this.title,
    required this.theme,
    required this.startDate,
    required this.address,
    required this.imageUrl,
    this.schedule = const [],
    this.ticket = const [],
    this.taggedPeople = const [],
    this.contacts = const [],
    required this.termsAndConditions,
    required this.type,
    required this.category,
    required this.rate,
    required this.venue,
    required this.dressCode,
    required this.time,
    required this.authorId,
    required this.report,
    required this.reportConfirmed,
    required this.timestamp,
    required this.previousEvent,
    required this.triller,
    required this.city,
    required this.country,
    required this.improvemenSuggestion,
    required this.virtualVenue,
    required this.ticketSite,
    required this.isVirtual,
    required this.isPrivate,
    required this.blurHash,
    required this.isFree,
    required this.isCashPayment,
    required this.showOnExplorePage,
    required this.showToFollowers,
    required this.clossingDay,
    required this.authorName,
    required this.dynamicLink,
    required this.fundsDistributed,
    required this.subaccountId,
    required this.transferRecepientId,
    required this.isAffiliateEnabled,
    required this.isAffiliateExclusive,
    required this.totalAffiliateAmount,
    required this.latLng,
  });

  factory Event.fromDoc(DocumentSnapshot doc) {
    return Event(
      id: doc.id,
      title: doc['title'] ?? '',
      theme: doc['theme'] ?? '',
      dynamicLink: doc['dynamicLink'] ?? '',
      subaccountId: doc['subaccountId'] ?? '',
      transferRecepientId: doc['transferRecepientId'] ?? '',
      improvemenSuggestion: doc['improvemenSuggestion'] ?? '',
      contacts: List<String>.from(doc['contacts'] ?? []),
      startDate: doc['startDate'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      address: doc['address'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
      schedule: List<Schedule>.from(
          doc['schedule']?.map((schedule) => Schedule.fromJson(schedule)) ??
              []),
      ticket: List<TicketModel>.from(
          doc['ticket']?.map((ticket) => TicketModel.fromJson(ticket)) ?? []),
      taggedPeople: List<TaggedEventPeopleModel>.from(doc['taggedPeople']?.map(
              (taggedPeople) =>
                  TaggedEventPeopleModel.fromJson(taggedPeople)) ??
          []),
      type: doc['type'] ?? "",
      termsAndConditions: doc['termsAndConditions'] ?? "",
      category: doc['category'] ?? "",
      rate: doc['rate'] ?? '',
      venue: doc['venue'] ?? '',
      dressCode: doc['dressCode'] ?? '',
      time: doc['time'] ?? '',
      authorId: doc['authorId'] ?? '',
      timestamp: doc['timestamp'],
      previousEvent: doc['previousEvent'] ?? '',
      triller: doc['triller'] ?? '',
      city: doc['city'] ?? '',
      country: doc['country'] ?? '',
      virtualVenue: doc['virtualVenue'],
      ticketSite: doc['ticketSite'] ?? '',
      report: doc['report'] ?? '',
      reportConfirmed: doc['reportConfirmed'],
      isVirtual: doc['isVirtual'] ?? false,
      isPrivate: doc['isPrivate'] ?? false,
      isFree: doc['isFree'] ?? false,
      isCashPayment: doc['isCashPayment'] ?? false,
      showToFollowers: doc['showToFollowers'] ?? false,
      showOnExplorePage: doc['showOnExplorePage'] ?? true,
      fundsDistributed: doc['fundsDistributed'] ?? false,
      isAffiliateEnabled: doc['isAffiliateEnabled'] ?? false,
      isAffiliateExclusive: doc['isAffiliateExclusive'] ?? false,
      clossingDay: doc['clossingDay'] ??
          Timestamp.fromDate(
            DateTime.now(),
          ),
      blurHash: doc['blurHash'] ?? '',
      authorName: doc['authorName'] ?? '',
      totalAffiliateAmount: doc['totalAffiliateAmount'].toDouble(),
      latLng: doc['latLng'] ?? '',
    );
  }

  factory Event.fromJson(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subaccountId: map['subaccountId'] ?? '',
      theme: map['theme'] ?? '',
      dynamicLink: map['dynamicLink'] ?? '',
      improvemenSuggestion: map['improvemenSuggestion'] ?? '',
      contacts: (map['contacts'] as List<dynamic>)
          .map((accountType) => accountType as String)
          .toList(),
      startDate: map['startDate'] ?? Timestamp.fromDate(DateTime.now()),
      address: map['address'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      schedule: List<Schedule>.from(
        (map['schedule'] as List<dynamic>?)
                ?.map((schedule) => Schedule.fromJson(schedule))
                .toList() ??
            [],
      ),
      ticket: List<TicketModel>.from(
        (map['ticket'] as List<dynamic>?)
                ?.map((ticket) => TicketModel.fromJson(ticket))
                .toList() ??
            [],
      ),
      taggedPeople: List<TaggedEventPeopleModel>.from(
        (map['taggedPeople'] as List<dynamic>?)
                ?.map((taggedPeople) =>
                    TaggedEventPeopleModel.fromJson(taggedPeople))
                .toList() ??
            [],
      ),
      type: map['type'] ?? '',
      termsAndConditions: map['termsAndConditions'] ?? '',
      category: map['category'] ?? '',
      rate: map['rate'] ?? '',
      venue: map['venue'] ?? '',
      dressCode: map['dressCode'] ?? '',
      time: map['time'] ?? '',
      authorId: map['authorId'] ?? '',
      timestamp: map['timestamp'],
      previousEvent: map['previousEvent'] ?? '',
      triller: map['triller'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      virtualVenue: map['virtualVenue'],
      ticketSite: map['ticketSite'] ?? '',
      report: map['report'] ?? '',
      reportConfirmed: map['reportConfirmed'],
      isVirtual: map['isVirtual'] ?? false,
      isPrivate: map['isPrivate'] ?? false,
      isFree: map['isFree'] ?? false,
      isCashPayment: map['isCashPayment'] ?? false,
      showToFollowers: map['showToFollowers'] ?? false,
      showOnExplorePage: map['showOnExplorePage'] ?? true,
      fundsDistributed: map['fundsDistributed'] ?? false,
      isAffiliateEnabled: map['isAffiliateEnabled'] ?? false,
      isAffiliateExclusive: map['isAffiliateExclusive'] ?? false,
      clossingDay: map['clossingDay'] ?? Timestamp.fromDate(DateTime.now()),
      blurHash: map['blurHash'] ?? '',
      authorName: map['authorName'] ?? '',
      transferRecepientId: map['transferRecepientId'] ?? '',
      totalAffiliateAmount: (map['totalAffiliateAmount'] as num).toDouble(),
      latLng: map['latLng'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'theme': theme,
      'subaccountId': subaccountId,
      'startDate': startDate,
      'address': address,
      'imageUrl': imageUrl,
      'dynamicLink': dynamicLink,
      'improvemenSuggestion': improvemenSuggestion,
      'contacts': contacts,
      'schedule': schedule.map((schedule) => schedule.toJson()).toList(),
      'ticket': ticket.map((ticket) => ticket.toJson()).toList(),
      'taggedPeople':
          taggedPeople.map((taggedPeople) => taggedPeople.toJson()).toList(),
      'termsAndConditions': termsAndConditions,
      'authorName': authorName,
      'type': type,
      'category': category,
      'rate': rate,
      'venue': venue,
      'dressCode': dressCode,
      'time': time,
      'report': report,
      'reportConfirmed': reportConfirmed,
      'authorId': authorId,
      'timestamp': timestamp,
      'previousEvent': previousEvent,
      'triller': triller,
      'city': city,
      'country': country,
      'virtualVenue': virtualVenue,
      'ticketSite': ticketSite,
      'isVirtual': isVirtual,
      'isPrivate': isPrivate,
      'blurHash': blurHash,
      'isFree': isFree,
      'isCashPayment': isCashPayment,
      'showToFollowers': showToFollowers,
      'showOnExplorePage': true,
      'fundsDistributed': false,
      'isAffiliateExclusive': isAffiliateExclusive,
      'isAffiliateEnabled': isAffiliateEnabled,
      'clossingDay': clossingDay,
      'transferRecepientId': transferRecepientId,
      'totalAffiliateAmount': totalAffiliateAmount,
      'latLng': latLng,
    };
  }
}
