import 'dart:html';

import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EventSheduleCalendar extends StatelessWidget {
  final Event event;
  final int duration;
  final String currentUserId;

  const EventSheduleCalendar(
      {super.key,
      required this.event,
      required this.currentUserId,
      required this.duration});

  Map<DateTime, List<Schedule>> convertToMap(List<Schedule> shedules) {
    Map<DateTime, List<Schedule>> scheduleMap = {};
    for (Schedule schedule in shedules) {
      DateTime date = schedule.scheduleDate.toDate();
      DateTime normalizedDate = DateTime(date.year, date.month, date.day);
      if (scheduleMap[normalizedDate] == null) {
        scheduleMap[normalizedDate] = [];
      }
      scheduleMap[normalizedDate]?.add(schedule);
    }
    return scheduleMap;
  }

  _launchMap() {
    return MapsLauncher.launchQuery(event.address);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    List<Schedule> scheduleOptions = [];

    for (Schedule schedule in event.schedule) {
      scheduleOptions.add(schedule);
    }
    scheduleOptions.sort(
        (a, b) => a.scheduleDate.toDate().compareTo(b.scheduleDate.toDate()));

    DateTime _scheduleFirsttDay = scheduleOptions.first.scheduleDate.toDate();
    DateTime _scheduleLastDay = scheduleOptions.last.scheduleDate.toDate();
    DateTime _startDay = event.startDate.toDate();
    DateTime _astDay = event.clossingDay.toDate();

    DateTime _calendarFirstDay =
        _startDay.isBefore(_scheduleFirsttDay) ? _startDay : _scheduleFirsttDay;

    DateTime _calendarLastDay =
        _astDay.isAfter(_scheduleLastDay) ? _astDay : _scheduleLastDay;

    DateTime _focusedDay =
        _startDay.isBefore(_scheduleFirsttDay) ? _startDay : _scheduleFirsttDay;

    Map<DateTime, List<Schedule>> _sheduleDates = convertToMap(scheduleOptions);
    var blueTextStyle = TextStyle(
        color: Colors.blue,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14));

    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 650.0),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          // Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TicketPurchasingIcon(
                      title: '',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(
                      ResponsiveHelper.responsiveWidth(context, 5)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CountdownTimer(
                      color: Theme.of(context).secondaryHeaderColor,
                      clossingDay: DateTime.now(),
                      startDate: event.startDate.toDate(),
                      isBold: true,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 20.0),
                      eventHasEnded: false,
                      eventHasStarted: false,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                event.startDate == null
                    ? const SizedBox.shrink()
                    : Container(
                        margin: EdgeInsets.all(
                            ResponsiveHelper.responsiveWidth(context, 5)),
                        height:
                            ResponsiveHelper.responsiveHeight(context, 400.0),
                        width: width.toDouble(),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              ResponsiveHelper.responsiveWidth(context, 5)),
                          child: Container(
                            margin: EdgeInsets.all(
                                ResponsiveHelper.responsiveWidth(context, 5)),
                            height: ResponsiveHelper.responsiveHeight(
                                context, 400.0),
                            width: width.toDouble(),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).cardColor.withOpacity(.3),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TableCalendar(
                              eventLoader: (day) {
                                DateTime normalizedDay =
                                    DateTime(day.year, day.month, day.day);

                                return _sheduleDates[normalizedDay] ?? [];
                              },
                              pageAnimationCurve: Curves.easeInOut,
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              calendarFormat: CalendarFormat.month,
                              availableGestures:
                                  AvailableGestures.horizontalSwipe,
                              rowHeight: ResponsiveHelper.responsiveHeight(
                                  context, 50.0),
                              daysOfWeekHeight:
                                  ResponsiveHelper.responsiveHeight(
                                      context, 30),
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                defaultTextStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                markerDecoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                holidayTextStyle: TextStyle(color: Colors.red),
                                outsideDaysVisible: true,
                              ),
                              headerStyle: HeaderStyle(
                                titleTextStyle: TextStyle(
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14),
                                ),
                                formatButtonDecoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                formatButtonVisible: false,
                                formatButtonTextStyle:
                                    TextStyle(color: Colors.white),
                                formatButtonShowsNext: false,
                              ),
                              firstDay: _calendarFirstDay,
                              focusedDay: _focusedDay,
                              lastDay: _calendarLastDay,
                              onDaySelected: (selectedDay, focusedDay) {
                                DateTime normalizedDay = DateTime(
                                    selectedDay.year,
                                    selectedDay.month,
                                    selectedDay.day);
                                List<Schedule> selectedEvents =
                                    _sheduleDates[normalizedDay] ?? [];
                                HapticFeedback.mediumImpact();

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        surfaceTintColor: Colors.transparent,
                                        backgroundColor: Colors.transparent,
                                        titlePadding: const EdgeInsets.all(0),
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  // size: ResponsiveHelper.responsiveFontSize(context, 20),
                                                )),
                                            Text(
                                              MyDateFormat.toDate(selectedDay),
                                              style: TextStyle(
                                                  fontSize: ResponsiveHelper
                                                      .responsiveFontSize(
                                                          context, 20.0),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                        content: Container(
                                          height:
                                              ResponsiveHelper.responsiveHeight(
                                                  context, 800),
                                          width:
                                              ResponsiveHelper.responsiveHeight(
                                                  context, 400),
                                          color: Colors.transparent,
                                          child: selectedEvents.isEmpty
                                              ? Center(
                                                  child: NoContents(
                                                      title: 'No Schedules',
                                                      subTitle:
                                                          'The event organizer didn\'t provide schedules for this date. If you want to know more about the schedules and program lineup, you can contact the organizer',
                                                      icon: Icons
                                                          .watch_later_outlined),
                                                )
                                              : ListView(

                                                  // mainAxisSize: MainAxisSize.min,
                                                  children: selectedEvents
                                                      .map((schedule) =>
                                                          ScheduleWidget(
                                                            schedule: schedule,
                                                            edit: false,
                                                            from: 'Calendar',
                                                            currentUserId:
                                                                currentUserId,
                                                          ))
                                                      .toList()),
                                        ));
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            EventDateInfo(
              duration: duration,
              endDate: event.clossingDay.toDate(),
              startDate: event.startDate.toDate(),
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding:
                  EdgeInsets.all(ResponsiveHelper.responsiveWidth(context, 5)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: event.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextSpan(
                        text: "\n${event.theme}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _launchMap,
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "This event would take place at ${event.venue}: ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: event.address,
                      style: blueTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin:
                  EdgeInsets.all(ResponsiveHelper.responsiveWidth(context, 5)),
              height: ResponsiveHelper.responsiveHeight(context, 400.0),
              width: width.toDouble(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const SizedBox(
              height: 60,
            ),

            Text(
              'Featured people',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Performers and Crew",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding:
                  EdgeInsets.all(ResponsiveHelper.responsiveWidth(context, 10)),
              // height: ResponsiveHelper.responsiveHeight(context, 400.0),
              width: width.toDouble(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ShedulePeopleHorizontal(
                edit: false,
                from: '',
                schedulepeople: event.taggedPeople,
                currentUserId: currentUserId,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Partners and Sponsers",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding:
                  EdgeInsets.all(ResponsiveHelper.responsiveWidth(context, 10)),
              // height: ResponsiveHelper.responsiveHeight(context, 400.0),
              width: width.toDouble(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ShedulePeopleHorizontal(
                edit: false,
                from: '',
                schedulepeople: event.taggedPeople,
                currentUserId: currentUserId,
              ),
            ),
            const SizedBox(
              height: 60,
            ),

            if (event.termsAndConditions.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(
                    ResponsiveHelper.responsiveWidth(context, 5)),
                child: Text(
                  "Terms and Conditions",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (event.termsAndConditions.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(
                    ResponsiveHelper.responsiveWidth(context, 5)),
                child: Text(
                  event.termsAndConditions,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (event.termsAndConditions.isNotEmpty)
              const SizedBox(
                height: 60,
              ),
            Padding(
              padding:
                  EdgeInsets.all(ResponsiveHelper.responsiveWidth(context, 5)),
              child: Text(
                'Organizer\'s info',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              thickness: .4,
            ),
            BottomModelSheetListTileActionWidget(
              colorCode: 'Blue',
              icon: Icons.account_circle,
              onPressed: () {
                // _showBottomSheetContactOrganizer(context);
              },
              text: 'View profile',
            ),
            Divider(
              thickness: .4,
            ),
            BottomModelSheetListTileActionWidget(
              colorCode: 'Blue',
              icon: Icons.call_outlined,
              onPressed: () {
                // _showBottomSheetContactOrganizer(context);
              },
              text: 'Call organizer',
            ),
            // Container(
            //   width: double.infinity,
            //   height: ResponsiveHelper.responsiveHeight(
            //     context,
            //     width * width.toDouble(),
            //   ),
            //   decoration: BoxDecoration(
            //     color: Colors.transparent,
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 0.0),
            //     child: ScheduleGroup(
            //       from: 'EventEnlarged',
            //       schedules: event.schedule,
            //       isEditing: false,
            //       eventOrganiserId: event.authorId,
            //       currentUserId: currentUserId,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
