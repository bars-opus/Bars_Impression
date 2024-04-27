import 'package:bars/utilities/exports.dart';

class NoScheduleCalendar extends StatelessWidget {
  final VoidCallback askMoreOnpressed;
  final bool showAskMore;
  const NoScheduleCalendar(
      {super.key, required this.askMoreOnpressed, required this.showAskMore});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ResponsiveHelper.responsiveHeight(context, 650.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NoContents(
                title: 'No Schedules',
                subTitle:
                    'The event organizer didn\'t provide schedules for this event. If you want to know more about the schedules and program lineup, you can',
                icon: Icons.watch_later_outlined),
            if (showAskMore)
              GestureDetector(
                onTap: askMoreOnpressed,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: Text(
                    'ask a question here',
                    style: TextStyle(color: Colors.blue, fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14),),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ));
  }
}
