import 'package:bars/utilities/exports.dart';

class CreateEventDoc extends StatelessWidget {
  const CreateEventDoc({super.key});

  @override
  Widget build(BuildContext context) {
    var featureStyleBig = TextStyle(
      color: Theme.of(context).secondaryHeaderColor,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 18),
    );
    var moreStyle = TextStyle(
      color: Colors.blue,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
    );
    return Container(
        height: ResponsiveHelper.responsiveHeight(context, 600),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TicketPurchasingIcon(
              title: '',
            ),
            Center(
              child: Text(
                "\nA new venue,\nA new canvas.    ",
                style: featureStyleBig,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: ShakeTransition(
                axis: Axis.vertical,
                child: Container(
                  color: Colors.grey,
                  height: 1,
                  width: ResponsiveHelper.responsiveWidth(context, 70),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "\nEvents and music have the power to create lasting memories that resonate deep within our souls,and we are here to foster that.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              '\nIn all aspects, \nYou are covered.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse('https://www.barsopus.com/private-event'))) {
                  throw 'Could not launch ';
                }
              },
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\nPrivate.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text:
                          "\nFrom intimate birthdays to grand weddings and beyond, our platform simplifies every aspect, making it effortless to create unforgettable moments.\nDesign eye-catching event fliers, Send personalized broadcast invitations, and stay organized with timely reminders..",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: "\nmore",
                      style: moreStyle,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse('https://www.barsopus.com/commercial-event'))) {
                  throw 'Could not launch ';
                }
              },
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\nCommercial.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text:
                          "\nReach local audiences, generate tickets, streamline entry management, and enhance attendee Experience..",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: "\nmore",
                      style: moreStyle,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "\n\nCreate memories that lasts a lifetime.\n",
              style: featureStyleBig,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                color: Colors.grey,
                height: 1,
                width: ResponsiveHelper.responsiveWidth(context, 70),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "\nInvite family and friends.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nSend broadcast invitations to friends and family, ensuring that everyone important to you receives a personalized invite.\nSeamlessly manage and track guest lists, and communicate updates, keeping everyone in the loop..",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nBook creatives.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nDiscover and book talented creatives and service providers. From musicians and photographers to venues and more, our platform connects you with professionals who can enhance your event.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse('https://www.barsopus.com/ticket-system'))) {
                  throw 'Could not launch ';
                }
              },
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\nBuy and Sell Ticket.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text:
                          "\nSay goodbye to long queues, complicated processes, and missed opportunities.\nOur ticketing system is designed to make selling and purchasing of tickets simple, secure and effortless..",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: "\nmore",
                      style: moreStyle,
                    ),
                  ],
                ),
              ),
            ),
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "\nReminders.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nStay on track and never miss an event. Receive timely daily reminders and add events to your calendar for seamless event engagement and attendance.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nStay connected.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nFoster networking and connections among event attendees. Each event has its own group, providing a space for participants to engage, share experiences, and build meaningful connections.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nManage activities.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nA management dashboard that simplifies your event activities. You can effortlessly validate tickets using a barcode scanner, efficiently manage attendee and invitee lists, and even request pay-outs for ticket sales. Experience seamless event management and much more..",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ));
  }
}
