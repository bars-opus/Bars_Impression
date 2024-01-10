import 'package:bars/utilities/exports.dart';

class DiscoverCategoryWidget extends StatefulWidget {
  final List<UserProfessionalModel> usersList;
  final List<DocumentSnapshot> usersSnapshot;
  final List<Event> eventsList;
  final List<DocumentSnapshot> eventsSnapshot;
  final List<Post> postsList;
  final List<DocumentSnapshot> postsSnapshot;
  final String locationCategory; //city, country, continent
  final String type; //event type or profilehandle type
  final String typeSpecific; // artist, producer or festivals, others
  final int pageIndex; //
  final String currentUserId; // artist, producer or festivals, others
  final VoidCallback loadMoreSeeAll;
  final String isFrom;
  final int sortNumberOfDays;

  DiscoverCategoryWidget({
    required this.usersList,
    required this.usersSnapshot,
    required this.typeSpecific,
    required this.locationCategory,
    required this.type,
    required this.pageIndex,
    required this.currentUserId,
    required this.eventsList,
    required this.eventsSnapshot,
    required this.postsList,
    required this.postsSnapshot,
    required this.loadMoreSeeAll,
    required this.isFrom,
    required this.sortNumberOfDays,
  });

  @override
  State<DiscoverCategoryWidget> createState() => _DiscoverCategoryWidgetState();
}

class _DiscoverCategoryWidgetState extends State<DiscoverCategoryWidget> {
  // late ScrollController _hideButtonController;
  late String widgetType;

  @override
  void initState() {
    super.initState();
    // _hideButtonController = ScrollController();
    if (widget.type.startsWith('User')) {
      widgetType = 'User';
    } else if (widget.type.startsWith('Post')) {
      widgetType = 'Post';
    } else if (widget.type.startsWith('Following')) {
      widgetType = 'Following';
    } else {
      widgetType = 'Other';
    }
  }

