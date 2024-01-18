import 'package:bars/utilities/exports.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class TicketScannerValidatorScreen extends StatefulWidget {
  static final id = 'TicketScannerValidatorScreen';
  final Event event;
  final String from;
  final PaletteGenerator palette;

  TicketScannerValidatorScreen({
    required this.event,
    required this.palette,
    required this.from,
  });

  @override
  _TicketScannerValidatorScreenState createState() =>
      _TicketScannerValidatorScreenState();
}

class _TicketScannerValidatorScreenState
    extends State<TicketScannerValidatorScreen>
    with AutomaticKeepAliveClientMixin {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _mySnackBar(BuildContext context, Color color, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.all(10),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
            child: ListTile(
              leading: Icon(
                Icons.info_outline_rounded,
                color: Colors.grey.withOpacity(.3),
              ),
              title: Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                ),
              ),
            ),
          )),
    );
  }

  Future<bool> validateTicket(BuildContext context, Event event,
      String ticketOrderUserId, String currentTicketId) async {
    bool isTicketValidated = false;

    try {
      isTicketValidated = await FirebaseFirestore.instance
          .runTransaction<bool>((transaction) async {
        // Get the order document reference
        DocumentReference orderDocRef = newEventTicketOrderRef
            .doc(event.id)
            .collection('eventInvite')
            .doc(ticketOrderUserId);

        DocumentReference userOrderDocRef = userInviteRef
            .doc(ticketOrderUserId)
            .collection('eventInvite')
            .doc(event.id);

        // Read the order document
        DocumentSnapshot orderSnapshot = await transaction.get(orderDocRef);

        if (!orderSnapshot.exists) {
          throw Exception('Ticket not found.');
        }

        // Deserialize the order document into TicketOrderModel
        TicketOrderModel order = TicketOrderModel.fromDoc(orderSnapshot);

        bool ticketFound = false;
        List<Map<String, dynamic>> updatedTickets = [];

        for (var ticket in order.tickets) {
          if (ticket.entranceId == currentTicketId) {
            ticketFound = true;
            DateTime eventDate = ticket.eventTicketDate.toDate();
            DateTime today = DateTime.now();

            if (ticket.validated) {
              throw Exception('Ticket has already been validated.');
            }

            if (eventDate.year != today.year ||
                eventDate.month != today.month ||
                eventDate.day != today.day) {
              throw Exception('Ticket is not valid for today\'s date.');
            }

            // Update the validated status of the ticket
            ticket.validated = true;
            updatedTickets.add(ticket.toJson());
            break; // Break after finding and updating the ticket
          }
        }

        if (!ticketFound) {
          throw Exception('Ticket not found.');
        }

        // Update the order document with the updated tickets array
        transaction.update(orderDocRef, {'tickets': updatedTickets});
        transaction.update(userOrderDocRef, {'tickets': updatedTickets});

        return true; // Ticket successfully validated
      });
    } catch (e) {
      // Handle errors by showing a Snackbar
      HapticFeedback.heavyImpact();
      _mySnackBar(context, Colors.red, e.toString());
      isTicketValidated = false;
    }

    return isTicketValidated;
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // Stop scanning
      controller.pauseCamera();

      // Extract the data from the QR code
      final String? scannedData = scanData.code;

      if (scannedData == null || !scannedData.contains('|')) {
        _mySnackBar(context, Colors.red, 'Invalid QR code format.');
        controller.resumeCamera();
        return;
      }

      final List<String> scannedDataPartition =
          scannedData.trim().replaceAll('\n', ' ').split("|");

      if (scannedDataPartition.length != 2) {
        _mySnackBar(context, Colors.red, 'Invalid QR code data.');
        controller.resumeCamera();
        return;
      }

      bool validated = await validateTicket(
        context,
        widget.event,
        scannedDataPartition[0].trim(),
        scannedDataPartition[1].trim(),
      );

      // Show a SnackBar after the validation
      if (validated == true)
        _mySnackBar(context, Colors.blue, 'Ticket has been validate');

      // If you want to resume scanning after a certain condition, you can call:
      await Future.delayed(Duration(seconds: 3));
      controller.resumeCamera();
    });
  }

  Widget buildQRView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: barcode == null ? Colors.white : Colors.blue,
          borderWidth: barcode == null ? 5 : 10,
          borderLength: barcode == null ? 40 : 100,
          cutOutSize: barcode == null
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width - 50,
        ),
      );

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQRView(context),
          Positioned(
            top: 80,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.close),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
