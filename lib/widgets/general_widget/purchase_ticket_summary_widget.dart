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

    var _textStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Colors.grey,
    );

    void _navigateToPage(Widget page) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }

    final List<String> currencyPartition =
        event.rate.trim().replaceAll('\n', ' ').split("|");

    Color _palleteColor = palette == null
        ? Colors.grey
        : palette.vibrantColor == null
            ? Colors.grey
            : palette.vibrantColor!.color;

    // Create a list of TicketInfo widgets from the ticket list
    List<Widget> purchaseTicket =
        finalPurchasingTicketList.map((finalPurchasintgTicket) {
      return GestureDetector(
        onTap: _isRefunded
            ? () {}
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
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
                        version: QrVersions.auto,
                        foregroundColor: finalPurchasintgTicket.validated
                            ? _palleteColor
                            : Colors.grey,
                        backgroundColor: Colors.transparent,
                        data: finalPurchasintgTicket.entranceId,
                        size: 80,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: finalPurchasintgTicket.type,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),

                            TextSpan(
                              text:
                                  "\n${MyDateFormat.toDate(finalPurchasintgTicket.eventTicketDate.toDate()).toString().substring(0, finalPurchasintgTicket.eventTicketDate.toDate().toString().length - 2)}",
                              style: _textStyle2,
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
                            // TextSpan(
                            //   text: "\nEnd date:    ",
                            //   style: _textStyle,
                            // ),
                            // TextSpan(
                            //   text: _clossingDay,
                            //   style: _textStyle2,
                            // ),
                            // TextSpan(
                            //   text: "\nVenue:        ",
                            //   style: _textStyle,
                            // ),
                            // TextSpan(
                            //   text: event.venue,
                            //   style: _textStyle2,
                            // ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12,
                  ),
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        // TextSpan(
                        //   text: 'Sales Receipt',
                        //   style: Theme.of(context).textTheme.bodyLarge,
                        // ),
                        TextSpan(
                          text: 'Order number:     ',
                          style: _textStyle,
                        ),
                        TextSpan(
                          text: '908098',
                          style: _textStyle2,
                        ),
                        // if (finalPurchasintgTicket.type.isNotEmpty)
                        //   TextSpan(
                        //     text: '\nTicket type:             ',
                        //     style: _textStyle,
                        //   ),
                        // if (finalPurchasintgTicket.type.isNotEmpty)
                        //   TextSpan(
                        //     text: finalPurchasintgTicket.type,
                        //     style: _textStyle2,
                        //   ),
                        if (finalPurchasintgTicket.group.isNotEmpty)
                          TextSpan(
                            text: '\nTicket group:        ',
                            style: _textStyle,
                          ),
                        if (finalPurchasintgTicket.group.isNotEmpty)
                          TextSpan(
                            text: finalPurchasintgTicket.group,
                            style: _textStyle2,
                          ),
                        if (finalPurchasintgTicket.accessLevel.isNotEmpty)
                          TextSpan(
                            text: '\nAccess level:        ',
                            style: _textStyle,
                          ),
                        if (finalPurchasintgTicket.accessLevel.isNotEmpty)
                          TextSpan(
                            text: finalPurchasintgTicket.accessLevel + 'ppp',
                            style: _textStyle2,
                          ),
                        // TextSpan(
                        //   text: '\nPurchased time:     ',
                        //   style: _textStyle,
                        // ),
                        // TextSpan(
                        //   text: MyDateFormat.toTime(timestamp.toDate()),
                        //   style: _textStyle2,
                        // ),
                        TextSpan(
                          text: '\nEvent date:          ',
                          style: _textStyle,
                        ),
                        TextSpan(
                          text: MyDateFormat.toDate(
                              finalPurchasintgTicket.eventTicketDate.toDate()),
                          style: _textStyle2,
                        ),
                        TextSpan(
                          text: '\nTotal:                   ',
                          style: _textStyle,
                        ),
                        TextSpan(
                          text: event.isFree
                              ? 'Free'
                              : currencyPartition.length > 0
                                  ? "${currencyPartition[1]} ${finalPurchasintgTicket.price.toString()}"
                                  : finalPurchasintgTicket.price.toString(),
                          style: _textStyle2,
                        ),
                      ],
                    ),
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
