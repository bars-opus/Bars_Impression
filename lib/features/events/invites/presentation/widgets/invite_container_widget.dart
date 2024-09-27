// import 'package:bars/utilities/exports.dart';

// class InviteContainerWidget extends StatefulWidget {
//   final InviteModel invite;
//   const InviteContainerWidget({
//     Key? key,
//     required this.invite,
//   }) : super(key: key);

//   @override
//   _InviteContainerWidgetState createState() => _InviteContainerWidgetState();
// }

// class _InviteContainerWidgetState extends State<InviteContainerWidget> {
//   bool _isLoading = false;

//   // This method shows a bottom sheet with an error message.
// // It uses the showModalBottomSheet function to display a DisplayErrorHandler widget, which shows
// // the message "Request failed" along with a button for dismissing the bottom sheet.
//   void _showBottomSheetErrorMessage(String title) {
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
//           subTitle: 'Please check your internet connection and try again.',
//         );
//       },
//     );
//   }

//   void _showBottomSheetCannotViewInvite() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: ResponsiveHelper.responsiveHeight(context, 300),
//           decoration: BoxDecoration(
//               color: Theme.of(context).cardColor,
//               borderRadius: BorderRadius.circular(30)),
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               DisclaimerWidget(
//                 title: 'Private',
//                 subTitle:
//                     'For privacy and security reasons, it is not possible to view another person\'s invitation.',
//                 icon: Icons.lock,
//               ),
//               const SizedBox(height: 40),
//               // PortfolioContactWidget(
//               //   portfolios: bookingUser.contacts,
//               //   edit: false,
//               // ),
//               const SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // This method navigates to a new page. It takes the BuildContext and the Widget for the new page as parameters
//   // and uses the Navigator.push function to navigate to the new page.
//   void _navigateToPage(Widget page) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => page),
//     );
//   }

//   void _showBottomDeletedEvent() {
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context) {
//           return Container(
//               height: ResponsiveHelper.responsiveHeight(context, 700.0),
//               decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   borderRadius: BorderRadius.circular(30)),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
//                 child: ListView(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TicketPurchasingIcon(
//                           title: '',
//                         ),
//                         Text(
//                           ' Deleted',
//                           style: TextStyle(
//                               fontSize: ResponsiveHelper.responsiveFontSize(
//                                   context, 20),
//                               color: Colors.grey,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     RichText(
//                       textScaler: MediaQuery.of(context).textScaler,
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: widget.invite.eventTitle,
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                           TextSpan(
//                             text:
//                                 "\n\We apologize for the inconvenience, but we regret to inform you that the event: ${widget.invite.eventTitle} has been deleted by the organizer. We understand the impact this may have, and we sincerely apologize for any inconvenience caused.",
//                             style: Theme.of(context).textTheme.bodyMedium,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                         height: ResponsiveHelper.responsiveHeight(context, 30)),
//                     const SizedBox(height: 60),
//                   ],
//                 ),
//               ));
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     var _provider = Provider.of<UserData>(context);
//     bool isCurrentUser = widget.invite.inviteeId == _provider.currentUserId;
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: GestureDetector(
//         onTap: !isCurrentUser
//             ? () {
//                 _showBottomSheetCannotViewInvite();
//               }
//             : widget.invite.isDeleted
//                 ? () {
//                     _showBottomDeletedEvent();
//                   }
//                 : () async {
//                     if (mounted) if (_isLoading) return;
//                     _isLoading = true;
//                     try {
//                       Event? event = await DatabaseService.getUserEventWithId(
//                           widget.invite.eventId, widget.invite.inviterId);

//                       TicketOrderModel? _ticket =
//                           await DatabaseService.getTicketWithId(
//                               widget.invite.eventId, _provider.currentUserId!);

//                       if (event != null) {
//                         PaletteGenerator _paletteGenerator =
//                             await PaletteGenerator.fromImageProvider(
//                           CachedNetworkImageProvider(event.imageUrl,
//                               errorListener: (_) {
//                             return;
//                           }),
//                           size: Size(1110, 150),
//                           maximumColorCount: 20,
//                         );
//                         _navigateToPage(EventInviteScreen(
//                           currentUserId: _provider.currentUserId!,
//                           event: event,
//                           invite: widget.invite,
//                           palette: _paletteGenerator,
//                           ticketOrder: _ticket,
//                         ));
//                       } else {
//                         _showBottomSheetErrorMessage('Failed to fetch event.');
//                       }
//                     } catch (e) {
//                       // print('Failed to fetch user data: $e');
//                       _showBottomSheetErrorMessage('Failed to fetch invite.');
//                     } finally {
//                       _isLoading = false;
//                     }
//                   },
//         child: Container(
//           padding: EdgeInsets.only(top: 5),
//           width: width,
//           height: ResponsiveHelper.responsiveHeight(context, 140.0),
//           decoration: BoxDecoration(
//               color: widget.invite.answer.isEmpty
//                   ? Theme.of(context).primaryColorLight
//                   : Colors.transparent,
//               borderRadius: BorderRadius.circular(5),
//               boxShadow: [
//                 BoxShadow(
//                   color: widget.invite.answer.isEmpty
//                       ? Colors.black26
//                       : Colors.transparent,
//                   offset: Offset(10, 10),
//                   blurRadius: 10.0,
//                   spreadRadius: 4.0,
//                 )
//               ]),
//           child: ListTile(
//             leading: _isLoading
//                 ? SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 3,
//                       color: Colors.blue,
//                     ),
//                   )
//                 : widget.invite.isDeleted
//                     ? Icon(
//                         Icons.remove,
//                         color: Colors.grey,
//                         size: ResponsiveHelper.responsiveHeight(context, 25.0),
//                       )
//                     : Icon(
//                         widget.invite.answer.startsWith('Accepted')
//                             ? MdiIcons.carOutline
//                             : widget.invite.answer.startsWith('Rejected')
//                                 ? MdiIcons.cancel
//                                 : Icons.mail_outline_rounded,
//                         color: Theme.of(context).secondaryHeaderColor,
//                         size: ResponsiveHelper.responsiveHeight(context, 25.0),
//                       ),
//             title: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.invite.eventTitle!.toUpperCase(),
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'CORDIALLY INVITED  ',
//                       style: TextStyle(
//                           fontSize: ResponsiveHelper.responsiveFontSize(
//                               context, 12.0),
//                           color: Colors.blue,
//                           fontWeight: FontWeight.normal),
//                     ),
//                     Text(
//                       widget.invite.answer,
//                       style: TextStyle(
//                           fontSize: ResponsiveHelper.responsiveFontSize(
//                               context, 12.0),
//                           color: widget.invite.answer.startsWith('Accepted')
//                               ? Colors.blue
//                               : Colors.red),
//                     ),
//                   ],
//                 ),
//                 RichText(
//                   textScaler: MediaQuery.of(context).textScaler,
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: '${widget.invite.generatedMessage}',
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                     ],
//                   ),
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.start,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
