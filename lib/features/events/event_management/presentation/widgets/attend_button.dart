import 'package:bars/utilities/exports.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AttendButton extends StatefulWidget {
  final Event event;
  final String currentUserId;
  final bool fromFlyier;
  final String marketedAffiliateId;

  const AttendButton(
      {super.key,
      required this.event,
      required this.currentUserId,
      required this.marketedAffiliateId,
      required this.fromFlyier});

  @override
  State<AttendButton> createState() => _AttendButtonState();
}

class _AttendButtonState extends State<AttendButton> {
  bool _checkingTicketAvailability = false;

  _attendMethod() async {
    HapticFeedback.lightImpact();
    if (mounted) {
      setState(() {
        _checkingTicketAvailability = true;
      });
    }

    TicketOrderModel? _ticket = await DatabaseService.getTicketWithId(
        widget.event.id, widget.currentUserId);

    if (_ticket != null) {
      PaletteGenerator _paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(widget.event.imageUrl),
        size: Size(1110, 150),
        maximumColorCount: 20,
      );

      _navigateToPage(
        context,
        PurchasedAttendingTicketScreen(
          ticketOrder: _ticket,
          event: widget.event,
          currentUserId: widget.currentUserId,
          justPurchased: 'Already',
          palette: _paletteGenerator,
        ),
      );
      if (mounted) {
        setState(() {
          _checkingTicketAvailability = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _checkingTicketAvailability = false;
        });
        _showBottomSheetAttendOptions(context);
      }
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // Ticket options purchase entry
  void _showBottomSheetAttendOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          final width = MediaQuery.of(context).size.width;

          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 690),
            width: width,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TicketPurchasingIcon(
                    title: 'Ticket packages.',
                  ),
                ),
                // const SizedBox(height: 20),
                TicketGroup(
                  currentUserId: widget.currentUserId,
                  groupTickets: widget.event.ticket,
                  event: widget.event,
                  inviteReply: '',
                  onInvite: false,
                  // marketedAffiliateId: widget.marketedAffiliateId,
                ),
              ],
            ),
          );
        });
  }

  _validateAttempt() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _usercountry = _provider.userLocationPreference!.country;

    bool isGhanaian = _usercountry == 'Ghana' ||
        _provider.userLocationPreference!.currency == 'Ghana Cedi | GHS';

    if (!isGhanaian) {
      _showBottomSheetErrorMessage(
          'This event is currently unavailable in $_usercountry.', '');
    } else if (widget.event.termsAndConditions.isNotEmpty) {
      _showBottomSheetTermsAndConditions();
    } else {
      if (widget.event.ticketSite.isNotEmpty) {
        _showBottomSheetExternalLink();
      } else {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          // No internet connection
          _showBottomSheetErrorMessage('No Internet',
              'No internet connection available. Please connect to the internet and try again.');
          return;
        } else {
          _attendMethod();
        }
      }
    }
  }

  void _showBottomSheetExternalLink() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 550),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: WebDisclaimer(
              link: widget.event.ticketSite,
              contentType: 'Event ticket',
              icon: Icons.link,
            ));
      },
    );
  }

  void _showBottomSheetTermsAndConditions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height.toDouble() / 1.2,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TicketPurchasingIcon(
                        title: '',
                      ),
                      _checkingTicketAvailability
                          ? SizedBox(
                              height: ResponsiveHelper.responsiveHeight(
                                  context, 10.0),
                              width: ResponsiveHelper.responsiveHeight(
                                  context, 10.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.blue,
                              ),
                            )
                          : MiniCircularProgressButton(
                              color: Colors.blue,
                              text: 'Continue',
                              onPressed: widget.event.ticketSite.isNotEmpty
                                  ? () {
                                      Navigator.pop(context);
                                      _showBottomSheetExternalLink();
                                    }
                                  : () async {
                                      if (mounted) {
                                        setState(() {
                                          _checkingTicketAvailability = true;
                                        });
                                      }
                                      await _attendMethod();
                                      if (mounted) {
                                        setState(() {
                                          _checkingTicketAvailability = false;
                                        });
                                      }
                                    })
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text: "\n\n${widget.event.termsAndConditions}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _showBottomSheetErrorMessage(String title, String subTitle) {
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
          title: title,
          subTitle: subTitle,
        );
      },
    );
  }

  void _showBottomEditLocation(
    BuildContext context,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _userLocation = _provider.userLocationPreference;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 400,
          buttonText: 'set up city',
          onPressed: () async {
            Navigator.pop(context);
            _navigateToPage(
                context,
                EditProfileSelectLocation(
                  user: _userLocation!,
                  notFromEditProfile: true,
                ));
          },
          title: 'Set up your city',
          subTitle:
              'To proceed with purchasing a ticket, we kindly ask you to provide your country information. This allows us to handle ticket processing appropriately, as the process may vary depending on different countries. Please note that specifying your city is sufficient, and there is no need to provide your precise location or community details.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    var _usercountry = _provider.userLocationPreference!.country;

    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: ResponsiveHelper.responsiveWidth(context, 150.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: widget.fromFlyier ? Colors.white : Colors.blue,
                elevation: widget.fromFlyier ? 20.0 : 10,
                foregroundColor: widget.fromFlyier ? Colors.blue : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                )),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _checkingTicketAvailability
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: widget.fromFlyier ? Colors.blue : Colors.white,
                      ),
                    )
                  : Text(
                      'Attend',
                      style: TextStyle(
                        color: widget.fromFlyier ? Colors.black : Colors.white,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                      ),
                    ),
            ),
            onPressed: _usercountry!.isEmpty
                ? () {
                    widget.event.isFree
                        ? _attendMethod()
                        : _showBottomEditLocation(context);
                  }
                : _validateAttempt,
            //
            // !isGhanaian
            //         ? () {
            //             _showBottomSheetErrorMessage(
            //                 'This event is currently unavailable in your $_usercountry.',
            //                 '');
            //           }
            //         : widget.event.termsAndConditions.isNotEmpty
            //             ? () {
            //                 _showBottomSheetTermsAndConditions();
            //               }
            //             : () async {
            //                 widget.event.ticketSite.isNotEmpty
            //                     ? _showBottomSheetExternalLink()
            //                     : _attendMethod();
            //               },
          ),
        ));
  }
}
