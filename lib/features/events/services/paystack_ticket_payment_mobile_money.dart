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
