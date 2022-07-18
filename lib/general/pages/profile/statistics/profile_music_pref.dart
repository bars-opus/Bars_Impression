import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class ProfileMusicPref extends StatefulWidget {
  final String currentUserId;
  final AccountHolder user;
  ProfileMusicPref({
    required this.user,
    required this.currentUserId,
  });

  @override
  _ProfileMusicPrefState createState() => _ProfileMusicPrefState();
}

class _ProfileMusicPrefState extends State<ProfileMusicPref> {
  int _artistCount = 0;
  int _songCount = 0;
  int _albumCount = 0;

  void initState() {
    super.initState();
    _setUpArtistCount();
    _setUpSongCount();
    _setUpAlbumCount();
  }

  _setUpArtistCount() async {
    DatabaseService.numFavoriteArtist(widget.user.favouriteArtist!)
        .listen((artistCount) {
      if (mounted) {
        setState(() {
          _artistCount = artistCount;
        });
      }
    });
  }

  _setUpSongCount() async {
    DatabaseService.numSongs(widget.user.favouriteSong!).listen((songCount) {
      if (mounted) {
        setState(() {
          _songCount = songCount;
        });
      }
    });
  }

  _setUpAlbumCount() async {
    DatabaseService.numAlbums(widget.user.favouriteAlbum!).listen((albumCount) {
      if (mounted) {
        setState(() {
          _albumCount = albumCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          title: Material(
            color: Colors.transparent,
            child: Text(
              'Music Preference',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.user.favouriteArtist!.isEmpty
                    ? Container(
                        height: width / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () => widget.user.id !=
                                    Provider.of<UserData>(context,
                                            listen: false)
                                        .currentUserId
                                ? () {}
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditProfileMusicPref(
                                        user: widget.user,
                                      ),
                                    )),
                            child: RichText(
                              textScaleFactor: MediaQuery.of(context)
                                  .textScaleFactor
                                  .clamp(0.5, 1.5),
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'NO',
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: widget.user.id !=
                                                Provider.of<UserData>(context)
                                                    .currentUserId
                                            ? Colors.grey
                                            : Colors.blue,
                                      )),
                                  TextSpan(
                                      text: "\nFavorite Artist Listed.\n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text:
                                          "You can list your favorite artist \n so others can know the type of music you listen to \n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: width / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => FavoriteArtists(
                                          currentUserId: widget.currentUserId,
                                          artist: widget.user.favouriteArtist!,
                                          user: widget.user,
                                          artistFavoriteCount: _artistCount,
                                        ))),
                            child: RichText(
                              textScaleFactor: MediaQuery.of(context)
                                  .textScaleFactor
                                  .clamp(0.5, 1.5),
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: NumberFormat.compact()
                                          .format(_artistCount),
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      )),
                                  TextSpan(
                                      text:
                                          "\nPeople listed \n${widget.user.favouriteArtist}\n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text: " as their favorite artist \n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                widget.user.favouriteSong!.isEmpty
                    ? Container(
                        height: width / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () => widget.user.id !=
                                    Provider.of<UserData>(context,
                                            listen: false)
                                        .currentUserId
                                ? () {}
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditProfileMusicPref(
                                        user: widget.user,
                                      ),
                                    )),
                            child: RichText(
                              textScaleFactor: MediaQuery.of(context)
                                  .textScaleFactor
                                  .clamp(0.5, 1.5),
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'NO',
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: widget.user.id !=
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .currentUserId
                                            ? Colors.grey
                                            : Colors.blue,
                                      )),
                                  TextSpan(
                                      text: "\nFavorite Song Listed.\n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text:
                                          "You can list your favorite song \n so others can know the type of music you listen to \n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: width / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => FavoriteSong(
                                          currentUserId: widget.currentUserId,
                                          song: widget.user.favouriteSong!,
                                          user: widget.user,
                                        ))),
                            child: RichText(
                              textScaleFactor: MediaQuery.of(context)
                                  .textScaleFactor
                                  .clamp(0.5, 1.5),
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: NumberFormat.compact()
                                          .format(_songCount),
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      )),
                                  TextSpan(
                                      text:
                                          "\nPeople listed \n${widget.user.favouriteSong}\n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text: " as their favorite song \n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                widget.user.favouriteAlbum!.isEmpty
                    ? Container(
                        height: width / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () => widget.user.id !=
                                    Provider.of<UserData>(context,
                                            listen: false)
                                        .currentUserId
                                ? () {}
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditProfileMusicPref(
                                        user: widget.user,
                                      ),
                                    )),
                            child: RichText(
                              textScaleFactor: MediaQuery.of(context)
                                  .textScaleFactor
                                  .clamp(0.5, 1.5),
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'NO',
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: widget.user.id !=
                                                Provider.of<UserData>(context)
                                                    .currentUserId
                                            ? Colors.grey
                                            : Colors.blue,
                                      )),
                                  TextSpan(
                                      text: "\nFavorite Album Listed.\n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text:
                                          "You can list your favorite album \n so others can know the type of music you listen to \n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: width / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => FavoritAlbum(
                                          currentUserId: widget.currentUserId,
                                          album: widget.user.favouriteAlbum!,
                                          user: widget.user,
                                        ))),
                            child: RichText(
                              textScaleFactor: MediaQuery.of(context)
                                  .textScaleFactor
                                  .clamp(0.5, 1.5),
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: NumberFormat.compact()
                                          .format(_albumCount),
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      )),
                                  TextSpan(
                                      text:
                                          "\nPeople listed \n${widget.user.favouriteAlbum}\n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                  TextSpan(
                                      text: " as their favorite album \n",
                                      style: TextStyle(
                                        fontSize: width > 800 ? 18 : 14,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
