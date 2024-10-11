import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EditOpeningHours extends StatefulWidget {
  final Map<String, DateTimeRange> openingHours;

  EditOpeningHours({required this.openingHours});

  @override
  _EditOpeningHoursState createState() => _EditOpeningHoursState();
}

class _EditOpeningHoursState extends State<EditOpeningHours> {
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0);
  Map<String, bool> _selectedDays = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };

  void _updateOpeningHours() {
    if (!_selectedDays.containsValue(true)) {
      // No days selected, handle this case (e.g., show a message)

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
                    'Please select at least one day.',
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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Please select at least one day.')),
      // );
      return;
    }

    var _provider = Provider.of<UserData>(context, listen: false);

    Map<String, DateTimeRange> updatedHours = Map.from(_provider.openingHours);

    _selectedDays.forEach((day, isSelected) {
      if (isSelected) {
        final now = DateTime.now();
        final startDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          _startTime.hour,
          _startTime.minute,
        );
        final endDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          _endTime.hour,
          _endTime.minute,
        );
        updatedHours[day] =
            DateTimeRange(start: startDateTime, end: endDateTime);
      }
    });

    _provider.setOpeningHours(updatedHours);

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
                  'Opening hours updated.',
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

    // Reset selected values to false
    _selectedDays.updateAll((day, isSelected) => false);
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Widget _selectTimeWidget(String time, VoidCallback onPressed) {
    var _textStyle = TextStyle(
      color: Colors.blue,
      fontSize: 14.0,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        CupertinoButton(
          child: Text(
            'Select',
            style: _textStyle,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _textStyle = TextStyle(
      color: Colors.blue,
      fontSize: 14.0,
    );
    var _provider = Provider.of<UserData>(context);
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        TicketPurchasingIcon(
          title: '',
        ),
        const SizedBox(height: 30),
        _selectTimeWidget('Start Time: ${_startTime.format(context)}',
            () => _selectTime(context, true)),
        _selectTimeWidget('End Time: ${_endTime.format(context)}',
            () => _selectTime(context, false)),
        const SizedBox(height: 30),
        Text(
          'Select opening Days',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        Container(
          height: _selectedDays.length *
              ResponsiveHelper.responsiveFontSize(context, 65),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: _selectedDays.keys.map((day) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _selectedDays[day]!
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).primaryColorLight.withOpacity(.5),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _selectedDays[day]!
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
                    style: _selectedDays[day]!
                        ? _textStyle
                        : Theme.of(context).textTheme.bodyMedium,
                  ),
                  value: _selectedDays[day],
                  onChanged: (bool? value) {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _selectedDays[day] = value ?? false;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              );
            }).toList(),
          ),
        ),
        Center(
          child: AlwaysWhiteButton(
            textColor:
                !_selectedDays.containsValue(true) ? Colors.grey : Colors.white,
            buttonText: 'Create opening hours',
            onPressed: _updateOpeningHours,
            buttonColor: !_selectedDays.containsValue(true)
                ? Theme.of(context).cardColor
                : Colors.blue,
          ),
        ),
        const SizedBox(height: 50),
        Divider(),
        const SizedBox(height: 30),
        _provider.openingHours.isEmpty
            ? NoAppointmentWidget()
            : OpeninHoursWidget(
                openingHours: _provider.openingHours,
              ),
        const SizedBox(height: 100),
      ],
    );
  }
}
  
  
//   TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
//   TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0);
//   Map<String, bool> _selectedDays = {
//     "Monday": false,
//     "Tuesday": false,
//     "Wednesday": false,
//     "Thursday": false,
//     "Friday": false,
//     "Saturday": false,
//     "Sunday": false,
//   };

//   void _updateOpeningHours() {
//     var _provider = Provider.of<UserData>(context, listen: false);

//     Map<String, DateTimeRange> updatedHours = Map.from(_provider.openingHours);

//     _selectedDays.forEach((day, isSelected) {
//       if (isSelected) {
//         final now = DateTime.now();
//         final startDateTime = DateTime(
//           now.year,
//           now.month,
//           now.day,
//           _startTime.hour,
//           _startTime.minute,
//         );
//         final endDateTime = DateTime(
//           now.year,
//           now.month,
//           now.day,
//           _endTime.hour,
//           _endTime.minute,
//         );
//         updatedHours[day] =
//             DateTimeRange(start: startDateTime, end: endDateTime);
//       }
//     });

//     _provider.setOpeningHours(updatedHours);

//     // Reset selected values to false
//     _selectedDays.updateAll((day, isSelected) => false);
//   }

//   Future<void> _selectTime(BuildContext context, bool isStartTime) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: isStartTime ? _startTime : _endTime,
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStartTime) {
//           _startTime = picked;
//         } else {
//           _endTime = picked;
//         }
//       });
//     }
//   }

//   _seletctTimeWidget(String time, VoidCallback onPressed) {
//     var _textStyle = TextStyle(
//       color: Colors.blue,
//       fontSize: 14.0,
//     );
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           time,
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//         CupertinoButton(
//           child: Text(
//             'Select',
//             style: _textStyle,
//           ),
//           onPressed: onPressed,
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var _textStyle = TextStyle(
//       color: Colors.blue,
//       fontSize: 14.0,
//     );
//     var _provider = Provider.of<UserData>(context);
//     return ListView(
//       padding: EdgeInsets.all(10.0),
//       children: [
//         TicketPurchasingIcon(
//           title: '',
//         ),
//         const SizedBox(height: 30),
//         _seletctTimeWidget('Start Time: ${_startTime.format(context)}',
//             () => _selectTime(context, true)),
//         _seletctTimeWidget('End Time: ${_endTime.format(context)}',
//             () => _selectTime(context, true)),
//         const SizedBox(height: 30),
//         Text(
//           'Select opening Days',
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//         const SizedBox(height: 10),
//         Container(
//           height: _selectedDays.length *
//               ResponsiveHelper.responsiveFontSize(context, 65),
//           child: ListView(
//             physics: NeverScrollableScrollPhysics(),
//             children: _selectedDays.keys.map((day) {
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 800),
//                 margin: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: _selectedDays[day]!
//                       ? Theme.of(context).primaryColorLight
//                       : Theme.of(context).primaryColorLight.withOpacity(.5),
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: _selectedDays[day]!
//                       ? [
//                           BoxShadow(
//                             color: Colors.black12,
//                             offset: Offset(0, 10),
//                             blurRadius: 8.0,
//                             spreadRadius: 2.0,
//                           )
//                         ]
//                       : [],
//                 ),
//                 child: CheckboxListTile(
//                   title: Text(
//                     day,
//                     style: _selectedDays[day]!
//                         ? _textStyle
//                         : Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   value: _selectedDays[day],
//                   onChanged: (bool? value) {
//                     HapticFeedback.mediumImpact();
//                     setState(() {
//                       _selectedDays[day] = value ?? false;
//                     });
//                   },
//                   activeColor: Colors.blue,
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//         Center(
//           child: AlwaysWhiteButton(
//             textColor: Colors.white,
//             buttonText: 'Create opening hours',
//             onPressed: _updateOpeningHours,
//             buttonColor: Colors.blue,
//           ),
//         ),
//         const SizedBox(height: 50),
//         Divider(),
//         const SizedBox(height: 30),
//         _provider.openingHours.isEmpty
//             ? NoAppointmentWidget()
//             : OpeninHoursWidget(
//                 openingHours: _provider.openingHours,
//               ),
//         const SizedBox(height: 100),
//       ],
//     );
//   }
// }
