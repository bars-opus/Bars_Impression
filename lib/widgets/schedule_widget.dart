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

  _buildDisplayPortfolioGrid(BuildContext context, Schedule shedule) {
    List<SchedulePeopleModel> people = shedule.people;

    final width = MediaQuery.of(context).size.width;
    List<Widget> tiles = [];
    people.forEach(
        (people) => tiles.add(_buildPeople(context, width, people, false)));

    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 120),
      child: GridView.count(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2, // Items down the screen
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio:
            0.3, // Adjust this to change the vertical size, smaller number means smaller height
        children: tiles,
      ),
    );
  }

  _buildPeople(BuildContext context, double width, SchedulePeopleModel person,
      bool fullWidth) {
    // var _currentUserId =
    //     Provider.of<UserData>(context, listen: false).currentUserId;

    return Padding(
      padding: fullWidth
          ? EdgeInsets.only(top: 5.0, left: 10, right: 10)
          : EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
            color: from.isEmpty
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColor.withOpacity(.5),
            borderRadius: BorderRadius.circular(5)),
        width: fullWidth ? width : width / 2,
        child: Padding(
          padding:
              fullWidth ? EdgeInsets.all(10.0) : EdgeInsets.only(bottom: 2.0),
          child: GestureDetector(
            onTap: edit || from == 'Calendar'
                ? () {}
                : () {
                    person.externalProfileLink!.isEmpty
                        ? _navigateToPage(
                            context,
                            ProfileScreen(
                              currentUserId: currentUserId,
                              userId: person.internalProfileLink!,
                              user: null,
                            ))
                        : _showBottomSheetWork(
                            context, person.name, person.externalProfileLink!);
                  },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveHeight(
                  context,
                  5,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      person.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: fullWidth ? null : 2,
                      overflow: fullWidth ? null : TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    height: ResponsiveHelper.responsiveHeight(
                      context,
                      40,
                    ),
                    width: ResponsiveHelper.responsiveHeight(
                      context,
                      30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (person.verifiedTag)
                          Icon(
                            Icons.verified,
                            size: ResponsiveHelper.responsiveHeight(
                              context,
                              10,
                            ),
                            color: Colors.blue,
                          ),
                        Icon(
                          person.internalProfileLink!.isNotEmpty
                              ? Icons.arrow_forward_ios
                              : Icons.link,
                          size: ResponsiveHelper.responsiveHeight(
                            context,
                            15,
                          ),
                          color: Colors.blue,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetWork(
    BuildContext context,
    String type,
    String link,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height.toDouble() / 2,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                DisclaimerWidget(
                  title: type,
                  subTitle:
                      'You will be redirected to wibesite, where you can read, listen or watch $type. Please note that Bars Impression assumes no liability or responsibility for the information, views, or opinions presented on that platform.',
                  icon: Icons.link,
                ),
                const SizedBox(
                  height: 30,
                ),
                BottomModalSheetButtonBlue(
                  buttonText: type,
                  onPressed: () async {
              if (!await launchUrl(Uri.parse(link))) {
                throw 'Could not launch link';
              }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => MyWebView(
                    //               url: link,
                    //               title: '',
                    //             )));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> startTimePartition =
        MyDateFormat.toTime(schedule.startTime.toDate()).split(" ");
    final List<String> endTimePartition =
        MyDateFormat.toTime(schedule.endTime.toDate()).split(" ");
    // final List<String> _startDatePartition =
    //     MyDateFormat.toDate(schedule.startTime.toDate()).split(" ");
    // final List<String> _endDatePartition =
    MyDateFormat.toDate(schedule.endTime.toDate()).split(" ");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        color: Theme.of(context).primaryColorLight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: ListTile(
            leading: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(children: [
                  TextSpan(
                    text: startTimePartition[0].toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (startTimePartition.length > 1)
                    TextSpan(
                      text: "\n${startTimePartition[1].toUpperCase()} ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ])),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(right: 50.0),
                //   child: Text(
                //     MyDateFormat.toDate(schedule.scheduleDate.toDate()),
                //     style: Theme.of(context).textTheme.bodyLarge,
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${startTimePartition[0]} ${startTimePartition[1]}\nTo --- >  ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${endTimePartition[0]} ${endTimePartition[1]}\n',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  schedule.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                _buildDisplayPortfolioGrid(context, schedule),
                // Text(
                //   schedule.performer,
                //   style: Theme.of(context).textTheme.bodyMedium,
                // ),
                Divider(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.4),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
