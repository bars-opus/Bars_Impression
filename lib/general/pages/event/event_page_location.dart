import 'package:bars/utilities/exports.dart';

class EventPageLocation extends StatefulWidget {
  static final id = 'EventPageLocation';
  final String currentUserId;
  final AccountHolder user;
  final String locationType;
  EventPageLocation(
      {required this.currentUserId,
      @required required this.locationType,
      required this.user});

  @override
  _EventPageLocationState createState() => _EventPageLocationState();
}

class _EventPageLocationState extends State<EventPageLocation>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
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
            appBar: AppBar(
              elevation: 0.0,
              iconTheme: new IconThemeData(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
              backgroundColor:
                  ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
              centerTitle: true,
              title: Text(
                widget.locationType.startsWith('City')
                    ? 'Events In ${widget.user.city}'
                    : widget.locationType.startsWith('Country')
                        ? 'Events In ${widget.user.country} '
                        : widget.locationType.startsWith('Virtual')
                            ? 'Virtual Events'
                            : '',
                style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              bottom: TabBar(
                  labelColor:
                      ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.blue,
                  onTap: (int index) {
                    Provider.of<UserData>(context, listen: false)
                        .setEventTab(index);
                  },
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
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
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                EventsAllLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                FestivalEventsLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                AwardEventsLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                ToursEventsLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                AlbumLaunchesLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                OtherEventsLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
              ],
            )),
      ),
    );
  }
}
