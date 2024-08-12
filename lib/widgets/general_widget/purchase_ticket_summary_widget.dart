import 'package:bars/utilities/exports.dart';

class PurchaseTicketSummaryWidget extends StatelessWidget {
  // Assuming `finalPurchasingTicketList` is a list of tickets you want to display.
  final List<TicketPurchasedModel> finalPurchasingTicketList;

  final TicketOrderModel ticketOrder;
  final Event event;
  final String currentUserId;
  final String justPurchased;
  final PaletteGenerator palette;

  PurchaseTicketSummaryWidget(
      {Key? key,
      required this.finalPurchasingTicketList,
      required this.ticketOrder,
      required this.event,
      required this.currentUserId,
      required this.justPurchased,
      required this.palette})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool _isRefunded = ticketOrder.refundRequestStatus == 'processed';
    var _textStyle2 = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      color: Theme.of(context).secondaryHeaderColor,
      decoration:
          _isRefunded ? TextDecoration.lineThrough : TextDecoration.none,
    );

    var _textStyle3 = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Colors.red,
    );

    String orderUmberSubstring =
        Utils.safeSubstring(ticketOrder.orderNumber, 0, 4);

    void _navigateToPage(Widget page) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }

    final List<String> currencyPartition =
        event.rate.trim().replaceAll('\n', '').split("|");

    Color _palleteColor = Utils.getPaletteVibrantColor(palette, Colors.blue);

    // Create a list of TicketInfo widgets from the ticket list
    List<Widget> purchaseTicket =
        finalPurchasingTicketList.map((finalPurchasintgTicket) {
      String transactionIdSubstring =
          Utils.safeSubstring(finalPurchasintgTicket.transactionId, 0, 4);
      return GestureDetector(
        onTap: _isRefunded
            ? () {
                mySnackBar(context, 'You cannot access a refunded ticket.');
              }
            : () {
                _navigateToPage(
                  EventsAttendingTicketScreen(
                    ticketOrder: ticketOrder,
                    event: event,
                    currentUserId: currentUserId,
                    justPurchased: '',
                    palette: palette,
                    ticket: finalPurchasintgTicket,
                  ),
                );
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2),
          child: Container(
            padding: const EdgeInsets.all(
              20.0,
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(10, 10),
                    blurRadius: 10.0,
                    spreadRadius: 4.0,
                  )
                ]),
            width: width,
            child: Column(
              children: [
                if (!_isRefunded)
                  ListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                      size: ResponsiveHelper.responsiveHeight(context, 18.0),
                    ),
                    title: Text(
                      "     Tap to view ticket details",
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                        color: Colors.blue,
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShakeTransition(
                      duration: const Duration(seconds: 2),
                      child: QrImageView(
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: finalPurchasintgTicket.validated
                              ? _palleteColor
                              : Colors.grey,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: finalPurchasintgTicket.validated
                              ? _palleteColor
                              : Colors.grey,
                        ),
                        version: QrVersions.auto,
                        data: finalPurchasintgTicket.entranceId,
                        size: 80,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            if (finalPurchasintgTicket
                                    .transactionId.isNotEmpty &&
                                finalPurchasintgTicket.transactionId.length > 4)
                              TextSpan(
                                text: transactionIdSubstring,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            if (event.isFree)
                              TextSpan(
                                text: 'Free',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            if (ticketOrder.isInvited && ticketOrder.total == 0)
                              TextSpan(
                                text: finalPurchasintgTicket.type,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            TextSpan(
                              text:
                                  "\n${MyDateFormat.toDate(finalPurchasintgTicket.eventTicketDate.toDate()).toString()}\n",
                              style: _textStyle2,
                            ),
                            if (event.isCashPayment)
                              TextSpan(
                                text: 'Cash in-hand payment',
                                style: _textStyle3,
                              ),
                            if (finalPurchasintgTicket.validated)
                              TextSpan(
                                text: "\nvalidated",
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 12.0),
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  thickness: .3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12,
                  ),
                  child: Column(
                    children: [
                      SalesReceiptWidget(
                          isRefunded: _isRefunded,
                          lable: 'Order number',
                          value: orderUmberSubstring),
                      SalesReceiptWidget(
                        isRefunded: _isRefunded,
                        lable: 'Ticket group',
                        value: finalPurchasintgTicket.group,
                      ),
                      SalesReceiptWidget(
                        isRefunded: _isRefunded,
                        lable: 'Access level',
                        value: finalPurchasintgTicket.accessLevel,
                      ),
                      SalesReceiptWidget(
                        isRefunded: _isRefunded,
                        lable: 'Event date:',
                        value: MyDateFormat.toDate(
                            finalPurchasintgTicket.eventTicketDate.toDate()),
                      ),
                      SalesReceiptWidget(
                        isRefunded: _isRefunded,
                        lable: 'Total',
                        value: event.isFree
                            ? 'Free'
                            : currencyPartition.length > 0
                                ? "${currencyPartition[1].trim()} ${finalPurchasintgTicket.price.toString()}"
                                : finalPurchasintgTicket.price.toString(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      );
    }).toList();

    // Use a SingleChildScrollView to make sure the list is scrollable if it's too long
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ...purchaseTicket, // Spread the list of widgets into the column
        ],
      ),
    );
  }
}
