import 'package:bars/utilities/exports.dart';

class EventDeletedMessageWidget extends StatelessWidget {
  final TicketOrderModel ticketOrder;
  final String currentUserId;

  const EventDeletedMessageWidget(
      {super.key, required this.ticketOrder, required this.currentUserId});

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

  @override
  Widget build(BuildContext context) {
    double total =
        ticketOrder.tickets.fold(0, (acc, ticket) => acc + ticket.price);
    return Container(
        height: ResponsiveHelper.responsiveHeight(context, 700.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TicketPurchasingIcon(
                    // icon: Icons.event,
                    title: '',
                  ),
                  Text(
                    ' Deleted',
                    style: TextStyle(
                        fontSize: 16,
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
                      text: ticketOrder.eventTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    TextSpan(
                      text:
                          "\n\nWe regret to inform you that this event has been canceled by the organizer. We understand the inconvenience this may cause and sincerely apologize.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    if (total != 0)
                      TextSpan(
                        text:
                            "\n\n Your ticket price of \$${total.toStringAsFixed(2)} will be fully refunded within 14 business days.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                    // Include any additional information or links here
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              currentUserId: currentUserId,
                              userId: ticketOrder.eventAuthorId,
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
                        text: ticketOrder.canlcellationReason,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\nContact oragnizer here.",
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),

                      // Include any additional information or links here
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
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                      TextSpan(
                        text: "\n\nYour order Id .",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\n${ticketOrder.orderId}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      // Include any additional information or links here
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
