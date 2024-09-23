import 'package:bars/utilities/exports.dart';

class ViewSentContent extends StatefulWidget {
  final String eventAuthorId;
  final String contentId;
  final String contentType;

  ViewSentContent({
    required this.contentType,
    required this.contentId,
    required this.eventAuthorId,
  });
  @override
  _ViewSentContentState createState() => _ViewSentContentState();
}

class _ViewSentContentState extends State<ViewSentContent> {
  @override
  Future<PaletteGenerator> _generatePalette(String imageUrl) async {
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(imageUrl, errorListener: (_) {
        return;
      }),
      size: Size(1110, 150),
      maximumColorCount: 20,
    );

    return _paletteGenerator;
  }

  _ticketOrderDeleted(String currentUserId, TicketOrderModel ticketOrder) {
    return Scaffold(
      body: EventDeletedMessageWidget(
        currentUserId: currentUserId,
        ticketOrder: ticketOrder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _provider = Provider.of<UserData>(context, listen: false);

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
        child: widget.contentType.startsWith('Event') ||
                widget.contentType.startsWith('Ask')
            ? FutureBuilder(
                future: DatabaseService.getUserEventWithId(
                    widget.contentId, widget.eventAuthorId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      width: width,
                      height: height,
                      color: Colors.black,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.blue,
                      )),
                    );
                  }
                  Event _event = snapshot.data;

                  return EventEnlargedScreen(
                    currentUserId: _provider.currentUserId!,
                    event: _event,
                    type: _event.type,
                    palette: null,
                    showPrivateEvent: true,
                    // marketedAffiliateId: widget.affiliateId,
                  );
                })
            : widget.contentType.startsWith('InviteRecieved')
                ? FutureBuilder<List<dynamic>>(
                    future: Future.wait([
                      DatabaseService.getUserEventWithId(
                          widget.contentId, widget.eventAuthorId),
                      DatabaseService.getEventIviteWithId(
                          _provider.currentUserId!, widget.contentId),
                      DatabaseService.getTicketWithId(
                          widget.contentId, _provider.currentUserId!),
                    ]),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          width: width,
                          height: height,
                          color: Colors.black,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ),
                        );
                      }

                      Event _event = snapshot.data![0];
                      InviteModel _invite = snapshot.data![1];

                      TicketOrderModel? _ticket = snapshot.data![2];

                      return FutureBuilder<PaletteGenerator>(
                        future: _generatePalette(_event.imageUrl),
                        builder: (BuildContext context,
                            AsyncSnapshot<PaletteGenerator> paletteSnapshot) {
                          if (!paletteSnapshot.hasData) {
                            return Container(
                              width: width,
                              height: height,
                              color: Colors.black,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              ),
                            );
                          }

                          PaletteGenerator _palette = paletteSnapshot.data!;

                          return EventInviteScreen(
                            currentUserId: _provider.currentUserId!,
                            event: _event,
                            invite: _invite,
                            palette: _palette,
                            ticketOrder: _ticket,
                          );
                        },
                      );
                    },
                  )
                : widget.contentType.startsWith('message')
                    ? FutureBuilder<List<dynamic>>(
                        future: Future.wait([
                          DatabaseService.getUserChatWithId(
                              _provider.currentUserId!, widget.contentId),
                          DatabaseService.getUserWithId(widget.contentId),
                        ]),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<dynamic>> snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              width: width,
                              height: height,
                              color: Colors.black,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              ),
                            );
                          }

                          Chat _chat = snapshot.data![0];
                          AccountHolderAuthor _user = snapshot.data![1];

                          return BottomModalSheetMessage(
                            currentUserId: _provider.currentUserId!,
                            user: null,
                            showAppbar: true,
                            userAuthor: _user,
                            chatLoaded: _chat,
                            userPortfolio: null,
                            userId: widget.contentId,
                          );
                        },
                      )
                    : widget.contentType.startsWith('eventRoom')
                        ? FutureBuilder<List<dynamic>>(
                            future: Future.wait([
                              DatabaseService.getEventRoomWithId(
                                  widget.contentId),
                              DatabaseService.getTicketIdWithId(
                                  widget.contentId, _provider.currentUserId!),
                            ]),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<dynamic>> snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data![0] == null ||
                                  snapshot.data![1] == null) {
                                return Container(
                                  width: width,
                                  height: height,
                                  color: Colors.black,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              }

                              EventRoom _eventRoom = snapshot.data![0];
                              TicketIdModel? ticketId = snapshot.data![1];
                              return FutureBuilder<PaletteGenerator>(
                                future: _generatePalette(_eventRoom.imageUrl),
                                builder: (BuildContext context,
                                    AsyncSnapshot<PaletteGenerator>
                                        paletteSnapshot) {
                                  if (!paletteSnapshot.hasData) {
                                    return Container(
                                      width: width,
                                      height: height,
                                      color: Colors.black,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    );
                                  }
                                  PaletteGenerator _palette =
                                      paletteSnapshot.data!;
                                  return EventRoomScreen(
                                    currentUserId: _provider.currentUserId!,
                                    room: _eventRoom,
                                    palette: _palette,
                                    ticketId: ticketId!,
                                  );
                                },
                              );
                            },
                          )
                        : widget.contentType.startsWith('refundProcessed')
                            ? FutureBuilder<List<dynamic>>(
                                future: Future.wait([
                                  DatabaseService.getUserTicketOrderWithId(
                                    widget.contentId,
                                    _provider.currentUserId!,
                                  ),
                                  DatabaseService.getUserEventWithId(
                                      widget.contentId, widget.eventAuthorId),
                                ]),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<dynamic>> snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.data![0] == null ||
                                      snapshot.data![1] == null) {
                                    return Container(
                                      width: width,
                                      height: height,
                                      color: Colors.black,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    );
                                  }

                                  TicketOrderModel _ticketOrder =
                                      snapshot.data![0];
                                  Event? event = snapshot.data![1];
                                  // RefundModel? newRefund;

                                  return FutureBuilder<PaletteGenerator>(
                                    future: _generatePalette(event!.imageUrl),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<PaletteGenerator>
                                            paletteSnapshot) {
                                      if (!paletteSnapshot.hasData) {
                                        return Container(
                                          width: width,
                                          height: height,
                                          color: Colors.black,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        );
                                      }
                                      PaletteGenerator _palette =
                                          paletteSnapshot.data!;
                                      return PurchasedAttendingTicketScreen(
                                        ticketOrder: _ticketOrder,
                                        event: event,
                                        currentUserId: _provider.currentUserId!,
                                        justPurchased: '',
                                        palette: _palette,
                                      );
                                    },
                                  );
                                },
                              )
                            : widget.contentType.startsWith('eventDeleted')
                                ? FutureBuilder(
                                    future: DatabaseService
                                        .getUserTicketOrderWithId(
                                      widget.contentId,
                                      _provider.currentUserId!,
                                    ),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container(
                                          width: width,
                                          height: height,
                                          color: Colors.black,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            color: Colors.blue,
                                          )),
                                        );
                                      }
                                      TicketOrderModel _ticketOrder =
                                          snapshot.data;

                                      return _ticketOrderDeleted(
                                          _provider.currentUserId!,
                                          _ticketOrder);
                                    })
                                : widget.contentType.startsWith('tag')
                                    ? FutureBuilder(
                                        future: DatabaseService.getUserTag(
                                          _provider.currentUserId!,
                                          widget.contentId,
                                        ),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (!snapshot.hasData) {
                                            return Container(
                                              width: width,
                                              height: height,
                                              color: Colors.black,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: Colors.blue,
                                              )),
                                            );
                                          }
                                          TaggedNotificationModel _tag =
                                              snapshot.data;

                                          return TagPage(
                                            currentUserId:
                                                _provider.currentUserId!,
                                            currentTag: _tag,
                                          );
                                        })
                                    : const SizedBox.shrink());
  }
}
