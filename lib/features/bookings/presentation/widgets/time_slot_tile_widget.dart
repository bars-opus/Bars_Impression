import 'package:bars/utilities/exports.dart';
import 'package:uuid/uuid.dart';

class TimeSlotTile extends StatefulWidget {
  final List<TimeOfDay> slots;
  final Duration interval;
  final String service;
  final String type;
  final String uniqueId; // Add this
  final String duration;

  const TimeSlotTile({
    Key? key,
    required this.slots,
    required this.interval,
    required this.service,
    required this.type,
    required this.duration,
    required this.uniqueId, // Add this
  }) : super(key: key);

  @override
  _TimeSlotTileState createState() => _TimeSlotTileState();
}

class _TimeSlotTileState extends State<TimeSlotTile> {
  int _selectedIndex = -1;

  Map<String, bool> selectedSlots = {};

  TimeOfDay addDuration(TimeOfDay time, Duration duration) {
    final now = DateTime.now();
    final fullDate =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final newDate = fullDate.add(duration);
    return TimeOfDay(hour: newDate.hour, minute: newDate.minute);
  }

  void _toggleSlot(SelectedSlotModel slot) {
    var _provider = Provider.of<UserData>(context, listen: false);

    // Remove existing slot for the same service and type
    _provider.selectedSlots.removeWhere((existingSlot) =>
        existingSlot.service == slot.service &&
        existingSlot.type == slot.type &&
        existingSlot.id == widget.uniqueId);

    // Add the current slot
    _provider.addSelectedSlotToList(slot);

    setState(() {
      selectedSlots = {slot.id: true}; // Update local state for UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          ResponsiveHelper.responsiveHeight(context, widget.slots.length * 75),
      child: ListView.builder(
        itemCount: widget.slots.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          TimeOfDay startSlot = widget.slots[index];
          TimeOfDay endSlot = addDuration(startSlot, widget.interval);
          return Container(
            decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? Colors.blue[50]
                    : Colors.transparent,
                border: Border.all(
                    width: .1, color: Colors.grey[300] ?? Colors.grey)),
            child: RadioListTile<int>(
              value: index,
              groupValue: _selectedIndex,
              onChanged: (value) {
                // String commonId = Uuid().v4();
                SelectedSlotModel _slot = SelectedSlotModel(
                  type: widget.type,
                  id: widget.uniqueId,
                  selectedSlot: startSlot,
                  service: widget.service,
                );

                setState(() {
                  _selectedIndex = value!;
                });
                _toggleSlot(_slot);
              },
              title: Text(
                '${startSlot.format(context)}   -  ${endSlot.format(context)}',
                style: TextStyle(
                  fontSize: _selectedIndex == index ? 16 : 14,
                  fontWeight: _selectedIndex == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedIndex == index ? Colors.blue : Colors.black,
                ),
              ),
              subtitle: Text(
                widget.duration,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              activeColor: Colors.blue,
              selected: _selectedIndex == index,
            ),
          );
        },
      ),
    );
  }
}
