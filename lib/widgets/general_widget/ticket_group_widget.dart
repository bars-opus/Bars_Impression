import 'package:bars/utilities/exports.dart';

class TicketGoupWidget extends StatefulWidget {
  final List<TicketModel> groupTickets;
  final bool isEditing;
  final bool onInvite;
  final bool isFree;
  final String currency;
  final String eventId;
  final String eventAuthorId;
  final bool onCalendatSchedule;

  const TicketGoupWidget({
    super.key,
    required this.groupTickets,
    required this.currency,
    required this.isEditing,
    this.onInvite = false,
    required this.isFree,
    required this.eventId,
    required this.eventAuthorId,
    this.onCalendatSchedule = false,
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
    // Initialize all tickets to be deselected
    for (var ticket in widget.groupTickets) {
      selectedTickets[ticket.id] =
          false; // Assuming TicketModel has an id property
    }
  }

  void _toggleTicket(TicketModel ticket) {
    var _provider = Provider.of<UserData>(context, listen: false);

    var ticketSelected = selectedTickets[ticket.id] ?? false;
    setState(() {
      selectedTickets[ticket.id] = !ticketSelected;
    });

    if (!ticketSelected) {
      // The ticket was not previously selected, so add it to the list.
      _provider.addTicketToList(ticket);
    } else {
      // The ticket was previously selected, so remove it from the list.
      _provider.removeTicketFromList(ticket);
    }
  }

  _removeTicket(TicketModel removingTicket) async {
    widget.groupTickets.removeWhere((ticket) =>
        ticket.price == removingTicket.price &&
        ticket.type == removingTicket.type &&
        ticket.group == removingTicket.group &&
        ticket.eventTicketDate == removingTicket.eventTicketDate);
  }

// Helper function to get date only from DateTime
  DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  void _showBottomSheetErrorMessage(BuildContext context, String error) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: 'Sold Out',
          subTitle: error,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> currencyPartition =
        widget.currency.trim().replaceAll('\n', ' ').split("|");
    // Group tickets by date, then by group
    Map<DateTime, Map<String, List<TicketModel>>> ticketsByDateAndGroup = {};
    for (TicketModel ticket in widget.groupTickets) {
      DateTime ticketDate = dateOnly(ticket.eventTicketDate.toDate());
      if (!ticketsByDateAndGroup.containsKey(ticketDate)) {
        ticketsByDateAndGroup[ticketDate] = {};
      }
      Map<String, List<TicketModel>> groupMap =
          ticketsByDateAndGroup[ticketDate]!;
      if (!groupMap.containsKey(ticket.group)) {
        groupMap[ticket.group] = [];
      }
      groupMap[ticket.group]!.add(ticket);
    }

    // Convert the map into a list of sorted entries by date
    var sortedEntries = ticketsByDateAndGroup.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Now build the UI using the sorted entries
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedEntries.length,
      itemBuilder: (BuildContext context, int dateIndex) {
        DateTime date = sortedEntries[dateIndex].key;
        Map<String, List<TicketModel>> groups = sortedEntries[dateIndex].value;

        // For each date, build a widget for each group
        List<Widget> groupWidgets = groups.entries.map((groupEntry) {
          String groupName = groupEntry.key;
          List<TicketModel> tickets = groupEntry.value;
          List<Widget> ticketWidgets = tickets.map((ticket) {
            bool isSelected = selectedTickets[ticket.id] ?? false;
            Color textColor = isSelected ? Colors.white : Colors.black;
            int availableSlot = ticket.maxOder - ticket.salesCount;
            // bool checkingTicketAvailability = false;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
              child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[400] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:

                        // ListTile(

                        //   subtitle:

                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (ticket.type.isNotEmpty)
                                SalesReceiptWidget(
                                  isTicket: true,
                                  text2Ccolor: Colors.black,
                                  width: 100,
                                  isRefunded: false,
                                  lable: 'Type',
                                  value: ticket.type.toUpperCase(),
                                ),
                              if (ticket.accessLevel.isNotEmpty)
                                SalesReceiptWidget(
                                  isTicket: true,
                                  text2Ccolor: Colors.black,
                                  width: 100,
                                  isRefunded: false,
                                  lable: 'Benefits',
                                  value: ticket.accessLevel,
                                ),
                              if (ticket.maxOder != 0)
                                SalesReceiptWidget(
                                  isTicket: true,
                                  text2Ccolor: Colors.black,
                                  width: 100,
                                  isRefunded: false,
                                  lable: 'Max order',
                                  value: ticket.maxOder.toString(),
                                ),
                              if (ticket.maxOder != 0)
                                SalesReceiptWidget(
                                  isTicket: true,
                                  text2Ccolor: Colors.black,
                                  width: 100,
                                  isRefunded: false,
                                  lable: 'Available slot',
                                  value: availableSlot.toString(),
                                ),
                            ],
                          ),
                        ),
                        ticket.isSoldOut
                            ? Text(
                                'Sold out',
                                style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 18.0),
                                    color: Colors.orange[900],
                                    fontWeight: FontWeight.bold),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (checkingAvailability[ticket.id] ==
                                          false ||
                                      checkingAvailability[ticket.id] == null)
                                    Text(
                                      widget.isFree
                                          ? 'Free'
                                          : '${currencyPartition.isEmpty ? '' : currencyPartition.length > 1 ? currencyPartition[1] : ''} ${ticket.price}',
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

                                              HapticFeedback.lightImpact();
                                              if (ticket.maxOder != 0 &&
                                                  !ticketSelected) {
                                                checkingAvailability[
                                                    ticket.id] = true;
                                                // checkingTicketAvailability = true;
                                                bool available =
                                                    await DatabaseService()
                                                        .checkTicketAvailability(
                                                            widget
                                                                .eventAuthorId,
                                                            widget.eventId,
                                                            ticket.id);
                                                checkingAvailability[
                                                    ticket.id] = false;
                                                // checkingTicketAvailability =
                                                //     false;
                                                if (!available) {
                                                  _showBottomSheetErrorMessage(
                                                      context,
                                                      "Sorry, this ticket just got sold out.\nKindly select another ticket option");
                                                  return;
                                                }

                                                _toggleTicket(ticket);
                                              } else {
                                                _toggleTicket(ticket);
                                              }
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
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            children: ticketWidgets,
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: ResponsiveHelper.responsiveFontSize(context, 200),
                child: Text(
                  MyDateFormat.toDate(date),
                  style: TextStyle(
                      color: widget.isEditing || widget.onInvite
                          ? Colors.white
                          : Theme.of(context).secondaryHeaderColor,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(children: groupWidgets)),
            SizedBox(
              height: widget.isEditing ? 10 : 30,
            ),
            Divider(
              thickness: .2,
            ),
            SizedBox(
              height: widget.isEditing ? 10 : 30,
            ),
          ],
        );
      },
    );
  }
}
