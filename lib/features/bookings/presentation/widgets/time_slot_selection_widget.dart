import 'package:bars/utilities/exports.dart';

class TimeSlotSelection extends StatefulWidget {
  final List<AppointmentSlotModel> appointmentSlots;
  final Map<String, DateTimeRange> openingHours;
  final DateTime selectedDate;
  final String shopId;
  final List<ShopWorkerModel> selectedWorkers;

  const TimeSlotSelection({
    Key? key,
    required this.appointmentSlots,
    required this.openingHours,
    required this.selectedDate,
    required this.shopId,
    required this.selectedWorkers,
  }) : super(key: key);

  @override
  State<TimeSlotSelection> createState() => _TimeSlotSelectionState();
}

class _TimeSlotSelectionState extends State<TimeSlotSelection> {
  List<BookedAppointmentModel> bookedAppointments = [];

  @override
  void initState() {
    super.initState();
    fetchBookedAppointments();
  }

  Future<void> fetchBookedAppointments() async {
    final workerIds =
        widget.selectedWorkers.map((worker) => worker.id).toList();

    final querySnapshot = await newBookingsReceivedRef
        .doc(widget.shopId)
        .collection('bookings')
        .where('bookingDate',
            isEqualTo: Timestamp.fromDate(widget.selectedDate))
        .get();

    setState(() {
      bookedAppointments = querySnapshot.docs
          .map((doc) => BookingAppointmentModel.fromDoc(doc).appointment)
          .expand((appointments) => appointments)
          .where((booking) =>
              booking.workers.any((worker) => workerIds.contains(worker.id)))
          .toList();
    });
  }

  List<TimeOfDay> filterAvailableSlots(
      List<TimeOfDay> slots, Duration duration) {
    return slots.where((slot) {
      final endSlot = addDuration(slot, duration);
      return !bookedAppointments.any((booking) {
        final bookedSlot = booking.selectedSlot;
        return bookedSlot != null &&
            bookedSlot.hour == slot.hour &&
            bookedSlot.minute == slot.minute;
      });
    }).toList();
  }

  List<TimeOfDay> generateFilteredTimeSlots(
      AppointmentSlotModel slot, DateTime selectedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = selectedDate.isAtSameMomentAs(today);

    List<TimeOfDay> availableSlots = generateTimeSlotsForAppointment(
      slot,
      selectedDate,
      widget.openingHours,
    );

    if (isToday) {
      availableSlots = availableSlots
          .where((time) =>
              time.hour > now.hour ||
              (time.hour == now.hour && time.minute > now.minute))
          .toList();
    }

    return availableSlots;
  }

  TimeOfDay addDuration(TimeOfDay time, Duration duration) {
    final now = DateTime.now();
    final fullDate =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final newDate = fullDate.add(duration);
    return TimeOfDay(hour: newDate.hour, minute: newDate.minute);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, List<TimeOfDay>>> slotsByServiceAndType = {};

    // Group slots by service and type
    for (var slot in widget.appointmentSlots) {
      String service = slot.service;
      String type = slot.type;

      if (!slotsByServiceAndType.containsKey(service)) {
        slotsByServiceAndType[service] = {};
      }
      if (!slotsByServiceAndType[service]!.containsKey(type)) {
        slotsByServiceAndType[service]![type] = [];
      }

      List<TimeOfDay> availableSlots =
          generateFilteredTimeSlots(slot, widget.selectedDate);

      Duration duration = DurationUtils.parseDuration(slot.duruation);

      slotsByServiceAndType[service]![type]!.addAll(
        filterAvailableSlots(availableSlots, duration),
      );
    }

    return Container(
      height: 300 * 300,
      child: ListView.builder(
        itemCount: slotsByServiceAndType.length,
        itemBuilder: (context, serviceIndex) {
          String service = slotsByServiceAndType.keys.elementAt(serviceIndex);
          Map<String, List<TimeOfDay>> types = slotsByServiceAndType[service]!;

          List<Widget> typeWidgets = types.entries.map((entry) {
            String type = entry.key;
            List<TimeOfDay> timeSlots = entry.value;

            return Card(
              color: Theme.of(context).primaryColorLight,
              elevation: 0.5,
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  type.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                children: [
                  timeSlots.isEmpty
                      ? Center(
                          child: NoContents(
                            icon: Icons.check_circle_outline,
                            title: 'No available slots',
                            subTitle:
                                'All ${type} services and workers are booked for this day. Kindly try another day.\n\n',
                          ),
                        )
                      : TimeSlotTile(
                          slots: timeSlots,
                          interval: DurationUtils.parseDuration(widget
                              .appointmentSlots
                              .firstWhere((slot) =>
                                  slot.service == service && slot.type == type)
                              .duruation),
                          service: service,
                          type: type,
                          uniqueId: entry.key,
                          duration: widget.appointmentSlots
                              .firstWhere((slot) =>
                                  slot.service == service && slot.type == type)
                              .duruation,
                        ),
                ],
              ),
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    service,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...typeWidgets,
              ],
            ),
          );
        },
      ),
    );
  }
}

