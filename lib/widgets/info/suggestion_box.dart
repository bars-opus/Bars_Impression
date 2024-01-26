import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class SuggestionBox extends StatefulWidget {
  static final id = 'SuggestionBox_screen';

  @override
  _SuggestionBoxState createState() => _SuggestionBoxState();
}

class _SuggestionBoxState extends State<SuggestionBox> {
  String _suggestion = '';
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
        Navigator.pop(context);
        mySnackBar(context, 'Thank You\nSuggestion submitted successfully.');
      } catch (e) {
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        mySnackBar(context, 'Request Failed\n$result.toString(),');
      }
      setState(() {
        _suggestion = '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return EditProfileScaffold(
      title: '',
      widget: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          height: width * 2,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Suggestion \nBox',
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 20.0),
                      ),
                      textAlign: TextAlign.center,
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
                      'This is how you can help Bars Impression become the best ecosystem for you and other event organizers and music creatives. We want to know what you think about our current efforts and how we can improve it.\nThank you.',
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ContentFieldBlack(
                  
                  onlyBlack: false,
                  labelText: "Tell us",
                  hintText: "How can we improve Bars Impression?",
                  initialValue: '',
                  onSavedText: (input) => _suggestion = input,
                  onValidateText: (suggestion) => suggestion!.isEmpty
                      ? 'Please suggest something'
                      : suggestion.length < 20
                          ? 'Not fewer than 20 characters'
                          : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: AlwaysWhiteButton(
                      buttonText: 'Send suggestion',
                      onPressed: () {
                        _submit();
                      },
                      buttonColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FeatureSurvey())),
                    child: Text(
                      'Take a survey',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(
                          context,
                          14,
                        ),
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
    );
  }
}
