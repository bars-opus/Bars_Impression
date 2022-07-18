import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class CreateForumWidget extends StatelessWidget {
  String title = '';
  String subTitle = '';
  final String appBarTitle;
  final String buttonText;
  String initialTitle = '';
  String initialSubTitle = '';
  final Widget loadingWidget;
  final Widget pageHint;
  final VoidCallback onPressedSubmite;
  final Widget deletWidget;
  final Function(String) onSavedTitle;
  final Function(String) onValidateTitle;
  final Function(String) onValidatesubTitle;
  final Function(String) onSavedSubTitle;

  CreateForumWidget({
    required this.title,
    required this.subTitle,
    required this.buttonText,
    required this.onSavedSubTitle,
    required this.onPressedSubmite,
    required this.loadingWidget,
    required this.deletWidget,
    required this.appBarTitle,
    required this.onSavedTitle,
    required this.onValidateTitle,
    required this.onValidatesubTitle,
    required this.initialSubTitle,
    required this.initialTitle,
    required this.pageHint,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          title: Material(
            color: Colors.transparent,
            child: Text(
              appBarTitle,
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  ContentField(
                    labelText: 'Topic',
                    hintText: "Enter the topic of your forum",
                    initialValue: initialTitle,
                    onSavedText: onSavedTitle,
                    onValidateText: onValidateTitle,
                  ),
                  ContentField(
                    labelText: 'Summary',
                    hintText: "Enter a summary of your blog",
                    initialValue: initialSubTitle,
                    onSavedText: onSavedSubTitle,
                    onValidateText: onValidatesubTitle,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  AvatarCircularButton(
                    onPressed: onPressedSubmite,
                    buttonText: buttonText,
                  ),
                  deletWidget,
                  SizedBox(
                    height: 10.0,
                  ),
                  pageHint,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
