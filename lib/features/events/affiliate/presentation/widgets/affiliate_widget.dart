import 'package:bars/utilities/exports.dart';
import 'package:uuid/uuid.dart';

class AffiliateWidget extends StatefulWidget {
  final AffiliateModel affiliate;
  final String currentUserId;
  final bool isUser;
  final bool fromActivity;

  const AffiliateWidget({
    super.key,
    required this.affiliate,
    required this.currentUserId,
    required this.isUser,
    required this.fromActivity,
  });

  @override
  State<AffiliateWidget> createState() => _AffiliatetStateState();
}

class _AffiliatetStateState extends State<AffiliateWidget> {
  bool _isLoadingSubmit = false;
  bool _isLoading = false;
  bool _hasOrganiserBeingPaid = false;
  bool _eventHasEnded = false;

  @override
  void initState() {
    super.initState();
    _countDown();
    _hasEventEnded();
  }

  void _hasEventEnded() {
    if (EventHasStarted.hasEventEnded(
        widget.affiliate.eventClossingDay.toDate())) {
      if (mounted) {
        setState(() {
          _eventHasEnded = true;
        });
      }
    }
  }

  void _countDown() async {
    _hasOrganiserBeingPaid = widget.affiliate.payoutToOrganizer;
    if (!widget.affiliate.payoutToAffiliates) {
      if (!_hasOrganiserBeingPaid) {
        try {
          if (EventHasStarted.hasEventEnded(
              widget.affiliate.eventClossingDay.toDate())) {
            Event? _event = await DatabaseService.getUserEventWithId(
                widget.affiliate.eventId, widget.affiliate.eventAuthorId);
            if (_event == null) return;
            if (_event.fundsDistributed) {
              await DatabaseService.updateAffiliatetEventOrganiserPayoutStatus(
                eventId: widget.affiliate.eventId,
                affiliateId: widget.affiliate.userId,
                eventAuthorId: widget.affiliate.eventAuthorId,
              );
              if (mounted) {
                setState(() {
                  _hasOrganiserBeingPaid = true;
                });
              }
            }
          }
        } catch (e) {}
      }
    }
  }

//create payout
  Future<AffiliatePayoutModel> _createPayoutRequst() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    String commonId = Uuid().v4();
    AffiliatePayoutModel payout = AffiliatePayoutModel(
      id: commonId,
      eventId: widget.affiliate.eventId,
      status: 'pending',
      timestamp: Timestamp.fromDate(DateTime.now()),
      eventAuthorId: widget.affiliate.eventAuthorId,
      idempotencyKey: '',
      subaccountId: _provider.userLocationPreference!.subaccountId!,
      transferRecepientId:
          _provider.userLocationPreference!.transferRecepientId!,
      eventTitle: widget.affiliate.eventTitle,
      clossingDay: widget.affiliate.eventClossingDay,
      affiliateId: widget.affiliate.userId,
      total: widget.affiliate.affiliateAmount,
    );

    await DatabaseService.requestAffiliatePayout(
      payout,
    );

