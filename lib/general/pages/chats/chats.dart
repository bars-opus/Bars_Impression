import 'package:bars/utilities/exports.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

// A user interface where we are handling different tabs, namely 'Chats' and 'Rooms'.
// There are also methods for showing bottom sheets for different actions like 'Search',
// 'Delete all chats', 'Leave all rooms', and 'Delete tickets'.
// This code is the state for a Chats widget that handles chat and event room functionality in the application.
// It makes use of several streams and futures to fetch data from a live backend,
//  which is a common approach for real-time chat applications.

class Chats extends StatefulWidget {
  static final id = 'Chats';
  final String currentUserId;
  final String? userId;
  Chats({
    required this.currentUserId,
    required this.userId,
  });

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late ScrollController _hideButtonController;
  late ScrollController _scrollController;

  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String query = "";
  final FocusNode _focusNode = FocusNode();
  late ConnectivityResult _connectivityStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _timer;
  Set<String> _activeListeners = {};
  List<StreamSubscription<DocumentSnapshot>> _subscriptions = [];

  Set<String> _activeChatListeners = Set<String>();
  List<StreamSubscription<DocumentSnapshot>> _chatSubscriptions = [];

  void initState() {
    super.initState();
    _initConnectivity();
    _timer = Timer.periodic(Duration(hours: 24), (_) {
      expireOldChats(Duration(days: 30));
      expireOldRooms(Duration(days: 30));
      expireOldTicketIds(Duration(days: 30));
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // _hideButtonController = new ScrollController();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _hideButtonController = ScrollController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    _tabController.dispose();
    _searchController.dispose();
    _connectivitySubscription?.cancel();
    _timer?.cancel();
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    for (var subscription in _chatSubscriptions) {
      subscription.cancel();
    }
    _activeListeners.clear();
    _activeChatListeners.clear();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult status;
    try {
      status = await _connectivity.checkConnectivity();
    } catch (e) {
      print("Error checking connectivity: $e");
      status = ConnectivityResult.none;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(status);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() => _connectivityStatus = result);
  }

  bool get wantKeepAlive => true;
  final _physycsNotifier = ValueNotifier<bool>(false);

  void _showModalBottomSheetAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CreateContent();
      },
    );
  }

  _addContentWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 2.0, 2.0, 2.0),
      child: GestureDetector(
        onTap: () {
          _showModalBottomSheetAdd(
            context,
          );
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Icon(
            size: ResponsiveHelper.responsiveHeight(context, 25),
            Icons.add,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
    );
  }

// These methods are responsible for clearing the search field.
  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
  }

  _cancelSearch() {
    FocusScope.of(context).unfocus();
    _clearSearch();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _notificationWidget() {
    var _provider = Provider.of<UserData>(context);
    return GestureDetector(
      onTap: () {
        _navigateToPage(
            context, NotificationPage(currentUserId: widget.currentUserId));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Icon(
                size: ResponsiveHelper.responsiveHeight(context, 25),
                Icons.notifications_active_outlined,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
          _provider.activityCount == 0
              ? SizedBox.shrink()
              : Positioned(
                  top: 0,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10),
                      child: Text(
                        NumberFormat.compact().format(_provider.activityCount),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  _buildNotification() {
    final width = MediaQuery.of(context).size.width;
    return Container(
        height: 60,
        width: width.toDouble(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('   Network',
                  style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 30.0),
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              width: 120,
              child: Row(
                children: [
                  _addContentWidget(),
                  _notificationWidget(),
                ],
              ),
            ),
          ],
        ));
  }

  //  The Chat model represents a chat thread or conversation between two users,
  //  while your ChatMessage model represents an individual message within that conversation.
  Widget _buildChatViewFromList({
    required List<Chat> chats,
    required String noContentMessage,
    required IconData noContentIcon,
    required String text,
    required Widget Function(BuildContext, int, Chat) itemBuilder,
  }) {
    return chats.isEmpty
        ? Center(
            child: NoContents(
              icon: noContentIcon,
              title: noContentMessage,
              subTitle: text,
            ),
          )
        : CustomScrollView(
            // controller: _hideButtonController,
            // physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => itemBuilder(context, index, chats[index]),
                  childCount: chats.length,
                ),
              ),
            ],
          );
  }

// imitChats(String chatId): This method is used to limit the number of chats associated with a
//specific chatId in the chats box to 30. If there are more than 30 chats, it deletes the oldest ones until there are only 30 left.
// Here's a breakdown:
// It opens the chats box which contains Chat objects.
// It filters the chats in the box to those that match the provided chatId and converts them to a list.
// If there are more than 30 chats, it sorts them in ascending order by their timestamp.
// It then deletes the oldest chats until only the 30 most recent ones remain.

  void limitChats() async {
    var box = await Hive.openBox<Chat>('chats');
    var chats = box.values.toList();

    if (chats.length > 30) {
      chats.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

      for (var i = 0; i < chats.length - 30; i++) {
        box.delete(chats[i].id);
      }
    }
  }

  void limitRooms() async {
    var box = await Hive.openBox<EventRoom>('eventRooms');
    var chats = box.values.toList();

    if (chats.length > 30) {
      chats.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

      for (var i = 0; i < chats.length - 30; i++) {
        box.delete(chats[i].id);
      }
    }
  }

  void limitTicketIds() async {
    var box = await Hive.openBox<TicketIdModel>('ticketIds');
    var chats = box.values.toList();

    if (chats.length > 30) {
      chats.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

      for (var i = 0; i < chats.length - 30; i++) {
        box.delete(chats[i].eventId);
      }
    }
  }

//ExpireOldChats(Duration ageLimit): This method is used
// to delete chats that are older than a certain age specified by ageLimit.
// Here's a breakdown:
// It opens the chats box which contains Chat objects.
// It goes through each chat in the box.
// If the difference between the current time (now) and the chat's
// newMessageTimestamp is greater than the ageLimit, it deletes that chat from the box.

  void expireOldChats(Duration ageLimit) async {
    var box = await Hive.openBox<Chat>('chats');
    var now = DateTime.now();

    for (var message in box.values) {
      if (now.difference(message.newMessageTimestamp!.toDate()) > ageLimit) {
        box.delete(message.id);
      }
    }
  }

  void expireOldRooms(Duration ageLimit) async {
    var box = await Hive.openBox<EventRoom>('eventRooms');
    var now = DateTime.now();

    for (var message in box.values) {
      if (now.difference(message.timestamp!.toDate()) > ageLimit) {
        box.delete(message.id);
      }
    }
  }

  void expireOldTicketIds(Duration ageLimit) async {
    var box = await Hive.openBox<TicketIdModel>('ticketIds');
    var now = DateTime.now();

    for (var message in box.values) {
      if (now.difference(message.timestamp!.toDate()) > ageLimit) {
        box.delete(message.eventId);
      }
    }
  }

  _schimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            8,
            (index) => EventAndUserScimmerSkeleton(
                  from: '',
                )),
      ),
    );
  }

  void _listenToChatUpdates(String chatId) {
    final chatsBox = Hive.box<Chat>('chats');

    var subscription = usersAuthorRef
        .doc(widget.currentUserId)
        .collection('new_chats')
        .doc(chatId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        Chat updatedChat = Chat.fromDoc(snapshot);
        chatsBox.put(chatId, updatedChat);
      }
    }, onError: (error) => print("Listen failed: $error"));

    _chatSubscriptions.add(subscription);
  }

  _chat() {
    // Stream from Firestore
    Stream<QuerySnapshot> stream = usersAuthorRef
        .doc(widget.currentUserId)
        .collection('new_chats')
        .orderBy('newMessageTimestamp', descending: true)
        .snapshots();

    final chatsBox = Hive.box<Chat>('chats');

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return _schimmer();
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: NoContents(
              icon: Icons.chat_bubble_outline_outlined,
              title: 'No Chats',
              subTitle: ' This section will display your chat and messages. ',
            ),
          );
        } else {
          // Map Firestore documents to Chat objects and update Hive
          snapshot.data!.docs.forEach((doc) {
            Chat chat = Chat.fromDoc(doc);

            // Update the local cache and listen for updates
            if (!_activeListeners.contains(chat.id)) {
              _listenToChatUpdates(chat.id);
              _activeListeners.add(chat.id);
            }

            chatsBox.put(chat.id, chat);
          });

          // Fetch chats from Hive directly
          List<Chat> retrievedChats = chatsBox.values.toList();

          // Use retrievedChats directly in your ListView
          return _buildChatViewFromList(
            chats: retrievedChats,
            noContentMessage: 'No Chats.',
            noContentIcon: Icons.send_outlined,
            itemBuilder: (context, index, chat) {
              limitChats();
              return GetAuthor(
                connectivityStatus: _connectivityStatus,
                chats: chat,
                lastMessage: chat.lastMessage,
                seen: chat.seen,
                chatUserId: chat.toUserId == widget.currentUserId
                    ? chat.fromUserId
                    : chat.toUserId,
                isEventRoom: false,
                room: null,
              );
            },
            text: 'Your chats and messages will be displayed here.',
          );
        }
      },
    );
  }

