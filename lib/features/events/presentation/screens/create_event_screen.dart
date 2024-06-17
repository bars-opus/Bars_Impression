import 'package:bars/general/pages/profile/create/date_picker.dart';
import 'package:bars/general/pages/profile/setup_brand.dart';
import 'package:bars/widgets/create/schedule_people_group.dart';

import 'package:blurhash/blurhash.dart';
import 'package:bars/utilities/exports.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:uuid/uuid.dart';

class CreateEventScreen extends StatefulWidget {
  final bool isEditting;
  final Event? event;
  final bool isCompleted;
  static final id = 'Create_event';

  CreateEventScreen({
    required this.isEditting,
    required this.event,
    required this.isCompleted,
  });

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Future<QuerySnapshot>? _users;
  int index = 0;
  int showDatePicker = 0;
  int showTimePicker = 0;
  int eventTypeIndex = 0;
  int showEventTypePicker = 0;
  late PageController _pageController;
  DateTime _scheduleStartTime = DateTime.now();
  DateTime _scheduleEndTime = DateTime.now();
  DateTime minTime = DateTime.now().subtract(Duration(minutes: 1));
  DateTime dayTime = DateTime.now();
  String selectedValue = '';
  String selectedSponsorOrPartnerValue = '';
  String _selectedRole = '';
  String _taggedType = '';
  String _selectedNameToAdd = '';
  String _taggedUserExternalLink = '';
  String selectedclosingDay = '';
  String _type = '';
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  bool _isLoading = false;
  final _contactsFormKey = GlobalKey<FormState>();

  final _addPersonFormKey = GlobalKey<FormState>();

  final _addPreviousVideoFormkey = GlobalKey<FormState>();
  final _ticketSiteFormkey = GlobalKey<FormState>();

// Text editing controllers
  final _addressSearchController = TextEditingController();
  final _ticketTypeController = TextEditingController();
  final _tagNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _scheduleTitleController = TextEditingController();
  final _schedulePerfomerController = TextEditingController();

  final _contactController = TextEditingController();

  final _groupController = TextEditingController();
  final _accessLevelController = TextEditingController();
  final _maxOrderController = TextEditingController();
  final _rowController = TextEditingController();
  final _maxSeatPerRowController = TextEditingController();
  final _cancellationRasonController = TextEditingController();

  final _debouncer = Debouncer(milliseconds: 500);

// Focus nodes
  final FocusNode _addressSearchfocusNode = FocusNode();
  final FocusNode _nameSearchfocusNode = FocusNode();
  final musicVideoLink =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

