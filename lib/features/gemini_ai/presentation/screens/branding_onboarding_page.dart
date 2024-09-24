import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

class BrandingOnboardingScreen extends StatefulWidget {
  @override
  _BrandingOnboardingScreenState createState() =>
      _BrandingOnboardingScreenState();
}

class _BrandingOnboardingScreenState extends State<BrandingOnboardingScreen> {
  PageController _pageController = PageController();
  TextEditingController _creativeStyleController = TextEditingController();
  TextEditingController _inspirationController = TextEditingController();
  TextEditingController _admiredWorkController = TextEditingController();
  TextEditingController _audiencePerceptionController = TextEditingController();
  TextEditingController _keyValuesController = TextEditingController();
  TextEditingController _currentBrandStatusController = TextEditingController();
  TextEditingController _satisfactionController = TextEditingController();
  TextEditingController _improvementController = TextEditingController();
  TextEditingController _marketingStrategiesController =
      TextEditingController();
  TextEditingController _promotionChannelsController = TextEditingController();
  TextEditingController _brandPersonalityController = TextEditingController();
  TextEditingController _toneOfVoiceController = TextEditingController();
  TextEditingController _visualElementsController = TextEditingController();
  TextEditingController _visualStyleController = TextEditingController();
  TextEditingController _feedbackController = TextEditingController();
  TextEditingController _brandDifferenceController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();
  TextEditingController _projectsController = TextEditingController();
  TextEditingController _clientsController = TextEditingController();
  TextEditingController _shortTermGoalsController = TextEditingController();
  TextEditingController _longTermGoalsController = TextEditingController();
  TextEditingController _targetAudienceController = TextEditingController();

  TextEditingController _brandVisionController = TextEditingController();

  bool _isLoadingSubmit = false;

  String _skillsSuggestion = '';
  String _creativeStyleSuggestion = '';
  String _inspirationSuggestion = '';
  String _admiredWorkSuggestion = '';
  String _audiencePerceptionSuggestion = '';
  String _keyValuesSuggestion = '';
  String _currentBrandStatusSuggestion = '';
  String _satisfactionSuggestion = '';
  String _improvementSuggestion = '';
  String _marketingStrategiesSuggestion = '';
  String _promotionChannelsSuggestion = '';
  String _brandPersonalitySuggestion = '';
  String _toneOfVoiceSuggestion = '';
  String _visualElementsSuggestion = '';
  String _visualStyleSuggestion = '';
  String _feedbackSuggestion = '';
  String _specificImprovementsSuggestion = '';
  String _projectsSuggestion = '';
  String _clientsSuggestion = '';
  String _shortTermGoalsSuggestion = '';
  String _longTermGoalsSuggestion = '';
  String _brandVisonSuggestion = '';

