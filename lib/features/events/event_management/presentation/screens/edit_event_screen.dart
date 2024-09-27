import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

class EditEventScreen extends StatefulWidget {
  final Post post;
  final String? currentUserId;
  // final bool isCompleted;
  // final bool isDraft;

  static final id = 'Edit_event';

  EditEventScreen({
    required this.post,
    required this.currentUserId,
    // required this.isCompleted,
    // required this.isDraft,
  });

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      var _provider = Provider.of<UserData>(context, listen: false);
      // await EventDatabase.setNull(_provider, false, context);
      // widget.event.isFree ? _provider.setInt1(2) :
      _provider.setInt1(1);
      _provider.setInt2(0);
      // _provider.setTitle(widget.event.title);
      // _provider.setTitleDraft(widget.event.title);
      // _provider.setAiMarketingDraft(widget.event.aiMarketingAdvice);

      // _provider.setEventId(widget.event.id);
      // _provider.setSalon(widget.event.blurHash);

      // _provider.setCaption(widget.post.caption);
      // _provider.setHashTagg(widget.post.hashTag);

      // _provider.setThemeDraft(widget.event.theme);

      _provider.setImageUrl(widget.post.imageUrl);
      // _provider.setImageUrlDraft(widget.event.imageUrl);

      // _provider.setVenue(widget.event.venue);
      // _provider.setVenueDraft(widget.event.venue);

      // _provider.setAddress(widget.event.address);
      // _provider.setAddressDraft(widget.event.address);

      // _provider.setType(widget.event.type);
      // _provider.setTypeDraft(widget.event.type);

      // _provider.setCategory(widget.event.category);
      // _provider.setCategoryDraft(widget.event.category);

      // _provider.setStartDate(widget.event.startDate);
      // _provider.setStartDateDraft(widget.event.startDate);

      // _provider.setClossingDay(widget.event.clossingDay);
      // _provider.setClosingDayDraft(widget.event.clossingDay);

      // _provider.setCountry(widget.event.country);
      // _provider.setCountryDraft(widget.event.country);

      // _provider.setCity(widget.event.city);
      // _provider.setCityDraft(widget.event.city);

      // _provider.setDressCode(widget.event.dressCode);
      // _provider.setDressingCodeDraft(widget.event.dressCode);

      // _provider.setTicketSite(widget.event.ticketSite);
      // _provider.setTicketSiteDraft(widget.event.ticketSite);

      // _provider.setBlurHash(widget.event.blurHash);

      // _provider.setPreviousEvent(widget.event.previousEvent);
      // _provider.setPreviousEventDraftDraft(widget.event.previousEvent);

      // _provider.setCurrency(widget.event.rate);
      // _provider.setCurrencyDraft(widget.event.rate);

      // _provider.setIsFree(widget.event.isFree);
      // _provider.setIsFreeDraft(widget.event.isFree);

      // _provider.setshowToFollowers(widget.event.showToFollowers);
      // _provider.setShowToFollowersDraft(widget.event.showToFollowers);

      // _provider.setIsPrivate(widget.event.isPrivate);
      // _provider.setIsPrivateDraft(widget.event.isPrivate);

      // _provider.setIsAffiliateEnabled(widget.event.isAffiliateEnabled);
      // _provider.setIsAffiliateEnabledDraft(widget.event.isAffiliateEnabled);

      // _provider.setisAffiliateExclusive(widget.event.isAffiliateExclusive);
      // _provider.setIsAffiliateExclusiveDraft(widget.event.isAffiliateExclusive);

      // _provider.setIsPrivate(widget.event.isPrivate);
      // _provider.setIsPrivateDraft(widget.event.isPrivate);

      // _provider.setIsCashPayment(widget.event.isCashPayment);
      // _provider.setIsCashPaymentDraft(widget.event.isCashPayment);

      // _provider.setEventTermsAndConditions(widget.event.termsAndConditions);
      // _provider
      //     .setEventTermsAndConditionsDraft(widget.event.termsAndConditions);

      // _provider.setStartDateString(widget.event.startDate.toDate().toString());

      // _provider.setEventVirtualVenueDraft('');

      // _provider
      //     .setClossingDayString(widget.event.clossingDay.toDate().toString());
      // _provider.setStartDate(widget.event.startDate);
      // _provider.setStartDateDraft(widget.event.startDate);
      // _provider.setClossingDay(widget.event.clossingDay);
      // _provider.setEventImage(null);
      // _provider.setVideoFile1(null);
      // _addLists();
    });
  }

//   _addLists() {
//     //add event schedules
//     var _provider = Provider.of<UserData>(context, listen: false);

//     List<Schedule> shedules = widget.event.schedule;
//     _provider.setScheduleDraft(shedules);
//     for (Schedule shedules in shedules) {
//       Schedule sheduleOption = shedules;
//       _provider.setSchedule(sheduleOption);
//     }

//     //add event tickets
//     List<TicketModel> tickets = widget.event.ticket;
//     _provider.setTicketListDraft(tickets);
//     for (TicketModel tickets in tickets) {
//       TicketModel ticketOption = tickets;
//       _provider.setTicket(ticketOption);
//     }

//     //add tagged people
//     List<TaggedEventPeopleModel> taggedPeople = widget.event.taggedPeople;
//     _provider.setTaggedEventPeopleDraft(taggedPeople);
//     for (TaggedEventPeopleModel taggedPerson in taggedPeople) {
//       TaggedEventPeopleModel taggedPersonOption = taggedPerson;
//       _provider.setTaggedEventPeopel(taggedPersonOption);
//     }

// //contacts
//     List<String> eventContact = widget.event.contacts;
//     _provider.setEventOrganizerContactsDraft(eventContact);
//     for (String contact in eventContact) {
//       String contactOption = contact;
//       _provider.setEventOrganizerContacts(contactOption);
//     }
//   }

  // _setNull(UserData provider) {
  //   // var provider = Provider.of<UserData>(context, listen: false);
  //   provider.setInt1(0);
  //   provider.setSalon('');
  //   provider.setTitle('');
  //   provider.setTheme('');
  //   provider.setImageUrl('');
  //   provider.setVenue('');
  //   provider.setAddress('');
  //   provider.setAddress('');
  //   provider.setType('');
  //   provider.setCategory('');
  //   provider.setStartDateString('');
  //   provider.setClossingDayString('');
  //   provider.setCountry('');
  //   provider.setCity('');
  //   provider.setDressCode('');
  //   provider.setTicketSite('');
  //   provider.setPreviousEvent('');
  //   provider.setCurrency('');
  //   provider.setEventTermsAndConditions('');
  //   provider.ticket.clear();
  //   provider.schedule.clear();
  //   provider.taggedEventPeople.clear();
  //   provider.setEventImage(null);
  //   provider.setVideoFile1(null);
  //   provider.setIsCashPayment(false);
  //   provider.setIsVirtual(false);
  //   provider.setIsPrivate(false);
  //   provider.setIsFree(false);
  //   provider.setIsAffiliateEnabled(false);
  //   provider.setisAffiliateExclusive(false);
  //   provider.eventOrganizerContacts.clear();
  //   provider.setCouldntDecodeCity(false);
  //   provider.setLatLng('');
  // }

  @override
  Widget build(BuildContext context) {
    return CreateEventScreen(
      post: widget.post,
      isEditting: true,
      // isCompleted: widget.isCompleted,
      // isDraft: widget.isDraft,
    );
  }
}