  @override
  void initState() {
    super.initState();
    selectedValue = _type.isEmpty ? values.last : _type;
    _pageController = PageController(
      initialPage: widget.isEditting ? 1 : 0,
    );
    _priceController.addListener(_onAskTextChanged);
    _cancellationRasonController.addListener(_onAskTextChanged);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      var _provider = Provider.of<UserData>(context, listen: false);
      _provider.setIsStartDateSelected(false);
      _provider.setIsEndDateSelected(false);
      _provider.setIsStartTimeSelected(false);
      _provider.setIsEndTimeSelected(false);
      _provider.setInt1(
        _pageController.initialPage,
      );
    });
  }

  List<String> sponsorOrPartner = [
    'Sponser',
    'Partner',
  ];

  List<String> crew = [
    'Audio Manager',
    'Caterers',
    'Decorations Coordinator',
    'Entertainment Coordinator',
    'Event Coordinator',
    'Food and Beverage Coordinator',
    'Lightening',
    'Marketing Manager',
    'Production Manager',
    'Photographer',
    'Publicity Coordinator',
    'Security Manager',
    'Sounds',
    'Ticketing Manager',
    'Transportation Manager',
    'Venue',
    'Videographer',
    'Visual Technician',
    'Volunteer Coordinator',
    'Others',
  ];

  List<String> performers = [
    'Special guess',
    'Artist',
    'Actor/actresse',
    'Band',
    'Choire',
    'Comedian',
    'Dancer',
    'DJ',
    'Instrumentalist',
    'MCs/host',
    'Speaker',
    'Others',
  ];

  @override
  void dispose() {
    _priceController.dispose();
    _addressSearchController.dispose();
    _tagNameController.dispose();
    _ticketTypeController.dispose();
    _scheduleTitleController.dispose();
    _contactController.dispose();
    _schedulePerfomerController.dispose();
    _groupController.dispose();
    _accessLevelController.dispose();
    _maxOrderController.dispose();
    _rowController.dispose();
    _maxSeatPerRowController.dispose();
    _cancellationRasonController.dispose();
    _pageController.dispose();
    _addressSearchfocusNode.dispose();
    _nameSearchfocusNode.dispose();
    _isTypingNotifier.dispose();
    _debouncer.cancel();

    // _pageController2.dispose();

    super.dispose();
  }

  void _onAskTextChanged() {
    if (_priceController.text.isNotEmpty ||
        _cancellationRasonController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

//Method to create ticket
  void _addTicket() {
    var _provider = Provider.of<UserData>(context, listen: false);
    final type = _ticketTypeController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final group = _groupController.text.trim();
    final accessLevel = _accessLevelController.text;
    // final row = int.tryParse(_rowController.text) ?? 0;
    final maxSeatPerRow = int.tryParse(_maxSeatPerRowController.text) ?? 0;
    final maxOrder = int.tryParse(_maxOrderController.text) ?? 0;

    final ticket = TicketModel(
      id: UniqueKey().toString(),
      type: type,
      price: _provider.isFree ? 0 : price,
      maxOder: maxOrder,
      salesCount: 0,
      group: group,
      accessLevel: accessLevel,
      // isRefundable: false,
      // row: row,
      // seat: 0,
      maxSeatsPerRow: maxSeatPerRow,
      eventTicketDate: _provider.sheduleDateTemp,
    );

    // adds ticket to ticket list
    _provider.setTicket(ticket);

    // Reset ticket variables
    _ticketTypeController.clear();
    _priceController.clear();
    _maxOrderController.clear();
    _maxSeatPerRowController.clear();
    _rowController.clear();
    _accessLevelController.clear();
    _groupController.clear();
  }

  //Methos to create schedule
  void _addSchedule() {
    var _provider = Provider.of<UserData>(context, listen: false);
    FocusScope.of(context).unfocus();
    final schedule = Schedule(
      id: UniqueKey().toString(),
      startTime: Timestamp.fromDate(_scheduleStartTime),
      endTime: Timestamp.fromDate(_scheduleEndTime),
      title: _scheduleTitleController.text,
      people: List.from(_provider.schedulePerson),

      // performer: _schedulePerfomerController.text,
      scheduleDate: _provider.sheduleDateTemp,
    );

    // add schedule to schedule lise
    _provider.setSchedule(schedule);

    // reset schedule variable
    _provider.setIsEndTimeSelected(false);
    _provider.setIsStartTimeSelected(false);
    // _provider.setIsStartDateSelected(false);
    // _provider.setIsEndDateSelected(false);
    _provider.schedulePerson.clear();
    _scheduleTitleController.clear();
    _schedulePerfomerController.clear();
    // mySnackBar(context, 'Program added to schedule');

    // mySnackBar(context, "Program added to Schedule")''
  }

  // method to add tagged event person to the list of tagged event people (performers, crew, sponsors, partners)
  void _addTaggedPeople() {
    var _provider = Provider.of<UserData>(context, listen: false);
    final name = _selectedNameToAdd;
    final role = _selectedRole;
    final taggedType = _taggedType;
    final internalProfileLink =
        Provider.of<UserData>(context, listen: false).artist;
    final externalProfileLink = _taggedUserExternalLink;

    String commonId = Uuid().v4();
    final taggedEvenPeople = TaggedEventPeopleModel(
      id: commonId,
      name: name,
      role: role,
      verifiedTag: false,
      externalProfileLink: externalProfileLink,
      internalProfileLink: internalProfileLink,
      taggedType: taggedType,
    );

    //Add tagged person to taggedPeopleList
    _provider.setTaggedEventPeopel(taggedEvenPeople);

    //Reset tagged people variable
    _provider.setArtist('');
    _selectedNameToAdd = '';
    _selectedRole = '';
    _taggedUserExternalLink = '';
    _taggedType = '';
    selectedSponsorOrPartnerValue = '';
    _users = null;
    _tagNameController.clear();
  }

  void _addSchedulePeople(
      String name, String internalProfileLink, String taggedUserExternalLink) {
    var _provider = Provider.of<UserData>(context, listen: false);
    // final name = _selectedNameToAdd;
    // final role = _selectedRole;
    // final taggedType = _taggedType;
    // final internalProfileLink =
    //     Provider.of<UserData>(context, listen: false).artist;
    // final externalProfileLink = _taggedUserExternalLink;

    String commonId = Uuid().v4();
    final taggedEvenPeople = SchedulePeopleModel(
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
    _selectedNameToAdd = '';
    _selectedRole = '';
    _taggedUserExternalLink = '';
    _taggedType = '';
    selectedSponsorOrPartnerValue = '';
    _users = null;
    _tagNameController.clear();
  }

  void _addContacts() {
    var _provider = Provider.of<UserData>(context, listen: false);

    // final externalProfileLink = _taggedUserExternalLink;

    // String commonId = Uuid().v4();
    // final taggedEvenPeople = SchedulePeopleModel(
    //   id: commonId,
    //   name: name,
    //   verifiedTag: false,
    //   externalProfileLink: externalProfileLink,
    //   internalProfileLink: internalProfileLink,
    // );

    //Add tagged person to taggedPeopleList
    if (_contactsFormKey.currentState!.validate()) {
      _provider.setEventOrganizerContacts(_contactController.text.trim());

      //Reset tagged people variable

      _contactController.clear();
    }
  }

  // Helper methods
  void _handleError(dynamic error, bool isSuccessful) {
    String result = error.toString().contains(']')
        ? error.toString().substring(error.toString().lastIndexOf(']') + 1)
        : error.toString();
    mySnackBar(context, result);
  }

  void _showBottomSheetErrorMessage(String e) {
    // String error = e.toString();
    // String result = error.contains(']')
    //     ? error.substring(error.lastIndexOf(']') + 1)
    //     : error;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: e,
          // 'Failed to create event',
          subTitle: 'Check your internet connection and try again.',
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // Method to create event
  _submitCreate() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    if (!_isLoading) {
      FocusScope.of(context).unfocus();
      animateToPage(1);
      _isLoading = true;
      String commonId = Uuid().v4();
      try {
        String imageUrl =
            await StorageService.uploadEvent(_provider.eventImage!);

        Event event = await _createEvent(
          imageUrl,
          commonId,
        );

        PaletteGenerator _paletteGenerator =
            await PaletteGenerator.fromImageProvider(
          CachedNetworkImageProvider(event.imageUrl),
          size: Size(1110, 150),
          maximumColorCount: 20,
        );

        DocumentSnapshot doc = await eventsRef
            .doc(_provider.currentUserId)
            .collection('userEvents')
            .doc(commonId)
            .get();

        Event newEvent = Event.fromDoc(doc);

        _setNull(_provider);

        // await Future.delayed(Duration(milliseconds: 100));
        _isLoading = false;
        if (mounted) {
          _navigateToPage(
              context,
              EventEnlargedScreen(
                justCreated: true,
                currentUserId: _provider.currentUserId!,
                event: newEvent,
                type: newEvent.type,
                palette: _paletteGenerator,
              ));

          mySnackBar(context, 'Your event was published successfully.');
        }
      } catch (e) {
        // _handleError(e, false);
        animateToBack(1);
        _isLoading = false;
        _showBottomSheetErrorMessage(
          'Failed to create event',
        );
      }
    }
  }

  Future<Event> _createEvent(
    String imageUrl,
    String commonId,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    Uint8List bytes = await (_provider.eventImage!).readAsBytes();
    var blurHash = await BlurHash.encode(bytes, 4, 3);

    // Calculate the total cost of the order

    String link = await DatabaseService.myDynamicLink(
        imageUrl,
        _provider.title,
        _provider.theme,
        'https://www.barsopus.com/event_${commonId}_${_provider.currentUserId}');

    // 'https://www.barsopus.com/event_${commonId}_${_provider.currentUserId}}');

//     if (!_provider.endDateSelected) {
// // Convert the Timestamp to a DateTime object
//       DateTime dateTime = _provider.startDate.toDate();
// // Add a one-day duration to the DateTime object
//       DateTime newDateTime = dateTime.add(Duration(days: 1));
// // Convert the DateTime back to a Timestamp object
//       Timestamp instantClosingDate = Timestamp.fromDate(newDateTime);
//       _provider.setClossingDay(instantClosingDate);
//     }

    Event event = Event(
      blurHash: blurHash,
      imageUrl: imageUrl,
      // offers: [],
      type: _provider.category.isEmpty ? 'Others' : _provider.category,
      title: _provider.title,
      rate: _provider.currency,
      ticket: _provider.ticket,
      schedule: _provider.schedule,
      taggedPeople: _provider.taggedEventPeople,
      // ticketOrder: [],
      venue: _provider.venue,
      // isTicketed: true,
      startDate: _provider.startDate,
      time: '',
      theme: _provider.theme,
      dressCode: _provider.dressCode,
      address: _provider.address,
      authorId: _provider.currentUserId!,
      timestamp: Timestamp.fromDate(DateTime.now()),
      previousEvent: _provider.previousEvent,
      triller: '',
      report: '',
      reportConfirmed: '',
      city: _provider.city,
      country: _provider.country,
      virtualVenue: _provider.isVirtual ? _provider.venue : '',
      ticketSite: _provider.ticketSite,
      isVirtual: _provider.isVirtual,
      isPrivate: _provider.isPrivate,
      id: commonId,
      isFree: _provider.isFree,
      isCashPayment: _provider.isCashPayment,
      showOnExplorePage: true,
      fundsDistributed: false,
      showToFollowers: _provider.showToFollowers,
      clossingDay: _provider.startDate,
      authorName: _provider.user!.userName!,
      category: _provider.category,
      termsAndConditions: _provider.eventTermsAndConditions,
      dynamicLink: link,
      subaccountId: _provider.userLocationPreference!.subaccountId!,
      transferRecepientId:
          _provider.userLocationPreference!.transferRecepientId!,
      contacts: _provider.eventOrganizerContacts, improvemenSuggestion: '',
    );

    await DatabaseService.createEvent(event);

    return event;
  }

  _editEvent() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    animateToPage(1);

    Event event = Event(
      blurHash: widget.event!.blurHash,
      imageUrl: widget.event!.imageUrl,
      // offers: [],
      type: _provider.category.isEmpty ? 'Others' : _provider.category,
      title: _provider.title,
      rate: _provider.currency,
      ticket: _provider.ticket,
      schedule: _provider.schedule,
      taggedPeople: _provider.taggedEventPeople,
      // ticketOrder: [],
      venue: _provider.venue,
      // isTicketed: true,
      startDate: _provider.startDate,
      time: '',
      theme: _provider.theme,
      dressCode: _provider.dressCode,
      address: _provider.address,
      authorId: _provider.currentUserId!,
      timestamp: Timestamp.fromDate(DateTime.now()),
      previousEvent: _provider.previousEvent,
      triller: '',
      report: '',
      reportConfirmed: '',
      city: _provider.city,
      country: _provider.country,
      virtualVenue: _provider.isVirtual ? _provider.venue : '',
      ticketSite: '',
      isVirtual: _provider.isVirtual,
      isPrivate: _provider.isPrivate,
      id: widget.event!.id,
      isFree: _provider.isFree,
      isCashPayment: _provider.isCashPayment,
      showOnExplorePage: true,
      fundsDistributed: false,
      showToFollowers: _provider.bool6,
      clossingDay: _provider.clossingDay,
      authorName: _provider.user!.userName!,
      category: _provider.category,
      termsAndConditions: _provider.eventTermsAndConditions,
      dynamicLink: widget.event!.dynamicLink,
      subaccountId: _provider.userLocationPreference!.subaccountId!,
      transferRecepientId:
          _provider.userLocationPreference!.transferRecepientId!,
      contacts: _provider.eventOrganizerContacts, improvemenSuggestion: '',
    );

    try {
      await DatabaseService.editEvent(event);
      _setNull(_provider);
      mySnackBar(context, 'Saved succesfully');
      return event;
    } catch (e) {
      // _handleError(e, false);
      animateToBack(1);
      _isLoading = false;
      _showBottomSheetErrorMessage(
        'Failed to edit event',
      );
    }
  }

  void _showBottomSheetLoading() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomModalLoading(
          title: 'Deleting event',
        );
      },
    );
  }

  void _showBottomSheetConfirmDeleteEvent() {
    var _provider = Provider.of<UserData>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 350,
          buttonText: 'Delete event',
          onPressed: widget.event == null
              ? () {
                  mySnackBar(context, 'event not found');
                }
              : () async {
                  // Navigator.pop(context);
                  try {
                    _showBottomSheetLoading();

                    await DatabaseService.deleteEvent(
                        widget.event!,
                        _cancellationRasonController.text.trim(),
                        widget.isCompleted);
                    await _setNull(_provider);

                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);

                    mySnackBar(context, 'Event deleted succesfully');
                  } catch (e) {
                    Navigator.pop(context);
                    _showBottomSheetErrorMessage(
                        'Error deleting notifications ');
                  }
                },
          title: 'Are you sure you want to Delete this event?',
          subTitle: widget.event!.isFree || widget.isCompleted
              ? "All data associated with this event, including the event room, will be deleted."
              : "If the event is deleted, all data related to the event, including the event room, will be deleted. Additionally, purchased tickets will be fully refunded",
        );
      },
    );
  }

  Widget _showBottomDeleteForm() {
    var _provider = Provider.of<UserData>(context, listen: false);
    return ValueListenableBuilder(
      valueListenable: _isTypingNotifier,
      builder: (BuildContext context, bool isTyping, Widget? child) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text(
            'Add reason',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          content: Container(
            width: ResponsiveHelper.responsiveHeight(context, 600),
            // height: ResponsiveHelper.responsiveHeight(context, 600),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(children: [
                  _cancellationRasonController.text.isNotEmpty
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: MiniCircularProgressButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showBottomSheetConfirmDeleteEvent();
                            },
                            text: "Continue",
                            color: Colors.blue,
                          ),
                        )
                      : const SizedBox(height: 50),
                  _ticketFiled(
                    true,
                    true,
                    'Reason',
                    'Please provide the reason for your event cancellation',
                    _cancellationRasonController,
                    TextInputType.multiline,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please reason for your event cancellation';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  // void _showBottomRefundForm() {
  //   var _size = MediaQuery.of(context).size;
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  // return StatefulBuilder(
  //     builder: (BuildContext context, StateSetter setState) {
  //           return ValueListenableBuilder(
  //               valueListenable: _isTypingNotifier,
  //               builder: (BuildContext context, bool isTyping, Widget? child) {
  //                 return
  //               });
  //         });
  //       });åß
  //

// To reset all event variables in ordert to be able to create a new event
  _setNull(UserData provider) {
    // var provider = Provider.of<UserData>(context, listen: false);
    provider.setInt1(0);
    provider.setArtist('');
    provider.setTitle('');
    provider.setTheme('');
    provider.setImageUrl('');
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
    provider.addressSearchResults = [];
    provider.setCouldntDecodeCity(false);
    provider.eventOrganizerContacts.clear();
    Navigator.pop(context);
  }

// Radio buttons to select the event vategory
  static const values = <String>[
    "Parties",
    "Music_concerts",
    "Festivals",
    "Club_nights",
    "Pub_events",
    "Games/Sports",
    "Religious",
    "Business",
    "Others",
  ];

  Widget buildRadios() => Column(
          children: values.map((value) {
        var _provider = Provider.of<UserData>(context, listen: false);

        final selected = this.selectedValue == value;
        final color = selected ? Colors.blue : Colors.white;

        return RadioTheme(
          data: RadioThemeData(
              fillColor: MaterialStateProperty.all(Colors.white)),
          child: RadioListTile<String>(
              value: value,
              groupValue: selectedValue,
              title: Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                ),
              ),
              activeColor: Colors.blue,
              onChanged: (value) {
                _provider.setCategory(this.selectedValue = value!);
                value.startsWith('Others') ? () {} : animateToPage(1);
              }),
        );
      }).toList());

