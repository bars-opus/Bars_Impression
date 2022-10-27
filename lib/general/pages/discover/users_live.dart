import 'package:bars/utilities/exports.dart';

class UserLive extends StatefulWidget {
  final String currentUserId;
  final AccountHolder user;
  final String liveCity;
  final String liveCountry;
  static final id = 'UserLive';

  UserLive({
    required this.currentUserId,
    required this.user,
    required this.liveCity,
    required this.liveCountry,
  });

  @override
  _UserLiveState createState() => _UserLiveState();
}

class _UserLiveState extends State<UserLive> {
  _pop() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
        child: DefaultTabController(
          length: 15,
          child: Scaffold(
              backgroundColor:
                  ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  onPressed: _pop,
                ),
                elevation: 0.0,
                iconTheme: new IconThemeData(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                ),
                backgroundColor:
                    ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
                centerTitle: true,
                title: Column(children: [
                  Text(
                    'People In ${widget.liveCity}',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20)
                ]),
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
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Artist',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Producer',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Cover_Art_Designer',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Music_Video_Director',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'DJ',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Battle_Rapper',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Photographer',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Dancer',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Video_Vixen',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Makeup_Artist',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Record_Label',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Brand_Influencer',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Blogger',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'MC(Host)',
                  ),
                  ArtistsLive(
                    currentUserId: widget.currentUserId,
                    liveCity: widget.liveCity,
                    liveCountry: widget.liveCountry,
                    exploreLocation: 'Live',
                    profileHandle: 'Fan',
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
