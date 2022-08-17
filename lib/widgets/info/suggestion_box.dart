import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class SuggestionBox extends StatefulWidget {
  static final id = 'SuggestionBox_screen';

  @override
  _SuggestionBoxState createState() => _SuggestionBoxState();
}

class _SuggestionBoxState extends State<SuggestionBox> {
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

      Suggestion suggestion = Suggestion(
        suggesttion: _suggestion,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: Timestamp.fromDate(DateTime.now()),
        id: '',
      );
      try {
        DatabaseService.createSuggestion(suggestion);
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
            'Thank You',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            "Suggestion submitted successfully.",
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
        _suggestion = '';
        _isLoading = false;
      });
    }
  }

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
                  Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back),
              onPressed: () {
                _index != 0 ? animateBack() : Navigator.pop(context);
              }),
          automaticallyImplyLeading: true,
          elevation: 0,
        ),
        body: Container(
          height: width * 2,
          width: double.infinity,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Center(
                    child: Hero(
                      tag: "suggestion",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          'Suggestion \nBox',
                          style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? Color(0xFFf2f2f2)
                                  : Color(0xFF1a1a1a),
                              fontSize: 40),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: Container(
                      height: 0.5,
                      color: Colors.blue,
                      width: 10,
                    ),
                  ),
                  ShakeTransition(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        'This is how you can help Bars Impression become the best ecosystem for you and other music creatives worldwide. We want to know what you think.',
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
                          maxLines: _suggestionController.text.length > 300
                              ? 10
                              : null,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (suggestion) => suggestion!.isEmpty
                              ? 'Please suggest something'
                              : suggestion.length < 20
                                  ? 'Not fewer than 20 characters'
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
                        padding: const EdgeInsets.only(top: 60.0, bottom: 60),
                        child: Container(
                          width: 250.0,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: Colors.blue,
                                side:
                                    BorderSide(width: 1.0, color: Colors.blue),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Submit Suggestion',
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
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => FeatureSurvey())),
                      child: Text(
                        'Take a survey',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
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
