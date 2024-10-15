/// `HopeIntroductionScreen` is a stateful widget that introduces users
/// to the platform's branding features. It provides an animated introduction
/// and detailed information about how the platform can assist in brand development.

import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

class HopeIntroductionScreen extends StatefulWidget {
  final bool isIntro;

  HopeIntroductionScreen({
    required this.isIntro,
  });

  @override
  _HopeIntroductionScreenState createState() => _HopeIntroductionScreenState();
}

class _HopeIntroductionScreenState extends State<HopeIntroductionScreen> {
  bool _animationComplete = false;

  // @override
  // void initState() {
  //   super.initState();

  //   SchedulerBinding.instance.addPostFrameCallback((_) async {
  //     Provider.of<UserData>(context, listen: false).setFlorenceActive(false);
  //   });
  // }

  /// Displays a section with a count, title, body, and suggestions.
  /// Uses animations to display suggestions.
  Widget _display(String count, String title, String body, String suggestions) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: ResponsiveHelper.responsiveHeight(context, 40),
              height: ResponsiveHelper.responsiveHeight(context, 40),
              child: Text(
                count,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        Text(
          body,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        // Text(
        //   "Suggestion:",
        //   style: Theme.of(context).textTheme.bodyLarge,
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 30.0),
        //   child: Column(children: [
        //     if (!_animationComplete)
        //       // Animates the suggestion text
        //       AnimatedTextKit(
        //         repeatForever: false,
        //         totalRepeatCount: 1,
        //         animatedTexts: [
        //           TyperAnimatedText(
        //             suggestions,
        //             textStyle: Theme.of(context).textTheme.bodyMedium,
        //           ),
        //         ],
        //         onFinished: () {
        //           setState(() {
        //             _animationComplete = true;
        //           });
        //         },
        //       ),
        //     if (_animationComplete)
        //       // Displays suggestions in Markdown format
        //       MarkdownBody(
        //         data: suggestions,
        //         styleSheet: MarkdownStyleSheet(
        //           h1: Theme.of(context).textTheme.titleLarge,
        //           h2: Theme.of(context).textTheme.titleMedium,
        //           p: Theme.of(context).textTheme.bodyMedium,
        //           listBullet: Theme.of(context).textTheme.bodySmall,
        //         ),
        //       ),
        //   ]),
        // ),
        const SizedBox(height: 20),
        Divider(
          color: Colors.grey,
          thickness: .5,
        ),
      ],
    );
  }

  /// Navigates to a new page.
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Displays a list of branding styles and suggestions using user data.
  /// Skips any entries where content or suggestion is empty and adjusts numbering.

  Widget _styles() {
    var provider = Provider.of<UserData>(context, listen: false);
    int displayIndex = 1;

    return ShakeTransition(
      curve: Curves.easeInOut,
      axis: Axis.vertical,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.edit),
              iconSize: ResponsiveHelper.responsiveHeight(context, 30),
              color: Colors.blue,
              onPressed: () {
                _navigateToPage(context, BrandingOnboardingScreen());
              },
            ),
          ),
          const SizedBox(height: 20),
          Divider(
            color: Colors.grey,
            thickness: .5,
          ),
          // Generates display widgets for each non-empty branding aspect
          ...List.generate(21, (index) {
            final widget = _buildDisplay(index + 1, provider, displayIndex);
            if (widget != null) displayIndex++;
            return widget;
          }).where((widget) => widget != null).cast<Widget>(),
        ],
      ),
    );
  }

  /// Builds the display widget based on the index, skipping if content or suggestion is empty.
  Widget? _buildDisplay(int index, UserData provider, int displayIndex) {
    String title;
    String content;
    String suggestion;

    switch (index) {
      case 1:
        title = 'Experience and Skills';
        content = provider.brandMatching!.skills;
        suggestion = '';
        // provider.brandMatching!.skillsSuggestion;
        break;
      case 2:
        title = 'Creative Style';
        content = provider.brandMatching!.creativeStyle;
        suggestion = '';

        //  provider.brandMatching!.projectsSuggestion;
        break;

      case 3:
        title = 'Inspiration';
        content = provider.brandMatching!.inspiration;
        suggestion = '';
        // provider.brandMatching!.creativeStyleSuggestion;
        break;
      case 4:
        title = 'Short-Term Goals';
        content = provider.brandMatching!.shortTermGoals;
        // suggestion = provider.brandMatching!.shortTermGoalsSuggestion;
        // provider.brandMatching!.inspirationSuggestion;
        break;
      case 5:
        title = 'Long-Term Goals';
        content = provider.brandMatching!.longTermGoals;
        // suggestion = provider.brandMatching!.longTermGoalsSuggestion;
        break;
      // case 6:
      //  title = 'Notable Projects';
      //   content = provider.brandMatching!.projects;
      //   suggestion = '';

      //   break;
      // case 5:
      //   title = 'Admired Work';
      //   content = provider.brandTarget!.admiredWork;
      //   suggestion = provider.brandTarget!.admiredWorkSuggestion;
      //   break;
      // case 6:
      //   title = 'Audience Perception';
      //   content = provider.brandTarget!.audiencePerception;
      //   suggestion = provider.brandTarget!.audiencePerceptionSuggestion;
      //   break;
      // case 7:
      //   title = 'Key Values';
      //   content = provider.brandTarget!.keyValues;
      //   suggestion = provider.brandTarget!.keyValuesSuggestion;
      //   break;
      // case 8:
      //   title = 'Current Brand Status';
      //   content = provider.brandTarget!.currentBrandStatus;
      //   suggestion = provider.brandTarget!.currentBrandStatusSuggestion;
      //   break;
      // case 9:
      //   title = 'Satisfaction';
      //   content = provider.brandTarget!.satisfaction;
      //   suggestion = provider.brandTarget!.satisfactionSuggestion;
      //   break;
      // case 10:
      //   title = 'Improvement';
      //   content = provider.brandTarget!.improvement;
      //   suggestion = provider.brandTarget!.improvementSuggestion;
      //   break;
      // case 11:
      //   title = 'Marketing Strategies';
      //   content = provider.brandTarget!.marketingStrategies;
      //   suggestion = provider.brandTarget!.marketingStrategiesSuggestion;
      //   break;
      // case 12:
      //   title = 'Promotion Channels';
      //   content = provider.brandTarget!.promotionChannels;
      //   suggestion = provider.brandTarget!.promotionChannelsSuggestion;
      //   break;
      // case 13:
      //   title = 'Brand Personality';
      //   content = provider.brandTarget!.brandPersonality;
      //   suggestion = provider.brandTarget!.brandPersonalitySuggestion;
      //   break;
      // case 14:
      //   title = 'Tone of Voice';
      //   content = provider.brandTarget!.toneOfVoice;
      //   suggestion = provider.brandTarget!.toneOfVoiceSuggestion;
      //   break;
      // case 15:
      //   title = 'Visual Elements';
      //   content = provider.brandTarget!.visualElements;
      //   suggestion = provider.brandTarget!.visualElementsSuggestion;
      //   break;
      // case 16:
      //   title = 'Visual Style';
      //   content = provider.brandTarget!.visualStyle;
      //   suggestion = provider.brandTarget!.visualStyleSuggestion;
      //   break;
      // case 17:
      //   title = 'Feedback';
      //   content = provider.brandTarget!.feedback;
      //   suggestion = provider.brandTarget!.feedbackSuggestion;
      //   break;
      // case 18:
      //   title = 'Specific Improvements';
      //   content = provider.brandTarget!.specificImprovements;
      //   suggestion = provider.brandTarget!.specificImprovementsSuggestion;
      //   break;
      // case 19:
      //   title = 'Clients';
      //   content = provider.brandTarget!.clients;
      //   suggestion = provider.brandTarget!.clientsSuggestion;
      //   break;

      default:
        return null;
    }

    if (content.isEmpty
        // && suggestion.isEmpty
        ) {
      return null;
    }

    return _display(
      displayIndex.toString(),
      title,
      content,
      '',
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserData>(
      context,
    );

    // 537c198b-e9d4-42b0-a1cd-f6c51b355a65

// Builds the greeting with an animated circle
    Widget _buildGreeting(BuildContext context) {
      return ShakeTransition(
        curve: Curves.easeInOut,
        axis: Axis.vertical,
        offset: -140,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hello ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 40.0),
              ),
            ),
            Center(
              child: AnimatedCircle(
                size: 70,
                animateSize: true,
                animateShape: true,
              ),
            ),
          ],
        ),
      );
    }

