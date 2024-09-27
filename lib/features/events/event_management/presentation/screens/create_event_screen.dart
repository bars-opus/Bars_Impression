import 'package:bars/utilities/exports.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/scheduler.dart';

class CreateEventScreen extends StatefulWidget {
  final bool isEditting;
  final Post? post;
  // final String
  // final bool isCompleted;
  // final bool isDraft;

  static final id = 'Create_event';

  CreateEventScreen({
    required this.isEditting,
    required this.post,
    // required this.isCompleted,
    // required this.isDraft,
  });

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Future<QuerySnapshot>? _users;
  int index = 0;
  // int showDatePicker = 0;
  // int showTimePicker = 0;
  // int eventTypeIndex = 0;
  // int showEventTypePicker = 0;
  late PageController _pageController;
  // DateTime _scheduleStartTime = DateTime.now();
  // DateTime _scheduleEndTime = DateTime.now();
  // DateTime minTime = DateTime.now().subtract(Duration(minutes: 1));
  // DateTime dayTime = DateTime.now();
  // String selectedValue = '';
  // String selectedSponsorOrPartnerValue = '';
  // String _selectedRole = '';
  // String _taggedType = '';
  // String _selectedNameToAdd = '';
  // String _selectedNameToAddProfileImageUrl = '';
  // String _taggedUserExternalLink = '';
  // String selectedclosingDay = '';
  // String _type = '';
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  bool _isLoading = false;
  final _contactsFormKey = GlobalKey<FormState>();
  // final _addPersonFormKey = GlobalKey<FormState>();
  // final _addPreviousVideoFormkey = GlobalKey<FormState>();
  // final _ticketSiteFormkey = GlobalKey<FormState>();

// Text editing controllers
//   final _addressSearchController = TextEditingController();
//   final _ticketTypeController = TextEditingController();
//   final _tagNameController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _schedulePerfomerController = TextEditingController();
//   final _contactController = TextEditingController();
//   final _groupController = TextEditingController();
//   final _accessLevelController = TextEditingController();
//   final _maxOrderController = TextEditingController();
//   final _rowController = TextEditingController();
//   final _maxSeatPerRowController = TextEditingController();
//   final _cancellationRasonController = TextEditingController();
  // final _debouncer = Debouncer(milliseconds: 500);
  // final _googleGenerativeAIService = GoogleGenerativeAIService();

// Focus nodes
  // final FocusNode _addressSearchfocusNode = FocusNode();
  // final FocusNode _nameSearchfocusNode = FocusNode();
  // final musicVideoLink =
  //     RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

  @override
  void initState() {
    super.initState();
    // selectedValue = _type.isEmpty ? values.last : _type;
    _pageController = PageController(
      initialPage: 0,
    );
    // _priceController.addListener(_onAskTextChanged);
    // _cancellationRasonController.addListener(_onAskTextChanged);
    // selectedValue = widget.event != null ? widget.event!.type : '';
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var _provider = Provider.of<UserData>(context, listen: false);
      _provider.setIsStartDateSelected(false);
      _provider.setIsEndDateSelected(false);
      _provider.setIsStartTimeSelected(false);
      _provider.setIsEndTimeSelected(false);
      _provider.setCurrency('');
      _provider.setInt1(
        0,
      );
      // if (!widget.isEditting) EventDatabase.setNull(_provider, false, context);
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
    'Salon',
    'Actor/actresse',
    'Barbershop',
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
    // _priceController.dispose();
    // _addressSearchController.dispose();
    // _tagNameController.dispose();
    // _ticketTypeController.dispose();
    // _contactController.dispose();
    // _schedulePerfomerController.dispose();
    // _groupController.dispose();
    // _accessLevelController.dispose();
    // _maxOrderController.dispose();
    // _rowController.dispose();
    // _maxSeatPerRowController.dispose();
    // _cancellationRasonController.dispose();
    _pageController.dispose();
    // _addressSearchfocusNode.dispose();
    // _nameSearchfocusNode.dispose();
    _isTypingNotifier.dispose();
    // _debouncer.cancel();
    super.dispose();
  }

  // void _onAskTextChanged() {
  //   if (_priceController.text.isNotEmpty ||
  //       _cancellationRasonController.text.isNotEmpty) {
  //     _isTypingNotifier.value = true;
  //   } else {
  //     _isTypingNotifier.value = false;
  //   }
  // }