//Radion button for tagged sponsors and partners
  static const SponserOrPartner = <String>[
    "Sponsor",
    "Partner",
  ];

  Widget buildSponserOrPartnerRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.white,
        ),
        child: Column(
            children: SponserOrPartner.map((value) {
          final selected = this.selectedSponsorOrPartnerValue == value;
          final color = selected ? Colors.blue : Colors.white;

          return RadioTheme(
            data: RadioThemeData(
                fillColor: MaterialStateProperty.all(Colors.white)),
            child: RadioListTile<String>(
                value: value,
                groupValue: selectedSponsorOrPartnerValue,
                title: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                  ),
                ),
                activeColor: Colors.blue,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _selectedRole =
                          this.selectedSponsorOrPartnerValue = value!;
                      _taggedType = _selectedRole;
                    });
                  }
                }),
          );
        }).toList()),
      );

  animateToPage(int index) {
    _pageController.animateToPage(
      _pageController.page!.toInt() + index,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateToBack(int index) {
    if (mounted) {
      _pageController.animateToPage(
        _pageController.page!.toInt() - index,
        // Provider.of<UserData>(context, listen: false).int1 - index,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  _validate() {
    animateToPage(1);
  }

//event process number
  _eventProcessNumber(
    String processNumber,
    String processTitle,
  ) {
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 80,
        width: ResponsiveHelper.responsiveFontSize(context, 230),
        child: ListTile(
          leading: Text(
            processNumber,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 30.0),
            ),
          ),
          title: Text(
            processTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventSettingSection() {
    UserData _provider = Provider.of<UserData>(context, listen: false);

    return _pageWidget(
      newWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _eventProcessNumber('1. ', 'Event\nsettings.'),
              MiniCircularProgressButton(
                  onPressed: () {
                    animateToPage(1);
                  },
                  text: "Next")
            ],
          ),
          const SizedBox(height: 20),
          Container(
            color: Theme.of(context).primaryColorLight,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildSettingOptions(_provider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker() {
    UserData _provider = Provider.of<UserData>(context, listen: false);

    showCurrencyPicker(
      theme: CurrencyPickerThemeData(
        backgroundColor: Theme.of(context).primaryColor,
        flagSize: 25,
        titleTextStyle: TextStyle(
          fontSize: ResponsiveHelper.responsiveFontSize(context, 17.0),
        ),
        subtitleTextStyle: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 15.0),
            color: Colors.blue),
        bottomSheetHeight: MediaQuery.of(context).size.height / 1.2,
      ),
      context: context,
      showFlag: true,
      showSearchField: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        print(currency.code.toString());
        _provider.setCurrency('${currency.name} | ${currency.code}');
        !_provider.isFree && currency.code != 'GHS' && !_provider.isCashPayment
            ? showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Theme.of(context).primaryColor,
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          // const SizedBox(
                          //   height: 30,
                          // ),
                          TicketPurchasingIcon(
                            title: '',
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MiniCircularProgressButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  animateToPage(1);
                                },
                                text: "Next"),
                          ),

                          const SizedBox(height: 20),
                          RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Event Organizers Outside of Ghana',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                TextSpan(
                                  text:
                                      "\n\nDue to the current limitations of payment processing in different currencies, we regret to inform event organizers outside of Ghana that we can only handle ticket purchases within Ghana at this time. We understand the importance of expanding our services to other countries and are actively working on implementing the necessary facilities to accommodate international transactions. \n\nIn the meantime, we recommend that event organizers outside of Ghana provide an alternative ticket handling solution, such as providing a link to their own website for ticket sales or accepting cash payments on-site. We apologize for any inconvenience caused and appreciate your understanding as we strive to enhance our services to better serve you in the future.",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : animateToPage(1);
      },
      favorite: _provider.userLocationPreference!.country == 'Ghana'
          ? ['GHS']
          : ['USD'],
    );
  }

  void _showBottomSheetSettingsLearnMore(
      String title, String subTitle, String body) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 700),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  TicketPurchasingIcon(
                    title: '',
                  ),

                  const SizedBox(height: 40),

                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text: "\n\n${subTitle}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Divider(
                      thickness: .5,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Overview",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "${body}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ));
      },
    );
  }

  _buildSettingOptions(UserData _provider) {
    List<Widget> options = [];
    options.add(const SizedBox(height: 30));

    if (!_provider.isCashPayment) {
      options.add(_buildSettingSwitchWithDivider(
          _provider.isFree ? 'Free' : 'Not free',
          _provider.isFree
              ? 'This is a free event with no ticket or gate fee.(Change back to paid)'
              : 'This is a paid event with a ticket or gate fee. (Change to free)',
          '',
          _provider.isFree,
          _provider.setIsFree));
    }
    if (!_provider.isFree) {
      options.add(_buildSettingSwitchWithDivider(
          _provider.isCashPayment ? 'Only cash payment' : 'Online Payment',
          _provider.isCashPayment
              ? 'Only cash is accepted as a payment method for tickets or gate fees'
              : 'Card and mobile money as a payment method for tickets or gate fees',
          'You can choose either online payment or cash payment, but not both at the same time\n\nOnline Payment:\nWhen you select the online payment option, the payment process is handled by the system.\nAfter the online payment is successful, the tickets are generated.\n\nCash Payment:\nWhen you select the cash payment option, the system generates free tickets for attendees. \nThe cash payment will be made at the event gate when the users show the generated ticket on the app.',
          _provider.isCashPayment,
          _provider.setIsCashPayment));
    }
    options.add(_buildSettingSwitchWithDivider(
        _provider.isPrivate ? 'Private event' : 'Not private event',
        _provider.isPrivate
            ? 'You are creating a private event, it means the event is exclusive and only accessible to a selected group of people, rather than being open to the general public. (Change back to public)'
            : 'You are creating a public (general) event where anybody can attend.(Change to private)',
        'When creating a private event, you have the option to send invitations only to specific individuals who are intended to attend. This means that the event is not open to the general public, and access is restricted to those who have received and accepted an invitation. \n\nExample: Weddings, Birthday celebrations, Graduation ceremonies, Exclusive fundraising events for high-net-worth individuals, Employee training sessions, Executive retreats, Product launch events for select customers or partners',
        _provider.isPrivate,
        _provider.setIsPrivate));

    if (_provider.isPrivate) {
      options.add(_buildSettingSwitchWithDivider(
          _provider.showToFollowers
              ? 'Show to followers'
              : 'Don\'t show to followers',
          _provider.showToFollowers
              ? 'Exclusive event where access is granted to both invited attendees and followers.'
              : 'Your followers cannot see this private event. This means only the people you send invites to can attend.',
          '',
          _provider.showToFollowers,
          _provider.setshowToFollowers));
    }
    // options.add(_buildSettingSwitchWithDivider(
    //     'Virtual event',
    //     'You can create an event that people can attend, or you can also create a virtual event that can be hosted on virtual platforms, where people can interact with you.',
    //     _provider.isVirtual,
    //     _provider.setIsVirtual));
    return options;
  }

  Widget _buildSettingSwitchWithDivider(String title, String subTitle,
      String body, bool value, Function onChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingSwitchBlack(
          title: title,
          subTitle: subTitle,
          value: value,
          onChanged: (bool value) => onChanged(value),
        ),
        if (body.isNotEmpty)
          GestureDetector(
            onTap: () {
              _showBottomSheetSettingsLearnMore(title, subTitle, body);
            },
            child: Text(
              'Learn more',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                color: Colors.blue,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
          child: Divider(
            color: Colors.grey,
            thickness: .3,
          ),
        ),
      ],
    );
  }

  _deleteWidget() {
    return Container(
        width: ResponsiveHelper.responsiveHeight(context, 50.0),
        height: ResponsiveHelper.responsiveHeight(context, 50.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(.4),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: widget.isCompleted
              ? () {
                  _showBottomSheetConfirmDeleteEvent();
                }
              : () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _showBottomDeleteForm();
                    },
                  );
                },
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              height: ResponsiveHelper.responsiveHeight(context, 40.0),
              width: ResponsiveHelper.responsiveHeight(context, 40.0),
              child: IconButton(
                icon: Icon(Icons.delete_forever),
                iconSize: ResponsiveHelper.responsiveHeight(context, 25.0),
                color: Colors.white,
                onPressed: widget.isCompleted
                    ? () {
                        _showBottomSheetConfirmDeleteEvent();
                      }
                    : () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _showBottomDeleteForm();
                          },
                        );
                      },
              ),
            ),
          ),
        ));
  }

