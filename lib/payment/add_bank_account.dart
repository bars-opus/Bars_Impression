import 'package:bars/utilities/exports.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateSubaccountForm extends StatefulWidget {
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
      };

      try {
        final HttpsCallableResult<dynamic> result =
            await createSubaccountCallable.call(
          subaccountData,
        );

        print('Full result data: ${result.data}');

        var subaccountId = result.data['subaccount_id'];
        print('Result data: $subaccountId');

        if (subaccountId != null && _user != null) {
          try {
            await usersLocationSettingsRef.doc(_user.userId).update({
              'subaccountId': subaccountId.toString(),
            });

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Subaccount created, continue with your event process.'),
            ));
            _updateAuthorHive(subaccountId.toString());
          } catch (e) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }

            // Log the error or use a debugger to inspect the error
            print('Error updating Firestore with subaccount ID: $e');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to update subaccount information'),
            ));
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          print('Result data: ${result.data}');
          print('User ID: ${_user?.userId}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Received invalid subaccount data'),
          ));
        }
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } on FirebaseFunctionsException catch (e) {
        print(e.code); // The error code ('unknown', 'unauthenticated', etc.)
        print(e.details);
        print(e.toString() + ' oooo');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create subaccount: ${e.message}'),
        ));
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        print(e.toString() + ' bbbb');

        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An unexpected error occurred'),
        ));
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  _updateAuthorHive(
    String subacccountId,
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
    );

    // Put the new object back into the box with the same key
    locationPreferenceBox.put(
        updatedLocationPreference.userId, updatedLocationPreference);
  }

  // void _submitForm(BuildContext context) async {
  //   FirebaseFunctions functions = FirebaseFunctions.instance;
  //   var createSubaccountCallable = functions.httpsCallable('createSubaccount');

  //   var _user =
  //       Provider.of<UserData>(context, listen: false).userLocationPreference;

  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();

  //     final bankCode = _selectedBankCode;

  //     if (bankCode == null || bankCode.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Please select a bank'),
  //       ));
  //       return;
  //     }

  //     // Ensure you collect the percentage charge properly
  //     final percentageCharge = 10; // Replace with your method/logic

  //     final subaccountData = {
  //       'business_name': _bussinessNameController.text.trim(),
  //       'bank_code': bankCode,
  //       'account_number': _accountNumber.text.trim(),
  //       'percentage_charge': percentageCharge,
  //     };

  //     try {
  //       final HttpsCallableResult<dynamic> result =
  //           await createSubaccountCallable.call(subaccountData);

  //       var subaccountId = result.data['subaccount_id'];

  //       if (subaccountId != null && _user != null) {
  //         await usersLocationSettingsRef.doc(_user.userId).update({
  //           'subaccount_id': subaccountId,
  //         });
  //         Navigator.pop(context);
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('Subaccount created: $subaccountId'),
  //         ));
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('Received invalid subaccount data'),
  //         ));
  //       }
  //     } on FirebaseFunctionsException catch (e) {
  //       print(e.toString() + ' oooo');
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Failed to create subaccount: ${e.message}'),
  //       ));
  //     } catch (e) {
  //       print(e.toString() + ' bbbb');

  //       print(e.toString());
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('An unexpected error occurred'),
  //       ));
  //     }
  //   }
  // }

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
      return banks;
    } else {
      throw Exception('Failed to load banks from Paystack');
    }
  }

  _saveButotn(VoidCallback onPressed, String text) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      width: double.infinity,
      height: 35,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.responsiveFontSize(context, 8.0),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _selectBank() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).cardColor,
      ),
      child: DropdownButtonFormField(
        isExpanded: true,
        hint: Text(
          'Select Bank',
          style: Theme.of(context).textTheme.bodyMedium,
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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: bank['code'],
          );
        }).toList(),
      ),
    );
    //  DropdownButtonFormField(
    //   isExpanded: true,
    //   hint: Text(
    //     'Select Bank',
    //     style: Theme.of(context).textTheme.bodyMedium,
    //     overflow: TextOverflow.ellipsis,
    //   ),
    //   value: _selectedBankCode,
    //   onChanged: (newValue) {
    //     setState(() {
    //       _selectedBankCode = newValue as String?;
    //     });
    //   },
    //   items: _banks.map((bank) {
    //     return DropdownMenuItem(
    //       child: Text(
    //         bank['name'],
    //         style: TextStyle(color: Colors.black),
    //       ),
    //       value: bank['code'],
    //     );
    //   }).toList(),
    // );
  }

  _ticketFiled(
    String labelText,
    String hintText,
    TextEditingController controler,
    TextInputType textInputType,
    final Function onValidateText,
  ) {
    var style = Theme.of(context).textTheme.titleSmall;
    var labelStyle = Theme.of(context).textTheme.bodyMedium;

    var hintStyle = TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        fontWeight: FontWeight.normal,
        color: Colors.grey);
    return TextFormField(
      controller: controler,
      keyboardAppearance: MediaQuery.of(context).platformBrightness,
      style: style,
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: labelStyle,
        hintStyle: hintStyle,
      ),
      validator: (string) => onValidateText(string),
    );
  }

  animateToPage(int index) {
    _pageController2.animateToPage(
      Provider.of<UserData>(context, listen: false).int1 + index,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorLight,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: PageView(
          controller: _pageController2,
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Payout \nAccount Information',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text:
                              "\n\nTo ensure you receive your earnings from ticket sales promptly, we require your bank account details. Your payouts will be processed securely through Paystack, a trusted payment platform that adheres to the highest levels of security compliance.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nDirect Deposits.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\n\nYour earnings from ticket sales will be securely deposited into the bank account you provide.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nPrivacy.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\n\nWe take your privacy seriously. Your bank details are encrypted and safely transmitted to our payment processors.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\nSecurity.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\n\nBars Impression uses advanced security protocols to protect your sensitive information and partners with leading financial institutions for secure processing.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n\n\n\nWe will issue your payout approximately 24 hours after the closing date of your event. Once the payout has been processed, you should receive the funds within 24 hours. ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n\n\n\nBy entering your bank account details, you agree to Bars Impression's ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "[Terms of Service](#) ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14.0),
                          ),
                        ),
                        TextSpan(
                          text:
                              "and acknowledge that this information is necessary for receiving your hosting payouts.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n\nShould you have any questions or require further clarification, please feel free to reach out to our support team at .",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "[support@example.com].",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (!_isLoading)
                    _saveButotn(() {
                      animateToPage(1);
                      // _submitForm(context);
                    }, 'Continue'),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    EditProfileInfo(
                      editTitle: 'Payout \nDetails',
                      info: '',
                      icon: Icons.payment_outlined,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        children: [
                          // const SizedBox(
                          //   height: 30,
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                _selectBank(),
                                _ticketFiled(
                                  'Account number',
                                  "00000000000000",
                                  _accountNumber,
                                  TextInputType.numberWithOptions(
                                      decimal: true),
                                  (input) => input!.trim().length < 10
                                      ? 'Please enter a valid bank account number'
                                      : null,
                                ),
                                _ticketFiled(
                                  'Business name',
                                  "The name of the business or individual for whom the account is being created.",
                                  _bussinessNameController,
                                  TextInputType.text,
                                  (input) => input!.trim().length < 1
                                      ? 'Enter a valid bank name'
                                      : null,
                                ),
                                // const SizedBox(
                                //   height: 60,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isLoading)
                      SizedBox(
                        height: 2,
                        child: LinearProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      ),
                    const SizedBox(
                      height: 60,
                    ),
                    if (!_isLoading)
                      _saveButotn(() {
                        _submitForm(context);
                      }, 'Submit'),
                    const SizedBox(
                      height: 80,
                    ),
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