  void _showBottomSheetErrorMessage(String e) {
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
          subTitle: 'Check your internet connection and try again.',
        );
      },
    );
  }

  // void _navigateToPage(BuildContext context, Widget page) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (_) => page),
  //   );
  // }

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
            buttonText: 'Delete post',
            onPressed: widget.post == null
                ? () {
                    mySnackBar(context, 'post not found');
                  }
                : () async {
                    try {
                      _showBottomSheetLoading();
                      // await DatabaseService.deleteEvent(
                      //     widget.event!,
                      //     _cancellationRasonController.text.trim(),
                      //     widget.isCompleted);
                      await EventDatabase.setNull(_provider, true, context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      mySnackBar(context, 'Post deleted succesfully');
                    } catch (e) {
                      Navigator.pop(context);
                      _showBottomSheetErrorMessage('Error deleting post ');
                    }
                  },
            title: 'Are you sure you want to Delete this post?',
            subTitle: "All data associated with this [pst] would be deleted.");
      },
    );
  }

  // Widget _showBottomDeleteForm() {
  //   return ValueListenableBuilder(
  //     valueListenable: _isTypingNotifier,
  //     builder: (BuildContext context, bool isTyping, Widget? child) {
  //       return AlertDialog(
  //         surfaceTintColor: Colors.transparent,
  //         backgroundColor: Theme.of(context).primaryColorLight,
  //         title: Text(
  //           'Add reason',
  //           style: Theme.of(context).textTheme.titleSmall,
  //         ),
  //         content: Container(
  //           width: ResponsiveHelper.responsiveHeight(context, 600),
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).primaryColorLight,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: Scaffold(
  //             backgroundColor: Colors.transparent,
  //             body: Padding(
  //               padding: EdgeInsets.all(10),
  //               child: ListView(children: [
  //                 _cancellationRasonController.text.isNotEmpty
  //                     ? Align(
  //                         alignment: Alignment.centerRight,
  //                         child: MiniCircularProgressButton(
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                             _showBottomSheetConfirmDeleteEvent();
  //                           },
  //                           text: "Continue",
  //                           color: Colors.blue,
  //                         ),
  //                       )
  //                     : const SizedBox(height: 50),
  //                 _ticketFiled(
  //                   true,
  //                   true,
  //                   'Reason',
  //                   'Please provide the reason for your event cancellation',
  //                   _cancellationRasonController,
  //                   TextInputType.multiline,
  //                   (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please reason for your event cancellation';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 const SizedBox(height: 20),
  //               ]),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

// Radio buttons to select the event vategory
//   static const values = <String>[
//     "Parties",
//     "Music_concerts",
//     "Festivals",
//     "Club_nights",
//     "Pub_events",
//     "Games/Sports",
//     "Religious",
//     "Business",
//     "Others",
//   ];

//   Widget buildRadios() => Column(
//           children: values.map((value) {
//         var _provider = Provider.of<UserData>(context, listen: false);
//         final selected = this.selectedValue == value;
//         final color =
//             selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;
//         return RadioTheme(
//           data: RadioThemeData(
//               fillColor: MaterialStateProperty.all(
//             Theme.of(context).secondaryHeaderColor,
//           )),
//           child: RadioListTile<String>(
//               value: value,
//               groupValue: selectedValue,
//               title: Text(
//                 value,
//                 style: TextStyle(
//                   color: color,
//                   fontWeight: FontWeight.normal,
//                   fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
//                 ),
//               ),
//               activeColor: Colors.blue,
//               onChanged: (value) {
//                 _provider.setCategory(this.selectedValue = value!);
//                 value.startsWith('Others') ? () {} : animateToPage(1);

//                 if (widget.event == null || widget.isDraft)
//                   EventDatabaseDraft.submitEditDraftTypeAndDate(
//                     context,
//                     _isLoading,
//                     widget.event,
//                     widget.isDraft,
//                   );
//               }),
//         );
//       }).toList());

// //Radion button for tagged sponsors and partners
//   static const SponserOrPartner = <String>[
//     "Sponsor",
//     "Partner",
//   ];

//   Widget buildSponserOrPartnerRadios() => Theme(
//         data: Theme.of(context).copyWith(
//           unselectedWidgetColor: Colors.white,
//         ),
//         child: Column(
//             children: SponserOrPartner.map((value) {
//           final selected = this.selectedSponsorOrPartnerValue == value;
//           final color = selected ? Colors.blue : Colors.white;
//           return RadioTheme(
//             data: RadioThemeData(
//                 fillColor: MaterialStateProperty.all(Colors.white)),
//             child: RadioListTile<String>(
//                 value: value,
//                 groupValue: selectedSponsorOrPartnerValue,
//                 title: Text(
//                   value,
//                   style: TextStyle(
//                     color: color,
//                     fontSize:
//                         ResponsiveHelper.responsiveFontSize(context, 14.0),
//                   ),
//                 ),
//                 activeColor: Colors.blue,
//                 onChanged: (value) {
//                   if (mounted) {
//                     setState(() {
//                       _selectedRole =
//                           this.selectedSponsorOrPartnerValue = value!;
//                       _taggedType = _selectedRole;
//                     });
//                   }
//                 }),
//           );
//         }).toList()),
//       );

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
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  // _validate() {
  //   animateToPage(1);
  // }

//event process number
  _eventProcessNumber(
    // String processNumber,
    String processTitle,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 80,
        width: ResponsiveHelper.responsiveFontSize(context, 230),
        child: Text(
          processTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
          ),
        ),
      ),
    );
  }

  _button(
    icon,
    onPressed,
  ) {
    return BottomModelSheetIconActionWidget(
      minor: false,
      dontPop: true,
      buttoncolor: Colors.white,
      textcolor: Colors.black,
      icon: icon,
      onPressed: onPressed,
      text: '',
    );
  }

  _button2(
    text,
    onPressed,
  ) {
    return BottomModelSheetIconActionWidget(
      minor: true,
      dontPop: true,
      buttoncolor: Colors.white,
      textcolor: Colors.black,
      icon: Icons.edit,
      onPressed: onPressed,
      text: text,
    );
  }

  _buttonRow(
    IconData icon1,
    VoidCallback onPressed1,
    IconData icon2,
    VoidCallback onPressed2,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _button(icon1, onPressed1),
        Container(
          width: 1,
          height: 50,
          color: Colors.grey,
        ),
        _button(icon2, onPressed2)
      ],
    );
  }

  // _buttonImageAndDeleteButton(
  //   IconData icon1,
  //   VoidCallback onPressed1,
  //   IconData icon2,
  //   VoidCallback onPressed2,
  // ) {
  //   UserData _provider = Provider.of<UserData>(context, listen: false);
  //   return Container(
  //       margin: const EdgeInsets.only(
  //         top: 20,
  //         bottom: 5,
  //       ),
  //       padding: const EdgeInsets.symmetric(
  //         vertical: 10,
  //       ),
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //           color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //       child: _provider.isLoading || _provider.isLoading2
  //           ? Center(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   _provider.isLoading2
  //                       ? 'Processing image'
  //                       : 'Saving to draft. Please wait...',
  //                   style: TextStyle(
  //                     color: Colors.blue,
  //                     fontSize:
  //                         ResponsiveHelper.responsiveFontSize(context, 12),
  //                   ),
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //             )
  //           : widget.isEditting
  //               ? (widget.isDraft
  //                   ? _buttonRow(icon1, onPressed1, icon2, onPressed2)
  //                   : _button(icon2, onPressed2))
  //               : _button(icon1, onPressed1));
  // }

  // _finalButtons(String text1, VoidCallback onPressed1, String text2,
  //     VoidCallback onPressed2, bool show1) {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //     child: !show1
  //         ? Row(
  //             children: [
  //               _button2(text1, onPressed1),
  //               // if (!show1)
  //               Container(
  //                 width: 1,
  //                 height: 50,
  //                 color: Colors.grey,
  //               ),
  //               // if (!show1)

  //               _button2(text2, onPressed2),
  //             ],
  //           )
  //         : _button2(text1, onPressed1),
  //   );
  // }

  // _deleteEventOrDraft() {
  //   // if (widget.event == null || widget.isDraft)
  //   widget.isDraft
  //       ? _showBottomSheetConfirmDeleteEvent()
  //       : widget.isCompleted
  //           ? _showBottomSheetConfirmDeleteEvent()
  //           : showDialog(
  //               context: context,
  //               builder: (BuildContext context) {
  //                 return _showBottomDeleteForm();
  //               },
  //             );
  //   ;
  // }

  // Widget _eventSettingSection() {
  //   UserData _provider = Provider.of<UserData>(context, listen: false);

  //   return _pageWidget(
  //     noPadding: true,
  //     newWidget: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             _eventProcessNumber('Event\nsettings.'),
  //             if (!_provider.isLoading)
  //               MiniCircularProgressButton(
  //                   onPressed: () async {
  //                     animateToPage(1);
  //                     // if (widget.event == null || widget.isDraft)
  //                     //   await EventDatabaseDraft.submitDraft(
  //                     //       context,
  //                     //       _isLoading,
  //                     //       widget.event,
  //                     //       widget.isDraft,
  //                     //       _pageController);
  //                   },
  //                   text: "Next")
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         _buttonImageAndDeleteButton(
  //           Icons.image_outlined,
  //           () async {
  //             ImageSafetyHandler imageSafetyHandler = ImageSafetyHandler();
  //             await imageSafetyHandler.handleImage(context);
  //           },
  //           Icons.delete_outline,
  //           _deleteEventOrDraft,
  //         ),
  //         Container(
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).primaryColorLight,
  //               borderRadius: BorderRadius.circular(10)),
  //           padding: const EdgeInsets.only(left: 20.0, right: 10),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: _buildSettingOptions(_provider),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _showCurrencyPicker() {
  //   UserData _provider = Provider.of<UserData>(context, listen: false);
  //   showCurrencyPicker(
  //     theme: CurrencyPickerThemeData(
  //       backgroundColor: Theme.of(context).primaryColorLight,
  //       flagSize: 25,
  //       titleTextStyle: TextStyle(
  //         fontSize: ResponsiveHelper.responsiveFontSize(context, 17.0),
  //       ),
  //       subtitleTextStyle: TextStyle(
  //           fontSize: ResponsiveHelper.responsiveFontSize(context, 15.0),
  //           color: Colors.blue),
  //       bottomSheetHeight: MediaQuery.of(context).size.height / 1.2,
  //     ),
  //     context: context,
  //     showFlag: true,
  //     showSearchField: true,
  //     showCurrencyName: true,
  //     showCurrencyCode: true,
  //     onSelect: (Currency currency) {
  //       _provider.setCurrency('${currency.name} | ${currency.code}');
  //       !_provider.isFree && currency.code != 'GHS' && !_provider.isCashPayment
  //           ? showDialog(
  //               context: context,
  //               builder: (context) {
  //                 return AlertDialog(
  //                   surfaceTintColor: Colors.transparent,
  //                   backgroundColor: Theme.of(context).primaryColor,
  //                   content: SingleChildScrollView(
  //                     child: Column(
  //                       children: [
  //                         TicketPurchasingIcon(
  //                           title: '',
  //                         ),
  //                         Align(
  //                           alignment: Alignment.centerRight,
  //                           child: MiniCircularProgressButton(
  //                               onPressed: () {
  //                                 Navigator.pop(context);
  //                                 animateToPage(1);
  //                               },
  //                               text: "Next"),
  //                         ),
  //                         const SizedBox(height: 20),
  //                         RichText(
  //                           textScaler: MediaQuery.of(context).textScaler,
  //                           text: TextSpan(
  //                             children: [
  //                               TextSpan(
  //                                 text: 'Event Organizers Outside of Ghana',
  //                                 style:
  //                                     Theme.of(context).textTheme.titleMedium,
  //                               ),
  //                               TextSpan(
  //                                 text:
  //                                     "\n\nDue to the current limitations of payment processing in different currencies, we regret to inform event organizers outside of Ghana that we can only handle ticket purchases within Ghana at this time. We understand the importance of expanding our services to other countries and are actively working on implementing the necessary facilities to accommodate international transactions. \n\nIn the meantime, we recommend that event organizers outside of Ghana provide an alternative ticket handling solution, such as providing a link to their own website for ticket sales or accepting cash payments on-site. We apologize for any inconvenience caused and appreciate your understanding as we strive to enhance our services to better serve you in the future.",
  //                                 style: Theme.of(context).textTheme.bodyMedium,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               },
  //             )
  //           : animateToPage(1);
  //       if (widget.event == null || widget.isDraft)
  //         EventDatabaseDraft.submitEditDraftScheduleAndDate(
  //           context,
  //           _isLoading,
  //           widget.event,
  //           widget.isDraft,
  //         );
  //     },
  //     favorite: _provider.userLocationPreference!.country == 'Ghana'
  //         ? ['GHS']
  //         : ['USD'],
  //   );
  // }

  void _showBottomSheetSettingsLearnMore(
    String title,
    String subTitle,
    String body,
  ) {
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
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  const SizedBox(height: 40),
                  RichText(
                    textScaler: MediaQuery.of(context).textScaler,
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
                  if (title == 'Affiliate enabled')
                    GestureDetector(
                      onTap: () {
                        _showBottomSheetAffiliateDoc();
                      },
                      child: Text(
                        "Read more",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14)),
                      ),
                    ),
                  const SizedBox(height: 60),
                ],
              ),
            ));
      },
    );
  }

  void _showBottomSheetAffiliateDoc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: AffiliateDoc(
                isAffiliated: false,
                isOganiser: true,
                affiliateOnPressed: () {},
              ));
        });
      },
    );
  }

  _buildSettingOptions(UserData _provider) {
    List<Widget> options = [];
    options.add(const SizedBox(height: 30));

    if (!_provider.isCashPayment && !_provider.isExternalTicketPayment) {
      options.add(_buildSettingSwitchWithDivider(
        'Free event',
        _provider.isFree
            ? 'This is a free event with no ticket or gate fee.(Change back to paid)'
            : 'This is a paid event with a ticket or gate fee. (Change to free)',
        '',
        _provider.isFree,
        _provider.setIsFree,
      ));
    }
    if (!_provider.isFree && !_provider.isCashPayment) {
      options.add(_buildSettingSwitchWithDivider(
        'External ticketing only (website)',
        _provider.isExternalTicketPayment
            ? 'The payment and ticketing functionality for this event will only be handled through an external website provided by the event organizers.'
            : 'Ticket payment and generating would be handle using Bars Impression.',
        'You can choose either an in-app ticketing system or an external ticketing platform, but not both at the same time.\n\nIn-App Ticketing:\nIf you choose the in-app ticketing system, the ticket payment and generation will be handled using Bars Impression. In addition, the following tools will be available to help manage the event:\n* Ticket Scanner - to validate event tickets\n*  Event Rooms - which facilitate networking\n*  Reminders - to be sent to attendees to keep them on track\n*  Invitations - to send to special attendees\n* Affiliate Management - to create and manage affiliates to promote your events\n\nExternal Ticketing:\nAlternatively, the payment and ticketing for this event will be handled through an external website provided by the event organizers. This external website will be responsible for all aspects of the ticketing process, including:\n*  Ticket Purchase: Attendees will be able to purchase tickets directly through the organizer\'s website. This will involve the payment processing, order confirmation, and ticket generation.\n*  Ticket Generation: The external website will be responsible for generating the actual event tickets, which may include features like unique ticket IDs, QR codes, and other security measures.\n* Ticket Validation: When attendees arrive at the event, their tickets will need to be validated. This validation process will also be managed through the organizer\'s external website, ensuring a seamless entry experience.\n\nNote that if you choose the external ticketing option, the event rooms, reminders, invitations, and affiliate management features would not be available.',
        _provider.isExternalTicketPayment,
        _provider.setIsExternalTicketPayment,
      ));
    }

    if (!_provider.isFree && !_provider.isExternalTicketPayment) {
      options.add(_buildSettingSwitchWithDivider(
        'Cash payment only',
        _provider.isCashPayment
            ? 'Only cash is accepted as a payment method for tickets or gate fees'
            : 'Card and mobile money as a payment method for tickets or gate fees',
        'You can choose either online payment or cash payment, but not both at the same time\n\nOnline Payment:\nWhen you select the online payment option, the payment process is handled by the system.\nAfter the online payment is successful, the tickets are generated.\n\nCash Payment:\nWhen you select the cash payment option, the system generates free tickets for attendees. \nThe cash payment will be made at the event gate when the users show the generated ticket on the app.',
        _provider.isCashPayment,
        _provider.setIsCashPayment,
      ));
    }
    options.add(_buildSettingSwitchWithDivider(
      'Private event',
      _provider.isPrivate
          ? 'You are creating a private event, it means the event is exclusive and only accessible to a selected group of people, rather than being open to the general public. (Change back to public)'
          : 'You are creating a public (general) event where anybody can attend.(Change to private)',
      'When creating a private event, you have the option to send invitations only to specific individuals who are intended to attend. This means that the event is not open to the general public, and access is restricted to those who have received and accepted an invitation. \n\nExample: Weddings, Birthday celebrations, Graduation ceremonies, Exclusive fundraising events for high-net-worth individuals, Employee training sessions, Executive retreats, Product launch events for select customers or partners',
      _provider.isPrivate,
      _provider.setIsPrivate,
    ));

    if (_provider.isPrivate) {
      options.add(_buildSettingSwitchWithDivider(
        'Show to followers',
        _provider.showToFollowers
            ? 'Exclusive event where access is granted to both invited attendees and followers.'
            : 'Your followers cannot see this private event. This means only the people you send invites to can attend.',
        '',
        _provider.showToFollowers,
        _provider.setshowToFollowers,
      ));
    }
    return options;
  }

  Widget _buildSettingSwitchWithDivider(
    String title,
    String subTitle,
    String body,
    bool value,
    Function onChanged,
  ) {
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
              _showBottomSheetSettingsLearnMore(
                title,
                subTitle,
                body,
              );
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

// //event categories: festivals, etc
//   Widget _eventCategorySection() {
//     UserData _provider = Provider.of<UserData>(context, listen: false);
//     final bool isOtherCategory = _provider.category.startsWith('Others');
//     return _pageWidget(
//       newWidget: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildEventProcessRow(_provider, isOtherCategory),
//           DirectionWidgetWhite(
//             text:
//                 'Select an event category that matches the event you are creating. ',
//           ),
//           if (widget.isEditting && !widget.isDraft)
//             Container(
//               margin: const EdgeInsets.only(bottom: 5),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(10)),
//               child: _button(Icons.delete_outline, _deleteEventOrDraft),
//             ),
//           isOtherCategory
//               ? _buildContentFieldWhite(_provider)
//               : Container(
//                   decoration: BoxDecoration(
//                       color: Theme.of(context).primaryColorLight,
//                       borderRadius: BorderRadius.circular(10)),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
//                   child: buildRadios()),
//         ],
//       ),
//     );
//   }

  // Widget _buildEventProcessRow(UserData _provider, bool isOtherCategory) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       _eventProcessNumber(
  //         '2. ',
  //         'Category.',
  //       ),
  //       if (_provider.category.isNotEmpty)
  //         (!isOtherCategory || _provider.subCategory.isNotEmpty)
  //             ? MiniCircularProgressButton(
  //                 onPressed: () {
  //                   if (isOtherCategory) FocusScope.of(context).unfocus();
  //                   animateToPage(1);

  //                   if (widget.event == null || widget.isDraft)
  //                     EventDatabaseDraft.submitEditDraftTypeAndDate(
  //                       context,
  //                       _isLoading,
  //                       widget.event,
  //                       widget.isDraft,
  //                     );
  //                 },
  //                 text: "Next")
  //             : SizedBox.shrink(),
  //     ],
  //   );
  // }

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

  // _cancelSearch() {
  //   FocusScope.of(context).unfocus();
  //   _clearSearch();
  //   Navigator.pop(context);
  // }

  // _clearSearch() {
  //   WidgetsBinding.instance
  //       .addPostFrameCallback((_) => _addressSearchController.clear());
  //   Provider.of<UserData>(context, listen: false).addressSearchResults = [];
  // }

  // void _showBottomVenue(String from) {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     isDismissible: false,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return GestureDetector(
  //         onTap: () => FocusScope.of(context).unfocus(),
  //         child: Container(
  //           height: ResponsiveHelper.responsiveHeight(context, 750),
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).primaryColorLight,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: ListView(
  //             children: [
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                 child: SearchContentField(
  //                     showCancelButton: true,
  //                     cancelSearch: _cancelSearch,
  //                     controller: _addressSearchController,
  //                     focusNode: _addressSearchfocusNode,
  //                     hintText: 'Type to search...',
  //                     onClearText: () {
  //                       _clearSearch();
  //                     },
  //                     onTap: () {},
  //                     onChanged: (value) {
  //                       if (value.trim().isNotEmpty) {
  //                         _debouncer.run(() {
  //                           _provider.searchAddress(value);
  //                         });
  //                       }
  //                     }),
  //               ),
  //               Text(
  //                 '        Select your address from the list below',
  //                 style: TextStyle(
  //                   fontSize:
  //                       ResponsiveHelper.responsiveFontSize(context, 14.0),
  //                 ),
  //               ),
  //               if (Provider.of<UserData>(
  //                     context,
  //                   ).addressSearchResults !=
  //                   null)
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 10.0),
  //                   child: SingleChildScrollView(
  //                     child: Column(
  //                       children: [
  //                         Container(
  //                           height: MediaQuery.of(context).size.height,
  //                           width: double.infinity,
  //                           child: ListView.builder(
  //                             itemCount: _provider.addressSearchResults!.length,
  //                             itemBuilder: (context, index) {
  //                               return Column(
  //                                 children: [
  //                                   ListTile(
  //                                       title: Text(
  //                                         _provider.addressSearchResults![index]
  //                                             .description,
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .bodyLarge,
  //                                       ),
  //                                       onTap: () {
  //                                         Navigator.pop(context);
  //                                         _provider.setCity('');
  //                                         _provider.setCountry('');
  //                                         _provider.setAddress(_provider
  //                                             .addressSearchResults![index]
  //                                             .description);
  //                                         // print(_provider
  //                                         //     .addressSearchResults![index]
  //                                         //     .description);

  //                                         reverseGeocoding(
  //                                             _provider,
  //                                             _provider
  //                                                 .addressSearchResults![index]
  //                                                 .description);
  //                                       }),
  //                                   Divider(
  //                                     thickness: .3,
  //                                   ),
  //                                 ],
  //                               );
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // _ticketFiled(
  //   bool isTicket,
  //   bool autofocus,
  //   String labelText,
  //   String hintText,
  //   TextEditingController controler,
  //   TextInputType textInputType,
  //   final Function onValidateText,
  // ) {
  //   var style = isTicket
  //       ? Theme.of(context).textTheme.titleSmall
  //       : TextStyle(
  //           fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
  //           color: labelText == 'Contact'
  //               ? Theme.of(context).secondaryHeaderColor
  //               : Colors.black,
  //         );
  //   var labelStyle = TextStyle(
  //       fontSize:
  //           ResponsiveHelper.responsiveFontSize(context, isTicket ? 16.0 : 14),
  //       color: isTicket ? Colors.blue : Colors.black);
  //   var hintStyle = TextStyle(
  //       fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
  //       fontWeight: FontWeight.normal,
  //       color: Colors.grey);
  //   return TextFormField(
  //     autofocus: autofocus,
  //     cursorColor: Colors.blue,
  //     controller: controler,
  //     maxLines: null,
  //     keyboardAppearance: MediaQuery.of(context).platformBrightness,
  //     style: style,
  //     keyboardType: textInputType,
  //     decoration: InputDecoration(
  //       labelText: isTicket ? labelText : null,
  //       hintText: hintText,
  //       labelStyle: isTicket ? labelStyle : null,
  //       hintStyle: hintStyle,
  //       focusedBorder: UnderlineInputBorder(
  //         borderSide: BorderSide(
  //           color: Colors.blue,
  //         ),
  //       ),
  //     ),
  //     validator: (string) => onValidateText(string),
  //   );
  // }

// // event rate or ticket price
//   _buildTicketDialog() {
//     return showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context) {
//           var _provider = Provider.of<UserData>(
//             context,
//           );
//           return GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//             },
//             child: Container(
//               height: ResponsiveHelper.responsiveHeight(context, 700),
//               decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(30)),
//               padding: const EdgeInsets.all(12),
//               child: Scaffold(
//                 backgroundColor: Colors.transparent,
//                 body: ListView(
//                   children: [
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     TicketPurchasingIcon(
//                       title: '',
//                     ),
//                     _priceController.text.isEmpty && !_provider.isFree
//                         ? SizedBox.shrink()
//                         : Align(
//                             alignment: Alignment.centerRight,
//                             child: MiniCircularProgressButton(
//                               color: Colors.blue,
//                               text: 'Add',
//                               onPressed: () {
//                                 EventDatabaseEventData.addTicket(
//                                   accessLevelController: _accessLevelController,
//                                   context: context,
//                                   ticketTypeController: _ticketTypeController,
//                                   priceController: _priceController,
//                                   groupController: _groupController,
//                                   maxSeatPerRowController:
//                                       _maxSeatPerRowController,
//                                   maxOrderController: _maxOrderController,
//                                 );
//                                 // _addTicket();
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     if (_provider.isFree)
//                       Text(
//                           'Since this ticket is free, the price will automatically be set to 0. You do not need to add a price. However, you may provide the necessary information below.".',
//                           style: Theme.of(context).textTheme.bodyMedium),
//                     if (!_provider.isFree)
//                       Container(
//                           child: Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: _ticketFiled(
//                                 true,
//                                 true,
//                                 'Ticket Price',
//                                 'eg. 10.0',
//                                 _priceController,
//                                 TextInputType.numberWithOptions(decimal: true),
//                                 (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter a price for the ticket';
//                                   }
//                                   final price = double.tryParse(value);
//                                   if (price == null || price <= 0.0) {
//                                     return 'Please enter a valid price for the ticket';
//                                   }
//                                   return null;
//                                 },
//                               ))),
//                     const SizedBox(height: 30),
//                     Text(
//                       'Optional',
//                       style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: ResponsiveHelper.responsiveFontSize(
//                               context, 14.0),
//                           fontWeight: FontWeight.normal),
//                     ),
//                     const SizedBox(height: 5),
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                           color: Theme.of(context).primaryColorLight,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Column(
//                         children: [
//                           _ticketFiled(
//                             true,
//                             false,
//                             'Ticket Group, ',
//                             'Family tickets, Couple tickets,',
//                             _groupController,
//                             TextInputType.text,
//                             () {},
//                           ),
//                           _ticketFiled(
//                             true,
//                             false,
//                             'Ticket type',
//                             'eg. Regular, Vip, VVip',
//                             _ticketTypeController,
//                             TextInputType.text,
//                             (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter a type for the ticket';
//                               }
//                               return null;
//                             },
//                           ),
//                           _ticketFiled(
//                             true,
//                             false,
//                             'Ticket benefits',
//                             'Access level, Meet & greet, free food',
//                             _accessLevelController,
//                             TextInputType.multiline,
//                             () {},
//                           ),
//                           _ticketFiled(
//                             true,
//                             false,
//                             'Ticket max order',
//                             'Maximu ticket order',
//                             _maxOrderController,
//                             TextInputType.number,
//                             () {},
//                           ),
//                           const SizedBox(height: 10),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                         'The ticket maximum order (max order) refers to the maximum number of tickets that can be sold for a particular ticket type. It allows to monitor if a ticket has reached its capacity (sold out) or is still available for purchase. ',
//                         style: Theme.of(context).textTheme.bodySmall),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

  //Time schedule
  // List<DateTime> getDatesInRange(DateTime startDate, DateTime endDate) {
  //   List<DateTime> dates = [];
  //   for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
  //     dates.add(startDate.add(Duration(days: i)));
  //   }
  //   return dates;
  // }

  // _dateRange() {
  //   UserData _provider = Provider.of<UserData>(
  //     context,
  //   );
  //   final width = MediaQuery.of(context).size.width;
  //   List<DateTime> dateList = getDatesInRange(
  //       _provider.startDate.toDate(), _provider.clossingDay.toDate());
  //   return Container(
  //       height: ResponsiveHelper.responsiveHeight(
  //           context,
  //           dateList.length == 1
  //               ? 60
  //               : dateList.length == 3
  //                   ? 190
  //                   : 120),
  //       width: ResponsiveHelper.responsiveWidth(context, width),
  //       child: GridView.builder(
  //         scrollDirection: Axis.horizontal,
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: dateList.length == 1
  //               ? 1
  //               : dateList.length == 3
  //                   ? 3
  //                   : 2, // Items down the screen
  //           mainAxisSpacing: .7,
  //           crossAxisSpacing: .7,
  //           childAspectRatio: dateList.length <= 3 ? 0.2 / 1.1 : 0.3,
  //         ),
  //         itemCount: dateList.length,
  //         itemBuilder: (context, index) {
  //           DateTime date = dateList[index];
  //           return Card(
  //             surfaceTintColor: Colors.transparent,
  //             color: Theme.of(context).primaryColor,
  //             // Using Card for better visual separation
  //             child: ListTile(
  //               title: Text(
  //                 MyDateFormat.toDate(date),
  //                 style: Theme.of(context).textTheme.bodySmall,
  //               ),
  //               leading: Radio<DateTime>(
  //                 value: date,
  //                 activeColor: Colors.blue,
  //                 groupValue: _provider.sheduleDateTemp.toDate(),
  //                 onChanged: (DateTime? value) {
  //                   _provider.setSheduleDateTemp(Timestamp.fromDate(value!));
  //                 },
  //               ),
  //             ),
  //           );
  //         },
  //       ));
  // }

  // void _showBottomSheetticketSiteError() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return DisplayErrorHandler(
  //         buttonText: 'Ok',
  //         onPressed: () async {
  //           Navigator.pop(context);
  //         },
  //         title: 'Ticket site not safe. ',
  //         subTitle:
  //             'We have identified potential threats associated with this link. Please enter another link.',
  //       );
  //     },
  //   );
  // }

  // String? validateWebsiteUrl(String? value) {
  //   final pattern =
  //       r'^(https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(:[0-9]{1,5})?(\/.*)?$';
  //   RegExp regex = RegExp(pattern);
  //   if (value == null || value.isEmpty) {
  //     return 'URL cannot be empty';
  //   } else if (!regex.hasMatch(value)) {
  //     return 'Enter a valid URL';
  //   } else {
  //     return null;
  //   }
  // }

  // void _showBottomTicketSite() {
  //   UserData _provider = Provider.of<UserData>(context, listen: false);

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return GestureDetector(
  //           onTap: () => FocusScope.of(context).unfocus(),
  //           child: Container(
  //             height: ResponsiveHelper.responsiveHeight(context, 700),
  //             decoration: BoxDecoration(
  //                 color: Theme.of(context).primaryColorLight,
  //                 borderRadius: BorderRadius.circular(30)),
  //             child: Padding(
  //                 padding:
  //                     const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
  //                 child: Column(
  //                   children: [
  //                     if (Provider.of<UserData>(
  //                       context,
  //                     ).ticketSite.trim().isNotEmpty)
  //                       Align(
  //                         alignment: Alignment.centerRight,
  //                         child: _isLoading
  //                             ? SizedBox(
  //                                 height: ResponsiveHelper.responsiveHeight(
  //                                     context, 10.0),
  //                                 width: ResponsiveHelper.responsiveHeight(
  //                                     context, 10.0),
  //                                 child: CircularProgressIndicator(
  //                                   strokeWidth: 3,
  //                                   color: Colors.blue,
  //                                 ),
  //                               )
  //                             : MiniCircularProgressButton(
  //                                 color: Colors.blue,
  //                                 onPressed: () async {
  //                                   var _provider = Provider.of<UserData>(
  //                                       context,
  //                                       listen: false);
  //                                   setState(() {
  //                                     _isLoading = true;
  //                                   });

  //                                   if (_ticketSiteFormkey.currentState!
  //                                       .validate()) {
  //                                     String urlToCheck = _provider.ticketSite;
  //                                     SafeBrowsingChecker checker =
  //                                         SafeBrowsingChecker();

  //                                     bool isSafe =
  //                                         await checker.isUrlSafe(urlToCheck);
  //                                     if (isSafe) {
  //                                       Navigator.pop(context);
  //                                       animateToPage(1);
  //                                     } else {
  //                                       _showBottomSheetticketSiteError();
  //                                       // mySnackBar(
  //                                       //     context, 'ticket site is not safe');
  //                                     }
  //                                   }
  //                                   setState(() {
  //                                     _isLoading = false;
  //                                   });
  //                                 },
  //                                 text: "Next"),
  //                       ),
  //                     Form(
  //                       key: _ticketSiteFormkey,
  //                       child: ContentFieldBlack(
  //                         onlyBlack: false,
  //                         labelText: "Ticket website",
  //                         hintText:
  //                             'Link to website where ticket pruchase would be handled',
  //                         initialValue: _provider.ticketSite,
  //                         onSavedText: (input) =>
  //                             _provider.setTicketSite(input),
  //                         onValidateText: ValidationUtils.validateWebsiteUrl,
  //                       ),
  //                     ),
  //                   ],
  //                 )),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

// // rate and ticket section
//   Widget _eventRateSection() {
//     UserData _provider = Provider.of<UserData>(context, listen: false);
//     var _userLocation = _provider.userLocationPreference;

//     final List<String> currencyPartition = _provider.currency.isEmpty
//         ? ' Ghana Cedi | GHS'.trim().replaceAll('\n', ' ').split("|")
//         : _provider.currency.trim().replaceAll('\n', ' ').split("|");

//     // Check for the country being Ghana or the currency code being GHS
//     bool isGhanaOrCurrencyGHS = _userLocation!.country == 'Ghana' &&
//         currencyPartition.length > 1 &&
//         currencyPartition[1].trim() == 'GHS';

//     // Check if the subaccount and transfer recipient IDs are empty
//     bool shouldNavigate = _userLocation.subaccountId!.isEmpty ||
//         _userLocation.transferRecepientId!.isEmpty;
//     final width = MediaQuery.of(context).size.width;

//     return _pageWidget(
//       newWidget: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: width * width,
//             width: width,
//             decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(30)),
//             child: ListView(
//               physics: NeverScrollableScrollPhysics(),
//               children: [
//                 if (_provider.currency.isNotEmpty)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _eventProcessNumber(
//                         '5. ',
//                         'Tickets.',
//                       ),
//                       _provider.ticket.isEmpty || _provider.currency.isEmpty
//                           ? SizedBox.shrink()
//                           : _provider.isFree ||
//                                   _provider.isCashPayment ||
//                                   _provider.ticketSite.isNotEmpty
//                               ? MiniCircularProgressButton(
//                                   onPressed: () {
//                                     // _validate();
//                                     animateToPage(1);
//                                     if (widget.event == null || widget.isDraft)
//                                       EventDatabaseDraft
//                                           .submitEditDraftScheduleAndDate(
//                                         context,
//                                         _isLoading,
//                                         widget.event!,
//                                         widget.isDraft,
//                                       );
//                                     // _submitEditDraftScheduleAndDate();
//                                   },
//                                   text: "Next",
//                                 )
//                               : isGhanaOrCurrencyGHS
//                                   ? MiniCircularProgressButton(
//                                       onPressed: isGhanaOrCurrencyGHS &&
//                                               shouldNavigate
//                                           ? () {
//                                               _navigateToPage(
//                                                   context,
//                                                   CreateSubaccountForm(
//                                                     isEditing: false,
//                                                   ));
//                                               if (widget.event == null ||
//                                                   widget.isDraft)
//                                                 EventDatabaseDraft
//                                                     .submitEditDraftScheduleAndDate(
//                                                   context,
//                                                   _isLoading,
//                                                   widget.event!,
//                                                   widget.isDraft,
//                                                 );
//                                             }
//                                           : widget.isEditting
//                                               ? () {
//                                                   _validate();
//                                                   if (widget.event == null ||
//                                                       widget.isDraft)
//                                                     EventDatabaseDraft
//                                                         .submitEditDraftScheduleAndDate(
//                                                       context,
//                                                       _isLoading,
//                                                       widget.event!,
//                                                       widget.isDraft,
//                                                     );
//                                                 }
//                                               : () {
//                                                   _validate();
//                                                   if (widget.event == null ||
//                                                       widget.isDraft)
//                                                     EventDatabaseDraft
//                                                         .submitEditDraftScheduleAndDate(
//                                                       context,
//                                                       _isLoading,
//                                                       widget.event,
//                                                       widget.isDraft,
//                                                     );
//                                                 },
//                                       text: "Next",
//                                     )
//                                   : MiniCircularProgressButton(
//                                       onPressed: widget.isEditting
//                                           ? () {
//                                               _validate();
//                                             }
//                                           : () {
//                                               _showBottomTicketSite();
//                                             },
//                                       text: "Next",
//                                     )
//                     ],
//                   ),
//                 DirectionWidgetWhite(
//                   text:
//                       'Create tickets for your event! Customize them based on your needs and preferences. For instance, you have the option to create VIP tickets with special access levels and exclusive options.',
//                 ),
//                 if (_provider.endDateSelected)
//                   Container(
//                     decoration: BoxDecoration(
//                         color:
//                             Theme.of(context).primaryColorLight.withOpacity(.3),
//                         borderRadius: BorderRadius.circular(10)),
//                     padding: EdgeInsets.all(3),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SelectDateRange(),
//                       ],
//                     ),
//                   ),
//                 if (_provider.endDateSelected) const SizedBox(height: 20.0),
//                 Text(
//                   _provider.currency,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize:
//                         ResponsiveHelper.responsiveFontSize(context, 16.0),
//                   ),
//                 ),
//                 const SizedBox(height: 10.0),
//                 _buildPickOptionWidget(_provider),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 Divider(
//                   color: Colors.white,
//                   thickness: .3,
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 TicketGroup(
//                   groupTickets: _provider.ticket,
//                   currentUserId: _provider.user!.userId!,
//                   event: null,
//                   inviteReply: '',
//                 ),
//                 const SizedBox(height: 40.0),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  // Widget _buildPickOptionWidget(UserData _provider) {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   var _userLocation = _provider.userLocationPreference;
  //   final List<String> currencyPartition = _provider.currency.isEmpty
  //       ? ' Ghana Cedi | GHS'.trim().replaceAll('\n', ' ').split("|")
  //       : _provider.currency.trim().replaceAll('\n', ' ').split("|");
  //   // Check for the country being Ghana or the currency code being GHS
  //   bool isGhanaOrCurrencyGHS = _userLocation!.country == 'Ghana' &&
  //       currencyPartition[1].trim() == 'GHS';
  //   return PickOptionWidget(
  //     title: _provider.ticket.length < 1
  //         ? 'Create Ticket'
  //         : 'Create another Ticket',
  //     onPressed: widget.isEditting
  //         ? () {
  //             !isGhanaOrCurrencyGHS || widget.event!.ticketSite.isNotEmpty
  //                 ? _showBottomTicketSite()
  //                 : _buildTicketDialog();
  //           }
  //         : () {
  //             _provider.isExternalTicketPayment || !isGhanaOrCurrencyGHS
  //                 ? _showBottomTicketSite()
  //                 : _buildTicketDialog();
  //           },
  //     dropDown: false,
  //   );
  // }

  _pageWidget({
    bool noPadding = false,
    required Column newWidget,
  }) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
                right: noPadding ? 10.0 : 20.0,
                left: noPadding ? 10.0 : 20.0,
                top: 80),
            child: newWidget),
      ),
    );
  }

  // _switchTagPeopleRole(
  //   bool fromList,
  // ) {
  //   return GestureDetector(
  //       onTap: () => FocusScope.of(context).unfocus(),
  //       child: fromList
  //           ? ListView.builder(
  //               physics: const NeverScrollableScrollPhysics(),
  //               itemCount: performers.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return ListTile(
  //                   title: Text(
  //                     performers[index],
  //                     style: Theme.of(context).textTheme.bodyLarge,
  //                   ),
  //                   onTap: () async {
  //                     if (mounted) {
  //                       setState(() {
  //                         _selectedRole = performers[index];
  //                         _taggedType = 'performer';
  //                       });
  //                     }
  //                     Navigator.pop(context);
  //                   },
  //                   subtitle: Divider(
  //                     thickness: .3,
  //                   ),
  //                 );
  //               },
  //             )
  //           : ListView.builder(
  //               physics: const NeverScrollableScrollPhysics(),
  //               itemCount: crew.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return ListTile(
  //                   title: Text(
  //                     crew[index],
  //                     style: Theme.of(context).textTheme.bodyLarge,
  //                   ),
  //                   onTap: () async {
  //                     if (mounted) {
  //                       setState(() {
  //                         _selectedRole = crew[index];
  //                         _taggedType = 'crew';
  //                       });
  //                     }
  //                     Navigator.pop(context);
  //                   },
  //                   subtitle: Divider(
  //                     thickness: .3,
  //                   ),
  //                 );
  //               },
  //             ));
  // }

  // void _showBottomTaggedPeople() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return AddTaggedPeople(
  //           // selectedNameToAdd: _selectedNameToAdd,
  //           // selectedNameToAddProfileImageUrl: _selectedNameToAddProfileImageUrl,
  //           // taggedUserExternalLink: _taggedUserExternalLink,
  //           tagNameController: _tagNameController,
  //           addPersonFormKey: _addPersonFormKey,
  //           nameSearchfocusNode: _nameSearchfocusNode,
  //           isSchedule: false,
  //         );
  //       });
  //     },
  //   );
  // }

  // void _showBottomTaggedPeopleRole() {
  //   var _size = MediaQuery.of(context).size;
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: _size.height.toDouble() / 1.3,
  //         decoration: BoxDecoration(
  //             color: Theme.of(context).primaryColorLight,
  //             borderRadius: BorderRadius.circular(30)),
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 30),
  //           child: DoubleOptionTabview(
  //             height: _size.height,
  //             onPressed: (int) {},
  //             tabText1: 'Performers',
  //             tabText2: 'Crew',
  //             initalTab: 0,
  //             widget1: _switchTagPeopleRole(
  //               true,
  //             ),
  //             widget2: _switchTagPeopleRole(
  //               false,
  //             ),
  //             lightColor: true,
  //             pageTitle: '',
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