//event categories: festivals, etc
  Widget _eventCategorySection() {
    UserData _provider = Provider.of<UserData>(context, listen: false);
    final bool isOtherCategory = _provider.category.startsWith('Others');

    return Stack(
      children: [
        _pageWidget(
          newWidget: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventProcessRow(_provider, isOtherCategory),
              DirectionWidgetWhite(
                text:
                    'Select an event category that matches the event you are creating. ',
              ),
              Text(
                _provider.category,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
                ),
              ),
              isOtherCategory
                  ? _buildContentFieldWhite(_provider)
                  : buildRadios(),
            ],
          ),
        ),
        if (widget.isEditting && widget.event != null)
          Positioned(
            right: 30,
            child: _deleteWidget(),
          )
      ],
    );
  }

  Widget _buildEventProcessRow(UserData _provider, bool isOtherCategory) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _eventProcessNumber(
          '2. ',
          'Category.',
        ),
        if (_provider.category.isNotEmpty)
          (!isOtherCategory || _provider.subCategory.isNotEmpty)
              ? MiniCircularProgressButton(
                  onPressed: () {
                    if (isOtherCategory) FocusScope.of(context).unfocus();
                    animateToPage(1);
                  },
                  text: "Next")
              : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildContentFieldWhite(UserData _provider) {
    return ContentFieldWhite(
      autofocus: true,
      labelText: "Custom Category",
      hintText: "Example:  House party, birthday party,  wedding, etc.",
      initialValue: _provider.subCategory,
      onSavedText: (input) => _provider.setSubCategory(input),
      onValidateText: (_) {},
    );
  }

  _adDateTimeButton(String buttonText, VoidCallback onPressed) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(100)),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                    )))));
  }

  _cancelSearch() {
    FocusScope.of(context).unfocus();
    _clearSearch();
    Navigator.pop(context);
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _addressSearchController.clear());
    Provider.of<UserData>(context, listen: false).addressSearchResults = [];
  }

  void _showBottomVenue(String from) {
    var _provider = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: ResponsiveHelper.responsiveHeight(context, 750),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SearchContentField(
                      showCancelButton: true,
                      cancelSearch: _cancelSearch,
                      controller: _addressSearchController,
                      focusNode: _addressSearchfocusNode,
                      hintText: 'Type to search...',
                      onClearText: () {
                        _clearSearch();
                      },
                      onTap: () {},
                      onChanged: (value) {
                        if (value.trim().isNotEmpty) {
                          _debouncer.run(() {
                            _provider.searchAddress(value);
                          });
                        }
                      }),
                ),
                Text(
                  '        Select your address from the list below',
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                  ),
                ),
                if (Provider.of<UserData>(
                      context,
                    ).addressSearchResults !=
                    null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            child: ListView.builder(
                              itemCount: _provider.addressSearchResults!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                        title: Text(
                                          _provider.addressSearchResults![index]
                                              .description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _provider.setCity('');
                                          _provider.setCountry('');
                                          _provider.setAddress(_provider
                                              .addressSearchResults![index]
                                              .description);
                                          // _reverseGeocoding(_provider
                                          //     .addressSearchResults![index]
                                          //     .description);
                                          reverseGeocoding(
                                              _provider,
                                              _provider
                                                  .addressSearchResults![index]
                                                  .description);
                                        }),
                                    Divider(
                                      thickness: .3,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  _ticketFiled(
    bool isTicket,
    bool autofocus,
    String labelText,
    String hintText,
    TextEditingController controler,
    TextInputType textInputType,
    final Function onValidateText,
  ) {
    var style = isTicket
        ? Theme.of(context).textTheme.titleSmall
        : TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
            color: labelText == 'Contact'
                ? Theme.of(context).secondaryHeaderColor
                : Colors.black,
          );
    var labelStyle = TextStyle(
        fontSize:
            ResponsiveHelper.responsiveFontSize(context, isTicket ? 16.0 : 14),
        color: isTicket ? Colors.blue : Colors.black);
    var hintStyle = TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        fontWeight: FontWeight.normal,
        color: Colors.grey);
    return TextFormField(
      autofocus: autofocus,
      cursorColor: Colors.blue,
      controller: controler,
      maxLines: null,
      keyboardAppearance: MediaQuery.of(context).platformBrightness,
      style: style,
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: isTicket ? labelText : null,
        hintText: hintText,
        labelStyle: isTicket ? labelStyle : null,
        hintStyle: hintStyle,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
      validator: (string) => onValidateText(string),
    );
  }

// event rate or ticket price
  _addTicketContainer() {
    var _provider = Provider.of<UserData>(context, listen: false);
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_provider.isFree)
              Text(
                  'Since this ticket is free, the price will automatically be set to 0. You do not need to add a price. However, you may provide the necessary information below.".',
                  style: Theme.of(context).textTheme.bodyMedium

                  //  TextStyle(
                  //   // fontWeight: FontWeight.bold,
                  //   color: Colors.grey,
                  //   fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  // ),
                  ),
            if (!_provider.isFree)
              Container(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _ticketFiled(
                        true,
                        true,
                        'Ticket Price',
                        'eg. 10.0',
                        _priceController,
                        TextInputType.numberWithOptions(decimal: true),
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price for the ticket';
                          }
                          final price = double.tryParse(value);
                          if (price == null || price <= 0.0) {
                            return 'Please enter a valid price for the ticket';
                          }
                          return null;
                        },
                      ))),
            const SizedBox(height: 30),
            Text(
              'Optional',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  _ticketFiled(
                    true,
                    false,
                    'Ticket Group, ',
                    'Early bird, Family tickets, Couples tickets,',
                    _groupController,
                    TextInputType.text,
                    () {},
                  ),
                  _ticketFiled(
                    true,
                    false,
                    'Ticket type',
                    'eg. Regular, Vip, VVip',
                    _ticketTypeController,
                    TextInputType.text,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a type for the ticket';
                      }
                      return null;
                    },
                  ),
                  _ticketFiled(
                    true,
                    false,
                    'Ticket access level',
                    'Extra benefits (Meet & greet, free food)',
                    _accessLevelController,
                    TextInputType.multiline,
                    () {},
                  ),
                  _ticketFiled(
                    true,
                    false,
                    'Ticket max order',
                    'Maximu ticket order',
                    _maxOrderController,
                    TextInputType.number,
                    () {},
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
                'The ticket maximum order (max order) refers to the maximum number of tickets that can be sold for a particular ticket type. It allows to monitor if a ticket has reached its capacity (sold out) or is still available for purchase. ',
                style: Theme.of(context).textTheme.bodySmall),
            // _ticketFiled(
            //   'Seating row',
            //   'Number of seating rows',
            //   _rowController,
            //   TextInputType.number,
            //   () {},
            // ),
            // _ticketFiled(
            //   'Maximum seat per row',
            //   'Maximum number of seats per row',
            //   _maxSeatPerRowController,
            //   TextInputType.number,
            //   () {},
            // ),
          ],
        ),
      ),
    );
  }

  _dateRange() {
    UserData _provider = Provider.of<UserData>(
      context,
    );
    final width = MediaQuery.of(context).size.width;
    List<DateTime> dateList = getDatesInRange(
        _provider.startDate.toDate(), _provider.clossingDay.toDate());
    return Container(
        // color: Colors.red,
        height: ResponsiveHelper.responsiveHeight(
            context,
            dateList.length == 1
                ? 60
                : dateList.length == 3
                    ? 190
                    : 120),
        width: ResponsiveHelper.responsiveWidth(context, width),
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: dateList.length == 1
                ? 1
                : dateList.length == 3
                    ? 3
                    : 2, // Items down the screen
            mainAxisSpacing: .7,
            crossAxisSpacing: .7,
            childAspectRatio: dateList.length <= 3 ? 0.2 / 1.1 : 0.3,
            // crossAxisCount: 5, // Two columns
            // childAspectRatio:
            //     3, // Adjust the ratio based on your layout needs
          ),
          itemCount: dateList.length,
          itemBuilder: (context, index) {
            DateTime date = dateList[index];
            return Card(
              // Using Card for better visual separation
              child: ListTile(
                title: Text(
                  MyDateFormat.toDate(date),
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                  ),

                  // DateFormat('yyyy-MM-dd').format(date)
                ),
                leading: Radio<DateTime>(
                  value: date,
                  activeColor: Colors.blue,
                  groupValue: _provider.sheduleDateTemp.toDate(),
                  onChanged: (DateTime? value) {
                    _provider.setSheduleDateTemp(Timestamp.fromDate(value!));
                    // setState(() {
                    //   _selectedDate = value;
                    // });
                  },
                ),
              ),
            );
          },
        ));
  }

  void _showBottomSheetticketSiteError() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: 'Ticket site not safe. ',
          subTitle:
              'We have identified potential threats associated with this link. Please enter another link.',
        );
      },
    );
  }

  void _showBottomTicketSite() {
    UserData _provider = Provider.of<UserData>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: Column(
                    children: [
                      if (Provider.of<UserData>(
                        context,
                      ).ticketSite.trim().isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: MiniCircularProgressButton(
                              onPressed: () async {
                                var _provider = Provider.of<UserData>(context,
                                    listen: false);
                                setState(() {
                                  _isLoading = true;
                                });

                                if (_ticketSiteFormkey.currentState!
                                    .validate()) {
                                  String urlToCheck = _provider.ticketSite;
                                  SafeBrowsingChecker checker =
                                      SafeBrowsingChecker();

                                  bool isSafe =
                                      await checker.isUrlSafe(urlToCheck);
                                  if (isSafe) {
                                    Navigator.pop(context);
                                    animateToPage(1);
                                  } else {
                                    _showBottomSheetticketSiteError();
                                    // mySnackBar(
                                    //     context, 'ticket site is not safe');
                                  }
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              text: "Next"),
                        ),
                      Form(
                        key: _ticketSiteFormkey,
                        child: ContentFieldBlack(
                            onlyBlack: false,
                            labelText: "Ticket website",
                            hintText:
                                'Link to website where ticket pruchase would be handled',
                            initialValue: _provider.ticketSite,
                            onSavedText: (input) =>
                                _provider.setTicketSite(input),
                            onValidateText: (input) {}

                            // => !ticketSiteLink.hasMatch(input!)
                            //     ? "Enter a valid ticket site link"
                            //     : null,
                            ),
                      ),
                      if (_isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: SizedBox(
                            height:
                                ResponsiveHelper.responsiveHeight(context, 2.0),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(Colors.blue),
                            ),
                          ),
                        )
                    ],
                  )),
            ),
          );
        });
      },
    );
  }

