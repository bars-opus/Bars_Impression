// import 'package:bars/utilities/exports.dart';
// import 'package:flutter/cupertino.dart';

// class EventPublicInvite extends StatefulWidget {
//   final Event event;
//   final PaletteGenerator palette;

//   const EventPublicInvite({
//     required this.event,
//     required this.palette,
//   });

//   @override
//   State<EventPublicInvite> createState() => _EventPublicInviteState();
// }

// class _EventPublicInviteState extends State<EventPublicInvite> {
//   int _inviteCount = 0;
//   int _different = 0;

//   @override
//   void initState() {
//     super.initState();
//     _setUpAttendee();
//     _countDown();
//   }

//   _countDown() async {
//     final DateTime date = DateTime.parse(widget.event.date);
//     final toDayDate = DateTime.now();
//     var different = date.difference(toDayDate).inDays;

//     setState(() {
//       _different = different;
//     });
//   }

//   _setUpAttendee() async {
//     DatabaseService.numEventAttendee(widget.event.id, '').listen((inviteCount) {
//       if (mounted) {
//         setState(() {
//           _inviteCount = inviteCount;
//         });
//       }
//     });
//   }

//   _showSelectImageDialog2(
//       BuildContext context, String from, EventInvite eventInvite) {
//     return Platform.isIOS
//         ? _iosBottomSheet2(context, from, eventInvite)
//         : _androidDialog2(context, from, eventInvite);
//   }

//   _iosBottomSheet2(BuildContext context, String from, EventInvite eventInvite) {
//     showCupertinoModalPopup(
//         context: context,
//         builder: (BuildContext context) {
//           return CupertinoActionSheet(
//             title: Text(
//               from.startsWith('Stop')
//                   ? 'Are you sure you want to stop attending this event?'
//                   : 'Are you sure you want to attend this event?',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
//               ),
//             ),
//             actions: <Widget>[
//               CupertinoActionSheetAction(
//                 child: Text(
//                   from.startsWith('Stop') ? 'Stop Attending' : 'Attend',
//                   style: TextStyle(
//                     color: Colors.blue,
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _attend(context, from, eventInvite);
//                 },
//               ),
//             ],
//             cancelButton: CupertinoActionSheetAction(
//               child: Text(
//                 'Cancle',
//                 style: TextStyle(
//                   color: Colors.red,
//                 ),
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//           );
//         });
//   }

//   _androidDialog2(
//       BuildContext parentContext, String from, EventInvite eventInvite) {
//     return showDialog(
//         context: parentContext,
//         builder: (context) {
//           return SimpleDialog(
//             title: Text(
//               from.startsWith('Stop')
//                   ? 'Are you sure you want to stop attending this event?'
//                   : 'Are you sure you want to attend this event?',
//               style: TextStyle(fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             children: <Widget>[
//               Divider(),
//               Center(
//                 child: SimpleDialogOption(
//                   child: Text(
//                     from.startsWith('Stop') ? 'Stop Attending' : 'Attend',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.blue),
//                     textAlign: TextAlign.center,
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     _attend(context, from, eventInvite);
//                   },
//                 ),
//               ),
//               Divider(),
//               Center(
//                 child: SimpleDialogOption(
//                   child: Text(
//                     'Cancel',
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ],
//           );
//         });
//   }

//   _attend(BuildContext context, String from, EventInvite eventInvite) {
//     final double width = MediaQuery.of(context).size.width;
//     try {
//       from.startsWith('Stop')
//           ? DatabaseService.cancelInvite(eventInvite: eventInvite)
//           : DatabaseService.attendEvent(
//               eventDate: DateTime.parse(widget.event.date),
//               message: '',
//               event: widget.event,
//               user: Provider.of<UserData>(context, listen: false).user!,
//               requestNumber: 0.toString(),
//               currentUserId:
//                   Provider.of<UserData>(context, listen: false).currentUserId!);

//       Flushbar(
//         margin: EdgeInsets.all(8),
//         boxShadows: [
//           BoxShadow(
//             color: Colors.black,
//             offset: Offset(0.0, 2.0),
//             blurRadius: 3.0,
//           )
//         ],
//         flushbarPosition: FlushbarPosition.TOP,
//         flushbarStyle: FlushbarStyle.FLOATING,
//         titleText: Text(
//           'Done',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: width > 800 ? 22 : 14,
//           ),
//         ),
//         messageText: Text(
//           from.startsWith('Stop')
//               ? "Event removed from your attending list successfully."
//               : "Event added to your attending list successfully.",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: width > 800 ? 20 : 12,
//           ),
//         ),
//         icon: Icon(
//           MdiIcons.checkCircleOutline,
//           size: 30.0,
//           color: Colors.blue,
//         ),
//         duration: Duration(seconds: 2),
//         leftBarIndicatorColor: Colors.blue,
//       )..show(context);
//     } catch (e) {
//       final double width = Responsive.isDesktop(context)
//           ? 600.0
//           : MediaQuery.of(context).size.width;
//       String error = e.toString();
//       String result = error.contains(']')
//           ? error.substring(error.lastIndexOf(']') + 1)
//           : error;
//       Flushbar(
//         margin: EdgeInsets.all(8),
//         boxShadows: [
//           BoxShadow(
//             color: Colors.black,
//             offset: Offset(0.0, 2.0),
//             blurRadius: 3.0,
//           )
//         ],
//         flushbarPosition: FlushbarPosition.TOP,
//         flushbarStyle: FlushbarStyle.FLOATING,
//         titleText: Text(
//           'Error',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: width > 800 ? 22 : 14,
//           ),
//         ),
//         messageText: Text(
//           result.toString(),
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: width > 800 ? 20 : 12,
//           ),
//         ),
//         icon: Icon(
//           Icons.error_outline,
//           size: 28.0,
//           color: Colors.blue,
//         ),
//         duration: Duration(seconds: 3),
//         leftBarIndicatorColor: Colors.blue,
//       )..show(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = Responsive.isDesktop(context)
//         ? 600.0
//         : MediaQuery.of(context).size.width;
//     return ResponsiveScaffold(
//       child: Container(
//         child: FutureBuilder(
//             future: DatabaseService.getEventAttendeee(widget.event,
//                 Provider.of<UserData>(context, listen: false).currentUserId),
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               if (!snapshot.hasData) {
//                 return Container(
//                   width: width,
//                   height: MediaQuery.of(context).size.height,
//                   color: widget.palette.darkMutedColor == null
//                       ? Color(0xFF1a1a1a)
//                       : widget.palette.darkMutedColor!.color,
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 );
//               }
//               EventInvite _eventInvite = snapshot.data;

