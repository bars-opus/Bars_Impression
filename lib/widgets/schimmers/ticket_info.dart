import 'package:bars/utilities/exports.dart';

class TicketInfo extends StatelessWidget {
  // final Event event;
  // final TicketModel finalPurchasintgTicket;

  final String label;
  final String value;
  final String position;

  TicketInfo({
    // required this.event,
    // required this.finalPurchasintgTicket,
    required this.label,
    required this.value,
    required this.position,
  });

  _packageInfoContainer(BuildContext context, Widget child, String position) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0.5),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight.withOpacity(.6),
              borderRadius: position.startsWith('First')
                  ? BorderRadius.only(
                      bottomRight: Radius.circular(0.0),
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(0.0),
                      topLeft: Radius.circular(10.0),
                    )
                  : position.startsWith('Last')
                      ? BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          topRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(10.0),
                          topLeft: Radius.circular(0.0),
                        )
                      : BorderRadius.only(
                          bottomRight: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0.0),
                          topLeft: Radius.circular(0.0),
                        )),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var _textStyle = TextStyle(
    //   fontSize:  ResponsiveHelper.responsiveFontSize(context, 12.0),
    //   color: Colors.grey,
    // );
    return Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight.withOpacity(.6),
                  borderRadius: position.startsWith('First')
                      ? BorderRadius.only(
                          bottomRight: Radius.circular(0.0),
                          topRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(0.0),
                          topLeft: Radius.circular(10.0),
                        )
                      : position.startsWith('Last')
                          ? BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(0.0),
                            )
                          : BorderRadius.only(
                              bottomRight: Radius.circular(0.0),
                              topRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0),
                              topLeft: Radius.circular(0.0),
                            )),
              width: ResponsiveHelper.responsiveWidth(context, 110),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            _packageInfoContainer(
                context,
                Padding(
                  padding: const EdgeInsets.all(10.5),
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                position),
          ],
        ));
  }
}
