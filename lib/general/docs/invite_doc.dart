import 'package:bars/utilities/exports.dart';

class inviteDoc extends StatelessWidget {
  final VoidCallback affiliateOnPressed;
  final bool showInviteButton;

  const inviteDoc({
    super.key,
    required this.affiliateOnPressed,
    required this.showInviteButton,
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
          if (showInviteButton)
            Align(
              alignment: Alignment.centerRight,
              child: MiniCircularProgressButton(
                onPressed: affiliateOnPressed,
                text: "Continue",
                color: Colors.blue,
              ),
            ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () async {
              // if (!await launchUrl(
              //     Uri.parse('https://www.barsopus.com/refund-policy'))) {
              //   throw 'Could not launch ';
              // }
            },
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Send\ninvites.',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                    text:
                        "\n\nSend broadcast invitations to friends and family, ensuring that everyone important to you receives a personalized invite.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nAccepting the Invitation.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nWhile an invitation is extended, guests are not obligated to accept. The invitation can be accepted or declined at the recipient's discretion. Upon accepting the invitation, a complimentary event ticket will be automatically generated for that individual",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nComplimentary Tickets for Invited Guests",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nFor paid events, you can choose to send invitations that include a free ticket. This allows the invited guest to attend the event at no cost. The ticket will clearly indicate that it is a Free Pass to distinguish the invited guests.",
                    style: Theme.of(context).textTheme.bodyMedium,
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
