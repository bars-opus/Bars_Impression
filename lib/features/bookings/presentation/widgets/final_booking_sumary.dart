import 'package:bars/utilities/exports.dart';

class FinalBookingSummary extends StatefulWidget {
  final UserStoreModel bookingShop;
  final BookingAppointmentModel appointmentOrder;

  const FinalBookingSummary(
      {super.key, required this.bookingShop, required this.appointmentOrder});

  @override
  State<FinalBookingSummary> createState() => _FinalBookingSummaryState();
}

class _FinalBookingSummaryState extends State<FinalBookingSummary> {
  _sendBookingRequest(
    BookingAppointmentModel appointmentOrder,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    _showBottomSheetLoading('Sending booking request');
    var _user = Provider.of<UserData>(context, listen: false).user;

    if (_provider.isLoading) {
      return;
    }
    if (mounted) {
      _provider.setIsLoading(true);

      // setState(() {
      //   _isLoadingSubmit = true;
      // });
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

    Future<void> sendInvites() => DatabaseService.createBookingAppointment(
          currentUser: _user!,
          booking: appointmentOrder,
        );

    try {
      await retry(() => sendInvites(), retries: 3);

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      _showBottomSheetBookingSuccesful();
      // Navigator.pop(context);
      _clear();
      mySnackBar(context, "Service successfully booked");
    } catch (e) {
      Navigator.pop(context);
      _showBottomSheetErrorMessage(context, 'Could not send book service');
    } finally {
      _endLoading();
    }
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

  void _showBottomSheetBookingSuccesful() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 350),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: ListView(
            children: [
              TicketPurchasingIcon(
                title: '',
              ),
              ShakeTransition(
                duration: const Duration(seconds: 2),
                child: Icon(
                  Icons.check_circle_outline_outlined,
                  size: 50,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Booking\nsuccessful',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Your booking to ${widget.bookingShop.shopName}. has been succesful. The booking details is now available on your calendar.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _endLoading() {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (mounted) {
      _provider.setIsLoading(false);
      // setState(() {
      //   _isLoadingSubmit = false; // Set isLoading to false
      // });
    }
  }

  _clear() {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setAddress('');
    _provider.appointmentSlots.clear();
    _provider.setFinalBookingAppointment(null);
    _provider.appointmentWorkers.clear();
    _provider.selectedSlots.clear();
    _provider.setIsLoading(false);
    _provider.addressSearchResults = null;
    _provider.setIsVirtual(false);
    _provider.setIsEndTimeSelected(false);
    _provider.setIsStartTimeSelected(false);
    // _provider.setBookingPriceRate(null);
  }

  void _showBottomConfirmBooking(
    BookingAppointmentModel appointmentOrder,
  ) {
    // String amount = _bookingAmountController.text;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 350,
          buttonText: 'Book',
          onPressed: () async {
            Navigator.pop(context);
            _sendBookingRequest(appointmentOrder);
          },
          title: 'Confirm booking',
          subTitle:
              'You are send booking request? This request must be accepted by this creative before the booking would be effective. Not that this creative is not oblige to respond or accept this request.',
        );
      },
    );
  }

  _eventOnTicketAndPurchaseButton(
    BuildContext context,
    BookingAppointmentModel appointmentOrder,
  ) {
    var _provider = Provider.of<UserData>(
      context,
    );

    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        if (appointmentOrder.appointment.isNotEmpty)
          Center(
            child: AlwaysWhiteButton(
              buttonText: 'Book service',
              onPressed: () {
                _showBottomConfirmBooking(appointmentOrder);
              },
              buttonColor: Colors.blue,
            ),
          ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          TicketPurchasingIcon(
            title: 'Payment.',
          ),
          const SizedBox(
            height: 20,
          ),
          BookingSummaryWidget(
            edit: true,
            currency: widget.bookingShop.currency,
            appointmentOrder: widget.appointmentOrder,
          ),
          _eventOnTicketAndPurchaseButton(context, widget.appointmentOrder),
        ],
      ),
    );
  }
}
