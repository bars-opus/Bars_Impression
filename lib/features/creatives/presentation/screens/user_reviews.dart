import 'package:bars/utilities/exports.dart';

class UserReviews extends StatefulWidget {
  final String currentUserId;

  UserReviews({
    required this.currentUserId,
  });

  @override
  State<UserReviews> createState() => _UserReviewsState();
}

class _UserReviewsState extends State<UserReviews>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
        child: DefaultTabController(
          length: 2,
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).primaryColorLight,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: AppBar(
                  automaticallyImplyLeading: true,
                  iconTheme: IconThemeData(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  elevation: 0.0,
                  backgroundColor: Theme.of(context).primaryColorLight,
                  primary: false,
                  title: Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  bottom: TabBar(
                    onTap: (index) {
                      // _searchController.text.trim().isNotEmpty
                      //     ? _search()
                      //     : null;
                    },
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    labelColor: Theme.of(context).secondaryHeaderColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabAlignment: TabAlignment.center,
                    isScrollable: true,
                    labelPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
                    indicatorWeight: 2.0,
                    tabs: <Widget>[
                      Text(
                        style: Theme.of(context).textTheme.bodyMedium,
                        'Made',
                      ),
                      Text(
                        style: Theme.of(context).textTheme.bodyMedium,
                        'received',
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  ReviewMadeReceiver(
                    userId: widget.currentUserId,
                    isDonar: true,
                  ),
                  ReviewMadeReceiver(
                    userId: widget.currentUserId,
                    isDonar: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
