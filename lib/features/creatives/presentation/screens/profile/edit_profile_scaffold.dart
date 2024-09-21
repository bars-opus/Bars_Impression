import 'package:bars/utilities/exports.dart';

class EditProfileScaffold extends StatelessWidget {
  final Widget widget;
  final String title;
  final bool cardColor;
  final Widget? action;

  const EditProfileScaffold(
      {super.key,
      required this.widget,
      this.action,
      required this.title,
      this.cardColor = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor
          ? Theme.of(context).cardColor
          : Theme.of(context).primaryColorLight,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: cardColor
            ? Theme.of(context).cardColor
            : Theme.of(context).primaryColorLight,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
        actions: action != null ? [action!] : null,
      ),
      body: SafeArea(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(child: widget)),
      ),
    );
  }
}
