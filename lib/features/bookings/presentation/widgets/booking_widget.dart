import 'package:avatar_glow/avatar_glow.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uuid/uuid.dart';

class BookingWidget extends StatefulWidget {
  final BookingModel booking;
  final String currentUserId;

  const BookingWidget({
    super.key,
    required this.booking,
    required this.currentUserId,
  });

  @override
  State<BookingWidget> createState() => _BookingWidgetStateState();
}

class _BookingWidgetStateState extends State<BookingWidget>
    with TickerProviderStateMixin {
  bool _isLoadingSubmit = false;
  // bool _isLoading = false;
  // bool _hasOrganiserBeingPaid = false;
  bool _eventHasEnded = false;
  bool _isAnswered = false;
  bool _downPayment = false;

  late TabController _tabController;
  final _commentController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  // final Color _eventColorMain = Color(0xFF036147);

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_onDonateChanged);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        HapticFeedback.mediumImpact();
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _clear();
    });

    _hasEventEnded();
  }

  void _onDonateChanged() {
    if (_commentController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  _indicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: _index == index ? 2 : 5,
      width: _index == index ? 20 : 50,
      decoration: BoxDecoration(
          color: Colors.transparent,
          // shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: Colors.blue,
            // widget.booking.isEvent ? Colors.yellow[700]! : Colors.green
          )),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _hasEventEnded() {
    if (EventHasStarted.hasEventEnded(widget.booking.bookingDate.toDate())) {
      if (mounted) {
        setState(() {
          _eventHasEnded = true;
        });
      }
    }
  }

  _answerRequest(String answer, bool isAnswer) async {
    // _showBottomSheetLoading('Sending booking request');
    var _user = Provider.of<UserData>(context, listen: false).user;

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

    Future<void> answerRequest() => isAnswer
        ? DatabaseService.answerBookingInviteBatch(
            currentUser: _user!,
            booking: widget.booking,
            answer: answer,
            isAnswer: isAnswer,
          )
        : DatabaseService.answerBookingInviteBatch(
            currentUser: _user!,
            booking: widget.booking,
            answer: answer,
            isAnswer: isAnswer,
          );

    try {
      await retry(() => answerRequest(), retries: 3);

      // if (answer == 'Accepted') Navigator.pop(context);
      setState(() {
        answer == 'Accepted' ? _isAnswered = true : _downPayment = true;
      });

      isAnswer
          ? mySnackBar(
              context,
              answer == 'Accepted'
                  ? "Booking accepted successfully"
                  : "Booking rejected successfully")
          : _showBottomSheetPayoutSuccessful();
    } catch (e) {
      _showBottomSheetErrorMessage('Could not answer booking request');
    } finally {
      _endLoading();
    }
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
            payment: true,
            amount: 30,
          );
        });
      },
    );
  }

  _sendRatings() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    FocusScope.of(context).unfocus();

    // _showBottomSheetLoading('Sending booking request');
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

    ReviewModel _review = ReviewModel(
      bookingId: commonId,
      reviewingId: widget.booking.creativeId,
      rating: _provider.affiliatecommission,
      timestamp: Timestamp.fromDate(DateTime.now()),
      revierwerId: widget.currentUserId,
      comment: _commentController.text.trim(),
    );

    Future<void> sendInvites() => DatabaseService.createReview(
          currentUser: _user!,
          rating: _review,
        );

    try {
      await retry(() => sendInvites(), retries: 3);
      _clear();
      mySnackBar(context, "Rating was successful");
    } catch (e) {
      Navigator.pop(context);
      _showBottomSheetErrorMessage('Could submit rating and review');
    } finally {
      _endLoading();
    }

    _endLoading();
  }

  _clear() {
    var _provider = Provider.of<UserData>(context, listen: false);

    _commentController.clear();
    _provider.setAffiliateComission(0);
  }

  void _endLoading() {
    if (mounted) {
      setState(() {
        _isLoadingSubmit = false; // Set isLoading to false
      });
    }
  }

  void _showBottomSheetConfirmPayout(String answer, bool isAnswer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 340,
          buttonText: isAnswer ? 'Acccept Booking' : 'Pay 30%',
          onPressed: () {
            Navigator.pop(context);
            isAnswer
                ? _answerRequest(answer, true)
                : _answerRequest(answer, false);
          },
          title: isAnswer
              ? 'Are you sure you want to accept this booking?'
              : 'Are you sure you want to pay the 30% down payment?',
          subTitle: isAnswer
              ? 'Please be informed that when you accept this booking request you would be subjected to its terms and conditions.'
              : '',
        );
      },
    );
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

  void _showBottomSheetComfirmDelete(BuildContext context) {
    bool _isCreative = widget.booking.creativeId == widget.currentUserId;
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
              _isCreative
                  ? DatabaseService.deleteCrativeBookingData(widget.booking)
                  : DatabaseService.deleteClientBookingData(widget.booking);
              mySnackBar(context, 'Booking data deleted successfully');
              Navigator.pop(context);
            } catch (e) {
              _showBottomSheetErrorMessage('Error deleting affiliate data');
            }
          },
          title: 'Are you sure you want to delete this booking data?',
          subTitle: '',
        );
      },
    );
  }

  _payoutWidget(String lable, String value, int? maxLines) {
    return PayoutDataWidget(
      text2Ccolor: value == 'Accepted'
          ? Colors.blue
          : value == 'Rejected'
              ? Colors.red
              : null,
      maxLines: maxLines,
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

  _launchMap() {
    return MapsLauncher.launchQuery(widget.booking.location);
  }

  void _showBottomSheetTerms(bool isAccepting) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: ListView(
                children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  if (isAccepting)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: MiniCircularProgressButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showBottomSheetConfirmPayout(
                                isAccepting ? 'Accepted' : 'Rejected', true);
                          },
                          text: "Accept",
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  RichText(
                    textScaler: MediaQuery.of(context).textScaler,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\nTerms and Conditions\n',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text: "\n${widget.booking.termsAndConditions}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        });
      },
    );
  }

  void _showBottomSheetDescriptionMore(String title, String body) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: ListView(
                children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  RichText(
                    textScaler: MediaQuery.of(context).textScaler,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\n${title}\n',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text: "\n${body}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        });
      },
    );
  }

  _scannerMini(
    String data,
    String label,
    bool isValidated,
    VoidCallback onPressed,
    bool isEnlarged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isEnlarged)
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        GestureDetector(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: isEnlarged ? 50.0 : 0),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 700),
                  height: ResponsiveHelper.responsiveHeight(
                      context, isEnlarged ? 200 : 50),
                  width: ResponsiveHelper.responsiveHeight(
                      context, isEnlarged ? 200 : 50),
                  curve: Curves.easeInOut,
                  child: QrImageView(
                    version: QrVersions.auto,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: isValidated ? Colors.blue : Colors.grey,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.circle,
                      color: isValidated ? Colors.blue : Colors.grey,
                    ),
                    backgroundColor: Colors.transparent,
                    data: data,
                    size: ResponsiveHelper.responsiveHeight(context, 50.0),
                  ),
                ),
                if (isEnlarged)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _yourRating() {
    bool noReview = widget.booking.reviewComment.isNotEmpty;
    bool noRating = widget.booking.rating == 0;
    var _divider = Divider(
      thickness: .2,
    );
    var _provider = Provider.of<UserData>(
      context,
    );
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          if (!noRating)
            Center(
                child: StarRatingWidget(
              enableTap: false,
              rating: widget.booking.rating,
              onRatingChanged: (rating) {},
            )),
          const SizedBox(
            height: 30,
          ),
          if (noReview)
            Text(
              widget.booking.reviewComment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (widget.booking.isdownPaymentMade)
            Column(
              children: [
                _divider,
                _scannerMini('first', 'Start time', false, () {
                  HapticFeedback.lightImpact();
                  _provider.enlargeStartBarcode
                      ? _provider.setEnlargeStartBarcode(false)
                      : _provider.setEnlargeStartBarcode(true);
                  _provider.setEnlargeEndBarcode(false);
                  // setState(() {

                  //   _enlargeStartBarcode != _enlargeStartBarcode;
                  // });
                }, _provider.enlargeStartBarcode),
                _divider,
                _scannerMini('first', 'End time', false, () {
                  HapticFeedback.lightImpact();
                  _provider.enlargeEndBarcode
                      ? _provider.setEnlargeEndBarcode(false)
                      : _provider.setEnlargeEndBarcode(true);
                  _provider.setEnlargeStartBarcode(false);
                }, _provider.enlargeEndBarcode),
                _divider,
                Text(
                  '\n\nThe QR code above should be used to validate your arrival and departure times at the client\'s location. If the arrival and departure times are not validated, the payment button will not be activated to process the final payment. Please ensure that the times are validated.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 30,
                ),
                _divider,
              ],
            ),
          const SizedBox(
            height: 30,
          ),
          noReview || !noRating
              ? Text(
                  'Rating and Review',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              : Text(
                  'Your rating and review for this booking would show here.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
        ]);
  }

  _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          height: ResponsiveHelper.responsiveFontSize(context, 20.0),
          width: ResponsiveHelper.responsiveFontSize(context, 20.0),
          child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.blue,
            ),
            strokeWidth: ResponsiveHelper.responsiveFontSize(context, 3.0),
          ),
        ),
      ),
    );
  }

  _rateAndReviewInfo(BuildContext context) {
    bool _isAuthor = widget.booking.creativeId == widget.currentUserId;
    String _scannerText =
        'validate the creative\'s arrival and departure times.This scanning ensures accurate tracking of the creative\'s attendance for the scheduled booking. Please make use of the scanner when the creative arrives and departs to complete the booking process. If the arrival and departure times are not validated, the payment button will not be activated to process the final payment.';

    return widget.booking.answer == 'Rejected'
        ? SizedBox.shrink()
        : ValueListenableBuilder(
            valueListenable: _isTypingNotifier,
            builder: (BuildContext context, bool isTyping, Widget? child) {
              var _provider = Provider.of<UserData>(
                context,
              );
              return _isAuthor
                  ? _yourRating()
                  : Column(
                      children: [
                        if (widget.booking.answer == 'Accepted' &&
                            !widget.booking.isdownPaymentMade)
                          Text(
                            "\n\nOn-site scanner will be available here to help ${_scannerText}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        _provider.affiliatecommission != 0 &&
                                _isTypingNotifier.value
                            ? _isLoadingSubmit
                                ? _loadingIndicator()
                                : Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: MiniCircularProgressButton(
                                          color: Colors.blue,
                                          text: 'Submit',
                                          onPressed: () {
                                            _sendRatings();
                                          }),
                                    ),
                                  )
                            : const SizedBox(
                                height: 60,
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (widget.booking.answer == 'Accepted' &&
                            widget.booking.isdownPaymentMade)
                          widget.booking.departureScanTimestamp == null
                              ? Column(
                                  children: [
                                    AvatarGlow(
                                      animate: true,
                                      showTwoGlows: true,
                                      shape: BoxShape.circle,
                                      glowColor: Colors.blue,
                                      endRadius:
                                          ResponsiveHelper.responsiveHeight(
                                              context, 100.0),
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      repeatPauseDuration:
                                          const Duration(milliseconds: 3000),
                                      child: IconButton(
                                        icon: Icon(Icons.qr_code_scanner),
                                        iconSize:
                                            ResponsiveHelper.responsiveHeight(
                                                context, 50.0),
                                        color: Colors.blue,
                                        onPressed: () {
                                          // _navigateToPage(
                                          //     context,
                                          //     TicketScannerValidatorScreen(
                                          //       event: widget.event,
                                          //       palette: widget.palette!,
                                          //       from: widget.event.isPrivate ? 'Accepted' : '',
                                          //     ));
                                        },
                                      ),
                                    ),
                                    Text(
                                      "Please use the scanner above to  ${_scannerText}",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Center(
                                        child: StarRatingWidget(
                                      rating: _provider.affiliatecommission,
                                      onRatingChanged: (rating) {
                                        _provider.setAffiliateComission(rating);
                                        // _sendRatings(rating);
                                      },
                                    )),
                                    UnderlinedTextField(
                                      autofocus: false,
                                      controler: _commentController,
                                      labelText: 'Terms and conditions',
                                      hintText: 'Reason for donation',
                                      onValidateText: () {},
                                    ),
                                  ],
                                ),
                      ],
                    );
            });
  }

  _congratMessage(IconData icon, String body) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        ShakeTransition(
          duration: const Duration(seconds: 2),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Icon(
              icon,
              size: 30,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          body,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _bookingPriceRateInfo() {
    bool _isAuthor = widget.currentUserId == widget.booking.creativeId;

    var _blueStyle = TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
        color: Colors.blue);

    String status = widget.booking.answer == 'Accepted' &&
                widget.booking.isdownPaymentMade ||
            _downPayment
        ? 'Confirmed and finalized'
        : widget.booking.answer == 'Accepted' &&
                    !widget.booking.isdownPaymentMade ||
                _isAnswered
            ? 'Pending down payment'
            : widget.booking.answer.isEmpty && !_isAuthor
                ? 'Submitted for review.'
                : '';
    var _divider = Divider(
      thickness: .2,
    );
    return Column(
      children: [
        if (widget.booking.isdownPaymentMade || _downPayment)
          Padding(
            padding: const EdgeInsets.only(
              top: 100.0,
            ),
            child: ShakeTransition(
              axis: Axis.vertical,
              child: Icon(
                widget.booking.isFinalPaymentMade
                    ? Icons.check_circle_outline_outlined
                    : Icons.gavel,
                size: ResponsiveHelper.responsiveHeight(context, 50.0),
                color: widget.booking.isFinalPaymentMade
                    ? Colors.green
                    : widget.booking.isEvent
                        ? Color.fromARGB(255, 216, 172, 39)
                        : Colors.green,
              ),
            ),
          ),
        if (!_isAuthor)
          if (widget.booking.answer == 'Accepted' &&
              !widget.booking.isdownPaymentMade &&
              !_downPayment)
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 60.0, right: 10, bottom: 10),
                  child: _isLoadingSubmit
                      ? CircularProgress(
                          isMini: true,
                          indicatorColor: Colors.blue,
                        )
                      : MiniCircularProgressButton(
                          color: Colors.blue,
                          text: 'Pay 30%',
                          onPressed: () {
                            _showBottomSheetConfirmPayout('', false);
                          }),
                )),
        if (widget.booking.answer.isEmpty && _isAuthor && !_isAnswered)
          _congratMessage(Icons.work_outline,
              'You have received a new booking request. Please review the full details of the booking requirements by swiping left.'),
        if (widget.booking.answer == 'Accepted' || _isAnswered)
          if (!widget.booking.isdownPaymentMade && !_downPayment)
            !_isAuthor
                ? _congratMessage(Icons.payment,
                    'Your booking request has been accepted. To confirm and finalize the booking, please make a 30% down payment. You can view the full booking details by swiping left.')
                : Text(
                    '\n\nTo confirm and finalize the booking, your client is required to make a 30% down payment.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
        if (widget.booking.answer.isEmpty && !_isAuthor)
          _congratMessage(Icons.work_outline,
              'Your booking request has been successfully submitted and is now awaiting review. You will be notified once the creative has reviewed and responded to your booking request.'),
        SizedBox(
          height: 30,
        ),
        _divider,
        _payoutWidget('Status', status, null),
        if (widget.booking.isdownPaymentMade || _downPayment) _divider,
        if (widget.booking.isdownPaymentMade || _downPayment)
          _payoutWidget('Down\nPayment', '30% paid', null),
        _divider,
        _payoutWidget('Service', widget.booking.priceRate!.name, null),
        _divider,
        _payoutWidget('Amount', 'GHC ${widget.booking.priceRate!.price}', null),
        _divider,
        _payoutWidget('Duration', widget.booking.priceRate!.duruation, null),
        _divider,
        _payoutWidget('Value', widget.booking.priceRate!.value, null),
        if (_eventHasEnded) _divider,
        if (_eventHasEnded)
          _payoutWidget('Payment\nStatus',
              widget.booking.isFinalPaymentMade ? 'Paid' : '', null),
        _divider,
        _divider,
        ListTile(
          onTap: () {
            _navigateToPage(
                context,
                ProfileScreen(
                  currentUserId: widget.currentUserId,
                  userId: _isAuthor
                      ? widget.booking.clientId
                      : widget.booking.creativeId,
                  user: null,
                ));
          },
          leading: Icon(
            Icons.account_circle_outlined,
            color: Colors.blue,
          ),
          title: Text(
            _isAuthor ? 'See client\'s profile' : 'See creative\'s profile',
            style: _blueStyle,
          ),
        ),
        _divider,
        ListTile(
          onTap: () {
            _showBottomSheetTerms(false);
          },
          leading: Icon(
            Icons.handshake_outlined,
            color: Colors.blue,
          ),
          title: Text(
            'Terms and condition',
            style: _blueStyle,
          ),
        ),
        _divider,
        ListTile(
          onTap: () {
            _launchMap();
          },
          leading: Icon(
            Icons.location_on_outlined,
            color: Colors.blue,
          ),
          title: Text(
            'Location address',
            style: _blueStyle,
          ),
        ),
        _divider,
        ListTile(
          onTap: () {
            _showBottomSheetComfirmDelete(context);
          },
          leading: Icon(
            Icons.delete_outlined,
            color: Colors.red,
          ),
          title: Text(
            'Delete',
            style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
                color: Colors.red),
          ),
        ),
        _divider,
        if (_isAuthor)
          if (widget.booking.answer.isEmpty && !_isAnswered)
            if (!_eventHasEnded)
              _isLoadingSubmit
                  ? Center(
                      child: CircularProgress(
                        isMini: true,
                        indicatorColor: Colors.blue,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _acceptRejectButton('Accept', () {
                            _showBottomSheetTerms(true);
                          }, false),
                          _acceptRejectButton('Reject', () {
                            _showBottomSheetConfirmPayout('Rejected', true);
                          }, false),
                        ],
                      ),
                    ),
      ],
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _bookingRequestInfo() {
    Map<String, int> duration = TimeDuration.calculateDuration(
        widget.booking.startTime.toDate(), widget.booking.endTime.toDate());

    // bool _isAuthor =
    //     widget.currentUserId == widget.booking.creativeId;

    // Extract hours and minutes from the duration map
    //  int days = duration['days']!;
    int hours = duration['hours']!;
    int minutes = duration['minutes']!;

    String durationString = '$hours hours and $minutes minutes';

    var _blueStyle = TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
        color: Colors.blue);
    var _divider = Divider(
      thickness: .2,
    );
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        if (widget.booking.answer.isNotEmpty) _divider,
        if (widget.booking.answer.isNotEmpty)
          _payoutWidget('Status', widget.booking.answer, null),
        _divider,
        _payoutWidget('Booking for',
            widget.booking.isEvent ? 'Event' : 'Creative work', null),
        _divider,
        _payoutWidget('Service', widget.booking.priceRate!.name, null),
        _divider,
        _payoutWidget('Booking\nDate',
            MyDateFormat.toDate(widget.booking.bookingDate.toDate()), null),
        _divider,
        _payoutWidget('Countdown',
            MyDateFormat.toDate(widget.booking.bookingDate.toDate()), null),
        _divider,
        _payoutWidget('Start\nTime',
            MyDateFormat.toTime(widget.booking.startTime.toDate()), null),
        _divider,
        _payoutWidget('End\nTime',
            MyDateFormat.toTime(widget.booking.endTime.toDate()), null),
        _divider,
        _payoutWidget('Duration', durationString, null),
        _divider,
        _payoutWidget('Location', widget.booking.location, 2),
        _divider,
        _payoutWidget('Description', widget.booking.description, 3),
        GestureDetector(
          onTap: () {
            _showBottomSheetDescriptionMore(
              'Description',
              widget.booking.description,
            );
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('more', style: _blueStyle),
          ),
        ),
        _divider,
        _payoutWidget(
            'Special\nrequirements', widget.booking.specialRequirements, 3),
        GestureDetector(
          onTap: () {
            _showBottomSheetDescriptionMore(
              'Special requirements',
              widget.booking.specialRequirements,
            );
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('more', style: _blueStyle),
          ),
        ),
        _divider,
        if (widget.booking.cancellationReason.isNotEmpty)
          _payoutWidget(
              widget.booking.answer == 'Rejected'
                  ? 'Rejection\nreason'
                  : 'Cancellation\nreason',
              widget.booking.cancellationReason,
              5),
        if (widget.booking.cancellationReason.isNotEmpty)
          GestureDetector(
            onTap: () {
              _showBottomSheetDescriptionMore(
                widget.booking.answer == 'Rejected'
                    ? 'Rejection reason'
                    : 'Cancellation reason',
                widget.booking.cancellationReason,
              );
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('more', style: _blueStyle),
            ),
          ),
        _divider,
        if (widget.booking.answer == 'Accepted')
          CountdownTimer(
            split: 'Single',
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            color: Theme.of(context).secondaryHeaderColor,
            clossingDay: DateTime.now(),
            startDate: widget.booking.bookingDate.toDate(),
            eventHasEnded: _eventHasEnded,
            eventHasStarted: _eventHasEnded,
            big: true,
          ),

        // IconButton(
        //     onPressed: () {
        //       _showBottomSheetComfirmDelete(context);
        //     },
        //     icon: Icon(
        //       Icons.delete_forever_outlined,
        //       color: Colors.red,
        //     )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isAuthor = widget.currentUserId == widget.booking.creativeId;
    return Material(
      color: Colors.transparent,
      child: Container(
        height: ResponsiveHelper.responsiveHeight(context, 1000),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            if (_isAuthor)
              const SizedBox(
                height: 40,
              ),
            if (_isAuthor)
              Icon(
                Icons.circle,
                size: ResponsiveHelper.responsiveHeight(context, 15.0),
                color: widget.booking.isEvent
                    ? widget.booking.answer == ''
                        ? Color.fromARGB(255, 255, 229, 152)
                        : widget.booking.answer == 'Rejected'
                            ? Colors.grey
                            : Color.fromARGB(255, 225, 169, 2)
                    : widget.booking.answer == ''
                        ? Colors.green.withOpacity(.4)
                        : widget.booking.answer == 'Rejected'
                            ? Colors.grey
                            : Colors.green,
              ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _indicator(0),
                const SizedBox(
                  width: 5,
                ),
                _indicator(1),
                const SizedBox(
                  width: 5,
                ),
                _indicator(2),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: PageView(
                  onPageChanged: (int index) {
                    setState(() {
                      _index = index;
                    });
                  },
                  children: [
                    _bookingPriceRateInfo(),
                    _bookingRequestInfo(),
                    _rateAndReviewInfo(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
