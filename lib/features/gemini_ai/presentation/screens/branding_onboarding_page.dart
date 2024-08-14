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

    // _admiredWorkController = TextEditingController(
    //   text: _provider.brandMatching?.admiredWork,
    // );

    // _audiencePerceptionController = TextEditingController(
    //   text: _provider.brandMatching?.audiencePerception,
    // );

    // _keyValuesController = TextEditingController(
    //   text: _provider.brandMatching?.keyValues,
    // );

    // _currentBrandStatusController = TextEditingController(
    //   text: _provider.brandMatching?.currentBrandStatus,
    // );

    // _satisfactionController = TextEditingController(
    //   text: _provider.brandMatching?.satisfaction,
    // );

    // _improvementController = TextEditingController(
    //   text: _provider.brandMatching?.improvement,
    // );

    // _marketingStrategiesController = TextEditingController(
    //   text: _provider.brandMatching?.marketingStrategies,
    // );

    // _promotionChannelsController = TextEditingController(
    //   text: _provider.brandMatching?.promotionChannels,
    // );

    // _brandPersonalityController = TextEditingController(
    //   text: _provider.brandMatching?.brandPersonality,
    // );

    // _toneOfVoiceController = TextEditingController(
    //   text: _provider.brandMatching?.toneOfVoice,
    // );

    // _visualElementsController = TextEditingController(
    //   text: _provider.brandMatching?.visualElements,
    // );

    // _visualStyleController = TextEditingController(
    //   text: _provider.brandMatching?.visualStyle,
    // );

    // _feedbackController = TextEditingController(
    //   text: _provider.brandMatching?.feedback,
    // );

    // _brandDifferenceController = TextEditingController(
    //   text: _provider.brandMatching?.specificImprovements,
    // );

    // _projectsController = TextEditingController(
    //   text: _provider.brandMatching?.projects,
    // );

    // _clientsController = TextEditingController(
    //   text: _provider.brandMatching?.clients,
    // );

    _shortTermGoalsController = TextEditingController(
      text: _provider.brandMatching?.shortTermGoals,
    );

    _longTermGoalsController = TextEditingController(
      text: _provider.brandMatching?.longTermGoals,
    );

    // _targetAudienceController = TextEditingController(
    //   text: _provider.brandMatching?.targetAudience,
    // );

    // _brandVisionController = TextEditingController(
    //   text: _provider.brandMatching?.brandVison,
    // );
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

    // await _generateResponse(
    //     'write a note on how a user can improve this admired work: $admiredWork',
    //     (suggestion) {
    //   _admiredWorkSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve this audience perception: $audiencePerception',
    //     (suggestion) {
    //   _audiencePerceptionSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve these key values: $keyValues',
    //     (suggestion) {
    //   _keyValuesSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve this current brand status: $currentBrandStatus',
    //     (suggestion) {
    //   _currentBrandStatusSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve this satisfaction: $satisfaction',
    //     (suggestion) {
    //   _satisfactionSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve this improvement: $improvement',
    //     (suggestion) {
    //   _improvementSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve these marketing strategies: $marketingStrategies',
    //     (suggestion) {
    //   _marketingStrategiesSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve these promotion channels: $promotionChannels',
    //     (suggestion) {
    //   _promotionChannelsSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve this brand personality: $brandPersonality',
    //     (suggestion) {
    //   _brandPersonalitySuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve this tone of voice: $toneOfVoice',
    //     (suggestion) {
    //   _toneOfVoiceSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve these visual elements: $visualElements',
    //     (suggestion) {
    //   _visualElementsSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve this visual style: $visualStyle',
    //     (suggestion) {
    //   _visualStyleSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve this feedback: $feedback',
    //     (suggestion) {
    //   _feedbackSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve these specific improvements: $specificImprovements',
    //     (suggestion) {
    //   _specificImprovementsSuggestion = suggestion;
    // });

    // await _generateResponse(
    //     'write a note on how a user can improve these short-term goals: $shortTermGoals',
    //     (suggestion) {
    //   _shortTermGoalsSuggestion = suggestion;
    // });
    // await _generateResponse(
    //     'write a note on how a user can improve these long-term goals: $longTermGoals',
    //     (suggestion) {
    //   _longTermGoalsSuggestion = suggestion;
    // });

    BrandMatchingModel _creativeBrandTarget = BrandMatchingModel(
      userId: _user!.userId!,
      skills: skills,
      // skillsSuggestion: _skillsSuggestion,
      creativeStyle: creativeStyle,
      inspiration: inspiration,
      // admiredWork: admiredWork,
      // audiencePerception: audiencePerception,
      // keyValues: keyValues,
      // currentBrandStatus: currentBrandStatus,
      // satisfaction: satisfaction,
      // improvement: improvement,
      // marketingStrategies: marketingStrategies,
      // promotionChannels: promotionChannels,
      // brandPersonality: brandPersonality,
      // toneOfVoice: toneOfVoice,
      // visualElements: visualElements,
      // visualStyle: visualStyle,
      // feedback: feedback,
      // specificImprovements: specificImprovements,
      // projects: projects,
      // clients: clients,
      shortTermGoals: shortTermGoals,
      longTermGoals: longTermGoals,
      matchReason: '',
      userName: _provider.user!.userName!,
      profileImageUrl: _provider.user!.profileImageUrl!,
      profileHandle: _provider.user!.profileHandle!,
      verified: _provider.user!.verified!,
      // creativeStyleSuggestion: _creativeStyleSuggestion,
      // inspirationSuggestion: _inspirationSuggestion,
      // satisfactionSuggestion: _satisfactionSuggestion,
      // admiredWorkSuggestion: _admiredWorkSuggestion,
      // audiencePerceptionSuggestion: _audiencePerceptionSuggestion,
      // keyValuesSuggestion: _keyValuesSuggestion,
      // marketingStrategiesSuggestion: _marketingStrategiesSuggestion,
      // improvementSuggestion: _improvementSuggestion,
      // currentBrandStatusSuggestion: _currentBrandStatusSuggestion,
      // toneOfVoiceSuggestion: _toneOfVoiceSuggestion,
      // specificImprovementsSuggestion: _specificImprovementsSuggestion,
      // brandPersonalitySuggestion: _brandPersonalitySuggestion,
      // promotionChannelsSuggestion: _promotionChannelsSuggestion,
      // visualElementsSuggestion: _visualElementsSuggestion,
      // visualStyleSuggestion: _visualStyleSuggestion,
      // feedbackSuggestion: _feedbackSuggestion,
      // projectsSuggestion: _projectsSuggestion,
      // clientsSuggestion: _clientsSuggestion,
      // shortTermGoalsSuggestion: _shortTermGoalsSuggestion,
      // longTermGoalsSuggestion: _longTermGoalsSuggestion,
      // targetAudience: '',
      // brandVison: '',
      // targetAudienceSuggestion: _targetAudienceSuggestion,
      // brandVisonSuggestion: _brandVisonSuggestion,
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

          //           GeminiOnboardingPage(
//             onPressed: () {
//               animateToPage(1);
//             },
//             title: 'Notable Projects',
//             description:
//                 'List some of your notable projects. This will give us an idea of the work you have done and your key achievements.',
//             textController: _projectsController,
//             hintText: 'Enter your notable projects here...',
//             example: """
// 1.Dancer\n  As a professional dancer, I have had the opportunity to work on several notable projects. Most recently, I was the lead choreographer and dancer for a sold-out arena tour, where I collaborated with the creative team to develop a visually stunning and engaging stage performance. I have also appeared in multiple music videos for chart-topping artists, showcasing my versatility in various dance styles, including contemporary, hip-hop, and ballroom. Additionally, I have been a featured performer at prestigious dance competitions and festivals, where I have won several awards and accolades for my technical skills and artistic expression..

// 2.Producer\n  As a music producer, I am proud to have worked on several high-profile projects. One of my most notable achievements was co-producing an album for a Grammy-nominated artist, which debuted at the top of the Billboard charts. I have also worked on the soundtracks for multiple independent films, collaborating closely with the directors and composers to create unique and impactful musical scores. Additionally, I have produced several remixes for popular electronic music artists, which have received support from leading DJs and record labels in the industry..

// 3.Photographer\n  As a professional photographer, I have had the privilege of working on a wide range of notable projects. One of my most recent achievements was being commissioned to photograph a series of editorial spreads for a renowned fashion magazine. This project allowed me to showcase my skills in fashion and portrait photography, as well as my ability to work closely with creative directors and stylists to bring their visions to life. I have also been commissioned to capture the behind-the-scenes moments of several high-profile music events and concerts, allowing me to hone my skills in live event photography and document the unique energy and atmosphere of these performances.

//          """,
//           ),
//           GeminiOnboardingPage(
//             onPressed: () {
//               animateToPage(1);
//             },
//             title: 'Clients',
//             description:
//                 'Mention any notable clients you have worked with. This will help us gauge the level of your professional experience.',
//             textController: _clientsController,
//             hintText: 'Enter your clients here...',
//             example: """
// 1. video vixen\n  As a video vixen, I have had the opportunity to work with some of the biggest names in the music industry. I have collaborated with award-winning artists such as XYZ Rapper, ABC Singer, and DEF Music Group, appearing in their high-profile music videos. My work has also been featured in leading publications like GHI Magazine and JKL Music Channel, which has helped to further enhance my reputation within the entertainment industry.

// 2.Influencer\n As a social media influencer, I have worked with a diverse range of brands and businesses to create engaging content and drive targeted marketing campaigns. Some of my notable clients include PQR Cosmetics, STU Fashion, and MNO Lifestyle, for whom I have created sponsored posts, Instagram stories, and video content that have consistently delivered strong engagement and conversion rates for their products and services.

// 3.Model\n As a professional model, I have had the privilege of working with renowned fashion and beauty brands, both locally and internationally. Some of my notable clients include ABC Apparel, XYZ Luxury Goods, and DEF Cosmetics, for whom I have modeled in print and digital campaigns, runway shows, and lookbook shoots. My work has also been featured in prestigious fashion publications like GHI Magazine and JKL Style Guide, further solidifying my standing within the modeling industry.

//        """,
//           ),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title: 'Admired Work',
//               description:
//                   'Describe some work by other creatives that you admire. What specifically do you like about it?"',
//               textController: _admiredWorkController,
//               hintText: 'Enter the work you admire here...',
//               example: """
// 1.  I greatly admire the photography of Ansel Adams for his ability to capture the grandeur and majesty of the natural world. I\'m particularly drawn to the way he used light and shadow to create a sense of depth and atmosphere in his images.

// 2.  I\'m in awe of the surreal and dreamlike illustrations of Remedios Varo, who was able to blend the fantastical and the mundane in such a captivating way. I admire her unique visual style and the way she used symbolism to explore themes of identity and the subconscious.

// 3.  I\'m a big fan of the abstract expressionist paintings of Jackson Pollock, who pioneered a new way of applying paint to the canvas. I\'m drawn to the sense of raw emotion and unbridled energy that his work evokes, and the way he was able to create such a powerful visual rhythm through his gestural brushstrokes.'

//            """),
//           GeminiOnboardingPage(
//             onPressed: () {
//               animateToPage(1);
//             },
//             title: 'What is your vision for your brand?',
//             description:
//                 'Your vision is a long-term goal or dream for your brand. It’s about where you see yourself in the future and what you want to achieve.',
//             textController: _brandVisionController,
//             hintText: 'Share your long-term vision for your brand.',
//             example: """

// 1.  My vision is to establish my brand as a trusted leader in the sustainable fashion industry, known for innovative and eco-friendly designs that inspire a more conscious approach to clothing.

// 2.  My long-term vision is to build a global community of artists and creators who use their work to promote positive social and environmental change.

// 3.  I envision my brand as a go-to destination for unique, handmade home decor that celebrates local craftsmanship and the beauty of natural materials.,

//          """,
//           ),
// //           GeminiOnboardingPage(
// //             onPressed: () {
// //               animateToPage(1);
// //             },
// //             title:
// //                 'What are your short-term and long-term goals for your brand?',
// //             description:
// //                 'Goals are specific, measurable objectives you want to achieve. Short-term goals might include launching a website, while long-term goals could be establishing a global presence.',
//           // textController: _shortTermGoalsController,
// //             hintText: 'List your short-term and long-term goals.',
// //             example: """
// // 1.  Launch a new collection of minimalist, zero-waste jewelry by the end of this year.

// // 2.  Expand my product line to include sustainable home goods and open a flagship store in a major city within the next 5 years.

// // 3.  Redesign my website to improve the user experience and increase online sales by 20% in the next 6 months.\n - Long-term goal: Establish partnerships with key retailers and distributors to grow my brand\'s reach and distribution nationally within the next 3 years.,

// //           """,
// //           ),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title: 'Who is your target audience?',
//               description:
//                   'Your target audience is the specific group of people you want to reach with your work. Understanding their demographics, interests, and behaviors helps tailor your messaging and marketing efforts.',
//               textController: _targetAudienceController,
//               hintText: 'Identify your ideal audience.',
//               example: """
// 1.  My target audience is eco-conscious millennials and Gen Z consumers who are interested in supporting brands with a strong focus on sustainability and ethical production.

// 2.  My ideal audience is young urban professionals aged 25-40 who value high-quality, handcrafted home decor that reflects their personal style and environmental values.

// 3.  I aim to reach creative, artistically-inclined individuals aged 18-35 who are passionate about supporting local makers and discovering unique, one-of-a-kind products.,

//            """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title: 'Audience Perception',
//               description:
//                   'How do you want your audience to perceive your work? What emotions or thoughts should your work evoke?"',
//               textController: _audiencePerceptionController,
//               hintText:
//                   'Enter how you want your audience to perceive your work here...',
//               example: """
// 1.  I want my audience to perceive my work as thoughtful, understated, and emotionally resonant. I aim to evoke a sense of calm, introspection, and appreciation for the beauty of simplicity.

// 2.  I want my audience to feel inspired, energized, and empowered by my designs. I want them to see my brand as bold, innovative, and dedicated to driving positive change through creativity.

// 3.  I want my audience to experience a sense of wonder and whimsy when engaging with my work. I strive to create pieces that spark the imagination and make people see the world in a new, more magical light.

//            """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title: 'How is your brand different from others in your field?',
//               description:
//                   'Brand differentiation is about what sets you apart from your competitors. It could be your unique style, exceptional quality, innovative approach, or anything that gives you a competitive edge.',
//               textController: _brandDifferenceController,

//               //  _audiencePerceptionCont,
//               hintText: 'Highlight what makes your brand unique.',
//               example: """,
// 1.  What sets my brand apart is our commitment to using 100% recycled and upcycled materials in all of our products. We\'re focused on creating high-quality, long-lasting designs that minimize waste and environmental impact.

// 2.  My brand\'s unique approach is to blend traditional craft techniques with modern, innovative design. This allows us to offer products that are both visually stunning and exceptionally well-made.\n - Example: The key differentiator for my brand is our dedication to radical transparency. We provide detailed information about our supply chain, manufacturing processes, and sustainability initiatives so customers can make informed choices.',
//           ),

//            """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title:
//                   'What are the key values or messages you want your brand to communicate?',
//               description: 'Define your brand’s core values and messages.',
//               textController: _keyValuesController,
//               hintText: 'Highlight the core values and messages of your brand.',
//               example: """
// 1.  The core values I want my brand to communicate are a commitment to sustainability, social responsibility, and supporting local artisans and makers.

// 2.  The key messages I want to convey with my brand are a sense of timeless elegance, a reverence for natural materials, and a celebration of thoughtful, intentional design.

// 3.  The overarching values I want my brand to embody are innovation, inclusivity, and a passion for empowering creatives to share their unique voices with the world.

//          """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title: 'Do you already have a brand identity in place?',
//               hintText: 'Tell us if you have an existing brand identity.',
//               description:
//                   'Having an existing brand identity means you already have elements like a logo, color scheme, and brand guidelines in place. This helps us understand your starting point.',
//               textController: _currentBrandStatusController,
//               example: """
// 1.  Yes, we have a brand identity in place, including a logo, a color palette, and a set of brand guidelines that inform our visual and messaging approach.

// 2.  No, we don\'t have an established brand identity yet. We\'re in the early stages of developing our visual branding and defining our brand\'s core personality and positioning.

// 3.  We have some elements of a brand identity in place, like a logo and basic brand colors, but we\'re looking to refine and expand our branding to better reflect our evolving vision and values.

//           """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title:
//                   'What aspects of your current brand identity are you satisfied with?',
//               hintText:
//                   'Share what you like about your current brand identity.',
//               description:
//                   'Identifying the strengths of your current brand identity helps us build on what’s already working well. It could be your visual design, tone of voice, or any other element you’re proud of.',
//               textController: _satisfactionController,
//               example: """
// 1.  We\'re very pleased with the clean, modern aesthetic of our current logo and website design. The visual identity effectively communicates our brand\'s focus on minimalism and sustainability.

// 2.  One of the strengths of our current brand identity is the warm, approachable tone of voice we\'ve developed. We feel it helps us connect authentically with our target audience and convey our brand\'s values.

// 3.  We\'re proud of the versatility and adaptability of our brand\'s color palette. The mix of earthy neutrals and vibrant accents works well across our product line and various marketing materials.

//         """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title:
//                   'What aspects of your current brand identity would you like to change or improve?',
//               hintText:
//                   'Identify areas for improvement in your brand identity.',
//               description:
//                   'Knowing what you want to change or improve in your brand identity helps us focus on areas that need enhancement. This could be anything from your logo to your marketing strategy.',
//               textController: _improvementController,
//               example: """,
// 1.  We would like to update our logo to better reflect our brand\'s evolution and the expanded product line. The current design feels a bit outdated.

// 2.  One area we\'d like to improve is our social media presence. Our Instagram and Facebook accounts feel scattered and lack a cohesive visual identity and content strategy.

// 3.  We\'re interested in revamping our brand\'s packaging design to be more sustainable and to better communicate our commitment to ethical production.

//          """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title: 'What marketing strategies have you tried so far?',
//               hintText: 'List the marketing strategies you’ve used.',
//               description:
//                   'Understanding the marketing strategies you’ve tried helps us see what has or hasn’t worked for you. This could include social media campaigns, email marketing, or other promotional efforts.',
//               textController: _marketingStrategiesController,
//               example: """,
// 1.  We\'ve experimented with a few different marketing strategies, including social media advertising, email marketing campaigns, and collaborations with relevant influencers.

// 2.  Our marketing efforts have primarily focused on content marketing, such as publishing blog posts and creating educational videos to showcase our products and brand values.

// 3.  In the past, we\'ve tried attending local craft fairs and pop-up markets to connect directly with potential customers, but we\'re looking to expand our digital marketing efforts.

//            """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title: 'Which channels do you use to promote your work?',
//               hintText: 'Specify the platforms you use for promotion.',
//               description:
//                   'Promotion channels are the platforms or methods you use to reach your audience. This could include social media, your website, events, or any other means of communication.',
//               textController: _promotionChannelsController,
//               example: """
// 1.   We promote our work through our website, Instagram, and Facebook. We\'ve also had success with showcasing our products at local design events and craft fairs.

// 2.  Our main promotional channels are our online shop, email newsletter, and YouTube channel, where we share product videos and behind-the-scenes content.

// 3.  In addition to our social media platforms (Instagram, Twitter, and LinkedIn), we also utilize our brick-and-mortar retail space to showcase our products and connect with customers in person.

//           """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title:
//                   'If your brand were a person, how would you describe its personality?',
//               hintText:
//                   'Describe your brand’s personality as if it were a person.',
//               description:
//                   'Your brand personality is the set of human characteristics associated with your brand. It influences the way you communicate and interact with your audience, making your brand more relatable.',
//               textController: _brandPersonalityController,
//               example: """
// 1.  If our brand were a person, they would be a warm, approachable, and creative individual who values ethical practices and sustainability. They would have a playful, adventurous spirit and a genuine passion for design.

// 2.  Our brand\'s personality would be that of a thoughtful, intellectual person who is deeply committed to innovation and pushing the boundaries of what\'s possible. They would be confident, well-spoken, and have a keen eye for aesthetics.

// 3.  If our brand were a person, they would be a friendly, down-to-earth character who is also highly ambitious and driven. They would have a strong sense of purpose and a desire to make a positive impact on the world.
//            """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title: 'What tone of voice do you want your brand to have?',
//               hintText: 'Define the tone of voice for your brand.',
//               description:
//                   'The tone of voice is the style in which you communicate with your audience. It could be professional, casual, humorous, or any other style that fits your brand’s personality.',
//               textController: _toneOfVoiceController,
//               example: """
// 1.  We want our brand\'s tone of voice to be warm, conversational, and approachable, with a touch of playfulness. We aim to communicate in a way that is informative and engaging, rather than overly formal or corporate.

// 2. The tone of voice we\'re aiming for is authoritative yet accessible, blending a sense of expertise with a relatable, human touch. We want to come across as knowledgeable and trustworthy, but also personable and empathetic.

// 3.  For our brand, we\'re going for a tone of voice that is passionate, enthusiastic, and bold. We want to convey a sense of excitement and energy, while still maintaining a professional and polished communication style.

//         """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title:
//                   'Do you have any visual elements already in use for your brand?',
//               hintText: 'Tell us about any existing visual elements.',
//               description:
//                   'Visual elements include your logo, color scheme, typography, and any other graphical components that represent your brand. These elements create a visual identity that helps people recognize your brand.',
//               textController: _visualElementsController,
//               example: """
// 1.   Yes, we have a logo, brand colors (a warm, earthy palette), and specific typography (a modern sans-serif font) that we use consistently across our marketing materials and website.

// 2.  We currently have a simple, minimalist logo, as well as a set of brand icons and illustrations that we\'ve been using. However, we\'re looking to refresh and expand our visual identity.

// 3.  At the moment, our visual branding consists of a hand-drawn logo and a few stock photography images we\'ve been using. We\'re interested in developing a more cohesive and intentional visual system.

//          """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title:
//                   'What kind of visual style do you envision for your brand?',
//               hintText: 'Describe the visual style you want for your brand.',
//               description:
//                   'Your envisioned visual style is about the look and feel you want your brand to have. It encompasses everything from colors and fonts to overall design aesthetics that align with your brand’s identity.',
//               textController: _visualStyleController,
//               example: """
// 1.  We envision a clean, modern, and sustainable visual style that uses natural materials and muted, earthy colors to reflect our brand\'s values and products.

// 2.  For our brand\'s visual style, we\'re aiming for a minimalist, elegant aesthetic with a focus on typography and simple, impactful graphics. We want to convey a sense of sophistication and attention to detail.

// 3.  The visual style we have in mind is playful, vibrant, and youthful, with a mix of hand-drawn elements and bold, colorful graphics. We want our brand to feel approachable and inspiring.

//           """),
//           GeminiOnboardingPage(
//               onPressed: () {
//                 animateToPage(1);
//               },
//               title:
//                   'Have you received any feedback on your brand identity from your audience or peers?',
//               hintText:
//                   'Share any feedback you’ve received on your brand identity.',
//               description:
//                   'Feedback from your audience or peers provides valuable insights into how your brand is perceived. It can highlight strengths and areas for improvement, guiding your brand development efforts.',
//               textController: _feedbackController,
//               example: """
// 1.  Yes, we\'ve received feedback from our customers that they appreciate the sustainability focus of our brand, but they\'ve mentioned that our website could use some improvements to enhance the user experience.

// 2.  Our peers have commented that our current branding feels a bit generic and doesn\'t fully capture the unique personality of our business. They\'ve encouraged us to develop a more distinctive and memorable visual identity.

// 3.  We\'ve heard from some of our audience that they find our brand messaging to be a bit too formal and serious. They\'ve suggested that we could benefit from a more conversational and relatable tone of voice.

//          """),
// //           GeminiOnboardingPage(
// //               onPressed: () {
// //                 animateToPage(1);
// //               },
// //               title:
// //                   'What specific areas of your brand identity are you looking to improve or develop further?',
// //               hintText: 'Identify the specific areas you want to work on.',
// //               description:
// //                   'Pinpointing specific areas for improvement helps us tailor our advice to your needs. Whether it’s your logo, messaging, or marketing strategy, focusing on these areas can enhance your overall brand identity.',
// //               textController: ,
// //               example: """
// // 1.  We\'re particularly interested in improving our online presence and developing a stronger digital marketing strategy, including a more cohesive and visually appealing website and social media platforms.

// // 2.  One area we\'d like to focus on is our product packaging design. We want to create packaging that better reflects our brand\'s commitment to sustainability and provides a more premium, elevated experience for our customers.

// // 3. We\'re looking to develop a more distinct and memorable brand persona, including refining our brand voice, messaging, and visual identity. This will help us stand out in our crowded market and better connect with our target audience.

// //      """),
        ],
      ),
    );
  }
}
