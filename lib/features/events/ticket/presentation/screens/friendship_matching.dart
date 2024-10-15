import 'package:bars/features/events/ticket/presentation/widgets/friendship_matching_widgets.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

/// The `FriendshipMatchings` widget displays potential matches for user collaborations
/// based on specific criteria (e.g., skills, interests). It utilizes an AI service
/// to analyze and determine the compatibility between users for possible partnerships.

class FriendshipMatchings extends StatefulWidget {
  static final id = 'FriendshipMatchings';
  final String eventId;
  final String goal;

  FriendshipMatchings({
    required this.eventId,
    required this.goal,
  });

  @override
  _FriendshipMatchingsState createState() => _FriendshipMatchingsState();
}

class _FriendshipMatchingsState extends State<FriendshipMatchings>
    with AutomaticKeepAliveClientMixin {
  List<UserFriendshipModel> _matcheList = [];
  int limit = 20;
  bool _isLoading = true;
  // bool _isFecthing = true;

  late ScrollController _hideButtonController;
  final _googleGenerativeAIService = GoogleGenerativeAIService();

  @override
  void initState() {
    super.initState();
    _hideButtonController = ScrollController();

    _setUpAllMatchings();
  }

  /// Sends batch requests to the AI service to analyze user summaries and determine matches.
  Future<List<String>> batchIsGoodMatchForQuery(List<String> summaries) async {
    final batchPayload = summaries
        .map((summary) => {
              'prompt': '''
Analyze these two networking goals and values and explain why these two users could be a match for possible collaboration:
1st user's goal: "${widget.goal}"
2nd user's goal: "${summary}"
Provide a brief reason for potential collaboration.
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

  Future<void> _setUpAllMatchings() async {
    try {
      QuerySnapshot ticketOrderSnapShot = await newEventTicketOrderRef
          .doc(widget.eventId)
          .collection('ticketOrders')
          .limit(30)
          .get();

      List<String> goalsToCompare = [];
      List<DocumentSnapshot> docs = [];

      for (var doc in ticketOrderSnapShot.docs) {
        String networkingGoal = await doc['networkingGoal'];
        goalsToCompare.add(networkingGoal.trim());
        docs.add(doc);
      }

      List<String> matchResults =
          await batchIsGoodMatchForQuery(goalsToCompare);
      List<UserFriendshipModel> matches = [];
      print(matchResults);

      for (int i = 0; i < matchResults.length; i++) {
        if (matchResults[i].toLowerCase().contains('match')) {
          DocumentSnapshot doc = docs[i];
          String userOrderId = doc['userOrderId'];
          String networkingGoal = doc['networkingGoal'];

          AccountHolderAuthor? user =
              await DatabaseService.getUserWithId(userOrderId);

          if (user != null) {
            print('Creating model for user: ${user.userName}');
            UserFriendshipModel model = UserFriendshipModel(
              userId: user.userId ?? '',
              userName: user.userName ?? '',
              profileImageUrl: user.profileImageUrl ?? '',
              verified: user.verified ?? false,
              profileHandle: user.profileHandle ?? '',
              matchReason: matchResults[i],
              bio: user.bio ?? '',
              dynamicLink: user.dynamicLink ?? '',
              goal: networkingGoal,
            );

            matches.add(model);
            print('Model added: ${model.userName}');
          } else {
            print('User not found for userOrderId: $userOrderId');
          }
        }
      }

      // for (int i = 0; i < matchResults.length; i++) {
      //   if (matchResults[i].toLowerCase().contains('match')) {
      //     DocumentSnapshot doc = await docs[i];
      //     String userOrderId = await doc['userOrderId'];
      //     String networkingGoal = await doc['networkingGoal'];

      //     AccountHolderAuthor? user =
      //         await DatabaseService.getUserWithId(userOrderId);

      //     if (user != null) {
      //       // Create a new UserFriendshipModel
      //       UserFriendshipModel model = await UserFriendshipModel(
      //         userId: user.userId ?? '',
      //         userName: user.userName ?? '',
      //         profileImageUrl: user.profileImageUrl ?? '',
      //         verified: user.verified ?? false,
      //         profileHandle: user.profileHandle ?? '',
      //         matchReason: matchResults[i],
      //         bio: user.bio ?? '',
      //         dynamicLink: user.dynamicLink ?? '',
      //         goal: networkingGoal,
      //       );

      //       matches.add(model);
      //     }
      //   }
      // }

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
      mySnackBar(context, 'An error occurred');
    }
  }

  // void _navigateToPage(BuildContext context, Widget page) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (_) => page),
  //   );
  // }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  /// Builds a list view for displaying user matches.
  Widget _buildDonationBuilder(List<UserFriendshipModel> _donationList) {
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
                  UserFriendshipModel friendshipMatching = _donationList[index];

                  return Container(
                    margin: const EdgeInsets.all(1),
                    child: FriendshipMatchingWidget(
                      friendshipMatching: friendshipMatching,
                      currentUserId: _provider.currentUserId!,
                      // tab: widget.goal,
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Column(
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
                  subTitle:
                      """Hey, There are no creatives that align with your frienship goal at the moment.""",
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
      ),
    );
  }
}
