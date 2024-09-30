import 'package:bars/utilities/exports.dart';

class ValidatorDoc extends StatelessWidget {
  const ValidatorDoc({super.key});

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
                  text: 'Ticket Validation:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextSpan(
                  text:
                      "\n\nThe scanning system (validator) on your event dashboard utilizes a QR code scanner to validate attendees' tickets. Upon successful validation, the QR code on the ticket changes color, and a blue verified checkmark is displayed in the top-right corner of the attendees' tickets. The ticket validation process typically takes only milliseconds, although the duration may vary depending on network conditions and the strength of connectivity. Once a ticket is scanned, the QR code scanner resets itself to scan another ticket. However, please avoid keeping the scanner on a ticket for an extended period after scanning, as it may result in a \"Ticket already validated\" error.\n\n",
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
                  text:
                      "\n\nDifferent errors that may occur during ticket scanning include:",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextSpan(
                  text: "\n\n1.	Ticket not found:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nThis indicates that the scanned ticket is either unavailable or forged.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n2.	Ticket has already been validated:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nThis means that the ticket is authentic and has already been validated for the attendee.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n3.	Ticket not valid for today: ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nThis error occurs when the scanned ticket's date does not match the current date. It typically happens for events that span multiple days and offer different tickets for each day. For example, if an event is taking place over two days, a ticket purchased for the first day (20th) would not be validated by the scanner on the 22nd. The ticket's date must match the current day for successful validation.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text:
                      "\n\n4.	Invalid QR code data or invalid QR code format: ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nThis error indicates that the scanned ticket is forged or contains invalid QR code data.\n\n",
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
                  text: "\n\nDetecting forged tickets:",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextSpan(
                  text:
                      "\nWhen scanning a ticket, a blue linear loading indicator should appear on the ticket, indicating that it is being scanned. If this loading indicator does not appear, it suggests that the ticket is forged or a screenshot. We encourage you to only scan tickets presented by attendees within the app while it is open and to avoid scanning screenshots of tickets. Valid tickets will provide a gentle haptic feedback on your phone, while non-valid tickets will generate a more pronounced vibration impact.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text:
                      "\n\nIn situations where an attendee leaves the venue and returns with a previously scanned ticket indicating they have already been validated, we recommend asking the attendee to verify that the ticket is not a screenshot. They can do this by navigating away from the ticket page in the app and then returning to it. This process should confirm the legitimacy of the ticket.\n\n",
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
                  text: "\n\nScanning Instructions:",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextSpan(
                  text:
                      "\nPosition your phone's camera in such a way that the QR code on the ticket is entirely visible within the scanning frame. Ensure good lighting conditions for optimal scanning accuracy.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n1.	Error Handling:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nIf you encounter any errors during the scanning process, please follow these steps:",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text:
                      "\n•	For a \"Ticket not found\" error,\nkindly verify that the ticket is valid and try scanning again. If the issue persists, contact our support team for assistance.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text:
                      "\n•	If you receive an \"Invalid QR code data or invalid QR code format\" error,\nit is possible that the ticket has been tampered with. Please ensure you are scanning a genuine ticket and not a forged version.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text:
                      "\•	In the case of a \"Ticket not valid for today\" error, confirm that the ticket corresponds to the current event date. If you believe there is an error, please consult our event staff for further guidance.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n2.	Scanner Performance Tips:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\n•	Ensure good lighting conditions during scanning to enhance QR code readability.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text:
                      "\n•	Avoid covering the QR code on your ticket, as it may affect scanning accuracy.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text:
                      "\n•	Keep your device's camera lens clean for optimum scanning results.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n3.	Offline Mode:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nOur scanning system requires an internet connection to validate tickets. Please ensure you have a stable network connection or access to mobile data for seamless ticket validation.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\n4.	App Permissions: ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nFor the scanning system to function correctly, the app requires access to your device's camera. Please grant the necessary camera permissions when prompted to ensure smooth ticket scanning.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text:
                      "\n\n\nWe hope this documentation provides comprehensive guidance on using the scanning system effectively and accurately validating attendees' tickets.",
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
