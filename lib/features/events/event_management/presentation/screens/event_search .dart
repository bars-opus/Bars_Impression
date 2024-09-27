import 'package:bars/utilities/exports.dart';

class EventSearch extends StatefulWidget {
  static final id = 'EventSearch';
  final Future<List<DocumentSnapshot>>? events;
  final bool fromFlorence;

  EventSearch({required this.events, this.fromFlorence = false});

  @override
  _EventSearchState createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  Future<List<Post>> getEvents() async {
    List<DocumentSnapshot> documentSnapshots = await widget.events!;

    if (documentSnapshots.isEmpty) {
      return [];
    }

    return documentSnapshots.map((doc) {
      return Post.fromDoc(doc);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      color: widget.fromFlorence ? Colors.transparent : theme.primaryColorLight,
      child: widget.events == null
          ? Center(
              child: NoContents(
                  isFLorence: widget.fromFlorence,
                  textColor: widget.fromFlorence ? Colors.white : null,
                  title: "Searh for events. ",
                  subTitle: widget.fromFlorence
                      ? """
Enter the name or something about the event you are looking for and let\'s get right to it.

For instance:
1.  A vibrant dance event on this weekend.
2.  A business meetup happening around me.
                        """
                      : 'Enter event title.',
                  icon: null))
          : FutureBuilder<List<Post>>(
              future: getEvents(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                if (!snapshot.hasData) {
                  return widget.fromFlorence
                      ? Center(
                          child: Loading(
                            shakeReapeat: false,
                            color: Colors.white,
                            title: 'processing...',
                            icon: (FontAwesomeIcons.circle),
                          ),
                        )
                      : SearchUserSchimmer();
                }
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                            text: "No events found. ",
                            style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 20),
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey)),
                        TextSpan(text: '\nCheck title and try again.'),
                      ],
                      style: TextStyle(
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 14),
                          color: Colors.grey),
                    )),
                  );
                }
                return Padding(
                  padding:
                      EdgeInsets.only(top: widget.fromFlorence ? 10 : 30.0),
                  child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Post post = snapshot.data![index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1.0),
                                child: EventDisplayWidget(
                                  currentUserId: Provider.of<UserData>(context)
                                      .currentUserId!,
                                  post: post,
                                  postList: snapshot.data!,
                                  pageIndex: 0,
                                  eventSnapshot: [],
                                  eventPagesOnly: false,
                                  liveCity: '',
                                  liveCountry: '',
                                  // sortNumberOfDays: 0,
                                  isFrom: '',
                                ),
                              );
                            },
                            childCount: snapshot.data!.length,
                          ),
                        ),
                      ]),
                );
              }),
    );
  }
}
