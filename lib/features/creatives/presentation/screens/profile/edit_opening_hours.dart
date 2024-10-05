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

  @override
  Widget build(BuildContext context) {
    var _textStyle = TextStyle(
      color: Colors.blue,
      fontSize: 14.0,
    );
    var _provider = Provider.of<UserData>(context);
    return ListView(
      children: [
        const SizedBox(height: 30),
        Container(
          height: 400,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: _selectedDays.keys.map((day) {
              return CheckboxListTile(
                title: Text(
                  day,
                  style: _selectedDays[day]!
                      ? _textStyle
                      : Theme.of(context).textTheme.bodyMedium,
                ),
                value: _selectedDays[day],
                onChanged: (bool? value) {
                  setState(() {
                    _selectedDays[day] = value ?? false;
                  });
                },
                activeColor: Colors.blue,
              );
            }).toList(),
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start Time: ${_startTime.format(context)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            CupertinoButton(
              child: Text(
                'Select',
                style: _textStyle,
              ),
              onPressed: () => _selectTime(context, true),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'End Time: ${_endTime.format(context)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            CupertinoButton(
              child: Text(
                'Select',
                style: _textStyle,
              ),
              onPressed: () => _selectTime(context, false),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ElevatedButton(
            child: Text('Add'),
            onPressed: _updateOpeningHours,
          ),
        ),
        const SizedBox(height: 60),
        OpeninHoursWidget(
          openingHours: _provider.openingHours.isEmpty
              ? {
                  "Monday": DateTimeRange(start: DateTime(0), end: DateTime(0)),
                  "Tuesday":
                      DateTimeRange(start: DateTime(0), end: DateTime(0)),
                  // More days...
                }
              : _provider.openingHours,
        ),
      ],
    );
  }
}
