import 'package:bars/utilities/exports.dart';

class SelectWorkers extends StatefulWidget {
  final bool edit;
  final bool fromProfile;
  final UserStoreModel bookingShop;

  // final Map<String, DateTimeRange> openingHours;

  const SelectWorkers(
      {super.key,
      required this.edit,
      required this.fromProfile,
      // required this.openingHours,
      required this.bookingShop});

  @override
  State<SelectWorkers> createState() => _SelectWorkersState();
}

class _SelectWorkersState extends State<SelectWorkers> {
  _selectGenerateTimeSlot() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ShowSlotWidget(bookingShop: widget.bookingShop);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      var _provider2 = Provider.of<UserData>(
        context,
      );
      return Container(
        height: ResponsiveHelper.responsiveHeight(context, 680),
        decoration: BoxDecoration(
          color: Colors.blue[50],
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
                  if (_provider2.appointmentWorkers.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: MiniCircularProgressButton(
                            color: Colors.blue,
                            text: 'Continue',
                            onPressed: () async {
                              _provider.selectedSlots.clear();
                              _selectGenerateTimeSlot();
                            }),
                      ),
                    ),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                padding: EdgeInsets.all(
                    ResponsiveHelper.responsiveWidth(context, 2)),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: ShedulePeopleHorizontal(
                  edit: false,
                  workers: _provider2.appointmentWorkers,
                  currentUserId: _provider.currentUserId!,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: ResponsiveHelper.responsiveHeight(context, 50 * 900),
                width: double.infinity,
                child: SelectAppointmentWorkers(
                  fromProfile: widget.fromProfile,
                  appointmentSlots: _provider2.appointmentSlots,
                  isEditing: widget.edit,
                  currency: _provider.currency,
                  eventId: '',
                  eventAuthorId: '',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
