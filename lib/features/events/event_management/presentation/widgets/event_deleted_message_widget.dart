import 'package:bars/utilities/exports.dart';

class EventDeletedMessageWidget extends StatefulWidget {
  final TicketOrderModel ticketOrder;
  final String currentUserId;

  const EventDeletedMessageWidget(
      {super.key, required this.ticketOrder, required this.currentUserId});

  @override
  State<EventDeletedMessageWidget> createState() =>
      _EventDeletedMessageWidgetState();
}

class _EventDeletedMessageWidgetState extends State<EventDeletedMessageWidget> {
  RefundModel? refund;

  @override
  void initState() {
    super.initState();
    if (widget.ticketOrder.refundRequestStatus.isNotEmpty) _getRefund();
  }

  Future<void> _sendMail(String email, BuildContext context) async {
    String url = 'mailto:$email';
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      mySnackBar(context, 'Could not launch mail');
    }
  }

  _getRefund() async {
    RefundModel? newRefund = await DatabaseService.getRefundWithId(
        widget.currentUserId, widget.ticketOrder.eventId);

    setState(() {
      refund = newRefund;
    });
  }

  _alreadyRefunded() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: ResponsiveHelper.responsiveFontSize(context, 40.0),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Text(
              'Refund processed  ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                color: Colors.white,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            height: refund == null
                ? 0.0
                : ResponsiveHelper.responsiveHeight(context, 350),
            width: double.infinity,
            curve: Curves.linearToEaseOut,
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    offset: Offset(2, 2),
                    blurRadius: 5.0,
                    spreadRadius: 4.0,
                  )
                ]),
            child: refund != null
                ? SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: RefundWidget(
                      currentRefund: refund!,
                      currentUserId: widget.currentUserId,
                    ),
                  )
                : SizedBox.shrink(),
          ),
          const SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total =
        widget.ticketOrder.tickets.fold(0, (acc, ticket) => acc + ticket.price);
    return Container(
        height: ResponsiveHelper.responsiveHeight(context, 700.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  Text(
                    ' Deleted',
                    style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 20),
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.ticketOrder.eventTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    TextSpan(
                      text:
                          "\n\nWe regret to inform you that this event ${widget.ticketOrder.eventTitle}, has been canceled by the organizer. We understand the inconvenience this may cause and sincerely apologize.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    if (total != 0)
                      TextSpan(
                        text:
                            "\n\n Your ticket price of ${total.toStringAsFixed(2)} will be fully refunded within 14 business days.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                    // Include any additional information or links here
                  ],
                ),
              ),
              SizedBox(height: ResponsiveHelper.responsiveHeight(context, 30)),
              if (widget.ticketOrder.refundRequestStatus == 'processed')
                _alreadyRefunded(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              currentUserId: widget.currentUserId,
                              userId: widget.ticketOrder.eventAuthorId,
                              user: null,
                            )),
                  );
                },
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "\nReason.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text:
                            "\nThis are the reasons provided by the event organizer.\n",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: widget.ticketOrder.canlcellationReason,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\nContact oragnizer here.",
                        style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14),
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _sendMail('support@barsopus.com', context);
                },
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "\nIf you have any questions or need further assistance, please don't hesitate to reach out to our support team. You can contact us at .",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "support@barsopus.com.",
                        style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14),
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),

              // Include buttons for contacting support or accessing FAQs
              const SizedBox(height: 60),
            ],
          ),
        ));
  }
}
