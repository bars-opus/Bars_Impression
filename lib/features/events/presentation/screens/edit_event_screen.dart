import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;
  final String? currentUserId;
  final bool isCompleted;

  static final id = 'Edit_event';

  EditEventScreen(
      {required this.event,
      required this.currentUserId,
      required this.isCompleted});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      var _provider = Provider.of<UserData>(context, listen: false);
      await _setNull(_provider);
      _provider.setInt1(0);
      _provider.setTitle(widget.event.title);
      _provider.setTheme(widget.event.theme);
      _provider.setImageUrl(widget.event.imageUrl);
      _provider.setVenue(widget.event.venue);
      _provider.setVenue(widget.event.city);
      _provider.setVenue(widget.event.country);
      _provider.setAddress(widget.event.address);
      _provider.setAddress(widget.event.address);
      _provider.setType(widget.event.type);
      _provider.setCategory(widget.event.category);
      _provider.setStartDate(widget.event.startDate);
      _provider.setClossingDay(widget.event.clossingDay);
      _provider.setCountry(widget.event.country);
      _provider.setDressCode(widget.event.dressCode);
      _provider.setTicketSite(widget.event.ticketSite);
      _provider.setPreviousEvent(widget.event.previousEvent);
      _provider.setCurrency(widget.event.rate);
      _provider.setIsFree(widget.event.isFree);
      _provider.setIsPrivate(widget.event.isPrivate);
      _provider.setEventTermsAndConditions(widget.event.termsAndConditions);
      _provider.setStartDateString(widget.event.startDate.toDate().toString());
      _provider
          .setClossingDayString(widget.event.clossingDay.toDate().toString());
      _provider.setStartDate(widget.event.startDate);
      _provider.setClossingDay(widget.event.clossingDay);
      _provider.setEventImage(null);
      _provider.setVideoFile1(null);
      _addLists();
    });
  }

  _addLists() {
    //add event schedules
    var _provider = Provider.of<UserData>(context, listen: false);
    List<Schedule> shedules = widget.event.schedule;
    for (Schedule shedules in shedules) {
      Schedule sheduleOption = shedules;
      _provider.setSchedule(sheduleOption);
    }
    //add event tickets
    List<TicketModel> tickets = widget.event.ticket;
    for (TicketModel tickets in tickets) {
      TicketModel ticketOption = tickets;

      _provider.setTicket(ticketOption);
    }

    //add tagged people
    List<TaggedEventPeopleModel> taggedPeople = widget.event.taggedPeople;
    for (TaggedEventPeopleModel taggedPerson in taggedPeople) {
      TaggedEventPeopleModel taggedPersonOption = taggedPerson;

      _provider.setTaggedEventPeopel(taggedPersonOption);
    }
  }

  _setNull(UserData provider) {
    // var provider = Provider.of<UserData>(context, listen: false);
    provider.setInt1(0);
    provider.setArtist('');
    provider.setTitle('');
    provider.setTheme('');
    provider.setImageUrl('');
    provider.setVenue('');
    provider.setAddress('');
    provider.setVenue('');
    provider.setAddress('');
    provider.setType('');
    provider.setCategory('');
    provider.setStartDateString('');
    provider.setClossingDayString('');
    provider.setCountry('');
    provider.setCity('');
    provider.setDressCode('');
    provider.setTicketSite('');
    provider.setPreviousEvent('');
    provider.setCurrency('');
    provider.setEventTermsAndConditions('');
    provider.ticket.clear();
    provider.schedule.clear();
    provider.taggedEventPeople.clear();
    provider.setEventImage(null);
    provider.setVideoFile1(null);
    provider.setIsCashPayment(false);
    provider.setIsVirtual(false);
    provider.setIsPrivate(false);
    provider.setIsFree(false);

    provider.setCouldntDecodeCity(false);
  }

  @override
  Widget build(BuildContext context) {
    return CreateEventScreen(
      event: widget.event,
      isEditting: true,
      isCompleted: widget.isCompleted,
    );
  }
}
