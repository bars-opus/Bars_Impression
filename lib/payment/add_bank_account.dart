import 'package:bars/utilities/exports.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateSubaccountForm extends StatefulWidget {
  final bool isEditing;

  const CreateSubaccountForm({super.key, required this.isEditing});

  @override
  _CreateSubaccountFormState createState() => _CreateSubaccountFormState();
}

class _CreateSubaccountFormState extends State<CreateSubaccountForm> {
  final _formKey = GlobalKey<FormState>();

  final _bussinessNameController = TextEditingController();
  final _accountNumber = TextEditingController();

  String bankCode = '';
  bool _isLoading = false;

  String? _selectedBankCode;
  List<dynamic> _banks = [];
  PageController _pageController2 = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    getBankList().then((banks) {
      if (mounted)
        setState(() {
          _banks = banks;
        });
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setInt1(0);
    });
  }

  void _submitForm(BuildContext context) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;
    var createSubaccountCallable = functions.httpsCallable(
      'createSubaccount',
    );

    var _user =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    if (_formKey.currentState!.validate() && !_isLoading) {
      _formKey.currentState!.save();

      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      final bankCode = _selectedBankCode;

      if (bankCode == null || bankCode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select a bank'),
        ));
        return;
      }

      // Ensure you collect the percentage charge properly
      final percentageCharge = 10; // Replace with your method/logic

      final subaccountData = {
        'business_name': _bussinessNameController.text.trim(),
        'bank_code': bankCode,
        'account_number': _accountNumber.text.trim(),
        'percentage_charge': percentageCharge,
        'currency': 'GHS',
        //  _user!.currency,
        'userId': _user!.userId
      };

      try {
        final HttpsCallableResult<dynamic> result =
            await createSubaccountCallable.call(
          subaccountData,
        );

        // print('Full result data: ${result.data}');

        var subaccountId = result.data['subaccount_id'];
        var transferRecepient = result.data['recipient_code'];

        // print('Result data: $result.data);

        if (subaccountId != null && _user != null) {
          try {
            await usersLocationSettingsRef.doc(_user.userId).update({
              'subaccountId': subaccountId.toString(),
              'transferRecepientId': transferRecepient.toString(),
            });

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Payout account created, continue with your event process.'),
            ));
            _updateAuthorHive(
                subaccountId.toString(), transferRecepient.toString());
          } catch (e) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }

            // Log the error or use a debugger to inspect the error
            // print('Error updating Firestore with subaccount ID: $e');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to create payout account'),
            ));
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Received invalid account data'),
          ));
        }
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } on FirebaseFunctionsException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create payout account'),
        ));
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An unexpected error occurred'),
        ));
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } finally {
        // Use finally to ensure _isLoading is set to false in both success and error scenarios
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // void _submitFormEdit(BuildContext context) async {
  //   FirebaseFunctions functions = FirebaseFunctions.instance;
  //   var createSubaccountCallable = functions.httpsCallable(
  //     'updateSubaccount',
  //   );

  //   var _user =
  //       Provider.of<UserData>(context, listen: false).userLocationPreference;

  //   if (_formKey.currentState!.validate() && !_isLoading) {
  //     _formKey.currentState!.save();

  //     if (mounted) {
  //       setState(() {
  //         _isLoading = true;
  //       });
  //     }

  //     final bankCode = _selectedBankCode;

  //     if (bankCode == null || bankCode.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Please select a bank'),
  //       ));
  //       return;
  //     }

  //     print(_user!.subaccountId.toString() +
  //         '    ' +
  //         _user.transferRecepientId.toString());
  //     // Ensure you collect the percentage charge properly
  //     final percentageCharge = 10; // Replace with your method/logic

  //     final subaccountData = {
  //       'business_name': _bussinessNameController.text.trim(),
  //       'bank_code': bankCode,
  //       'account_number': _accountNumber.text.trim(),
  //       'percentage_charge': percentageCharge,
  //       'currency': _user.currency,
  //       'userId': _user.userId,
  //       'oldSubaccountId': _user.subaccountId,
  //       'oldTransferRecepientId': _user.transferRecepientId,
  //     };

  //     try {
  //       final HttpsCallableResult<dynamic> result =
  //           await createSubaccountCallable.call(
  //         subaccountData,
  //       );

  //       // print('Full result data: ${result.data}');

  //       var subaccountId = result.data['subaccount_id'];
  //       var transferRecepient = result.data['recipient_code'];

  //       print('Result data: $result.data');
  //       print('Result data: $result');

  //       if (subaccountId != null && _user != null) {
  //         try {
  //           await usersLocationSettingsRef.doc(_user.userId).update({
  //             'subaccountId': subaccountId.toString(),
  //             'transferRecepientId': transferRecepient.toString(),
  //           });

  //           Navigator.pop(context);
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             content: Text('Payout account updated.'),
  //           ));
  //           _updateAuthorHive(
  //               subaccountId.toString(), transferRecepient.toString());
  //         } catch (e) {
  //           if (mounted) {
  //             setState(() {
  //               _isLoading = false;
  //             });
  //           }
  //           // print(e);

  //           // Log the error or use a debugger to inspect the error
  //           // print('Error updating Firestore with subaccount ID: $e');
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             content: Text('Failed to update payout account'),
  //           ));
  //         }
  //       } else {
  //         if (mounted) {
  //           setState(() {
  //             _isLoading = false;
  //           });
  //         }

  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('Received invalid subaccount data'),
  //         ));
  //       }
  //       if (mounted) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     } on FirebaseFunctionsException catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Failed to create subaccount: ${e.message}'),
  //       ));
  //       if (mounted) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('An unexpected error occurred'),
  //       ));
  //       if (mounted) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     } finally {
  //       // Use finally to ensure _isLoading is set to false in both success and error scenarios
  //       if (mounted) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     }
  //   }
  // }

  _updateAuthorHive(
    String subacccountId,
    String transferRecepient,
  ) async {
    Box<UserSettingsLoadingPreferenceModel> locationPreferenceBox;

    if (Hive.isBoxOpen('accountLocationPreference')) {
      locationPreferenceBox = Hive.box('accountLocationPreference');
    } else {
      locationPreferenceBox = await Hive.openBox('accountLocationPreference');
    }

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of UserSettingsLoadingPreferenceModel with the updated values
    var updatedLocationPreference = UserSettingsLoadingPreferenceModel(
      userId: _provider.userLocationPreference!.userId,
      city: _provider.userLocationPreference!.city,
      continent: _provider.userLocationPreference!.continent,
      country: _provider.userLocationPreference!.country,
      currency: _provider.userLocationPreference!.currency,
      timestamp: _provider.userLocationPreference!.timestamp,
      subaccountId: subacccountId,
      transferRecepientId: transferRecepient,
    );

    // Put the new object back into the box with the same key
    locationPreferenceBox.put(
        updatedLocationPreference.userId, updatedLocationPreference);
  }

  // Function to retrieve bank list from Paystack
  Future<List<dynamic>> getBankList() async {
    var _country = Provider.of<UserData>(context, listen: false)
        .userLocationPreference!
        .country;

    const String url = 'https://api.paystack.co/bank';
    const String paystackApiKey =
        PayStackKey.PAYSTACK_KEY; // Replace with your actual key

    final response = await http.get(
      Uri.parse(url).replace(queryParameters: {'country': _country}),
      headers: {
        'Authorization': 'Bearer $paystackApiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List banks = json.decode(response.body)['data'];

      // List of bank names to exclude
      const List<String> excludedBankNames = [
        'Absa Bank Ghana Ltd',
        'Ecobank Ghana Limited',
        'Bank of Ghana',
        'OmniBSCI Bank',
        'Société Générale Ghana Limited',
        'MTN',
        'Vodafone',
        'AirtelTigo',
      ];

      // Filter out the banks that should be excluded
      final filteredBanks = banks.where((bank) {
        return !excludedBankNames.contains(bank['name']);
      }).toList();
      // print(filteredBanks);
      return filteredBanks;
    } else {
      throw Exception('Failed to load banks from Paystack');
    }
  }
  // Future<List<dynamic>> getBankList() async {
  //   var _country = Provider.of<UserData>(context, listen: false)
  //       .userLocationPreference!
  //       .country;

  //   const String url = 'https://api.paystack.co/bank';
  //   const String paystackApiKey =
  //       PayStackKey.PAYSTACK_KEY; // Replace with your actual key

  //   final response = await http.get(
  //     Uri.parse(url).replace(queryParameters: {'country': _country}),
  //     headers: {
  //       'Authorization': 'Bearer $paystackApiKey',
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final List banks = json.decode(response.body)['data'];
  //     return banks;
  //   } else {
  //     throw Exception('Failed to load banks from Paystack');
  //   }
  // }

  // _saveButotn(VoidCallback onPressed, String text) {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 700),
  //     width: double.infinity,
  //     height: 35,
  //     child: ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.blue,
  //         elevation: 0.0,
  //         foregroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //       ),
  //       onPressed: onPressed,
  //       child: Padding(
  //         padding: EdgeInsets.all(
  //           ResponsiveHelper.responsiveFontSize(context, 8.0),
  //         ),
  //         child: Text(
  //           text,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  _selectBank() {
    //  Theme.of(context).textTheme.titleSmall;
    // var labelStyle = TextStyle(
    //     color: Colors.white,
    //     fontSize: ResponsiveHelper.responsiveFontSize(context, 14));
    // Theme.of(context).textTheme.bodyMedium;

    return ShakeTransition(
      curve: Curves.easeOutBack,
      duration: const Duration(seconds: 2),
      axis: Axis.vertical,
      offset: -140,
      child: DropdownButtonFormField(
        isExpanded: true,
        elevation: 0,
        dropdownColor: Colors.white,
        // style: labelStyle,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.grey)),
        ),
        hint: Text(
          'Select Bank',
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14)),
          overflow: TextOverflow.ellipsis,
        ),
        value: _selectedBankCode,
        onChanged: (newValue) {
          setState(() {
            _selectedBankCode = newValue as String?;
          });
        },
        items: _banks.map((bank) {
          return DropdownMenuItem(
            child: Text(
              bank['name'],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14)),
            ),
            value: bank['code'],
          );
        }).toList(),
      ),
    );
  }

  _ticketFiled(
    String labelText,
    String hintText,
    TextEditingController controler,
    TextInputType textInputType,
    final Function onValidateText,
  ) {
    var style = TextStyle(
        color: Colors.black,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 12));
    //  Theme.of(context).textTheme.titleSmall;
    var labelStyle = TextStyle(
        color: Colors.grey,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14));
    // Theme.of(context).textTheme.bodyMedium;

    var hintStyle = TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        fontWeight: FontWeight.normal,
        color: Colors.grey);
    return ShakeTransition(
      curve: Curves.easeOutBack,
      duration: const Duration(seconds: 2),
      axis: Axis.vertical,
      offset: -140,
      child: TextFormField(
        controller: controler,
        keyboardAppearance: MediaQuery.of(context).platformBrightness,
        style: style,
        keyboardType: textInputType,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
        ),
        validator: (string) => onValidateText(string),
      ),
    );
  }

  animateToPage(int index) async {
    _pageController2.animateToPage(
      index,
      duration: Duration(milliseconds: 900),
      curve: Curves.easeInOut,
    );

    Provider.of<UserData>(context, listen: false).setInt1(index);
    // print(index);
  }

  Future<void> _sendMail(String email, BuildContext context) async {
    String url = 'mailto:$email';
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      mySnackBar(context, 'Could not launch mail');
    }
  }

  // Color(0xFF374594),
  // Color(0xFFBFE4EC),

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );

    var bodyLarge = TextStyle(
      color: _provider.int1 == 1 ? Color(0xFF1a1a1a) : Colors.white,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 16),
      fontWeight: FontWeight.bold,
    );

    //  Theme.of(context).textTheme.bodyLarge;
    //  Theme.of(context).textTheme.titleSmall;
    var bodyMedium = TextStyle(
        color: _provider.int1 == 1 ? Color(0xFF1a1a1a) : Colors.white,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14));

    double _progress =
        _pageController2.hasClients ? _pageController2.page ?? 0 : 0;

    var _user =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Color(0xFF1a1a1a),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: PageView(
          controller: _pageController2,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // const SizedBox(
                //   height: 20,
                // ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  height: ResponsiveHelper.responsiveHeight(context, 700),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(30.0),
                  //     topRight: Radius.circular(30.0),
                  //   ),
                  //   // BorderRadius.circular(30),
                  // color: _provider.int1 == 1
                  //     ? Color(0xFF1a1a1a)
                  //       : Color(0xFF1a1a1a),
                  // ),
                  child: ListView(
                    children: <Widget>[
                      // const SizedBox(height: 60),
                      Center(
                        child: Icon(
                          MdiIcons.transfer,
                          color: Colors.white,
                          size: ResponsiveHelper.responsiveHeight(context, 40),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: ShakeTransition(
                          child: Text(
                            'Payout account information\nfor ticket sales',
                            style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 20),
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Center(
                          child: Container(
                            width: 50,
                            height: 1,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            // TextSpan(
                            //   text: '\nPayout Account \nInformation',
                            //   style: Theme.of(context).textTheme.titleLarge,
                            // ),
                            TextSpan(
                              text:
                                  "To ensure you receive your earnings from ticket sales promptly, we require your bank account details. Your payouts will be processed securely through Paystack, a trusted payment platform that adheres to the highest levels of security compliance.",
                              style: bodyMedium,
                            ),
                            TextSpan(
                              text: "\n\nDirect Deposits.",
                              style: bodyLarge,
                            ),
                            TextSpan(
                              text:
                                  "\nYour earnings from ticket sales will be securely deposited into the bank account you provide.",
                              style: bodyMedium,
                            ),
                            TextSpan(
                              text: "\n\nPrivacy.",
                              style: bodyLarge,
                            ),
                            TextSpan(
                              text:
                                  "\nWe take your privacy seriously. Your bank details are encrypted and safely transmitted to our payment processors.",
                              style: bodyMedium,
                            ),
                            TextSpan(
                              text: "\n\nSecurity.",
                              style: bodyLarge,
                            ),
                            TextSpan(
                              text:
                                  "\nBars Impression partners with leading financial institutions for secure processing.",
                              style: bodyMedium,
                            ),

                            TextSpan(
                              text:
                                  "\n\nWe will process your payout approximately 48 hours after the closing date of your event. Once the payout has been processed, you should receive the funds within 24 hours. \n\nYou must request the payout yourself. A 'Request Payout' button will appear on your event dashboard after the closing day of your event. You can use this button to request the payout",
                              style: bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!await launchUrl(Uri.parse(
                              'https://www.barsopus.com/terms-of-use'))) {
                            throw 'Could not launch link';
                          }
                        },
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "\n\nBy entering your bank account details, you agree to Bars Impression's ",
                                style: bodyMedium,
                              ),
                              TextSpan(
                                text: "Terms of Service ",
                                style: TextStyle(
                                  color: _provider.int1 == 1
                                      ? Color(0xFF1a1a1a)
                                      : Colors.blue,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14.0),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "and acknowledge that this information is necessary for receiving your hosting payouts.",
                                style: bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _sendMail('support@barsopus.com', context);
                        },
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "\nShould you have any questions or require further clarification, please feel free to reach out to our support team at .",
                                style: bodyMedium,
                              ),
                              TextSpan(
                                text: "support@barsopus.com.",
                                style: TextStyle(
                                  color: _provider.int1 == 1
                                      ? Color(0xFF1a1a1a)
                                      : Colors.blue,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: _provider.int1 == 1 ? 0 : 40,
                          child: MiniCircularProgressButton(
                              // color: Colors.blue,
                              text: 'Continue',
                              onPressed: () {
                                animateToPage(1);
                              }),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // _saveButotn(() {
                      //   animateToPage(1);
                      //   // _submitForm(context);
                      // }, 'Continue'),
                    ],
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: ListView(
                  children: <Widget>[
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: Colors.red,
                    //       borderRadius: BorderRadius.circular(0)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Text(
                    //       'Please ensure that you add a bank account denominated in Ghanaian Cedis (GHS) for payout purposes. Our payment providers do not support payouts to foreign accounts, so it is important that your account is in Ghanaian Cedis and not in foreign currencies.',
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: ResponsiveHelper.responsiveHeight(
                    //               context, 12)),
                    //     ),
                    //   ),
                    // ),
                    // if (_isLoading)
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      height: 0 + _progress * 600,
                      // _provider.int1 == 1 ? 600 : 0,
                      curve: Curves.linearToEaseOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),

                        // BorderRadius.only(
                        //   // bottomLeft: Radius.circular(30.0),
                        //   topRight: Radius.circular(10.0),
                        // ),
                        color: Color(0xFFf2f2f2),
                      ),
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    MdiIcons.transfer,
                                    color: Color(0xFF1a1a1a),
                                    size: ResponsiveHelper.responsiveHeight(
                                        context, 30),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    _isLoading
                                        ? 'processing...'
                                        : widget.isEditing
                                            ? 'Edit \nPayout Account'
                                            : 'Add \nPayout Account',
                                    style: TextStyle(
                                        color: _isLoading
                                            ? Colors.blue
                                            : Color(0xFF1a1a1a),
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 14)),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 60),
                              const SizedBox(
                                height: 20,
                              ),
                              Divider(
                                thickness: .2,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ShakeTransition(
                                curve: Curves.easeOutBack,
                                duration: const Duration(seconds: 1),
                                axis: Axis.vertical,
                                offset: -140,
                                child: Text(
                                  'Only GHS acccount.',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          ResponsiveHelper.responsiveHeight(
                                              context, 16)),
                                ),
                              ),
                              ShakeTransition(
                                curve: Curves.easeOutBack,
                                axis: Axis.vertical,
                                offset: -140,
                                duration: const Duration(seconds: 2),
                                child: Text(
                                  '\nPlease ensure that you add a bank account denominated in Ghanaian Cedis (GHS) for payout purposes. Our payment providers do not support payouts to foreign accounts, so it is important that your account is in Ghanaian Cedis and not in foreign currencies.',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          ResponsiveHelper.responsiveHeight(
                                              context, 12)),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Divider(
                                thickness: .2,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              _selectBank(),
                              _ticketFiled(
                                'Account number',
                                "00000000000000",
                                _accountNumber,
                                TextInputType.numberWithOptions(decimal: true),
                                (input) => input!.trim().length < 10
                                    ? 'Please enter a valid bank account number'
                                    : null,
                              ),
                              _ticketFiled(
                                'Business name',
                                "The name of the business or individual.",
                                _bussinessNameController,
                                TextInputType.text,
                                (input) => input!.trim().length < 1
                                    ? 'Enter a valid bank name'
                                    : null,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (_accountNumber.text.trim().isNotEmpty &&
                        _bussinessNameController.text.trim().isNotEmpty &&
                        _selectedBankCode != null)
                      _isLoading
                          ? Center(
                              child: SizedBox(
                                height: ResponsiveHelper.responsiveHeight(
                                    context, 20.0),
                                width: ResponsiveHelper.responsiveHeight(
                                    context, 20.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          : Center(
                              child: MiniCircularProgressButton(
                                  color: Colors.blue,
                                  text: 'Submit',
                                  onPressed: () {
                                    // widget.isEditing ||
                                    //         _user!
                                    //             .transferRecepientId!.isNotEmpty
                                    //     ? _submitFormEdit(context)
                                    //     :

                                    _submitForm(context);
                                  }),
                            ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.only(
                    //       bottomLeft: Radius.circular(10.0),
                    //       // bottomRight: Radius.circular(30.0),
                    //     ),
                    //     color: Colors.transparent,
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const SizedBox(
                    //           height: 30,
                    //         ),

                    //         _selectBank(),
                    //         _ticketFiled(
                    //           'Account number',
                    //           "00000000000000",
                    //           _accountNumber,
                    //           TextInputType.numberWithOptions(decimal: true),
                    //           (input) => input!.trim().length < 10
                    //               ? 'Please enter a valid bank account number'
                    //               : null,
                    //         ),
                    //         _ticketFiled(
                    //           'Business name',
                    //           "The name of the business or individual.",
                    //           _bussinessNameController,
                    //           TextInputType.text,
                    //           (input) => input!.trim().length < 1
                    //               ? 'Enter a valid bank name'
                    //               : null,
                    //         ),
                    //         const SizedBox(
                    //           height: 30,
                    //         ),
                    //         // const SizedBox(
                    //         //   height: 60,
                    //         // ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // if (_isLoading)
                    // SizedBox(
                    //   height: 2,
                    //   child: LinearProgressIndicator(
                    //     backgroundColor: Theme.of(context).primaryColor,
                    //     valueColor: AlwaysStoppedAnimation(Colors.blue),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 60,
                    ),
                    // if (!_isLoading)
                    //   _saveButotn(() {
                    //     widget.isEditing
                    //         ? _submitFormEdit(context)
                    //         : _submitForm(context);
                    //   }, 'Submit'),
                    // const SizedBox(
                    //   height: 80,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