// rate and ticket section
  Widget _eventRateSection() {
    UserData _provider = Provider.of<UserData>(context, listen: false);
    var _userLocation = _provider.userLocationPreference;

    final List<String> currencyPartition = _provider.currency.isEmpty
        ? ' Ghana Cedi | GHS'.trim().replaceAll('\n', ' ').split("|")
        : _provider.currency.trim().replaceAll('\n', ' ').split("|");

    // Check for the country being Ghana or the currency code being GHS
    bool isGhanaOrCurrencyGHS = _userLocation!.country == 'Ghana' &&
        currencyPartition[1].trim() == 'GHS';

    // Check if the subaccount and transfer recipient IDs are empty
    bool shouldNavigate = _userLocation.subaccountId!.isEmpty ||
        _userLocation.transferRecepientId!.isEmpty;

    final width = MediaQuery.of(context).size.width;

    return _pageWidget(
      newWidget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: width * width,
            width: width,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30)),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                if (_provider.currency.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _eventProcessNumber(
                        '5. ',
                        'Tickets.',
                      ),
                      _provider.ticket.isEmpty || _provider.currency.isEmpty
                          ? SizedBox.shrink()
                          : _provider.isFree || _provider.isCashPayment
                              ? MiniCircularProgressButton(
                                  onPressed: () {
                                    _validate();
                                  },
                                  text: "Next",
                                )
                              : isGhanaOrCurrencyGHS
                                  ? MiniCircularProgressButton(
                                      onPressed: isGhanaOrCurrencyGHS &&
                                              shouldNavigate
                                          ? () {
                                              _navigateToPage(
                                                  context,
                                                  CreateSubaccountForm(
                                                    isEditing: false,
                                                  ));
                                            }
                                          : widget.isEditting
                                              ? () {
                                                  _validate();
                                                }
                                              : () {
                                                  _validate();
                                                }, // Pass null or remove the onPressed to disable the button if the condition is not met
                                      text: "Next",
                                    )
                                  : MiniCircularProgressButton(
                                      onPressed: widget.isEditting
                                          ? () {
                                              _validate();
                                            }
                                          : () {
                                              _showBottomTicketSite();
                                            }, // Pass null or remove the onPressed to disable the button if the condition is not met
                                      text: "Next",
                                    )
                    ],
                  ),

                DirectionWidgetWhite(
                  text:
                      'Create tickets for your event! Customize them based on your needs and preferences. For instance, you have the option to create VIP tickets with special access levels and exclusive options.',
                ),
                if (_provider.endDateSelected)
                  Container(
                    decoration: BoxDecoration(
                        color:
                            Theme.of(context).primaryColorLight.withOpacity(.3),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _dateRange(),
                      ],
                    ),
                  ),
                if (_provider.endDateSelected) const SizedBox(height: 20.0),
                Text(
                  _provider.currency,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 16.0),
                  ),
                ),
                const SizedBox(height: 10.0),
                _buildPickOptionWidget(_provider),
                const SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Colors.white,
                  thickness: .3,
                ),
                const SizedBox(
                  height: 30,
                ),
                // const SizedBox(height: 10.0),
                TicketGroup(
                  groupTickets: _provider.ticket,
                  currentUserId: _provider.user!.userId!,
                  event: null,
                  inviteReply: '',
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickOptionWidget(UserData _provider) {
    return PickOptionWidget(
      title: _provider.ticket.length < 1
          ? 'Create Ticket'
          : 'Create another Ticket',
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _buildTicketDialog();
          },
        );
      },
      dropDown: false,
    );
  }

  Widget _buildTicketDialog() {
    var _provider = Provider.of<UserData>(context, listen: false);
    return ValueListenableBuilder(
      valueListenable: _isTypingNotifier,
      builder: (BuildContext context, bool isTyping, Widget? child) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).primaryColorLight,
          title: ListTile(
            trailing: _priceController.text.isEmpty && !_provider.isFree
                ? SizedBox.shrink()
                : MiniCircularProgressButton(
                    color: Colors.blue,
                    text: 'Add',
                    onPressed: () {
                      _addTicket();
                      Navigator.pop(context);
                    },
                  ),

            //  GestureDetector(
            //     onTap: () {
            //       _addTicket();
            //       Navigator.pop(context);
            //     },
            //     child:

            //      Container(
            //       decoration: BoxDecoration(
            //           color: Colors.blue,
            //           borderRadius: BorderRadius.circular(100)),
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text('  Add  ',
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontSize: ResponsiveHelper.responsiveFontSize(
            //                   context, 14.0),
            //             )),
            //       ),
            //     ),
            //   ),
            title: Text(
              'Create Ticket',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          content: _addTicketContainer(),
        );
      },
    );
  }

  _pageWidget({required Column newWidget}) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 80),
            child: newWidget),
      ),
    );
  }

//section for people performain in an event
  _cancelSearchUser() {
    if (mounted) {
      setState(() {
        _users = null;
        _clearSearchUser();
      });
    }
  }

  _clearSearchUser() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _tagNameController.clear());
    _selectedNameToAdd = '';
    _tagNameController.clear();
  }

  _switchTagPeopleRole(
    bool fromList,
  ) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: fromList
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: performers.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      performers[index],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () async {
                      if (mounted) {
                        setState(() {
                          _selectedRole = performers[index];
                          _taggedType = 'performer';
                        });
                      }
                      Navigator.pop(context);
                    },
                    subtitle: Divider(
                      thickness: .3,
                    ),
                  );
                },
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: crew.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      crew[index],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () async {
                      if (mounted) {
                        setState(() {
                          _selectedRole = crew[index];
                          _taggedType = 'crew';
                        });
                      }
                      Navigator.pop(context);
                    },
                    subtitle: Divider(
                      thickness: .3,
                    ),
                  );
                },
              ));
  }

  _addPeopleFunction(AccountHolderAuthor user, bool isSchedule) {
    var _provider = Provider.of<UserData>(context, listen: false);
    return isSchedule
        ? () {
            _addSchedulePeople(user.userName!, user.userId!, '');
            Navigator.pop(context);
          }
        : () {
            _provider.setArtist(user.userId!);
            if (mounted) {
              setState(() {
                _selectedNameToAdd = user.userName!;
              });
            }

            Navigator.pop(context);
          };
  }

  _buildUserTile(AccountHolderAuthor user, bool isSchedule) {
    return SearchUserTile(
        verified: user.verified!,
        userName: user.userName!.toUpperCase(),
        profileHandle: user.profileHandle!,
        // company: user.company!,
        profileImageUrl: user.profileImageUrl!,
        bio: user.bio!,
        onPressed: _addPeopleFunction(user, isSchedule));
  }

  void _showBottomTaggedPeople(bool isSchedule) {
    var _size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              height: ResponsiveHelper.responsiveHeight(context, 750),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: DoubleOptionTabview(
                  height: _size.height,
                  onPressed: (int) {},
                  tabText1: 'From Bars Impression',
                  tabText2: 'From external link',
                  initalTab: 0,
                  widget1: ListView(
                    children: [
                      Text(
                        _tagNameController.text,
                      ),
                      SearchContentField(
                          cancelSearch: _cancelSearchUser,
                          controller: _tagNameController,
                          focusNode: _nameSearchfocusNode,
                          hintText: 'Enter username..',
                          onClearText: () {
                            _clearSearchUser();
                          },
                          onTap: () {},
                          onChanged: (input) {
                            if (input.trim().isNotEmpty) {
                              _debouncer.run(() {
                                setState(() {
                                  _users = DatabaseService.searchUsers(
                                      input.toUpperCase());
                                });
                              });
                            }
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      //   child: Text(
                      //     'This user can remove or verify this tag, When this user verifies this tagg a black checkmark would be added to this tag.',
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.grey,
                      //       fontSize: ResponsiveHelper.responsiveFontSize(
                      //           context, 12.0),
                      //     ),
                      //   ),
                      // ),
                      if (_users != null)
                        Text('        Select a person from the list below'),
                      if (_users != null)
                        FutureBuilder<QuerySnapshot>(
                            future: _users,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox.shrink();
                              }
                              if (snapshot.data!.docs.length == 0) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "No users found. ",
                                            style: TextStyle(
                                                fontSize: ResponsiveHelper
                                                    .responsiveFontSize(
                                                        context, 20.0),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey)),
                                        TextSpan(
                                            text:
                                                '\nCheck username and try again.',
                                            style: TextStyle(
                                              fontSize: ResponsiveHelper
                                                  .responsiveFontSize(
                                                      context, 14.0),
                                            )),
                                      ],
                                      style: TextStyle(
                                          fontSize: ResponsiveHelper
                                              .responsiveFontSize(
                                                  context, 14.0),
                                          color: Colors.grey),
                                    )),
                                  ),
                                );
                              }
                              return SingleChildScrollView(
                                child: SizedBox(
                                  height: _size.width,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          height: _size.width - 20,
                                          child: ListView.builder(
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              AccountHolderAuthor? user =
                                                  AccountHolderAuthor.fromDoc(
                                                      snapshot
                                                          .data!.docs[index]);
                                              return _buildUserTile(
                                                  user, isSchedule);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                    ],
                  ),
                  widget2: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _addPersonFormKey,
                      child: Column(
                        children: [
                          _selectedNameToAdd.isEmpty ||
                                  _taggedUserExternalLink.isEmpty
                              ? SizedBox.shrink()
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: _adDateTimeButton(
                                    '  Add  ',
                                    !isSchedule
                                        ? () {
                                            if (_addPersonFormKey.currentState!
                                                .validate())
                                              Navigator.pop(context);
                                          }
                                        : () {
                                            if (_addPersonFormKey.currentState!
                                                .validate()) {
                                              _addSchedulePeople(
                                                _selectedNameToAdd,
                                                '',
                                                _taggedUserExternalLink,
                                              );

                                              Navigator.pop(context);
                                            }

                                            // }
                                          },
                                  ),
                                ),
                          ContentFieldBlack(
                              onlyBlack: false,
                              onSavedText: (value) {
                                setState(() {
                                  _selectedNameToAdd = value;
                                });
                              },
                              onValidateText: (_) {},
                              initialValue: _selectedNameToAdd,
                              hintText: 'Nam of person',
                              labelText: 'Name'),
                          ContentFieldBlack(
                              onlyBlack: false,
                              onSavedText: (value) {
                                setState(() {
                                  _taggedUserExternalLink = value;
                                });
                              },
                              onValidateText: (value) {
                                String pattern =
                                    r'^(https?:\/\/)?(([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?)$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value!))
                                  return 'Enter a valid URL';
                                else
                                  return null;
                              },
                              initialValue: _taggedUserExternalLink,
                              hintText:
                                  'External link to profile(social media, wikipedia)',
                              labelText: 'link'),
                        ],
                      ),
                    ),
                  ),
                  lightColor: true,
                  pageTitle: '',
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _showBottomTaggedPeopleRole() {
    var _size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: _size.height.toDouble() / 1.3,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: DoubleOptionTabview(
              height: _size.height,
              onPressed: (int) {},
              tabText1: 'Performers',
              tabText2: 'Crew',
              initalTab: 0,
              widget1: _switchTagPeopleRole(
                true,
              ),
              widget2: _switchTagPeopleRole(
                false,
              ),
              lightColor: true,
              pageTitle: '',
            ),
          ),
        );
      },
    );
  }

