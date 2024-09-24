// import 'package:bars/utilities/exports.dart';

// //These code has been tested for  better performance and potential bug prevention:
// //15th August 2023  4:09pm
// //Author: Harold Enam Kwaku Fianu (CEO BARS OPUS LTD)

// class DiscoverEventScreen extends StatefulWidget {
//   static final id = 'DiscoverEventScreen';
//   final String currentUserId;
//   final UserSettingsLoadingPreferenceModel userLocationSettings;
//   final bool isLiveLocation;
//   final String liveCity;
//   final String liveCountry;
//   final int liveLocationIntialPage;

//   final int sortNumberOfDays;

//   DiscoverEventScreen({
//     required this.currentUserId,
//     required this.userLocationSettings,
//     required this.isLiveLocation,
//     required this.liveCity,
//     required this.liveCountry,
//     required this.liveLocationIntialPage,
//     required this.sortNumberOfDays,
//   });

//   @override
//   _DiscoverEventScreenState createState() => _DiscoverEventScreenState();
// }

// class _DiscoverEventScreenState extends State<DiscoverEventScreen>
//     with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
//   late ScrollController _hideButtonController;
//   late TabController _tabController;
//   String query = "";

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//         length: 10, initialIndex: widget.liveLocationIntialPage, vsync: this);
//     _tabController.addListener(() {});
//     _hideButtonController = ScrollController();
//   }

//   @override
//   void dispose() {
//     // Dispose controllers to free up resources
//     _hideButtonController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }

//   bool get wantKeepAlive => true;
//   final _physycsNotifier = ValueNotifier<bool>(false);

//   // Widget for search container
//   _searchContainer() {
//     return GestureDetector(
//         onTap: () {
//           Navigator.push(context, MaterialPageRoute(builder: (_) => Search()));
//         },
//         child: DummySearchContainer());
//   }

//   // Method to show the bottom sheet for expanding the calendar
//   void _showBottomSheetExpandCalendar(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return ExploreEventCalendar(
//           currentUserId: widget.currentUserId,
//         );
//       },
//     );
//   }

//   // Widget for the event tab bar
//   _eventTab() {
//     return Stack(
//       children: [
//         Padding(
//           padding:
//               EdgeInsets.only(left: widget.sortNumberOfDays != 0 ? 0 : 50.0),
//           child: TabBar(
//               controller: _tabController,
//               labelColor: Theme.of(context).secondaryHeaderColor,
//               indicatorSize: TabBarIndicatorSize.label,
//               indicatorColor: Colors.blue,
//               unselectedLabelColor: Colors.grey,
//               isScrollable: true,
//               dividerColor: Colors.transparent,
//               tabAlignment: TabAlignment.start,
//               labelPadding:
//                   EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
//               indicatorWeight: 2.0,
//               tabs: <Widget>[
//                 Text(
//                   style: Theme.of(context).textTheme.bodySmall,
//                   'All',
//                 ),
//                 Text(
//                   style: Theme.of(context).textTheme.bodySmall,
//                   'Parties',
//                 ),
//                 Text(
//                   style: Theme.of(context).textTheme.bodySmall,
//                   'Music_concerts',
//                 ),
//                 Text(style: Theme.of(context).textTheme.bodySmall, 'Festivals'),
//                 Text(
//                   style: Theme.of(context).textTheme.bodySmall,
//                   'Club_nights',
//                 ),
//                 Text(
//                   style: Theme.of(context).textTheme.bodySmall,
//                   'Pub_events',
//                 ),
//                 Text(
//                   style: Theme.of(context).textTheme.bodySmall,
//                   'Sports/Games',
//                 ),
//                 Text(
//                   style: Theme.of(context).textTheme.bodySmall,
//                   'Religious',
//                 ),
//                 Text(
//                   style: Theme.of(context).textTheme.bodySmall,
//                   'Business',
//                 ),
//                 Text(
//                   style: Theme.of(context).textTheme.bodySmall,
//                   'Others',
//                 ),
//               ]),
//         ),
//         widget.sortNumberOfDays != 0
//             ? SizedBox.fromSize()
//             : Positioned(
//                 left: 2,
//                 child: IconButton(
//                   onPressed: () {
//                     HapticFeedback.lightImpact();
//                     _showBottomSheetExpandCalendar(context);
//                   },
//                   icon: Icon(
//                     Icons.calendar_today_outlined,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }

