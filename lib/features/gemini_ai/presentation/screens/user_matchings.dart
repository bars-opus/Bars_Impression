import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

/// The `UserMatchings` widget displays potential matches for user collaborations
/// based on specific criteria (e.g., skills, interests). It utilizes an AI service
/// to analyze and determine the compatibility between users for possible partnerships.

class UserMatchings extends StatefulWidget {
  static final id = 'UserMatchings';
  final String eventId;
  final String tab;

  UserMatchings({
    required this.eventId,
    required this.tab,
  });

  @override
  _UserMatchingsState createState() => _UserMatchingsState();
}

class _UserMatchingsState extends State<UserMatchings>
    with AutomaticKeepAliveClientMixin {
  List<BrandMatchingModel> _matcheList = [];
  int limit = 20;
  bool _isLoading = true;
  // bool _isFecthing = true;

  late ScrollController _hideButtonController;
  final _googleGenerativeAIService = GoogleGenerativeAIService();

  @override
  void initState() {
    super.initState();
    _hideButtonController = ScrollController();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      var _provider = Provider.of<UserData>(context, listen: false);

      if (_provider.brandMatching == null) {
        await _setBrandTarget();
      } else {
        _setUpAllMatchings();
      }

      if (!_isLoading && _provider.brandMatching != null) {
        _setUpAllMatchings();
      }
    });
  }

  Future<void> _setBrandTarget() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    BrandMatchingModel? brandTarget =
        await DatabaseService.getUserBrandInfoWithId(
      _provider.currentUserId!,
    );

    if (!mounted) return;

    setState(() {
      if (brandTarget != null) {
        _isLoading = false;
        _provider.setBrandMatching(brandTarget);
      } else {
        if (mounted) {
          _isLoading = false;
        }
        _navigateToPage(context, HopeIntroductionScreen(isIntro: true));
      }
    });
  }

  /// Sends batch requests to the AI service to analyze user summaries and determine matches.
  Future<List<String>> batchIsGoodMatchForQuery(List<String> summaries) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    BrandMatchingModel brand = _provider.brandMatching!;

    String brandValue = '';
    switch (widget.tab) {
      case 'skills':
        brandValue = brand.skills.trim();
        break;
      case 'shortTermGoals':
        brandValue = brand.shortTermGoals.trim();
        break;
      case 'longTermGoals':
        brandValue = brand.longTermGoals.trim();
        break;
      case 'creativeStyle':
        brandValue = brand.creativeStyle.trim();
        break;
      case 'inspiration':
        brandValue = brand.inspiration.trim();
        break;
      default:
        brandValue = '';
      // tabValue = '';
    }

    final batchPayload = summaries
        .map((summary) => {
              'prompt': '''
Analyze the two ${widget.tab} values and explain why these two users could be a match for possible collaboration:
1st user's ${widget.tab}: "${brandValue}"
2nd user's ${widget.tab}: "${summary}"
Provide a brief reason for the potential match.
'''
            })
        .toList();

    final responses = await Future.wait(batchPayload.map((payload) async {
      final response =
          await _googleGenerativeAIService.generateResponse(payload['prompt']!);
      return response!.trim();
    }));

    return responses;
  }

  /// Fetches and sets up all potential user matchings for the specified event.
  Future<void> _setUpAllMatchings() async {
    try {
    QuerySnapshot ticketOrderSnapShot = widget.eventId.isNotEmpty
        ? await newEventBrandMatchingRef
            .doc(widget.eventId)
            .collection('brandMatching')
            .limit(10)
            .get()
        : await newBrandMatchingRef.limit(10).get();

    List<BrandMatchingModel> matches = [];
    List<String> userSkills = [];
    List<DocumentSnapshot> docs = [];

    for (var doc in ticketOrderSnapShot.docs) {
      String userSkill = doc[widget.tab];

      userSkills.add(userSkill.trim());
      docs.add(doc);
    }

    List<String> matchResults = await batchIsGoodMatchForQuery(userSkills);

    for (int i = 0; i < matchResults.length; i++) {
      if (matchResults[i].toLowerCase().contains('match')) {
        BrandMatchingModel model = BrandMatchingModel.fromDoc(docs[i]);
        model.matchReason = matchResults[i];
        matches.add(model);
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        _matcheList = matches;
      });
    }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      mySnackBar(context, 'An error occured');
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  /// Builds a list view for displaying user matches.
  Widget _buildDonationBuilder(List<BrandMatchingModel> _donationList) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return ShakeTransition(
      axis: Axis.vertical,
      curve: Curves.easeInOut,
      child: Scrollbar(
        controller: _hideButtonController,
        child: CustomScrollView(
          controller: _hideButtonController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  BrandMatchingModel brandMatching = _donationList[index];

                  return Container(
                    margin: const EdgeInsets.all(1),
                    child: BrandMatchingWidget(
                      brandMatching: brandMatching,
                      currentUserId: _provider.currentUserId!,
                      tab: widget.tab,
                      // tabValue: widget.tabValue,
                    ),
                  );
                },
                childCount: _donationList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isLoading)
          Expanded(
            child: Center(
              child: Loading(
                shakeReapeat: false,
                color: Colors.white,
                title: 'processing...',
                icon: (FontAwesomeIcons.circle),
              ),
            ),
          )
        else if (_matcheList.isEmpty)
          Expanded(
            child: Center(
              child: NoContents(
                isFLorence: true,
                textColor: Colors.white,
                title: "",
                subTitle: _provider.brandMatching == null
                    ? """Hey, Provide your brand matching details and let\'s continue."""
                    : """Hey, There are no creatives that align with your brand identity at the moment.""",
                icon: null,
              ),
            ),
          )
        else
          Expanded(
            child: _buildDonationBuilder(_matcheList),
          ),
        SizedBox(height: 16),
      ],
    );
  }
}