//   _chat() {
//     // Stream from Firestore
//     Stream<QuerySnapshot> stream = usersAuthorRef
//         .doc(widget.currentUserId)
//         .collection('new_chats')
//         .orderBy('newMessageTimestamp', descending: true)
//         .snapshots();
//     return StreamBuilder<QuerySnapshot>(
//       stream: stream,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData) {
//           return _schimmer();
//         } else {
//           // Map Firestore documents to Chat objects
//           // List<Chat> newChats = snapshot.data!.docs.map((doc) {
//           //   return Chat.fromDoc(doc);
//           // }).toList();
//           // final chatsBox = Hive.box<Chat>('chats');

//           // for (Chat newChat in newChats) {
//           //   // Update lastMessage and newMessageTimestamp
//           //   newChat.lastMessage =
//           //       'New message'; // Replace with actual new message
//           //   newChat.newMessageTimestamp = Timestamp.now();

//           //   // Store the updated Chat object in Hive
//           //   chatsBox.put(newChat.id, newChat);
//           // }

//           // // Fetch chats from Hive directly
//           // List<Chat> retrievedChats = [];
//           // for (Chat newChat in newChats) {
//           //   Chat? chatFromBox = chatsBox.get(newChat.id);
//           //   if (chatFromBox != null) {
//           //     retrievedChats.add(chatFromBox);
//           //   }
//           // }
//           List<Chat> newChats = snapshot.data!.docs.map((doc) {
//             return Chat.fromDoc(doc);
//           }).toList();
//           final chatsBox = Hive.box<Chat>('chats');