//pick dates
  Widget _eventPickDateSection() {
    UserData _provider = Provider.of<UserData>(context, listen: false);
    Duration _durationDuringEvents =
        _provider.clossingDay.toDate().difference(_provider.startDate.toDate());
    int differenceBetweenEventDays = _durationDuringEvents.inDays.abs();

    Duration _countDownToEvents =
        DateTime.now().difference(_provider.startDate.toDate());
    int countDownDifferenceToEvent = _countDownToEvents.inDays.abs();

    return _pageWidget(
      newWidget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventProcessRow3(),
          DirectionWidgetWhite(
            text:
                'Select a start and end date for your event. If your event would end on thesame day, you can select only the start date. ',
          ),
          if (widget.isEditting)
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              child: Text(
                'If you decide to change your event and date, please note that it will impact the format of your schedules and tickets. We recommend adjusting the dates on your schedules and tickets to align with your new modified date.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 12)),
              ),
            ),
          DatePicker(
            onStartDateChanged: (DateTime newDate) {
              _provider.setStartDate(Timestamp.fromDate(newDate));
              _provider.setSheduleDateTemp(Timestamp.fromDate(newDate));
              _provider.setStartDateString(newDate.toString());
            },
            onEndDateChanged: (DateTime newDate) {
              _provider.setClossingDay(Timestamp.fromDate(newDate));
              _provider.setClossingDayString(newDate.toString());
            },
            onEndTimeChanged: (DateTime newDate) {
              _scheduleStartTime = newDate;
            },
            onStartTimeChanged: (DateTime newDate) {
              _scheduleEndTime = newDate;
            },
            date: true,
          ),
          _buildEventInformationDivider(),
          _buildEventInformationText(
              'Duration:', '${differenceBetweenEventDays.toString()} days'),
          _buildEventInformationDivider(),
          _buildEventInformationText('Countdown:',
              '${countDownDifferenceToEvent.toString()} days more'),
          _buildEventInformationDivider(),
        ],
      ),
    );
  }

  Widget _buildEventProcessRow3() {
    UserData _provider = Provider.of<UserData>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _eventProcessNumber(
          '3. ',
          'Date.',
        ),
        if (_provider.startDateSelected || widget.isEditting)
          MiniCircularProgressButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                animateToPage(1);
              },
              text: "Next")
      ],
    );
  }

  Widget _buildEventInformationDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(
        color: Colors.white,
        thickness: .3,
      ),
    );
  }

  Widget _buildEventInformationText(String title, String value) {
    return RichText(
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title   ',
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                fontWeight: FontWeight.bold),
          )
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  //Time schedule

  List<DateTime> getDatesInRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  _sheduleDivider(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        // const Divider(
        //   color: Colors.white,
        //   thickness: .3,
        // ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  // DateTime? _selectedDate;

  _eventPickTimeScheduleSection() {
    final width = MediaQuery.of(context).size.width;
    var _provider = Provider.of<UserData>(
      context,
    );

    List<DateTime> dateList = getDatesInRange(
        _provider.startDate.toDate(), _provider.clossingDay.toDate());
    return _pageWidget(
      newWidget: Column(
        children: [
          Container(
            height: ResponsiveHelper.responsiveHeight(context, 500 * 500),
            width: width,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30)),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _eventProcessNumber(
                      '4. ',
                      'Program lineup\n(Time schedules)',
                    ),
                    _provider.schedule.isEmpty
                        ? SizedBox.shrink()
                        : MiniCircularProgressButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              // _provider.isFree
                              //     ? animateToPage(2)
                              //     :

                              widget.isEditting
                                  ? animateToPage(1)
                                  : _showCurrencyPicker();
                              // animateToPage(1);
                            },
                            text: "Next")
                  ],
                ),
                DirectionWidgetWhite(
                  text:
                      'The program lineup refers to the sequence or order in which different elements of the event will be presented or performed. You should provide a structured timeline for attendees, staff, and participants to know when each segment of the event will occur.',
                ),

                _scheduleTitleController.text.isEmpty ||
                        _provider.schedulePerson.isEmpty ||
                        !_provider.endTimeSelected ||
                        !_provider.startTimeSelected
                    ? SizedBox.shrink()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: _adDateTimeButton(
                          '  Add ',
                          () {
                            _addSchedule();
                          },
                        ),
                      ),
                const SizedBox(height: 10.0),
                // const SizedBox(
                //   height: 30,
                // ),
                Container(
                  decoration: BoxDecoration(
                      color:
                          //  !_provider.endDateSelected
                          //     ? Colors.transparent
                          //     :
                          Theme.of(context).primaryColorLight.withOpacity(.3),
                      borderRadius: BorderRadius.circular(10)),
                  // padding: EdgeInsets.all(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (dateList.length > 1)
                        _sheduleDivider(
                            'Choose the date for which you want to create a program lineup.'),
                      // Column(
                      //   children: [
                      if (_provider.endDateSelected) _dateRange(),
                      // if (_provider.endDateSelected)
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      _sheduleDivider(
                          'Select the start and end time to indicate the duration for this program on the schedule'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: DatePicker(
                          onStartDateChanged: (DateTime newDate) {
                            _scheduleStartTime = newDate;
                          },
                          onStartTimeChanged: (DateTime newDate) {
                            _scheduleStartTime = newDate;
                          },
                          onEndDateChanged: (DateTime newDate) {
                            _scheduleEndTime = newDate;
                          },
                          onEndTimeChanged: (DateTime newDate) {
                            _scheduleEndTime = newDate;
                          },
                          date: false,
                        ),
                      ),
                      //   ],
                      // ),
                      // if (_provider.endDateSelected)
                      //   const SizedBox(
                      //     height: 40,
                      //   ),
                      _sheduleDivider(
                          'Enter the title of the program segment (e.g., \'opening prayer\') '),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: _ticketFiled(
                            false,
                            false,
                            'Program title',
                            'Schedule(Program) title',
                            _scheduleTitleController,
                            TextInputType.text,
                            (value) {
                              if (value == null || value.isEmpty) {
                                return 'Program title cannot be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      _sheduleDivider(
                          'Add the person or people performing or participating in this program. You can either provide their names from Bars Impression or include a link to their profiles on other platforms.'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: PickOptionWidget(
                            dropDown: true,
                            title: 'Add speaker or performer',
                            onPressed: () {
                              _showBottomTaggedPeople(true);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10.0, left: 10, right: 10),
                        child: SchedulePeopleGroup(
                          canBeEdited: true,
                          groupTaggedEventPeopleGroup: _provider.schedulePerson,
                          // .where((taggedPerson) =>
                          //     taggedPerson.role != 'Sponsor' &&
                          //     taggedPerson.role != 'Partner')
                          // .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Divider(
                //   color: Colors.white,
                //   thickness: .3,
                // ),
                // const SizedBox(
                //   height: 30,
                // ),
                ScheduleGroup(
                  schedules: _provider.schedule,
                  isEditing: true,
                  eventOrganiserId: _provider.currentUserId!,
                  currentUserId: _provider.currentUserId!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// pick event address section
  _eventAdressSection() {
    var _provider = Provider.of<UserData>(
      context,
    );
    _pickVenueText(
      String title,
      String subTitle,
      VoidCallback onPressed,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PickOptionWidget(
            title: title,
            onPressed: onPressed,
            dropDown: true,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Text(
              subTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              ),
            ),
          )
        ],
      );
    }

    return _pageWidget(
      newWidget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _eventProcessNumber(
                '6. ',
                'Venue',
              ),
              _provider.venue.isEmpty || _provider.address.isEmpty
                  ? SizedBox.shrink()
                  : MiniCircularProgressButton(
                      onPressed: _validate, text: 'Next'),
            ],
          ),
          DirectionWidgetWhite(
            text: _provider.isVirtual
                ? 'Enter the host link of the event. It will help other users virtually join the event if they are interested. '
                : 'Please enter the venue for the event. The venue refers to the specific physical location where the event will take place. It could be an event center, auditorium, stadium, church, house, club, or any other suitable space. ',
          ),
          SizedBox(height: 10),
          _provider.isVirtual
              ? Container(
                  color: Colors.white,
                  child: ContentFieldBlack(
                    labelText: "Virtual venue",
                    hintText: "Link to virtual event venue",
                    initialValue: _provider.address,
                    onSavedText: (input) => _provider.setAddress(input),
                    onValidateText: (_) {},
                  ),
                )
              : Container(
                  color: Colors.white,
                  child: ContentFieldBlack(
                    labelText: "Event venue",
                    hintText:
                        "This could be an event center name, an auditorium, a stadium, or a church.",
                    initialValue: _provider.venue,
                    onSavedText: (input) => _provider.setVenue(input),
                    onValidateText: (_) {},
                  ),
                ),
          const SizedBox(
            height: 30,
          ),
          _provider.address.isEmpty
              ? _pickVenueText('+  Add Address to venue',
                  'Please provide the venue address accurately. It will assist attendees in finding the event venue (location).',
                  () {
                  _showBottomVenue(
                    'Adrress',
                  );
                })
              : GestureDetector(
                  onTap: () {
                    _showBottomVenue(
                      'Adrress',
                    );
                  },
                  child: Text(
                    _provider.address,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  _eventPeopleSection(bool isSponsor) {
    var _provider = Provider.of<UserData>(context, listen: false);
    List<TaggedEventPeopleModel> taggPeoples = _provider.taggedEventPeople;
    Map<String, List<TaggedEventPeopleModel>> taggPeoplesByGroup = {};
    for (TaggedEventPeopleModel taggedPeople in taggPeoples) {
      if (!taggPeoplesByGroup.containsKey(taggedPeople.role)) {
        taggPeoplesByGroup[taggedPeople.role] = [];
      }
      taggPeoplesByGroup[taggedPeople.role]!.add(taggedPeople);
    }

    var _style = TextStyle(
        color: Colors.white,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
        fontWeight: FontWeight.bold);
    return _pageWidget(
      newWidget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _eventProcessNumber(
                isSponsor ? '8. ' : '7. ',
                isSponsor
                    ? 'Partners and sponsors.\n(Optional)'
                    : 'Performers and special guests.\n(Optional)',
              ),
              MiniCircularProgressButton(
                  onPressed: _validate,
                  text: widget.isEditting
                      ? 'Next'
                      : _provider.taggedEventPeople.isEmpty
                          ? "Skip"
                          : "Next"),
            ],
          ),
          DirectionWidgetWhite(
            text: isSponsor
                ? 'Please enter the names of sponsors and partners who are supporting this event. '
                : 'Please provide the names and roles of all the performers, participants, or special guests who will be attending this event.',
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectedNameToAdd.isEmpty ||
                      _selectedRole.isEmpty ||
                      _provider.artist.isEmpty &&
                          _taggedUserExternalLink.isEmpty
                  ? SizedBox.shrink()
                  : Align(
                      alignment: Alignment.centerRight,
                      child: _adDateTimeButton(
                        isSponsor
                            ? '  Add  $_selectedRole '
                            : '  Add  $_taggedType ',
                        () {
                          _addTaggedPeople();
                        },
                      ),
                    ),
              const SizedBox(
                height: 30,
              ),
              PickOptionWidget(
                  dropDown: true,
                  title: 'Add name',
                  onPressed: () {
                    _showBottomTaggedPeople(false);
                  }),
              const SizedBox(
                height: 10,
              ),
              Text(_selectedNameToAdd, style: _style),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          isSponsor
              ? buildSponserOrPartnerRadios()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PickOptionWidget(
                      title: 'Add Role',
                      onPressed: () {
                        _showBottomTaggedPeopleRole();
                      },
                      dropDown: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_selectedRole.isNotEmpty)
                      Text("$_taggedType:   $_selectedRole", style: _style),
                  ],
                ),
          const SizedBox(height: 20.0),
          Divider(
            color: Colors.white,
            thickness: .3,
          ),
          const SizedBox(height: 20.0),
          TaggedPeopleGroup(
            canBeEdited: true,
            groupTaggedEventPeopleGroup: isSponsor
                ? _provider.taggedEventPeople
                    .where((taggedPerson) =>
                        taggedPerson.role == 'Sponsor' ||
                        taggedPerson.role == 'Partner')
                    .toList()
                : _provider.taggedEventPeople
                    .where((taggedPerson) =>
                        taggedPerson.role != 'Sponsor' &&
                        taggedPerson.role != 'Partner')
                    .toList(),
          ),
        ],
      ),
    );
  }

  void _showBottomContact(
    List<String> contacts,
  ) {
    TextEditingController controller = _contactController;
    double sheetHeightFraction = 1.3;

    var _size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AnimatedBuilder(
                animation: controller, // Use the controller as the Listenable
                builder: (BuildContext context, Widget? child) {
                  return Form(
                    key: _contactsFormKey,
                    child: Container(
                      height: _size.height.toDouble() / sheetHeightFraction,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(30)),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView(
                            children: [
                              contacts.length < 6 && controller.text.length > 0
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: MiniCircularProgressButton(
                                        onPressed: () {
                                          _addContacts();
                                        },
                                        text: "Add",
                                        color: Colors.blue,
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Done',
                                          style: TextStyle(
                                              fontSize: ResponsiveHelper
                                                  .responsiveFontSize(
                                                      context, 14.0),
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                              if (contacts.length > 5 &&
                                  controller.text.length > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Text(
                                    'You cannot add more than six ',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              const SizedBox(
                                height: 30,
                              ),
                              _ticketFiled(
                                false,
                                true,
                                'Contact',
                                'Phone numbers',
                                _contactController,
                                TextInputType.numberWithOptions(decimal: true),
                                (value) {
                                  String pattern =
                                      r'^(\+\d{1,3}[- ]?)?\d{1,4}[- ]?(\d{1,3}[- ]?){1,2}\d{1,9}(\ x\d{1,4})?$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value!))
                                    return 'Enter a valid phone number';
                                  else
                                    return null;
                                },
                                // (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'Program title cannot be empty';
                                //   }
                                //   return null;
                                // },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          });
        });
  }

  _eventOrganizerContacts() {
    var _provider = Provider.of<UserData>(context, listen: false);

    var _style = TextStyle(
        color: Colors.white,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
        fontWeight: FontWeight.bold);
    return _pageWidget(
      newWidget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _eventProcessNumber(
                '10. ',
                'Contacts',
              ),
              if (_provider.eventOrganizerContacts.isNotEmpty)
                MiniCircularProgressButton(
                    onPressed: _validate,
                    text: widget.isEditting
                        ? 'Next'
                        : _provider.isPrivate
                            ? "Next"
                            : "Next"),
            ],
          ),
          DirectionWidgetWhite(
            text:
                'Kindly provide a phone number for potential attendees and partners to get in touch with you.',
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              PickOptionWidget(
                  dropDown: true,
                  title: 'Add contact',
                  onPressed: () {
                    _showBottomContact(_provider.eventOrganizerContacts);
                  }),
              const SizedBox(
                height: 10,
              ),
              Text(_selectedNameToAdd, style: _style),
            ],
          ),
          const SizedBox(height: 20.0),
          Divider(
            color: Colors.white,
            thickness: .3,
          ),
          const SizedBox(height: 20.0),
          EventOrganizerContactWidget(
            portfolios: _provider.eventOrganizerContacts,
            edit: true,
          ),
        ],
      ),
    );
  }

// enter main event information: title, theme, etc.
  _validateTextToxicity() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setIsLoading(true);

    TextModerator moderator = TextModerator();

    // Define the texts to be checked
    List<String> textsToCheck = [_provider.title, _provider.theme];

    // Set a threshold for toxicity that is appropriate for your app
    const double toxicityThreshold = 0.7;
    bool allTextsValid = true;

    try {
      for (String text in textsToCheck) {
        if (text.isEmpty) {
          // Handle the case where the text is empty
          mySnackBar(context, 'Title and theme cannot be empty.');
          allTextsValid = false;
          break; // Exit loop as there is an empty text
        }

        Map<String, dynamic>? analysisResult =
            await moderator.moderateText(text);

        // Check if the API call was successful
        if (analysisResult != null) {
          double toxicityScore = analysisResult['attributeScores']['TOXICITY']
              ['summaryScore']['value'];

          if (toxicityScore >= toxicityThreshold) {
            // If any text's score is above the threshold, show a Snackbar and set allTextsValid to false
            mySnackBarModeration(context,
                'Your title or theme contains inappropriate content. Please review');
            allTextsValid = false;
            break; // Exit loop as we already found inappropriate content
          }
        } else {
          // Handle the case where the API call failed
          mySnackBar(context, 'Error analyzing text. Try again.');
          allTextsValid = false;
          break; // Exit loop as there was an API error
        }
      }
    } catch (e) {
      // Handle any exceptions here
      mySnackBar(context, 'An unexpected error occurred. Please try again.');
      allTextsValid = false;
    } finally {
      // This block runs whether an exception occurred or not
      _provider.setIsLoading(false);
    }

    // You can use allTextsValid for further logic if needed
    if (allTextsValid) {
      _provider.setIsLoading(false);
      animateToPage(1);
    }
  }

  // void myInternalSnackBar(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }

  void mySnackBarModeration(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 4),
      ),
    );
  }

  // _validateTextToxicity() async {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   _provider.setIsLoading(true);

  //   TextModerator moderator = TextModerator();

  //   // Define the texts to be checked
  //   List<String> textsToCheck = [_provider.title, _provider.theme];

  //   // Set a threshold for toxicity that is appropriate for your app
  //   const double toxicityThreshold = 0.7;
  //   bool allTextsValid = true;

  //   for (String text in textsToCheck) {
  //     if (text.isEmpty) {
  //       // Handle the case where the text is empty
  //       _provider.setIsLoading(false);
  //       mySnackBar(context, ' Title and theme cannot be empty.');
  //       allTextsValid = false;
  //       break; // Exit loop as there is an empty text
  //     }

  //     Map<String, dynamic>? analysisResult = await moderator.moderateText(text);

  //     // Check if the API call was successful
  //     if (analysisResult != null) {
  //       double toxicityScore = analysisResult['attributeScores']['TOXICITY']
  //           ['summaryScore']['value'];

  //       if (toxicityScore >= toxicityThreshold) {
  //         // If any text's score is above the threshold, show a Snackbar and set allTextsValid to false
  //         mySnackBarModeration(context,
  //             'Your title or theme contains inappropriate content. Please review');
  //         _provider.setIsLoading(false);

  //         allTextsValid = false;
  //         break; // Exit loop as we already found inappropriate content
  //       }
  //     } else {
  //       // Handle the case where the API call failed
  //       _provider.setIsLoading(false);
  //       mySnackBar(context, 'Try again.');
  //       allTextsValid = false;
  //       break; // Exit loop as there was an API error
  //     }
  //   }

  //   // Animate to the next page if all texts are valid
  //   if (allTextsValid) {
  //     _provider.setIsLoading(false);
  //     animateToPage(1);
  //   }
  // }

  _eventMainInformation() {
    var _provider = Provider.of<UserData>(context, listen: false);
    return _pageWidget(
      newWidget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _eventProcessNumber(
                '9. ',
                'Flyer\nInformation.',
              ),
              if (_provider.title.isNotEmpty && _provider.theme.isNotEmpty)
                MiniCircularProgressButton(
                    onPressed: _validateTextToxicity, text: "Next"),
            ],
          ),
          DirectionWidgetWhite(
            text:
                'Please ensure that you provide the necessary information accurately. Both the Title and Theme fields must be filled in order to proceed. ',
          ),
          // if (_provider.isLoading)
          //   SizedBox(
          //     height: ResponsiveHelper.responsiveHeight(context, 2.0),
          //     child: LinearProgressIndicator(
          //       backgroundColor: Colors.transparent,
          //       valueColor: AlwaysStoppedAnimation(Colors.blue),
          //     ),
          //   ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ContentFieldBlack(
                    labelText: 'Title',
                    hintText: "Enter the title of your event",
                    initialValue: _provider.title.toString(),
                    onSavedText: (input) => _provider.setTitle(input),
                    onValidateText: (input) => input.trim().length < 1
                        ? "The title cannot be empty"
                        : null,
                  ),
                  ContentFieldBlack(
                    labelText: 'Theme',
                    hintText: "Enter a theme for the event",
                    initialValue: _provider.theme.toString(),
                    onSavedText: (input) => _provider.setTheme(input),
                    onValidateText: (input) => input.trim().length < 10
                        ? "The theme is too short( > 10 characters)"
                        : null,
                  ),
                  ContentFieldBlack(
                    labelText: "Dress code for the event",
                    hintText: 'Dress code',
                    initialValue: _provider.dressCode,
                    onSavedText: (input) => _provider.setDressCode(input),
                    onValidateText: (_) {},
                  ),
                  _provider.isVirtual && _provider.couldntDecodeCity
                      ? const SizedBox.shrink()
                      : ContentFieldBlack(
                          labelText: 'City',
                          hintText: "City of event",
                          initialValue: _provider.city.toString(),
                          onSavedText: (input) =>
                              _provider.setCity(input.trim()),
                          onValidateText: (input) => input.trim().length < 1
                              ? "Enter the city of event"
                              : null,
                        ),
                  _provider.isVirtual && _provider.couldntDecodeCity
                      ? const SizedBox.shrink()
                      : ContentFieldBlack(
                          labelText: 'Country',
                          hintText: "Country of event",
                          initialValue: _provider.country.toString(),
                          onSavedText: (input) =>
                              _provider.setCountry(input.trim()),
                          onValidateText: (input) => input.trim().length < 1
                              ? "Enter the country of event"
                              : null,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final musiVideoLink =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");
// event optional addtitional information

  // // bool isValidUrl(String url) {
  // final ticketSiteLink = RegExp(
  //   r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  //   caseSensitive: false,
  // );
  //   return regex.hasMatch(url);
  // }

  // _validateTicketLink() async {
  //   var _provider = Provider.of<UserData>(context, listen: false);

  //   if (_ticketSiteFormkey.currentState!.validate()) {
  //     String urlToCheck = _provider.ticketSite;
  //     SafeBrowsingChecker checker = SafeBrowsingChecker();

  //     bool isSafe = await checker.isUrlSafe(urlToCheck);
  //     if (isSafe) {
  //       animateToPage(1);
  //     } else {
  //       mySnackBar(context, 'ticket site is not safe');
  //     }
  //   }
  // }

  _validatePreviosEventLink() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (_addPreviousVideoFormkey.currentState!.validate()) {
      String urlToCheck = _provider.previousEvent;
      SafeBrowsingChecker checker = SafeBrowsingChecker();

      bool isSafe = await checker.isUrlSafe(urlToCheck);
      if (isSafe) {
        animateToPage(1);
      } else {
        mySnackBar(context, 'video link is not safe');
      }
    }
  }

  _eventPreviousEvent() {
    var _provider = Provider.of<UserData>(context, listen: false);
    // bool notGhana = _provider.userLocationPreference!.country != 'Ghana';

    return _pageWidget(
      newWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _eventProcessNumber(
                '11. ',
                'Previous\nEvent.(optional)',
              ),
              // notGhana && _provider.ticketSite.isEmpty
              //     ? SizedBox.shrink()
              //     :
              MiniCircularProgressButton(
                  onPressed:
                      // _provider.ticketSite.isNotEmpty
                      //     ? _validateTicketLink
                      //     :
                      _provider.previousEvent.isNotEmpty
                          ? _validatePreviosEventLink
                          : _validate,
                  text: "Next"),
            ],
          ),
          DirectionWidgetWhite(
            text:
                'To give other users an insight into the upcoming event, you can share a video link showcasing the previous event.',
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Form(
                  key: _addPreviousVideoFormkey,
                  child: ContentFieldBlack(
                    labelText: "Previous event",
                    hintText: 'A video link to previous event',
                    initialValue: _provider.previousEvent,
                    onSavedText: (input) => _provider.setPreviousEvent(input),
                    onValidateText: (input) => !musiVideoLink.hasMatch(input!)
                        ? "Enter a valid video link"
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  _eventTermsAndConditions() {
    var _provider = Provider.of<UserData>(context, listen: false);

    return _pageWidget(
      newWidget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _eventProcessNumber(
                '12. ',
                'Terms and Conditions.\n(optional)',
              ),
              _provider.isLoading
                  ? const SizedBox.shrink()
                  : MiniCircularProgressButton(
                      color: Colors.blue,
                      onPressed: () async {
                        var connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult == ConnectivityResult.none) {
                          // No internet connection
                          _showBottomSheetErrorMessage(
                              'No internet connection available. ');
                          return;
                        }
                        widget.isEditting ? _editEvent() : _submitCreate();
                      },
                      text: widget.isEditting ? 'Save' : "Create",
                    ),
            ],
          ),
          DirectionWidgetWhite(
            text:
                'You can provide your terms and conditions and other policies to govern this event.',
          ),
          Container(
            color: Colors.white,
            child: ContentFieldBlack(
              labelText: "Terms and conditions",
              hintText: 'Terms and conditions governing this event',
              initialValue: _provider.eventTermsAndConditions,
              onSavedText: (input) =>
                  _provider.setEventTermsAndConditions(input),
              onValidateText: (_) {},
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'The terms and conditions outline the terms of service for event attendees and establish the rights and responsibilities of both the event organizer and attendees. By providing these terms and conditions and ensuring that attendees read and understand them, individuals can obtain clear information regarding crucial aspects including event policies, refund and cancellation policies, liability disclaimers, code of conduct, privacy and data handling practices, and any other relevant rules or guidelines. This helps create transparency and enables attendees to make informed decisions and comply with the established terms during their participation in the event.',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  _animatedText(String text) {
    return FadeAnimatedText(
      duration: const Duration(seconds: 8),
      text,
      textStyle: TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
        color: Colors.white,
      ),
    );
  }

  _loadingWidget() {
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height - 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Loading(
                title: 'Publishing event',
                icon: (Icons.event),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: AnimatedTextKit(
                          animatedTexts: [
                            _animatedText(
                              'Your event dashboard allows you to manage your event activities.',
                            ),
                            _animatedText(
                              'You can send invitations to people to attend this event.',
                            ),
                            _animatedText(
                              'Scan attendee tickets for validation.',
                            ),
                            _animatedText(
                              'Event room fosters networking and interaction among attendees of a specific event.',
                            ),
                            _animatedText(
                              'Daily reminders to attendees to ensure that they don\'t forget about the events.',
                            ),
                          ],
                          repeatForever: true,
                          pause: const Duration(seconds: 2),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true),
                    )),
              )
            ],
          )),
    );
  }

  _popButton() {
    var _provider = Provider.of<UserData>(
      context,
    );
    return _isLoading
        ? SizedBox.shrink()
        : IconButton(
            icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Colors.white),
            onPressed: widget.isCompleted
                ? () {
                    _pop();
                  }
                : widget.isEditting
                    ? () {
                        widget.event!.isFree && _pageController.page == 2
                            ? _pop()
                            : _pageController.page == 1
                                ? _pop()
                                : animateToBack(1);
                      }
                    : () {
                        _provider.int1 == 0 ? _pop() : animateToBack(1);
                      });
  }

  _completed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShakeTransition(
          duration: const Duration(seconds: 2),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: ResponsiveHelper.responsiveHeight(context, 50.0),
          ),
        ),
        SizedBox(height: ResponsiveHelper.responsiveHeight(context, 10.0)),
        Text(
          'Completed',
          style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Text(
            'Congratulations on completing ${widget.event!.title}. We are thrilled that you have reached this milestone. Completing such an event is no easy feat, and we commend your dedication. We wish you the best for your upcoming events. Please note that completed events cannot be modified further. If you choose to, you have the option to delete the event. ',
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14)),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: ResponsiveHelper.responsiveHeight(context, 30.0)),
        _deleteWidget(),
      ],
    );
  }

  // Main event section
  @override
  bool get wantKeepAlive => true;
  _eventSection() {
    var _provider = Provider.of<UserData>(
      context,
    );

    void _createEventDoc(
      BuildContext context,
    ) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return CreateWorkRequestDoc(
            fromWelcome: false,
          );
        },
      );
    }

    return Stack(
      alignment: FractionalOffset.center,
      children: [
        DisplayCreateImage(
          isEvent: true,
        ),
        widget.isCompleted
            ? _completed()
            : _provider.eventImage == null && !widget.isEditting
                ? CreateSelectImageWidget(
                    onPressed: () {
                      _createEventDoc(context);
                    },
                    isEditting: widget.isEditting,
                    feature: 'Punch',
                    selectImageInfo:
                        '\nSelect a background image for your event. The image selected should not contain any text and should be of good pixel quality. The image selected should align with the context of your event. The right image can significantly enhance the atmosphere and engagement of your event. ',
                    featureInfo: '',
                    isEvent: true,
                  )
                : SafeArea(
                    child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (int index) {
                          _provider.setInt1(index);
                        },
                        children: [
                          //setting section (private, virtual, etc)
                          _eventSettingSection(),

                          //select category, festiva, albums, etc.
                          _eventCategorySection(),

                          //pick date for event
                          _eventPickDateSection(),

                          //pick time for event
                          _eventPickTimeScheduleSection(),

                          //rate section (feee)
                          _eventRateSection(),

                          // //select clossing date and page for start editting.
                          // _eventClossingDateStartEditing(),

                          //event section for picking address and venue.
                          _eventAdressSection(),

                          //event people performing and appearing
                          _eventPeopleSection(false),

                          //event sponsors and partners
                          _eventPeopleSection(true),

                          //event main information(title, theme, etc.)
                          _eventMainInformation(),

                          //event optional additional
                          _eventOrganizerContacts(),

                          //event optional additional
                          _eventPreviousEvent(),

                          //event terms and conditions
                          _eventTermsAndConditions(),

                          //loading --- creating event
                          _loadingWidget(),
                        ]),
                  ),
        Positioned(top: 50, left: 10, child: _popButton()),
        if (_provider.eventImage != null &&
            !widget.isEditting &&
            _provider.int1 == 0 &&
            !_provider.isLoading)
          Positioned(
            top: 70,
            right: 30,
            child: Container(
                width: ResponsiveHelper.responsiveHeight(context, 40.0),
                height: ResponsiveHelper.responsiveHeight(context, 40.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    )),
                child: IconButton(
                  icon: Icon(
                    MdiIcons.image,
                    color: Colors.white,
                    size: ResponsiveHelper.responsiveHeight(context, 20.0),
                  ),
                  onPressed: () async {
                    ImageSafetyHandler imageSafetyHandler =
                        ImageSafetyHandler();
                    await imageSafetyHandler.handleImage(context);
                  },
                )),
          ),
        if (_provider.isLoading)
          Positioned(
            top: 100,
            child: SizedBox(
              height: ResponsiveHelper.responsiveHeight(context, 2.0),
              width: ResponsiveHelper.responsiveWidth(context, 400),
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            ),
          ),
      ],
    );
  }

  _pop() {
    var provider = Provider.of<UserData>(context, listen: false);

    widget.isEditting ? _setNull(provider) : Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // var _provider = Provider.of<UserData>(context, listen: false);
    // final width = Responsive.isDesktop(context)
    //     ? 600.0
    //     : MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: _eventSection()),
    );

    // _eventSection();
  }
}
