import 'package:bars/utilities/exports.dart';

class EventPageLive extends StatefulWidget {
  static final id = 'EventPageLive';
  final String currentUserId;
  final String liveCity;
  final String liveCountry;
  final AccountHolder user;
  EventPageLive(
      {required this.currentUserId,
      required this.liveCity,
      required this.liveCountry,
      required this.user});

  @override
  _EventPageLiveState createState() => _EventPageLiveState();
}

class _EventPageLiveState extends State<EventPageLive>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  _pop() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

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
              leading: IconButton(
                icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                onPressed: _pop,
              ),
              backgroundColor:
                  ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
              centerTitle: true,
              title: Text(
                'Events In ${widget.liveCity}',
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
                EventsAllLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: widget.liveCity,
                  liveCountry: widget.liveCountry,
                ),
                FestivalEventsLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: widget.liveCity,
                  liveCountry: widget.liveCountry,
                ),
                AwardEventsLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: widget.liveCity,
                  liveCountry: widget.liveCountry,
                ),
                ToursEventsLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: widget.liveCity,
                  liveCountry: widget.liveCountry,
                ),
                AlbumLaunchesLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: widget.liveCity,
                  liveCountry: widget.liveCountry,
                ),
                OtherEventsLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: widget.liveCity,
                  liveCountry: widget.liveCountry,
                ),
              ],
            )),
      ),
    );
  }
}
