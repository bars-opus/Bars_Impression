import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class EventEnlargedScreen extends StatefulWidget {
  final String currentUserId;
  final String type;
  final Event event;
  final bool justCreated;
  final PaletteGenerator? palette;

  EventEnlargedScreen({
    required this.currentUserId,
    required this.event,
    required this.type,
    this.justCreated = false,
    this.palette,
  });

  @override
  State<EventEnlargedScreen> createState() => _EventEnlargedScreenState();
}

class _EventEnlargedScreenState extends State<EventEnlargedScreen>
    with AutomaticKeepAliveClientMixin {
  bool _displayImage = false;
  // bool _imageAnim = false;
  bool _displayReportWarning = false;
  // bool _warningAnim = false;
  // bool _isAsking = false;
  var _isVisible;
  bool _heartAnim = false;

  // int _askCount = 0;
  bool _isBlockedUser = false;

  late DateTime _date;
  // late DateTime _firstScheduleDateTime;
  late DateTime _closingDate;

  bool _eventHasStarted = false;
  bool _eventHasEnded = false;

  int _ticketSeat = 0;

  TextEditingController _askController = TextEditingController();
  // final _askController = TextEditingController();

  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  // late DateTime _toDaysDate;
  // int _different = 0;
  // double _ticketOptionPrice = 0;
  // double _optionIndex = 0;
  // Color _selectedTicketColor = Color.fromRGBO(33, 150, 243, 1);

  Timestamp _fristScheduleTime = Timestamp.now();
  double _fristTickePrice = 0;
  TicketModel? _fristTicke;

  int _selectedSeat = 0;
  int _selectedRow = 0;
  //  VideoPlayerController _controller;
  bool _isPlaying = true;
  bool _isLoadingDashboard = false;

  bool _isLoading = false;

  bool _checkingTicketAvailability = false;

  late ScrollController _hideButtonController;

  bool _showInfo = false;
  Color lightVibrantColor = Colors.white;
  late Color lightMutedColor;

  @override
  void initState() {
    super.initState();
    _setupIsBlockedUser();
    _countDown();
    // widget.justCreated ? () {} : _setUpAsks();
    _displayReportWarning = widget.event.report.isNotEmpty;
    _setUpTicket();
    _askController.addListener(_onAskTextChanged);
    _hideButtonController = new ScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).ticketList.clear();
    });

    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (mounted) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    _askController.dispose();
    _isTypingNotifier.dispose();
    super.dispose();
  }

  void _countDown() async {
    if (EventHasStarted.hasEventStarted(widget.event.startDate.toDate())) {
      if (mounted) {
        setState(() {
          _eventHasStarted = true;
        });
      }
    }

    if (EventHasStarted.hasEventEnded(widget.event.clossingDay.toDate())) {
      if (mounted) {
        setState(() {
          _eventHasEnded = true;
        });
      }
    }
  }

  _setUpTicket() {
    List<TicketModel> tickets = widget.event.ticket;
    if (tickets.isNotEmpty) {
      TicketModel firstTicket = tickets[0];
      if (mounted) {
        setState(() {
          _fristTickePrice = firstTicket.price;
        });
      }
    } else {}
  }

  void _onAskTextChanged() {
    if (_askController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.event.authorId,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
  }

  // _setUpAsks() async {
  //   DatabaseService.numAsks(widget.event.id).listen((askCount) {
  //     if (mounted) {
  //       setState(() {
  //         _askCount = askCount;
  //       });
  //     }
  //   });
  // }

  _setImage() async {
    HapticFeedback.heavyImpact();
    if (mounted) {
      setState(() {
        _displayImage = !_displayImage;
      });
    }
  }

  _launchMap() {
    return MapsLauncher.launchQuery(widget.event.venue);
  }

  _setContentWarning() {
    if (mounted) {
      setState(() {
        _displayReportWarning = false;
      });
    }
  }

// To display the people tagged in a post as performers, crew, sponsors or partners
  void _showBottomSheetTaggedPeople(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EventTaggedPeople(
          event: widget.event,
          isSponsor: false,
          showTagsOnImage: false,
        );
      },
    );
  }

  void _showBottomSheetPreviosEvent(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 400),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: WebDisclaimer(
            contentType: 'Previous Event', icon: Icons.play_arrow_outlined,
            link: widget.event.previousEvent,
            // event: widget.event,
            // isSponsor: false,
            // showTagsOnImage: false,
          ),
        );
      },
    );
  }

