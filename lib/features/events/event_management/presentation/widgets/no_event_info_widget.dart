import 'package:bars/utilities/exports.dart';

class NoEventInfoWidget extends StatelessWidget {
  final String from;
  final String specificType;
  final String liveLocation;
  final int liveLocationIntialPage;
  final bool isEvent;

  const NoEventInfoWidget(
      {super.key,
      required this.from,
      required this.specificType,
      required this.liveLocation,
      required this.liveLocationIntialPage,
      required this.isEvent});

  @override
  Widget build(BuildContext context) {
    String __specificTypeLowerCase = specificType.toLowerCase();
    String _specificType = __specificTypeLowerCase.isEmpty
        ? 'events'
        : __specificTypeLowerCase.endsWith('s')
            ? __specificTypeLowerCase
            : ' $__specificTypeLowerCase\s';
    return CategoryContainerEmpty(
      containerSubTitle: liveLocation.isNotEmpty
          ? 'At the moment, there are no $_specificType events in $liveLocation. We will keep you updated if new $_specificType become available. '
          : from.startsWith('Location')
              ? ''
              : from.isEmpty
                  ? 'At the moment, there are no $_specificType.  We will keep you updated if new $_specificType become available. '
                  : from.startsWith('by')
                      ? 'At the moment, there are no $_specificType $from.  We will keep you updated if new $_specificType become available. '
                      : 'At the moment, there are no $_specificType in $from.  We will keep you updated if new $_specificType become available. ',
      containerTitle: from.startsWith('Location')
          ? 'Explore $_specificType in live location'
          : from.isEmpty
              ? 'No $_specificType'
              : from.startsWith('by')
                  ? 'No $_specificType $from'
                  : 'No $_specificType in $from',
      height: from.startsWith('Location') ? 70 : 100,
      noLocation: false,
      liveLocation: from.startsWith('Location') ? true : false,
      liveLocationIntialPage: liveLocationIntialPage,
      isEvent: isEvent,
    );
  }
}
