import 'package:bars/utilities/exports.dart';

class EventSearch extends StatefulWidget {
  static final id = 'EventSearch';

  final Future<QuerySnapshot>? events;

  EventSearch({required this.events});

  @override
  _EventSearchState createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  Future<List<Event>> getEvents() async {
    QuerySnapshot<Object?> querySnapshot = await widget.events!;

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    return querySnapshot.docs.map((doc) {
      return Event.fromDoc(doc);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColorLight,
      body: SafeArea(
        child: Container(
          color: theme.primaryColorLight,
          child: widget.events == null
              ? Center(
                  child: NoContents(
                      title: "Searh for events. ",
                      subTitle: 'Enter event title.',
                      icon: Icons.event_outlined))
              : FutureBuilder<List<Event>>(
                  future: getEvents(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Event>> snapshot) {
                    if (!snapshot.hasData) {
                      return SearchUserSchimmer();
                    }
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                                text: "No events found. ",
                                style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 20),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey)),
                            TextSpan(text: '\nCheck title and try again.'),
                          ],
                          style: TextStyle(fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14), color: Colors.grey),
                        )),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  Event event = snapshot.data![index];
                                  return EventDisplayWidget(
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId!,
                                    event: event,
                                    eventList: snapshot.data!,
                                    pageIndex: 0,
                                    eventSnapshot: [],
                                    eventPagesOnly: false,
                                    liveCity: '',
                                    liveCountry: '',
                                    sortNumberOfDays: 0,
                                    isFrom: '',
                                  );
                                },
                                childCount: snapshot.data!.length,
                              ),
                            ),
                          ]),
                    );
                  }),

          //  FutureBuilder<QuerySnapshot>(
          //     future: widget.events,
          //     builder: (BuildContext context,
          //         AsyncSnapshot<QuerySnapshot> snapshot)   {

          //       if (!snapshot.hasData) {
          //         return SearchUserSchimmer();
          //       }
          //       if (snapshot.data!.docs.length == 0) {
          //         return Center(
          //           child: RichText(
          //               text: TextSpan(
          //             children: [
          //               TextSpan(
          //                   text: "No events found. ",
          //                   style: TextStyle(
          //                       fontSize:  ResponsiveHelper.responsiveFontSize( context, 20),
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.blueGrey)),
          //               TextSpan(text: '\nCheck title and try again.'),
          //             ],
          //             style: TextStyle(fontSize: 14, color: Colors.grey),
          //           )),
          //         );
          //       }
          //       return Padding(
          //         padding: const EdgeInsets.only(top: 30.0),
          //         child: CustomScrollView(
          //             physics: const AlwaysScrollableScrollPhysics(),
          //             slivers: [
          //               SliverList(
          //                 delegate: SliverChildBuilderDelegate(
          //                   (context, index) {

          //                     Event? event = Event.fromDoc(
          //                         snapshot.data!.docs[index]);
          //                           List<Event> _events = await getEvents();
          //                     return EventDisplayWidget(
          //                       currentUserId:
          //                           Provider.of<UserData>(context)
          //                               .currentUserId!,
          //                       event: event,
          //                       eventList:_events,
          //                       pageIndex: 0,
          //                       eventSnapshot: [],
          //                       eventPagesOnly: false,
          //                       liveCity: '',
          //                       liveCountry: '',
          //                       sortNumberOfDays: 0,
          //                       isFrom: '',
          //                     );
          //                   },
          //                   childCount: snapshot.data!.docs.length,
          //                 ),
          //               ),
          //             ]),
          //       );
          //     })
        ),
      ),
    );
  }
}