// //pick dates
//   Widget _eventPickDateSection() {
//     UserData _provider = Provider.of<UserData>(context, listen: false);
//     Duration _durationDuringEvents =
//         _provider.clossingDay.toDate().difference(_provider.startDate.toDate());
//     int differenceBetweenEventDays = _durationDuringEvents.inDays.abs();
//     Duration _countDownToEvents =
//         DateTime.now().difference(_provider.startDate.toDate());
//     int countDownDifferenceToEvent = _countDownToEvents.inDays.abs();
//     return _pageWidget(
//       newWidget: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildEventProcessRow3(),
//           DirectionWidgetWhite(
//             text:
//                 'Select a start and end date for your event. If your event would end on thesame day, you can select only the start date. ',
//           ),
//           Container(
//             decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColorLight,
//                 borderRadius: BorderRadius.circular(30)),
//             padding:
//                 const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 40),
//             child: Column(
//               children: [
//                 if (widget.isEditting)
//                   Text(
//                     'If you decide to change your event and date, please note that it will impact the format of your schedules and tickets. We recommend adjusting the dates on your schedules and tickets to align with your new modified date.',
//                     style: TextStyle(
//                         color: Theme.of(context).secondaryHeaderColor,
//                         fontSize:
//                             ResponsiveHelper.responsiveFontSize(context, 12)),
//                   ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 DatePicker(
//                   onlyWhite: false,
//                   onStartDateChanged: (DateTime newDate) {
//                     _provider.setStartDate(Timestamp.fromDate(newDate));
//                     _provider.setSheduleDateTemp(Timestamp.fromDate(newDate));
//                     _provider.setStartDateString(newDate.toString());
//                   },
//                   onEndDateChanged: (DateTime newDate) {
//                     _provider.setClossingDay(Timestamp.fromDate(newDate));
//                     _provider.setClossingDayString(newDate.toString());
//                   },
//                   onEndTimeChanged: (DateTime newDate) {
//                     _scheduleStartTime = newDate;
//                   },
//                   onStartTimeChanged: (DateTime newDate) {
//                     _scheduleEndTime = newDate;
//                   },
//                   date: true,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 40,
//           ),
//           _buildEventInformationText(
//               'Duration:',
//               _provider.clossingDate.isEmpty
//                   ? ''
//                   : '${differenceBetweenEventDays.toString()} days'),
//           _buildEventInformationDivider(),
//           _buildEventInformationText('Countdown:',
//               '${countDownDifferenceToEvent.toString()} days more'),
//           const SizedBox(
//             height: 100,
//           ),
//         ],
//       ),
//     );
//   }

  // Widget _buildEventProcessRow3() {
  //   UserData _provider = Provider.of<UserData>(context, listen: false);

  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       _eventProcessNumber(
  //         '3. ',
  //         'Date.',
  //       ),
  //       if (_provider.startDateSelected || widget.isEditting)
  //         MiniCircularProgressButton(
  //             onPressed: () {
  //               FocusScope.of(context).unfocus();
  //               animateToPage(1);

  //               if (widget.event == null || widget.isDraft)
  //                 EventDatabaseDraft.submitEditDraftTypeAndDate(
  //                   context,
  //                   _isLoading,
  //                   widget.event,
  //                   widget.isDraft,
  //                 );
  //               // _submitEditDraftTypeAndDate();
  //             },
  //             text: "Next")
  //     ],
  //   );
  // }

  // Widget _buildEventInformationDivider() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5.0),
  //     child: Divider(
  //       color: Colors.white,
  //       thickness: .3,
  //     ),
  //   );
  // }

  // Widget _buildEventInformationText(String title, String value) {
  //   return RichText(
  //     textScaler: MediaQuery.of(context).textScaler,
  //     text: TextSpan(
  //       children: [
  //         TextSpan(
  //           text: '$title   ',
  //           style: TextStyle(
  //             fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
  //             color: Colors.white,
  //           ),
  //         ),
  //         TextSpan(
  //           text: value,
  //           style: TextStyle(
  //               color: Colors.white,
  //               fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
  //               fontWeight: FontWeight.bold),
  //         )
  //       ],
  //     ),
  //     overflow: TextOverflow.ellipsis,
  //   );
  // }

  // void _showBottomSheetAddSchedule() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return GestureDetector(
  //         onTap: () {
  //           FocusScope.of(context).unfocus();
  //         },
  //         child: Container(
  //           height: ResponsiveHelper.responsiveHeight(context, 650),
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).cardColor,
  //               borderRadius: BorderRadius.circular(30)),
  //           padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //           child: CreateScheduleWidget(
  //             // selectedNameToAdd: _selectedNameToAdd,
  //             // selectedNameToAddProfileImageUrl:
  //             //     _selectedNameToAddProfileImageUrl,
  //             // taggedUserExternalLink: _taggedUserExternalLink,
  //             tagNameController: _tagNameController,
  //             addPersonFormKey: _addPersonFormKey,
  //             nameSearchfocusNode: _nameSearchfocusNode,
  //             isSchedule: true,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // // DateTime? _selectedDate;
  // _eventPickTimeScheduleSection() {
  //   final width = MediaQuery.of(context).size.width;
  //   var _provider = Provider.of<UserData>(
  //     context,
  //   );

  //   return _pageWidget(
  //     newWidget: Column(
  //       children: [
  //         Container(
  //           height: ResponsiveHelper.responsiveHeight(context, 500 * 500),
  //           width: width,
  //           decoration: BoxDecoration(
  //               color: Colors.transparent,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: ListView(
  //             physics: const NeverScrollableScrollPhysics(),
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   _eventProcessNumber(
  //                     '4. ',
  //                     'Program lineup\n(Time schedules)',
  //                   ),
  //                   _provider.schedule.isEmpty
  //                       ? SizedBox.shrink()
  //                       : MiniCircularProgressButton(
  //                           onPressed: () {
  //                             FocusScope.of(context).unfocus();
  //                             widget.isEditting
  //                                 ? widget.isDraft
  //                                     ? _showCurrencyPicker()
  //                                     : animateToPage(1)
  //                                 : _showCurrencyPicker();
  //                             if (widget.event == null || widget.isDraft)
  //                               EventDatabaseDraft
  //                                   .submitEditDraftScheduleAndDate(
  //                                 context,
  //                                 _isLoading,
  //                                 widget.event,
  //                                 widget.isDraft,
  //                               );
  //                             // _submitEditDraftScheduleAndDate();
  //                           },
  //                           text: "Next")
  //                 ],
  //               ),
  //               DirectionWidgetWhite(
  //                 text:
  //                     'The program lineup refers to the sequence or order in which different elements of the event will be presented or performed. You should provide a structured timeline for attendees, staff, and participants to know when each segment of the event will occur.',
  //               ),
  //               const SizedBox(height: 10.0),
  //               PickOptionWidget(
  //                 title: 'Create schedule',
  //                 onPressed: () {
  //                   _showBottomSheetAddSchedule();
  //                 },
  //                 dropDown: false,
  //               ),
  //               const SizedBox(
  //                 height: 30,
  //               ),
  //               ScheduleGroup(
  //                 schedules: _provider.schedule,
  //                 isEditing: true,
  //                 eventOrganiserId: _provider.currentUserId!,
  //                 currentUserId: _provider.currentUserId!,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

// // pick event address section
//   _eventAdressSection() {
//     var _provider = Provider.of<UserData>(
//       context,
//     );
//     _pickVenueText(
//       String title,
//       String subTitle,
//       VoidCallback onPressed,
//     ) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           PickOptionWidget(
//             title: title,
//             onPressed: onPressed,
//             dropDown: true,
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 50.0),
//             child: Text(
//               subTitle,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
//               ),
//             ),
//           )
//         ],
//       );
//     }

