import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class FeatureSurvey extends StatefulWidget {
  static final id = 'FeatureSurvey_screen';

  @override
  _FeatureSurveyState createState() => _FeatureSurveyState();
}

class _FeatureSurveyState extends State<FeatureSurvey> {
  String _lessHelpfulFeature = '';
  String _mostHelpfulFeature = '';
  String _moreImprovement = '';
  String _overRallSatisfaction = '';
  String _suggestion = '';
  late PageController _pageController;
  int _index = 0;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _suggestionController = TextEditingController();

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  _submit() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });

      Survey survey = Survey(
        lessHelpfulFeature: _lessHelpfulFeature.isEmpty
            ? 'All of the above'
            : _lessHelpfulFeature,
        mostHelpfulFeature: _mostHelpfulFeature.isEmpty
            ? 'All of the above'
            : _mostHelpfulFeature,
        moreImprovement:
            _moreImprovement.isEmpty ? 'All of the above' : _moreImprovement,
        overRallSatisfaction: _overRallSatisfaction.isEmpty
            ? 'All of the above'
            : _overRallSatisfaction,
        suggesttion: _suggestion,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
        id: '',
      );
      try {
        DatabaseService.createSurvey(survey);
        final double width = MediaQuery.of(context).size.width;
        Navigator.pop(context);
        Flushbar(
          margin: EdgeInsets.all(8),
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Text(
            'Thank you',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            "Survey submitted successfully.",
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      } catch (e) {
        final double width = MediaQuery.of(context).size.width;
        Flushbar(
          margin: EdgeInsets.all(8),
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Text(
            'Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
        print(e.toString());
      }
      setState(() {
        _lessHelpfulFeature = '';
        _mostHelpfulFeature = '';
        _moreImprovement = '';
        _overRallSatisfaction = '';
        _suggestion = '';
        _isLoading = false;
      });
    }
  }

  static const moreImprovement = <String>[
    "Punch Mood",
    "Forum",
    "Event",
    "User Discover and Booking",
    "User rating",
    "All of the above",
  ];
  String selectedMoreImprovementValue = moreImprovement.last;

  Widget buildMoreImprovementRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: moreImprovement.map((moreImprovement) {
          final selected = this.selectedMoreImprovementValue == moreImprovement;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
            value: moreImprovement,
            groupValue: selectedMoreImprovementValue,
            title: Text(
              moreImprovement,
              style: TextStyle(color: color, fontSize: 14),
            ),
            activeColor: Colors.blue,
            onChanged: (moreImprovement) => setState(
              () {
                _moreImprovement =
                    this.selectedMoreImprovementValue = moreImprovement!;
              },
            ),
          );
        }).toList()),
      );
  static const mostHelpfulFeature = <String>[
    "Punch Mood",
    "Forum",
    "Event",
    "User Discover and Booking",
    "User rating",
    "All of the above",
  ];
  String selectedMostHelpfulValue = mostHelpfulFeature.last;

  Widget buildMoreHelpfulRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: mostHelpfulFeature.map((mostHelpfulFeature) {
          final selected = this.selectedMostHelpfulValue == mostHelpfulFeature;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
            value: mostHelpfulFeature,
            groupValue: selectedMostHelpfulValue,
            title: Text(
              mostHelpfulFeature,
              style: TextStyle(color: color, fontSize: 14),
            ),
            activeColor: Colors.blue,
            onChanged: (mostHelpfulFeature) => setState(
              () {
                _mostHelpfulFeature =
                    this.selectedMostHelpfulValue = mostHelpfulFeature!;
              },
            ),
          );
        }).toList()),
      );

  static const lessHelpfulFeature = <String>[
    "Punch Mood",
    "Forum",
    "Event",
    "User Discover and Booking",
    "User rating",
    "All of the above",
  ];
  String selectedLessHelpfulValue = lessHelpfulFeature.last;

  Widget buildLessHelpfulRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: lessHelpfulFeature.map((lessHelpfulFeature) {
          final selected = this.selectedLessHelpfulValue == lessHelpfulFeature;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
            value: lessHelpfulFeature,
            groupValue: selectedLessHelpfulValue,
            title: Text(
              lessHelpfulFeature,
              style: TextStyle(color: color, fontSize: 14),
            ),
            activeColor: Colors.blue,
            onChanged: (lessHelpfulFeature) => setState(
              () {
                _lessHelpfulFeature =
                    this.selectedLessHelpfulValue = lessHelpfulFeature!;
              },
            ),
          );
        }).toList()),
      );

  static const satisfaction = <String>[
    "Not Satisified",
    "Satisfied",
    "Very Satisfied",
    "Impressive",
  ];
  String selectedSatisfaction = satisfaction.last;

  Widget buildSatisfaction() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: satisfaction.map((satisfaction) {
          final selected = this.selectedSatisfaction == satisfaction;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
            value: satisfaction,
            groupValue: selectedSatisfaction,
            title: Text(
              satisfaction,
              style: TextStyle(color: color, fontSize: 14),
            ),
            activeColor: Colors.blue,
            onChanged: (satisfaction) => setState(
              () {
                _overRallSatisfaction =
                    this.selectedSatisfaction = satisfaction!;
              },
            ),
          );
        }).toList()),
      );

  animateBack() {
    _pageController.animateToPage(
      _index - 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
        appBar: AppBar(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn
                  ? Color(0xFFf2f2f2)
                  : Color(0xFF1a1a1a)),
          leading: IconButton(
              icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
              onPressed: () {
                _index != 0 ? animateBack() : Navigator.pop(context);
              }),
          automaticallyImplyLeading: true,
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: PageView(
              controller: _pageController,
              physics: AlwaysScrollableScrollPhysics(),
              onPageChanged: (int index) {
                setState(() {
                  _index = index;
                });
              },
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Container(
                      height: width * 2,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Center(
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                'Suggestion \nSurvey',
                                style: TextStyle(
                                    color: ConfigBloc().darkModeOn
                                        ? Color(0xFFf2f2f2)
                                        : Color(0xFF1a1a1a),
                                    fontSize: 40),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 2,
                            color: Colors.blue,
                            width: 10,
                          ),
                          ShakeTransition(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Text(
                                'We want to make Bars Impression the best ecosystem for you and other music creatives worldwide. We want to know what you think about our current effort.',
                                style: TextStyle(
                                    color: ConfigBloc().darkModeOn
                                        ? Color(0xFFf2f2f2)
                                        : Color(0xFF1a1a1a),
                                    fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          FadeAnimation(
                            0.5,
                            Swipinfo(
                              text: 'Swipe left',
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    child: Container(
                      height: width * 2,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DirectionWidget(
                              text:
                                  'Which of the features do you find more helpful?',
                              fontSize: 16,
                            ),
                            buildMoreHelpfulRadios(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: width * 2,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DirectionWidget(
                              text:
                                  'Which of the features do you find less helpful?',
                              fontSize: 16,
                            ),
                            buildLessHelpfulRadios(),
                          ]),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: width * 2,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DirectionWidget(
                              text:
                                  'Which of the feature needs more improvement?',
                              fontSize: 16,
                            ),
                            buildMoreImprovementRadios(),
                          ]),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: width * 2,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DirectionWidget(
                              text:
                                  'What is the overall satisfaction with Bars Impression?',
                              fontSize: 16,
                              
                            ),
                            buildSatisfaction(),
                          ]),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: width * 2,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DirectionWidget(
                              text: 'Kindly leave an advice for us',
                              fontSize: 16,
                            ),
                            SizedBox(height: 10),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              height: width / 2,
                              color: Colors.blue[200],
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: TextFormField(
                                    controller: _suggestionController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines:
                                        _suggestionController.text.length > 300
                                            ? 10
                                            : null,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    validator: (suggestion) =>
                                        suggestion!.isEmpty
                                            ? 'Kindly leave an advice'
                                            : null,
                                    onSaved: (input) => _suggestion = input!,
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'What do you think?...',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            FadeAnimation(
                              0.5,
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 60.0, bottom: 40),
                                  child: Container(
                                    width: 250.0,
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          primary: Colors.blue,
                                          side: BorderSide(
                                              width: 1.0, color: Colors.blue),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            'Submit Survey',
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        onPressed: _submit),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
