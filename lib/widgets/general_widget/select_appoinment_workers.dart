import 'package:bars/utilities/exports.dart';

class SelectAppointmentWorkers extends StatefulWidget {
  final List<AppointmentSlotModel> appointmentSlots;
  final bool isEditing;
  final String currency;
  final String eventId;
  final String eventAuthorId;
  final bool fromProfile;

  const SelectAppointmentWorkers({
    super.key,
    required this.appointmentSlots,
    required this.currency,
    required this.isEditing,
    required this.eventId,
    required this.eventAuthorId,
    this.fromProfile = true,
  });

  @override
  State<SelectAppointmentWorkers> createState() =>
      _SelectAppointmentWorkersState();
}

class _SelectAppointmentWorkersState extends State<SelectAppointmentWorkers> {
  // Map<String, bool> checkingAvailability = {};

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    final List<String> currencyPartition =
        widget.currency.trim().replaceAll('\n', ' ').split("|");

    Map<String, Map<String, List<AppointmentSlotModel>>> ticketsByDateAndGroup =
        {};
    for (AppointmentSlotModel ticket in widget.appointmentSlots) {
      String ticketDate = ticket.service;

      if (!ticketsByDateAndGroup.containsKey(ticketDate)) {
        ticketsByDateAndGroup[ticketDate] = {};
      }
      Map<String, List<AppointmentSlotModel>> groupMap =
          ticketsByDateAndGroup[ticketDate]!;
      if (!groupMap.containsKey(ticket.type)) {
        groupMap[ticket.type] = [];
      }
      groupMap[ticket.type]!.add(ticket);
    }

    var sortedEntries = ticketsByDateAndGroup.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedEntries.length,
      itemBuilder: (BuildContext context, int dateIndex) {
        String service = sortedEntries[dateIndex].key;
        Map<String, List<AppointmentSlotModel>> groups =
            sortedEntries[dateIndex].value;

        List<Widget> groupWidgets = groups.entries.map((groupEntry) {
          String groupName = groupEntry.key;
          List<AppointmentSlotModel> tickets = groupEntry.value;
          List<Widget> ticketWidgets = tickets.map((ticket) {
            // bool isSelected = selectedTickets[ticket.id] ?? false;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    // isSelected ? Colors.blue[400] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        SelectWorkerWidget(
                          // edit: ticket.favoriteWorker,
                          workers: ticket.workers,
                          // currentUserId: _provider.currentUserId!,
                        ),
                      ],
                    ),
                  )),
            );
          }).toList();

          return ExpansionTile(
            initiallyExpanded: true,
            iconColor: Colors.grey,
            collapsedIconColor: Colors.blue,
            title: Text(
              groupName.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            children: ticketWidgets,
          );
        }).toList();

        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                service,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Card(
              color: Theme.of(context).primaryColorLight,
              elevation: 0.5,
              // : BorderRadius.circular(5.0),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(5.0),

              // ),
              child: Column(children: groupWidgets),
            ),
          ],
        );

        return content;
      },
    );
  }
}