  _sliverListEvent() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          Event event = widget.eventsList[index];
          return EventDisplayWidget(
            currentUserId: widget.currentUserId,
            event: event,
            eventList: widget.eventsList,
            eventSnapshot: widget.eventsSnapshot,
            pageIndex: widget.pageIndex,
            eventPagesOnly: false,
            liveCity: '',
            liveCountry: '',
            isFrom: widget.isFrom,
            sortNumberOfDays: widget.sortNumberOfDays,
          );
        },
        childCount: widget.eventsList.length,
      ),
    );
  }

  _sliverListUser() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          UserProfessionalModel userProfessional = widget.usersList[index];
          return UserView(
            userSnapshot: widget.usersSnapshot,
            userList: widget.usersList,
            currentUserId: widget.currentUserId,
            // userId: userProfessional.id,
            userProfessional: userProfessional,
            pageIndex: widget.pageIndex,
            liveCity: '',
            liveCountry: '',
            isFrom: widget.isFrom,
          );
          // UserView(
          //   userSnapshot:  widget.usersList,
          //   userList: widget.usersList,
          //   currentUserId: widget.currentUserId,
          //   // userId: accountHolder.id!,
          //   // user: accountHolder,
          //   pageIndex: widget.pageIndex, userProfessional: accountHolder, user: null,
          // );
        },
        childCount: widget.usersList.length,
      ),
    );
  }

  _display(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(.3),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.type.startsWith('User')
                ? CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    // controller: _hideButtonController,
                    slivers: [_sliverListUser()],
                  )
                : widget.type.startsWith('Following')
                    ? CustomScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [_sliverListEvent()],
                      )
                    :

                    // widget.type.startsWith('Post')
                    //     ? CustomScrollView(
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         // scrollDirection: Axis.horizontal,
                    //         slivers: <Widget>[
                    //           SliverGrid(
                    //             gridDelegate:
                    //                 SliverGridDelegateWithFixedCrossAxisCount(
                    //               crossAxisCount: 2,
                    //               mainAxisSpacing: 5.0,
                    //               crossAxisSpacing: 5.0,
                    //               childAspectRatio: 1.0,
                    //             ),
                    //             delegate: SliverChildBuilderDelegate(
                    //               (context, index) {
                    //                 Post post = widget.postsList[index];
                    //                 return Container(
                    //                     child: FeedGrid(
                    //                   feed: 'All',
                    //                   currentUserId: widget.currentUserId,
                    //                   post: post,
                    //                 ));
                    //               },
                    //               childCount: widget.postsList.length,
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //     :
                    CustomScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [_sliverListEvent()],
                      )),
      ),
    );
  }

  // void _showBottomSheetSeeAll(BuildContext context) {
  //   var _size = MediaQuery.of(context).size;

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return Container(
  //           height: _size.height.toDouble() - 80,
  //           // height: width.toDouble() * 2,
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).cardColor,
  //               borderRadius: BorderRadius.circular(30)),

  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(5.0),
  //                 child: Text(
  //                   'All ${widget.typeSpecific} in ${widget.locationCategory} ',
  //                   style: Theme.of(context).textTheme.bodySmall,
  //                   // textAlign: TextAlign.end,
  //                 ),
  //               ),
  //               Container(
  //                 height: _size.height.toDouble() - 110,
  //                 decoration: BoxDecoration(
  //                     color: Theme.of(context).primaryColorLight,
  //                     borderRadius: BorderRadius.circular(10)),
  //                 child: Padding(
  //                     padding: const EdgeInsets.all(10.0),
  //                     child: widget.type.startsWith('User')
  //                         ? NotificationListener<ScrollNotification>(
  //                             onNotification: (scrollNotification) {
  //                               if (scrollNotification
  //                                   is ScrollEndNotification) {
  //                                 if (_hideButtonController
  //                                         .position.extentAfter ==
  //                                     0) {
  //                                   widget.loadMoreSeeAll();
  //                                 }
  //                                 setState(() {});
  //                               }

  //                               return false;

  //                             },
  //                             child: CustomScrollView(
  //                               physics: const AlwaysScrollableScrollPhysics(),
  //                               controller: _hideButtonController,
  //                               slivers: [
  //                                 _sliverListUser()

  //                               ],
  //                             ),
  //                           )
  //                         : widget.type.startsWith('Post')
  //                             ? CustomScrollView(
  //                                 physics: const NeverScrollableScrollPhysics(),
  //                                 // scrollDirection: Axis.horizontal,
  //                                 slivers: <Widget>[
  //                                   SliverGrid(
  //                                     gridDelegate:
  //                                         SliverGridDelegateWithFixedCrossAxisCount(
  //                                       crossAxisCount: 2,
  //                                       mainAxisSpacing: 5.0,
  //                                       crossAxisSpacing: 5.0,
  //                                       childAspectRatio: 1.0,
  //                                     ),
  //                                     delegate: SliverChildBuilderDelegate(
  //                                       (context, index) {
  //                                         Post post = widget.postsList[index];
  //                                         return Container(
  //                                             child: FeedGrid(
  //                                           feed: 'All',
  //                                           currentUserId: widget.currentUserId,
  //                                           post: post,
  //                                         ));
  //                                       },
  //                                       childCount: widget.postsList.length,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               )
  //                             : NotificationListener<ScrollNotification>(
  //                                 onNotification: (scrollNotification) {
  //                                   if (scrollNotification
  //                                       is ScrollEndNotification) {
  //                                     if (_hideButtonController
  //                                             .position.extentAfter ==
  //                                         0) {
  //                                       widget.loadMoreSeeAll();
  //                                     }
  //                                     setState(() {});
  //                                   }

  //                                   return false;

  //                                 },
  //                                 child: CustomScrollView(
  //                                   controller: _hideButtonController,
  //                                   physics:
  //                                       const AlwaysScrollableScrollPhysics(),
  //                                   slivers: [
  //                                     _sliverListEvent()
  //                                   ],
  //                                 ),
  //                               )),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var list = widgetType == 'User'
        ? widget.usersList.length
        : widget.eventsList.length;

    int baseHeight = 200; // Height of one item in the list
    int additionalHeight = widgetType == 'User'
        ? 100
        : 110; // Additional height per item in the list for list sizes greater than 1

    num height2 = (list > 0)
        ? baseHeight + (list - 1) * additionalHeight
        : 0; // Set the height as 0 if the list is empty
    // var list = widgetType == 'User'
    //     ? widget.usersList.length
    //     : widgetType == 'Post'
    //         ? widget.postsList.length
    //         : widget.eventsList.length;

    // double height2 =

    // list == 1
    //     ? 200
    //     : list == 2
    //         ? 300
    //         : list == 3
    //             ? 400
    //             : 520;

    return CategoryContainer(
      containerSubTitle: '',
      containerTitle: widget.locationCategory.isEmpty
          ? 'All ${widget.typeSpecific}'
          : widgetType == 'Following'
              ? '${widget.typeSpecific}\'s by people you follow'
              : '${widget.typeSpecific}\'s in ${widget.locationCategory}',
      seeAllOnPressed: () {
        HapticFeedback.lightImpact();
        widget.loadMoreSeeAll();
      },
      showSeeAll: widgetType == 'Following'
              ? false : true,
      child: Container(
        height: height2.toDouble(),
        child: _display(context),
      ),
    );
  }
  //   var list = widget.type.startsWith('User')
  //       ? widget.usersList.length
  //       : widget.type.startsWith('Post')
  //           ? widget.postsList.length
  //           : widget.eventsList.length;

  //   double height2 = list == 1
  //       ? 200
  //       : list == 2
  //           ? 300
  //           : list == 3
  //               ? 400
  //               : 520;
  //   return CategoryContainer(
  //     containerSubTitle: '',
  //     containerTitle: widget.locationCategory.isEmpty
  //         ? 'All ${widget.typeSpecific}'
  //         : widget.type.startsWith('Post')
  //             ? 'punches by ${widget.typeSpecific}'
  //             : '${widget.typeSpecific}\'s in ${widget.locationCategory}',
  //     seeAllOnPressed: () {
  //       HapticFeedback.lightImpact();
  //       _showBottomSheetSeeAll(context);
  //     },
  // child: Container(
  //   height: height2,
  //   child: _display(context),
  // ),
  //   );
  // }
}