  String _targetAudienceSuggestion = '';

  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );

    setInitialValues();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var _provider = Provider.of<UserData>(context, listen: false);

      _provider.setInt1(
        _pageController.initialPage,
      );
    });
  }

  setInitialValues() {
    var _provider = Provider.of<UserData>(context, listen: false);

    _skillsController = TextEditingController(
      text: _provider.brandMatching?.skills,
    );

    _creativeStyleController = TextEditingController(
      text: _provider.brandMatching?.creativeStyle,
    );

    _inspirationController = TextEditingController(
      text: _provider.brandMatching?.inspiration,
    );

    _shortTermGoalsController = TextEditingController(
      text: _provider.brandMatching?.shortTermGoals,
    );

    _longTermGoalsController = TextEditingController(
      text: _provider.brandMatching?.longTermGoals,
    );
  }

  @override
  void dispose() {
    _creativeStyleController.dispose();
    _inspirationController.dispose();
    _admiredWorkController.dispose();
    _audiencePerceptionController.dispose();
    _keyValuesController.dispose();
    _currentBrandStatusController.dispose();
    _satisfactionController.dispose();
    _improvementController.dispose();
    _marketingStrategiesController.dispose();
    _promotionChannelsController.dispose();
    _brandPersonalityController.dispose();
    _toneOfVoiceController.dispose();
    _visualElementsController.dispose();
    _visualStyleController.dispose();
    _feedbackController.dispose();
    _brandDifferenceController.dispose();
    _skillsController.dispose();
    _projectsController.dispose();
    _clientsController.dispose();
    _shortTermGoalsController.dispose();
    _targetAudienceController.dispose();
    _longTermGoalsController.dispose();
    super.dispose();
  }

  _clear() {
    _creativeStyleController.clear();
    _inspirationController.clear();
    _admiredWorkController.clear();
    _audiencePerceptionController.clear();
    _keyValuesController.clear();
    _currentBrandStatusController.clear();
    _satisfactionController.clear();
    _improvementController.clear();
    _marketingStrategiesController.clear();
    _promotionChannelsController.clear();
    _brandPersonalityController.clear();
    _toneOfVoiceController.clear();
    _visualElementsController.clear();
    _visualStyleController.clear();
    _feedbackController.clear();
    _brandDifferenceController.clear();
    _skillsController.clear();
    _projectsController.clear();
    _clientsController.clear();
    _shortTermGoalsController.clear();
    _longTermGoalsController.clear();
    _targetAudienceController.clear();
  }

  final _googleGenerativeAIService = GoogleGenerativeAIService();

  // Future<void> _generateResponse(String prompt) async {
  //   final response = await _googleGenerativeAIService.generateResponse(prompt);
  //   setState(() {
  //     _skillsSuggestion = response!;
  //   });
  // }

  Future<void> _generateResponse(
      String prompt, Function(String) callback) async {
    try {
      final response =
          await _googleGenerativeAIService.generateResponse(prompt);
      setState(() {
        callback(response!);
      });
    } catch (error) {
      print('Error generating response: $error');
      // Handle the error, e.g., show an error message to the user
      setState(() {
        callback('Error generating response');
      });
    }
  }

  _sendBookingRequest() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    _showBottomSheetLoading('processing brand target');
    var _user = Provider.of<UserData>(context, listen: false).user;

    if (_isLoadingSubmit) {
      return;
    }
    if (mounted) {
      setState(() {
        _isLoadingSubmit = true;
      });
    }

    Future<T> retry<T>(Future<T> Function() function, {int retries = 3}) async {
      Duration delay =
          const Duration(milliseconds: 100); // Start with a short delay
      for (int i = 0; i < retries; i++) {
        try {
          return await function();
        } catch (e) {
          if (i == retries - 1) {
            // Don't delay after the last attempt
            rethrow;
          }
          await Future.delayed(delay);
          delay *= 2; // Double the delay for the next attempt
        }
      }
      throw Exception('Failed after $retries attempts');
    }

    String skills = _skillsController.text.trim();
    String projects = _projectsController.text.trim();
    String clients = _clientsController.text.trim();
    String shortTermGoals = _shortTermGoalsController.text.trim();
    String longTermGoals = _longTermGoalsController.text.trim();
    String creativeStyle = _creativeStyleController.text.trim();
    String inspiration = _inspirationController.text.trim();
    String admiredWork = '';
    String audiencePerception = '';
    String keyValues = '';
    String currentBrandStatus = '';
    String satisfaction = '';
    String improvement = '';
    String marketingStrategies = '';
    String promotionChannels = '';
    String brandPersonality = '';
    String toneOfVoice = '';
    String visualElements = '';
    String visualStyle = '';
    String feedback = '';
    String specificImprovements = '';

    await _generateResponse(
        'write a note on how a user can improve this skills, give examples: $skills',
        (suggestion) {
      _skillsSuggestion = suggestion;
    });

    // await _generateResponse(
    //     'write a note on similar projects the user can consider implementing, give examples: $projects',
    //     (suggestion) {
    //   _projectsSuggestion = suggestion;
    // });

    // await _generateResponse(
    //     'write a note on how a user can attract more similar clients, give examples: $clients',
    //     (suggestion) {
    //   _clientsSuggestion = suggestion;
    // });

    await _generateResponse(
        'write a note on how a user can reach the short term goal and give examples: $longTermGoals',
        (suggestion) {
      _targetAudienceSuggestion = suggestion;
    });

    await _generateResponse(
        'write a note on how a user can achive this long term goal and give examples: $longTermGoals',
        (suggestion) {
      _brandVisonSuggestion = suggestion;
    });

    await _generateResponse(
        'write a note on how a user can improve this creative style: $creativeStyle',
        (suggestion) {
      _creativeStyleSuggestion = suggestion;
    });

    await _generateResponse(
        'write a note on how a inspiration can find similar inspirations.: $inspiration',
        (suggestion) {
      _inspirationSuggestion = suggestion;
    });

    BrandMatchingModel _creativeBrandTarget = BrandMatchingModel(
      userId: _user!.userId!,
      skills: skills,
      creativeStyle: creativeStyle,
      inspiration: inspiration,
      shortTermGoals: shortTermGoals,
      longTermGoals: longTermGoals,
      matchReason: '',
      userName: _provider.user!.userName!,
      profileImageUrl: _provider.user!.profileImageUrl!,
      storeType: _provider.user!.storeType!,
      verified: _provider.user!.verified!,
    );

    Future<void> sendInvites() => DatabaseService.createBrandInfo(
          _creativeBrandTarget,
        );

    try {
      await retry(() => sendInvites(), retries: 3);
      _provider.setBrandMatching(_creativeBrandTarget);
      _clear();
      mySnackBar(context, "Brand identity successfully sent");

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      _showBottomSheetErrorMessage(context, 'Could not send brand identity');
    } finally {
      _endLoading();
    }
  }

  void _showBottomSheetErrorMessage(BuildContext context, String error) {
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
          title: error,
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  void _endLoading() {
    if (mounted) {
      setState(() {
        _isLoadingSubmit = false; // Set isLoading to false
      });
    }
  }

  void _showBottomSheetLoading(String text) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomModalLoading(
          title: text,
        );
      },
    );
  }

  void _showBottomConfirmBooking() {
    // String amount = _bookingAmountController.text;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 350,
          buttonText: 'Submit',
          onPressed: () async {
            // Navigator.pop(context);
            _sendBookingRequest();
          },
          title: 'Confirm brand style and target',
          subTitle:
              'This brand style and target would be used to improve your experience in the creative commmunity.',
        );
      },
    );
  }

  animateToPage(int index) {
    var _provider = Provider.of<UserData>(context, listen: false);

    print(_provider.int1);
    _pageController.page!.toInt() == 5
        ? _showBottomConfirmBooking()
        : _pageController.animateToPage(
            _pageController.page!.toInt() + index,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
  }

  animateToBack(int index) {
    if (mounted) {
      _pageController.animateToPage(
        _pageController.page!.toInt() - index,
        // Provider.of<UserData>(context, listen: false).int1 - index,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).secondaryHeaderColor),
        leading: IconButton(
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          iconSize: ResponsiveHelper.responsiveHeight(context, 30),
          color: Colors.grey,
          onPressed: () {
            _pageController.page == 0
                ? Navigator.pop(context)
                : animateToBack(1);
          },
        ),
        backgroundColor: Theme.of(context).cardColor,
        title: Text(''),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (int index) {
          _provider.setInt1(index);
        },
        children: [
          OnboardingInfoPage(
            onPressed: () {
              animateToPage(1);
            },
            title: 'Understanding Branding',
            content:
                'Branding is a critical aspect of your creative business. It encompasses your visual identity, your messaging, and how you connect with your audience. A strong brand helps you stand out in a crowded market and communicates your values and vision to your audience.\n\nBooks to read on personal branding:\n1. "Building a StoryBrand" by Donald Miller\n2. "Crushing It!" by Gary Vaynerchuk\n3. "The Brand Gap" by Marty Neumeier\n4. "Start with Why" by Simon Sinek\n\nThese books will provide you with a deeper understanding of how to create and maintain a strong personal brand.',
          ),
          GeminiOnboardingPage(
            onPressed: () {
              animateToPage(1);
            },
            title: 'How would you describe your creative style or aesthetic?',
            description:
                'Your creative professional style or aesthetic is what sets you apart from others. It includes elements like color schemes, techniques, and themes that make your work recognizable.\n Describe your creative style. What elements or themes are consistent in your work?"',
            textController: _creativeStyleController,
            hintText: 'Describe your unique creative style.',
            example: """
1.Blogger\n As a blogger, my creative style is centered around storytelling and visual imagery. I have a distinct editorial aesthetic, characterized by a muted color palette, clean typography, and a focus on capturing the emotional essence of my subject matter. Thematically, I often explore topics related to personal growth, mindfulness, and the human experience, aiming to inspire and connect with my audience through relatable narratives and authentic content.

2.Makeup Artist\n As a makeup artist, my creative style is bold, artistic, and heavily influenced by the world of fashion and high couture. I am known for my elaborate eye makeup designs, which often feature intricate patterns, jewel-toned pigments, and dramatic lashes. My work is also distinguished by a flawless base and a signature focus on sculpting and highlighting the features to achieve a striking, editorial-inspired look.

3.Instrumentalist\n As an instrumentalist, my creative style is characterized by a unique blend of technical mastery and emotive expression. Whether I'm performing classical pieces or improvising in a jazz setting, I aim to infuse my playing with a deep sense of passion and musicality. Thematically, my work often explores themes of human connection, the beauty of nature, and the power of storytelling through sound. I strive to create a captivating, immersive sonic experience for my audience.
         
          """,
          ),
          GeminiOnboardingPage(
              onPressed: () {
                animateToPage(1);
              },
              title: 'Inspirations',
              description:
                  'Who or what inspires your work? This could be other artists, nature, music, or anything that sparks your creativity."',
              textController: _inspirationController,
              hintText: 'Enter your inspirations here...',
              example: """
 1. I am inspired by the works of impressionist painters like Claude Monet, who were able to capture the fleeting beauty of natural light and color. I also find inspiration in the soundscapes created by ambient music composers.
 
2.  My creative inspirations come from a wide range of sources, including the geometric patterns found in architecture, the emotive power of classical music, and the raw energy of street art.

3.  I draw a lot of inspiration from the natural world, particularly the dramatic landscapes and vibrant colors of the American Southwest. I\'m also inspired by the rich cultural heritage and storytelling traditions of indigenous communities.'),
         
          """),
          GeminiOnboardingPage(
            onPressed: () {
              animateToPage(1);
            },
            title: 'Experience and Skills',
            description:
                'Please describe your skills and experience in your creative field. This information will help us understand your expertise and areas of specialization."',
            textController: _skillsController,
            hintText: 'Enter your skills and experience here...',
            example: """
1.  Grapher designer\n I have 7 years of experience in graphic design, with a focus on branding and digital marketing materials. I am highly proficient in Adobe Creative Cloud, particularly Photoshop, Illustrator, and InDesign. I also have experience in user interface (UI) design and am familiar with various design principles and best practices.
                
2.Music Artist\n  As a professional musician, I have 10 years of experience in the music industry. I am a skilled vocalist and multi-instrumentalist, proficient in playing the guitar, piano, and drums. I have a strong background in music theory and composition, and I have produced several albums and singles that have been well-received by critics and fans alike. I am also experienced in live performance, having toured extensively and performed at various music festivals and venues.

3.Dj\n  As a DJ and music producer, I have 8 years of experience in the electronic music scene. I am highly skilled in software like Ableton Live, Pro Tools, and Logic Pro, and I have a deep understanding of music production techniques, sound design, and audio engineering. I have a diverse music library spanning various genres, including house, techno, and bass music, and I am adept at reading crowds and creating dynamic, engaging sets that keep the dance floor packed. I have performed at renowned clubs and festivals, and my original productions have received support from leading DJs and radio stations.',
          
            """,
          ),
          GeminiOnboardingPage(
            onPressed: () {
              animateToPage(1);
            },
            title: 'Short-term Goals',
            description:
                'Please describe your short-term goals. These are the objectives you wish to achieve in the near future."',
            textController: _shortTermGoalsController,
            hintText: 'Enter your short-term goals here...',
            example: """
1.Host\n  As a host, my short-term goals include expanding my reach and building a stronger personal brand. In the next 12 months, I plan to launch my own podcast, where I can showcase my interviewing skills and engage with a wider audience. I also aim to secure more high-profile hosting gigs, such as emceeing for corporate events and award ceremonies, to further enhance my visibility and reputation within the industry.

2.Event Organizer\n   As an event organizer, my primary short-term goal is to diversify my client portfolio. Over the next year, I intend to actively pursue opportunities to plan and execute events for a broader range of industries, beyond my current focus on the tech and finance sectors. I also aim to explore new event formats and technologies to deliver more innovative and engaging experiences for my clients.

3.Caterer\n As a professional caterer, my short-term goals revolve around enhancing my service offerings and improving operational efficiency. In the next 12 months, I plan to expand my menu options to cater to a wider range of dietary requirements and preferences, including vegan, gluten-free, and halal options. I also aim to streamline my order management and logistics processes, leveraging technology and automation to ensure a seamless experience for my clients.
         
         """,
          ),
          GeminiOnboardingPage(
            onPressed: () {
              animateToPage(1);
            },
            title: 'Long-term Goals',
            description:
                'Please describe your long-term goals. These are the objectives you wish to achieve in the distant future."',
            textController: _longTermGoalsController,
            hintText: 'Enter your long-term goals here...',
            example: """
1.  In the next 5 years, my long-term goal is to transition from freelancing to running my own design studio. I aim to build a talented team and expand my services to include branding, packaging, and digital marketing solutions for small-to-medium-sized businesses.

2.  Over the next 5-10 years, I aspire to become a lead developer for a prominent technology company, where I can contribute to large-scale, enterprise-level projects and mentor junior developers. I also hope to earn industry certifications and become an active contributor to the open-source community.

3.  In the long term, my vision is to grow my digital marketing consultancy into a full-service agency that provides comprehensive solutions for clients across various industries. I aim to establish a strong reputation in the market and potentially expand to new geographic regions.',
          
            """,
          ),
        ],
      ),
    );
  }
}
