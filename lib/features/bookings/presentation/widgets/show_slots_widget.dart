import 'package:bars/utilities/exports.dart';
import 'package:uuid/uuid.dart';

class ShowSlotWidget extends StatefulWidget {
  final UserStoreModel bookingShop;

  const ShowSlotWidget({super.key, required this.bookingShop});

  @override
  State<ShowSlotWidget> createState() => _ShowSlotWidgetState();
}

class _ShowSlotWidgetState extends State<ShowSlotWidget> {
  void _showBottomFinalPurhcaseSummary(
    BuildContext context,
    BookingAppointmentModel bookedAppointmentClient,
    BookingAppointmentModel bookedAppointmentShop,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 640),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30)),
            child: FinalBookingSummary(
              bookingShop: widget.bookingShop,
              bookedAppointmentShop: bookedAppointmentShop,
              bookedAppointmentClient: bookedAppointmentClient,
            ));
      },
    );
  }

  _creatingBookingData(BuildContext context) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    print(_provider.appointmentWorkers);

    List<BookedAppointmentModel> bookedAppointments = [];

    for (var appointmentSlot in _provider.appointmentSlots) {
      // Find matching selected slots
      var matchingSlots = _provider.selectedSlots.where((selectedSlot) =>
          selectedSlot.service == appointmentSlot.service &&
          selectedSlot.type == appointmentSlot.type);

      var matchingWorkers = _provider.appointmentWorkers.where((worker) {
        bool serviceMatch = worker.services
            .any((service) => appointmentSlot.service.contains(service));
        bool typeMatch =
            worker.role.any((type) => appointmentSlot.type.contains(type));
        return serviceMatch && typeMatch;
      }).toList();

      for (var selectedSlot in matchingSlots) {
        // Find matching workers for the service
        // var matchingWorkers = _provider.appointmentWorkers
        //     .where(
        //         (worker) => worker.services.contains(appointmentSlot.service))
        //     .toList();

        // print(matchingWorkers);

        // Create a booked appointment model
        BookedAppointmentModel appointment = BookedAppointmentModel(
          id: appointmentSlot.id,
          price: appointmentSlot.price,
          workers: matchingWorkers,
          service: appointmentSlot.service,
          type: appointmentSlot.type,
          duruation: appointmentSlot.duruation,
          selectedSlot: selectedSlot.selectedSlot,
        );

        bookedAppointments.add(appointment);
        String commonId = Uuid().v4();

        BookingAppointmentModel bookedAppointmentClient =
            BookingAppointmentModel(
          id: commonId,
          shopId: widget.bookingShop.userId,
          isFinalPaymentMade: false,
          clientId: _provider.currentUserId!,
          appointment: bookedAppointments,
          bookingDate: _provider.startDate,
          location: widget.bookingShop.address,
          rating: 0,
          reviewComment: '',
          timestamp: Timestamp.fromDate(DateTime.now()),
          termsAndConditions: '',
          cancellationReason: '',
          shopName: widget.bookingShop.shopName,
          shopLogoUrl: widget.bookingShop.shopLogomageUrl,
          specialRequirements: '',
          isdownPaymentMade: false,
          shopType: widget.bookingShop.shopType,
        );

        BookingAppointmentModel bookedAppointmentShop = BookingAppointmentModel(
          id: commonId,
          shopId: widget.bookingShop.userId,
          isFinalPaymentMade: false,
          clientId: _provider.currentUserId!,
          appointment: bookedAppointments,
          bookingDate: _provider.startDate,
          location: widget.bookingShop.address,
          rating: 0,
          reviewComment: '',
          timestamp: Timestamp.fromDate(DateTime.now()),
          termsAndConditions: '',
          cancellationReason: '',
          shopName: _provider.user!.userName!,
          //  widget.bookingShop.shopName,
          shopLogoUrl: _provider.user!.profileImageUrl!,
          specialRequirements: '',
          isdownPaymentMade: false,
          shopType: '',
        );
        _showBottomFinalPurhcaseSummary(
            context, bookedAppointmentClient, bookedAppointmentShop);

        // _provider.setFinalBookingAppointment(bookedAppointment);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        var _provider = Provider.of<UserData>(
          context,
        );

        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 660),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TicketPurchasingIcon(
                      title: '',
                    ),
                    if (_provider.selectedSlots.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: MiniCircularProgressButton(
                          color: Colors.blue,
                          text: 'Continue',
                          onPressed: () {
                            _creatingBookingData(context);
                            // Implement continue logic
                          },
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 20),
                TimeSlotSelection(
                  shopId: widget.bookingShop.userId,
                  appointmentSlots: _provider.appointmentSlots,
                  openingHours: widget.bookingShop.openingHours,
                  selectedDate: _provider.startDate.toDate(),
                  selectedWorkers: _provider.appointmentWorkers,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
