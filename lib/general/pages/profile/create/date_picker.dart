import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime) onStartDateChanged;
  final Function(DateTime) onEndDateChanged;

  final Function(DateTime) onStartTimeChanged;
  final Function(DateTime) onEndTimeChanged;
  final bool date;

  DatePicker(
      {required this.onStartDateChanged,
      required this.onEndDateChanged,
      required this.date,
      required this.onStartTimeChanged,
      required this.onEndTimeChanged});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 150));
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0);

  _selector(
    String title,
    String dateTime,
    VoidCallback onPressed,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PickOptionWidget(
          title: title,
          onPressed: onPressed,
          dropDown: true,
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            dateTime,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  _stateDateSelector() {
    var _provider = Provider.of<UserData>(context, listen: false);
    return _selector(
      'Start Date',
      _provider.startDateString.isNotEmpty
          ? "    ${MyDateFormat.toDate(DateTime.parse(_provider.startDateString))}"
          : '',
      () {
        _showStartDatePicker('Start');
      },
    );
  }

  _endDateSelector() {
    var _provider = Provider.of<UserData>(context, listen: false);
    return _selector(
      'End Date',
      _provider.clossingDayString.isNotEmpty
          ? "    ${MyDateFormat.toDate(DateTime.parse(_provider.clossingDayString))}"
          : '',
      () {
        _showStartDatePicker('End');
      },
    );
  }

  _dateSelector() {
    return Column(
      children: [
        _stateDateSelector(),
        _endDateSelector(),
      ],
    );
  }

  _stateTimeSelector() {
    var _provider = Provider.of<UserData>(context, listen: false);
    return Container(
        // color: Colors.red,
        width: ResponsiveHelper.responsiveFontSize(context, 160),
        child: _selector(
          'Start Time',
          _provider.startTimeSelected
              ? "    ${_startTime.format(context)}"
              : '',
          () {
            _showStartTimePicker('Start');
          },
        ));
  }

  _endTimeSelector() {
    var _provider = Provider.of<UserData>(context, listen: false);
    return Container(
        // color: Colors.red,
        width: ResponsiveHelper.responsiveFontSize(context, 160),
        child: _selector(
          'End Time',
          _provider.endTimeSelected ? "    ${_endTime.format(context)}" : '',
          () {
            _showStartTimePicker('End');
          },
        ));
  }

  _timeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stateTimeSelector(),
          _endTimeSelector(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.date ? _dateSelector() : _timeSelector();

    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Container(
    //       color: Colors.red,
    //       width: 200,
    //       child: _firstSelector(),
    //     ),
    //     Container(
    //       width: 100,
    //       child: _secondSelector(),
    //     ),
    //   ],
    // );
  }

  // Column(
  //         children: [
  //           widget.date
  //               ? _selector(
  //                   'Start Date',
  //                   _provider.startDateString.isNotEmpty
  //                       ? "    ${MyDateFormat.toDate(DateTime.parse(_provider.startDateString))}"
  //                       : '',
  //                   () {
  //                     _showStartDatePicker('Start');
  //                   },
  //                 )
  //               : const SizedBox.shrink(),
  //           widget.date
  //               ? _selector(
  //                   'End Date',
  //                   _provider.clossingDayString.isNotEmpty
  //                       ? "    ${MyDateFormat.toDate(DateTime.parse(_provider.clossingDayString))}"
  //                       : '',
  //                   () {
  //                     _showStartDatePicker('End');
  //                   },
  //                 )
  //               : const SizedBox.shrink(),
  //           !widget.date
  //               ? _selector(
  //                   'Start Time',
  //                   _provider.startTimeSelected
  //                       ? "    ${_startTime.format(context)}"
  //                       : '',
  //                   () {
  //                     _showStartTimePicker('Start');
  //                   },
  //                 )
  //               : const SizedBox.shrink(),
  //           !widget.date
  // ? _selector(
  //     'End Time',
  //     _provider.endTimeSelected
  //         ? "    ${_endTime.format(context)}"
  //         : '',
  //     () {
  //       _showStartTimePicker('End');
  //     },
  //   )
  //               : const SizedBox.shrink(),
  //         ],
  //       ),

  _paddingForDatePicket(Widget widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 10),
              blurRadius: 10.0,
              spreadRadius: 4.0,
            )
          ],
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: widget,
      ),
    );
  }

  void _showStartDatePicker(String from) {
    var _size = MediaQuery.of(context).size;
    var _provider = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: _size.height / 1.5,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: DoubleOptionTabview(
                height: _size.width + 20,
                initalTab: from.startsWith('Start') ? 0 : 1,
                tabText1: 'Start Date',
                tabText2: 'End Date',
                widget1: _paddingForDatePicket(
                  CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    minimumYear: 2023,
                    maximumYear: 2026,
                    // backgroundColor: Theme.of(context).primaryColorLight,
                    initialDateTime: _startDate,
                    maximumDate: _endDate.subtract(Duration(days: 1)),
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _provider.setIsStartDateSelected(true);
                        _startDate = newDate;
                        if (_startTime.hour < _startDate.hour) {
                          _startTime =
                              TimeOfDay(hour: _startDate.hour, minute: 0);

                          // _startDateSelected = true;
                        }
                      });
                      if (widget.onStartDateChanged != null) {
                        widget.onStartDateChanged(newDate);
                      }
                    },
                  ),
                ),
                widget2: _paddingForDatePicket(
                  CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _endDate,
                    minimumYear: 2023,
                    maximumYear: 2026,
                    minimumDate: _startDate.add(Duration(days: 1)),
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _provider.setIsEndDateSelected(true);
                        _endDate = newDate;
                        if (_endTime.hour > _endDate.hour) {
                          _endTime = TimeOfDay(hour: _endDate.hour, minute: 0);

                          // _endDateSelected = true;
                        }
                      });
                      if (widget.onEndDateChanged != null) {
                        widget.onEndDateChanged(newDate);
                      }
                    },
                  ),
                ),
                onPressed: (int) {},
                lightColor: false,
                pageTitle: '',
              ),
            ));
      },
    );
  }

  void _showStartTimePicker(String from) {
    var _size = MediaQuery.of(context).size;
    var _provider = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: _size.height / 1.5,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: DoubleOptionTabview(
                lightColor: false,
                height: _size.width + 20,
                initalTab: from.startsWith('Start') ? 0 : 1,
                tabText1: 'Start Time',
                tabText2: 'End Time',
                widget1: _paddingForDatePicket(
                  CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime(_startDate.year, _startDate.month,
                        _startDate.day, _startTime.hour, _startTime.minute),
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() {
                        _startTime = TimeOfDay.fromDateTime(newTime);
                        _provider.setIsStartTimeSelected(true);
                        // _startTimeSelected = true;
                      });

                      if (widget.onStartTimeChanged != null) {
                        widget.onStartTimeChanged(newTime);
                      }
                    },
                  ),
                ),
                widget2: _paddingForDatePicket(
                  CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime(
                      _endDate.year,
                      _endDate.month,
                      _endDate.day,
                      _endTime.hour,
                      _endTime.minute,
                    ),
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() {
                        _provider.setIsEndTimeSelected(true);

                        _endTime = TimeOfDay.fromDateTime(newTime);
                        // _endTimeSelected = true;
                      });

                      if (widget.onEndTimeChanged != null) {
                        widget.onEndTimeChanged(newTime);
                      }
                    },
                  ),
                ),
                onPressed: (int) {},
                pageTitle: '',
              ),
            ));
      },
    );
  }
}
