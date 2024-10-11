import 'package:bars/utilities/exports.dart';

class TimeSlotSelection extends StatefulWidget {
  final List<AppointmentSlotModel> appointmentSlots;
  final Map<String, DateTimeRange> openingHours;

  const TimeSlotSelection({
    Key? key,
    required this.appointmentSlots,
    required this.openingHours,
  }) : super(key: key);

  @override
  State<TimeSlotSelection> createState() => _TimeSlotSelectionState();
}

class _TimeSlotSelectionState extends State<TimeSlotSelection> {
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    Map<String, Map<String, List<TimeOfDay>>> slotsByServiceAndType = {};

    DateTime selectedDate = _provider.startDate.toDate();

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

      List<TimeOfDay> availableSlots = generateTimeSlotsForAppointment(
        slot,
        selectedDate,
        widget.openingHours,
      );

      slotsByServiceAndType[service]![type]!.addAll(availableSlots);
    }

    return Container(
      height: 300 * 300,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: slotsByServiceAndType.length,
        itemBuilder: (context, serviceIndex) {
          String service = slotsByServiceAndType.keys.elementAt(serviceIndex);
          Map<String, List<TimeOfDay>> types = slotsByServiceAndType[service]!;

          List<Widget> typeWidgets = types.entries.map((entry) {
            String type = entry.key;
            String id = entry.key;

            // Find the corresponding AppointmentSlotModel
            AppointmentSlotModel? correspondingSlot =
                widget.appointmentSlots.firstWhere(
              (slot) => slot.service == service && slot.type == type,
            );

            Duration duration = correspondingSlot != null
                ? DurationUtils.parseDuration(correspondingSlot.duruation)
                : Duration.zero;

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
                  TimeSlotTile(
                    slots: timeSlots,
                    interval: duration,
                    service: service,
                    type: type,
                    uniqueId: id,
                    duration: correspondingSlot.duruation,
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
