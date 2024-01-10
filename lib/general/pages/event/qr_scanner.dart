import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      Navigator.pop(context, scanData.code);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// In this example, a new screen is created that displays the QR code scanner. When a QR code is scanned, the scanner is paused, and the scanned data is passed back to the previous screen.

// You can then use the scanned data for ticket verification or event check-in. For example, the scanned data might contain a ticket ID, which you can look up in your database to verify the ticket. Or, it might contain an attendee's ID, which you can use to check them into the event.

// Here's an example of how you might call the ScanScreen and handle the scanned data:


// void _scanTicket() async {
//   String? ticketId = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => ScanScreen()),
//   );

//   if (ticketId != null) {
//     bool valid = await DatabaseService.verifyTicket(ticketId);
//     if (valid) {
//       // Handle valid ticket
//     } else {
//       // Handle invalid ticket
//     }
//   }
// }

// void _checkInAttendee() async {
//   String? attendeeId = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => ScanScreen()),
//   );

//   if (attendeeId != null) {
//     await DatabaseService.checkInAttendee(attendeeId);
//     // Handle attendee check-in
//   }
// }
