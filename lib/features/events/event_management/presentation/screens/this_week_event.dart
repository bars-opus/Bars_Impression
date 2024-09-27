// import 'package:bars/utilities/exports.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class ThisWeekEvent extends StatefulWidget {
//   final Event event;
//   final List<Event> currentEventList;
//   final List<DocumentSnapshot> currentEventSnapShot;
//   final int sortNumberOfDays;

//   const ThisWeekEvent(
//       {super.key,
//       required this.event,
//       required this.currentEventList,
//       required this.currentEventSnapShot,
//       required this.sortNumberOfDays});

//   @override
//   State<ThisWeekEvent> createState() => _ThisWeekEventState();
// }

// class _ThisWeekEventState extends State<ThisWeekEvent> {
//   bool _checkingTicketAvailability = false;

//   bool _eventHasStarted = false;
//   bool _eventHasEnded = false;

//   @override
//   void initState() {
//     super.initState();
//     _countDown();
//   }

//   void _countDown() async {
//     if (EventHasStarted.hasEventStarted(widget.event.startDate.toDate())) {
//       if (mounted) {
//         setState(() {
//           _eventHasStarted = true;
//         });
//       }
//     }

//     if (EventHasStarted.hasEventEnded(widget.event.clossingDay.toDate())) {
//       if (mounted) {
//         setState(() {
//           _eventHasEnded = true;
//         });
//       }
//     }
//   }

//   void _navigateToPage(BuildContext context, Widget page) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => page),
//     );
//   }

//   void _showBottomSheetTermsAndConditions() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//           return Container(
//             height: ResponsiveHelper.responsiveHeight(context, 600),
//             decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(30)),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: ListView(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TicketPurchasingIcon(
//                         title: '',
//                       ),
//                       _checkingTicketAvailability
//                           ? SizedBox(
//                               height: ResponsiveHelper.responsiveHeight(
//                                   context, 10.0),
//                               width: ResponsiveHelper.responsiveHeight(
//                                   context, 10.0),
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 3,
//                                 color: Colors.blue,
//                               ),
//                             )
//                           : MiniCircularProgressButton(
//                               color: Colors.blue,
//                               text: 'Continue',
//                               onPressed: widget.event.ticketSite.isNotEmpty
//                                   ? () {
//                                       Navigator.pop(context);
//                                       _showBottomSheetExternalLink();
//                                     }
//                                   : () async {
//                                       if (mounted) {
//                                         setState(() {
//                                           _checkingTicketAvailability = true;
//                                         });
//                                       }
//                                       await _attendMethod();
//                                       if (mounted) {
//                                         setState(() {
//                                           _checkingTicketAvailability = false;
//                                         });
//                                       }
//                                     })
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Terms and Conditions',
//                           style: Theme.of(context).textTheme.titleMedium,
//                         ),
//                         TextSpan(
//                           text: "\n\n${widget.event.termsAndConditions}",
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),
//                       ],
//                     ),
//                     textScaler: TextScaler.linear(
//                         MediaQuery.of(context).textScaleFactor),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//       },
//     );
//   }

//   _attendMethod() async {
//     var _provider = Provider.of<UserData>(context, listen: false);
//     Provider.of<UserData>(context, listen: false).ticketList.clear();

//     HapticFeedback.lightImpact();
//     if (mounted) {
//       setState(() {
//         _checkingTicketAvailability = true;
//       });
//     }

//     TicketOrderModel? _ticket = await DatabaseService.getTicketWithId(
//         widget.event.id, _provider.currentUserId!);

//     if (_ticket != null) {
//       PaletteGenerator _paletteGenerator =
//           await PaletteGenerator.fromImageProvider(
//         CachedNetworkImageProvider(widget.event.imageUrl, errorListener: (_) {
//           return;
//         }),
//         size: Size(1110, 150),
//         maximumColorCount: 20,
//       );

