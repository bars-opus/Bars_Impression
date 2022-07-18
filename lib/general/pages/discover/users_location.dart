import 'package:bars/utilities/exports.dart';

class UsersLocation extends StatefulWidget {
  final String currentUserId;
  final AccountHolder user;
  final String locationType;

  static final id = 'UsersLocation';

  UsersLocation({
    required this.currentUserId,
    required this.user,
    required this.locationType,
  });

  @override
  _UsersLocationState createState() => _UsersLocationState();
}

class _UsersLocationState extends State<UsersLocation> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: DefaultTabController(
        length: 15,
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
                    ? 'People In ${widget.user.city}'
                    : widget.locationType.startsWith('Country')
                        ? 'People In ${widget.user.country}'
                        : widget.locationType.startsWith('Continent')
                            ? 'People In ${widget.user.continent}'
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
                        .setUsersTab(index);
                  },
                  unselectedLabelColor: Colors.grey,
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                  indicatorWeight: 2.0,
                  isScrollable: true,
                  tabs: <Widget>[
                    const Text(
                      'Artists',
                    ),
                    const Text(
                      'Producers',
                    ),
                    const Text(
                      'Designers',
                    ),
                    const Text(
                      'Video Directors',
                    ),
                    const Text(
                      'Djs',
                    ),
                    const Text(
                      'Battle Rappers',
                    ),
                    const Text(
                      'Photographers',
                    ),
                    const Text(
                      'Dancers',
                    ),
                    const Text(
                      'Video Vixens',
                    ),
                    const Text(
                      'Makeup Artist',
                    ),
                    const Text(
                      'Record Labels',
                    ),
                    const Text(
                      'Brand Influncers',
                    ),
                    const Text(
                      'Bloggers',
                    ),
                    const Text(
                      'MC(Host)',
                    ),
                    const Text(
                      'Fans',
                    ),
                  ]),
            ),
            body: TabBarView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                ArtistsLocation(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  locationType: widget.locationType,
                ),
                ProducersLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                DesignersLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                VideoDirectorsLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                DjsLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                BattleRappersLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                PhotographersLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                DancersLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                VideoVixensLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                MakeUpArtistsLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                RecordLabelsLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                BrandInfluencersLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                BloggersLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                MCHostsLocation(
                  locationType: widget.locationType,
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                ),
                FansLocation(
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
