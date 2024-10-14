import 'package:bars/utilities/exports.dart';

// This widget summarizes and displays a list of bookings based on their status.
// It categorizes bookings as Accepted, Rejected, or Not answered.
// Users can tap on a summary to view detailed bookings in a modal sheet.

class ShopBookingSummaryWidget extends StatelessWidget {
  final List<BookingAppointmentModel> bookings;

  ShopBookingSummaryWidget({required this.bookings});

  // Groups bookings by their answer status and counts them.
  Map<String, int> _groupAndCountBookingAppointmentModels() {
    Map<String, int> bookingCounts = {};

    for (var booking in bookings) {
      String key;
      if (booking.cancellationReason == '') {
        key = 'Cancelled';
        // } else if (booking.answer == 'Rejected') {
        //   key = 'Rejected';
      } else {
        key = 'active';
      }
      bookingCounts[key] = (bookingCounts[key] ?? 0) + 1;
    }

    return bookingCounts;
  }

  // Generates summary text for a given booking status and count.
  String _generateSummaryText(String key, int count) {
    return '$count $key';
  }

  // Builds a summary container for each booking status.
  Widget _summaryContainer(BuildContext context, IconData icon, Color color,
      String summary, List<BookingAppointmentModel> bookings) {
    return GestureDetector(
        onTap: () => _showActivitiesByType(context, bookings),
        child: SummaryButton(
          icon: icon,
          color: color,
       
          summary: summary,
        ),

        // Container(
        //   padding: const EdgeInsets.all(10),
        //   margin: const EdgeInsets.symmetric(vertical: 1),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).primaryColorLight,
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: _summaryRow(
        //     context,
        //     icon,
        //     color,
        //     summary,
        //   ),
        // ),
        );
  }

  // Creates a row with an icon and summary text.
  // Widget _summaryRow(
  //   BuildContext context,
  //   IconData icon,
  //   Color color,
  //   String summary,
  // ) {
  //   return Row(
  //     children: [
  //       Icon(
  //         icon,
  //         size: ResponsiveHelper.responsiveHeight(context, 20),
  //         color: color,
  //       ),
  //       const SizedBox(width: 10),
  //       Expanded(
  //         child: Text(
  //           summary,
  //           style: TextStyle(
  //             color: Theme.of(context).secondaryHeaderColor,
  //             fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Displays a list of bookings in a modal bottom sheet.
  void _showActivitiesByType(
      BuildContext context, List<BookingAppointmentModel> bookings) {
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
                      itemCount: bookings.length,
                      itemBuilder: (BuildContext context, int index) {
                        final booking = bookings[index];
                        return Container(
                          height: 100,
                          color: Colors.blue,
                        );

                        //  InviteContainerWidget(
                        //   booking: booking,
                        // );
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
    // Group and count bookings for display.
    Map<String, int> bookingCounts = _groupAndCountBookingAppointmentModels();

    // Define icons for each booking status.
    Map<String, IconData> icons = {
      'Accepted': Icons.check_circle_outline,
      'Rejected': Icons.cancel_outlined,
      'Not answered': Icons.help_outline,
    };

    // Define colors for each booking status.
    Map<String, Color> colors = {
      'Accepted': Colors.green,
      'Rejected': Colors.red,
      'Not answered': Colors.grey,
    };

    return Column(
      children: icons.entries.map((entry) {
        int count = bookingCounts[entry.key] ?? 0;
        if (count > 0) {
          // Filter bookings matching the current status.
          List<BookingAppointmentModel> filteredInvites =
              bookings.where((booking) {
            return (booking.cancellationReason == entry.key) ||
                (booking.cancellationReason.isEmpty &&
                    entry.key == 'Not answered');
          }).toList();

          // Generate summary text for the booking status.
          String summaryText = _generateSummaryText(entry.key, count);

          // Create a summary container for the booking status.
          return _summaryContainer(context, entry.value, colors[entry.key]!,
              summaryText, filteredInvites);
        } else {
          return SizedBox.shrink();
        }
      }).toList(),
    );
  }
}
