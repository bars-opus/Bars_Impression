import 'package:bars/utilities/exports.dart';

class CreateAffiliate extends StatefulWidget {
  final Event event;
  final PaletteGenerator paletteColor;
  final String currentUserId;

  const CreateAffiliate({
    super.key,
    required this.event,
    required this.currentUserId,
    required this.paletteColor,
  });

  @override
  State<CreateAffiliate> createState() => _CreateAffiliateState();
}

class _CreateAffiliateState extends State<CreateAffiliate> {
  final _messageController = TextEditingController();
  final _termsController = TextEditingController();

  final _commissionController = TextEditingController();

  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  int selectedIndex = 0;

  @override
  void initState() {
    _commissionController.addListener(_onAskTextChanged);
    super.initState();
  }

  void _onAskTextChanged() {
    if (_commissionController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _commissionController.dispose();
    _messageController.dispose();
    _termsController.dispose();
  }

  void selectItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Map<String, dynamic>> optionData = [
    {
      'title': 'Candidate',
     
      'amount': 5,
      'index': 0,
    },
    {
      'title': 'Candidate',
      // 'subTitle': 'For job seekers',
      'amount': 10,
      'index': 0,
    },
    {
      'title': 'Clients',
      // 'subTitle': 'For recruitement companies',
      'amount': 15,
      'index': 1,
    },
    {
      'title': 'Franchise',
      // 'subTitle': 'For job partners',
      'amount': 20,
      'index': 2,
    },
    {
      'title': 'Internal Staff',
      // 'subTitle': 'For jobtion employees',
      'amount': 25,
      'index': 3,
    },
    {
      'title': 'Internal Staff',
      // 'subTitle': 'For jobtion employees',
      'amount': 30,
      'index': 3,
    },
  ];

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _example(int comission) {
    var _newComission = comission / 100;
    var _comission = 100 * _newComission;
    var _expetedAmount = 100 - _comission;

    return Column(
      children: [
        PayoutDataWidget(
          label: 'Comission',
          value: "${comission.toString()}%",
        ),
        PayoutDataWidget(
          label: 'Affiliate\'s payment',
          value: 'GHC ${_comission.toString()}',
        ),
        PayoutDataWidget(
          label: 'Organizer\'s\nTicket Payout',
          value: 'GHC ${_expetedAmount.toString()}',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    Color _paletteDark =
        Utils.getPaletteDarkMutedColor(widget.paletteColor, Color(0xFF1a1a1a));
    // Color _paletteDark = widget.palette == null
    //     ? Color(0xFF1a1a1a)
    //     : widget.palette!.darkMutedColor == null
    //         ? Color(0xFF1a1a1a)
    //         : widget.palette!.darkMutedColor!.color;
    return ValueListenableBuilder(
        valueListenable: _isTypingNotifier,
        builder: (BuildContext context, bool isTyping, Widget? child) {
          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 650),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(children: [
                  ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "You can create multiple affiliate deals with different influencers. For instance, you can start by offering a 10% commission, and later you can create a separate deal with a 25% commission for different influencers.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 40),
                  Container(
                    color: Colors.transparent,
                    height: ResponsiveHelper.responsiveHeight(context, 300),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      children: List.generate(optionData.length, (index) {
                        var data = optionData[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AffiliateCommissionOptions(
                            widget: Text("${data['amount'].toString()}%",
                                style: TextStyle(
                                    color: selectedIndex == index
                                        ? Colors.blue
                                        : Theme.of(context)
                                            .secondaryHeaderColor,
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context,
                                            selectedIndex == index ? 30 : 18),
                                    fontWeight: selectedIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                            onPressed: () {
                              selectItem(index);
                              _provider
                                  .setAffiliateComission(data['amount'] ?? 5);
                              HapticFeedback.lightImpact();
                              // double.parse(data['amount'] ?? 5.0));
                            },
                            title: data['title'],
                            // subTitle: data['subTitle'],
                            isSelected: selectedIndex == index,
                          ),
                        );
                      }),
                    ),
                  ),
                  Text(
                    "Comission break down on a single ticket sale of GHC 100 by an affiliate. (example)",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _example(_provider.affiliatecommission),
                  // UnderlinedTextField(
                  //   labelText: 'Commision',
                  //   hintText: 'We recommend not more than 30%',
                  //   controler: _commissionController,
                  //   isNumber: true,
                  //   onValidateText: () {},
                  // ),
                  const SizedBox(height: 20),
                  UnderlinedTextField(
                    labelText: 'Invite message',
                    hintText: 'Affiliate invitation messages',
                    controler: _messageController,
                    onValidateText: () {},
                    autofocus: false,
                  ),

                  const SizedBox(height: 10),
                  UnderlinedTextField(
                    labelText: 'Terms and conditions',
                    hintText:
                        'Govern relationship between organizer and affiliate',
                    controler: _termsController,
                    onValidateText: () {},
                    autofocus: false,
                  ),
                  const SizedBox(height: 70),
                  Center(
                    child: MiniCircularProgressButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToPage(
                            context,
                            AffiliateSearchScreen(
                              event: widget.event,
                              currentUserId: widget.currentUserId,
                              inviteMessage: _messageController.text.trim(),
                              paletteColor: _paletteDark,
                              commission:
                                  _provider.affiliatecommission.toDouble(),
                              termsAndCondition:
                                  _termsController.text.toString().trim(),
                            ));
                      },
                      text: "Continue",
                      color: Colors.blue,
                    ),
                  ),

                  // _ticketFiled(
                  //   'Invitation message',
                  //   'A special invitation message to your guests',
                  //   _messageController,
                  //   () {},
                  // ),
                  const SizedBox(height: 70),
                ]),
              ),
            ),
          );
        });
  }
}
