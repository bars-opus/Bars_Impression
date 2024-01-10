// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class MyPaymentService {

//   // Flutterwave API base URL
//   static const String _baseUrl = 'https://api.flutterwave.com/v3';

//   // Your Flutterwave secret key
//   static const String _secretKey = 'YOUR_FLUTTERWAVE_SECRET_KEY';

//   // Headers for HTTP requests
//   static const Map<String, String> _headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $_secretKey',
//   };

//   // Create a sub-account
//   Future<void> createSubAccount(
//     String accountBank,
//     String accountNumber,
//     String businessName,
//     String businessEmail,
//     String businessContact,
//     String businessContactMobile,
//     String businessMobile,
//     String country,
//     String splitType,
//     int splitValue,
//   ) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/subaccounts'),
//       headers: _headers,
//       body: jsonEncode(<String, dynamic>{
//         'account_bank': accountBank,
//         'account_number': accountNumber,
//         'business_name': businessName,
//         'business_email': businessEmail,
//         'business_contact': businessContact,
//         'business_contact_mobile': businessContactMobile,
//         'business_mobile': businessMobile,
//         'country': country,
//         'split_type': splitType,
//         'split_value': splitValue,
//       }),
//     );

//     // Handle the response...
//   }

//   // Process a payment
//   Future<void> processPayment(
//     String txRef,
//     double amount,
//     String currency,
//     String paymentOption,
//     String customerEmail,
//     String customerPhoneNumber,
//     String customerName,
//     String subAccountId,
//     int transactionSplitRatio,
//   ) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/payments'),
//       headers: _headers,
//       body: jsonEncode(<String, dynamic>{
//         'tx_ref': txRef,
//         'amount': amount,
//         'currency': currency,
//         'payment_options': paymentOption,
//         'customer': {
//           'email': customerEmail,
//           'phonenumber': customerPhoneNumber,
//           'name': customerName,
//         },
//         'subaccounts': [
//           {
//             'id': subAccountId,
//             'transaction_split_ratio': transactionSplitRatio,
//           },
//         ],
//       }),
//     );

//     // Handle the response...
//   }
// }
