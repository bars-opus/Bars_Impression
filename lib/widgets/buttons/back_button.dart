import 'package:bars/utilities/exports.dart';

class BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  BackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      onPressed: onPressed,
    );
  }
}
