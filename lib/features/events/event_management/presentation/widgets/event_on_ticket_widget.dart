import 'package:bars/utilities/exports.dart';

class EventOnTicketWidget extends StatelessWidget {
  final Event event;
  final String currentUserId;

  // final TicketModel? finalPurchasintgTicket;

  EventOnTicketWidget({
    required this.event,
    // required this.finalPurchasintgTicket,
    required this.currentUserId,
  });

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    String startDate = MyDateFormat.toDate(event.startDate.toDate());
    String _startDate = startDate.substring(0, startDate.length - 5);
    String clossingDay = MyDateFormat.toDate(event.clossingDay.toDate());
    String _clossingDay = clossingDay.substring(0, clossingDay.length - 5);
    var _textStyle2 = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Theme.of(context).secondaryHeaderColor,
    );
    var _textStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Colors.grey,
    );
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        ListTile(
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.blue,
            size: ResponsiveHelper.responsiveHeight(context, 18.0),
          ),
          title: Text(
            "     Tap to view event details",
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              color: Colors.blue,
            ),
          ),
        ),
        ListTile(
          onTap: () {
            _navigateToPage(
                context,
                EventEnlargedScreen(
                  currentUserId: currentUserId,
                  event: event,
                  type: event.type,
                  showPrivateEvent: true,
                ));
          },
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: CachedNetworkImageProvider(event.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              children: [
                TextSpan(
                  text: event.title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextSpan(
                  text: "\n\nStart date:  ",
                  style: _textStyle,
                ),
                TextSpan(
                  text: _startDate,
                  style: _textStyle2,
                ),
                TextSpan(
                  text: "\nEnd date:    ",
                  style: _textStyle,
                ),
                TextSpan(
                  text: _clossingDay,
                  style: _textStyle2,
                ),
                TextSpan(
                  text: "\nVenue:        ",
                  style: _textStyle,
                ),
                TextSpan(
                  text: event.venue,
                  style: _textStyle2,
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
