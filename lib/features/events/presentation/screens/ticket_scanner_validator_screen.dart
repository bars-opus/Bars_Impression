
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
  String query = "";
  int limit = 10;
  bool _showInfo = true;
  late ScrollController _hideButtonController;
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  StreamSubscription<Barcode>? barcodeStreamSubscription;

  @override
  void initState() {
    super.initState();

    _setShowInfo();
    _hideButtonController = ScrollController();
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    controller?.dispose();
    barcodeStreamSubscription?.cancel();
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

  void _setShowInfo() {
    if (_showInfo) {
      Timer(Duration(seconds: 7), () {
        if (mounted) {
          setState(() {
            _showInfo = false;
          });
        }
      });
    }
  }

  void onQRViewCreated(QRViewController controller) async {
    setState(() => this.controller = controller);
    barcodeStreamSubscription = controller.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));


      // Call the validateTicket method
      // await DatabaseService.validateTicket(widget.event, barcode.rawBytes.toString());

      // Show a SnackBar after the validation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ticket validated.'),
        ),
      );  }

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
