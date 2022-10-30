import 'package:bars/utilities/exports.dart';

class StoreSearchEvents extends StatefulWidget {
  static final id = 'StoreSearchEvents';

   final Future<QuerySnapshot>? events;

  StoreSearchEvents({required this.events});

  @override
  _StoreSearchEventsState createState() => _StoreSearchEventsState();
}

class _StoreSearchEventsState extends State<StoreSearchEvents> {
  _buildUserTile(Event event) {
    return EventView(
        currentUserId:
            Provider.of<UserData>(context, listen: false).currentUserId!,
        exploreLocation: 'No',
        feed: 1,
        user: Provider.of<UserData>(context, listen: false).user!,
        event: event);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
         
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Container(
                  // ignore: unnecessary_null_comparison
                  child: widget.events == null
                      ? Center(
                          child: NoContents(
                              title: "Searh for events. ",
                              subTitle: 'Enter event title.',
                              icon: Icons.event))
                      : FutureBuilder<QuerySnapshot>(
                          future: widget.events,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return EventSchimmer();
                            }
                            if (snapshot.data!.docs.length == 0) {
                              return Center(
                                child: RichText(
                                    text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "No events found. ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey)),
                                    TextSpan(
                                        text: '\nCheck title and try again.'),
                                  ],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Scrollbar(
                                child: CustomScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    slivers: [
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            Event? event = Event.fromDoc(
                                                snapshot.data!.docs[index]);
                                            return _buildUserTile(event);
                                          },
                                          childCount:
                                              snapshot.data!.docs.length,
                                        ),
                                      ),
                                    ]),
                              ),
                            );
                          })),
            ),
          )),
    );
  }
}
