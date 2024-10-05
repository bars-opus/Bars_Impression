import 'package:bars/utilities/exports.dart';

class MoreAboutAccountTypes extends StatelessWidget {
  const MoreAboutAccountTypes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          TicketPurchasingIcon(
            title: '',
          ),
          RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(children: [
              TextSpan(
                text: "\n\nClient.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(
                text:
                    "\nClients are individuals who use the app to book services such as haircuts, massages, or other treatments.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: "\n\nShop.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(
                text:
                    "\nShops are service providers, such as barbershops, hair salons, and spas, that offer various services to clients.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: "\n\nWorker.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(
                text:
                    "\nWorkers are individuals who provide services within a shop, such as barbers, hairstylists, or therapists.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ]),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
