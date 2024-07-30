import 'package:bars/utilities/exports.dart';

class PayoutSuccessWidget extends StatelessWidget {
  final int amount;
  final bool payout;
  final bool payment;

  const PayoutSuccessWidget(
      {super.key,
      required this.amount,
      this.payout = true,
      this.payment = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, payment ? 350 : 450),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TicketPurchasingIcon(
              title: '',
            ),
            ShakeTransition(
              duration: const Duration(seconds: 2),
              child: Icon(
                Icons.check_circle_outline_outlined,
                size: 50,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                payment
                    ? 'Payment\nsuccessfully processed'
                    : payout
                        ? 'Payout\nsuccessfully processed'
                        : 'Donation\nsuccessful',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              payment
                  ? 'Your 30% down payment has been successfully processed. Your booking request has now been finalized and confirmed.'
                  : payout
                      ? "We are pleased to inform you that your payout request has been successfully processed. The requested funds of ${amount} have been transferred to your designated account and should be credited within the next few minutes.\n\nThank you for choosing Bars Impression."
                      : 'You donatino to this user has been successful. We appreciate your generosity and support for the creative community.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
