import 'package:bars/utilities/exports.dart';

class AllEvenEnlargedProfile extends StatefulWidget {
  final String currentUserId;
  final Event event;
  final AccountHolder author;
  final AccountHolder user;
  final int? askCount;
  final int feed;
  final PaletteGenerator palette;

  final String exploreLocation;

  AllEvenEnlargedProfile(
      {required this.currentUserId,
      required this.user,
      required this.askCount,
      required this.exploreLocation,
      required this.feed,
      required this.event,
      required this.palette,
      required this.author});

  @override
  _AllEvenEnlargedProfileState createState() => _AllEvenEnlargedProfileState();
}

class _AllEvenEnlargedProfileState extends State<AllEvenEnlargedProfile> {
  _launchMap() {
    return MapsLauncher.launchQuery(widget.event.venue);
  }

  //  Future<void> _generatePalette(
  //   context,
  // ) async {
  //   PaletteGenerator _paletteGenerator =
  //       await PaletteGenerator.fromImageProvider(
  //     CachedNetworkImageProvider(widget.event.imageUrl),
  //     size: Size(1110, 150),
  //     maximumColorCount: 20,
  //   );
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => AllEvenEnlarged(
  //                 exploreLocation: widget.exploreLocation,
  //                 feed: widget.feed,
  //                 askCount: widget.askCount,
  //                 currentUserId: widget.currentUserId,
  //                 event: widget.event,
  //                 author: widget.author,
  //                 user: widget.user,
  //                 palette: _paletteGenerator,
  //                 // eventList: widget.eventList,
  //               )));
  // }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
        body: GestureDetector(
          onLongPress: () {
            Navigator.of(context).push(PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, animation, _) {
                  return FadeTransition(
                    opacity: animation,
                    child: ExploreEvent(
                      exploreLocation: widget.exploreLocation,
                      feed: widget.feed,
                      user: widget.author,
                      currentUserId: widget.currentUserId,
                      askCount: widget.askCount!,
                      author: widget.author,
                      event: widget.event,
                    ),
                  );
                }));
          },
          child: Stack(
            children: [
              EventEnlargedWidget(
                closeHero: 'close' + widget.event.id.toString(),
                onPressedEventEnlarged: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AllEvenEnlarged(
                              exploreLocation: widget.exploreLocation,
                              feed: widget.feed,
                              askCount: widget.askCount!,
                              currentUserId: widget.currentUserId,
                              event: widget.event,
                              author: widget.author,
                              user: widget.user,
                            ))),
                imageHero: 'image' + widget.event.id.toString(),
                titleHero: 'title' + widget.event.id.toString(),
                onPressedLocationMap: _launchMap,
                onPressedEventticketSite: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WebDisclaimer(
                          link: widget.event.ticketSite,
                          contentType: 'Event ticket'),
                    ),
                  );
                },
                onPressedPreviousEvent: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => WebDisclaimer(
                              contentType: 'Previous Event',
                              link: widget.event.previousEvent,
                            ))),
                onPressedAsk: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AsksScreen(
                            askCount: widget.askCount!,
                            event: widget.event,
                            author: widget.author,
                            ask: null,
                            currentUserId: widget.currentUserId, 
                          )),
                ),
                event: widget.event,
            ),
              Positioned(
                top: 55,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.center_focus_strong,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).push(PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, _) {
                        return FadeTransition(
                          opacity: animation,
                          child: ExploreEvent(
                            feed: widget.feed,
                            user: widget.user,
                            currentUserId: widget.currentUserId,
                            askCount: widget.askCount!,
                            author: widget.author,
                            event: widget.event,
                            exploreLocation: widget.exploreLocation,
                          ),
                        );
                      })),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
