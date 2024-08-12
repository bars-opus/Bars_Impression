import 'package:bars/utilities/exports.dart';

class ManagerDonationDoc extends StatelessWidget {
  final bool isDonation;
  final bool isCreating;
  final bool isCurrentUser;

  const ManagerDonationDoc(
      {super.key,
      required this.isDonation,
      required this.isCurrentUser,
      required this.isCreating});

  @override
  Widget build(BuildContext context) {
    void _navigateToPage(BuildContext context, Widget page) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }

    String _bookingTitle = 'Booking manager.';
    String _bookingOverview =
        "\n\nOur Booking Manager streamlines the process of booking creatives for various events and projects. Whether you're a client looking to hire a creative professional or a creative service provider, this comprehensive guide will walk you through the end-to-end booking workflow.";

    var pyoutSyle = TextStyle(
      color: Colors.red,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
    );
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          TicketPurchasingIcon(
            title: '',
          ),
          const SizedBox(height: 40),
          isDonation
              ? RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Donations: Understanding Your Supporters',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextSpan(
                        text:
                            "\n\nAs a creative on our platform, the donation feature is an important way for your supporters to show their appreciation and contribute to your journey. Here's what you need to know about the donations:.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\n\nDonation Purpose.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text:
                            "\nDonations from your supporters are a valuable source of funding that can help you continue your creative pursuits and develop your skills further. This support allows you to focus on your passion without the burden of financial constraints.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\n\nNo Obligations.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text:
                            "\nWhen your supporters choose to make a donation, they do so out of their own free will. They do not expect any favors, special treatment, or additional services in return. Your supporters understand that their donation is a gift, and you are not obligated to provide anything beyond your ongoing creative work.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\n\nNon-Refundable Donations",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text:
                            "\nOnce a supporter has made a donation, it is non-refundable. This means that you can rely on the funds they have provided, and you don't need to worry about them requesting a refund at a later date.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\n\nMinimum Donation Amount",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text:
                            "\nThe minimum donation amount is GHC 10. Your supporters can choose to donate any amount above this minimum, based on their individual circumstances and the value they place on your work.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\n\nReceiving Donations.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text:
                            "\nWhen one of your supporters makes a donation, you will be notified. The donation amount will be added to your account balance, ready for you to request a payout.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\n\nRequesting Donation Payout.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text:
                            "\nTo access the donated funds, you can request a payout from your account settings - donation - (received tab). This will transfer the donation amount to the payment account associated with your profile.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\n\nUsing Donated Funds.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text:
                            "\nThe payment account linked to your profile is the same one used for event ticket sales and booking management. You can use the donated funds to support your creative work, such as:",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "\n - Purchasing materials and supplies",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text:
                            "\n - Investing in professional development opportunities",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text:
                            "\n - Covering your living expenses while you focus on your craft",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text:
                            "\n\nRemember, the donations you receive are a testament to the impact of your work. We encourage you to use these funds to nurture your creativity and propel your career forward.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              : isCurrentUser
                  ? RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _bookingTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextSpan(
                            text: _bookingOverview,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "\n\nReviewing Booking Requests.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text:
                                "\n - A client chooses the desired booking date from your booking calendar. The client selects the appropriate price rate and duration for the service, as defined in your portfolio.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - When a client submits a booking request, you will be notified.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - Review the details of the request and decide whether to accept or reject it.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "\n\nResponding to the Client.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text:
                                "\n - If you accept the request, the client will be notified and prompted to make the initial deposit payment of 30% of the initial booking price.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - If you reject the request, the client will be notified with the reason (if provided) so that they can adjust and resubmit the request.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "\n\nPreparing for the Booked Service.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text:
                                "\n - Once the client makes the 30% deposit payment, you will be notified, and the booking will be confirmed.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - With the booking is confirmed, you can begin preparing for the event or project and coordinate with the client as needed.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "\n\nService Delivery and Final Payment.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text:
                                "\n - During the service delivery, you and the client should use the app's barcode scanner on the booking card to log the actual arrival and departure times. Without this validation the initial payment wouldn\'t be activated.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - After the service is completed, the client will be prompted to make the final payment.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - Both you and the client will receive confirmation of the final payment, signaling the successful completion of the booking.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "\n\nRequesting your funds.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text:
                                "\nTo access the final booking funds, you can request a payout from your booking card after the final payment. This will transfer the booking amount to the payment account associated with your profile. The payment account linked to your profile is the same one used for event ticket sales and donation.",
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
                            text: _bookingTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextSpan(
                            text: _bookingOverview,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "\n\nSubmitting a Booking Request.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text:
                                "\n - A client chooses the desired booking date from the booking calendar. \n- The client selects the appropriate price rate and duration for the service, as defined in the creatives portfolio.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - Your booking request will sent to the selected creative and stored in a pending state, awaiting review.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "\n\nReceiving the Creatives's Response.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text:
                                "\n - You will be notified when the creative has reviewed and responded to your booking request.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - If the creative accepts your request, you will be prompted to make an initial deposit payment of 30% of the service price.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - If the provider rejects your request, you will be notified with the reason (if provided) so that you can adjust your request and submit it again.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - With the deposit payment complete, the booking will be confirmed, and both you and the service provider can begin preparing for the event or project.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "\n\nService Delivery and Final Payment.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text:
                                "\n - During the service delivery, you should use the app's barcode scanner on the booking card to log the actual arrival and departure times of the creative. Without this validation the initial payment wouldn\'t be activated.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - After the service is completed, the you will be prompted to make the final payment.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text:
                                "\n - Both you and the creative will receive confirmation of the final payment, signaling the successful completion of the booking.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
          if (!isDonation)
            Text(
              '\nRemember, The Booking Manager is designed to provide a seamless and transparent booking experience for both clients and service providers.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (isCurrentUser)
            RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(children: [
                  TextSpan(
                    text: "\nAdd payout account.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        '\nWithout adding a payout account, you will not be able to receive payments or payouts related to your booking management, donations, or event ticket sales.',
                    style: pyoutSyle,
                  ),
                ])),
          const SizedBox(height: 40),
          if (isCreating)
            Align(
              alignment: Alignment.center,
              child: MiniCircularProgressButton(
                onPressed: () {
                  _navigateToPage(
                      context,
                      CreateSubaccountForm(
                        isEditing: false,
                      ));
                },
                text: "Add payout account",
                color: Colors.blue,
              ),
            ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
