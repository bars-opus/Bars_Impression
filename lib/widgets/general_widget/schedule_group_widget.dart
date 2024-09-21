import 'package:bars/utilities/exports.dart';

class ScheduleGroup extends StatelessWidget {
  final List<Schedule> schedules;
  final bool isEditing;
  final String from;
  final String currentUserId;
  final String eventOrganiserId;

  final Timestamp? ticketEventDate;

  ScheduleGroup(
      {Key? key,
      required this.schedules,
      required this.isEditing,
      this.from = '',
      this.ticketEventDate,
      required this.currentUserId,
      required this.eventOrganiserId})
      : super(key: key);

  void _removeShedule(BuildContext context, Schedule removingShedule) {
    var _provider = Provider.of<UserData>(context, listen: false);
    schedules.removeWhere((schedule) =>
        schedule.title == removingShedule.title &&
        schedule.startTime == removingShedule.startTime);
    _provider.setInt2(1);
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;
    // Sort the schedules by date in ascending order
    schedules.sort((a, b) => a.scheduleDate.compareTo(b.scheduleDate));

    // Group the schedules by their scheduleDate
    Map<DateTime, List<Schedule>> groupedSchedules = {};
    for (Schedule schedule in schedules) {
      DateTime dateWithoutTime = DateTime(
        schedule.scheduleDate.toDate().year,
        schedule.scheduleDate.toDate().month,
        schedule.scheduleDate.toDate().day,
      );
      if (!groupedSchedules.containsKey(dateWithoutTime)) {
        groupedSchedules[dateWithoutTime] = [];
      }
      groupedSchedules[dateWithoutTime]!.add(schedule);
    }

    final width = MediaQuery.of(context).size.width;

    if (ticketEventDate != null) {
      DateTime ticketDate = ticketEventDate!.toDate();
      DateTime ticketDateWithoutTime = DateTime(
        ticketDate.year,
        ticketDate.month,
        ticketDate.day,
      );
      // Keep only the schedules for ticketEventDate
      groupedSchedules = {
        ticketDateWithoutTime: groupedSchedules[ticketDateWithoutTime] ?? []
      };
    }

    // Check if the list for the specific date is empty
    bool isListEmpty = ticketEventDate != null &&
        groupedSchedules[ticketEventDate!.toDate()] != null &&
        groupedSchedules[ticketEventDate!.toDate()]!.isEmpty;

    return isListEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 150),
            child: GestureDetector(
              onTap: () {
                _navigateToPage(
                    context,
                    ProfileScreen(
                      user: null,
                      currentUserId: currentUserId,
                      userId: eventOrganiserId,
                    ));
              },
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'There are no program lineups or schedules provided for the ticket date of this event. You can contact the ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                      ),
                    ),
                    TextSpan(
                      text: 'event organizer ',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                      ),
                    ),
                    TextSpan(
                      text:
                          'directly to learn more about the program structure.\n\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            height: width * width,
            width: isEditing ? width - 40 : width,
            child: ListView.builder(
              physics: isEditing || from == 'EventEnlarged'
                  ? NeverScrollableScrollPhysics()
                  : AlwaysScrollableScrollPhysics(),
              itemCount: groupedSchedules.keys.length,
              itemBuilder: (BuildContext context, int index) {
                // Get the date and schedules for the current index
                DateTime date = groupedSchedules.keys.elementAt(index);
                List<Schedule> dateSchedules = groupedSchedules[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    // Display the date
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: from.isEmpty ? 0 : 20),
                      child: Text(
                        MyDateFormat.toDate(date),
                        // DateFormat('yyyy-MM-dd').format(date),
                        style: TextStyle(
                            color: from.isEmpty || from == 'Schedule'
                                ? Colors.white
                                : Theme.of(context).secondaryHeaderColor,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 16),
                            // from.isEmpty ? 20 : 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Display the schedules for this date
                    ...dateSchedules.map((schedule) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: from.isEmpty ? 0 : 16),
                        child: Stack(
                          children: [
                            ScheduleWidget(
                              from: 'Calendar',
                              schedule: schedule,
                              edit: isEditing,
                              currentUserId: _currentUserId!,
                            ),
                            if (isEditing)
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Row(
                                  children: [
                                    // IconButton(
                                    //   onPressed: () =>
                                    //       _showBottomSheetAddSchedule(
                                    //           context, schedule),
                                    //   icon: Icon(
                                    //     Icons.edit,
                                    //     color: Colors.blue,
                                    //   ),
                                    // ),
                                    IconButton(
                                      onPressed: () =>
                                          _removeShedule(context, schedule),
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            ),
          );
  }
}
