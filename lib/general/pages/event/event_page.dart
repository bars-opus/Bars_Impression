import 'package:bars/utilities/exports.dart';

class EventPage extends StatefulWidget {
  static final id = 'EventPage';
  final String currentUserId;
  final AccountHolder user;
  EventPage({required this.currentUserId, required this.user});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  _locationTab() {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    // ignore: unnecessary_null_comparison
    return widget.user == null
        ? SizedBox.shrink()
        : FadeAnimation(
            1,
            Container(
              height: 35,
              width: width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 20),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.blue,
                          side: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            ' Virtual Events',
                            style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventPageLocation(
                                  locationType: 'Virtual',
                                  currentUserId: widget.currentUserId,
                                  user: widget.user,
                                ),
                              ),
                            )),
                    SizedBox(width: 20),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.blue,
                          side: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            ' In Live Location',
                            style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FetchingLocation(
                                  currentUserId: widget.currentUserId,
                                  user: widget.user,
                                  type: 'Events',
                                ),
                              ),
                            )),
                    SizedBox(width: 20),
                    Container(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.blue,
                            side: BorderSide(width: 1.0, color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              widget.user.country!.isEmpty
                                  ? 'In Your Country'
                                  : 'In ' + widget.user.country!,
                              style: TextStyle(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          onPressed: () => widget.user.country!.isEmpty
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NoCity(
                                      currentUserId: widget.currentUserId,
                                      user: widget.user,
                                    ),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventPageLocation(
                                      locationType: 'Country',
                                      currentUserId: widget.currentUserId,
                                      user: widget.user,
                                    ),
                                  ),
                                )),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: Provider.of<UserData>(
                      context,
                    ).showEventTab
                        ? null
                        : 0.0,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Platform.isIOS
                                    ? Icons.arrow_back_ios
                                    : Icons.arrow_back),
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(
                                ' Explore Events',
                                style: TextStyle(
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox()
                            ],
                          ),
                          _locationTab(),
                          const SizedBox(height: 20),
                          TabBar(
                              labelColor: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: Colors.blue,
                              onTap: (int index) {
                                Provider.of<UserData>(context, listen: false)
                                    .setEventTab(index);
                              },
                              unselectedLabelColor: Colors.grey,
                              isScrollable: true,
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10.0),
                              indicatorWeight: 2.0,
                              tabs: <Widget>[
                                const Text(
                                  'All',
                                ),
                                const Text(
                                  'Festival',
                                ),
                                const Text(
                                  'Award',
                                ),
                                const Text('Tour'),
                                const Text(
                                  'Album Launch',
                                ),
                                const Text(
                                  'Others',
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                EventsAll(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                FestivalEvents(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                AwardEvents(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                ToursEvents(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                AlbumLaunches(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                OtherEvents(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
              ],
            )),
      ),
    );
  }
}
