import 'package:bars/utilities/exports.dart';

class OnCalendarScheduleList extends StatelessWidget {
  final List<Schedule> schedules;

  const OnCalendarScheduleList({Key? key, required this.schedules})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
      var _currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;
    return Container(
      height: height.toDouble(),
      width: width.toDouble(),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(30)),
      child: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (BuildContext context, int index) {
          Schedule schedule = schedules[index];
          return ScheduleWidget(
            schedule: schedule,
            edit: false, currentUserId: _currentUserId!,
          );
        },
      ),
    );
  }
}