//           for (Chat newChat in newChats) {
//             chatsBox.put(newChat.id, newChat);
//           }

// // Fetch chats from Hive directly
//           List<Chat> retrievedChats = [];
//           for (Chat newChat in newChats) {
//             Chat? chatFromBox = chatsBox.get(newChat.id);
//             if (chatFromBox != null) {
//               retrievedChats.add(chatFromBox);
//             }
//           }

//           // Use retrievedChats directly in your ListView
  // return _buildChatViewFromList(
  //   chats: retrievedChats,
  //   noContentMessage: 'No Chats.',
  //   noContentIcon: Icons.send_outlined,
  //   itemBuilder: (context, index, chat) {
  //     limitChats();
  //     return GetAuthor(
  //       connectivityStatus: _connectivityStatus,
  //       chats: chat,
  //       lastMessage: chat.lastMessage,
  //       seen: chat.seen,
  //       chatUserId: chat.toUserId == widget.currentUserId
  //           ? chat.fromUserId
  //           : chat.toUserId,
  //       isEventRoom: false,
  //       room: null,
  //     );
  //   },
  //   text: 'Your chats and messages will be displayed here.',
  // );
//         }
//       },
//     );
//   }

  _loadingSkeleton() {
    return ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.blue,
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    ResponsiveHelper.responsiveFontSize(context, 14.0),
                  ),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            const SizedBox(
              height: 2.0,
            ),
          ],
        ),
        onTap: () {});
  }

  // Define this in your State class
  Future<EventRoom?> _getEventRoom(String eventId) async {
    final eventRoomsBox = Hive.box<EventRoom>('eventRooms');

    // Check if the event room is already in the cache
    if (eventRoomsBox.containsKey(eventId)) {
      return eventRoomsBox.get(eventId);
    } else {
      // If not, fetch it from Firestore and store it in the cache
      final room = await DatabaseService.getEventRoomWithId(eventId);
      if (room != null) await eventRoomsBox.put(eventId, room);
      return room;
    }
  }

  void _listenToTicketIdUpdates(String ticketIdKey) {
    final ticketIdsBox = Hive.box<TicketIdModel>('ticketIds');

    var subscription = userTicketIdRef
        .doc(widget.currentUserId)
        .collection('eventInvite')
        .doc(ticketIdKey)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        // Deserialize the updated TicketIdModel from the document snapshot
        TicketIdModel updatedTicketId = TicketIdModel.fromDoc(snapshot);

        // Update the Hive box with the new data
        ticketIdsBox.put(ticketIdKey, updatedTicketId);
      }
    }, onError: (error) => print("Listen failed: $error"));

    // Store the subscription so you can cancel it when it's no longer needed
    _subscriptions.add(subscription);
  }

  _eventRoom() {
    final ticketIdsBox = Hive.box<TicketIdModel>('ticketIds');
    // final eventRoomsBox = Hive.box<EventRoom>('eventRooms');

    return StreamBuilder<QuerySnapshot>(
      stream: userTicketIdRef
          .doc(widget.currentUserId)
          .collection('eventInvite')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (!streamSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (streamSnapshot.data!.docs.isEmpty) {
          return Center(
            child: NoContents(
              icon: Icons.chat_bubble_outline_outlined,
              title: 'No event room',
              subTitle:
                  'Your event rooms will be displayed here. An event room is a networking group comprised of all the attendees of a particular event. It facilitates networking, fosters friendships, and helps build relationships. ',
            ),
          );
        }

        // Now you can access the documents through streamSnapshot.data.docs
        return ListView.builder(
          // controller: _hideButtonController,
          // physics: const AlwaysScrollableScrollPhysics(),
          itemCount: streamSnapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot docSnapshot = streamSnapshot.data!.docs[index];
            String ticketIdKey = docSnapshot.id;
            // Check if the ticketId is already in the cache
            TicketIdModel ticketId;
            if (ticketIdsBox.containsKey(ticketIdKey)) {
              ticketId = ticketIdsBox.get(ticketIdKey)!;
            } else {
              // If not, create it from the DocumentSnapshot and store it in the cache
              ticketId = TicketIdModel.fromDoc(
                  docSnapshot); // pass the DocumentSnapshot directly
              ticketIdsBox.put(ticketIdKey, ticketId);

              // Set up a listener for this TicketIdModel if not already listening
              if (!_activeListeners.contains(ticketIdKey)) {
                _listenToTicketIdUpdates(ticketIdKey);
                _activeListeners.add(ticketIdKey);
              }
            }
            // Use FutureBuilder inside itemBuilder to handle asynchronous fetching of EventRoom
            return FutureBuilder<EventRoom?>(
              future: _getEventRoom(ticketId.eventId),
              builder: (BuildContext context,
                  AsyncSnapshot<EventRoom?> roomSnapshot) {
                if (roomSnapshot.hasError) {
                  return const Text('Error loading chat room');
                }
                if (!roomSnapshot.hasData) {
                  return _loadingSkeleton(); // return a loading spinner or some other widget
                }
                final room = roomSnapshot.data;
                // limitRooms(); // Ensure these functions are defined and manage your data as expected
                // limitTicketIds(); // Ensure these functions are defined and manage your data as expected
                return GetAuthor(
                  ticketId: ticketId,
                  connectivityStatus: _connectivityStatus,
                  chats: null,
                  lastMessage: ticketId.lastMessage,
                  seen: false,
                  chatUserId: '',
                  isEventRoom: true,
                  room: room,
                );
              },
            );
          },
        );
      },
    );
  }

