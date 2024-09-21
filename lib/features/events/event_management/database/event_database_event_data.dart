import 'package:bars/utilities/exports.dart';
import 'package:blurhash/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EventDatabaseEventData {
  // final Event? event;
  final PageController pageController;
  // final bool isDraft;

  // final BuildContext context;
  EventDatabaseEventData({
    required this.pageController,
  });
  // bool _isLoading = false;

//Add event organisers contacnts
  static void addContacts({
    required BuildContext context,
    required TextEditingController contactController,
    required GlobalKey<FormState> contactsFormKey,
  }) {
    var _provider = Provider.of<UserData>(context, listen: false);
    if (contactsFormKey.currentState!.validate()) {
      _provider.setEventOrganizerContacts(contactController.text.trim());
      contactController.clear();
    }
  }

//add event tickets
  static void addTicket({
    required BuildContext context,
    required TextEditingController ticketTypeController,
    required TextEditingController priceController,
    required TextEditingController groupController,
    required TextEditingController accessLevelController,
    required TextEditingController maxSeatPerRowController,
    required TextEditingController maxOrderController,
  }) {
    var _provider = Provider.of<UserData>(context, listen: false);
    final type = ticketTypeController.text;
    final price = double.tryParse(priceController.text) ?? 0.0;
    final group = groupController.text.trim();
    final accessLevel = accessLevelController.text;
    final maxSeatPerRow = int.tryParse(maxSeatPerRowController.text) ?? 0;
    final maxOrder = int.tryParse(maxOrderController.text) ?? 0;

    final ticket = TicketModel(
      id: UniqueKey().toString(),
      type: type,
      price: _provider.isFree ? 0 : price,
      maxOder: maxOrder,
      salesCount: 0,
      group: group,
      accessLevel: accessLevel,
      maxSeatsPerRow: maxSeatPerRow,
      eventTicketDate: _provider.sheduleDateTemp,
    );

    // adds ticket to ticket list
    _provider.setTicket(ticket);
    _provider.setInt2(2);
    // Reset ticket variables
    ticketTypeController.clear();
    priceController.clear();
    maxOrderController.clear();
    maxSeatPerRowController.clear();
    accessLevelController.clear();
    groupController.clear();
  }

//add event schedule
  static void addSchedule({
    required BuildContext context,
    required DateTime scheduleStartTime,
    required DateTime scheduleEndTime,
    required Future<QuerySnapshot>? users,
  }) {
    var _provider = Provider.of<UserData>(context, listen: false);
    FocusScope.of(context).unfocus();
    final schedule = Schedule(
      id: UniqueKey().toString(),
      startTime: Timestamp.fromDate(scheduleStartTime),
      endTime: Timestamp.fromDate(scheduleEndTime),
      title: _provider.punchline,
      // _scheduleTitleController.text,
      people: List.from(_provider.schedulePerson),
      scheduleDate: _provider.sheduleDateTemp,
    );
    users = null;
    _provider.setInt2(1);
    _provider.setSchedule(schedule);
    _provider.setIsEndTimeSelected(false);
    _provider.setIsStartTimeSelected(false);
    _provider.schedulePerson.clear();
    _provider.setPunchline('');
    Navigator.pop(context);
  }

  // method to add tagged event person to the list of tagged event people (performers, crew, sponsors, partners)
  static addTaggedPeople({
    required BuildContext context,
    // required String selectedNameToAdd,
    required String selectedRole,
    required String newtaggedType,
    // required String taggedUserExternalLink,
    // required String selectedNameToAddProfileImageUrl,
    required String selectedSponsorOrPartnerValue,
    required Future<QuerySnapshot>? users,
    required TextEditingController tagNameController,
  }) {
    var _provider = Provider.of<UserData>(context, listen: false);
    final name = _provider.taggedUserSelectedProfileName;
    final role = selectedRole;
    final taggedType = newtaggedType;
    final internalProfileLink = _provider.taggedUserSelectedProfileLink;
    final externalProfileLink = _provider.taggedUserSelectedExternalLink;
    String commonId = Uuid().v4();
    final taggedEvenPeople = TaggedEventPeopleModel(
      id: commonId,
      name: name,
      role: role,
      verifiedTag: false,
      externalProfileLink: externalProfileLink,
      internalProfileLink: internalProfileLink,
      taggedType: taggedType,
      profileImageUrl: _provider.taggedUserSelectedProfileImageUrl,
    );
    _provider.setTaggedEventPeopel(taggedEvenPeople);
    // _provider.setArtist('');
    _provider.setInt2(3);
    // selectedNameToAddProfileImageUrl = '';
    // taggedUserExternalLink = '';
    _provider.setTaggedUserSelectedExternalLink('');
    _provider.setTaggedUserSelectedProfileImageUrl('');
    _provider.setTaggedUserSelectedProfileName('');
    _provider.setTaggedUserSelectedProfileLink('');
    newtaggedType = '';
    selectedSponsorOrPartnerValue = '';
    users = null;
    tagNameController.clear();
  }

//add event schedule people  before addin to schedule
  static void addSchedulePeople({
    required BuildContext context,
    required String name,
    required String internalProfileLink,
    required String taggedUserExternalLink,
    required String profileImageUrl,
  }) {
    var _provider = Provider.of<UserData>(context, listen: false);
    String commonId = Uuid().v4();
    final taggedEvenPeople = SchedulePeopleModel(
      profileImageUrl: profileImageUrl,
      id: commonId,
      name: name,
      verifiedTag: false,
      externalProfileLink: taggedUserExternalLink,
      internalProfileLink: internalProfileLink,
    );
    //Add tagged person to taggedPeopleList
    _provider.setSchedulePeople(taggedEvenPeople);
    //Reset tagged people variable
    _provider.setArtist('');
  }
}
