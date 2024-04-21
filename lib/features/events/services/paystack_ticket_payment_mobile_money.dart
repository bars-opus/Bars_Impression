import 'package:bars/features/events/services/paystack_ticket_payment.dart';
import 'package:flutter/material.dart';
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

// class PaystackPaymentScreen extends StatefulWidget {
//   final String authorizationUrl;

//   PaystackPaymentScreen({required this.authorizationUrl});

//   @override
//   _PaystackPaymentScreenState createState() => _PaystackPaymentScreenState();
// }

// class _PaystackPaymentScreenState extends State<PaystackPaymentScreen> {
//   late WebViewController _webViewController;

//   @override
//   void initState() {
//     super.initState();
//     // Enable hybrid composition.
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         automaticallyImplyLeading: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text('Complete Ticket Payment',
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: WebView(
//         initialUrl: widget.authorizationUrl,
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           _webViewController = webViewController;
//         },
//         onPageFinished: (String url) async {
//           await _checkForPaymentSuccess();
//         },
//         onWebResourceError: (WebResourceError error) {
//           // Handle errors
//           print("Web resource error: ${error.description}");
//         },
//         javascriptChannels: <JavascriptChannel>{
//           JavascriptChannel(
//               name: 'flutter_inappwebview',
//               onMessageReceived: (JavascriptMessage message) {
//                 if (message.message == 'paymentSuccess') {
//                   // Pop with a result that indicates success
//                   Navigator.pop(context, true);
//                 }
//               }),
//         },
//       ),
//     );
//   }

//   Future<void> _checkForPaymentSuccess() async {
//     const checkForSuccessJS = '''
//     var checkInterval = setInterval(function() {
//       if (document.body.innerText.includes("Payment Successful")) {
//         clearInterval(checkInterval);
//         window.flutter_inappwebview.callHandler('paymentSuccess');
//       }
//     }, 1000);  // Check every 1000 milliseconds (1 second)
//     ''';

//     try {
//       await _webViewController.evaluateJavascript(checkForSuccessJS);
//     } catch (e) {
//       print('Error setting up payment success check: $e');
//     }
//   }
// }
  // Future<void> _checkForPaymentSuccess() async {
  //   // Use an IIFE to return true explicitly for testing.
  //   const testJS = '(function() { return true; })();';
  //   try {
  //     // Execute JavaScript and await the result.
  //     var result =
  //         await _webViewController.runJavascriptReturningResult(testJS);
  //     print("JS Result: $result"); // This should print 'true'

  //     // If result is 'true', consider it a success
  //     if (result.trim().toLowerCase() == 'true') {
  //       Navigator.pop(context, true);
  //     }
  //   } catch (e) {
  //     print('Error evaluating JavaScript: $e');
  //     if (e is PlatformException) {
  //       print('Error Code: ${e.code}');
  //       print('Error Message: ${e.message}');
  //       print('Error Details: ${e.details}');
  //     }
  //   }
  // }

  // Future<void> _checkForPaymentSuccess() async {
  //   // Use 'return true;' to explicitly ensure JavaScript returns something.
  //   const testJS = 'return true;';
  //   try {
  //     // Execute JavaScript and await the result.
  //     var result =
  //         await _webViewController.runJavascriptReturningResult(testJS);
  //     print(
  //         "JS Result: $result"); // This will help verify what the JS execution returns.

  //     // Log the entire page content to the console for debugging.
  //     const logBodyTextJS = 'console.log(document.body.innerText);';
  //     print(logBodyTextJS);
  //     await _webViewController.runJavascript(logBodyTextJS);

  //     // Trim and compare the result. Ensure comparison is against the string "true".
  //     if (result.trim().toLowerCase() == 'true') {
  //       Navigator.pop(context, true);
  //     }
  //   } catch (e) {
  //     // Print any errors that occur during the JavaScript execution or checking.
  //    print('Error evaluating JavaScript: $e');
  // if (e is PlatformException) {
  //   print('Error Code: ${e.code}');
  //   print('Error Message: ${e.message}');
  //   print('Error Details: ${e.details}');
  // }
  //   }
  // }

  // Future<void> _checkForPaymentSuccess() async {
  //   const checkForSuccessJS = '''
  //     if (document.body.innerText.includes('Payment Successful')) {
  //       true;  // This should be a part of the success logic
  //     } else {
  //       false;
  //     }
  //   ''';
  //   var result = await _webViewController.evaluateJavascript(checkForSuccessJS);
  //   if (result.toLowerCase() == 'true') {
  //     Navigator.pop(context, true); // Assuming 'true' means success
  //   }
  // }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black,
//         ),
//         automaticallyImplyLeading: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text('Complete payment',
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: WebView(
//         initialUrl: widget.authorizationUrl,
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           _webViewController = webViewController;
//         },
//         onPageFinished: (String url) async {
//           // After page load, inject JavaScript to check for the success message
//           const checkForSuccessJS = '''
//             if (document.body.innerText.includes('Payment Successful')) {
//               window.Flutter.postMessage('true');
//             }
//           ''';
//           _webViewController.evaluateJavascript(checkForSuccessJS);
//         },
//         javascriptChannels: <JavascriptChannel>{
//           JavascriptChannel(
//               name: 'Flutter',
//               onMessageReceived: (JavascriptMessage message) {
//                 if (message.message == 'true') {
//                   Navigator.pop(context, true); // Assuming 'true' means success
//                 }
//               }),
//         },
//         navigationDelegate: (NavigationRequest request) {
//           if (request.url.contains("/success_path")) {
//             // This path should be something you expect to see in the URL on successful payment
//             Uri uri = Uri.parse(request.url);
//             String? reference = uri.queryParameters[
//                 'reference']; // Assuming Paystack redirects with a reference

//             if (reference != null) {
//               Navigator.pop(
//                   context, PaymentResult(reference: reference, success: true));
//               return NavigationDecision.prevent; // Prevent further navigation
//             } else {
//               // Handle the case where the payment reference is not found
//               // You might want to show an error or log this case
//               print("Payment reference not found after successful payment.");
//             }
//           }
//           return NavigationDecision.navigate; // Allow navigation to other URLs
//         },
//         onWebResourceError: (WebResourceError error) {
//           // Your existing error handling code
//         },
//       ),
//     );
//   }
// }


// class PaystackPaymentScreen extends StatefulWidget {
//   final String authorizationUrl;

//   const PaystackPaymentScreen({Key? key, required this.authorizationUrl})
//       : super(key: key);

//   @override
//   _PaystackPaymentScreenState createState() => _PaystackPaymentScreenState();
// }

// class _PaystackPaymentScreenState extends State<PaystackPaymentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black,
//         ),
//         automaticallyImplyLeading: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text('Complete payment',
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: WebView(
//         initialUrl: widget.authorizationUrl,
//         javascriptMode: JavascriptMode.unrestricted,
//         navigationDelegate: (NavigationRequest request) {
//           // if (request.url.startsWith("https://your-redirect-url")) {
//           //   // Handle successful payment and close the WebView
//           //   // You can also perform a verification step here if necessary
//           //   Navigator.pop(context, true);
//           //   return NavigationDecision.prevent;
//           // }
//           return NavigationDecision.navigate;
//         },
//         onPageStarted: (String url) {
//           // Perform actions when page starts loading
//         },
//         onPageFinished: (String url) {
//           // Perform actions when page finishes loading
//         },
//         onWebResourceError: (WebResourceError error) {
//           // Handle errors
//         },
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:bars/features/events/models/Event_model.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // import 'package:webview_flutter/webview_flutter.dart';
// // Ensure all necessary imports are here.

// class MakePaymentMobileMoney extends StatelessWidget {
//   int price;
//   String email;
//   String subaccountId;

//   Event event;

//   MakePaymentMobileMoney({
//     super.key,
//     required this.price,
//     required this.email,
//     required this.event,
//     required this.subaccountId,
//   });

//   Future<String?> initializePayment() async {
//     FirebaseFunctions functions = FirebaseFunctions.instance;

//     // Data to send to the Cloud Function
//     // final paymentData = {
//     //   'email': email, // Replace with the actual customer's email
//     //   'amount': price *
//     //       100, // Replace with the actual amount in the smallest currency unit (e.g., pesewas for GHS)
//     //   'platform':
//     //       Platform.isIOS ? 'iOS' : 'Android', // Specify the platform as needed
//     //   'subAccount': subaccountId, // Replace with the actual subaccount code
//     // };

//     // try {
//     // Call the Cloud Function 'initializePayment'
//     final HttpsCallable callable =
//         FirebaseFunctions.instance.httpsCallable('initializePayment');
//     final verificationResult = await callable.call(<String, dynamic>{
//       'email': email, // Replace with the actual customer's email
//       'amount': price *
//           100, // Replace with the actual amount in the smallest currency unit (e.g., pesewas for GHS)
//       'platform':
//           Platform.isIOS ? 'iOS' : 'Android', // Specify the platform as needed
//       'subAccount': subaccountId,
//     });
//     // final HttpsCallableResult result =
//     //     await functions.httpsCallable('initializePayment').call(paymentData);

//     return verificationResult.data['authorizationUrl'];
//     // } catch (e) {
//     //   print(e);
//     //   return null;
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Make Payment'),
//       ),
//       body: FutureBuilder<String?>(
//         future: initializePayment(),
//         builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return Center(child: Text('Failed to load payment page'));
//           } else {
//             return WebView(
//               initialUrl: snapshot.data,
//               javascriptMode: JavascriptMode.unrestricted,
//               navigationDelegate: (NavigationRequest request) {
//                 if (request.url.startsWith('https://hello.pstk.xyz/callback')) {
//                   // Handle success callback
//                   Navigator.of(context).pop();
//                   return NavigationDecision.prevent;
//                 }
//                 if (request.url.startsWith('https://your-cancel-url.com')) {
//                   // Handle cancel callback
//                   Navigator.of(context).pop();
//                   return NavigationDecision.prevent;
//                 }
//                 return NavigationDecision.navigate;
//               },
//             );

//             // const Center(child: Text('Failed to load payment page'));
//           }
//         },
//       ),
//     );
//   }
// }