//     return _pageWidget(
//       newWidget: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _eventProcessNumber(
//                 '6. ',
//                 'Venue',
//               ),
//               _provider.venue.isEmpty || _provider.address.isEmpty
//                   ? SizedBox.shrink()
//                   : MiniCircularProgressButton(
//                       onPressed: () {
//                         animateToPage(1);
//                         if (widget.event == null || widget.isDraft)
//                           EventDatabaseDraft.submitEditDraftVenueAndPeople(
//                             context,
//                             widget.event,
//                             _isLoading,
//                             widget.isDraft,
//                           );
//                         // _submitEditDraftVenueAndPeople();
//                       },
//                       text: 'Next'),
//             ],
//           ),
//           DirectionWidgetWhite(
//             text: _provider.isVirtual
//                 ? 'Enter the host link of the event. It will help other users virtually join the event if they are interested. '
//                 : 'Please enter the venue for the event. The venue refers to the specific physical location where the event will take place. It could be an event center, auditorium, stadium, church, house, club, or any other suitable space. ',
//           ),
//           SizedBox(height: 10),
//           _provider.isVirtual
//               ? Container(
//                   color: Colors.white,
//                   child: ContentFieldBlack(
//                     labelText: "Virtual venue",
//                     hintText: "Link to virtual event venue",
//                     initialValue: _provider.address,
//                     onSavedText: (input) => _provider.setAddress(input),
//                     onValidateText: (_) {},
//                   ),
//                 )
//               : Container(
//                   color: Colors.white,
//                   child: ContentFieldBlack(
//                     labelText: "Event venue",
//                     hintText:
//                         "This could be an event center name, an auditorium, a stadium, or a church.",
//                     initialValue: _provider.venue,
//                     onSavedText: (input) => _provider.setVenue(input),
//                     onValidateText: (_) {},
//                   ),
//                 ),
//           const SizedBox(
//             height: 30,
//           ),
//           _provider.address.isEmpty
//               ? _pickVenueText('+  Add Address to venue',
//                   'Please provide the venue address accurately. It will assist attendees in finding the event venue (location).',
//                   () {
//                   _showBottomVenue(
//                     'Adrress',
//                   );
//                 })
//               : GestureDetector(
//                   onTap: () {
//                     _showBottomVenue(
//                       'Adrress',
//                     );
//                   },
//                   child: Text(
//                     _provider.address,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize:
//                           ResponsiveHelper.responsiveFontSize(context, 14.0),
//                     ),
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }

