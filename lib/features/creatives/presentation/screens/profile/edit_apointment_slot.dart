import 'package:bars/utilities/exports.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EditApointmentSlot extends StatefulWidget {
  final Map<String, DateTimeRange> openingHours;
  // final List<String> services;
  final List<ShopWorkerModel> workers;

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

  List<ShopWorkerModel> selectedWorkers = [];
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

  List<ShopWorkerModel> _getAvailableWorkers(String selectedService) {
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
                backgroundColor: Theme.of(context).primaryColorLight,
                surfaceTintColor: Colors.transparent,
                elevation: 50,
                title: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Icon(
                    Icons.error_outline_outlined,
                    color: Colors.red,
                    size: ResponsiveHelper.responsiveFontSize(context, 30),
                  ),
                ),
                content: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Please select all fields.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center, // Center text alignment
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'OK',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ));
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
      day: selectedDays,
      duruation: selectedDuration!,
      // startTime: startTime!,
      // endTime: endTime!,
      service: _serviceController.text.trim(),
      workers: selectedWorkers, price: _price,
      type: _typeController.text.trim(), favoriteWorker: false,
    );

    print(_appointment.toString());

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
              backgroundColor: Theme.of(context).primaryColorLight,
              surfaceTintColor: Colors.transparent,
              elevation: 50,
              title: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Icon(
                  Icons.check,
                  color: Colors.blue,
                  size: ResponsiveHelper.responsiveFontSize(context, 30),
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'Appointment slot created.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center, // Center text alignment
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ));
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('Success'),
    //     content: Text('Appointment slot created.'),
    //     actions: [
    //       TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
    //     ],
    //   ),
    // );
  }

  void _showBottomWorkers() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: ResponsiveHelper.responsiveFontSize(context, 600),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(30)),
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
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
                ],
              ),
            );
          });
        });
  }

  _selectedWorkers() {
    var _provider = Provider.of<UserData>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.responsiveWidth(context, 2)),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ShedulePeopleHorizontal(
              edit: true,
              workers: selectedWorkers,
              currentUserId: _provider.currentUserId!,
            ),
          ),
          IconButton(
              onPressed: () {
                _showBottomWorkers();
              },
              icon: Icon(Icons.edit,
                  size: ResponsiveHelper.responsiveFontSize(context, 20),
                  color: Theme.of(context).secondaryHeaderColor))
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
              TicketPurchasingIcon(
                title: '',
              ),
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
                onValidateText: () {},
              ),
              const SizedBox(height: 20),
              if (usePredefinedDuration)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none, // Remove the underline
                  ),
                  elevation: 0,
                  hint: Text(
                    'Select Duration',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                    ),
                  ),
                  value: selectedDuration,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) =>
                      setState(() => selectedDuration = value),
                  items: durations.map((duration) {
                    return DropdownMenuItem<String>(
                      value: duration,
                      child: Text(
                        duration,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium, // Change font size here
                      ),
                    );
                  }).toList(),
                  dropdownColor: Theme.of(context).primaryColorLight,
                  selectedItemBuilder: (BuildContext context) {
                    return durations.map((String value) {
                      return Text(
                        value,
                        style: Theme.of(context).textTheme.bodyLarge,
                      );
                    }).toList();
                  },
                ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              selectedWorkers.isNotEmpty
                  ? _selectedWorkers()
                  : GestureDetector(
                      onTap: () {
                        _showBottomWorkers();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Select workers',
                          style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14),
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

              if (selectedWorkers.isEmpty)
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              const SizedBox(height: 40),
              Text(
                'Select Days',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              ...widget.openingHours.keys.map((day) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: selectedDays.contains(day)
                        ? Theme.of(context).primaryColorLight
                        : Theme.of(context).primaryColorLight.withOpacity(.5),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: selectedDays.contains(day)
                        ? [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 10),
                              blurRadius: 8.0,
                              spreadRadius: 2.0,
                            )
                          ]
                        : [],
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      day,
                      style: selectedDays.contains(day)
                          ? Theme.of(context).textTheme.bodyLarge
                          : Theme.of(context).textTheme.bodyMedium,
                    ),
                    value: selectedDays.contains(day),
                    activeColor: Colors.blue,
                    onChanged: (bool? value) {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        if (value == true) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                  ),
                );
              }).toList(),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Text('Use Predefined Duration'),
              //     Switch(
              //       value: usePredefinedDuration,
              //       onChanged: (value) {
              //         setState(() {
              //           usePredefinedDuration = value;
              //           startTime = null;
              //           endTime = null;
              //         });
              //       },
              //     ),
              //   ],
              // ),

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

              // if (_serviceController.text.isNotEmpty)

              SizedBox(height: 50),
              Center(
                child: AlwaysWhiteButton(
                  textColor: selectedDays.isEmpty ? Colors.grey : Colors.white,
                  buttonText: 'Create Appointment Slot',
                  onPressed: _createSlot,
                  buttonColor: selectedDays.isEmpty
                      ? Theme.of(context).cardColor
                      : Colors.blue,
                ),
              ),
              // ElevatedButton(
              //   child: Text('Create Appointment Slot'),
              //   onPressed: _createSlot,
              // ),
              SizedBox(height: 70),
              Divider(),
              // SizedBox(height: 20),
              TicketGroup(
                fromPrice: false,
                appointmentSlots: _provider2.appointmentSlots,
                openingHours: widget.openingHours,
                edit: true,
                bookingShop: null,
              ),
            ],
          );
        });
  }
}
