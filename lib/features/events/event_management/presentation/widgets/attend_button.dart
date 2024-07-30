import 'package:bars/utilities/exports.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AttendButton extends StatefulWidget {
  final Event event;
  final String currentUserId;
  final bool fromFlyier;
  final String marketedAffiliateId;
  final bool fromThisWeek;

  const AttendButton({
    super.key,
    required this.event,
    required this.currentUserId,
    required this.marketedAffiliateId,
    required this.fromFlyier,
    this.fromThisWeek = false,
  });

  @override
  State<AttendButton> createState() => _AttendButtonState();
}

class _AttendButtonState extends State<AttendButton> {
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
                    title: 'Tickets.',
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

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    var _usercountry = _provider.userLocationPreference!.country;

    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: widget.fromThisWeek
            ? Container(
                width: ResponsiveHelper.responsiveHeight(
                  context,
                  120,
                ),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(
                      width: 0.5,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Attend',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onPressed: widget.event.ticketSite.isNotEmpty
                      ? () {
                          _showBottomSheetExternalLink();
                        }
                      : () {
                          _showBottomSheetAttendOptions(context);
                        },
                ),
              )
            : Container(
                width: ResponsiveHelper.responsiveWidth(context, 150.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.fromFlyier ? Colors.white : Colors.blue,
                      elevation: widget.fromFlyier ? 20.0 : 10,
                      foregroundColor:
                          widget.fromFlyier ? Colors.blue : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Attend',
                      style: TextStyle(
                        color: widget.fromFlyier ? Colors.black : Colors.white,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                      ),
                    ),
                  ),
                  onPressed: widget.event.ticketSite.isNotEmpty
                      ? () {
                          _showBottomSheetExternalLink();
                        }
                      : () {
                          _showBottomSheetAttendOptions(context);
                        },
                ),
              ));
  }
}