//Action Sheet to perform more actions
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EventBottomModalSheetActions(
          event: widget.event,
          currentUserId: widget.currentUserId,
          eventHasEnded: _eventHasEnded,
        );
      },
    );
  }

// Ticket options purchase entry
  void _showBottomSheetAttendOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          final width = MediaQuery.of(context).size.width;

          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 690),
            width: width,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TicketPurchasingIcon(
                    title: 'Ticket packages.',
                  ),
                ),
                // const SizedBox(height: 20),
                TicketGroup(
                  currentUserId: widget.currentUserId,
                  groupTickets: widget.event.ticket,
                  event: widget.event,
                  inviteReply: '',
                  onInvite: false,
                ),
              ],
            ),
          );
        });
  }

  _noSchedule() {
    return Container(
        height: ResponsiveHelper.responsiveHeight(context, 650.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NoContents(
                title: 'No Schedules',
                subTitle:
                    'The event organizer didn\'t provide schedules for this event. If you want to know more about the schedules and program lineup, you can',
                icon: Icons.watch_later_outlined),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _showBottomSheetAskMore(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30),
                child: Text(
                  'ask a question here',
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ));
  }

  // display event dates and schedules on calendar
  void _showBottomSheetCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return widget.event.schedule.isEmpty
            ? _noSchedule()
            : EventSheduleCalendar(
                event: widget.event,
                currentUserId: widget.currentUserId,
              );
      },
    );
  }

//display schedules and programe line ups
  void _showBottomSheetSchedules(BuildContext context) {
    List<Schedule> shedules = widget.event.schedule;
    List<Schedule> scheduleOptions = [];
    for (Schedule shedules in shedules) {
      Schedule sheduleOption = shedules;
      scheduleOptions.add(sheduleOption);
    }
    scheduleOptions
        .sort((a, b) => a.startTime.toDate().compareTo(b.startTime.toDate()));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return widget.event.schedule.isEmpty
            ? _noSchedule()
            : Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: ResponsiveHelper.responsiveHeight(context, 650),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(.3),
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 0.0),
                        child: ScheduleGroup(
                          from: 'Calendar',
                          schedules: widget.event.schedule,
                          isEditing: false,
                          eventOrganiserId: widget.event.authorId,
                          currentUserId: widget.currentUserId,
                        ),
                      ),
                    ),

                    // Padding(
                    //     padding:
                    //         const EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 0.0),
                    //     child: ListView.builder(
                    //       itemCount: scheduleOptions.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         Schedule schedule = scheduleOptions[index];

                    //         return ScheduleWidget(schedule: schedule, edit: false,);
                    //       },
                    //     )),
                  ),
                  Positioned(
                    top: 10,
                    child: TicketPurchasingIcon(
                      title: 'Schedules.',
                    ),
                  ),
                ],
              );
      },
    );
  }

  void _showBottomSheetEditAsk(
    Ask ask,
  ) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EditCommentContent(
            content: ask.content,
            newContentVaraible: '',
            contentType: 'Question',
            onPressedDelete: () {},
            onPressedSave: () {},
            onSavedText: (String) {},
          );
        });
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