//   /// Builds the event page with a TabBarView, handling swiping gestures to prevent
//   /// scrolling beyond the first and last tabs.
//   _eventPage() {
//     return Listener(
//       // Listener to detect pointer movements
//       onPointerMove: (event) {
//         final offset = event.delta.dx;
//         final index = _tabController.index;
//         //Check if we are in the first or last page of TabView and the notifier is false
//         if (((offset > 0 && index == 0) || (offset < 0 && index == 10 - 1)) &&
//             !_physycsNotifier.value) {
//           _physycsNotifier.value = true;
//         }
//       },
//       // Reset the physics notifier when the pointer is lifted
//       onPointerUp: (_) => _physycsNotifier.value = false,
//       // ValueListenableBuilder to rebuild the TabBarView based on the physics notifier
//       child: ValueListenableBuilder<bool>(
//         valueListenable: _physycsNotifier,
//         builder: (_, value, __) {
//           return TabBarView(
//             controller: _tabController,
//             physics: value ? NeverScrollableScrollPhysics() : null,
//             // Generate a list of child widgets for each tab
//             children: List.generate(10, (index) {
//               String eventType = '';
//               int tabIndex = 0;
//               switch (index) {
//                 case 0:
//                   eventType = 'All';
//                   tabIndex = 0;
//                   break;
//                 case 1:
//                   eventType = 'Parties';
//                   tabIndex = 1;
//                   break;
//                 case 2:
//                   eventType = 'Music_concerts';
//                   tabIndex = 2;
//                   break;
//                 case 3:
//                   eventType = 'Festivals';
//                   tabIndex = 3;
//                   break;
//                 case 4:
//                   eventType = 'Club_nights';
//                   tabIndex = 4;
//                   break;
//                 case 5:
//                   eventType = 'Pub_events';
//                   tabIndex = 5;
//                   break;
//                 case 6:
//                   eventType = 'Games/Sports';
//                   tabIndex = 6;
//                   break;
//                 case 7:
//                   eventType = 'Religious';
//                   tabIndex = 7;
//                   break;
//                 case 8:
//                   eventType = 'Business';
//                   tabIndex = 8;
//                   break;
//                 case 9:
//                   eventType = 'Others';
//                   tabIndex = 9;
//                   break;
//               }
//               // Return the EventTypes widget for the current tab
//               return EventTypes(
//                 currentUserId: widget.currentUserId,
//                 types: eventType.startsWith('All') ? '' : eventType,
//                 pageIndex: eventType.startsWith('All') ? 0 : tabIndex,
//                 userLocationSettings: widget.userLocationSettings,
//                 liveCity: widget.liveCity,
//                 liveCountry: widget.liveCountry,
//                 seeMoreFrom: '',
//                 sortNumberOfDays: widget.sortNumberOfDays,
//                 isFrom: '',
//               );
//             }),
//           );
//         },
//       ),
//     );
//   }

//   _liveLocationHeader() {
//     String sort = widget.sortNumberOfDays == 1
//         ? 'Events Tonight'
//         : widget.sortNumberOfDays == 2
//             ? 'Events Tomorrow'
//             : widget.sortNumberOfDays == 7
//                 ? 'Events Within Seven (7) Days'
//                 : widget.sortNumberOfDays == 14
//                     ? 'Events Within Fourteen (14) Days'
//                     : '';
//     return ListTile(
//       leading: GestureDetector(
//         onTap: () {
//           Navigator.pop(context);
//         },
//         child: Icon(
//           Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
//           color: Colors.grey,
//         ),
//       ),
//       title: Text(
//         widget.liveCity.isEmpty ? sort : widget.liveCity,
//         style: Theme.of(context).textTheme.bodyLarge,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//           textScaleFactor:
//               MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
//       child: DefaultTabController(
//         length: 10,
//         child: Scaffold(
//           backgroundColor: Theme.of(context).primaryColorLight,
//           appBar: PreferredSize(
//             preferredSize: Size.fromHeight(MediaQuery.of(context).size.height),
//             child: SafeArea(
//               child: !Provider.of<UserData>(
//                 context,
//               ).showEventTab
//                   ? Padding(
//                       padding: const EdgeInsets.all(30.0),
//                       child: Text(
//                         _tabController.index == 0
//                             ? 'Discover events'
//                             : _tabController.index == 1
//                                 ? 'Discover parties'
//                                 : _tabController.index == 2
//                                     ? 'Discover music concerts'
//                                     : _tabController.index == 3
//                                         ? 'Discover festivals'
//                                         : _tabController.index == 4
//                                             ? 'Discover club nights'
//                                             : _tabController.index == 5
//                                                 ? 'Discover pub events'
//                                                 : _tabController.index == 6
//                                                     ? 'Discover games/sports'
//                                                     : _tabController.index == 7
//                                                         ? 'Discover religious events'
//                                                         : _tabController
//                                                                     .index ==
//                                                                 8
//                                                             ? 'Discover business events'
//                                                             : _tabController
//                                                                         .index ==
//                                                                     9
//                                                                 ? 'Discover other events'
//                                                                 : 'Discover',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                     )
//                   : Container(
//                       color: Theme.of(context).primaryColorLight,
//                       height: ResponsiveHelper.responsiveHeight(context, 100),
//                       child: SingleChildScrollView(
//                         controller: _hideButtonController,
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         child: Column(
//                           children: [
//                             widget.isLiveLocation ||
//                                     widget.sortNumberOfDays != 0
//                                 ? _liveLocationHeader()
//                                 : _searchContainer(),
//                             _eventTab()
//                           ],
//                         ),
//                       ),
//                     ),
//             ),
//           ),
//           body: _eventPage(),
//         ),
//       ),
//     );
//   }
// }
