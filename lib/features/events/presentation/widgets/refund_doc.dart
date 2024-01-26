import 'package:bars/utilities/exports.dart';
import 'package:bars/utilities/webview_url.dart';
import 'package:bars/widgets/ticket_purchasing_process_icon.dart';
import 'package:flutter/material.dart';

class RefundDoc extends StatelessWidget {
  const RefundDoc({super.key});

  @override
  Widget build(BuildContext context) {
    void _navigateToPage(BuildContext context, Widget page) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          // const SizedBox(
          //   height: 30,
          // ),
          TicketPurchasingIcon(
            title: '',
          ),
          const SizedBox(height: 40),
          // RichText(
          //   textScaleFactor: MediaQuery.of(context).textScaleFactor,
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //         text: 'Refund',
          //         style: Theme.of(context).textTheme.titleMedium,
          //       ),
          //       TextSpan(
          //         text: "\n\n${widget.event.termsAndConditions}",
          //         style: Theme.of(context).textTheme.bodyMedium,
          //       ),
          //     ],
          //   ),
          // ),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse('https://www.barsopus.com/'))) {
                throw 'Could not launch ';
              }
            
            },
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Refund.',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                    text:
                        "\n\nThank you for using Bars Impression to purchase tickets for events. We aim to provide a seamless ticketing experience for our users. In the event that you need to request a refund for a purchased ticket, please review our refund policy outlined below.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nRefund Amount.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nPlease note that we offer a partial refund policy.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "\n - We will refund 80 percent of the ticket purchase price.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "\n - The remaining 20 percent will be retained as a non-refundable fee to cover administrative and processing costs associated with ticket sales and refunds.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nRefund Timeframe.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\n - The time it takes to process a refund may vary depending on your original payment method and financial institution.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "\n - It may take up to 10 business days for customers to receive their funds",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nEvent Cancellation.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nIn the event of cancellation by the organizers, attendees will be offered a full refund.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nNon-Refundable Circumstances.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nRefunds will not be provided under the following circumstances:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n - The event has already taken place.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "\n - The refund request is made after the specified deadline (no later than 2 days before the scheduled event date.).",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nNon-refundable Fees.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nPlease be aware that tickets bought via third-party websites or through cash transactions are not eligible for refunds. Currently, we only process refunds for tickets sold within Ghana, where payments are directly handled by our system",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nRed full refund policy.",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
