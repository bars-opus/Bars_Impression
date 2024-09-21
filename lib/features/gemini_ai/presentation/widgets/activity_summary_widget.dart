// This widget displays a summary of activities, grouped by type.
// It shows a count and allows users to view detailed activities in a modal.

import 'package:bars/utilities/exports.dart';

class ActivitySummaryWidget extends StatelessWidget {
  final List<Activity> activities;

  ActivitySummaryWidget({required this.activities});

  // Groups activities by type and counts them
  Map<NotificationActivityType, int> _groupAndCountActivities() {
    Map<NotificationActivityType, int> activityCounts = {};

    for (var activity in activities) {
      NotificationActivityType type = activity.type;
      activityCounts[type] = (activityCounts[type] ?? 0) + 1;
    }

    return activityCounts;
  }

  // Builds a summary row with an icon and text
  Widget _summaryRow(
    BuildContext context,
    IconData icon,
    String summary,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.responsiveHeight(context, 20),
          color: Colors.red,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            summary,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
            ),
          ),
        ),
      ],
    );
  }

  // Shows a modal bottom sheet with activities of a specific type
  void _showActivitiesByType(BuildContext context, List<Activity> activities) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          var _provider = Provider.of<UserData>(context, listen: false);

          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 600),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TicketPurchasingIcon(
                  title: '',
                ),
                Container(
                  height: ResponsiveHelper.responsiveHeight(context, 530),
                  child: ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (BuildContext context, int index) {
                      final activity = activities[index];
                      return ActivityWidget(
                        activity: activity,
                        currentUserId: _provider.currentUserId!,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  // Wraps the summary row in a container and makes it tappable
  Widget _summaryContainer(BuildContext context, IconData icon, String summary,
      List<Activity> activities) {
    return GestureDetector(
      onTap: () => _showActivitiesByType(context, activities),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: _summaryRow(
          context,
          icon,
          summary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Counts activities by type
    Map<NotificationActivityType, int> activityCounts =
        _groupAndCountActivities();

    // Maps activity types to icons
    Map<NotificationActivityType, IconData> icons = {
      NotificationActivityType.advice: Icons.comment_outlined,
      NotificationActivityType.affiliate: Icons.attach_money,
      NotificationActivityType.bookingMade: Icons.calendar_month_outlined,
      NotificationActivityType.bookingReceived: Icons.calendar_month_outlined,
      NotificationActivityType.donation: MdiIcons.giftOutline,
      NotificationActivityType.eventDeleted: Icons.calendar_month_outlined,
      NotificationActivityType.newEventInNearYou:
          Icons.event_available_outlined,
      NotificationActivityType.inviteRecieved: FontAwesomeIcons.idBadge,
      NotificationActivityType.ticketPurchased: Icons.payment,
      NotificationActivityType.eventUpdate: FontAwesomeIcons.idBadge,
      NotificationActivityType.eventReminder: Icons.payment,
      NotificationActivityType.refundRequested: Icons.request_quote_outlined,
      NotificationActivityType.follow: Icons.account_circle_outlined,
      NotificationActivityType.ask: Icons.question_mark_rounded,
      NotificationActivityType.comment: Icons.question_mark_rounded,
    };

    // Builds a column of summary containers for each activity type
    return Column(
      children: icons.entries.map((entry) {
        int count = activityCounts[entry.key] ?? 0;
        if (count > 0) {
          List<Activity> filteredActivities = activities
              .where((activity) => activity.type == entry.key)
              .toList();
          return _summaryContainer(context, entry.value,
              '$count ${entry.key.name}', filteredActivities);
        } else {
          return SizedBox.shrink();
        }
      }).toList(),
    );
  }
}


