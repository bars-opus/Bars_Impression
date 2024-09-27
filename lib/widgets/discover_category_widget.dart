import 'package:bars/utilities/exports.dart';

class DiscoverCategoryWidget extends StatefulWidget {
  final List<UserStoreModel> usersList;
  final List<DocumentSnapshot> usersSnapshot;
  final List<Event> eventsList;
  final List<DocumentSnapshot> eventsSnapshot;
  final List<Post> postsList;
  final List<DocumentSnapshot> postsSnapshot;
  final String locationCategory; //city, country, continent
  final String type; //event type or storeType type
  final String typeSpecific; // Salon, producer or festivals, others
  final int pageIndex; //
  final String currentUserId; // Salon, producer or festivals, others
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
  late String widgetType;

  @override
  void initState() {
    super.initState();
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

  // _sliverListEvent() {
  //   return SliverList(
  //     delegate: SliverChildBuilderDelegate(
  //       (context, index) {
  //         Post post = widget.eventsList[index];
  //         return EventDisplayWidget(
  //           currentUserId: widget.currentUserId,
  //           post: event,
  //           eventList: widget.eventsList,
  //           eventSnapshot: widget.eventsSnapshot,
  //           pageIndex: widget.pageIndex,
  //           eventPagesOnly: false,
  //           liveCity: '',
  //           liveCountry: '',
  //           isFrom: widget.isFrom,
  //           sortNumberOfDays: widget.sortNumberOfDays,
  //         );
  //       },
  //       childCount: widget.eventsList.length,
  //     ),
  //   );
  // }

  _sliverListUser() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          UserStoreModel userProfessional = widget.usersList[index];
          return UserView(
            userSnapshot: widget.usersSnapshot,
            userList: widget.usersList,
            currentUserId: widget.currentUserId,
            userProfessional: userProfessional,
            pageIndex: widget.pageIndex,
            liveCity: '',
            liveCountry: '',
            isFrom: widget.isFrom,
          );
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
            child: CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [_sliverListUser()],
            )
            // widget.type.startsWith('User')
            //     ? CustomScrollView(
            //         physics: const NeverScrollableScrollPhysics(),
            //         slivers: [_sliverListUser()],
            //       )
            //     : widget.type.startsWith('Following')
            //         ? CustomScrollView(
            //             physics: const NeverScrollableScrollPhysics(),
            //             slivers: [_sliverListEvent()],
            //           )
            //         : CustomScrollView(
            //             physics: const NeverScrollableScrollPhysics(),
            //             slivers: [_sliverListEvent()],
            //           )

            ),
      ),
    );
  }

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
      showSeeAll: widgetType == 'Following' ? false : true,
      child: Container(
        height: height2.toDouble(),
        child: _display(context),
      ),
    );
  }
}
