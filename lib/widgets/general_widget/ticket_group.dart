import 'package:bars/features/events/services/paystack_ticket_payment.dart';
import 'package:bars/utilities/exports.dart';
import 'package:bars/widgets/general_widget/ticket_group_widget.dart';
import 'package:bars/widgets/general_widget/ticket_purchase_summary_widget.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/scheduler.dart';

import 'package:uuid/uuid.dart';

class TicketGroup extends StatefulWidget {
  final List<TicketModel> groupTickets;
  final Event? event;
  final String currentUserId;
  final String inviteReply;
  final bool onInvite;

  TicketGroup({
    required this.groupTickets,
    required this.event,
    required this.currentUserId,
    required this.inviteReply,
    this.onInvite = false,
  });

  @override
  State<TicketGroup> createState() => _TicketGroupState();
}

class _TicketGroupState extends State<TicketGroup> {
  int _selectedSeat = 0;
  int _selectedRow = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).ticketList.clear();
    });
  }

  void _showBottomSheetErrorMessage(BuildContext context, String error) {
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
          title: 'Process failed',
          subTitle: error,
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

  void _showBottomSheetLoading() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomModalLoading(
          title: 'Generating ticket',
        );
      },
    );
  }

  void _generateTickets(
    // TicketModel? purchasintgTickets,
    String purchaseReferenceId,
    String transactionId,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    var _user = _provider.user;

    _showBottomSheetLoading();
    List<TicketModel> _finalTicket =
        // widget.event!.isFree ? [] :
        _provider.ticketList;
    // if (purchasintgTickets != null &&
    //     purchasintgTickets is TicketPurchasedModel) {
    //   _finalTicket.add(purchasintgTickets);
    // }

    Future<T> retry<T>(Future<T> Function() function, {int retries = 3}) async {
      Duration delay =
          const Duration(milliseconds: 100); // Start with a short delay

      for (int i = 0; i < retries; i++) {
        try {
          return await function();
        } catch (e) {
          if (i == retries - 1) {
            // Don't delay after the last attempt
            rethrow;
          }

          await Future.delayed(delay);
          delay *= 2; // Double the delay for the next attempt
        }
      }

      throw Exception('Failed after $retries attempts');
    }

    FirebaseFirestore.instance.runTransaction((transaction) async {
      try {
        // Check if the ticket order already exists to ensure idempotency
        bool existingOrder = await DatabaseService.isTicketOrderAvailable(
          transaction: transaction,
          userOrderId: widget.currentUserId,
          eventId: widget.event!.id,
        );

        if (!existingOrder) {
          String commonId = Uuid().v4();

          Future<void> sendInvites() =>
              DatabaseService.answerEventInviteTransaction(
                transaction: transaction,
                event: widget.event!,
                answer: widget.inviteReply,
                currentUser: _user!,
              );

          Future<TicketOrderModel> createTicketOrder() => _createTicketOrder(
              transactionId,
              transaction,
              commonId,
              _finalTicket,
              purchaseReferenceId);

          if (widget.inviteReply.isNotEmpty) {
            await retry(() => sendInvites(), retries: 3);
          }

          TicketOrderModel order =
              await retry(() => createTicketOrder(), retries: 3);
          if (!widget.event!.isFree || !widget.event!.isCashPayment) {
            Navigator.pop(context);
            // await Future.delayed(Duration(milliseconds: 700));
            Navigator.pop(context);
            // await Future.delayed(Duration(milliseconds: 700));
          }
          if (widget.event!.termsAndConditions.isNotEmpty) {
            Navigator.pop(context);
            // await Future.delayed(Duration(milliseconds: 700));
          }

          // Navigator.pop(context);
          Navigator.pop(context);
          PaletteGenerator _paletteGenerator =
              await PaletteGenerator.fromImageProvider(
            CachedNetworkImageProvider(widget.event!.imageUrl),
            size: Size(1110, 150),
            maximumColorCount: 20,
          );

          _navigateToPage(
            context,
            PurchasedAttendingTicketScreen(
              ticketOrder: order,
              event: widget.event!,
              currentUserId: widget.currentUserId,
              justPurchased: 'New',
              palette: _paletteGenerator,
            ),
          );
          mySnackBar(context, ' Ticket purchased succesfully');
        } else {
          if (!widget.event!.isFree || !widget.event!.isCashPayment) {
            Navigator.pop(context);
            // await Future.delayed(Duration(milliseconds: 700));
            Navigator.pop(context);
            // await Future.delayed(Duration(milliseconds: 700));
          }
          if (widget.event!.termsAndConditions.isNotEmpty) {
            Navigator.pop(context);
            // await Future.delayed(Duration(milliseconds: 700));
          }
          // Navigator.pop(context);
          mySnackBar(context, ' Ticket is already available');
        }
      } catch (e) {
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        Navigator.pop(context);
        _showBottomSheetErrorMessage(context, result);
      } finally {}
    });
  }

  Future<TicketOrderModel> _createTicketOrder(
      String transactionId,
      Transaction transaction,
      String commonId,
      List<TicketModel> _finalTicket,
      String purchaseReferenceId) async {
    var _user = Provider.of<UserData>(context, listen: false).user;

    double total = _finalTicket.fold(0, (acc, ticket) => acc + ticket.price);

    List<TicketPurchasedModel> _purchasedTickets =
        _finalTicket.map((ticketModel) {
      // Use the fromTicketModel method to convert
      return TicketPurchasedModel.fromTicketModel(
        ticketModel: ticketModel,
        entranceId: Uuid().v4(),
        validated: false,
        row: _selectedRow,
        seat: _selectedSeat,
        refundRequestStatus: '',
        idempotencyKey: '',
        transactionId: transactionId,
      );
    }).toList();

    TicketOrderModel order = TicketOrderModel(
      orderId: commonId,
      tickets:
          // widget.event!.isFree ? [] :
          _purchasedTickets,
      total: total,
      canlcellationReason: '',
      eventAuthorId: widget.event!.authorId,

      // entranceId: '',
      eventId: widget.event!.id,
      eventImageUrl: widget.event!.imageUrl,
      eventTimestamp: widget.event!.startDate,
      isInvited: widget.inviteReply.isNotEmpty ? true : false,
      timestamp: Timestamp.now(),
      orderNumber: commonId,
      // validated: false,
      userOrderId: widget.currentUserId,
      eventTitle: widget.event!.title,
      purchaseReferenceId: purchaseReferenceId,
      refundRequestStatus: '',
      idempotencyKey: '',

      transactionId: transactionId, isDeleted: false,
    );

    widget.event!.ticketOrder.add(order);
    await DatabaseService.purchaseTicketTransaction(
        transaction: transaction,
        ticketOrder: order,
        user: _user!,
        purchaseReferenceId: purchaseReferenceId,
        eventAuthorId: widget.event!.authorId);

    return order;
  }

  _payForTicket() async {
    HapticFeedback.lightImpact();
    Navigator.pop(context);
    var _provider = Provider.of<UserData>(context, listen: false);

    double totalPrice = _provider.ticketList
        .fold(0.0, (double sum, TicketModel ticket) => sum + ticket.price);

    MakePayment makePayment = MakePayment(
      context: context,
      price: totalPrice.toInt(),
      email: FirebaseAuth.instance.currentUser!.email!,
      event: widget.event!,
      subaccountId: widget.event!.subaccountId,
    );
    PaymentResult paymentResult = await makePayment.chargeCardAndMakePayMent();

// If the initial Paystack payment is successful, verify it server-side
    if (paymentResult.success) {
      // _provider.setIsLoading(true);
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('verifyPaystackPayment');
      try {
        final verificationResult = await callable.call(<String, dynamic>{
          'reference': paymentResult.reference,
          'eventId': widget.event!.id,
          'amount': totalPrice.toInt() *
              100, // Assuming this is the correct amount in kobo
        });

        // If server-side verification is successful, generate tickets
        if (verificationResult.data['success']) {
          FocusScope.of(context).unfocus();
          var transactionId =
              verificationResult.data['transactionData']['id'].toString();
          // Reference to the Firestore collection where event invites are stored
          CollectionReference eventInviteCollection = FirebaseFirestore.instance
              .collection('newEventTicketOrder')
              .doc(widget.event!.id)
              .collection('eventInvite');

          // Query for the existing ticket
          QuerySnapshot ticketRecordSnapshot = await eventInviteCollection
              .where('purchaseReferenceId', isEqualTo: paymentResult.reference)
              .get();

          // Check if the ticket record exists
          if (ticketRecordSnapshot.docs.isEmpty) {
            // No ticket found for this payment reference, so we can generate tickets
            _generateTickets(paymentResult.reference, transactionId.toString());
            // Proceed with any additional steps such as updating the user's tickets
          } else {
            // _provider.setIsLoading(false);
            // A ticket has already been generated for this payment reference
            _showBottomSheetErrorMessage(context,
                'Tickets have already been generated for this payment.');
          }

          // _generateTickets(finalPurchasintgTicket, paymentResult.reference);
        } else {
          // _provider.setIsLoading(false);
          _showBottomSheetErrorMessage(
              context, 'Couldn\'t verify your ticket payment');
          // Handle verification failure
          // Show some error to the user or log for further investigation
        }
      } catch (e) {
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        Navigator.pop(context);
        _showBottomSheetErrorMessage(context, result);
        // Handle errors from calling the Cloud Function
        // Again, show an error message or log the error
      }
    } else {
      // _provider.setIsLoading(false);
      _showBottomSheetErrorMessage(
          context, 'Couldn\'t pay for ticket please try again');
      // Handle Paystack payment failure
      // Inform the user that the payment process was not successful
    }
    // _provider.setIsLoading(false);
  }

  void _showBottomConfirmTicketAddOrder(
    BuildContext context,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height:
              widget.event!.isFree || widget.event!.isCashPayment ? 300 : 320,
          buttonText: widget.event!.isFree || widget.event!.isCashPayment
              ? 'Generate Ticket'
              : 'Purchase Ticket',
          onPressed: widget.event!.isFree || widget.event!.isCashPayment
              ? () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  _generateTickets('', '');
                }
              :
              //
              () async {
                  _payForTicket();

//
                },
          title: widget.event!.isFree || widget.event!.isCashPayment
              ? 'Are you sure you want to proceed and generate a ticket?'
              : 'Are you sure you want to proceed and purchase this tickets?',
          subTitle: widget.event!.termsAndConditions.isNotEmpty
              ? 'By purchasing or generating a ticket to this event, you have accepted the terms and conditions that govern this event as provided by the event organizer.'
              : widget.event!.isCashPayment
                  ? 'The payment method for this ticket is cash. Therefore, you will be required to pay for the ticket at the event venue. For further clarification or more information, please contact the event organizer'
                  : '',
        );
      },
    );
  }

  void _showBottomTicketSite(
    BuildContext context,
    String link,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 600),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DisclaimerWidget(
                  title: 'Ticket Site',
                  subTitle:
                      'You will be redirected to a website provided by the event organizer, where you can continue with the ticket purchasing process. Please note that Bars Impression assumes no liability or responsibility for the information, views, or opinions presented on that platform.',
                  icon: Icons.link,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              BottomModalSheetButtonBlue(
                buttonText: 'Access ticket site',
                onPressed: () async {
                  if (!await launchUrl(Uri.parse(link))) {
                    throw 'Could not launch link';
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => MyWebView(
                  //               url: link,
                  //               title: '',
                  //             )));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _eventOnTicketAndPurchaseButton() {
    var _provider = Provider.of<UserData>(
      context,
    );
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight.withOpacity(.6),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EventOnTicketWidget(
              event: widget.event!,
              // finalPurchasintgTicket: finalPurchasintgTicket,
              currentUserId: widget.currentUserId,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Divider(),
        const SizedBox(
          height: 40,
        ),
        _provider.isLoading
            ? SizedBox(
                height: ResponsiveHelper.responsiveHeight(context, 30),
                width: ResponsiveHelper.responsiveHeight(context, 30),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              )
            : Center(
                child: widget.event!.ticketSite.isNotEmpty
                    ? AlwaysWhiteButton(
                        buttonText: 'Go to ticket site',
                        onPressed: () {
                          _showBottomTicketSite(
                              context, widget.event!.ticketSite);

                          // Navigator.pop(context);
                        },
                        buttonColor: Colors.blue,
                      )
                    : AlwaysWhiteButton(
                        buttonText: widget.event!.isFree
                            ? 'Generate free ticket'
                            : widget.event!.isCashPayment
                                ? 'Generate ticket'
                                : 'Purchase ticket',
                        onPressed: () {
                          // Navigator.pop(context);
                          _showBottomConfirmTicketAddOrder(
                            context,
                          );
                        },
                        buttonColor: Colors.blue,
                      ),
              ),
      ],
    );
  }

  void _showBottomFinalPurhcaseSummary(
    BuildContext context,
  ) {
    // var _textStyle = TextStyle(
    //   fontSize:  ResponsiveHelper.responsiveFontSize( context, 16),
    //   color: Colors.grey,
    // );
    var _provider = Provider.of<UserData>(context, listen: false);

    double totalPrice = _provider.ticketList
        .fold(0.0, (double sum, TicketModel ticket) => sum + ticket.price);

    final List<String> currencyPartition =
        widget.event!.rate.trim().replaceAll('\n', ' ').split("|");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 670),
          // MediaQuery.of(context).size.height.toDouble() / 1.2 - 30,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TicketPurchasingIcon(
                      // icon: Icons.payment,
                      title: 'Payment.',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Center(
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: currencyPartition.length > 0
                                    ? " ${currencyPartition[1]}\n"
                                    : '',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              TextSpan(
                                text: totalPrice.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              )
                            ],
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),

                TicketPurchaseSummaryWidget(),
                // TicketInfo(
                //   event: widget.event!,
                //   // finalPurchasintgTicket: finalPurchasintgTicket,
                //   label: 'Category',
                //   position: 'First',
                //   value: finalPurchasintgTicket.group,
                // ),
                // if (finalPurchasintgTicket.type.isNotEmpty)
                //   TicketInfo(
                //     event: widget.event!,
                //     // finalPurchasintgTicket: finalPurchasintgTicket,

                //     // finalPurchasintgTicket.type,
                //     label: 'Type',
                //     position: '',
                //     value: finalPurchasintgTicket.type,
                //   ),
                // if (finalPurchasintgTicket.accessLevel.isNotEmpty)
                //   TicketInfo(
                //     event: widget.event!,
                //     // finalPurchasintgTicket: finalPurchasintgTicket,
                //     label: 'Access level',
                //     position: '',
                //     value: finalPurchasintgTicket.accessLevel,
                //     // 'Access level',
                //     // finalPurchasintgTicket.accessLevel,
                //   ),
                // TicketInfo(
                //   event: widget.event!,
                //   // finalPurchasintgTicket: finalPurchasintgTicket,
                //   label: 'Price',
                //   position: 'Last',
                //   value: finalPurchasintgTicket.price.toString(),

                // ),

                const SizedBox(
                  height: 10,
                ),
                Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Currency:   ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: currencyPartition.length > 0
                              ? " ${currencyPartition[0]}\n"
                              : '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: "Total:            ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: totalPrice.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Divider(),
                const SizedBox(
                  height: 20,
                ),
                _eventOnTicketAndPurchaseButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  // _packageInfoContainer(Widget child, String position) {
  // return Expanded(
  //   child: Padding(
  //     padding: const EdgeInsets.all(0.5),
  //     child: Container(
  //       decoration: BoxDecoration(
  //           color: Theme.of(context).primaryColor.withOpacity(.5),
  //           borderRadius: position.startsWith('First')
  //               ? BorderRadius.only(
  //                   bottomRight: Radius.circular(0.0),
  //                   topRight: Radius.circular(10.0),
  //                   bottomLeft: Radius.circular(0.0),
  //                   topLeft: Radius.circular(10.0),
  //                 )
  //               : position.startsWith('Last')
  //                   ? BorderRadius.only(
  //                       bottomRight: Radius.circular(10.0),
  //                       topRight: Radius.circular(0.0),
  //                       bottomLeft: Radius.circular(10.0),
  //                       topLeft: Radius.circular(0.0),
  //                     )
  //                   : BorderRadius.only(
  //                       bottomRight: Radius.circular(0.0),
  //                       topRight: Radius.circular(0.0),
  //                       bottomLeft: Radius.circular(0.0),
  //                       topLeft: Radius.circular(0.0),
  //                     )),
  //       child: child,
  //     ),
  //   ),
  // );
  // }

  // _packageInfo(String label, String value, String position) {
  // return Align(
  //     alignment: Alignment.center,
  //     child: Row(
  //       children: [
  //         Container(
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).primaryColor.withOpacity(.5),
  //               borderRadius: position.startsWith('First')
  //                   ? BorderRadius.only(
  //                       bottomRight: Radius.circular(0.0),
  //                       topRight: Radius.circular(10.0),
  //                       bottomLeft: Radius.circular(0.0),
  //                       topLeft: Radius.circular(10.0),
  //                     )
  //                   : position.startsWith('Last')
  //                       ? BorderRadius.only(
  //                           bottomRight: Radius.circular(10.0),
  //                           topRight: Radius.circular(0.0),
  //                           bottomLeft: Radius.circular(10.0),
  //                           topLeft: Radius.circular(0.0),
  //                         )
  //                       : BorderRadius.only(
  //                           bottomRight: Radius.circular(0.0),
  //                           topRight: Radius.circular(0.0),
  //                           bottomLeft: Radius.circular(0.0),
  //                           topLeft: Radius.circular(0.0),
  //                         )),
  //           width: 110,
  //           child: Padding(
  //             padding: const EdgeInsets.all(12.0),
  //             child: Text(
  //               label,
  //               style: TextStyle(
  //                ResponsiveHelper.responsiveFontSize( context, 12),.0,
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //         ),
  //         _packageInfoContainer(
  //             Padding(
  //               padding: const EdgeInsets.all(10.5),
  //               child: Text(
  //                 value,
  //                 style: Theme.of(context).textTheme.displayMedium,
  //               ),
  //             ),
  //             position),
  //       ],
  //     )
  //     );
  // }

  // void _showBottomSheetAttend(List<TicketModel> tickets, int selectedIndex) {
  //   final width = MediaQuery.of(context).size.width;
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       TicketModel selectedTicket = tickets[selectedIndex];
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height.toDouble() / 1.2 - 20,
  //           width: width,
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).primaryColor,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: Padding(
  //             padding: const EdgeInsets.all(10.0),
  //             child: ListView(
  //               children: [
  //                 TicketPurchasingIcon(
  //                   // icon: Icons.payment,
  //                   title: 'Package Type.',
  //                 ),
  //                 const SizedBox(
  //                   height: 50,
  //                 ),
  //                 Center(
  //                   child: Container(
  //                     height: width / 2,
  //                     width: width / 2,
  //                     // decoration: BoxDecoration(
  //                     //   border: Border.all(width: 1, color: Colors.black),
  //                     //   //     color: Theme.of(context).primaryColorLight,
  //                     //   borderRadius: BorderRadius.circular(30),
  //                     //     boxShadow: [
  //                     //       BoxShadow(
  //                     //         color: Colors.black12,
  //                     //         offset: Offset(0, 10),
  //                     //         blurRadius: 10.0,
  //                     //         spreadRadius: 4.0,
  //                     //       )
  //                     // ]
  //                     // ),
  //                     child: Center(
  //                       child: RichText(
  //                         textScaleFactor:
  //                             MediaQuery.of(context).textScaleFactor,
  //                         text: TextSpan(
  //                           children: [
  //                             TextSpan(
  //                               text: "USD",
  //                               style: TextStyle(
  //                                   fontSize:
  //                                       ResponsiveHelper.responsiveFontSize(
  //                                           context, 18.0),
  //                                   color:
  //                                       Theme.of(context).secondaryHeaderColor,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                             TextSpan(
  //                               text: '\n${selectedTicket.price}',
  //                               style: TextStyle(
  //                                   fontSize:
  //                                       ResponsiveHelper.responsiveFontSize(
  //                                           context, 50.0),
  //                                   color:
  //                                       Theme.of(context).secondaryHeaderColor,
  //                                   fontWeight: FontWeight.bold),
  //                             )
  //                           ],
  //                           style: TextStyle(
  //                               // shadows: [
  //                               //   BoxShadow(
  //                               //     color: Colors.black26,
  //                               //     offset: Offset(0, 10),
  //                               //     blurRadius: 15.0,
  //                               //     spreadRadius: 10.0,
  //                               //   )
  //                               // ],
  //                               ),
  //                         ),
  //                         key: ValueKey<int>(selectedTicket.price.toInt()),
  //                         textAlign: TextAlign.center,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 30,
  //                 ),
  //                 TicketInfo(
  //                   event: widget.event!,
  //                   finalPurchasintgTicket: selectedTicket,
  //                   label: 'Category',
  //                   position: 'First',
  //                   value: selectedTicket.group,
  //                 ),
  //                 if (selectedTicket.type.isNotEmpty)
  //                   TicketInfo(
  //                     event: widget.event!,
  //                     finalPurchasintgTicket: selectedTicket,

  //                     // selectedTicket.type,
  //                     label: 'Type',
  //                     position: '',
  //                     value: selectedTicket.type,
  //                   ),
  //                 if (selectedTicket.accessLevel.isNotEmpty)
  //                   TicketInfo(
  //                     event: widget.event!,
  //                     finalPurchasintgTicket: selectedTicket,
  //                     label: 'Access level',
  //                     position: '',
  //                     value: selectedTicket.accessLevel,
  //                     // 'Access level',
  //                     // selectedTicket.accessLevel,
  //                   ),
  //                 TicketInfo(
  //                   event: widget.event!,
  //                   finalPurchasintgTicket: selectedTicket,
  //                   label: 'Price',
  //                   position: 'Last',
  //                   value: selectedTicket.price.toString(),
  //                   // 'isRefundable',
  //                   // selectedTicket.isRefundable.toString()
  //                   // ,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 60.0, vertical: 30),
  //                   child: Container(
  //                     height: 50,
  //                     width: 800,
  //                     child: LayoutBuilder(
  //                       builder:
  //                           (BuildContext context, BoxConstraints constraints) {
  //                         return SingleChildScrollView(
  //                           physics: NeverScrollableScrollPhysics(),
  //                           scrollDirection: Axis.horizontal,
  //                           child: ConstrainedBox(
  //                             constraints: BoxConstraints(
  //                               minWidth: constraints.maxWidth,
  //                               minHeight: constraints.maxHeight,
  //                             ),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 ListView.builder(
  //                                   shrinkWrap: true,
  //                                   scrollDirection: Axis.horizontal,
  //                                   itemCount: tickets.length,
  //                                   itemBuilder:
  //                                       (BuildContext context, int index) {
  //                                     TicketModel ticket = tickets[index];
  //                                     return GestureDetector(
  //                                       onTap: () {
  //                                         HapticFeedback.lightImpact();

  //                                         setState(() {
  //                                           selectedIndex = index;
  //                                           selectedTicket =
  //                                               tickets[selectedIndex];
  //                                         });
  //                                       },
  //                                       child: ticket.type.isEmpty
  //                                           ? const SizedBox.shrink()
  //                                           : Padding(
  //                                               padding:
  //                                                   const EdgeInsets.symmetric(
  //                                                       horizontal: 8.0),
  //                                               child: Container(
  //                                                 height: 40,
  //                                                 width: 50,
  //                                                 decoration: BoxDecoration(
  //                                                   boxShadow: [
  //                                                     BoxShadow(
  //                                                       color: index ==
  //                                                               selectedIndex
  //                                                           ? Colors.black12
  //                                                           : Colors
  //                                                               .transparent,
  //                                                       offset: Offset(0, 10),
  //                                                       blurRadius: 10.0,
  //                                                       spreadRadius: 4.0,
  //                                                     )
  //                                                   ],
  //                                                   color: index ==
  //                                                           selectedIndex
  //                                                       ? Theme.of(context)
  //                                                           .secondaryHeaderColor
  //                                                       : Theme.of(context)
  //                                                           .primaryColorLight
  //                                                           .withOpacity(.5),
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           8),
  //                                                 ),
  //                                                 child: Center(
  //                                                   child: Text(
  //                                                     ticket.type.length >= 2
  //                                                         ? ticket.type
  //                                                             .toUpperCase()
  //                                                             .substring(0, 2)
  //                                                         : ticket.type
  //                                                             .toUpperCase(),
  //                                                     style: TextStyle(
  //                                                       color: index ==
  //                                                               selectedIndex
  //                                                           ? Theme.of(context)
  //                                                               .primaryColorLight
  //                                                           : Theme.of(context)
  //                                                               .secondaryHeaderColor,
  //                                                       fontSize: ResponsiveHelper
  //                                                           .responsiveFontSize(
  //                                                               context, 16.0),
  //                                                       fontWeight:
  //                                                           FontWeight.bold,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                     );
  //                                   },
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //                   child: Center(
  //                     child: AlwaysWhiteButton(
  //                       buttonText: 'Select ticket',
  //                       onPressed: () {
  //                         HapticFeedback.lightImpact();

  //                         // Navigator.pop(context);
  //                         _showBottomFinalPurhcaseSummary(
  //                             context, selectedTicket);
  //                         // selectedTicket.seat == 0
  //                         //     ? _showBottomFinalPurhcaseSummary(selectedTicket)
  //                         //     : _showBottomConfirmTicketOrderPurchaseAvailableSeats(
  //                         //         selectedTicket);
  //                       },
  //                       buttonColor: Colors.blue,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  // void _showBottomConfirmTicketOrderPurchaseAvailableSeats(
  //     TicketModel purchasintgTicket) {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         final width = MediaQuery.of(context).size.width;
  //         List<TicketModel> _availableTickets = widget.event!.ticket;
  //         Map<String, TicketModel> ticketMap = {};
  //         for (TicketModel ticket in _availableTickets) {
  //           String location = "${ticket.row}-${ticket.seat}";
  //           ticketMap[location] = ticket;
  //         }
  //         Set<TicketModel> selectedSeats = {};
  //         TicketModel _finalPurchasingTicket = purchasintgTicket;
  //         return StatefulBuilder(
  //           builder: (BuildContext context, setState) {
  //             return Container(
  //               height: MediaQuery.of(context).size.height.toDouble() / 1.3,
  //               // width: width,
  //               decoration: BoxDecoration(
  //                   color: Theme.of(context).primaryColorLight,
  //                   borderRadius: BorderRadius.circular(30)),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(20.0),
  //                 child: Column(
  //                   children: [
  //                     const SizedBox(
  //                       height: 20,
  //                     ),
  //                     Text(
  //                       "Row $_selectedRow Seat $_selectedSeat",
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: ResponsiveHelper.responsiveFontSize(
  //                             context, 16.0),
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 30,
  //                     ),
  //                     Container(
  //                       height: width,
  //                       child: Flexible(
  //                         child: CustomScrollView(
  //                           slivers: [
  //                             SliverToBoxAdapter(
  //                               child: Column(
  //                                 children: List.generate(purchasintgTicket.row,
  //                                     (row) {
  //                                   return SingleChildScrollView(
  //                                     scrollDirection: Axis.horizontal,
  //                                     child: Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.center,
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.center,
  //                                       children: [
  //                                         Container(
  //                                           width: 100,
  //                                           height: 20,
  //                                           margin: EdgeInsets.all(2),
  //                                           child: Center(
  //                                             child: Text(
  //                                               "Row ${row + 1}",
  //                                               style: TextStyle(
  //                                                 color: Colors.black,
  //                                                 fontSize: ResponsiveHelper
  //                                                     .responsiveFontSize(
  //                                                         context, 16.0),
  //                                                 fontWeight: FontWeight.bold,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           decoration: BoxDecoration(
  //                                             color: _selectedRow == row + 1
  //                                                 ? Colors.blue
  //                                                 : Colors.transparent,
  //                                             borderRadius:
  //                                                 BorderRadius.circular(5),
  //                                           ),
  //                                         ),
  //                                         ...List.generate(20, (seat) {
  //                                           String location =
  //                                               "${row + 1}-${seat + 1}";
  //                                           if (ticketMap
  //                                               .containsKey(location)) {
  //                                             // This seat is not available, display an X
  //                                             return Container(
  //                                               width: 40,
  //                                               height: 40,
  //                                               margin: EdgeInsets.all(2),
  //                                               child: Center(
  //                                                 child: Text(
  //                                                   "X",
  //                                                   style: TextStyle(
  //                                                     color: Colors.black,
  //                                                     fontSize: ResponsiveHelper
  //                                                         .responsiveFontSize(
  //                                                             context, 16.0),
  //                                                     fontWeight:
  //                                                         FontWeight.bold,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                               decoration: BoxDecoration(
  //                                                 color: Colors.grey,
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(5),
  //                                               ),
  //                                             );
  //                                           } else {
  //                                             // This seat is available, display the seat number
  //                                             return GestureDetector(
  //                                               onTap: () {
  //                                                 _selectedSeat = seat + 1;
  //                                                 _selectedRow = row + 1;
  //                                                 // Ticket selectedTicket =
  //                                                 //     Ticket(row: row + 1, seat: seat + 1);
  //                                                 if (selectedSeats.contains(
  //                                                         _selectedRow) &&
  //                                                     selectedSeats.contains(
  //                                                         _selectedSeat)) {
  //                                                   // Deselect the seat
  //                                                   selectedSeats
  //                                                       .remove(_selectedRow);
  //                                                   selectedSeats
  //                                                       .remove(_selectedSeat);

  //                                                   // finalPurchasingTicket = null;
  //                                                 } else {
  //                                                   // Select the seat
  //                                                   // selectedSeats.add(selectedTicket);
  //                                                   TicketModel
  //                                                       finalPurchasingTicket =
  //                                                       TicketModel(
  //                                                     type: purchasintgTicket
  //                                                         .type,
  //                                                     accessLevel:
  //                                                         purchasintgTicket
  //                                                             .accessLevel,
  //                                                     price: purchasintgTicket
  //                                                         .price,
  //                                                     maxSeatsPerRow:
  //                                                         purchasintgTicket
  //                                                             .maxSeatsPerRow,
  //                                                     // row: _selectedRow,
  //                                                     // seat: _selectedSeat,
  //                                                     group: purchasintgTicket
  //                                                         .group,
  //                                                     maxOder: purchasintgTicket
  //                                                         .maxOder,
  //                                                     id: purchasintgTicket.id,
  //                                                     eventTicketDate: widget
  //                                                         .event!.startDate,
  //                                                   );
  //                                                   setState(() {
  //                                                     _finalPurchasingTicket =
  //                                                         finalPurchasingTicket;
  //                                                   });

  //                                                   // updateTicket(selectedTicket);
  //                                                 }
  //                                               },
  //                                               child: Container(
  //                                                 width: 40,
  //                                                 height: 40,
  //                                                 margin: EdgeInsets.all(2),
  //                                                 child: Center(
  //                                                   child: Text(
  //                                                     "${seat + 1}",
  //                                                     style: TextStyle(
  //                                                       color: Colors.black,
  //                                                       fontSize: ResponsiveHelper
  //                                                           .responsiveFontSize(
  //                                                               context, 16.0),
  //                                                       fontWeight:
  //                                                           FontWeight.bold,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 decoration: BoxDecoration(
  //                                                   color: _finalPurchasingTicket !=
  //                                                               null &&
  //                                                           _finalPurchasingTicket
  //                                                                   .row ==
  //                                                               row + 1 &&
  //                                                           _finalPurchasingTicket
  //                                                                   .seat ==
  //                                                               seat + 1
  //                                                       ? Colors.blue
  //                                                       : Colors.blue[50],
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           5),
  //                                                 ),
  //                                               ),
  //                                             );
  //                                           }
  //                                         }).toList(),
  //                                       ],
  //                                     ),
  //                                   );
  //                                 }).toList(),
  //                               ),
  //                             ),
  //                             SliverGrid(
  //                               gridDelegate:
  //                                   SliverGridDelegateWithFixedCrossAxisCount(
  //                                 crossAxisCount: 20,
  //                               ),
  //                               delegate: SliverChildBuilderDelegate(
  //                                 (BuildContext context, int index) {
  //                                   // This builder is required but unused
  //                                   return Container();
  //                                 },
  //                                 childCount: 1,
  //                               ),
  //                             ),
  //                           ],
  //                           scrollDirection: Axis.vertical,
  //                           physics: BouncingScrollPhysics(),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 40),
  //                     AlwaysWhiteButton(
  //                       buttonText: 'Purchase ticket',
  //                       onPressed: () {
  //                         _showBottomFinalPurhcaseSummary(
  //                             context, _finalPurchasingTicket);
  //                       },
  //                       buttonColor: Colors.blue,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var _provider = Provider.of<UserData>(
      context,
    );

    return Stack(
      children: [
        Container(
            height: width * width,
            // color: Colors.red,
            width: width,
            child:
                // widget.event != null && widget.event!.isFree
                //     ? _eventOnTicketAndPurchaseButton()
                //     :

                AnimatedPadding(
              curve: Curves.easeOutBack,
              duration: const Duration(milliseconds: 500),
              padding: EdgeInsets.only(
                  top: _provider.ticketList.isEmpty ? 0.0 : 50.0),
              child: TicketGoupWidget(
                onInvite: widget.onInvite,
                groupTickets: widget.groupTickets,
                // onPressed: widget.event == null
                //     ? () {}
                //     : () {
                //         // HapticFeedback.lightImpact();
                //         // // Navigator.pop;
                //         // _showBottomSheetAttend(
                //         //    widget. groupTickets, widget. groupTickets.indexOf(ticket));
                //       },
                isEditing: widget.event == null ? true : false,
                currency: widget.event == null
                    ? _provider.currency
                    : widget.event!.rate,
                isFree: widget.event == null ? false : widget.event!.isFree,
              ),
            )),
        if (_provider.ticketList.isNotEmpty)
          Positioned(
              right: 30,
              top: 10,
              child: MiniCircularProgressButton(
                text: 'Continue',
                onPressed: () {
                  _showBottomFinalPurhcaseSummary(
                    context,
                  );
                },
                color: Colors.blue,
              ))
      ],
    );
  }
}