//               return  Scaffold(
//                       backgroundColor: widget.palette.darkMutedColor == null
//                           ? Color(0xFF1a1a1a)
//                           : widget.palette.darkMutedColor!.color,
//                       appBar: AppBar(
//                         automaticallyImplyLeading: true,
//                         elevation: 0,
//                         backgroundColor: widget.palette.darkMutedColor == null
//                             ? Color(0xFF1a1a1a)
//                             : widget.palette.darkMutedColor!.color,
//                       ),
//                       body: Padding(
//                         padding: const EdgeInsets.all(30.0),
//                         child: ListView(
//                           children: <Widget>[
//                             Row(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: Icon(
//                                       Icons.event_available,
//                                       color:
//                                           widget.palette.darkMutedColor == null
//                                               ? Color(0xFF1a1a1a)
//                                               : widget.palette.darkMutedColor!
//                                                   .color,
//                                       size: 20.0,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   _eventInvite.anttendeeId.isNotEmpty
//                                       ? 'Attending \nEvent.'
//                                       : 'Attend \nEvent.',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16.0,
//                                       height: 1),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             _different < 1
//                                 ? RichText(
//                                     textScaleFactor:
//                                         MediaQuery.of(context).textScaleFactor,
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text: 'Ongoing...',
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         TextSpan(
//                                           text:
//                                               '\nThis event is in progress. It would be completed on ${MyDateFormat.toDate(DateTime.parse(widget.event.clossingDay))}. Attend, meet and explore.',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   )
//                                 : const SizedBox.shrink(),
//                             _different < 1
//                                 ? const SizedBox(
//                                     height: 10,
//                                   )
//                                 : const SizedBox.shrink(),
//                             ShakeTransition(
//                               child: Material(
//                                 color: Colors.transparent,
//                                 child: Container(
//                                   width: width,
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black26,
//                                           offset: Offset(10, 10),
//                                           blurRadius: 10.0,
//                                           spreadRadius: 4.0,
//                                         )
//                                       ]),
//                                   child: Column(
//                                     children: [
//                                       const SizedBox(
//                                         height: 60,
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 12.0, right: 12),
//                                         child: Text(
//                                           _eventInvite.anttendeeId.isNotEmpty
//                                               ? 'You would be attending ${widget.event.title} at  ${widget.event.venue} on ${MyDateFormat.toDate(DateTime.parse(widget.event.date))} at ${MyDateFormat.toTime(DateTime.parse(widget.event.time))}.'
//                                               : 'This event would be added to the list of events you would be attending. This event is public and you do not need an invitation to attend this event ',
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 12,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             top: 30.0, bottom: 30),
//                                         child: Divider(
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       GestureDetector(
//                                         onTap: () => Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (_) =>
//                                                     EventAttendeesRequested(
//                                                       palette: widget.palette,
//                                                       showAppBar: true,
//                                                       event: widget.event,
//                                                       answer: '',
//                                                       dontShowAnswerWidget:
//                                                           true,
//                                                     ))),
//                                         child: Container(
//                                           width: width,
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 12.0, right: 12),
//                                             child: RichText(
//                                               textScaleFactor:
//                                                   MediaQuery.of(context)
//                                                       .textScaleFactor,
//                                               text: TextSpan(
//                                                 children: [
//                                                   TextSpan(
//                                                     text: 'Invitation type:   ',
//                                                     style: TextStyle(
//                                                       fontSize: 12,
//                                                       color: Colors.grey,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text: 'Public',
//                                                     style: TextStyle(
//                                                       fontSize: 12,
//                                                       color: Colors.black,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text:
//                                                         '\nNumber of people attending:   ',
//                                                     style: TextStyle(
//                                                       fontSize: 12,
//                                                       color: Colors.grey,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text:
//                                                         "${_inviteCount.toString()}",
//                                                     style: TextStyle(
//                                                       fontSize: 12,
//                                                       color: Colors.black,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text:
//                                                         '\nSee people attending:   ',
//                                                     style: TextStyle(
//                                                       fontSize: 12,
//                                                       color: Colors.blue,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 60,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             Container(
//                               width: width,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.white,
//                                   elevation: 0.0,
//                                   foregroundColor: Colors.blue,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 5.0, vertical: 2),
//                                   child: Text(
//                                     _eventInvite.anttendeeId.isNotEmpty
//                                         ? 'Stop Attending'
//                                         : 'Attend',
//                                     style: TextStyle(
//                                       color: Colors.blue,
//                                       fontSize: 12,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 onPressed: () => _showSelectImageDialog2(
//                                     context,
//                                     _eventInvite.anttendeeId.isNotEmpty
//                                         ? 'Stop'
//                                         : '',
//                                     _eventInvite),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 50.0,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//             }),
//       ),
//     );
//   }
// }
