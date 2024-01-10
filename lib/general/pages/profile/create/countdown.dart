import 'package:bars/utilities/exports.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime startDate;
  final DateTime clossingDay;
  final Color color;
  final double fontSize;
  final String split;

  CountdownTimer(
      {required this.startDate,
      required this.clossingDay,
      this.split = '',
      required this.color,
      required this.fontSize});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  String _countDownToStartingDate = '';
  String _singleCountDownToStartingDate = '';
  String _metaData = '';

  bool _eventHasStarted = false;
  bool _eventHasEnded = false;

  @override
  void initState() {
    super.initState();
    _countDown();
  }

  void _countDown() async {
    DateTime eventDate = widget.startDate == null
        ? DateTime.parse('2023-02-27 00:00:00.000')
        : widget.startDate;

    DateTime clossingDate = widget.clossingDay;

    final toDaysDate = DateTime.now();

    Duration _durationToStartingDate = eventDate.difference(toDaysDate);
    Duration _duratoinDuringStartingToEndingDate =
        clossingDate.difference(toDaysDate);

    // Determine whether the event date is in the past or future
    bool isPastStartDate = eventDate.isBefore(toDaysDate);

    // Calculate the absolute difference in days
    int differenceInDays = _durationToStartingDate.inDays.abs();

    // Format the countdown string based on the difference in days and whether the event date is in the past or future
    String countdownString =
        differenceInDays == 1 ? 'A day ' : '$differenceInDays\ndays ';
    countdownString += isPastStartDate ? 'ago' : 'more';

    // Update the state with the countdown string
    if (mounted) {
      setState(() {
        _countDownToStartingDate = countdownString;
        _singleCountDownToStartingDate =
            differenceInDays == 1 ? 'A day ' : '$differenceInDays';
        _metaData = isPastStartDate ? 'days -' : 'days +';
      });
    }

    // Check if the event has started or ended
    // if (eventDate.isBefore(toDaysDate)) {
    //   if (mounted) {
    //     setState(() {
    //       _eventHasStarted = true;
    //     });
    //   }
    // }

    if (EventHasStarted.hasEventStarted(widget.startDate)) {
      if (mounted) {
        setState(() {
          _eventHasStarted = true;
        });
      }
    }

    if (EventHasStarted.hasEventEnded(widget.clossingDay)) {
      if (mounted) {
        setState(() {
          _eventHasEnded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.split.startsWith('Multiple')
        ? RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(children: [
              TextSpan(
                text: '$_singleCountDownToStartingDate',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '\n$_metaData',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 11.0),
                  color: widget.color,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ]))
        : widget.split.startsWith('Single')
            ? Text(
                '$_singleCountDownToStartingDate $_metaData',
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.color,
                  // fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                _countDownToStartingDate,
                style:
                    TextStyle(color: widget.color, fontSize: widget.fontSize),
                overflow: TextOverflow.ellipsis,
              );
  }
}
