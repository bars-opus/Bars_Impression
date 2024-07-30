import 'package:bars/utilities/exports.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaystackPaymentScreen extends StatefulWidget {
  final String authorizationUrl;

  const PaystackPaymentScreen({Key? key, required this.authorizationUrl})
      : super(key: key);

  @override
  _PaystackPaymentScreenState createState() => _PaystackPaymentScreenState();
}

class _PaystackPaymentScreenState extends State<PaystackPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Complete Ticket Payment',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: widget.authorizationUrl,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          // Check if the URL starts with the base path
          if (request.url
              .startsWith("https://links.barsopus.com/barsImpression/")) {
            // Parse the URL to work with its components
            Uri uri = Uri.parse(request.url);

            // The last part of the path is the unique identifier
            String? uniqueIdentifier =
                uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;

            // if (uniqueIdentifier != null) {
            // Here you handle the case where you successfully retrieve the unique identifier
            print("Unique Identifier: $uniqueIdentifier"); // Example action

            // Optionally, you might want to use this identifier to perform some actions,
            // For example, confirming a payment or other transaction
            Navigator.pop(context, PaymentResult(success: true, reference: ''));
            return NavigationDecision.prevent; // Prevent further navigation
            // } else {
            //   // Handle the case where the path segment is not found
            //   print("No unique identifier found after successful payment.");
            // }
          }
          return NavigationDecision.navigate; // Allow navigation to other URLs
        },
        onPageStarted: (String url) {
          // Perform actions when page starts loading
        },
        onPageFinished: (String url) {
          // Perform actions when page finishes loading
        },
        onWebResourceError: (WebResourceError error) {
          // Handle errors
        },
      ),
    );
  }
}
