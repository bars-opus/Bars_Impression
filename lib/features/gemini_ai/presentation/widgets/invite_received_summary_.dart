import 'package:bars/utilities/exports.dart';

// This widget summarizes and displays a list of invites based on their status.
// It categorizes invites as Accepted, Rejected, or Not answered.
// Users can tap on a summary to view detailed invites in a modal sheet.


class InviteReceivedSummaryWidget extends StatelessWidget {
  final List<InviteModel> invites;

  InviteReceivedSummaryWidget({required this.invites});

  // Groups invites by their answer status and counts them.
  Map<String, int> _groupAndCountInviteModels() {
    Map<String, int> inviteCounts = {};

    for (var invite in invites) {
      String key;
      if (invite.answer == 'Accepted') {
        key = 'Accepted';
      } else if (invite.answer == 'Rejected') {
        key = 'Rejected';
      } else {
        key = 'Not answered';
      }
      inviteCounts[key] = (inviteCounts[key] ?? 0) + 1;
    }

    return inviteCounts;
  }

  // Generates summary text for a given invite status and count.
  String _generateSummaryText(String key, int count) {
    return '$count $key';
  }

  // Builds a summary container for each invite status.
  Widget _summaryContainer(BuildContext context, IconData icon, Color color, String summary,
      List<InviteModel> invites) {
    return GestureDetector(
      onTap: () => _showActivitiesByType(context, invites),
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
          color,
          summary,
        ),
      ),
    );
  }

  // Creates a row with an icon and summary text.
  Widget _summaryRow(
    BuildContext context,
    IconData icon,
    Color color,
    String summary,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.responsiveHeight(context, 20),
          color: color,
        ),
        const SizedBox(width: 10),
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

  // Displays a list of invites in a modal bottom sheet.
  void _showActivitiesByType(BuildContext context, List<InviteModel> invites) {
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
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TicketPurchasingIcon(title: ''),
                  Container(
                    height: ResponsiveHelper.responsiveHeight(context, 530),
                    child: ListView.builder(
                      itemCount: invites.length,
                      itemBuilder: (BuildContext context, int index) {
                        final invite = invites[index];
                        return InviteContainerWidget(
                          invite: invite,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group and count invites for display.
    Map<String, int> inviteCounts = _groupAndCountInviteModels();

    // Define icons for each invite status.
    Map<String, IconData> icons = {
      'Accepted': Icons.check_circle_outline,
      'Rejected': Icons.cancel_outlined,
      'Not answered': Icons.help_outline,
    };

    // Define colors for each invite status.
    Map<String, Color> colors = {
      'Accepted': Colors.green,
      'Rejected': Colors.red,
      'Not answered': Colors.grey,
    };

    return Column(
      children: icons.entries.map((entry) {
        int count = inviteCounts[entry.key] ?? 0;
        if (count > 0) {
          // Filter invites matching the current status.
          List<InviteModel> filteredInvites = invites.where((invite) {
            return (invite.answer == entry.key) ||
                   (invite.answer.isEmpty && entry.key == 'Not answered');
          }).toList();

          // Generate summary text for the invite status.
          String summaryText = _generateSummaryText(entry.key, count);

          // Create a summary container for the invite status.
          return _summaryContainer(
              context, entry.value, colors[entry.key]!, summaryText, filteredInvites);
        } else {
          return SizedBox.shrink();
        }
      }).toList(),
    );
  }
}



