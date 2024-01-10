import 'package:bars/utilities/exports.dart';

class AroundTheWorldWidget extends StatelessWidget {
  const AroundTheWorldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 60,
          ),
          Text(
            "Around the world",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 30,
            height: 1,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
    
  }
}
