import 'dart:convert';

import 'package:bars/features/events/services/paystack_ticket_payment_mobile_money.dart';
import 'package:bars/utilities/exports.dart';
import 'package:bars/widgets/general_widget/ticket_group_widget.dart';
import 'package:bars/widgets/general_widget/ticket_purchase_summary_widget.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

class TicketGroup extends StatefulWidget {
  final List<TicketModel> groupTickets;
  final Event? event;
  final String currentUserId;
  final String inviteReply;
  final bool onInvite;
  final bool onCalendatSchedule;
  // final String marketedAffiliateId;

  TicketGroup({
    required this.groupTickets,
    required this.event,
    required this.currentUserId,
    required this.inviteReply,
    // required this.marketedAffiliateId ,
    this.onInvite = false,
    this.onCalendatSchedule = false,
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

  void _showBottomSheetLoading(String text) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomModalLoading(
          title: text,
        );
      },
    );
  }

  Future<List<TicketModel>> loadTickets() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? serializedData = prefs.getString('savedTickets');
    if (serializedData != null) {
      Iterable l = jsonDecode(serializedData);
      List<TicketModel> tickets = List<TicketModel>.from(
          l.map((model) => TicketModel.fromJsonSharedPref(model)));
      return tickets;
    }
    return [];
  }

  Future<void> removeTickets() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(
        'savedTickets'); // 'savedTickets' is the key used to store the tickets
  }

  void _generateTickets(
    // TicketModel? purchasintgTickets,
    String purchaseReferenceId,
    String transactionId,
    bool isPaymentVerified,
    String paymentProvider,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    var _user = _provider.user;

    _showBottomSheetLoading('Generating ticket');
    List<TicketModel> _finalTicket = _provider.ticketList.isEmpty
        ? await loadTickets()
        : _provider.ticketList;

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

          Future<TicketOrderModel> createTicketOrder() => _createTicketOrder(
                transactionId,
                transaction,
                commonId,
                _finalTicket,
                purchaseReferenceId,
                isPaymentVerified,
                paymentProvider,
              );

         

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
          await removeTickets();

          ;
          Navigator.pop(context);
          PaletteGenerator _paletteGenerator =
              await PaletteGenerator.fromImageProvider(
            CachedNetworkImageProvider(widget.event!.imageUrl),
            size: Size(1110, 150),
            maximumColorCount: 20,
          );
          // HapticFeedback.lightImpact();
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
          mySnackBar(
              context,
              widget.event!.isFree || widget.event!.isCashPayment
                  ? 'Free ticket generated succesfully'
                  : ' Ticket purchased succesfully');
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
    String purchaseReferenceId,
    isPaymentVerified,
    paymentProvider,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _user = _provider.user;
    String? affiliateId = await AffiliateManager.getAffiliateIdForEvent(
      widget.event!.id,
    );

    // String _marketAffiliateId = _provider.marketedAffiliateId;

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
        lastTimeScanned: Timestamp.fromDate(DateTime.now()),
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
      isPaymentVerified: isPaymentVerified,
      paymentProvider: paymentProvider,
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

    List<String> ticketIds = _finalTicket.map((ticket) => ticket.id).toList();

    bool dontUpdateTicketSales =
        _finalTicket.every((ticket) => ticket.maxOder == 0);

    // widget.event!.ticketOrder.add(order);

    await DatabaseService.purchaseTicketTransaction(
      transaction: transaction,
      ticketOrder: order,
      user: _user!,
      purchaseReferenceId: purchaseReferenceId,
      eventAuthorId: widget.event!.authorId,
      isEventFree: widget.event!.isFree,
      isEventPrivate: widget.event!.isPrivate,
      purchasedTicketIds: ticketIds,
      dontUpdateTicketSales: dontUpdateTicketSales,
      inviteReply: widget.inviteReply,
      marketAffiliateId: affiliateId == null ? '' : affiliateId,
      isEventAffiliated: widget.event!.isAffiliateEnabled,
    );
    if (affiliateId != null)
      await AffiliateManager.clearEventAffiliateId(widget.event!.id);

    return order;
  }

  _processingToGenerate(var verificationResult, PaymentResult paymentResult,
      bool isPaymentVerified, String paymentProvider) async {
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
      _generateTickets(paymentResult.reference, transactionId.toString(),
          isPaymentVerified, paymentProvider);
      // Proceed with any additional steps such as updating the user's tickets
    } else {
      // _provider.setIsLoading(false);
      // A ticket has already been generated for this payment reference
      _showBottomSheetErrorMessage(
          context, 'Tickets have already been generated for this payment.');
    }
  }

  _logVerificationErroData(PaymentResult paymentResult, String result,
      bool ticketGenerated, int totalPrice, String reference) {
    var _provider = Provider.of<UserData>(context, listen: false);
    String id = Uuid().v4();
    DateTime now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    String monthName = DateFormat('MMMM').format(currentDate);

    // Save the error details for internal review
    FirebaseFirestore.instance
        .collection('paymentVerificationFailure')
        .doc(currentDate.year.toString())
        .collection(monthName)
        .doc(getWeekOfMonth(currentDate).toString())
        .collection('verificationFailure')
        .doc(id)
        .set({
      'date': Timestamp.fromDate(DateTime.now()),
      'userName': _provider.user!.userName,
      'userId': _provider.user!.userId,
      'error': result,
      'ticketGenerated': ticketGenerated,
      'reference': reference,
      'amount': totalPrice
    });
  }


  static int getWeekOfMonth(DateTime dateTime) {
    int daysInWeek = 7;
    int daysPassed = dateTime.day + dateTime.weekday - 1;
    return ((daysPassed - 1) / daysInWeek).ceil();
  }

  void _initiatePayment(BuildContext context) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    // try {
    // Assuming you have the email and amount to charge
    // int price = 3;
    double totalPrice = _provider.ticketList
        .fold(0.0, (double sum, TicketModel ticket) => sum + ticket.price);
    String email = FirebaseAuth.instance.currentUser!.email!;
    //  "supportbarsopus@gmail.com"; // User's email
    int amount = totalPrice.toInt(); // Amount in kobo

    final HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable('initiatePaystackMobileMoneyPayment');

    // Call the function to initiate the payment
    final HttpsCallableResult result = await callable.call(<String, dynamic>{
      'email': email,
      'amount': amount * 100, // Assuming this is the correct amount in kobo
      'subaccount': widget.event!.subaccountId,
      'bearer': 'split',
      'callback_url': widget.event!.dynamicLink,
      'reference': _getReference(),
    });

    // Extract the authorization URL from the results
    final String authorizationUrl = result.data['authorizationUrl'];
    final bool success = result.data['success'];
    final String reference = result.data['reference'];

    // Navigate to the payment screen with the authorization URL
    if (success) {
      await navigateToPaymentScreen(
          context, authorizationUrl, reference, amount);
    } else {
      // Handle error
      _showBottomSheetErrorMessage(
          context, 'Failed to initiate payment\n${result.toString()}');
    }
    // await navigateToPaymentScreen(context, authorizationUrl);
    // } catch (e) {
    //   // Handle errors, such as showing an error message to the user
    //   String error = e.toString();
    //   String result = error.contains(']')
    //       ? error.substring(error.lastIndexOf(']') + 1)
    //       : error;

    //   Navigator.pop(context);
    //   _showBottomSheetErrorMessage(context, 'Failed to initiate payment');
    // }
  }

  String _getReference() {
    String commonId = Uuid().v4();
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_$commonId';
  }

  Future<void> navigateToPaymentScreen(BuildContext context,
      String authorizationUrl, String reference, int totalPrice) async {
    // final bool? result =

    PaymentResult? paymentResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaystackPaymentScreen(authorizationUrl: authorizationUrl),
      ),
    );

    if (paymentResult == null) {
      Navigator.pop(context);
      _showBottomSheetErrorMessage(
          context, "Payment was not completed.\nPlease try again.");
      return; // Early return to stop further processing
    }

    // If the initial Paystack payment is successful, verify it server-side
    if (paymentResult.success) {
      // _provider.setIsLoading(true); // Start the loading indicator
      Navigator.pop(context);
      _showBottomSheetLoading('Verifying payment');
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('verifyPaystackPayment');
      try {
        final verificationResult = await callable.call(<String, dynamic>{
          'reference': reference,
          'isEvent': true,
          //  paymentResult.reference,
          'eventId': widget.event!.id,
          'amount': totalPrice.toInt() * 100,

          //  totalPrice.toInt() *
          //     100, // Assuming this is the correct amount in kobo
        });

        // If server-side verification is successful, generate tickets
        if (verificationResult.data['success']) {
          Navigator.pop(context);
          Navigator.pop(context);
          //affiliate check and update would happen here..

          await _processingToGenerate(
              verificationResult, paymentResult, true, 'Paystack');
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
          await _processingToGenerate(
              verificationResult, paymentResult, false, 'Paystack');
          await _logVerificationErroData(
              paymentResult,
              'Couldn\'t verify your ticket payment',
              true,
              totalPrice,
              reference);
          _showBottomSheetErrorMessage(
              context, 'Couldn\'t verify your ticket payment');
        }
      } catch (e) {
        // Handle errors from calling the Cloud Function
        // Log the error and notify the user
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        _logVerificationErroData(
            paymentResult, result, false, totalPrice, reference);

        Navigator.pop(context);
        _showBottomSheetErrorMessage(
            context,
            'Your payment is under review. Please '
            'note your reference number: $reference. Our support team will contact you shortly.');
      }
    } else {
      _showBottomSheetErrorMessage(
          context, 'Couldn\'t pay for the ticket, please try again.');
    }
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
          height: widget.event!.isFree
              ? 300
              : widget.event!.isCashPayment
                  ? 400
                  : 380,
          buttonText: widget.event!.isFree || widget.event!.isCashPayment
              ? 'Generate Ticket'
              : 'Purchase Ticket',
          onPressed: () async {
            // Check internet connectivity
            var connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult == ConnectivityResult.none) {
              // No internet connection
              _showBottomSheetErrorMessage(context,
                  'No internet connection available. Please connect to the internet and try again.');
              return;
            }

            if (_provider.ticketList.isEmpty) {
              _showBottomSheetErrorMessage(context,
                  'No selected ticket. Tap on the attend button to reselect your tickets.');
            } else {
              // Check the condition of the event being free or cash payment
              if (widget.event!.isFree || widget.event!.isCashPayment) {
                // HapticFeedback.lightImpact();
                Navigator.pop(context);
                _generateTickets('', '', false, '');
              } else {
                _showBottomSheetLoading('Initializing payment');
                _initiatePayment(context);

                // _payForTicket();
              }
            }
          },
          title: widget.event!.isFree || widget.event!.isCashPayment
              ? 'Are you sure you want to proceed and generate a ticket?'
              : 'Are you sure you want to proceed and purchase this tickets?',
          subTitle: widget.event!.termsAndConditions.isNotEmpty
              ? 'By purchasing or generating a ticket to this event, you have accepted the terms and conditions that govern this event as provided by the event organizer.'
              : widget.event!.isCashPayment
                  ? 'The payment method for this ticket is cash in hand. Therefore, you will be required to pay for the tickets you generate here at the event venue. For further clarification or more information, please contact the event organizer'
                  : widget.event!.isFree
                      ? ''
                      : 'Please avoid interrupting any processing, loading, or countdown indicators during the payment process. Kindly wait for the process to finish on its own.',
        );
      },
    );
  }


  _eventOnTicketAndPurchaseButton() {
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
              currentUserId: widget.currentUserId,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Divider(
          thickness: .2,
        ),
        const SizedBox(
          height: 40,
        ),
        Center(
          child: AlwaysWhiteButton(
            buttonText: widget.event!.isFree
                ? 'Generate free ticket'
                : widget.event!.isCashPayment
                    ? 'Generate ticket'
                    : 'Purchase ticket',
            onPressed: () {
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
                      title: 'Payment.',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: ShakeTransition(
                        axis: Axis.vertical,
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
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
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: .2,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    textScaler: MediaQuery.of(context).textScaler,
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
                Divider(
                  thickness: .2,
                ),
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

  Future<void> saveTickets(List<TicketModel> tickets) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String serializedData = jsonEncode(
          tickets.map((ticket) => ticket.toJsonSharedPref()).toList());
      await prefs.setString('savedTickets', serializedData);
    } catch (e) {
      print("Error saving tickets: $e");
      throw Exception('Failed to save tickets');
    }
  }

  bool _checkingTicketAvailability = false;

  _attendMethod() async {
    HapticFeedback.lightImpact();
    if (mounted) {
      setState(() {
        _checkingTicketAvailability = true;
      });
    }

    TicketOrderModel? _ticket = await DatabaseService.getTicketWithId(
        widget.event!.id, widget.currentUserId);

    if (_ticket != null) {
      PaletteGenerator _paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(widget.event!.imageUrl),
        size: Size(1110, 150),
        maximumColorCount: 20,
      );

      _navigateToPage(
        context,
        PurchasedAttendingTicketScreen(
          ticketOrder: _ticket,
          event: widget.event!,
          currentUserId: widget.currentUserId,
          justPurchased: 'Already',
          palette: _paletteGenerator,
        ),
      );
      if (mounted) {
        setState(() {
          _checkingTicketAvailability = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _checkingTicketAvailability = false;
        });
        _showBottomFinalPurhcaseSummary(context);
      }
    }
  }

  _validateAttempt() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _usercountry = _provider.userLocationPreference!.country;

    bool isGhanaian = _usercountry == 'Ghana' ||
        _provider.userLocationPreference!.currency == 'Ghana Cedi | GHS';

    if (!isGhanaian) {
      _showBottomSheetErrorMessage(
        context,
        'This event is currently unavailable in $_usercountry.',
      );
    } else if (widget.event!.termsAndConditions.isNotEmpty) {
      _showBottomSheetTermsAndConditions();
    } else {
      if (widget.event!.ticketSite.isNotEmpty) {
        _showBottomSheetExternalLink();
      } else {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          _showBottomSheetErrorMessage(context,
              'No internet connection available. Please connect to the internet and try again.');
          return;
        } else {
          _attendMethod();
        }
      }
    }
  }

  void _showBottomSheetExternalLink() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 550),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: WebDisclaimer(
              link: widget.event!.ticketSite,
              contentType: 'Event ticket',
              icon: Icons.link,
            ));
      },
    );
  }

  _ticketLoadingIndicator() {
    return SizedBox(
      height: ResponsiveHelper.responsiveHeight(context, 10.0),
      width: ResponsiveHelper.responsiveHeight(context, 10.0),
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Colors.blue,
      ),
    );
  }

  void _showBottomSheetTermsAndConditions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height.toDouble() / 1.2,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
           
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TicketPurchasingIcon(
                        title: '',
                      ),
                      _checkingTicketAvailability
                          ? _ticketLoadingIndicator()
                          : MiniCircularProgressButton(
                              color: Colors.blue,
                              text: 'Accept',
                              onPressed: widget.event!.ticketSite.isNotEmpty
                                  ? () {
                                      Navigator.pop(context);
                                      _showBottomSheetExternalLink();
                                    }
                                  : () async {
                                      if (mounted) {
                                        setState(() {
                                          _checkingTicketAvailability = true;
                                        });
                                      }
                                      await _attendMethod();
                                      if (mounted) {
                                        setState(() {
                                          _checkingTicketAvailability = false;
                                        });
                                      }
                                    })
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textScaler: MediaQuery.of(context).textScaler,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text: "\n\n${widget.event!.termsAndConditions}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }


  void _showBottomEditLocation(
    BuildContext context,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _userLocation = _provider.userLocationPreference;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 400,
          buttonText: 'set up city',
          onPressed: () async {
            Navigator.pop(context);
            _navigateToPage(
                context,
                EditProfileSelectLocation(
                  user: _userLocation!,
                  notFromEditProfile: true,
                ));
          },
          title: 'Set up your city',
          subTitle:
              'To proceed with purchasing a ticket, we kindly ask you to provide your country information. This allows us to handle ticket processing appropriately, as the process may vary depending on different countries. Please note that specifying your city is sufficient, and there is no need to provide your precise location or community details.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var _provider = Provider.of<UserData>(
      context,
    );
    var _usercountry = _provider.userLocationPreference!.country;

    return Stack(
      children: [
        Container(
            height: ResponsiveHelper.responsiveHeight(
                context,
                widget.event == null || !widget.event!.isFree
                    ? widget.groupTickets.length * 500
                    : widget.groupTickets.length * 300),
          
            width: width,
            child:
             
                AnimatedPadding(
              curve: Curves.easeOutBack,
              duration: const Duration(milliseconds: 500),
              padding: EdgeInsets.only(
                  top: _provider.ticketList.isEmpty ? 0.0 : 50.0),
              child: TicketGoupWidget(
                onCalendatSchedule: widget.onCalendatSchedule,
                onInvite: widget.onInvite,
                groupTickets: widget.groupTickets,
                isEditing: widget.event == null ? true : false,
                currency: widget.event == null
                    ? _provider.currency
                    : widget.event!.rate,
                isFree: widget.event == null ? false : widget.event!.isFree,
                eventId: widget.event == null ? '' : widget.event!.id,
                eventAuthorId: widget.event == null
                    ? widget.currentUserId
                    : widget.event!.authorId,
              ),
            )),
        if (_provider.ticketList.isNotEmpty)
          Positioned(
              right: 30,
              top: 10,
              child: _checkingTicketAvailability
                  ? _ticketLoadingIndicator()
                  : MiniCircularProgressButton(
                      text: 'Continue',
                      onPressed: _usercountry!.isEmpty
                          ? () {
                              widget.event!.isFree
                                  ? _attendMethod()
                                  : _showBottomEditLocation(context);
                            }
                          : _validateAttempt,

                      color: Colors.blue,
                    ))
      ],
    );
  }
}
