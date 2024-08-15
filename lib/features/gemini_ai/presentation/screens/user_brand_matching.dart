/// `UserBrandMatching` is a stateful widget that provides a tabbed view interface
/// for users to interact with different aspects of brand matching. Each tab
/// displays specific user matching information such as skills, goals, and inspirations.
/// The widget uses a `TabController` to manage the tabs and `TabBarView` to display
/// the corresponding content for each tab.

import 'package:bars/utilities/exports.dart';

class UserBrandMatching extends StatefulWidget {
  final String eventId;

  UserBrandMatching({required this.eventId});

  @override
  State<UserBrandMatching> createState() => _UserBrandMatchingState();
}

class _UserBrandMatchingState extends State<UserBrandMatching>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with 5 tabs
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      // Provide haptic feedback when tab changes
      if (!_tabController.indexIsChanging) {
        HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  void dispose() {
    // Dispose TabController to release resources
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserData>(context, listen: false);
    TextStyle style = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Colors.white,
    );

    return Container(
      color: Colors.transparent,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          // Clamp text scale factor for consistent UI
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3),
        ),
        child: DefaultTabController(
          length: 5,
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Theme.of(context).primaryColorLight,
                ),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text(
                  'Brand matching',
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 20.0),
                    color: Colors.white,
                  ),
                ),
                bottom: TabBar(
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
                    Text('skills', style: style),
                    Text('shortTermGoals', style: style),
                    Text('longTermGoals', style: style),
                    Text('creativeStyle', style: style),
                    Text('inspirations', style: style),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: List.generate(5, (index) {
                  // Create content for each tab
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: _buildTabViewContent(index, provider),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds the content for each tab based on its index
  Widget _buildTabViewContent(int index, UserData provider) {
    String tab;
    //  tabValue;

    switch (index) {
      case 0:
        tab = 'skills';
        // tabValue = provider.brandTarget!.skills.trim();
        break;
      case 1:
        tab = 'shortTermGoals';
        // tabValue = provider.brandTarget!.shortTermGoals.trim();
        break;
      case 2:
        tab = 'longTermGoals';
        // tabValue = provider.brandTarget!.longTermGoals.trim();
        break;
      case 3:
        tab = 'creativeStyle';
        // tabValue = provider.brandTarget!.creativeStyle.trim();
        break;
      case 4:
        tab = 'inspiration';
        // tabValue = provider.brandTarget!.inspiration.trim();
        break;
      default:
        tab = '';
      // tabValue = '';
    }

    return UserMatchings(
      eventId: widget.eventId,
      tab: tab,
      // tabValue: tabValue,
    );
  }
}
