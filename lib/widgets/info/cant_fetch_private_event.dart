import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class CantFetchPrivateEvent extends StatelessWidget {
  final String body; 
  CantFetchPrivateEvent(
      { required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ResponsiveHelper.responsiveHeight(context, 350),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
            child: MyBottomModelSheetAction(actions: [
              const SizedBox(
                height: 40,
              ),
              Icon(
                Icons.lock_outline,
                color: Colors.red,
                size: ResponsiveHelper.responsiveHeight(context, 50),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Private Event',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              Text(
                body,
                // 'To maintain this event\'s privacy, the event\'s contents can only be accessed through the ticket or via your profile if you are the organizer.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              BottomModalSheetButtonBlue(
                dissable: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                buttonText: 'Ok',
              ),
            ])));
  }
}