//   _eventRoom() {
//     final ticketIdsBox = Hive.box<TicketIdModel>('ticketIds');
//     final eventRoomsBox = Hive.box<EventRoom>('eventRooms');

//     return StreamBuilder<QuerySnapshot>(
//   stream: userTicketIdRef
//       .doc(widget.currentUserId)
//       .collection('eventInvite')
//       .orderBy('timestamp', descending: true)
//       .snapshots(),
//   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {

//     if (!streamSnapshot.hasData) {
//       return Center(child: CircularProgressIndicator());
//     }

//       DocumentSnapshot docSnapshot = streamSnapshot.data!.docs[index];
//         String ticketIdKey = docSnapshot.id;
//         // Check if the ticketId is already in the cache
//         TicketIdModel ticketId;
//         if (ticketIdsBox.containsKey(docSnapshot.id)) {
//           ticketId = ticketIdsBox.get(docSnapshot.id)!;
//         } else {
//           // If not, fetch it from Firestore and store it in the cache
//           ticketId = TicketIdModel.fromDoc( docSnapshot);
//           ticketIdsBox.put(docSnapshot.id, ticketId);

//           if (!_activeListeners.contains(ticketIdKey)) {
//             _listenToTicketIdUpdates(ticketIdKey);
//             _activeListeners.add(ticketIdKey);
//           }
//         }

//     // Now you can access the documents through streamSnapshot.data.docs
//     return FutureBuilder<EventRoom?>(
//           // future: () async {
//           //   // Check if the event room is already in the cache
//           //   if (eventRoomsBox.containsKey(ticketId.eventId)) {
//           //     return eventRoomsBox.get(ticketId.eventId);
//           //   } else {
//           //     // If not, fetch it from Firestore and store it in the cache
//           //     final room =
//           //         await DatabaseService.getEventRoomWithId(ticketId.eventId);
//           //     if (room != null) await eventRoomsBox.put(ticketId.eventId, room);
//           //     return room;
//           //   }
//           // }(),
//           future: _getEventRoom(ticketId.eventId),

//           builder: (BuildContext context, AsyncSnapshot<EventRoom?> snapshot) {
//             if (snapshot.hasError) {
//               return const Text('Error loading chat room');
//             }
//             if (!snapshot.hasData) {
//               return _loadingSkeleton(); // return a loading spinner or some other widget
//             }
//             final room = snapshot.data;
//             limitRooms();
//             limitTicketIds();
//             return GetAuthor(
//               ticketId: ticketId,
//               connectivityStatus: _connectivityStatus,
//               chats: null,
//               lastMessage: ticketId.lastMessage,
//               seen: false,
//               chatUserId: widget.currentUserId,
//               isEventRoom: true,
//               room: room,
//             );
//           },
//         );
//   },
// );

