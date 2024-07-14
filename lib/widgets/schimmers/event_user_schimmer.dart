import 'package:bars/utilities/exports.dart';

class EventAndUserScimmer extends StatelessWidget {
  late final String from;
  final bool showWithoutSegment;

  EventAndUserScimmer({
    required this.from,
    required this.showWithoutSegment,
  });

  _buildSchimmer(BuildContext context) {
    return Container(
      height: ResponsiveHelper.responsiveHeight(
        context,
        450,
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            4,
            (index) => EventAndUserScimmerSkeleton(
                  from: from,
                )),
      ),
    );
  }

  _buildSchimmer2(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            15,
            (index) => EventAndUserScimmerSkeleton(
                  from: from,
                )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return showWithoutSegment
        ? _buildSchimmer2(context)
        : ListView(
            children: List.generate(
                3,
                (index) => Container(
                      color: Theme.of(context).primaryColorLight,
                      height: ResponsiveHelper.responsiveHeight(
                        context,
                        600,
                      ),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Divider( thickness: .2,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Container(
                              height: ResponsiveHelper.responsiveHeight(
                                context,
                                550,
                              ),
                              // 550,
                              // color: Colors.red,
                              child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  RichText(
                                    textScaleFactor:
                                        MediaQuery.of(context).textScaleFactor,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Just a moment...\n",
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveHelper
                                                      .responsiveFontSize(context,
                                                          14.0),
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: from.startsWith('Event')
                                              ? 'Fetching upcoming events in your city, and country'
                                              : 'Fetching creatives in your city, country and continent',
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper
                                                .responsiveFontSize(
                                                    context, 12.0),
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildSchimmer(context),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
          );
  }
}
