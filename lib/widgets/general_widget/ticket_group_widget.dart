import 'package:bars/utilities/exports.dart';

class TicketGoupWidget extends StatefulWidget {
  final List<TicketModel> groupTickets;
  // final VoidCallback onPressed;
  final bool isEditing;
  final bool onInvite;
  final bool isFree;
  final String currency;

  const TicketGoupWidget({
    super.key,
    required this.groupTickets,
    required this.currency,
    required this.isEditing,
    this.onInvite = false,
    required this.isFree,
  });

  @override
  State<TicketGoupWidget> createState() => _TicketGoupWidgetState();
}

class _TicketGoupWidgetState extends State<TicketGoupWidget> {
  Map<String, bool> selectedTickets = {};

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
    widget.groupTickets
        .removeWhere((ticket) => ticket.price == removingTicket.price);
  }

// Helper function to get date only from DateTime
  DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
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
            // ... your ListTile or other widget for each ticket ...
            // Placeholder for ticket widget
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
              child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[400] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ListTile(
                      // onTap: widget.isEditing
                      //     ? () {}
                      //     : () {
                      //         HapticFeedback.lightImpact();
                      //         _provider.setTicketList(ticket);
                      //         // // Navigator.pop;
                      //         // _showBottomSheetAttend(
                      //         //    widget. groupTickets, widget. groupTickets.indexOf(ticket));
                      //       },

                      title: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Type:              ",
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 14.0),
                                color: textColor,
                              ),
                            ),
                            TextSpan(
                              text: ticket.type.toUpperCase(),
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 18.0),
                                color: textColor,
                              ),
                            )
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      //  Text(
                      //   ticket.type,
                      //   style: Theme.of(context).textTheme.bodyMedium,
                      // ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Acess level:   ",
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 14.0),
                                    color: textColor,
                                  ),
                                ),
                                TextSpan(
                                    text: ticket.accessLevel,
                                    style: TextStyle(
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 16.0),
                                      color: textColor,
                                    ))
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider()
                        ],
                      ),
                      trailing: Wrap(
                        children: [
                          Text(
                            widget.isFree
                                ? 'Free'
                                : '${currencyPartition.isEmpty ? '' : currencyPartition.length > 0 ? currencyPartition[1] : ''} ${ticket.price}',
                            style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 18.0),
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ),
                          if (!widget.isEditing)
                            Checkbox(
                              checkColor: Colors.blue,
                              activeColor: Colors.white,
                              value: selectedTickets[ticket.id],
                              onChanged: (bool? value) {
                                HapticFeedback.lightImpact();
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
                    ),
                  )),
            );
          }).toList();

          return ExpansionTile(
            initiallyExpanded: true,
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
                  // DateFormat('yyyy-MM-dd').format(date),
                  style: TextStyle(
                      color: widget.isEditing || widget.onInvite
                          ? Colors.white
                          : Theme.of(context).secondaryHeaderColor,
                      fontSize: 20,
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
            Divider(),
            SizedBox(
              height: widget.isEditing ? 10 : 30,
            ),
          ],
        );
      },
    );
  }
}

// class TicketGoupWidget extends StatelessWidget {
//   final List<TicketModel> groupTickets;
//   final VoidCallback onPressed;

//   const TicketGoupWidget({
//     super.key,
//     required this.groupTickets,
//     required this.onPressed,
//   });

//   _removeTicket(TicketModel removingticket) async {
//     groupTickets.removeWhere((ticket) => ticket.price == removingticket.price);
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<TicketModel> tickets = groupTickets;
//     Map<String, List<TicketModel>> ticketsByGroup = {};
//     for (TicketModel ticket in tickets) {
//       if (!ticketsByGroup.containsKey(ticket.group)) {
//         ticketsByGroup[ticket.group] = [];
//       }
//       ticketsByGroup[ticket.group]!.add(ticket);
// //     }
//     return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: ticketsByGroup.length,
//       itemBuilder: (BuildContext context, int groupIndex) {
//         // Get the group name and tickets for the current index
//         String groupName = ticketsByGroup.keys.elementAt(groupIndex);
//         List<TicketModel> groupTickets =
//             ticketsByGroup.values.elementAt(groupIndex);

//         // Create a sublist of widgets for each ticket in the group
//         List<Widget> ticketWidgets = groupTickets
//             .map((ticket) => Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: ListTile(
//                     onTap: () {
//                       onPressed();
//                     },

//                     title: RichText(
//                       textScaleFactor: MediaQuery.of(context).textScaleFactor,
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: "Type:              ",
//                             style: TextStyle(
//                               fontSize: ResponsiveHelper.responsiveFontSize(
//                                   context, 14.0),
//                               color: Colors.black,
//                             ),
//                           ),
//                           TextSpan(
//                             text: ticket.type.toUpperCase(),
//                             style: TextStyle(
//                               fontSize: ResponsiveHelper.responsiveFontSize(
//                                   context, 18.0),
//                               color: Colors.black,
//                             ),
//                           )
//                         ],
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),

//                     //  Text(
//                     //   ticket.type,
//                     //   style: Theme.of(context).textTheme.bodyMedium,
//                     // ),
//                     subtitle: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         RichText(
//                           textScaleFactor:
//                               MediaQuery.of(context).textScaleFactor,
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: "Acess level:   ",
//                                 style: TextStyle(
//                                   fontSize: ResponsiveHelper.responsiveFontSize(
//                                       context, 14.0),
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               TextSpan(
//                                   text: ticket.accessLevel,
//                                   style: TextStyle(
//                                     fontSize:
//                                         ResponsiveHelper.responsiveFontSize(
//                                             context, 16.0),
//                                     color: Colors.black,
//                                   ))
//                             ],
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Divider()
//                       ],
//                     ),
//                     trailing: Column(
//                       children: [
//                         Text(
//                           '\$${ticket.price}',
//                           style: TextStyle(
//                               fontSize: ResponsiveHelper.responsiveFontSize(
//                                   context, 18.0),
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         GestureDetector(
//                             onTap: () => _removeTicket(ticket),
//                             child: Icon(
//                               Icons.remove,
//                               color: Colors.red,
//                             )),
//                       ],
//                     ),
//                   ),
//                 ))
//             .toList();

//         // Return a Card widget for the group, containing a ListView of the tickets
        // return Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Theme.of(context).primaryColorLight,
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //     child: Column(
        //       children: <Widget>[
        //         ListTile(
        //           title: Text(
        //             groupName.toUpperCase(),
        //             style: Theme.of(context).textTheme.displayMedium,
        //           ),
        //         ),
        //         Container(
        //           decoration: BoxDecoration(
        //               color: Colors.blue[50],
        //               borderRadius: BorderRadius.only(
        //                   bottomRight: Radius.circular(5.0),
        //                   bottomLeft: Radius.circular(5.0))),
        //           child: ListView.builder(
        //             physics: const NeverScrollableScrollPhysics(),
        //             shrinkWrap: true,
        //             itemCount: ticketWidgets.length,
        //             itemBuilder: (BuildContext context, int ticketIndex) {
        //               return ticketWidgets[ticketIndex];
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
//       },
//     );
//   }
// }