//     // _buildChatView(

//     //   stream: userTicketIdRef
//     //       .doc(widget.currentUserId)
//     //       .collection('eventInvite')
//     //       .orderBy('timestamp', descending: true)
//     //       .snapshots(),
//     //   noContentMessage: 'No Event Rooms.',
//     //   noContentIcon: Icons.chat_bubble_outline_sharp,
//     //   itemBuilder: (context, index, doc) {
//     //     DocumentSnapshot docSnapshot = doc[index];
//     //     String ticketIdKey = docSnapshot.id;
//     //     // Check if the ticketId is already in the cache
//     //     TicketIdModel ticketId;
//     //     if (ticketIdsBox.containsKey(doc.id)) {
//     //       ticketId = ticketIdsBox.get(doc.id)!;
//     //     } else {
//     //       // If not, fetch it from Firestore and store it in the cache
//     //       ticketId = TicketIdModel.fromDoc(doc);
//     //       ticketIdsBox.put(doc.id, ticketId);

//     //       if (!_activeListeners.contains(ticketIdKey)) {
//     //         _listenToTicketIdUpdates(ticketIdKey);
//     //         _activeListeners.add(ticketIdKey);
//     //       }
//     //     }

//     //     // Return a FutureBuilder that completes with the event room
//     //     return FutureBuilder<EventRoom?>(
//     //       // future: () async {
//     //       //   // Check if the event room is already in the cache
//     //       //   if (eventRoomsBox.containsKey(ticketId.eventId)) {
//     //       //     return eventRoomsBox.get(ticketId.eventId);
//     //       //   } else {
//     //       //     // If not, fetch it from Firestore and store it in the cache
//     //       //     final room =
//     //       //         await DatabaseService.getEventRoomWithId(ticketId.eventId);
//     //       //     if (room != null) await eventRoomsBox.put(ticketId.eventId, room);
//     //       //     return room;
//     //       //   }
//     //       // }(),
//     //       future: _getEventRoom(ticketId.eventId),

//     //       builder: (BuildContext context, AsyncSnapshot<EventRoom?> snapshot) {
//     //         if (snapshot.hasError) {
//     //           return const Text('Error loading chat room');
//     //         }
//     //         if (!snapshot.hasData) {
//     //           return _loadingSkeleton(); // return a loading spinner or some other widget
//     //         }
//     //         final room = snapshot.data;
//     //         limitRooms();
//     //         limitTicketIds();
//     //         return GetAuthor(
//     //           ticketId: ticketId,
//     //           connectivityStatus: _connectivityStatus,
//     //           chats: null,
//     //           lastMessage: ticketId.lastMessage,
//     //           seen: false,
//     //           chatUserId: widget.currentUserId,
//     //           isEventRoom: true,
//     //           room: room,
//     //         );
//     //       },
//     //     );
//     //   },
//     // );
//   }

