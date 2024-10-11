import 'package:bars/utilities/exports.dart';

class TicketPurchaseSummaryWidget extends StatelessWidget {
  TicketPurchaseSummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );

    // Create a list of TicketInfo widgets from the ticket list
    List<Widget> ticketInfoWidgets =
        _provider.ticketList.map((finalPurchasintgTicket) {
      return Column(
        children: <Widget>[
          TicketInfo(
            // event: widget.event!,
            label: 'Category',
            position: 'First',
            value: finalPurchasintgTicket.group,
          ),
          if (finalPurchasintgTicket.type.isNotEmpty)
            TicketInfo(
              // event: widget.event!,
              label: 'Type',
              position: '',
              value: finalPurchasintgTicket.type,
            ),
          if (finalPurchasintgTicket.accessLevel.isNotEmpty)
            TicketInfo(
              // event: widget.event!,
              label: 'Access level',
              position: '',
              value: finalPurchasintgTicket.accessLevel,
            ),
          TicketInfo(
            // event: widget.event!,
            label: 'Price',
            position: 'Last',
            value: finalPurchasintgTicket.price.toString(),
          ),
          // Add a divider or padding if necessary
          Divider(
            thickness: .2,
          ),
        ],
      );
    }).toList();

    // Use a SingleChildScrollView to make sure the list is scrollable if it's too long
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ...ticketInfoWidgets, // Spread the list of widgets into the column
        ],
      ),
    );
  }
}
