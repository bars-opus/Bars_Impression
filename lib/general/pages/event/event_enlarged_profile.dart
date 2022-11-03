import 'package:bars/utilities/exports.dart';

class AllEvenEnlargedProfile extends StatefulWidget {
  final String currentUserId;
  final Event event;
  final AccountHolder user;
  final int? askCount;
  final int feed;

  final String exploreLocation;

  AllEvenEnlargedProfile({
    required this.currentUserId,
    required this.user,
    required this.askCount,
    required this.exploreLocation,
    required this.feed,
    required this.event,
  });

  @override
  _AllEvenEnlargedProfileState createState() => _AllEvenEnlargedProfileState();
}

class _AllEvenEnlargedProfileState extends State<AllEvenEnlargedProfile> {
  _launchMap() {
    return MapsLauncher.launchQuery(widget.event.venue);
  }

  Future<void> _generatePalette(
    context,
  ) async {
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(widget.event.imageUrl),
      size: Size(1110, 150),
      maximumColorCount: 20,
    );

    widget.event.isPrivate
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AttendEvent(
                      event: widget.event,
                      currentUserId:
                          Provider.of<UserData>(context, listen: false)
                              .currentUserId!,
                      palette: _paletteGenerator,
                    )),
          )
        : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => EventPublicInviteAvailable(
                      event: widget.event,
                      palette: _paletteGenerator,
                      eventInvite: null,
                    )),

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (_) => AttendEvent(  eventInvite: null,
            //             event: widget.event,
            //             currentUserId: widget.currentUserId,
            //             palette: _paletteGenerator,
            //           )),
          );
  }

  Future<void> _generatePalette2(context, String from) async {
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(widget.event.imageUrl),
      size: Size(1110, 150),
      maximumColorCount: 20,
    );
    from.startsWith('People')
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => EventPeople(
                      event: widget.event,
                      palette: _paletteGenerator,
                    )),
          )
        : from.startsWith('Calendar')
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EventCalender(
                          event: widget.event,
                          palette: _paletteGenerator,
                        )),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EventRate(
                          event: widget.event,
                          palette: _paletteGenerator,
                        )),
              );
  }

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
                      currentUserId: widget.currentUserId,
                      askCount: widget.askCount!,
                      event: widget.event,
                      user: widget.user,
                    ),
                  );
                }));
          },
          child: Stack(
            children: [
              EventEnlargedWidget(
                onPressedAttend: () => _generatePalette(
                  context,
                ),
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
                              // user: widget.user,
                            ))),
                imageHero: 'image ${widget.event.id.toString()}',
                titleHero: 'title ${widget.event.id.toString()}',
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
                            event: widget.event,
                            ask: null,
                            currentUserId: widget.currentUserId,
                            askCount: widget.askCount!,
                          )),
                ),
                event: widget.event,
                onPressedCalendar: () => _generatePalette2(context, 'Calendar'),
                onPressedPeople: () => _generatePalette2(context, 'People'),
                onPressedRate: () => _generatePalette2(context, ''),
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
                        HapticFeedback.heavyImpact();
                        return FadeTransition(
                          opacity: animation,
                          child: ExploreEvent(
                            feed: widget.feed,
                            user: widget.user,
                            currentUserId: widget.currentUserId,
                            askCount: widget.askCount!,
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
