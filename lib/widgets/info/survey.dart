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
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: Timestamp.fromDate(DateTime.now()),
        id: '',
      );
      try {
        DatabaseService.createSurvey(survey);
        Navigator.pop(context);
        mySnackBar(context, 'Thank You\nSurvey submitted successfully.');
      } catch (e) {
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        mySnackBar(context, 'Request Failed\n$result.toString(),');
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
    "Event mangement",
    "Ticket generation",
    "Creative discovery and booking",
    "Work request",
    "Event room",
    "Calendar and reminders",
    "All of the above",
  ];
  String selectedMoreImprovementValue = moreImprovement.last;

  Widget buildMoreImprovementRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Column(
            children: moreImprovement.map((moreImprovement) {
          final selected = this.selectedMoreImprovementValue == moreImprovement;
          final color =
              selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

          return RadioListTile<String>(
            value: moreImprovement,
            groupValue: selectedMoreImprovementValue,
            title: Text(
              moreImprovement,
              style: TextStyle(
                color: color,
                fontSize: ResponsiveHelper.responsiveFontSize(
                  context,
                  14,
                ),
              ),
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
    "Event mangement",
    "Ticket generation",
    "Creative discovery and booking",
    "Work request",
    "Event room",
    "Calendar and reminders",
    "All of the above",
  ];
  String selectedMostHelpfulValue = mostHelpfulFeature.last;

  Widget buildMoreHelpfulRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Column(
            children: mostHelpfulFeature.map((mostHelpfulFeature) {
          final selected = this.selectedMostHelpfulValue == mostHelpfulFeature;
          final color =
              selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

          return RadioListTile<String>(
            value: mostHelpfulFeature,
            groupValue: selectedMostHelpfulValue,
            title: Text(
              mostHelpfulFeature,
              style: TextStyle(
                color: color,
                fontSize: ResponsiveHelper.responsiveFontSize(
                  context,
                  14,
                ),
              ),
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
    "Event mangement",
    "Ticket generation",
    "Creative discovery and booking",
    "Work request",
    "Event room",
    "Calendar and reminders",
    "All of the above",
  ];
  String selectedLessHelpfulValue = lessHelpfulFeature.last;

  Widget buildLessHelpfulRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Column(
            children: lessHelpfulFeature.map((lessHelpfulFeature) {
          final selected = this.selectedLessHelpfulValue == lessHelpfulFeature;
          final color =
              selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

          return RadioListTile<String>(
            value: lessHelpfulFeature,
            groupValue: selectedLessHelpfulValue,
            title: Text(
              lessHelpfulFeature,
              style: TextStyle(
                color: color,
                fontSize: ResponsiveHelper.responsiveFontSize(
                  context,
                  14,
                ),
              ),
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
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Column(
            children: satisfaction.map((satisfaction) {
          final selected = this.selectedSatisfaction == satisfaction;
          final color =
              selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

          return RadioListTile<String>(
            value: satisfaction,
            groupValue: selectedSatisfaction,
            title: Text(
              satisfaction,
              style: TextStyle(
                color: color,
                fontSize: ResponsiveHelper.responsiveFontSize(
                  context,
                  14,
                ),
              ),
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        leading: IconButton(
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
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
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                  context,
                                  40,
                                ),
                              ),
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
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                  context,
                                  12,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ShakeTransition(
                          child: Text(
                            "< < <  Swipe",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                context,
                                14,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // Swipinfo(
                          //   text: 'Swipe left',
                          //   color: Colors.blue,
                          // ),
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
                            fontSize: ResponsiveHelper.responsiveFontSize(
                              context,
                              16,
                            ),
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
                            fontSize: ResponsiveHelper.responsiveFontSize(
                              context,
                              16,
                            ),
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
                            fontSize: ResponsiveHelper.responsiveFontSize(
                              context,
                              16,
                            ),
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
                            fontSize: ResponsiveHelper.responsiveFontSize(
                              context,
                              16,
                            ),
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
                            height: ResponsiveHelper.responsiveHeight(
                              context,
                              200,
                            ),
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
                                  validator: (suggestion) => suggestion!.isEmpty
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
                          ShakeTransition(
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 60.0, bottom: 40),
                                child: Container(
                                  width: ResponsiveHelper.responsiveHeight(
                                    context,
                                    250,
                                  ),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.blue,
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
    );
  }
}