//   _eventPeopleSection(bool isSponsor) {
//     var _provider = Provider.of<UserData>(context, listen: false);
//     List<TaggedEventPeopleModel> taggPeoples = _provider.taggedEventPeople;
//     Map<String, List<TaggedEventPeopleModel>> taggPeoplesByGroup = {};
//     for (TaggedEventPeopleModel taggedPeople in taggPeoples) {
//       if (!taggPeoplesByGroup.containsKey(taggedPeople.role)) {
//         taggPeoplesByGroup[taggedPeople.role] = [];
//       }
//       taggPeoplesByGroup[taggedPeople.role]!.add(taggedPeople);
//     }

//     var _style = TextStyle(
//         color: Colors.white,
//         fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
//         fontWeight: FontWeight.bold);
//     return _pageWidget(
//       newWidget: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _eventProcessNumber(
//                 isSponsor ? '8. ' : '7. ',
//                 isSponsor
//                     ? 'Partners and sponsors.\n(Optional)'
//                     : 'Performers and special guests.\n(Optional)',
//               ),
//               MiniCircularProgressButton(
//                   onPressed: () {
//                     animateToPage(1);
//                     if (widget.event == null || widget.isDraft)
//                       EventDatabaseDraft.submitEditDraftVenueAndPeople(
//                         context,
//                         widget.event,
//                         _isLoading,
//                         widget.isDraft,
//                       );
//                     // _submitEditDraftVenueAndPeople();
//                   },
//                   // _validate,
//                   text: widget.isEditting
//                       ? 'Next'
//                       : _provider.taggedEventPeople.isEmpty
//                           ? "Skip"
//                           : "Next"),
//             ],
//           ),
//           DirectionWidgetWhite(
//             text: isSponsor
//                 ? 'Please enter the names of sponsors and partners who are supporting this event. '
//                 : 'Please provide the names and roles of all the performers, participants, or special guests who will be attending this event.',
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _provider.taggedUserSelectedProfileName.isEmpty ||
//                       _selectedRole.isEmpty ||
//                       _provider.taggedUserSelectedProfileLink.isEmpty &&
//                           _provider.taggedUserSelectedExternalLink.isEmpty
//                   ? SizedBox.shrink()
//                   : Align(
//                       alignment: Alignment.centerRight,
//                       child: MiniCircularProgressButton(
//                         color: Colors.blue,
//                         text: '  Add  ',
//                         onPressed: () async {
//                           await EventDatabaseEventData.addTaggedPeople(
//                               context: context,
//                               // selectedNameToAdd: _selectedNameToAdd,
//                               selectedRole: _selectedRole,
//                               newtaggedType: _taggedType,
//                               // taggedUserExternalLink: _taggedUserExternalLink,
//                               // selectedNameToAddProfileImageUrl:
//                               // _selectedNameToAddProfileImageUrl,
//                               selectedSponsorOrPartnerValue:
//                                   selectedSponsorOrPartnerValue,
//                               users: _users,
//                               tagNameController: _tagNameController);
//                           // _selectedNameToAdd = '';
//                           _selectedRole = '';
//                           // _addTaggedPeople();
//                         },
//                       ),
//                     ),
//               const SizedBox(
//                 height: 30,
//               ),
//               PickOptionWidget(
//                   dropDown: true,
//                   title: 'Add name',
//                   onPressed: () {
//                     _showBottomTaggedPeople();
//                   }),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(_provider.taggedUserSelectedProfileName, style: _style),
//             ],
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//           isSponsor
//               ? buildSponserOrPartnerRadios()
//               : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     PickOptionWidget(
//                       title: 'Add Role',
//                       onPressed: () {
//                         _showBottomTaggedPeopleRole();
//                       },
//                       dropDown: false,
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     if (_selectedRole.isNotEmpty)
//                       Text("$_taggedType:   $_selectedRole", style: _style),
//                   ],
//                 ),
//           const SizedBox(height: 20.0),
//           Divider(
//             color: Colors.white,
//             thickness: .3,
//           ),
//           const SizedBox(height: 20.0),
//           TaggedPeopleGroup(
//             canBeEdited: true,
//             groupTaggedEventPeopleGroup: isSponsor
//                 ? _provider.taggedEventPeople
//                     .where((taggedPerson) =>
//                         taggedPerson.role == 'Sponsor' ||
//                         taggedPerson.role == 'Partner')
//                     .toList()
//                 : _provider.taggedEventPeople
//                     .where((taggedPerson) =>
//                         taggedPerson.role != 'Sponsor' &&
//                         taggedPerson.role != 'Partner')
//                     .toList(),
//           ),
//         ],
//       ),
//     );
//   }

  // void _showBottomContact(
  //   List<String> contacts,
  // ) {
  //   TextEditingController controller = _contactController;
  //   double sheetHeightFraction = 1.3;

  //   var _size = MediaQuery.of(context).size;
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //           return AnimatedBuilder(
  //               animation: controller, // Use the controller as the Listenable
  //               builder: (BuildContext context, Widget? child) {
  //                 return Form(
  //                   key: _contactsFormKey,
  //                   child: Container(
  //                     height: _size.height.toDouble() / sheetHeightFraction,
  //                     decoration: BoxDecoration(
  //                         color: Theme.of(context).primaryColorLight,
  //                         borderRadius: BorderRadius.circular(30)),
  //                     child: Scaffold(
  //                       backgroundColor: Colors.transparent,
  //                       body: Padding(
  //                         padding: const EdgeInsets.all(20),
  //                         child: ListView(
  //                           children: [
  //                             contacts.length < 6 && controller.text.length > 0
  //                                 ? Align(
  //                                     alignment: Alignment.topRight,
  //                                     child: MiniCircularProgressButton(
  //                                       onPressed: () {
  //                                         EventDatabaseEventData.addContacts(
  //                                           contactController:
  //                                               _contactController,
  //                                           context: context,
  //                                           contactsFormKey: _contactsFormKey,
  //                                         );
  //                                         // _addContacts();
  //                                       },
  //                                       text: "Add",
  //                                       color: Colors.blue,
  //                                     ),
  //                                   )
  //                                 : Align(
  //                                     alignment: Alignment.topRight,
  //                                     child: GestureDetector(
  //                                       onTap: () {
  //                                         Navigator.pop(context);
  //                                       },
  //                                       child: Text(
  //                                         'Done',
  //                                         style: TextStyle(
  //                                             fontSize: ResponsiveHelper
  //                                                 .responsiveFontSize(
  //                                                     context, 14.0),
  //                                             color: Colors.blue,
  //                                             fontWeight: FontWeight.bold),
  //                                       ),
  //                                     ),
  //                                   ),
  //                             if (contacts.length > 5 &&
  //                                 controller.text.length > 0)
  //                               Padding(
  //                                 padding: const EdgeInsets.only(top: 30.0),
  //                                 child: Text(
  //                                   'You cannot add more than six ',
  //                                   style: TextStyle(
  //                                       color: Colors.red,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                             const SizedBox(
  //                               height: 30,
  //                             ),
  //                             _ticketFiled(
  //                               false,
  //                               true,
  //                               'Contact',
  //                               'Phone numbers',
  //                               _contactController,
  //                               TextInputType.numberWithOptions(decimal: true),
  //                               (value) {
  //                                 String pattern =
  //                                     r'^(\+\d{1,3}[- ]?)?\d{1,4}[- ]?(\d{1,3}[- ]?){1,2}\d{1,9}(\ x\d{1,4})?$';
  //                                 RegExp regex = new RegExp(pattern);
  //                                 if (!regex.hasMatch(value!))
  //                                   return 'Enter a valid phone number';
  //                                 else
  //                                   return null;
  //                               },
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               });
  //         });
  //       });
  // }

  // _eventOrganizerContacts() {
  //   var _provider = Provider.of<UserData>(context, listen: false);

  //   return _pageWidget(
  //     newWidget: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             _eventProcessNumber(
  //               '10. ',
  //               'Contacts',
  //             ),
  //             if (_provider.eventOrganizerContacts.isNotEmpty)
  //               MiniCircularProgressButton(
  //                   onPressed: () {
  //                     animateToPage(1);
  //                     if (widget.event == null || widget.isDraft)
  //                       EventDatabaseDraft.submitEditDrafContactAndTerms(
  //                         context,
  //                         widget.event,
  //                         _isLoading,
  //                         widget.isDraft,
  //                       );
  //                   },
  //                   text: widget.isEditting
  //                       ? 'Next'
  //                       : _provider.isPrivate
  //                           ? "Next"
  //                           : "Next"),
  //           ],
  //         ),
  //         DirectionWidgetWhite(
  //           text:
  //               'Kindly provide a phone number for potential attendees and partners to get in touch with you.',
  //         ),
  //         const SizedBox(
  //           height: 30,
  //         ),
  //         PickOptionWidget(
  //             dropDown: true,
  //             title: 'Add contact',
  //             onPressed: () {
  //               _showBottomContact(_provider.eventOrganizerContacts);
  //             }),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         const SizedBox(height: 20.0),
  //         Divider(
  //           color: Colors.white,
  //           thickness: .3,
  //         ),
  //         const SizedBox(height: 20.0),
  //         EventOrganizerContactWidget(
  //           portfolios: _provider.eventOrganizerContacts,
  //           edit: true,
  //         ),
  //       ],
  //     ),
  //   );
  // }