//       _navigateToPage(
//         context,
//         PurchasedAttendingTicketScreen(
//           ticketOrder: _ticket,
//           event: widget.event,
//           currentUserId: _provider.currentUserId!,
//           justPurchased: 'Already',
//           palette: _paletteGenerator,
//         ),
//       );
//       if (mounted) {
//         setState(() {
//           _checkingTicketAvailability = false;
//         });
//       }
//     } else {
//       if (mounted) {
//         setState(() {
//           _checkingTicketAvailability = false;
//         });
//         _showBottomSheetAttendOptions(context, widget.event);
//       }
//     }
//   }

//   // Ticket options purchase entry
//   void _showBottomSheetAttendOptions(BuildContext context, Event currentEvent) {
//     var _provider = Provider.of<UserData>(context, listen: false);
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context) {
//           final width = MediaQuery.of(context).size.width;
//           List<TicketModel> tickets = currentEvent.ticket;
//           Map<String, List<TicketModel>> ticketsByGroup = {};
//           for (TicketModel ticket in tickets) {
//             if (!ticketsByGroup.containsKey(ticket.group)) {
//               ticketsByGroup[ticket.group] = [];
//             }
//             ticketsByGroup[ticket.group]!.add(ticket);
//           }
//           return Container(
//             height: MediaQuery.of(context).size.height.toDouble() / 1.2,
//             width: width,
//             decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(30)),
//             child: ListView(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: TicketPurchasingIcon(
//                     title: 'Ticket packages.',
//                   ),
//                 ),
//                 TicketGroup(
//                   currentUserId: _provider.currentUserId!,
//                   groupTickets: currentEvent.ticket,
//                   event: currentEvent,
//                   inviteReply: '',
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   void _showBottomSheetExternalLink() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//             height: ResponsiveHelper.responsiveHeight(context, 550),
//             decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(30)),
//             child: WebDisclaimer(
//               link: widget.event.ticketSite,
//               contentType: 'Event ticket',
//               icon: Icons.link,
//             ));
//       },
//     );
//   }

//   void _showBottomEditLocation(
//     BuildContext context,
//   ) {
//     var _provider = Provider.of<UserData>(context, listen: false);
//     var _userLocation = _provider.userLocationPreference;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return ConfirmationPrompt(
//           height: 400,
//           buttonText: 'set up city',
//           onPressed: () async {
//             Navigator.pop(context);
//             _navigateToPage(
//                 context,
//                 EditProfileSelectLocation(
//                   user: _userLocation!,
//                   notFromEditProfile: true,
//                 ));
//           },
//           title: 'Set up your city',
//           subTitle:
//               'To proceed with purchasing a ticket, we kindly ask you to provide your country information. This allows us to handle ticket processing appropriately, as the process may vary depending on different countries. Please note that specifying your city is sufficient, and there is no need to provide your precise location or community details.',
//         );
//       },
//     );
//   }

//   void _showBottomSheetErrorMessage(String title, String subTitle) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return DisplayErrorHandler(
//           buttonText: 'Ok',
//           onPressed: () async {
//             Navigator.pop(context);
//           },
//           title: title,
//           subTitle: subTitle,
//         );
//       },
//     );
//   }

//   _validateAttempt() {
//     var _provider = Provider.of<UserData>(context, listen: false);
//     var _usercountry = _provider.userLocationPreference!.country;
//     bool isGhanaian = _usercountry == 'Ghana' ||
//         _provider.userLocationPreference!.currency == 'Ghana Cedi | GHS';
//     return !isGhanaian
//         ? () {
//             _showBottomSheetErrorMessage(
//                 'This event is currently unavailable in $_usercountry.', '');
//           }
//         : widget.event.termsAndConditions.isNotEmpty
//             ? () {
//                 _showBottomSheetTermsAndConditions();
//               }
//             : () async {
//                 if (widget.event.ticketSite.isNotEmpty) {
//                   _showBottomSheetExternalLink();
//                 } else {
//                   var connectivityResult =
//                       await Connectivity().checkConnectivity();
//                   if (connectivityResult == ConnectivityResult.none) {
//                     _showBottomSheetErrorMessage('No Internet',
//                         'Please connect to the internet and try again.');
//                     return;
//                   } else {
//                     _attendMethod();
//                   }
//                 }
//               };
//   }

//   @override
//   Widget build(BuildContext context) {
//     var _provider = Provider.of<UserData>(context, listen: false);

//     bool isAuthor = _provider.currentUserId == widget.event.authorId;
//     // var _usercountry = _provider.userLocationPreference!.country;
//     String startDate = MyDateFormat.toDate(widget.event.startDate.toDate());
//     String _startDate = startDate.substring(0, startDate.length - 5);
//     List<TicketModel> tickets = widget.event.ticket;
//     double _fristTickePrice = tickets.isNotEmpty ? tickets[0].price : 0.0;
//     final List<String> currencyPartition =
//         widget.event.rate.trim().replaceAll('\n', ' ').split("|");
//     return FocusedMenuAction(
//       onPressedReport: () {
//         isAuthor
//             ? _navigateToPage(
//                 context,
//                 EditEventScreen(
//                   currentUserId: _provider.currentUserId,
//                   event: widget.event,
//                   isCompleted: _eventHasEnded,
//                       isDraft: false,
//                 ),
//               )
//             : _navigateToPage(
//                 context,
//                 ReportContentPage(
//                   contentId: widget.event.id,
//                   parentContentId: widget.event.id,
//                   repotedAuthorId: widget.event.authorId,
//                   contentType: 'event',
//                 ));
//       },
//       onPressedSend: () {
//         _navigateToPage(
//           context,
//           SendToChats(
//             currentUserId: _provider.currentUserId!,
//             sendContentType: 'Event',
//             sendContentId: widget.event.id,
//             sendImageUrl: widget.event.imageUrl,
//             sendTitle: widget.event.title,
//           ),
//         );
//       },
//       onPressedShare: () async {
//         Share.share(widget.event.dynamicLink);
//       },
//       isAuthor: isAuthor,
//       child: GestureDetector(
//         onTap: () {
//           int eventIndex = widget.currentEventList
//               .indexWhere((p) => p.id == widget.event.id);

//           _navigateToPage(
//               context,
//               EventPages(
//                 types: 'All',
//                 event: widget.event,
//                 currentUserId: _provider.currentUserId!,
//                 eventList: widget.currentEventList,
//                 eventSnapshot: widget.currentEventSnapShot,
//                 liveCity: '',
//                 liveCountry: '',
//                 isFrom: '',
//                 sortNumberOfDays: 7,
//                 eventIndex: eventIndex,
//               ));
//         },
//         child: Stack(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0.5),
//               child: Container(
//                 height: ResponsiveHelper.responsiveHeight(
//                   context,
//                   600,
//                 ),
//                 width: ResponsiveHelper.responsiveWidth(
//                   context,
//                   200,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColorLight,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: ResponsiveHelper.responsiveHeight(
//                         context,
//                         200,
//                       ),
//                       width: ResponsiveHelper.responsiveWidth(
//                         context,
//                         200,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         image: DecorationImage(
//                           alignment: Alignment.topCenter,
//                           image: CachedNetworkImageProvider(
//                               widget.event.imageUrl, errorListener: (_) {
//                             return;
//                           }),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.event.title.toUpperCase(),
//                             style: TextStyle(
//                               color: Theme.of(context).secondaryHeaderColor,
//                               fontSize: ResponsiveHelper.responsiveFontSize(
//                                   context, 20.0),
//                               fontWeight: FontWeight.w400,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             widget.event.theme,
//                             style: Theme.of(context).textTheme.bodyMedium,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             _startDate,
//                             style: Theme.of(context).textTheme.bodyMedium,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             widget.event.venue,
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontSize: ResponsiveHelper.responsiveFontSize(
//                                   context, 14.0),
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             "${widget.event.city} ${widget.event.country}",
//                             style: Theme.of(context).textTheme.bodyMedium,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           widget.event.ticketSite.isNotEmpty
//                               ? Icon(
//                                   Icons.link,
//                                   size: ResponsiveHelper.responsiveHeight(
//                                       context, 30.0),
//                                   color: Colors.blue,
//                                 )
//                               : Text(
//                                   widget.event.isFree
//                                       ? 'Free'
//                                       : currencyPartition.length > 1 ||
//                                               widget.event.rate.isNotEmpty
//                                           ? "${currencyPartition[1]}${_fristTickePrice.toString()}"
//                                           : _fristTickePrice.toString(),
//                                   style: TextStyle(
//                                     fontSize:
//                                         ResponsiveHelper.responsiveFontSize(
//                                             context, 14.0),
//                                     color: _eventHasEnded
//                                         ? Colors.grey
//                                         : Colors.blue,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   textAlign: TextAlign.right,
//                                 ),
//                           if (_eventHasStarted)
//                             Text(
//                               _eventHasEnded ? 'Completed' : 'Ongoing',
//                               style: TextStyle(
//                                 fontSize: ResponsiveHelper.responsiveFontSize(
//                                     context, 12.0),
//                                 color:
//                                     _eventHasEnded ? Colors.red : Colors.blue,
//                               ),
//                               textAlign: TextAlign.right,
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             !_eventHasEnded && !isAuthor
//                 ? Positioned(
//                     bottom: 10,
//                     left: 10,
//                     child: AttendButton(
//                       fromThisWeek: true,
//                       marketedAffiliateId: '',
//                       fromFlyier: false,
//                       currentUserId: _provider.currentUserId!,
//                       event: widget.event,
//                     ),
//                   )
//                 : SizedBox.shrink(),

//             // if (!_eventHasEnded)
//             //   if (widget.event.authorId != _provider.currentUserId)
//             //     Positioned(
//             //       bottom: 10,
//             //       child: Padding(
//             //         padding: const EdgeInsets.all(5.0),
//             //         child: Align(
//             //           alignment: Alignment.bottomCenter,
//             //           child: Container(
//             //             width: ResponsiveHelper.responsiveHeight(
//             //               context,
//             //               120,
//             //             ),
//             //             child: OutlinedButton(
//             //               style: OutlinedButton.styleFrom(
//             //                 foregroundColor: Colors.blue,
//             //                 side: BorderSide(
//             //                   width: 0.5,
//             //                   color: Theme.of(context).secondaryHeaderColor,
//             //                 ),
//             //                 shape: RoundedRectangleBorder(
//             //                   borderRadius: BorderRadius.circular(20.0),
//             //                 ),
//             //               ),
//             //               child: Padding(
//             //                 padding: const EdgeInsets.all(10.0),
//             // child: _checkingTicketAvailability
//             //     ? SizedBox(
//             //         height: 15,
//             //         width: 15,
//             //         child: CircularProgressIndicator(
//             //           strokeWidth: 2,
//             //           color: Colors.blue,
//             //         ),
//             //       )
//             //     : Text(
//             //                         'Attend',
//             //                         style: TextStyle(
//             //                           fontSize:
//             //                               ResponsiveHelper.responsiveFontSize(
//             //                                   context, 14.0),
//             //                           color: Theme.of(context)
//             //                               .secondaryHeaderColor,
//             //                         ),
//             //                         overflow: TextOverflow.ellipsis,
//             //                       ),
//             //               ),
//             //               onPressed: _usercountry!.isEmpty
//             //                   ? () {
//             //                       widget.event.isFree
//             //                           ? _attendMethod()
//             //                           : _showBottomEditLocation(context);
//             //                     }
//             //                   : _validateAttempt(),
//             //             ),
//             //           ),
//             //         ),
//             //       ),
//             //     ),
//           ],
//         ),
//       ),
//     );
//   }
// }