// he build method constructs the UI of the widget. It uses a NestedScrollView
// with a SliverAppBar for the header, which contains the user's posts and a
// TabBar for switching between 'Chats' and 'Rooms'. The body of the
// NestedScrollView contains the TabBarView for the 'Chats' and 'Rooms' tabs.
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scrollbar(
            controller: _hideButtonController,
            child: NestedScrollView(
              controller: _hideButtonController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // sif (Provider.of<UserData>(context, listen: false).showUsersTab)
                SliverAppBar(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  expandedHeight: 100,
                  flexibleSpace: SingleChildScrollView(
                    // controller: _hideButtonController,
                    child: Column(
                      children: [
                        _buildNotification(),
                        TabBar(
                          controller: _tabController,
                          labelColor: Theme.of(context).secondaryHeaderColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.blue,
                          unselectedLabelColor: Colors.grey,
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10.0,
                          ),
                          indicatorWeight: 2.0,
                          tabs: <Widget>[
                            Text(
                              'Chats',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Rooms',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              body: Listener(
                onPointerMove: (event) {
                  final offset = event.delta.dx;
                  final index = _tabController.index;
                  //Check if we are in the first or last page of TabView and the notifier is false
                  if (((offset > 0 && index == 0) ||
                          (offset < 0 && index == 2 - 1)) &&
                      !_physycsNotifier.value) {
                    _physycsNotifier.value = true;
                  }
                },
                onPointerUp: (_) => _physycsNotifier.value = false,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _physycsNotifier,
                  builder: (_, value, __) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TabBarView(
                        controller: _tabController,
                        physics: value ? NeverScrollableScrollPhysics() : null,
                        children: [
                          _chat(),
                          _eventRoom(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GetAuthor extends StatefulWidget {
  final ConnectivityResult connectivityStatus;
  final Chat? chats;
  final String chatUserId;
  final bool seen;
  final String lastMessage;
  final bool isEventRoom;
  final EventRoom? room;
  final TicketIdModel? ticketId;

  const GetAuthor({
    Key? key,
    required this.chats,
    required this.chatUserId,
    required this.seen,
    required this.lastMessage,
    required this.isEventRoom,
    required this.room,
    required this.connectivityStatus,
    this.ticketId,
  }) : super(key: key);

  @override
  State<GetAuthor> createState() => _GetAuthorState();
}

class _GetAuthorState extends State<GetAuthor>
    with AutomaticKeepAliveClientMixin {
  AccountHolderAuthor? _author;
  Object? _error;
  bool _loading = true;
  // late Future<Box> box;

  @override
  void initState() {
    super.initState();
    //  box = Hive.openBox('accountHolderAuthorBox');
    _loading = widget.isEventRoom ? false : true;
    widget.isEventRoom ? () {} : _setUpProfileUser();
  }

  Future<void> _setUpProfileUser() async {
    final usersBox = Hive.box<AccountHolderAuthor>('accountHolderAuthor');
    if (usersBox.containsKey(widget.chatUserId)) {
      // // If the user data is already in the box, use it
      _author = usersBox.get(widget.chatUserId);
    } else {
      // If the user data is not in the box, fetch it from the database and save it to the box
      try {
        _author = await DatabaseService.getUserWithId(widget.chatUserId);
        usersBox.put(widget.chatUserId, _author!);
      } catch (e) {
        _error = e;
      }
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  _loadingSkeleton() {
    return ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.blue,
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            const SizedBox(
              height: 2.0,
            ),
          ],
        ),
        onTap: () {});
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_loading) {
      return _loadingSkeleton();
    } else if (_error != null) {
      return Text('Error loading user data: $_error');
    } else {
      return Display(
        connectivityStatus: widget.connectivityStatus,
        author: _author,
        chats: widget.chats,
        lastMessage: widget.lastMessage,
        seen: widget.seen,
        chatUserId: widget.chatUserId,
        isEventRoom: widget.isEventRoom,
        room: widget.room,
        ticketId: widget.ticketId,
      );
    }
  }
}

class Display extends StatefulWidget {
  final AccountHolderAuthor? author;
  final Chat? chats;
  final String lastMessage;
  final bool seen;
  final String chatUserId;
  final bool isEventRoom;
  final EventRoom? room;
  final TicketIdModel? ticketId;

  final ConnectivityResult connectivityStatus;

  Display({
    required this.author,
    required this.chats,
    required this.lastMessage,
    required this.seen,
    required this.chatUserId,
    required this.isEventRoom,
    required this.room,
    required this.connectivityStatus,
    required this.ticketId,
  });

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  bool _isLoading = false;
  late PaletteGenerator _paletteGenerator;
  bool muteEvent = false;
  bool muteMessage = false;

  @override
  void initState() {
    super.initState();
    widget.room == null ? () {} : _initPaletteGenerator();
    widget.ticketId == null ? _seMuteMessage() : _seMute();
  }

  _seMuteMessage() {
    setState(() {
      muteMessage = widget.chats!.muteMessage;
    });
  }

  _seMute() {
    setState(() {
      muteEvent = widget.ticketId!.muteNotification;
    });
  }

  Future<void> _initPaletteGenerator() async {
    _paletteGenerator = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(widget.room!.imageUrl),
      size: const Size(1110, 150),
      maximumColorCount: 20,
    );
  }

  void _showBottomSheetErrorMessage(BuildContext context) {
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
          title: 'Failed to fecth event',
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomConfirmLeaveRoom(BuildContext context, bool isMute) {
    var _provider = Provider.of<UserData>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height:
              ResponsiveHelper.responsiveHeight(context, isMute ? 300 : 400),
          child: ConfirmationPrompt(
            buttonText: isMute ? 'Mute Room' : 'Leave Room',
            onPressed: isMute
                ? () async {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                    try {
                      userTicketIdRef
                          .doc(_provider.currentUserId)
                          .collection('eventInvite')
                          .doc(widget.room!.linkedEventId)
                          .update({'muteNotification': !muteEvent});
                      mySnackBar(
                          context, 'You have successfully left the room.');

                      muteEvent = !muteEvent;
                    } catch (e) {}
                  }
                : () async {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);

                    try {
                      userTicketIdRef
                          .doc(_provider.currentUserId)
                          .collection('eventInvite')
                          .doc(widget.room!.linkedEventId)
                          .get()
                          .then((doc) {
                        if (doc.exists) {
                          doc.reference.delete();
                        }
                      });
                      mySnackBar(
                          context, 'You have successfully left the room.');
                    } catch (e) {}
                  },
            title: isMute
                ? 'Are you sure you want to mute ${widget.room!.title} room?'
                : 'Are you sure you want to leave ${widget.room!.title} room?',
            subTitle: isMute
                ? ''
                : 'If you leave this room, you will lose access to this room. This means you won\'t be able to read past conversations or contribute to new conversations. Additionally, please note that once you leave, you cannot be added back to the room. Leaving the room is a permanent action.',
          ),
        );
      },
    );
  }

  void _showBottomSheetEventRoomMore(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveFontSize(context, 500),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    widget.room!.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    MyDateFormat.toDate(widget.room!.timestamp!.toDate()),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  height: ResponsiveHelper.responsiveFontSize(context, 380),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 2),
                      child: MyBottomModelSheetAction(actions: [
                        const SizedBox(
                          height: 30,
                        ),
                        BottomModelSheetListTileActionWidget(
                          colorCode: muteEvent ? 'Blue' : '',
                          icon: muteEvent
                              ? Icons.volume_off_outlined
                              : Icons.volume_up_outlined,
                          onPressed: () async {
                            _showBottomConfirmLeaveRoom(context, true);
                          },
                          text: muteEvent ? 'Unmute room' : 'Mute room',
                        ),
                        BottomModelSheetListTileActionWidget(
                          colorCode: '',
                          icon: Icons.remove,
                          onPressed: () async {
                            _showBottomConfirmLeaveRoom(context, false);
                          },
                          text: 'Leave room',
                        ),
                        BottomModelSheetListTileActionWidget(
                          colorCode: '',
                          icon: Icons.event_available_outlined,
                          onPressed: () async {
                            _isLoading = true;
                            try {
                              Event? event =
                                  await DatabaseService.getEventWithId(
                                widget.room!.linkedEventId,
                              );

                              if (event != null) {
                                _navigateToPage(EventEnlargedScreen(
                                  currentUserId: _provider.currentUserId!,
                                  event: event,
                                  type: event.type,
                                ));
                              } else {
                                _showBottomSheetErrorMessage(context);
                              }
                            } catch (e) {
                              _showBottomSheetErrorMessage(context);
                            } finally {
                              _isLoading = false;
                            }
                          },
                          text: 'View event',
                        ),
                        BottomModelSheetListTileActionWidget(
                          colorCode: '',
                          icon: Icons.person_outline,
                          onPressed: () async {
                            _isLoading = true;
                            try {
                              Event? event =
                                  await DatabaseService.getEventWithId(
                                widget.room!.linkedEventId,
                              );

                              if (event != null) {
                                _navigateToPage(ProfileScreen(
                                  currentUserId: _provider.currentUserId!,
                                  userId: event.authorId,
                                  user: null,
                                ));
                              } else {
                                _showBottomSheetErrorMessage(context);
                              }
                            } catch (e) {
                              _showBottomSheetErrorMessage(context);
                            } finally {
                              _isLoading = false;
                            }
                            //           _navigateToPage(

                            // ProfileScreen(
                            //   currentUserId: _provider.currentUserId!,
                            //   userId:  widget.room!.,
                            //   user: null,
                            // ));
                          },
                          text: 'View event organizer',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BottomModelSheetListTileActionWidget(
                          colorCode: '',
                          icon: Icons.flag_outlined,
                          onPressed: () {
                            _navigateToPage(ReportContentPage(
                              contentId: widget.room!.id,
                              contentType: widget.room!.title,
                              parentContentId: widget.room!.linkedEventId,
                              repotedAuthorId: widget.room!.linkedEventId,
                            ));
                          },
                          text: 'Report',
                        ),
                      ])),
                ),
              ],
            ));
      },
    );
  }

  void _showBottomConfirmMutChat(
    BuildContext context,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 300),
          child: ConfirmationPrompt(
            buttonText: 'Mute chat',
            onPressed: () async {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
              try {
                usersAuthorRef
                    .doc(_provider.currentUserId)
                    .collection('new_chats')
                    .doc(widget.author!.userId)
                    .update({'muteMessage': !muteMessage});
                mySnackBar(context, 'You have successfully left the room.');

                muteMessage = !muteMessage;
              } catch (e) {}
            },
            title:
                'Are you sure you want to mute messages from ${widget.author!.userName!}?',
            subTitle: '',
          ),
        );
      },
    );
  }

  void _showBottomSheetChatMore(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 150),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
                  child: MyBottomModelSheetAction(actions: [
                    const SizedBox(
                      height: 30,
                    ),
                    BottomModelSheetListTileActionWidget(
                      colorCode: muteMessage ? 'Blue' : '',
                      icon: muteMessage
                          ? Icons.volume_off_outlined
                          : Icons.volume_up_outlined,
                      onPressed: () async {
                        _showBottomConfirmMutChat(
                          context,
                        );
                      },
                      text: muteEvent ? 'Unmute message' : 'Mute message',
                    ),
                  ])),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    return FocusedMenuHolder(
      menuWidth: width,
      menuOffset: 1,
      blurBackgroundColor: Theme.of(context).secondaryHeaderColor,
      openWithTap: false,
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
          title: Container(
            width: width / 2,
            child: Text(
              widget.isEventRoom ? 'Report room' : 'Report chat',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
            ),
          ),
          onPressed: widget.isEventRoom
              ? () {}
              : () {
                  _navigateToPage(ReportContentPage(
                    contentId: widget.chatUserId,
                    contentType: widget.author!.userName!,
                    parentContentId: widget.chatUserId,
                    repotedAuthorId: currentUserId,
                  ));
                },
        ),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
        child: ListTile(
            leading: Hero(
              tag: widget.isEventRoom ? widget.room!.id : widget.chatUserId,
              child: widget.isEventRoom
                  ? CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.blue,
                      backgroundImage:
                          CachedNetworkImageProvider(widget.room!.imageUrl),
                    )
                  : widget.author!.profileImageUrl!.isEmpty
                      ? Icon(
                          Icons.account_circle,
                          color: Theme.of(context).secondaryHeaderColor,
                          size: ResponsiveHelper.responsiveHeight(context, 40),
                        )
                      : CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.blue,
                          backgroundImage: CachedNetworkImageProvider(
                              widget.author!.profileImageUrl!),
                        ),
            ),
            trailing: widget.isEventRoom
                ? GestureDetector(
                    onTap: () {
                      _showBottomSheetEventRoomMore(context);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.more_vert_outlined,
                          size: 25,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        muteEvent
                            ? Icon(
                                Icons.volume_off_outlined,
                                size: 20,
                                color: Colors.grey,
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _showBottomSheetChatMore(context);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.more_vert_outlined,
                          size: 25,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        muteMessage
                            ? Icon(
                                Icons.volume_off_outlined,
                                size: 20,
                                color: Colors.grey,
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: NameText(
                        name: widget.isEventRoom
                            ? widget.room!.title
                            : widget.author!.userName!,
                        verified: widget.isEventRoom
                            ? false
                            : widget.author!.verified!
                                ? false
                                : true,
                      ),
                    ),
                    Text(
                        widget.isEventRoom
                            ? timeago.format(
                                widget.ticketId!.timestamp == null
                                    ? DateTime.now()
                                    : widget.ticketId!.timestamp!.toDate(),
                              )
                            : timeago.format(
                                widget.chats!.newMessageTimestamp == null
                                    ? DateTime.now()
                                    : widget.chats!.newMessageTimestamp!
                                        .toDate(),
                              ),
                        style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 10.0),
                            color: Colors.grey,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
                const SizedBox(
                  height: 2.0,
                ),
                widget.isEventRoom
                    ? Wrap(
                        children: [
                          Text(
                            widget.lastMessage,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0),
                              fontWeight: widget.ticketId!.isSeen
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: widget.ticketId!.isSeen
                                  ? Colors.grey
                                  : Colors.blue,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Divider(),
                        ],
                      )
                    : Wrap(
                        children: [
                          widget.chats!.mediaType.isEmpty
                              ? const SizedBox.shrink()
                              : Icon(
                                  MdiIcons.image,
                                  size: 20,
                                  color:
                                      widget.seen ? Colors.grey : Colors.blue,
                                ),
                          Text(
                            widget.lastMessage,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0),
                              fontWeight: widget.seen
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: widget.seen ? Colors.grey : Colors.blue,
                              overflow: TextOverflow.ellipsis,
                              decoration: widget.chats!.restrictChat
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Divider(),
                        ],
                      ),
              ],
            ),
            onTap: widget.isEventRoom
                ? () async {
                    _navigateToPage(EventRoomScreen(
                      currentUserId: currentUserId,
                      room: widget.room!,
                      palette: _paletteGenerator,
                      ticketId: widget.ticketId!,
                    ));
                  }
                : () {
                    _navigateToPage(BottomModalSheetMessage(
                      currentUserId: currentUserId,
                      user: null,
                      showAppbar: true,
                      userAuthor: widget.author!,
                      chatLoaded: widget.chats!,
                      userPortfolio: null,
                      userId: widget.author!.userId!,
                    ));
                    usersAuthorRef
                        .doc(currentUserId)
                        .collection('new_chats')
                        .doc(widget.chatUserId)
                        .update({
                      'seen': true,
                    });
                  }),
      ),
    );
  }
}
