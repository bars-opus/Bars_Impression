import 'package:bars/utilities/exports.dart';

class TicketGoupWidget extends StatefulWidget {
  final List<AppointmentSlotModel> appointmentSlots;
  final bool isEditing;
  final String currency;
  final String eventId;
  final String eventAuthorId;
  final bool fromProfile;

  const TicketGoupWidget({
    super.key,
    required this.appointmentSlots,
    required this.currency,
    required this.isEditing,
    required this.eventId,
    required this.eventAuthorId,
    this.fromProfile = true,
  });

  @override
  State<TicketGoupWidget> createState() => _TicketGoupWidgetState();
}

class _TicketGoupWidgetState extends State<TicketGoupWidget> {
  Map<String, bool> selectedTickets = {};
  Map<String, bool> checkingAvailability = {};

  @override
  void initState() {
    super.initState();
    for (var ticket in widget.appointmentSlots) {
      selectedTickets[ticket.id] = false;
    }
  }

  void _toggleTicket(AppointmentSlotModel appoinment) {
    var _provider = Provider.of<UserData>(context, listen: false);

    var appoinmentSelected = selectedTickets[appoinment.id] ?? false;
    setState(() {
      selectedTickets[appoinment.id] = !appoinmentSelected;
    });

    if (!appoinmentSelected) {
      // The appoinment was not previously selected, so add it to the list.
      _provider.addAppointmentToList(appoinment);
    } else {
      // The appoinment was previously selected, so remove it from the list.
      _provider.removeAppointmentFromList(appoinment);
    }
  }

  _removeTicket(AppointmentSlotModel removingTicket) async {
    widget.appointmentSlots
        .removeWhere((ticket) => ticket.id == removingTicket.id);
  }

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
            bool isSelected = selectedTickets[ticket.id] ?? false;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[400] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SalesReceiptWidget(
                                      isTicket: true,
                                      text2Ccolor: Colors.black,
                                      width: 100,
                                      isRefunded: false,
                                      lable: 'Duration',
                                      value: ticket.duruation,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (checkingAvailability[ticket.id] ==
                                          false ||
                                      checkingAvailability[ticket.id] == null)
                                    Text(
                                      '${currencyPartition.isEmpty ? '' : currencyPartition.length > 1 ? currencyPartition[1] : ''} ${ticket.price}',
                                      style: TextStyle(
                                          fontSize: ResponsiveHelper
                                              .responsiveFontSize(
                                                  context, 18.0),
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  if (!widget.isEditing)
                                    checkingAvailability[ticket.id] == true
                                        ? SizedBox(
                                            height: ResponsiveHelper
                                                .responsiveHeight(
                                                    context, 10.0),
                                            width: ResponsiveHelper
                                                .responsiveHeight(
                                                    context, 10.0),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              color: Colors.blue,
                                            ),
                                          )
                                        : Checkbox(
                                            checkColor: Colors.blue,
                                            activeColor: Colors.white,
                                            side:
                                                BorderSide(color: Colors.black),
                                            value: selectedTickets[ticket.id],
                                            onChanged: (bool? value) async {
                                              var ticketSelected =
                                                  selectedTickets[ticket.id] ??
                                                      false;
                                              _toggleTicket(ticket);
                                            },
                                          ),
                                  if (widget.isEditing)
                                    GestureDetector(
                                        onTap: () => _removeTicket(ticket),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.red,
                                        )),
                                ],
                              ),
                            ]),
                        SettingSwitch(
                          isAlwaysBlack: isSelected ? true : false,
                          color: isSelected
                              ? Colors.grey[700] ?? Colors.grey
                              : Colors.blue,
                          title: 'Select your favorite worker.',
                          subTitle: ticket.favoriteWorker
                              ? 'You would have to select a preferred worker in the next step.\nSee available workers below'
                              : 'A random worker would be selected for you.\nSee available workers below',
                          value: ticket.favoriteWorker,
                          onChanged: (value) {
                            setState(() {
                              ticket.favoriteWorker = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.all(
                              ResponsiveHelper.responsiveWidth(context, 2)),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                          child: ShedulePeopleHorizontal(
                            edit: ticket.favoriteWorker,
                            workers: ticket.workers,
                            currentUserId: _provider.currentUserId!,
                          ),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(children: groupWidgets),
            ),
          ],
        );

        return content;
      },
    );
  }
}