    return payout;
  }

  // Method to request payout
  _submitRequest() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      try {
        bool existingOrder = await DatabaseService.isAffiliatePayoutAvailable(
          // transaction: transaction,
          userId: widget.affiliate.userId,
          eventId: widget.affiliate.eventId,
        );
        if (!existingOrder) {
          await _createPayoutRequst();
          _showBottomSheetPayoutSuccessful();
        } else {
          _showBottomSheetErrorMessage('Payout already requested');
        }

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showBottomSheetErrorMessage('Couldn\'t request for Payout');
      }
    }
  }

  void _showBottomSheetConfirmPayout() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 300,
          buttonText: 'Request Payout',
          onPressed: () {
            Navigator.pop(context);
            _submitRequest();
          },
          title: 'Are you sure you want to request for your payout?',
          subTitle:
              'Please be informed that payout request can only be made once.',
        );
      },
    );
  }

  _acceptAffiliateInvite(
    bool isAccepted,
    String purchaseReferenceId,
    String transactionId,
  ) async {
    var _user = Provider.of<UserData>(context, listen: false).user;
    String commonId = Uuid().v4();

    if (_isLoadingSubmit) {
      return;
    }
    if (mounted) {
      setState(() {
        _isLoadingSubmit = true;
      });
    }

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

    WriteBatch batch = FirebaseFirestore.instance.batch();
    Event? _event = await DatabaseService.getUserEventWithId(
        widget.affiliate.eventId, widget.affiliate.eventAuthorId);

    if (_event == null) {
      return;
    }
    String link = isAccepted
        ? await DatabaseService.myDynamicLink(
            widget.affiliate.eventImageUrl,
            widget.affiliate.eventTitle,
            _event.theme,
            'https://www.barsopus.com/event_${widget.affiliate.eventId}_${widget.affiliate.eventAuthorId}_${widget.affiliate.userId}')
        : '';

    Future<void> sendInvites() => DatabaseService.answeAffiliatetInviteBatch(
          affiliateLink: link,
          batch: batch,
          eventId: widget.affiliate.eventId,
          answer: isAccepted ? 'Accepted' : 'Rejected',
          currentUser: _user!,
          affiliateInviteeId: widget.affiliate.eventAuthorId,
        );

    try {
      await retry(() => sendInvites(), retries: 3);
      List<TicketPurchasedModel> pasTicket = [];
      if (isAccepted) {
        TicketPurchasedModel order = TicketPurchasedModel(
          entranceId: commonId,
          eventTicketDate: _event.startDate,
          group: '',
          id: '',
          price: 0,
          refundRequestStatus: '',
          idempotencyKey: '',
          seat: 0,
          row: 0,
          type: 'Free Pass',
          validated: false,
          transactionId: '',
          lastTimeScanned: Timestamp.fromDate(DateTime.now()),
        );
        pasTicket.add(order);

        try {
          TicketOrderModel order = await retry(
              () => _createTicketOrder(transactionId, batch, commonId,
                  pasTicket, purchaseReferenceId, _event),
              retries: 3);

          PaletteGenerator _paletteGenerator =
              await PaletteGenerator.fromImageProvider(
            CachedNetworkImageProvider(_event.imageUrl,
            ),
            
            size: Size(1110, 150),
            maximumColorCount: 20,
          );

          _navigateToPage(
            PurchasedAttendingTicketScreen(
              affiliateLink: link,
              affiliate: widget.affiliate,
              ticketOrder: order,
              event: _event,
              currentUserId: widget.currentUserId,
              justPurchased: 'Affiliate',
              palette: _paletteGenerator,
            ),
          );

          mySnackBar(context, "Deal accepted successfully");
        } catch (e) {}
      } else {
        Navigator.pop(context);
        mySnackBar(context, "Deal rejected ");
      }
      await batch.commit();
    } catch (e) {
      _showBottomSheetErrorMessage(e);
    } finally {
      _endLoading();
    }
  }

  Future<TicketOrderModel> _createTicketOrder(
    String transactionId,
    WriteBatch batch,
    String commonId,
    List<TicketPurchasedModel> _finalTicket,
    String purchaseReferenceId,
    Event event,
  ) async {
    // Calculate the total cost of the order
    var _user = Provider.of<UserData>(context, listen: false).user;

    double total = _finalTicket.fold(0, (acc, ticket) => acc + ticket.price);

    TicketOrderModel order = TicketOrderModel(
      orderId: commonId,
      tickets: _finalTicket,
      total: total,
      isDeleted: false,
      canlcellationReason: '',
      eventAuthorId: event.authorId,
      // entranceId: '',
      eventId: event.id,
      eventImageUrl: event.imageUrl,
      eventTimestamp: event.startDate,
      isInvited: true,
      timestamp: Timestamp.now(),
      orderNumber: commonId,
      // validated: false,
      userOrderId: widget.currentUserId,
      eventTitle: event.title,
      purchaseReferenceId: purchaseReferenceId, refundRequestStatus: '',
      transactionId: transactionId, idempotencyKey: '',
      isPaymentVerified: false, paymentProvider: '',
      //  refundRequestStatus: '',
    );

    // widget.event.ticketOrder.add(order);
    DatabaseService.purchaseTicketBatch(
      ticketOrder: order,
      batch: batch,
      user: _user!,
      eventAuthorId: event.authorId,
      purchaseReferenceId: purchaseReferenceId,
    );

    return order;
  }

  void _endLoading() {
    if (mounted) {
      setState(() {
        _isLoadingSubmit = false; // Set isLoading to false
      });
    }
  }

  void _showBottomSheetErrorMessage(Object e) {
    String error = e.toString();
    String result = error.contains(']')
        ? error.substring(error.lastIndexOf(']') + 1)
        : error;
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
          title: "Request failed",
          subTitle: result,
        );
      },
    );
  }

  void _showBottomSheetPayoutSuccessful() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return PayoutSuccessWidget(
            amount: widget.affiliate.affiliateAmount.toInt(),
          );
        });
      },
    );
  }

  void _showBottomSheetComfirmDelete(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: 'Delete',
          onPressed: () async {
            Navigator.pop(context);
            try {
              // Call recursive function to delete documents in chunks
              await widget.isUser
                  ? DatabaseService.deleteAffiliateUsertData(widget.affiliate)
                  : DatabaseService.deleteAffiliatetEventData(widget.affiliate);
              mySnackBar(context, 'Affiliate data deleted successfully');
              Navigator.pop(context);
            } catch (e) {
              _showBottomSheetErrorMessage('Error deleting affiliate data');
            }
          },
          title: 'Are you sure you want to delete this affiliate data?',
          subTitle: '',
        );
      },
    );
  }

  _checkForPaymentDetails(bool isAccepted) {
    UserData _provider = Provider.of<UserData>(context, listen: false);
    var _userLocation = _provider.userLocationPreference;

    // final List<String> currencyPartition = _provider.currency.isEmpty
    //     ? ' Ghana Cedi | GHS'.trim().replaceAll('\n', ' ').split("|")
    //     : _provider.currency.trim().replaceAll('\n', ' ').split("|");

    // // Check for the country being Ghana or the currency code being GHS
    // bool isGhanaOrCurrencyGHS = _userLocation!.country == 'Ghana' &&
    //     currencyPartition[1].trim() == 'GHS';

    // bool isGhanaOrCurrencyGHS = Utils.isGhanaOrCurrencyGHS(_userLocation!.country, _currency);

    bool isGhanaOrCurrencyGHS = IsGhanain.isGhanaOrCurrencyGHS(
        _userLocation!.country!, _userLocation.currency!);

    // Check if the subaccount and transfer recipient IDs are empty
    bool shouldNavigate = _userLocation.subaccountId!.isEmpty ||
        _userLocation.transferRecepientId!.isEmpty;

    isGhanaOrCurrencyGHS && shouldNavigate
        ? _navigateToPage(CreateSubaccountForm(
            isEditing: false,
          ))
        : _acceptAffiliateInvite(isAccepted, '', '');
  }

  void _showBottomSheetAcceptReject(BuildContext context, bool isAccepted) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 300,
          buttonText: isAccepted ? 'Accept' : 'Reject',
          onPressed: () async {
            Navigator.pop(context);
            _checkForPaymentDetails(isAccepted);
          },
          title: isAccepted
              ? 'Are you sure you want to accept this affiliate deal?'
              : 'Are you sure you want to reject this affiliate deal?',
          subTitle: '',
        );
      },
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _payoutWidget(String lable, String value) {
    return PayoutDataWidget(
      label: lable,
      value: value,
    );
  }

  _acceptRejectButton(
    String buttonText,
    VoidCallback onPressed,
    bool fullLength,
  ) {
    return AcceptRejectButton(
      isAffiliate: true,
      buttonText: buttonText,
      onPressed: onPressed,
      fullLength: fullLength,
    );
  }

  void _showBottomSheetDoc(bool showButton) {
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
                          text: 'Terms and Conditons:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text: "\n\n${widget.affiliate.termsAndCondition}.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (showButton)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: MiniCircularProgressButton(
                          text: 'Accept',
                          onPressed: () {
                            Navigator.pop(context);
                            _showBottomSheetAcceptReject(
                              context,
                              true,
                            );
                          }),
                    ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          );
        });
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
                isOganiser: false,
                affiliateOnPressed: () {
                  Navigator.pop(context);
                  // _showBottomSheetCreateAffiliate();
                },
              ));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.fromActivity
          ? Theme.of(context).cardColor.withOpacity(.5)
          : Theme.of(context).primaryColorLight,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(30),
      child: GestureDetector(
        onTap: widget.isUser
            ? () async {
                setState(() {
                  _isLoading = true;
                });

                try {
                  Event? event = await DatabaseService.getUserEventWithId(
                      widget.affiliate.eventId, widget.affiliate.eventAuthorId);

                  if (event != null) {
                    _navigateToPage(EventEnlargedScreen(
                      currentUserId: widget.currentUserId,
                      event: event,
                      type: event.type,
                      showPrivateEvent: true,
                    ));
                  } else {
                    _showBottomSheetErrorMessage(
                        'Event not found. This event might have been deleted or cancelled');
                  }
                } catch (e) {
                  _showBottomSheetErrorMessage('Failed to fetch event');
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            : () {
                _navigateToPage(ProfileScreen(
                  currentUserId: widget.currentUserId,
                  userId: widget.affiliate.userId,
                  user: null,
                ));
              },
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: [
              if (_hasOrganiserBeingPaid)
                widget.affiliate.payoutToAffiliates
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                        child: Icon(
                          Icons.check_circle_outline_outlined,
                          size:
                              ResponsiveHelper.responsiveHeight(context, 50.0),
                          color: Colors.green,
                        ),
                      )
                    : Text(
                        widget.affiliate.salesNumber == 0
                            ? "You havent soled any tickets. \nGood luck next time."
                            : "Congratulations ${widget.affiliate.userName}\n\nWe're thrilled to report that you've successfully sold ${widget.affiliate.salesNumber} tickets for the ${widget.affiliate.eventTitle} event. Your impressive efforts have earned you a commission of ${widget.affiliate.commissionRate}% per ticket sold.\n\nAs a result, your total commission amount is GHC ${widget.affiliate.affiliateAmount}. This payout is now available and ready for you to request.\n\nTo receive your well-deserved earnings, please click the button below",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: widget.affiliate.salesNumber == 0
                            ? TextAlign.center
                            : TextAlign.start,
                      ),
              if (_hasOrganiserBeingPaid)
                if (widget.affiliate.salesNumber > 0)
                  if (!widget.affiliate.payoutToAffiliates)
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: _isLoading
                          ? SizedBox.shrink()
                          : MiniCircularProgressButton(
                              color: Colors.blue,
                              text: 'Request Payout',
                              onPressed: () {
                                _showBottomSheetConfirmPayout();
                              }),
                    ),
              if (_hasOrganiserBeingPaid)
                if (!widget.affiliate.payoutToAffiliates)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
              ListTile(
                leading: _isLoading
                    ? SizedBox(
                        height:
                            ResponsiveHelper.responsiveFontSize(context, 30.0),
                        width:
                            ResponsiveHelper.responsiveFontSize(context, 30.0),
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                          strokeWidth:
                              ResponsiveHelper.responsiveFontSize(context, 2.0),
                        ),
                      )
                    : widget.isUser
                        ? Container(
                            height:
                                ResponsiveHelper.responsiveHeight(context, 50),
                            width:
                                ResponsiveHelper.responsiveHeight(context, 50),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.affiliate.eventImageUrl,   errorListener: (_) {
                                  return;
                                }),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : widget.affiliate.userProfileUrl.isEmpty
                            ? Icon(
                                Icons.account_circle,
                                size: ResponsiveHelper.responsiveHeight(
                                    context, 50.0),
                                color: Colors.grey,
                              )
                            : CircleAvatar(
                                radius: ResponsiveHelper.responsiveHeight(
                                    context, 25.0),
                                backgroundColor: Colors.blue,
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.affiliate.userProfileUrl),
                              ),
                title: Text(
                  widget.isUser
                      ? widget.affiliate.eventTitle
                      : widget.affiliate.userName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.affiliate.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              if (widget.affiliate.affiliateLink.isNotEmpty && widget.isUser)
                if (!_eventHasEnded)
                  GestureDetector(
                    onTap: () {
                      _navigateToPage(AffiliateBarcode(
                        affiliate: widget.affiliate,
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                      child: Hero(
                        tag: widget.affiliate.affiliateLink,
                        child: QrImageView(
                          version: QrVersions.auto,
                          eyeStyle: QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.blueGrey,
                          ),
                          dataModuleStyle: QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.circle,
                            color: Colors.blueGrey,
                          ),
                          backgroundColor: Colors.transparent,
                          data: widget.affiliate.affiliateLink,
                          size:
                              ResponsiveHelper.responsiveHeight(context, 50.0),
                        ),
                      ),
                    ),
                  ),
              if (widget.affiliate.affiliateLink.isNotEmpty && widget.isUser)
                if (!_eventHasEnded)
                  GestureDetector(
                    onTap: () {
                      Share.share(widget.affiliate.affiliateLink);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.link,
                            color: Colors.blue,
                            size:
                                ResponsiveHelper.responsiveHeight(context, 30),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Your affiliate link',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              if (widget.affiliate.affiliateLink.isEmpty || !widget.isUser)
                const SizedBox(
                  height: 10,
                ),
              _payoutWidget(
                'commission\nRate',
                "${widget.affiliate.commissionRate.toString()}%",
              ),
              Divider(
                thickness: .2,
              ),
              _payoutWidget(
                'sales\nNumber',
                widget.affiliate.salesNumber.toString(),
              ),
              Divider(
                thickness: .2,
              ),
              _payoutWidget(
                'Amount',
                widget.affiliate.affiliateAmount.toString(),
              ),
              Divider(
                thickness: .2,
              ),
              _payoutWidget(
                'Payout\nStatus',
                widget.affiliate.payoutToAffiliates ? 'Paid' : '',
              ),
              Divider(
                thickness: .2,
              ),
              _payoutWidget(
                'Type',
                widget.affiliate.marketingType.toString(),
              ),
              Divider(
                thickness: .2,
              ),
              _payoutWidget(
                'Affiliate\nPayout time',
                widget.affiliate.payoutToAffiliates
                    ? MyDateFormat.toTime(
                        widget.affiliate.affiliatePayoutDate.toDate())
                    : '',
              ),
              Divider(
                thickness: .2,
              ),
              _payoutWidget(
                'Affiliate \nPayout date',
                widget.affiliate.payoutToAffiliates
                    ? MyDateFormat.toDate(
                        widget.affiliate.affiliatePayoutDate.toDate())
                    : '',
              ),
              Divider(
                thickness: .2,
              ),
              _payoutWidget(
                'Event \nClossing date',
                MyDateFormat.toDate(widget.affiliate.eventClossingDay.toDate()),
              ),
              Divider(
                thickness: .2,
              ),
              _payoutWidget(
                'Created \ndate',
                MyDateFormat.toDate(widget.affiliate.timestamp.toDate()),
              ),
              if (widget.affiliate.salesNumber > 0)
                GestureDetector(
                  onTap: () {
                    _navigateToPage(
                      AffiliateCustomers(
                        userId: widget.currentUserId,
                      ),
                    );
                  },
                  child: Text(
                    '\nSee referred attendees',
                    style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14),
                        color: Colors.blue),
                  ),
                ),
              Divider(
                thickness: .2,
              ),
              GestureDetector(
                onTap: () {
                  _showBottomSheetAffiliateDoc();
                },
                child: Text(
                  '\nWho is an affiliate',
                  style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                      color: Colors.blue),
                ),
              ),
              if (widget.affiliate.termsAndCondition.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _showBottomSheetDoc(false);
                  },
                  child: Text(
                    '\nTerms and conditions',
                    style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14),
                        color: Colors.blue),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              if (widget.isUser)
                if (widget.affiliate.answer.isEmpty)
                  _isLoadingSubmit
                      ? Center(
                          child: CircularProgress(
                            isMini: true,
                            // indicatorColor: Colors.white,
                            indicatorColor: Colors.blue,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _acceptRejectButton('Accept', () {
                              widget.affiliate.termsAndCondition.isNotEmpty
                                  ? _showBottomSheetDoc(true)
                                  : _showBottomSheetAcceptReject(
                                      context,
                                      true,
                                    );
                            }, false),
                            _acceptRejectButton('Reject', () {
                              _showBottomSheetAcceptReject(
                                context,
                                false,
                              );
                            }, false),
                          ],
                        ),
              IconButton(
                  onPressed: () {
                    _showBottomSheetComfirmDelete(context);
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