//validateToxicTextChange
  // _validateToxixTextChange() {
  //   var _provider = Provider.of<UserData>(context, listen: false);

  //   // if (widget.event != null) {
  //   //   if (_provider.titleDraft != _provider.title ||
  //   //         _provider.themeDraft != _provider.theme) {
  //   //       // Assuming you have a corresponding draft variable
  //   //       _validateTextToxicity();
  //   //     } else {
  //   //     animateToPage(1);
  //   //   }
  //   // } else {
  //   if (_provider.titleDraft != _provider.title ||
  //       _provider.themeDraft != _provider.theme) {
  //     // Assuming you have a corresponding draft variable
  //     _validateTextToxicity();
  //   } else {
  //     animateToPage(1);
  //   }
  //   // }
  // }

// enter main event information: title, theme, etc.
  // _validateTextToxicity() async {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   _provider.setIsLoading(true);
  //   TextModerator moderator = TextModerator();
  //   // Define the texts to be checked
  //   List<String> textsToCheck = [_provider.caption, _provider.had];
  //   // Set a threshold for toxicity that is appropriate for your app
  //   const double toxicityThreshold = 0.7;
  //   bool allTextsValid = true;
  //   try {
  //     for (String text in textsToCheck) {
  //       if (text.isEmpty) {
  //         // Handle the case where the text is empty
  //         mySnackBar(context, 'Title and theme cannot be empty.');
  //         allTextsValid = false;
  //         break; // Exit loop as there is an empty text
  //       }
  //       Map<String, dynamic>? analysisResult =
  //           await moderator.moderateText(text);
  //       // Check if the API call was successful
  //       if (analysisResult != null) {
  //         double toxicityScore = analysisResult['attributeScores']['TOXICITY']
  //             ['summaryScore']['value'];
  //         if (toxicityScore >= toxicityThreshold) {
  //           // If any text's score is above the threshold, show a Snackbar and set allTextsValid to false
  //           mySnackBarModeration(context,
  //               'Your title or theme contains inappropriate content. Please review');
  //           allTextsValid = false;
  //           break; // Exit loop as we already found inappropriate content
  //         }
  //       } else {
  //         // Handle the case where the API call failed
  //         mySnackBar(context, 'Error analyzing text. Try again.');
  //         allTextsValid = false;
  //         break; // Exit loop as there was an API error
  //       }
  //     }
  //   } catch (e) {
  //     // Handle any exceptions here
  //     mySnackBar(context, 'An unexpected error occurred. Please try again.');
  //     allTextsValid = false;
  //   } finally {
  //     // This block runs whether an exception occurred or not
  //     _provider.setIsLoading(false);
  //   }
  //   // You can use allTextsValid for further logic if needed
  //   if (allTextsValid) {
  //     _provider.setIsLoading(false);
  //     animateToPage(1);
  //     //   if (widget.event == null || widget.isDraft)
  //     //     EventDatabaseDraft.submitEditDraftTitleTheme(
  //     //       context,
  //     //       _isLoading,
  //     //       widget.event,
  //     //       widget.isDraft,
  //     //     );
  //   }
  // }

  void mySnackBarModeration(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 4),
      ),
    );
  }

  // _eventMainInformation() {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   return _pageWidget(
  //     newWidget: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             _eventProcessNumber(
  //               '9. ',
  //               'Flyer\nInformation.',
  //             ),
  //             if (_provider.title.isNotEmpty && _provider.theme.isNotEmpty)
  //               MiniCircularProgressButton(
  //                   onPressed: _validateToxixTextChange, text: "Next"),
  //           ],
  //         ),
  //         DirectionWidgetWhite(
  //           text:
  //               'Please ensure that you provide the necessary information accurately. Both the Title and Theme fields must be filled in order to proceed. ',
  //         ),
  //         SizedBox(
  //           height: 5,
  //         ),
  //         Container(
  //           color: Colors.white,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 10.0,
  //             ),
  //             child: Column(
  //               children: [
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 ContentFieldBlack(
  //                   labelText: 'Title',
  //                   hintText: "Enter the title of your event",
  //                   initialValue: _provider.title.toString(),
  //                   onSavedText: (input) => _provider.setTitle(input),
  //                   onValidateText: (input) => input.trim().length < 1
  //                       ? "The title cannot be empty"
  //                       : null,
  //                 ),
  //                 ContentFieldBlack(
  //                   labelText: 'Theme',
  //                   hintText: "Enter a theme for the event",
  //                   initialValue: _provider.theme.toString(),
  //                   onSavedText: (input) => _provider.setTheme(input),
  //                   onValidateText: (input) => input.trim().length < 10
  //                       ? "The theme is too short( > 10 characters)"
  //                       : null,
  //                 ),
  //                 ContentFieldBlack(
  //                   labelText: 'Overview',
  //                   hintText: "Indepth Description of the event",
  //                   initialValue: _provider.overview.toString(),
  //                   onSavedText: (input) => _provider.setOverview(input),
  //                   onValidateText: (input) => input.trim().length < 50
  //                       ? "Overview is too short( > 10 characters)"
  //                       : null,
  //                 ),
  //                 ContentFieldBlack(
  //                   labelText: "Dress code for the event",
  //                   hintText: 'Dress code',
  //                   initialValue: _provider.dressCode,
  //                   onSavedText: (input) => _provider.setDressCode(input),
  //                   onValidateText: (_) {},
  //                 ),
  //                 _provider.isVirtual && _provider.couldntDecodeCity
  //                     ? const SizedBox.shrink()
  //                     : ContentFieldBlack(
  //                         labelText: 'City',
  //                         hintText: "City of event",
  //                         initialValue: _provider.city.toString(),
  //                         onSavedText: (input) =>
  //                             _provider.setCity(input.trim()),
  //                         onValidateText: (input) => input.trim().length < 1
  //                             ? "Enter the city of event"
  //                             : null,
  //                       ),
  //                 _provider.isVirtual && _provider.couldntDecodeCity
  //                     ? const SizedBox.shrink()
  //                     : ContentFieldBlack(
  //                         labelText: 'Country',
  //                         hintText: "Country of event",
  //                         initialValue: _provider.country.toString(),
  //                         onSavedText: (input) =>
  //                             _provider.setCountry(input.trim()),
  //                         onValidateText: (input) => input.trim().length < 1
  //                             ? "Enter the country of event"
  //                             : null,
  //                       ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // final musiVideoLink =
  //     RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");
  // _validatePreviosEventLink() async {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   if (_addPreviousVideoFormkey.currentState!.validate()) {
  //     String urlToCheck = _provider.previousEvent;
  //     SafeBrowsingChecker checker = SafeBrowsingChecker();
  //     bool isSafe = await checker.isUrlSafe(urlToCheck);
  //     if (isSafe) {
  //       animateToPage(1);
  //       if (widget.event == null || widget.isDraft)
  //         EventDatabaseDraft.submitEditDrafContactAndTerms(
  //           context,
  //           widget.event!,
  //           _isLoading,
  //           widget.isDraft,
  //         );
  //     } else {
  //       mySnackBar(context, 'video link is not safe');
  //     }
  //   }
  // }

  // _eventPreviousEvent() {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   return _pageWidget(
  //     newWidget: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             _eventProcessNumber(
  //               '11. ',
  //               'Previous\nEvent.(optional)',
  //             ),
  //             MiniCircularProgressButton(
  //                 onPressed: _provider.previousEvent.isNotEmpty
  //                     ? _validatePreviosEventLink
  //                     : () {
  //                         animateToPage(1);
  //                         if (widget.event == null || widget.isDraft)
  //                           EventDatabaseDraft.submitEditDrafContactAndTerms(
  //                             context,
  //                             widget.event,
  //                             _isLoading,
  //                             widget.isDraft,
  //                           );
  //                       },
  //                 text: "Next"),
  //           ],
  //         ),
  //         DirectionWidgetWhite(
  //           text:
  //               'To give other users an insight into the upcoming event, you can share a video link showcasing the previous event.',
  //         ),
  //         Container(
  //           color: Colors.white,
  //           child: Column(
  //             children: [
  //               Form(
  //                 key: _addPreviousVideoFormkey,
  //                 child: ContentFieldBlack(
  //                   labelText: "Previous event",
  //                   hintText: 'A video link to previous event',
  //                   initialValue: _provider.previousEvent,
  //                   onSavedText: (input) => _provider.setPreviousEvent(input),
  //                   onValidateText: (input) => !musiVideoLink.hasMatch(input!)
  //                       ? "Enter a valid video link"
  //                       : null,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 30,
  //         ),
  //         const SizedBox(height: 70),
  //       ],
  //     ),
  //   );
  // }

  _eventTermsAndConditions({
    required String title,
    required String direction,
    required String labelText,
    required String hintText,
    required String initialValue,
    required Function(String) onSavedText,
    required isSubmit,
  }) {
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
                title,
              ),
              _provider.isLoading
                  ? const SizedBox.shrink()
                  : MiniCircularProgressButton(
                      color: isSubmit ? Colors.blue : Colors.white,
                      onPressed: isSubmit
                          ? () {
                              if (widget.isEditting && widget.post != null) {
                                EventDatabase.editPost(
                                    context, _pageController, widget.post!);
                              } else if (isSubmit) {
                                EventDatabase.submitCreate(
                                    context, _pageController);
                              }
                            }
                          : () {
                              animateToPage(1);
                            },
                      text: isSubmit && widget.isEditting
                          ? 'Save'
                          : isSubmit
                              ? 'POST'
                              : 'Next'),
            ],
          ),
          DirectionWidgetWhite(
            text: direction,
            // 'You can provide your terms and conditions and other policies to govern this event.',
          ),
          Container(
            color: Colors.white,
            child: ContentFieldBlack(
              labelText: labelText,
              hintText: hintText,
              initialValue: initialValue,
              onSavedText: onSavedText,
              onValidateText: (_) {},
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Text(
          //   'The terms and conditions outline the terms of service for event attendees and establish the rights and responsibilities of both the event organizer and attendees. By providing these terms and conditions and ensuring that attendees read and understand them, individuals can obtain clear information regarding crucial aspects including event policies, refund and cancellation policies, liability disclaimers, code of conduct, privacy and data handling practices, and any other relevant rules or guidelines. This helps create transparency and enables attendees to make informed decisions and comply with the established terms during their participation in the event.',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
          //   ),
          // ),
          // const SizedBox(
          //   height: 100,
          // ),
        ],
      ),
    );
  }

  _animatedText(String text) {
    return FadeAnimatedText(
      duration: const Duration(seconds: 8),
      text,
      textStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
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
                title: '',
                // widget.isEditting ? 'Updating event' : 'Publishing event',
                icon: (Icons.event),
              ),
              SizedBox(height: 40),
              Padding(
                  padding: const EdgeInsets.all(20.0),
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
            onPressed: () {
              _pageController.page == 0 ? _pop() : animateToBack(1);
            }

            // widget.isCompleted
            //     ? () {
            //         _pop();
            //       }
            //     : widget.isEditting
            //         ? widget.isDraft
            //             ? () {
            //                 _pageController.page == 0
            //                     ? _pop()
            //                     : animateToBack(1);
            //               }
            //             : () {
            //                 widget.event!.isFree && _provider.int1 == 2
            //                     //  _pageController.page == 2
            //                     ? _pop()
            //                     : _provider.int1 == 1
            //                         // _pageController.page == 1
            //                         ? _pop()
            //                         : animateToBack(1);
            //               }
            //         : () {
            //             _provider.int1 == 0 ? _pop() : animateToBack(1);
            //           }
            );
  }

  // _completed() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         ShakeTransition(
  //           duration: const Duration(seconds: 2),
  //           child: Icon(
  //             Icons.check,
  //             color: Colors.white,
  //             size: ResponsiveHelper.responsiveHeight(context, 40.0),
  //           ),
  //         ),
  //         SizedBox(height: ResponsiveHelper.responsiveHeight(context, 10.0)),

  //         const SizedBox(height: 3),
  //         Text(
  //           'Congratulations on completing ${widget.event!.title}. We are thrilled that you have reached this milestone. Completing such an event is no easy feat, and we commend your dedication. We wish you the best for your upcoming events. Please note that completed events cannot be modified further. If you choose to, you have the option to delete the event. ',
  //           style: TextStyle(
  //               color: Colors.white,
  //               fontSize: ResponsiveHelper.responsiveFontSize(context, 14)),
  //           textAlign: TextAlign.start,
  //         ),
  //         SizedBox(height: ResponsiveHelper.responsiveHeight(context, 30.0)),
  //         Container(
  //           margin: const EdgeInsets.only(bottom: 5),
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //               color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //           child: _button(Icons.delete_outline, _deleteEventOrDraft),
  //         ),
  //         // _button(
  //         //   Icons.delete_outline,
  //         //   _deleteEventOrDraft,
  //         // )
  //       ],
  //     ),
  //   );
  // }

  // void _createEventDoc(
  //   BuildContext context,
  // ) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return CreateWorkRequestDoc(
  //         fromWelcome: false,
  //       );
  //     },
  //   );
  // }

  // Widget _eventFinalSection(BuildContext context) {
  //   UserData _provider = Provider.of<UserData>(context, listen: false);
  //   return _pageWidget(
  //     noPadding: true,
  //     newWidget: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         // const SizedBox(height: 20),
  //         if (widget.event == null || widget.isDraft)
  //           ShakeTransition(
  //             duration: const Duration(seconds: 2),
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 20.0),
  //               child: RichText(
  //                 textScaler: MediaQuery.of(context).textScaler,
  //                 text: TextSpan(
  //                   children: [
  //                     TextSpan(
  //                       text: "Ready? ",
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: ResponsiveHelper.responsiveFontSize(
  //                               context, 20)),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           '\n\nAre you ready to publish your event? Your event is automatically saved as a draft, allowing you to modify it as many times as you like until you\'re ready to publish it.',
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: ResponsiveHelper.responsiveFontSize(
  //                               context, 12)),
  //                     )
  //                   ],
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //           ),
  //         // const SizedBox(height: 20),
  //         widget.isEditting && !widget.isDraft
  //             ? Container(
  //                 margin: const EdgeInsets.only(bottom: 5),
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(10)),
  //                 child: _button(
  //                   Icons.save_outlined,
  //                   () async {
  //                     // var connectivityResult =
  //                     //     await Connectivity().checkConnectivity();
  //                     // if (connectivityResult == ConnectivityResult.none) {
  //                     //   // No internet connection
  //                     //   _showBottomSheetErrorMessage(
  //                     //       'No internet connection available. ');
  //                     //   return;
  //                     // }
  //                     EventDatabase.editEvent(
  //                         context, widget.event!, _pageController);
  //                   },
  //                 ),
  //               )
  //             : _finalButtons(
  //                 'Preview',
  //                 () async {
  //                   Event event = await EventDatabase.createEvent(
  //                     blurHash:
  //                         widget.event != null ? widget.event!.blurHash : '',
  //                     imageUrl: _provider.imageUrl,
  //                     commonId: widget.event != null
  //                         ? widget.event!.id
  //                         : _provider.eventId,
  //                     link: '',
  //                     insight: _provider.aiMarketingDraft,
  //                     aiMarketingAdvice: _provider.aiMarketingDraft,
  //                     provider: _provider,
  //                   );

  //                   _navigateToPage(
  //                     context,
  //                     EventEnlargedScreen(
  //                       isPreview: true,
  //                       currentUserId: _provider.currentUserId!,
  //                       event: event,
  //                       type: event.type,
  //                       showPrivateEvent: true,
  //                     ),
  //                   );
  //                 },
  //                 'Publish',
  //                 () async {
  //                   animateToPage(1);
  //                 },
  //                 false),
  //         if (widget.isDraft || widget.event == null)
  //           Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 2.0),
  //             child: _finalButtons('Book Creatives', () async {
  //               _navigateToPage(
  //                 context,
  //                 DiscoverUser(
  //                   currentUserId: _provider.currentUserId!,
  //                   // userLocationSettings:
  //                   //     _provider.userLocationPreference!,
  //                   isLiveLocation: true,
  //                   liveCity: _provider.city,
  //                   //  widget.event!.city,
  //                   liveCountry: _provider.country,
  //                   liveLocationIntialPage: 0, isWelcome: false,
  //                   // sortNumberOfDays: 0,
  //                 ),
  //               );
  //             }, '', () async {}, true),
  //           ),

  //         Container(
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).primaryColorLight,
  //               borderRadius: BorderRadius.circular(10)),
  //           padding: const EdgeInsets.only(left: 20.0, right: 10, bottom: 50),
  //           margin: EdgeInsets.only(
  //             top: widget.isEditting && !widget.isDraft ? 3 : 10.0,
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               const SizedBox(height: 60),
  //               Center(
  //                 child: AnimatedCircle(
  //                   size: 50,
  //                   stroke: 3,
  //                   animateSize: true,
  //                 ),
  //               ),
  //               const SizedBox(height: 40),
  //               MarkdownBody(
  //                 data: widget.event != null
  //                     ? widget.event!.aiMarketingAdvice.isEmpty
  //                         ? _provider.aiMarketingDraft
  //                         : widget.event!.aiMarketingAdvice
  //                     : _provider.aiMarketingDraft,
  //                 styleSheet: MarkdownStyleSheet(
  //                   h1: Theme.of(context).textTheme.titleLarge,
  //                   h2: Theme.of(context).textTheme.titleMedium,
  //                   p: Theme.of(context).textTheme.bodyMedium,
  //                   listBullet: Theme.of(context).textTheme.bodySmall,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