// class TimeSlotSelection extends StatefulWidget {
//   final List<AppointmentSlotModel> appointmentSlots;
//   final Map<String, DateTimeRange> openingHours;

//   const TimeSlotSelection({
//     Key? key,
//     required this.appointmentSlots,
//     required this.openingHours,
//   }) : super(key: key);

//   @override
//   State<TimeSlotSelection> createState() => _TimeSlotSelectionState();
// }

// class _TimeSlotSelectionState extends State<TimeSlotSelection> {
//   @override
//   Widget build(BuildContext context) {
//     var _provider = Provider.of<UserData>(context, listen: false);
//     Map<String, Map<String, List<TimeOfDay>>> slotsByServiceAndType = {};

//     DateTime selectedDate = _provider.startDate.toDate();

//     // Group slots by service and type
//     for (var slot in widget.appointmentSlots) {
//       String service = slot.service;
//       String type = slot.type;

//       if (!slotsByServiceAndType.containsKey(service)) {
//         slotsByServiceAndType[service] = {};
//       }
//       if (!slotsByServiceAndType[service]!.containsKey(type)) {
//         slotsByServiceAndType[service]![type] = [];
//       }

//       List<TimeOfDay> availableSlots = generateTimeSlotsForAppointment(
//         slot,
//         selectedDate,
//         widget.openingHours,
//       );

//       slotsByServiceAndType[service]![type]!.addAll(availableSlots);
//     }

//     return Container(
//       height: 300 * 300,
//       child: ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: slotsByServiceAndType.length,
//         itemBuilder: (context, serviceIndex) {
//           String service = slotsByServiceAndType.keys.elementAt(serviceIndex);
//           Map<String, List<TimeOfDay>> types = slotsByServiceAndType[service]!;

//           List<Widget> typeWidgets = types.entries.map((entry) {
//             String type = entry.key;
//             String id = entry.key;

//             // Find the corresponding AppointmentSlotModel
//             AppointmentSlotModel? correspondingSlot =
//                 widget.appointmentSlots.firstWhere(
//               (slot) => slot.service == service && slot.type == type,
//             );

//             Duration duration = correspondingSlot != null
//                 ? DurationUtils.parseDuration(correspondingSlot.duruation)
//                 : Duration.zero;

//             List<TimeOfDay> timeSlots = entry.value;

//             return Card(
//               color: Theme.of(context).primaryColorLight,
//               elevation: 0.5,
//               child: ExpansionTile(
//                 initiallyExpanded: true,
//                 title: Text(
//                   type.toUpperCase(),
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 children: [
//                   TimeSlotTile(
//                     slots: timeSlots,
//                     interval: duration,
//                     service: service,
//                     type: type,
//                     uniqueId: id,
//                     duration: correspondingSlot.duruation,
//                   ),
//                 ],
//               ),
//             );
//           }).toList();

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     service,
//                     style: Theme.of(context).textTheme.titleSmall,
//                   ),
//                 ),
//                 ...typeWidgets,
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
