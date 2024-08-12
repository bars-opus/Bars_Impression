import 'package:bars/utilities/exports.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime startDate;
  final DateTime clossingDay;
  final Color color;
  final double fontSize;
  final String split;
  final bool eventHasStarted;
  final bool eventHasEnded;
  final bool isBold;
  final bool big;

  CountdownTimer({
    required this.startDate,
    required this.clossingDay,
    this.split = '',
    required this.color,
    required this.fontSize,
    required this.eventHasStarted,
    required this.eventHasEnded,
    this.big = false,
    this.isBold = false,
  });

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  String _countDownToStartingDate = '';
  String _metaData = '';

  @override
  void initState() {
    super.initState();
    _countDown();
  }

  void _countDown() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    DateTime eventDate = widget.startDate == null
        ? DateTime.parse('2023-02-27 00:00:00.000')
        : DateTime(widget.startDate.year, widget.startDate.month,
            widget.startDate.day);

    DateTime closingDate = DateTime(widget.clossingDay.year,
        widget.clossingDay.month, widget.clossingDay.day);

    Duration durationToStartingDate = eventDate.difference(today);
    Duration durationDuringStartingToEndingDate = closingDate.difference(today);

    // Determine whether the event date is in the past or future
    bool isPastStartDate = eventDate.isBefore(today);
    bool hasEventStarted = !durationToStartingDate.isNegative;

    // Calculate the absolute difference in days
    int differenceInDays = hasEventStarted
        ? durationToStartingDate.inDays
        : durationToStartingDate.inDays.abs();

    // Format the countdown string based on the difference in days and whether the event date is in the past or future
    String countdownString;
    if (differenceInDays == 0 && hasEventStarted) {
      countdownString = 'Today';
    } else if (differenceInDays == 1) {
      countdownString = isPastStartDate ? 'Yesterday' : 'Tomorrow';
    } else {
      countdownString = widget.split.startsWith('Multiple')
          ? '$differenceInDays'
          : '$differenceInDays days ' + (isPastStartDate ? 'ago' : 'more');
    }

    // Update the state with the countdown string
    if (mounted) {
      setState(() {
        _countDownToStartingDate = countdownString;
        _metaData = ' days ' + (isPastStartDate ? '-' : ' +');
      });
    }
  }

  _countDownWidget() {
    bool _isToday = _countDownToStartingDate == 'Today';
    bool _isCurrent = _countDownToStartingDate == 'Today' ||
        _countDownToStartingDate == 'Yesterday' ||
        _countDownToStartingDate == 'Tomorrow';
    return widget.split.startsWith('Multiple')
        ? RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(children: [
              TextSpan(
                text: '$_countDownToStartingDate',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
                  color: _isToday ? Colors.blue : widget.color,
                  fontWeight: _isToday ? FontWeight.bold : FontWeight.w100,
                ),
              ),
              TextSpan(
                text: _isToday
                    ? '           '
                    : _isCurrent
                        ? ''
                        : '\n$_metaData',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 11.0),
                  color: widget.color,
                ),
              ),
            ]))
        : Text(
            _countDownToStartingDate,
            style: TextStyle(
                color: widget.color,
                fontSize: widget.fontSize,
                fontWeight:
                    widget.isBold ? FontWeight.bold : FontWeight.normal),
            overflow: TextOverflow.ellipsis,
          );
  }

  @override
  Widget build(BuildContext context) {
    return widget.eventHasStarted
        ? Text(
            widget.eventHasEnded ? 'Completed' : 'Ongoing',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.responsiveFontSize(
                  context, widget.big ? 16.0 : 12),
              color: widget.eventHasEnded ? Colors.red : Colors.blue,
            ),
          )
        : _countDownWidget();
  }
}