// //Confirm create business
//   Widget _confirmCreateBusiness(BuildContext context) {
//     UserData _provider = Provider.of<UserData>(context, listen: false);
//     return _pageWidget(
//       noPadding: true,
//       newWidget: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // const SizedBox(height: 20),

//           // if (widget.isDraft || widget.event == null)

//           Container(
//             decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(30)),
//             padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 50),
//             margin: EdgeInsets.only(
//               top: widget.isEditting && !widget.isDraft ? 3 : 10.0,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // const SizedBox(height: 60),
//                 // Center(
//                 //   child: AnimatedCircle(
//                 //     size: 50,
//                 //     stroke: 3,
//                 //     animateSize: true,
//                 //   ),
//                 // ),
//                 const SizedBox(height: 40),
//                 ShakeTransition(
//                   duration: const Duration(seconds: 2),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 20.0),
//                     child: RichText(
//                       textScaler: MediaQuery.of(context).textScaler,
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'Confirm information',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: ResponsiveHelper.responsiveFontSize(
//                                     context, 20)),
//                           ),
//                           TextSpan(
//                             text:
//                                 '\n\nPlease note that certain event details, such as the background image, and settings, cannot be modified once the event is published. We recommend carefully reviewing this information before proceeding.',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: ResponsiveHelper.responsiveFontSize(
//                                     context, 12)),
//                           )
//                         ],
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 5.0),
//                   child: _finalButtons('Publish event', () async {
//                     var connectivityResult =
//                         await Connectivity().checkConnectivity();
//                     if (connectivityResult == ConnectivityResult.none) {
//                       // No internet connection
//                       _showBottomSheetErrorMessage(
//                           'No internet connection available. ');
//                       return;
//                     }
//                     EventDatabase.submitCreate(
//                       context,
//                       _pageController,
//                     );
//                     // widget.isEditting
//                     //     ? _editEvent()
//                     //     : _showBottomConfirmEventInfo(context);
//                     // EventDatabase.showBottomConfirmEventInfo(
//                     //   context,
//                     //   _pageController,
//                     // );
//                   }, '', () async {}, true),
//                 ),
//               ],
//             ),
//           ),
//           // const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

  // @override
  bool get wantKeepAlive =>
      true; // Keeps the state of the widget alive when switching tabs.
  Widget _buildEventSection() {
    final _provider = Provider.of<UserData>(context, listen: false);
    return Stack(
      alignment: FractionalOffset.center,
      children: [
        // Displays the event image.
        DisplayCreateImage(isEvent: true),
        // if (widget.isCompleted)
        //   _completed() // Shows completed state if the event is finished.
        // else

        if (_provider.profileImage == null && !widget.isEditting)
          // Prompts the user to select an image if none is set and not editing.
          CreateSelectImageWidget(
            onPressed: () {
              // Placeholder for image selection logic.
            },
            isEditting: widget.isEditting,
            feature: '',
            selectImageInfo:
                '\nSelect a background image for your event. The image selected should not contain any text and should be of good pixel quality. The image selected should align with the context of your event. The right image can significantly enhance the atmosphere and engagement of your event.',
            featureInfo: '',
            isEvent: true,
          )
        else
          SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const AlwaysScrollableScrollPhysics(),
              onPageChanged: (int index) {
                _provider.setInt1(
                    index); // Updates the current page index in the provider.
              },
              children:
                  _buildPageViewChildren(), // Builds the pages for the event creation process.
            ),
          ),

        Positioned(top: 50, left: 10, child: _popButton()), // Back button.

        if (_provider.isLoading || _provider.isLoading2)
          // Shows a loading indicator if data is being processed.
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

  List<Widget> _buildPageViewChildren() {
    final _provider = Provider.of<UserData>(context, listen: false);

    return [
      _eventTermsAndConditions(
        title: 'Caption',
        direction: 'Enter a caption for your image, this can be a discription',
        labelText: 'Caption',
        hintText: 'Enter caption here',
        initialValue:
            widget.post != null ? widget.post!.caption : _provider.caption,
        //  _provider.caption,
        onSavedText: (input) => _provider.setCaption(input),
        isSubmit: false,
      ),
      _eventTermsAndConditions(
        title: 'Hashtag',
        direction:
            'Enter a hashtag for your image, this can be in promoting the image and your shop',
        labelText: 'Hastah',
        hintText: 'Enter hastag here',
        initialValue:
            widget.post != null ? widget.post!.hashTag : _provider.hashTagg,
        onSavedText: (input) => _provider.setHashTagg(input),
        isSubmit: true,
      ),
      // _eventSettingSection(), // Page for event settings.

      _loadingWidget(),
      // _eventCategorySection(), // Page for selecting event category.
      // _eventPickDateSection(), // Page for picking the event date.
      // _eventPickTimeScheduleSection(), // Page for scheduling event time.
      // _eventRateSection(), // Page for setting event rates.
      // _eventAdressSection(), // Page for entering event address and venue.
      // _eventPeopleSection(false), // Page for selecting performers.
      // _eventPeopleSection(true), // Page for selecting sponsors.
      // _eventMainInformation(), // Page for entering main event details.
      // _eventOrganizerContacts(), // Page for organizer contact info.
      // _eventPreviousEvent(), // Page for previous event details.
      // _eventTermsAndConditions(), // Page for event terms and conditions.
      // _eventFinalSection(context), // Final review page.
      // widget.isEditting && !widget.isDraft
      //     ? _loadingWidget()
      //     : _confirmCreateBusiness(context), // Confirmation or loading state.
      // _loadingWidget(), // Shows a loading state when creating an event.
    ];
  }

  void _pop() {
    final provider = Provider.of<UserData>(context, listen: false);
    widget.isEditting
        ? EventDatabase.setNull(
            provider, true, context) // Resets data if editing.
        : Navigator.pop(context); // Navigates back if not editing.
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // Dismisses keyboard on tap.
        child: _buildEventSection(), // Main content of the page.
      ),
    );
  }

  // // Main event section
  // @override
  // bool get wantKeepAlive => true;
  // _eventSection() {
  //   var _provider = Provider.of<UserData>(
  //     context,
  //   );
  //   return Stack(
  //     alignment: FractionalOffset.center,
  //     children: [
  //       DisplayCreateImage(
  //         isEvent: true,
  //       ),
  //       widget.isCompleted
  //           ? _completed()
  //           : _provider.eventImage == null && !widget.isEditting
  //               ? CreateSelectImageWidget(
  //                   onPressed: () {
  //                     // _createEventDoc(context);
  //                   },
  //                   isEditting: widget.isEditting,
  //                   feature: '',
  //                   selectImageInfo:
  //                       '\nSelect a background image for your event. The image selected should not contain any text and should be of good pixel quality. The image selected should align with the context of your event. The right image can significantly enhance the atmosphere and engagement of your event. ',
  //                   featureInfo: '',
  //                   isEvent: true,
  //                 )
  //               : SafeArea(
  //                   child: PageView(
  //                       controller: _pageController,
  //                       physics: const AlwaysScrollableScrollPhysics(),
  //                       onPageChanged: (int index) {
  //                         _provider.setInt1(index);
  //                       },
  //                       children: [
  //                         //setting section (private, virtual, etc)
  //                         _eventSettingSection(),
  //                         //select category, festiva, albums, etc.
  //                         _eventCategorySection(),
  //                         //pick date for event
  //                         _eventPickDateSection(),
  //                         //pick time for event
  //                         _eventPickTimeScheduleSection(),
  //                         //rate section (feee)
  //                         _eventRateSection(),
  //                         //event section for picking address and venue.
  //                         _eventAdressSection(),
  //                         //event people performing and appearing
  //                         _eventPeopleSection(false),
  //                         //event sponsors and partners
  //                         _eventPeopleSection(true),
  //                         //event main information(title, theme, etc.)
  //                         _eventMainInformation(),
  //                         //event optional additional
  //                         _eventOrganizerContacts(),
  //                         //event optional additional
  //                         _eventPreviousEvent(),
  //                         //event terms and conditions
  //                         _eventTermsAndConditions(),
  //                         //Final sections
  //                         _eventFinalSection(context),
  //                         //Confirm create business
  //                         widget.isEditting && !widget.isDraft
  //                             ? _loadingWidget()
  //                             : _confirmCreateBusiness(context),
  //                         //loading --- creating event
  //                         _loadingWidget(),
  //                       ]),
  //                 ),
  //       Positioned(top: 50, left: 10, child: _popButton()),
  //       if (_provider.isLoading)
  //         Positioned(
  //           top: 100,
  //           child: SizedBox(
  //             height: ResponsiveHelper.responsiveHeight(context, 2.0),
  //             width: ResponsiveHelper.responsiveWidth(context, 400),
  //             child: LinearProgressIndicator(
  //               backgroundColor: Colors.transparent,
  //               valueColor: AlwaysStoppedAnimation(Colors.blue),
  //             ),
  //           ),
  //         ),
  //     ],
  //   );
  // }

  // _pop() {
  //   var provider = Provider.of<UserData>(context, listen: false);
  //   widget.isEditting
  //       ? EventDatabase.setNull(provider, true, context)
  //       : Navigator.pop(context);
  // }

  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);
  //   return Scaffold(
  //     resizeToAvoidBottomInset: true,
  //     backgroundColor: Colors.black,
  //     body: GestureDetector(
  //         onTap: () => FocusScope.of(context).unfocus(),
  //         child: _eventSection()),
  //   );
  // }
}
