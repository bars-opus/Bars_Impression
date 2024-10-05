import 'package:bars/utilities/exports.dart';
import 'package:uuid/uuid.dart';

class EditApointmentSlot extends StatefulWidget {
  final Map<String, DateTimeRange> openingHours;
  // final List<String> services;
  final List<WorkersModel> workers;

  EditApointmentSlot({
    required this.openingHours,
    // required this.services,
    required this.workers,
  });

  @override
  _EditApointmentSlotState createState() => _EditApointmentSlotState();
}

class _EditApointmentSlotState extends State<EditApointmentSlot> {
  // String? selectedService;
  // String price = '';

  final _serviceController = TextEditingController();
  final _typeController = TextEditingController();

  final _priceController = TextEditingController();

  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_onAskTextChanged);
    _serviceController.addListener(_onAskTextChanged);
    _typeController.addListener(_onAskTextChanged);
  }

  void _onAskTextChanged() {
    if (_priceController.text.isNotEmpty ||
        _serviceController.text.isNotEmpty ||
        _typeController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  List<WorkersModel> selectedWorkers = [];
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<String> selectedDays = [];
  String? selectedDuration;
  bool usePredefinedDuration = true;

  final List<String> durations = [
    '30 minutes',
    '1 hour',
    '1 hour 30 minutes',
    '2 hours',
    '3 hours',
    '4 hours',
    '5 hours',
    '6 hours',
    '7 hours',
    '8 hours',
    '9 hours'
  ];

  Duration _parseDuration(String duration) {
    final parts = duration.split(' ');
    int hours = 0;
    int minutes = 0;

    for (var i = 0; i < parts.length; i += 2) {
      final value = int.parse(parts[i]);
      final unit = parts[i + 1];
      if (unit.contains('hour')) {
        hours = value;
      } else if (unit.contains('minute')) {
        minutes = value;
      }
    }

    return Duration(hours: hours, minutes: minutes);
  }

  List<WorkersModel> _getAvailableWorkers(String selectedService) {
    return widget.workers.where((worker) {
      return worker.services
          .toString()
          .trim()
          .toLowerCase()
          .contains(selectedService);
    }).toList();
  }

  bool _isDuringLunchBreak(TimeOfDay start, TimeOfDay end) {
    final lunchStart = TimeOfDay(hour: 12, minute: 0);
    final lunchEnd = TimeOfDay(hour: 13, minute: 0);

    return (start.hour < lunchEnd.hour && end.hour > lunchStart.hour) ||
        (start.hour == lunchStart.hour && start.minute < lunchEnd.minute) ||
        (end.hour == lunchEnd.hour && end.minute > lunchStart.minute);
  }

  void _createSlot() {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (selectedDays.isEmpty ||
        _serviceController.text.isEmpty ||
        selectedWorkers.isEmpty ||
        (usePredefinedDuration && selectedDuration == null) ||
        (!usePredefinedDuration && (startTime == null || endTime == null))) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select all fields.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('OK'))
          ],
        ),
      );
      return;
    }

    DateTimeRange openingRange = widget.openingHours[selectedDays.first]!;
    if (usePredefinedDuration) {
      startTime = TimeOfDay.fromDateTime(openingRange.start);
      final duration = _parseDuration(selectedDuration!);
      final end = startTime!.replacing(
        hour: (startTime!.hour + duration.inHours) % 24,
        minute: (startTime!.minute + duration.inMinutes) % 60,
      );
      endTime = end;
    }

    final openingStart = TimeOfDay.fromDateTime(openingRange.start);
    final openingEnd = TimeOfDay.fromDateTime(openingRange.end);

    bool isValidEndTime = (endTime!.hour < openingEnd.hour) ||
        (endTime!.hour == openingEnd.hour &&
            endTime!.minute <= openingEnd.minute);

    if (!isValidEndTime || _isDuringLunchBreak(startTime!, endTime!)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Selected time is outside opening hours.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('OK'))
          ],
        ),
      );
      return;
    }

    final _price = double.tryParse(_priceController.text) ?? 0.0;
    String commonId = Uuid().v4();

    AppointmentSlotModel _appointment = AppointmentSlotModel(
      id: commonId,
      days: selectedDays,
      duruation: selectedDuration!,
      // startTime: startTime!,
      // endTime: endTime!,
      service: _serviceController.text.trim(),
      workers: selectedWorkers, price: _price,
      type: _typeController.text.trim(), favoriteWorker: true,
    );

    _provider.setAppointmentSlots(_appointment);
    _serviceController.clear();
    _priceController.clear();
    _typeController.clear();

    setState(() {
      startTime = null;
      endTime = null;

      selectedWorkers = [];
      selectedDuration = null;
      selectedDays = [];
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Appointment slot created.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider2 = Provider.of<UserData>(
      context,
    );
    return ValueListenableBuilder(
        valueListenable: _isTypingNotifier,
        builder: (BuildContext context, bool isTyping, Widget? child) {
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Text('Select Days'),
              ...widget.openingHours.keys.map((day) {
                return CheckboxListTile(
                  title: Text(day),
                  value: selectedDays.contains(day),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedDays.add(day);
                      } else {
                        selectedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Use Predefined Duration'),
                  Switch(
                    value: usePredefinedDuration,
                    onChanged: (value) {
                      setState(() {
                        usePredefinedDuration = value;
                        startTime = null;
                        endTime = null;
                      });
                    },
                  ),
                ],
              ),
              if (usePredefinedDuration)
                DropdownButton<String>(
                  hint: Text('Select Duration'),
                  value: selectedDuration,
                  onChanged: (value) =>
                      setState(() => selectedDuration = value),
                  items: durations.map((duration) {
                    return DropdownMenuItem<String>(
                      value: duration,
                      child: Text(duration),
                    );
                  }).toList(),
                ),
              // if (!usePredefinedDuration)
              //   Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           Text('Start: ${startTime?.format(context) ?? 'Not set'}'),
              //           CupertinoButton(
              //             child: Text('Select Start Time'),
              //             onPressed: () => _selectTime(context, true),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           Text('End: ${endTime?.format(context) ?? 'Not set'}'),
              //           CupertinoButton(
              //             child: Text('Select End Time'),
              //             onPressed: () => _selectTime(context, false),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // DropdownButton<String>(
              //   hint: Text('Select Service'),
              //   value: selectedService,
              //   onChanged: (value) {
              //     setState(() {
              //       selectedService = value;
              //       selectedWorkers = [];
              //     });
              //   },
              //   items: widget.services.map((service) {
              //     return DropdownMenuItem<String>(
              //       value: service,
              //       child: Text(service),
              //     );
              //   }).toList(),
              // ),
              LoginField(
                notLogin: true,
                labelText: 'Service',
                hintText: "service you offer",
                onValidateText: () {},
                icon: Icons.email,
                controller: _serviceController,
              ),

              LoginField(
                notLogin: true,
                labelText: 'Service type',
                hintText: "type of service you offer",
                onValidateText: () {},
                icon: Icons.email,
                controller: _typeController,
              ),

              LoginField(
                notLogin: true,
                icon: Icons.email,
                controller: _priceController,
                labelText: 'Price',
                hintText: "price of the savice",
                // initialValue: '',
                // onSavedText: (input) => price = input,
                // onChanged: (value) {
                //   setState(() {
                //     price = value;
                //   });
                // },
                onValidateText: () {},
              ),
              if (_serviceController.text.isNotEmpty)
                Column(
                  children: _getAvailableWorkers(
                          _serviceController.text.trim().toLowerCase())
                      .map((worker) {
                    return CheckboxListTile(
                      title: Text(worker.name),
                      value: selectedWorkers.contains(worker),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedWorkers.add(worker);
                          } else {
                            selectedWorkers.remove(worker);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Create Appointment Slot'),
                onPressed: _createSlot,
              ),
              SizedBox(height: 40),
              TicketGroup(
                appointmentSlots: _provider2.appointmentSlots,
                edit: true,
              ),
            ],
          );
        });
  }
}
