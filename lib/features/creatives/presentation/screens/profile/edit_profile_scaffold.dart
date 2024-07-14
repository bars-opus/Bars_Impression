import 'package:bars/utilities/exports.dart';

class EditProfileScaffold extends StatelessWidget {
  final Widget widget;
  final String title;

  const EditProfileScaffold(
      {super.key, required this.widget, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(child: widget)),
      ),
    );
  }
}
