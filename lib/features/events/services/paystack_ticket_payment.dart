import 'package:bars/utilities/exports.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_functions/cloud_functions.dart';

class MakePayment {
  BuildContext context;
  int price;
  String email;
  String subaccountId;

  Event event;

  MakePayment({
    required this.context,
    required this.price,
    required this.email,
    required this.event,
    required this.subaccountId,
  }) {
    initialisePlugin();
  }

  PaystackPlugin payStack = PaystackPlugin();

  Future initialisePlugin() async {
    await payStack.initialize(publicKey: PayStackKey.PAYSTACK_KEY);
  }

  void _showBottomSheetErrorMessage(String error) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: "Request failed",
          subTitle: error,
        );
      },
    );
  }

  Future<PaymentResult> chargeCardAndMakePayMent() async {
    try {
      return await initialisePlugin().then((_) async {
        Charge charge = Charge()
          ..amount = price * 100
          ..email = email
          ..currency = "GHS"
          ..subAccount = subaccountId
          ..bearer = Bearer.SubAccount
          ..reference = _getReference();

        CheckoutResponse response = await payStack.checkout(
          context,
          charge: charge,
          method: CheckoutMethod.card,
          fullscreen: false,
          logo: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: CachedNetworkImageProvider(event.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

        if (response.status == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Transaction successful',
              overflow: TextOverflow.ellipsis,
            ),
          ));
          return PaymentResult(success: true, reference: response.reference!);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Transaction failed',
              overflow: TextOverflow.ellipsis,
            ),
          ));
          return PaymentResult(success: false, reference: response.reference!);
        }
      });
    } catch (e) {
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      _showBottomSheetErrorMessage(e.toString());
      return PaymentResult(success: false, reference: '');
    }
  }

  Future<void> initiatePaystackPayment(String email, int amount) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('initiatePaystackPayment');
    try {
      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'email': email,
        'amount': amount,
      });

      final String authorizationUrl = result.data['authorizationUrl'];

      if (await canLaunch(authorizationUrl)) {
        await launch(authorizationUrl);
      } else {
        throw 'Could not launch $authorizationUrl';
      }
    } on FirebaseFunctionsException catch (e) {
      // Handle the error from the Cloud Function
      throw Exception('Error initiating payment: ${e.message}');
    }
  }

  // Future<void> saveTokenToServer(String token) async {}
  String _getReference() {
    String commonId = Uuid().v4();
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_$commonId';
  }
}

class PaymentResult {
  final bool success;
  final String reference;

  PaymentResult({required this.success, required this.reference});
}
