import 'package:bars/utilities/exports.dart';

class ScheduleWidget extends StatelessWidget {
  final Schedule schedule;
  final bool edit;
  final String from;
  final String currentUserId;

  ScheduleWidget(
      {required this.schedule,
      required this.edit,
      this.from = '',
      required this.currentUserId});

  _peopleMini(BuildContext context) {
    int maxDisplayCount = 9;
    int displayCount = schedule.people.length > maxDisplayCount
        ? maxDisplayCount
        : schedule.people.length;
    int remainingCount = schedule.people.length > maxDisplayCount
        ? schedule.people.length - maxDisplayCount
        : 0;

    double overlapOffset = 25.0;

    return ShakeTransition(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        height: schedule.people.isEmpty
            ? 0
            : ResponsiveHelper.responsiveWidth(context, 50),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            ...List.generate(displayCount, (index) {
              String imageUrl = schedule.people[index].profileImageUrl ?? '';

              return Positioned(
                left: index * overlapOffset,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    shape: BoxShape.circle,
                  ),
                  child: imageUrl.isEmpty
                      ? Icon(
                          Icons.account_circle,
                          size: 36.0,
                          color: Colors.grey,
                        )
                      : CircleAvatar(
                          radius: 17, // Adjust the radius as needed
                          backgroundColor: Colors.blue,
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                ),
              );
            }),
            if (remainingCount > 0)
              Positioned(
                left: displayCount * overlapOffset,
                child: Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '+$remainingCount',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12),
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _scheduleTitle(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> startTimePartition =
        MyDateFormat.toTime(schedule.startTime.toDate()).split(" ");
    final List<String> endTimePartition =
        MyDateFormat.toTime(schedule.endTime.toDate()).split(" ");
    final width = MediaQuery.of(context).size.width;
    Map<String, int> duration = TimeDuration.calculateDuration(
        schedule.startTime.toDate(), schedule.endTime.toDate());
    int hours = duration['hours']!;
    int minutes = duration['minutes']!;
    String durationString = '$hours hours and $minutes minutes';
    MyDateFormat.toDate(schedule.endTime.toDate()).split(" ");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Stack(
                        children: [
                          Container(
                            height:
                                ResponsiveHelper.responsiveHeight(context, 800),
                            width:
                                ResponsiveHelper.responsiveHeight(context, 400),
                            padding: EdgeInsets.only(
                                top: ResponsiveHelper.responsiveFontSize(
                                    context, 120)),
                            color: Colors.transparent,
                            child: ListView.builder(
                              itemCount: schedule.people.length,
                              itemBuilder: (context, index) {
                                var person = schedule.people[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5),
                                  child: ScheduleBuildPeople(
                                    currentUserId: currentUserId,
                                    edit: edit,
                                    from: 'list',
                                    width: width,
                                    fullWidth: false,
                                    person: person,
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 70,
                            left: 20,
                            child: _scheduleTitle(context),
                          ),
                        ],
                      );
                    });
              },
              child: _peopleMini(context),
            ),
            Text(
              '${startTimePartition[0]} ${startTimePartition[1]}    --->   ${endTimePartition[0]} ${endTimePartition[1]} ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              durationString,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              schedule.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
