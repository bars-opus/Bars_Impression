import 'package:bars/utilities/exports.dart';

class PayoutDoc extends StatelessWidget {
  final String eventTitle;
  final Timestamp? eventClossinDay;

  final bool isRequesting;
  final bool isFreeEvent;
  final bool isCashPayment;

  const PayoutDoc(
      {super.key,
      required this.eventTitle,
      required this.isFreeEvent,
      required this.isCashPayment,
      this.eventClossinDay,
      required this.isRequesting});

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
    return Column(children: [
      isRequesting
          ? RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Request\nTicket Payouts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                    text:
                        '\n\nCongratulations on successfully completing ${eventTitle}. We are delighted to see that you have reached this significant milestone. Completing such an event is a commendable achievement, and we appreciate your dedication.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        '\n\nWe understand that you are ready to receive the payouts for your ticket sales. It is important for you to have a clear understanding of how the payout system functions. While most payouts are instant, occasional network issues and other factors may contribute to slight delays in the payout. Typically, payouts are processed within 3 days after your request. Please note that Bars Impression applies a 1% commission on the payment amount to cover maintenance and other operational costs associated with managing the event process.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        '\n\nKindly ensure that you have completed your event and are fully prepared to receive your funds before submitting a payout request. Please remember that payout requests can only be made once. The funds will be transferred to the bank account linked to the event at the time of its creation.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '\nTicket Sales Payouts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  isFreeEvent || isCashPayment
                      ? TextSpan(
                          text:
                              '\n\nTicket sales payouts is where you request for your ticket sales funds.\n\nThis is only available for events that offer paid tickets through Bars Impression(not support for payment through other website or cash-payment)  and not free events. ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : TextSpan(
                          text:
                              '\n\nYour ticket sales funds will be made available after the closing date of your event: ${MyDateFormat.toDate(eventClossinDay!.toDate())}. You will be able to request a payout of those funds at that time if you sell any tickets. ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                ],
              ),
            ),
      if (isRequesting)
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _sendMail('support@barsopus.com', context);
          },
          child: RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '\n\nIf you have any further questions or need assistance, please don\'t hesitate to reach out to our ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: 'support team.',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14)),
                ),
              ],
            ),
          ),
        )
    ]);
  }
}
