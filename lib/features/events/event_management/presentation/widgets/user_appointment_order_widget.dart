import 'package:bars/features/creatives/presentation/screens/profile/profile_screen.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/material.dart';

class UserAppointmenstWidget extends StatefulWidget {
  final BookingAppointmentModel appointmentOrder;
  final String currentUserId;
  final bool disableMoreVert;
  final List<BookingAppointmentModel> appointmentList;

  const UserAppointmenstWidget({
    required this.appointmentOrder,
    required this.currentUserId,
    required this.appointmentList,
    this.disableMoreVert = false,
  });

  @override
  State<UserAppointmenstWidget> createState() => _UserAppointmenstWidgetState();
}

class _UserAppointmenstWidgetState extends State<UserAppointmenstWidget> {
  bool _isLoading = false;

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetErrorMessage(String title) {
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
          title: title,
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  _launchMap(String address) {
    return MapsLauncher.launchQuery(address);
  }

  void _showBottomSheetDeleteAppointment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 300,
          buttonText: 'Delete appointment',
          onPressed: () async {
            Navigator.pop(context);

            try {
              String id = widget.appointmentOrder.id;

              widget.appointmentList.removeWhere((ticket) => ticket.id == id);
              await DatabaseService.deleteAppointment(
                  appointmentOrder: widget.appointmentOrder);
              setState(() {});
            } catch (e) {
              _showBottomSheetErrorMessage('Failed to delete appointment');
            }
            mySnackBar(context, "Appointment deleted successfully");
          },
          title: 'Are you sure you want to delete this appointment? ',
          subTitle:

              //  widget.appointmentOrder.total != 0 &&
              //         widget.appointmentOrder.refundRequestStatus != 'processed'
              //     ? 'Deleting this ticket will result in the loss of access to this event and it\'s room. Deleted tickets would be refunded."'
              //     :

              '',
        );
      },
    );
  }

  void _showBottomSheetMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 370.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    widget.appointmentOrder.shopName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  height: ResponsiveHelper.responsiveHeight(context, 250.0),
                  // color: Colors.red,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 2),
                      child: MyBottomModelSheetAction(actions: [
                        const SizedBox(
                          height: 40,
                        ),
                        Stack(
                          alignment: FractionalOffset.center,
                          children: [
                            BottomModelSheetListTileActionWidget(
                              colorCode: '',
                              icon: Icons.store_mall_directory_outlined,
                              onPressed: () async {
                                // _isLoading = true;
                                // try {
                                //   Event? event = await DatabaseService
                                //       .getUserEventWithId(
                                //           widget.appointmentOrder.eventId,
                                //           widget.appointmentOrder
                                //               .eventAuthorId);

                                //   if (event != null) {
                                _navigateToPage(ProfileScreen(
                                  currentUserId: widget.currentUserId,
                                  userId: widget.appointmentOrder.shopId,
                                  user: null,
                                  accountType: 'Shop',
                                ));
                                //   } else {
                                //     _showBottomSheetErrorMessage(
                                //         'Failed to fetch event.');
                                //   }
                                // } catch (e) {
                                //   _showBottomSheetErrorMessage(
                                //       'Failed to fetch event');
                                // } finally {
                                //   _isLoading = false;
                                // }
                              },
                              text: 'View shop',
                            ),
                            _isLoading
                                ? Positioned(
                                    right: 30,
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                        Stack(
                          alignment: FractionalOffset.center,
                          children: [
                            BottomModelSheetListTileActionWidget(
                              colorCode: '',
                              icon: Icons.location_on_outlined,
                              onPressed: () async {
                                // _isLoading = true;
                                // try {
                                //   Event? event = await DatabaseService
                                //       .getUserEventWithId(
                                //           widget.appointmentOrder.eventId,
                                //           widget.appointmentOrder
                                //               .eventAuthorId);
                                //   if (event != null) {
                                _launchMap(widget.appointmentOrder.location);
                                //   } else {
                                //     _showBottomSheetErrorMessage(
                                //         'Failed to launch map.');
                                //   }
                                // } catch (e) {
                                //   _showBottomSheetErrorMessage(
                                //       'Failed to launch map');
                                // } finally {
                                //   _isLoading = false;
                                // }
                              },
                              text: 'Acces location',
                            ),
                            _isLoading
                                ? Positioned(
                                    right: 30,
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                        BottomModelSheetListTileActionWidget(
                          colorCode: '',
                          icon: Icons.delete_outlined,
                          onPressed: () {
                            _showBottomSheetDeleteAppointment();
                          },
                          text: 'Delete ticket',
                        ),
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      _navigateToPage(CompainAnIssue(
                        parentContentId: widget.appointmentOrder.id,
                        authorId: widget.currentUserId,
                        complainContentId: widget.appointmentOrder.id,
                        complainType: 'TicketOrder',
                        parentContentAuthorId: widget.appointmentOrder.clientId,
                      ));
                    },
                    child: Text(
                      'Complain an issue.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  void _showBottomAppointmentDetails() {
    var _provider = Provider.of<UserData>(context, listen: false);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 640),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(30)),
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10),
                  child: TicketPurchasingIcon(
                    title: '',
                  ),
                ),
                BookingSummaryWidget(
                  edit: false,
                  currency: _provider.userLocationPreference!.currency!,
                  appointmentOrder: widget.appointmentOrder,
                ),
              ]));
        });
  }

  _divider() {
    return Divider(
      thickness: .3,
      // height: 4,
      color: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> datePartition =
        widget.appointmentOrder.bookingDate == null
            ? MyDateFormat.toDate(DateTime.now()).split(" ")
            : MyDateFormat.toDate(widget.appointmentOrder.bookingDate.toDate())
                .split(" ");

    final services = widget.appointmentOrder.appointment
        .map((slot) => slot.type)
        .toSet() // Use a set to ensure uniqueness
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () {
          _showBottomAppointmentDetails();
        },
        child: Card(
          elevation: 0,
          color: Theme.of(context).cardColor.withOpacity(.5),
          // Colors.blue.shade50,
          surfaceTintColor: Colors.transparent,
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Adjust the radius as needed
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.appointmentOrder.shopLogoUrl.isEmpty
                        ? const Icon(
                            Icons.account_circle,
                            size: 30.0,
                            color: Colors.grey,
                          )
                        : CircleAvatar(
                            radius: 15.0,
                            backgroundColor: Colors.blue,
                            backgroundImage: CachedNetworkImageProvider(
                                widget.appointmentOrder.shopLogoUrl,
                                errorListener: (_) {
                              return;
                            }),
                          ),
                    SizedBox(
                      width: ResponsiveHelper.responsiveWidth(context, 10.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.appointmentOrder.shopName
                                .replaceAll('\n', ' '),
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.appointmentOrder.shopType,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 10.0),
                              color: Colors.blue,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showBottomSheetMore(context);
                      },
                      child: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ],
                ),
                _divider(),
                Text(
                  MyDateFormat.toDate(
                      widget.appointmentOrder.bookingDate.toDate()),
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                // _payoutWidget(
                //     'Date',
                //     MyDateFormat.toDate(
                //         widget.appointmentOrder.bookingDate.toDate())),
                // _payoutWidget(
                //   'Location',
                //   widget.appointmentOrder!.location,
                // ),
                _divider(),

                SizedBox(
                  height: ResponsiveHelper.responsiveFontSize(context, 30),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          // width:
                          //     ResponsiveHelper.responsiveFontSize(context, 100),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: Text(
                              services[index],
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ListTile(
          //   trailing: _isLoading
          //       ? SizedBox(
          //           height: ResponsiveHelper.responsiveHeight(context, 20),
          //           width: ResponsiveHelper.responsiveHeight(context, 20),
          //           child: CircularProgressIndicator(
          //             strokeWidth: 3,
          //             color: Colors.blue,
          //           ),
          //         )
          //       : Container(
          //           width: ResponsiveHelper.responsiveWidth(context, 70),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.end,
          //             children: [
          //               // if (widget.appointmentOrder.isDeleted)
          //               //   //     ?
          //               //   Icon(
          //               //     Icons.remove_outlined,
          //               //     color: Colors.grey,
          //               //     size: 20.0,
          //               //   ),
          //               // : SizedBox.shrink(),
          //               if (!widget.disableMoreVert)
          // IconButton(
          //     onPressed: () {
          //       _showBottomSheetMore(context);
          //     },
          //     icon: Icon(
          //       Icons.more_vert,
          //       color: Theme.of(context).secondaryHeaderColor,
          //     )),
          //             ],
          //           ),
          //         ),
          // onTap: () {
          //   _showBottomAppointmentDetails();
          //     // print(widget.appointmentOrder.eventAuthorId );
          //     // if (_isLoading) return;
          //     // _isLoading = true;
          //     // try {
          //     //   Event? event = await DatabaseService.getUserEventWithId(
          //     //       widget.appointmentOrder.eventId,
          //     //       widget.appointmentOrder.eventAuthorId);

          //     //   if (event != null) {
          //     //     PaletteGenerator _paletteGenerator =
          //     //         await PaletteGenerator.fromImageProvider(
          //     //       CachedNetworkImageProvider(event.imageUrl,
          //     //           errorListener: (_) {
          //     //         return;
          //     //       }),
          //     //       size: Size(1110, 150),
          //     //       maximumColorCount: 20,
          //     //     );

          //     //     _navigateToPage(
          //     //       PurchasedAttendingTicketScreen(
          //     //         appointmentOrder: widget.appointmentOrder,
          //     //         event: event,
          //     //         currentUserId: widget.currentUserId,
          //     //         justPurchased: '',
          //     //         palette: _paletteGenerator,
          //     //       ),
          //     //     );
          //     //   } else {
          //     //     _showBottomSheetErrorMessage('Failed to fetch event.');
          //     //   }
          //     // } catch (e) {
          //     //   _showBottomSheetErrorMessage('Failed to fetch event');
          //     // } finally {
          //     //   _isLoading = false;
          //     // }
          //   },
          //   leading: CountdownTimer(
          //     fontSize: ResponsiveHelper.responsiveFontSize(context, 11.0),
          //     split: 'Multiple',
          //     color: Theme.of(context).secondaryHeaderColor,
          //     clossingDay: DateTime.now(),
          //     startDate: widget.appointmentOrder.bookingDate!.toDate(),
          //     eventHasEnded: false,
          //     eventHasStarted: false,
          //   ),
          //   title: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Text(
          //         widget.appointmentOrder.shopName.toUpperCase(),
          //         style: TextStyle(
          //           fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
          //           fontWeight: FontWeight.bold,
          //           color: Theme.of(context).secondaryHeaderColor,
          //         ),
          //         overflow: TextOverflow.ellipsis,
          //       ),
          //       Text(
          //         "${datePartition[2]} ${datePartition[1]} ${datePartition[0]}",
          //         style: TextStyle(
          //           fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
          //           fontWeight: FontWeight.normal,
          //           color: Theme.of(context).secondaryHeaderColor,
          //         ),
          //         overflow: TextOverflow.ellipsis,
          //       ),
          //       Text(
          //         "${datePartition[2]} ${datePartition[1]} ${datePartition[0]}",
          //         style: TextStyle(
          //           fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
          //           fontWeight: FontWeight.normal,
          //           color: Theme.of(context).secondaryHeaderColor,
          //         ),
          //         overflow: TextOverflow.ellipsis,
          //       ),
          //       Text(
          //         "${datePartition[2]} ${datePartition[1]} ${datePartition[0]}",
          //         style: TextStyle(
          //           fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
          //           fontWeight: FontWeight.normal,
          //           color: Theme.of(context).secondaryHeaderColor,
          //         ),
          //         overflow: TextOverflow.ellipsis,
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
