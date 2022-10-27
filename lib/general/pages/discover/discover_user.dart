import 'package:bars/general/pages/discover/seach/store_search.dart';
import 'package:bars/utilities/exports.dart';

class DiscoverUser extends StatefulWidget {
  final String currentUserId;
  final bool isWelcome;
  static final id = 'DiscoverUser';

  DiscoverUser({
    required this.currentUserId,
    required this.isWelcome,
  });

  @override
  _DiscoverUserState createState() => _DiscoverUserState();
}

class _DiscoverUserState extends State<DiscoverUser>
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
        length: 15,
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
                    height: Provider.of<UserData>(context, listen: false)
                            .showUsersTab
                        ? null
                        : 0.0,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          widget.isWelcome
                              ? Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.close),
                                          color: ConfigBloc().darkModeOn
                                              ? Colors.white
                                              : Colors.black,
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ConfigPage(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Don\'t miss out ',
                                            style: TextStyle(
                                                color: ConfigBloc().darkModeOn
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        color: Colors.blue,
                                        width: double.infinity,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              title: Text(
                                                  'We have put together some of the most talented music creatives for you. Explore, connect, and make history.',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  )),
                                              leading: IconButton(
                                                icon: Icon(Icons.info_outline),
                                                iconSize: 20.0,
                                                color: Colors.white,
                                                onPressed: () => () {},
                                              ),
                                            )))
                                  ],
                                )
                              : _locationTab(),
                          const SizedBox(height: 20),
                          TabBar(
                              labelColor: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: Colors.blue,
                              onTap: (int index) {
                                Provider.of<UserData>(context, listen: false)
                                    .setUsersTab(index);
                              },
                              unselectedLabelColor: Colors.grey,
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10.0),
                              indicatorWeight: 2.0,
                              isScrollable: true,
                              tabs: <Widget>[
                                const Text(
                                  'Artists',
                                ),
                                const Text(
                                  'Producers',
                                ),
                                const Text('Designers'),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Artist',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Producer',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Cover_Art_Designer',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Music_Video_Director',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'DJ',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Battle_Rapper',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Photographer',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Dancer',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Video_Vixen',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Makeup_Artist',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Record_Label',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Brand_Influencer',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'Blogger',
                ),
                Artists(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                  profileHandle: 'MC(Host)',
                ),
                Fans(
                  currentUserId: widget.currentUserId,
                  exploreLocation: '',
                ),
              ],
            )),
      ),
    );
  }
}

//display
class _locationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    final AccountHolder user =
        Provider.of<UserData>(context, listen: false).user!;
    // ignore: unnecessary_null_comparison
    return user == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
            child: FadeAnimation(
              1,
              Container(
                height: 35,
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: [
                            Row(
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.blue,
                                    side: BorderSide(
                                        width: 1.0, color: Colors.grey),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.search),
                                        iconSize: 25.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                        onPressed: () => Navigator.pushNamed(
                                            context, StoreSearch.id),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'Search',
                                          style: TextStyle(
                                            color: ConfigBloc().darkModeOn
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () => Navigator.pushNamed(
                                      context, StoreSearch.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
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
                                    currentUserId: currentUserId,
                                    user: user,
                                    type: 'Users',
                                  ),
                                ),
                              )),
                      const SizedBox(width: 20),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.blue,
                          side: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            user.city!.isEmpty
                                ? 'in Your City'
                                : 'In ' + user.city!,
                            style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        onPressed: () => user.city!.isEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NoCity(
                                    currentUserId: currentUserId,
                                    user: user,
                                  ),
                                ),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UsersLocation(
                                    locationType: 'City',
                                    currentUserId: currentUserId,
                                    user: user,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.blue,
                              side: BorderSide(width: 1.0, color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                user.country!.isEmpty
                                    ? 'In Your Country'
                                    : 'In ' + user.country!,
                                style: TextStyle(
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            onPressed: () => user.country!.isEmpty
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NoCity(
                                        currentUserId: currentUserId,
                                        user: user,
                                      ),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => UsersLocation(
                                        locationType: 'Country',
                                        currentUserId: currentUserId,
                                        user: user,
                                      ),
                                    ),
                                  )),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.blue,
                              side: BorderSide(width: 1.0, color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                user.continent!.isEmpty
                                    ? 'In Your Continent'
                                    : 'In ' + user.continent!,
                                style: TextStyle(
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            onPressed: () => user.continent!.isEmpty
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NoCity(
                                        currentUserId: currentUserId,
                                        user: user,
                                      ),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => UsersLocation(
                                        locationType: 'Continent',
                                        currentUserId: currentUserId,
                                        user: user,
                                      ),
                                    ),
                                  )),
                      ),
                    ]),
              ),
            ),
          );
  }
}
