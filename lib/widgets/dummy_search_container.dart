import 'package:bars/utilities/exports.dart';

class DummySearchContainer extends StatelessWidget {
  const DummySearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        height: ResponsiveHelper.responsiveHeight(context, 35),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: ResponsiveHelper.responsiveHeight(context, 20),
                color: Theme.of(context).secondaryHeaderColor,
              ),
              const SizedBox(
                width: 10,
              ),

              Text(
                'Search',
                style: Theme.of(context).textTheme.bodySmall,
              )
             
            ],
          ),
        ),
      ),
    );
  }
}