// Builds introduction text for new users
    Widget _buildIntroductionText(BuildContext context, UserData provider) {
      String introductionText1 = """
${provider.user!.userName}, it is me again Hope, your personal creative assistant. I'm here to help you set up your brand style, improve your skills, and connect with other creatives. Let's get started on your creative journey!
       """;

      String introductionText2 = """
Our key priority is to facilitate meaningful professional connections on our platform. While we have dedicated features to help creative professionals connect and discover new opportunities, we also cater to a wide range of other industries and backgrounds.

Our "Brand Target" functionality enables all professionals, regardless of their field, to connect with one another based on shared attributes such as skills, short-term goals, inspirations, and more. This helps to foster valuable networking opportunities.

When you attend an event through our platform, we leverage the "Brand Target" system to match you with other attendees who share common professional goals and interests. This streamlines the networking process, allowing you to easily identify and engage with like-minded individuals. Moreover, you can also utilize the "Brand Target" functionality to make meaningful connections with other professionals on our platform more broadly.

Furthermore, we leverage information about your short-term goals, long-term aspirations, brand vision, and areas for improvement to provide personalized recommendations and support for enhancing your professional brand and positioning.

The information you provide will be crucial in helping us connect you with the right opportunities, events, and collaborators to support your creative journey.

By taking the time to complete your brand style, you're empowering us to enhance your user experience and deliver more value. 
       """;

      String introductionText3 = """
1.   Match you with like-minded creatives for event attendance and networking
2.   Suggest workshops, mentorship, or other professional development resources
3.   Analyze your activity to identify any unmet needs or areas for improvement

We're committed to supporting the growth and success of our creative community.
       """;

      return ShakeTransition(
        curve: Curves.easeInOut,
        axis: Axis.vertical,
        child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
          text: TextSpan(
            children: [
              TextSpan(
                text: introductionText1,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '\nWhy brand matching?\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
                ),
              ),
              TextSpan(
                text: introductionText2,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '\nYour information will be used to:\n',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(
                text: introductionText3,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

// Builds text for existing users with brand targets
    Widget _buildExistingUserText(BuildContext context) {
      return Text(
        """
It is me, Hope, again. Last time we set up your brand target, and I have all the information here.

Currently, we use the skills, long-term goals, short-term goals, inspirations, and creative styles you've provided to match you with other creatives globally and specific creatives attending events you would also be attending. This makes it easy for you to network and grow your brand.
""",
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

// Builds the start button
    Widget _buildStartButton(BuildContext context) {
      return Center(
        child: ShakeTransition(
          axis: Axis.vertical,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
          child: BlueOutlineButton(
            buttonText: 'Let\'s Start',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrandingOnboardingScreen(),
                ),
              );
            },
          ),
        ),
      );
    }

// Builds the AppBar
    AppBar _buildAppBar(BuildContext context) {
      return AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorLight,
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildGreeting(context),
            const SizedBox(height: 40),
            provider.brandMatching == null
                ? _buildIntroductionText(context, provider)
                : _buildExistingUserText(context),
            if (!widget.isIntro && provider.brandMatching != null) _styles(),
            // if (provider.brandMatching != null) _styles(),
            const SizedBox(height: 40),
            if (provider.brandMatching == null) _buildStartButton(context),
            const SizedBox(height: 70),
            Center(
              child: Text(
                'Powered by Gemini',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
