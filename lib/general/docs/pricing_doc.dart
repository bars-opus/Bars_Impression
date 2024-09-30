import 'package:bars/utilities/exports.dart';

class PricingDoc extends StatefulWidget {
  // final VoidCallback refundOnPressed;
  // final bool isRefunding;
  const PricingDoc({
    super.key,
  });

  @override
  State<PricingDoc> createState() => _PricingDocState();
}

class _PricingDocState extends State<PricingDoc> {
  final TextEditingController _amountController = TextEditingController();

  double _commission = 0.0;

  double _processingFee = 0.0;

  void _calculateFees() {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      _commission = amount * 0.01;
      _processingFee = ProcessingFeeCalculator.calculateProcessingFee(amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            TicketPurchasingIcon(
              title: '',
            ),
            const SizedBox(height: 40),
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Pricing.',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                    text:
                        "\n\nOur goal is to provide a transparent and fair pricing model for both event organizers and attendees.\n",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Divider(),
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "\nOrganizer Fees.",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextSpan(
                    text:
                        "\nWe charge a 1% commission on the total ticket sales from the event organizer.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nExample:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "\nIf the total sales amount to GHC 10,000, the commission fee will be GHC 100.\n",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Divider(),
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "\nAttendee Processing Fees.",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextSpan(
                    text:
                        "\nProcessing fees are applied based on the price of each ticket purchased. These fees cover transaction and service costs.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nExample:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "\n - Tickets less than GHC 100: \n    GHC 5 processing fee.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "\n\n - Tickets between GHC 100 and GHC 500: \n    GHC 10 processing fee.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "\n\n - Tickets between GHC 500 and GHC 1000: \n    GHC 20 processing fee.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Divider(), const SizedBox(height: 40),

            Text(
              "Price calculator.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20),
            TextField(
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _calculateFees();
              },
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                labelStyle: TextStyle(color: Colors.blue),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(height: 16),
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Commission (1%):     ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: 'GHC $_commission',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Processing Fee:        ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: 'GHC $_processingFee',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            // Text(
            //   'Commission (1%): GHC $_commission',
            //   style: Theme.of(context).textTheme.bodyMedium,
            // ),
            // Text(
            //   'Processing Fee: GHC $_processingFee',
            //   style: Theme.of(context).textTheme.bodyMedium,
            // ),
            SizedBox(height: 16),
            Text(
              'Note: Processing fees are paid by attendees and are used to cover taxes and other processing expenses. These fees do not affect the profit of the organizers, as they are additional charges on the platform.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
