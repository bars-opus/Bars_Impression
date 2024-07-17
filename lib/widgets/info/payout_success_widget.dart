import 'package:bars/utilities/exports.dart';

class PayoutSuccessWidget extends StatelessWidget {
  final int amount;
  const PayoutSuccessWidget({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 450),
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
                'Payout\nsuccessfully processed',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "We are pleased to inform you that your payout request has been successfully processed. The requested funds of ${amount} have been transferred to your designated account and should be credited within the next few minutes.\n\nThank you for choosing Bars Impression.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
