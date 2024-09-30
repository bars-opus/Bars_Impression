import 'package:bars/utilities/exports.dart';

class EventEvidenceDoc extends StatelessWidget {
  final VoidCallback refundOnPressed;

  const EventEvidenceDoc({
    super.key,
    required this.refundOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
                  text: 'Event evidence.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextSpan(
                  text:
                      "\n\nTo maintain the integrity of Bars Impression, we require that events meet a minimum attendance threshold before organizers can request payouts. Here’s why this is important:",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n - Fraud Prevention:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nThis policy helps prevent organizers from creating fake events just to sell tickets. By requiring at least 10% of expected attendees to validate their tickets, we reduce the risk of fraudulent claims.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n - Ensuring Legitimate Events:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nIt confirms that the events are real and have attracted genuine participants, helping to uphold the reputation of our platform.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n - Protecting Attendees:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nThis requirement safeguards attendees by ensuring they are purchasing tickets for legitimate events that have actual participation.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n - Encouraging Engagement:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nKnowing they need to reach an attendance threshold motivates organizers to actively promote their events, leading to better experiences for attendees.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n - Building Trust:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nOverall, this policy creates a reliable marketplace for both organizers and attendees, fostering confidence in our platform.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
