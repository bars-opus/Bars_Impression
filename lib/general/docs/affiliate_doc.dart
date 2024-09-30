import 'package:bars/utilities/exports.dart';

class AffiliateDoc extends StatelessWidget {
  final VoidCallback affiliateOnPressed;
  final bool isAffiliated;
  final bool isOganiser;

  const AffiliateDoc({
    super.key,
    required this.affiliateOnPressed,
    required this.isAffiliated,
    required this.isOganiser,
  });

  @override
  Widget build(BuildContext context) {
    String whatIsAffiliate =
        "\n\nAffiliate marketing is a type of performance-based marketing where a business rewards one or more affiliates for each visitor or customer brought about by the affiliate's own marketing efforts.";
    String whoIsAnAffiliate =
        "\n\nAn affiliate is an individual or organization that promotes and helps sell products or services (tickets) on behalf of a company or event organizer. Affiliates typically receive a commission or percentage of the sales they generate through their promotional efforts.";
    String partnership =
        "\nAffiliates have an established partnership or agreement with the company/organizer to market and sell their offerings";
    String promotional_Channels =
        '\nAffiliates leverage their own platforms, such as websites, social media, email lists, etc. to reach and engage their audience';
    String commissionEg =
        'For example, if the ticket price is GHC 50 and the affiliate commission is 20%, the affiliate would earn GHC 10 for every ticket they sell.';
    String comission = isOganiser
        ? "\nThis is the commission you would like to offer an affiliate for each ticket they sell. $commissionEg"
        : '\nAffiliates earn a predetermined commission, often a percentage, for each sale they facilitate through their promotional activities. $commissionEg';

    String terms =
        "All participating affiliates will be required to agree to the terms and conditions outlined in the Affiliate Agreement. This legally binding contract will govern the relationship between the event organizer and each affiliate partner";
    String termAndConditions = isOganiser
        ? "\nYou may provide terms and conditions, as part of the affiliate program. $terms"
        : "\n$terms";

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          TicketPurchasingIcon(
            title: '',
          ),
          if (isAffiliated)
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
            child: isOganiser
                ? RichText(
                    textScaler: MediaQuery.of(context).textScaler,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'An Affiliate.',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text: whatIsAffiliate,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: whoIsAnAffiliate,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n\nYou can create and distribute affiliate invitations to up to 10 influencers. This will allow them to promote your event and earn a commission on any ticket sales generated through their unique affiliate links.\n\nTo get started, you can send the affiliate invitation for them to review and accept. Once they accept, they can begin promoting your event to their audience. The commission structure and payout details will be clearly outlined in the affiliate agreement.\n\nThis provides a mutually beneficial opportunity, as you can leverage the influencers' reach to drive additional ticket sales, while the affiliates can earn a percentage of the revenue they generate for your event",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n\nA free affiliate ticket will be generated and provided to the partner upon acceptance of the invitation. This ticket is non-transferrable and intended solely for the affiliated individual to attend the event.\nThis free ticket is a way of showing appreciation for the affiliate's willingness to promote and drive ticket sales for the event. It also ensures the affiliate can experience the event firsthand, which can enhance their ability to effectively market it to their audience.\n\nPlease note that the free ticket does not replace or reduce the affiliate's earned commissions from ticket sales",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nPartnership.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: partnership,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nPromotional Channels.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: promotional_Channels,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nCommission.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: comission,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nInvite message.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\nYou can enter customized affiliate invitation messages for potential affiliates.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nTerms and conditions.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: termAndConditions,
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
                          text: 'An Affiliate.',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text: whatIsAffiliate,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: whoIsAnAffiliate,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nPartnership.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: partnership,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nPromotional Channels.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: promotional_Channels,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nCommission.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: comission,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nTerms and conditions.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: termAndConditions,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 60),
          RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Note.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextSpan(
                  text:
                      "\n\nNeither event organizers nor affiliates will be paid in the case of cancellation or deletion of the event.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\n\nThe affiliate deal must be accepted at least 2 days before the event date.\n",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text: termAndConditions,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