//build ask question display
  _buildAsk(
    Ask ask,
  ) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
        child: DisplayAskAndReply(
          ask: ask,
          event: widget.event,
        ));

    // Authorview(
    //   report: ask.report,
    //   content: ask.content,
    //   timestamp: ask.timestamp,
    //   authorId: ask.authorId,
    //   profileHandle: ask.authorProfileHanlde,
    //   userName: ask.authorName,
    //   profileImageUrl: ask.authorProfileImageUrl,
    //   verified: ask.authorVerification.isEmpty,
    //   from: '',
    //   onPressedReport: isAuthor
    //       ? () {
    //           _showBottomSheetEditAsk(ask);
    //         }
    //       : () {
    //           _navigateToPage(
    //             context,
    //             ReportContentPage(
    //               contentId: ask.id,
    //               contentType: 'question',
    //               parentContentId: widget.event.id,
    //               repotedAuthorId: widget.event.authorId,
    //             ),
    //           );
    //         },
    //   onPressedReply: () {},
    //   onPressedSeeAllReplies: () {},
    //   isPostAuthor: false,
    // );
  }

  void _showBottomSheetErrorMessage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: 'Failed to send question.',
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  _buildAskTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return CommentContentField(
      controller: _askController,
      onSend: () {
        HapticFeedback.mediumImpact();

        final trimmedText = _askController.text.trim();
        if (trimmedText.isNotEmpty) {
          try {
            final currentUser =
                Provider.of<UserData>(context, listen: false).user!;
            DatabaseService.askAboutEvent(
              currentUserId: currentUserId!,
              user: currentUser,
              event: widget.event,
              reportConfirmed: '',
              ask: trimmedText,
            );
            _askController.clear();
          } catch (e) {
            _showBottomSheetErrorMessage();
          }
        }
      },
      hintText: 'Interested? Ask more...',
    );
  }

  //Ask more bottom model sheet to handle and display questions
  void _showBottomSheetAskMore(BuildContext context) async {
    bool _isAuthor = widget.currentUserId == widget.event.authorId;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ValueListenableBuilder(
          valueListenable: _isTypingNotifier,
          builder: (BuildContext context, bool isTyping, Widget? child) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                height: ResponsiveHelper.responsiveHeight(context, 630),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TicketPurchasingIcon(
                        // icon: Icons.payment,
                        title: '',
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: StreamBuilder(
                          stream: asksRef
                              .doc(widget.event.id)
                              .collection('eventAsks')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                height: MediaQuery.of(context)
                                            .size
                                            .height
                                            .toDouble() /
                                        1.7 +
                                    30,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            return snapshot.data.docs.length == 0
                                ? Container(
                                    height: ResponsiveHelper.responsiveHeight(
                                        context, 630),
                                    child: Center(
                                      child: NoContents(
                                        icon: (FontAwesomeIcons.question),
                                        title:
                                            '\nNo questions have been asked about this event yet.\n',
                                        subTitle: _isAuthor
                                            ? 'Questions asked about this event would appear here so you can answer them and provide more clarifications'
                                            : ' You can be the first to ask a question or share your thoughts and excitement about this upcoming event. Engage with others and make the event experience even more interactive!',
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: ResponsiveHelper.responsiveHeight(
                                        context, 630),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Scrollbar(
                                        child: CustomScrollView(
                                          slivers: [
                                            SliverList(
                                              delegate:
                                                  SliverChildBuilderDelegate(
                                                (context, index) {
                                                  Ask ask = Ask.fromDoc(snapshot
                                                      .data.docs[index]);
                                                  return _buildAsk(ask);
                                                },
                                                childCount:
                                                    snapshot.data.docs.length,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                      _buildAskTF(),
                      SizedBox(
                        height:
                            ResponsiveHelper.responsiveHeight(context, 10.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  // void _showBottomSheetAskMore(BuildContext context) async {
  //   bool _isAuthor = widget.currentUserId == widget.event.authorId;

  //   await showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return ValueListenableBuilder(
  //         valueListenable: _isTypingNotifier,
  //         builder: (BuildContext context, bool isTyping, Widget? child) {
  //           return GestureDetector(
  //             onTap: () => FocusScope.of(context).unfocus(),
  //             child: Container(
  //               height:
  //                   MediaQuery.of(context).size.height.toDouble() / 1.3 + 30,
  //               padding: EdgeInsets.only(
  //                 bottom: MediaQuery.of(context).viewInsets.bottom,
  //               ),
  //               decoration: BoxDecoration(
  //                   color: Theme.of(context).cardColor,
  //                   borderRadius: BorderRadius.circular(30)),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.max,
  //                   children: [
  //                     TicketPurchasingIcon(
  //                       // icon: Icons.payment,
  //                       title: '',
  //                     ),

  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     Expanded(
  //                       child: StreamBuilder(
  //                         stream: asksRef
  //                             .doc(widget.event.id)
  //                             .collection('eventAsks')
  //                             .orderBy('timestamp', descending: true)
  //                             .snapshots(),
  //                         builder:
  //                             (BuildContext context, AsyncSnapshot snapshot) {
  //                           if (!snapshot.hasData ||
  //                               snapshot.connectionState ==
  //                                   ConnectionState.waiting) {
  //                             return Container(
  //                                 height: MediaQuery.of(context)
  //                                             .size
  //                                             .height
  //                                             .toDouble() /
  //                                         1.7 +
  //                                     30,
  //                                 child: Center(
  //                                     child: CircularProgressIndicator()));
  //                           }
  //                           return snapshot.data.docs.length == 0
  //                               ? Container(
  //                                   height: MediaQuery.of(context)
  //                                               .size
  //                                               .height
  //                                               .toDouble() /
  //                                           1.7 +
  //                                       30,
  //                                   child: Center(
  //                                       child: NoContents(
  //                                     icon: (FontAwesomeIcons.question),
  //                                     title:
  //                                         '\nNo questions have been asked about this event yet.\n',
  //                                     subTitle: _isAuthor
  //                                         ? 'Questions asked about this event would appear here so you can answer them and provide more clarifications'
  //                                         : ' You can be the first to ask a question or share your thoughts and excitement about this upcoming event. Engage with others and make the event experience even more interactive!',
  //                                   )),
  //                                 )
  //                               : Container(
  //                                   height: MediaQuery.of(context)
  //                                               .size
  //                                               .height
  //                                               .toDouble() /
  //                                           1.7 +
  //                                       30,
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.only(top: 12.0),
  //                                     child: Scrollbar(
  //                                         child: CustomScrollView(slivers: [
  //                                       SliverList(
  //                                         delegate: SliverChildBuilderDelegate(
  //                                           (context, index) {
  //                                             Ask ask = Ask.fromDoc(
  //                                                 snapshot.data.docs[index]);
  //                                             return _buildAsk(
  //                                               ask,
  //                                             );
  //                                           },
  //                                           childCount:
  //                                               snapshot.data.docs.length,
  //                                         ),
  //                                       )
  //                                     ])),
  //                                   ),
  //                                 );
  //                         },
  //                       ),
  //                     ),
  //                     _buildAskTF(),
  //                     SizedBox(
  //                       height:
  //                           ResponsiveHelper.responsiveHeight(context, 10.0),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

// icon widgets for location, people tagged and more
  _accessIcons(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: ResponsiveHelper.responsiveHeight(context, 40.0),
        width: ResponsiveHelper.responsiveHeight(context, 40.0),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(.2),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Icon(
            icon,
            size: ResponsiveHelper.responsiveHeight(context, 30.0),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  List<String> usernames = <String>[
    "Artist",
    "Producer",
    "DJ",
    "Dancer",
    "Music_Video_Director",
    "Content_creator",
    "Photographer",
    "Record_Label",
    "Brand_Influencer",
    "Event_organiser",
    "Band",
    "Instrumentalist",
    "Cover_Art_Designer",
    "Makeup_Artist",
    "Video_Vixen",
    "Blogger",
    "MC(Host)",
    "Choire",
    "Battle_Rapper",
    "Fan",
  ];

  _toRoom(PaletteGenerator palette) async {
    EventRoom? room = await DatabaseService.getEventRoomWithId(widget.event.id);
    TicketIdModel? ticketId = await DatabaseService.getTicketIdWithId(
        widget.event.id, widget.currentUserId);

    if (room != null) {
      _navigateToPage(
          context,
          EventRoomScreen(
            currentUserId: widget.currentUserId,
            room: room,
            palette: palette,
            ticketId: ticketId!,
          ));
    } else {
      _showBottomSheetErrorMessage();
    }
  }

  _goToRoom(PaletteGenerator palette) async {
    try {
      if (_isLoading) return;
      _isLoading = true;

      _toRoom(palette);
    } catch (e) {
      _showBottomSheetErrorMessage();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _generatePalette(isDashBoard) async {
    if (_isLoading) return;
    if (_isLoadingDashboard) return;

    isDashBoard
        ? setState(() {
            _isLoadingDashboard = true;
          })
        : setState(() {
            _isLoading = true;
          });
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(widget.event.imageUrl),
      size: Size(1110, 150),
      maximumColorCount: 20,
    );

    isDashBoard
        ? setState(() {
            _isLoadingDashboard = false;
          })
        : setState(() {
            _isLoading = false;
          });
    isDashBoard
        ? _navigateToPage(
            context,
            EventDashboardScreen(
              // askCount: 0,
              currentUserId: widget.currentUserId,
              event: widget.event,
              palette: _paletteGenerator,
            ))
        : _goToRoom(_paletteGenerator);
  }

  _inviteonSummaryButton(
    String buttonText,
    VoidCallback onPressed,
  ) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          foregroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
          ),
          textAlign: TextAlign.center,
        ),
        onPressed: onPressed,
      ),
    );
  }

  _resourceSummaryInfo() {
    final width = MediaQuery.of(context).size.width;
    var _provider = Provider.of<UserData>(context, listen: false);
    return new Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          width: width,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(10, 10),
                  blurRadius: 10.0,
                  spreadRadius: 4.0,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                ShakeTransition(
                  duration: const Duration(seconds: 2),
                  child: Center(
                    child: Icon(
                      Icons.done,
                      size: ResponsiveHelper.responsiveHeight(context, 50.0),
                      color: Colors.grey,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Successful',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 40.0),
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 30,
                ),
                if (_provider.user != null)
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Dear  ${_provider.user!.userName} \n',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              'Your event: ${widget.event.title}, has been created successfully.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 40,
                ),
                RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Your \nExperience',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 20.0),
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      TextSpan(
                        text:
                            '\nWe prioritize providing an exceptional experience that will benefit you in managing this event. We are thrilled to support you throughout the event management process. As an organizer, you have access to a comprehensive set of resources to help you manage the event and engage with attendees effectively.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.justCreated || widget.palette != null
                        ? _navigateToPage(
                            context,
                            EventDashboardScreen(
                              // askCount: 0,
                              currentUserId: widget.currentUserId,
                              event: widget.event,
                              palette: widget.palette!,
                            ))
                        : _generatePalette(true);
                  },
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\n\nEvent Dashboard.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              '\nThe Event Dashboard is designed to assist you in managing attendees for this event. Within the dashboard, you\'ll find various tools that enable you to send invitations to potential attendees, monitor the number of expected attendees, and scan attendee tickets for validation',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: '\nAccess dashboard...',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.justCreated || widget.palette == null
                        ? _goToRoom(widget.palette!)
                        : _generatePalette(false);
                  },
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\n\nEvent Room',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              '\nAn event room fosters networking and interaction among attendees of a specific event. It creates a dedicated group for all event attendees to chat and connect with each other.  ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: '\nAccess room...',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\n\nReminders',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text:
                            '\nSeven days prior to the event, we will send daily reminders to attendees to ensure that they don\'t forget about the events.\n',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: '\n\nEvent Barcode',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text:
                            '\nThe event barcode makes it convenient for you to share this event with others. Simply take a screenshot of the barcode and place it at your desired location. Potential attendees can then scan the barcode to gain access to the event. It\'s a hassle-free way to promote and provide easy entry to the event.  ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: ShakeTransition(
                    duration: const Duration(seconds: 3),
                    child: QrImageView(
                      version: QrVersions.auto,
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.transparent,
                      data: widget.event.dynamicLink,
                      size: ResponsiveHelper.responsiveHeight(context, 200.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                _inviteonSummaryButton(
                  'Share link',
                  () async {
                    Share.share(widget.event.dynamicLink);
                  },
                ),
                _inviteonSummaryButton(
                  'Send to chats',
                  () {
                    _navigateToPage(
                        context,
                        SendToChats(
                          currentUserId: widget.currentUserId,
                          sendContentType: 'Event',
                          sendContentId: widget.event.id,
                          sendImageUrl: widget.event.imageUrl,
                          sendTitle: widget.event.title,
                        ));
                  },
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheetTermsAndConditions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height.toDouble() / 1.2,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TicketPurchasingIcon(
                        title: '',
                      ),
                      _checkingTicketAvailability
                          ? SizedBox(
                              height: ResponsiveHelper.responsiveHeight(
                                  context, 10.0),
                              width: ResponsiveHelper.responsiveHeight(
                                  context, 10.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                          : MiniCircularProgressButton(
                              color: Colors.blue,
                              text: 'Continue',
                              onPressed: () async {
                                if (mounted) {
                                  setState(() {
                                    _checkingTicketAvailability = true;
                                  });
                                }
                                await _attendMethod();
                                if (mounted) {
                                  setState(() {
                                    _checkingTicketAvailability = false;
                                  });
                                }
                              })
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text: "\n\n${widget.event.termsAndConditions}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  _attendMethod() async {
    HapticFeedback.lightImpact();
    if (mounted) {
      setState(() {
        _checkingTicketAvailability = true;
      });
    }

    TicketOrderModel? _ticket = await DatabaseService.getTicketWithId(
        widget.event.id, widget.currentUserId);

    if (_ticket != null) {
      PaletteGenerator _paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(widget.event.imageUrl),
        size: Size(1110, 150),
        maximumColorCount: 20,
      );

      _navigateToPage(
        context,
        PurchasedAttendingTicketScreen(
          ticketOrder: _ticket,
          event: widget.event,
          currentUserId: widget.currentUserId,
          justPurchased: 'Already',
          palette: _paletteGenerator,
        ),
      );
      if (mounted) {
        setState(() {
          _checkingTicketAvailability = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _checkingTicketAvailability = false;
        });
        _showBottomSheetAttendOptions(context);
      }
    }
  }

  _contentWidget() {
    // final width = MediaQuery.of(context).size.width;

    bool _isAuthor = widget.currentUserId == widget.event.authorId;

    final List<String> datePartition = widget.event.startDate == null
        ? MyDateFormat.toDate(DateTime.now()).split(" ")
        : MyDateFormat.toDate(widget.event.startDate.toDate()).split(" ");

    final List<String> timePartition = _fristScheduleTime == null
        ? MyDateFormat.toTime(DateTime.now()).split(" ")
        : MyDateFormat.toTime(_fristScheduleTime.toDate()).split(" ");

    final List<String> namePartition =
        widget.event.title.trim().replaceAll('\n', ' ').split(" ");
    var _titleStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 30.0),
      color: lightVibrantColor,
      fontWeight: FontWeight.bold,
    );
    var _dateAndTimeSmallStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      color: Colors.white,
      decoration:
          _eventHasEnded ? TextDecoration.lineThrough : TextDecoration.none,
    );
    var _dateAndTimeLargeStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
      color: Colors.white,
      fontWeight: FontWeight.bold,
      decoration:
          _eventHasEnded ? TextDecoration.lineThrough : TextDecoration.none,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isAuthor)
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: EventBottomButton(
                  onlyWhite: true,
                  buttonText:
                      _isLoadingDashboard ? 'Loading...' : 'Access Dashbord',
                  onPressed: () {
                    widget.palette == null
                        ? _generatePalette(true)
                        : _navigateToPage(
                            context,
                            EventDashboardScreen(
                              // askCount: _askCount,
                              currentUserId: widget.currentUserId,
                              event: widget.event,
                              palette: widget.palette!,
                            ));
                  },
                ),
              ),
            if (_isAuthor)
              EventBottomButton(
                onlyWhite: true,
                buttonText: _isLoading ? 'Loading...' : 'Access Room',
                onPressed: () {
                  widget.palette == null
                      ? _generatePalette(false)
                      : _goToRoom(widget.palette!);
                },
              ),
            if (_isAuthor)
              if (!_eventHasEnded)
                Padding(
                  padding:
                      EdgeInsets.only(bottom: widget.justCreated ? 100.0 : 30),
                  child: EventBottomButton(
                    onlyWhite: true,
                    buttonText: 'Edit event',
                    onPressed: () {
                      _navigateToPage(
                        context,
                        EditEventScreen(
                          currentUserId: widget.currentUserId,
                          event: widget.event,
                        ),
                      );
                    },
                  ),
                ),
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: namePartition[0].toUpperCase(),
                    style: _titleStyle,
                  ),
                  if (namePartition.length > 1)
                    TextSpan(
                        text: "\n${namePartition[1].toUpperCase()} ",
                        style: _titleStyle),
                  if (namePartition.length > 2)
                    TextSpan(
                        text: "\n${namePartition[2].toUpperCase()} ",
                        style: _titleStyle),
                  if (namePartition.length > 3)
                    TextSpan(
                        text: "${namePartition[3].toUpperCase()} ",
                        style: _titleStyle),
                  if (namePartition.length > 4)
                    TextSpan(
                        text: "${namePartition[4].toUpperCase()} ",
                        style: _titleStyle),
                  if (namePartition.length > 5)
                    TextSpan(
                        text: "${namePartition[5].toUpperCase()} ",
                        style: _titleStyle),
                  if (namePartition.length > 6)
                    TextSpan(
                        text: "${namePartition[6].toUpperCase()} ",
                        style: _titleStyle),
                  if (namePartition.length > 7)
                    TextSpan(
                        text: "${namePartition[7].toUpperCase()} ",
                        style: _titleStyle),
                  if (namePartition.length > 8)
                    TextSpan(
                        text: "${namePartition[8].toUpperCase()} ",
                        style: _titleStyle),
                  if (namePartition.length > 9)
                    TextSpan(
                        text: "${namePartition[9].toUpperCase()} ",
                        style: _titleStyle),
                  if (namePartition.length > 10)
                    TextSpan(
                        text: "${namePartition[10].toUpperCase()} ",
                        style: _titleStyle),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: ResponsiveHelper.responsiveWidth(context, 10.0),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "${widget.event.theme.trim().replaceAll('\n', ' ')}. \nThis event would take place at ${widget.event.address} ",
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
                  color: Colors.white,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveHelper.responsiveWidth(context, 20.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _showBottomSheetCalendar(context);
              },
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: datePartition[0].toUpperCase(),
                        style: _dateAndTimeSmallStyle),
                    if (datePartition.length > 1)
                      TextSpan(
                          text: "\n${datePartition[1].toUpperCase()} ",
                          style: _dateAndTimeSmallStyle),
                    if (datePartition.length > 2)
                      TextSpan(
                          text: "\n${datePartition[2].toUpperCase()} ",
                          style: _dateAndTimeLargeStyle),
                  ],
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 50,
                width: 1,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showBottomSheetSchedules(context);
              },
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: timePartition[0].toUpperCase(),
                        style: _dateAndTimeLargeStyle),
                    if (timePartition.length > 1)
                      TextSpan(
                          text: "\n${timePartition[1].toUpperCase()} ",
                          style: _dateAndTimeSmallStyle),
                    if (timePartition.length > 2)
                      TextSpan(
                          text: "\n${timePartition[2].toUpperCase()} ",
                          style: _dateAndTimeSmallStyle),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        if (!_isAuthor)
          if (!_eventHasEnded)
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: ResponsiveHelper.responsiveWidth(context, 150.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 20.0,
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _checkingTicketAvailability
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              'Attend',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 14.0),
                              ),
                            ),
                    ),
                    onPressed: widget.event.termsAndConditions.isNotEmpty
                        ? () {
                            _showBottomSheetTermsAndConditions();
                          }
                        : () async {
                            _attendMethod();
                          },
                  ),
                )),
        SizedBox(
          height: 5,
        ),
        Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Container(
              width: ResponsiveHelper.responsiveWidth(context, 150.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: BorderSide(width: 1.0, color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _isAuthor ? 'Questions' : 'Ask more',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                    ),
                  ),
                ),
                onPressed: () {
                  _showBottomSheetAskMore(context);
                },
              ),
            )),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _accessIcons(
              Icons.location_on,
              _launchMap,
            ),
            const SizedBox(
              width: 5,
            ),
            widget.event.taggedPeople.isEmpty
                ? const SizedBox.shrink()
                : _accessIcons(
                    Icons.people,
                    () {
                      _showBottomSheetTaggedPeople(context);
                    },
                  ),
            const SizedBox(
              width: 5,
            ),
            widget.event.previousEvent.isEmpty
                ? const SizedBox.shrink()
                : _accessIcons(
                    Icons.play_arrow_outlined,
                    () {
                      _showBottomSheetPreviosEvent(context);
                    },
                  ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        if (!_eventHasEnded)
          Center(
            child: Hero(
              tag: widget.event.id,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _navigateToPage(
                    context,
                    ExpandEventBarcodeScreen(
                      event: widget.event,
                    ),
                  );
                },
                child: QrImageView(
                  version: QrVersions.auto,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  data: widget.event.dynamicLink,
                  size: ResponsiveHelper.responsiveHeight(context, 50.0),
                ),
              ),
            ),
          ),
        if (!_isAuthor)
          if (!_eventHasEnded)
            _eventHasStarted
                ? Text('Ongiong...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                      color: Colors.blue,
                    ))
                : CountdownTimer(
                    split: 'Single',
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.white,
                    clossingDay: DateTime.now(),
                    startDate: widget.event.startDate.toDate(),
                  ),
        if (!_isAuthor)
          Text(
            widget.event.type,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              color: Colors.white,
              fontFamily: 'Bessita',
            ),
          ),
        if (!_isAuthor)
          SizedBox(
            height: ResponsiveHelper.responsiveWidth(context, 20.0),
          ),
        if (!_isAuthor || _eventHasEnded)
          GestureDetector(
            onTap: _eventHasEnded
                ? () {}
                : () {
                    _attendMethod();
                  },
            child: _eventHasEnded
                ? Text(
                    'Completed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 20.0),
                      color: Colors.white,
                    ),
                  )
                : _checkingTicketAvailability
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      )
                    : RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.event.isFree
                                  ? ''
                                  : "${widget.event.rate}:\n",
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12.0),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.event.isFree
                                  ? 'Free'
                                  : _fristTickePrice.toString(),
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 30.0),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
          ),
        if (_isAuthor && _eventHasEnded)
          Text(
            'Completed',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
              color: Colors.white,
            ),
          )
      ],
    );
  }

  _eventInfoBody() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: widget.justCreated
            ? ListView(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  _resourceSummaryInfo(),
                  _contentWidget(),
                  const SizedBox(
                    height: 200,
                  ),
                ],
              )
            : _contentWidget());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: _displayImage ? false : true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          _displayImage
              ? 'Tagged people'
              : widget.event.city + '   /     ' + widget.event.country,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
            color: Colors.white,
          ),
        ),
        actions: [
          _displayImage || _displayReportWarning
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: ResponsiveHelper.responsiveHeight(context, 30.0),
                  ),
                ),
        ],
      ),
      body: Stack(
        alignment: FractionalOffset.center,
        children: <Widget>[
          Container(
            height: height,
            width: double.infinity,
            child: BlurHash(
              hash: widget.event.blurHash.isEmpty
                  ? 'LpQ0aNRkM{M{~qWBayWB4nofj[j['
                  : widget.event.blurHash,
              imageFit: BoxFit.cover,
            ),
          ),
          GestureDetector(
              onLongPress: _setImage,
              child: Container(
                height: height,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.event.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.6),
                          Colors.black.withOpacity(.6),
                        ],
                      ),
                    ),
                    child: !_displayImage
                        ? SizedBox.shrink()
                        : EventTaggedPeople(
                            event: widget.event,
                            isSponsor: false,
                            showTagsOnImage: true,
                          )),
              )),
          _displayReportWarning
              ? ContentWarning(
                  imageUrl: widget.event.imageUrl,
                  onPressed: () {
                    _setContentWarning();
                  },
                  report: widget.event.report,
                )
              : _displayImage
                  ? SizedBox.shrink()
                  : _eventInfoBody(),
        ],
      ),
    );
  }
}
