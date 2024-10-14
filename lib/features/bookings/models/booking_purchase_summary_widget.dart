import 'package:bars/utilities/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BookingSummaryWidget extends StatefulWidget {
  final String currency;
  final BookingAppointmentModel appointmentOrder;
  final bool edit;

  BookingSummaryWidget({
    Key? key,
    required this.currency,
    required this.edit,
    required this.appointmentOrder,
  }) : super(key: key);

  @override
  State<BookingSummaryWidget> createState() => _BookingSummaryWidgetState();
}

class _BookingSummaryWidgetState extends State<BookingSummaryWidget> {
  _removeAppointment(BookedAppointmentModel appointmentTicket) async {
    widget.appointmentOrder.appointment
        .removeWhere((appointment) => appointment.id == appointmentTicket.id);
  }

  _launchMap(String address) {
    return MapsLauncher.launchQuery(address);
  }

  _payoutWidget(String lable, String value) {
    return PayoutDataWidget(
      label: lable,
      value: value,
      text2Ccolor: Colors.black,
    );
  }

  _totalWidget(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // color: Colors.red,
          width: ResponsiveHelper.responsiveWidth(context, 90),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }

  var divider = Divider(
    thickness: .2,
  );

  TimeOfDay addDuration(TimeOfDay time, Duration duration) {
    final now = DateTime.now();
    final fullDate =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final newDate = fullDate.add(duration);
    return TimeOfDay(hour: newDate.hour, minute: newDate.minute);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> currencyPartition =
        widget.currency.trim().replaceAll('\n', ' ').split("|");

    var _provider = Provider.of<UserData>(context, listen: false);
    var _provider2 = Provider.of<UserData>(
      context,
    );

    double _total = widget.appointmentOrder == null
        ? 0.00
        : widget.appointmentOrder!.appointment.fold(
            0.0,
            (double sum, BookedAppointmentModel appointment) =>
                sum + appointment.price);

    double _totalAmount = _total + 2;

    // Create a list of TicketInfo widgets from the ticket list
    List<Widget> ticketInfoWidgets = widget.appointmentOrder == null
        ? []
        : widget.appointmentOrder.appointment.map((finalAppointment) {
            TimeOfDay startSlot = finalAppointment.selectedSlot!;
            TimeOfDay endSlot = addDuration(startSlot,
                DurationUtils.parseDuration(finalAppointment.duruation));
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        finalAppointment.type,
                        style: TextStyle(
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 14),
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      if (widget.edit)
                        GestureDetector(
                            onTap: () {
                              _removeAppointment(finalAppointment);
                              // _provider
                              //     .removeBookedAppointment(finalAppointment.id);
                            },
                            child: Icon(
                              Icons.remove,
                              color: Colors.red,
                            )),
                    ],
                  ),
                  Text(
                    '${startSlot.format(context)}   -  ${endSlot.format(context)}',
                    // '${finalAppointment.selectedSlot}    --->   end ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  divider,
                  _payoutWidget(
                    'Duration',
                    finalAppointment.duruation,
                  ),
                  divider,
                  _payoutWidget(
                    'Service',
                    finalAppointment.service,
                  ),
                  divider,
                  _payoutWidget(
                    'Type',
                    finalAppointment.type,
                  ),
                  divider,
                  _payoutWidget(
                    'Price',
                    '${currencyPartition.isEmpty ? '' : currencyPartition.length > 1 ? currencyPartition[1] : ''} ${finalAppointment.price}',
                    // finalAppointment.price.toString(),
                  ),
                  divider,
                  Container(
                    padding: EdgeInsets.all(
                        ResponsiveHelper.responsiveWidth(context, 2)),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                    child: ShedulePeopleHorizontal(
                      edit: false,
                      workers: finalAppointment.workers,
                      //  _provider.appointmentWorkers,
                      currentUserId: _provider.currentUserId!,
                    ),
                  ),
                ],
              ),
            );
          }).toList();

    // Use a SingleChildScrollView to make sure the list is scrollable if it's too long
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        // height: ResponsiveHelper.responsiveHeight(context, 400),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(20)),
        child: widget.appointmentOrder == null
            ? SizedBox.shrink()
            : Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  if (!widget.edit)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    currentUserId: _provider.currentUserId!,
                                    userId: widget.appointmentOrder.shopId,
                                    user: null,
                                    accountType: 'Shop',
                                  )),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.appointmentOrder!.shopLogoUrl.isEmpty
                              ? const Icon(
                                  Icons.account_circle,
                                  size: 40.0,
                                  color: Colors.grey,
                                )
                              : CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.blue,
                                  backgroundImage: CachedNetworkImageProvider(
                                      widget.appointmentOrder!.shopLogoUrl,
                                      errorListener: (_) {
                                    return;
                                  }),
                                ),
                          SizedBox(
                            width:
                                ResponsiveHelper.responsiveWidth(context, 10.0),
                          ),
                          RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.appointmentOrder!.shopName
                                      .replaceAll('\n', ' '),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextSpan(
                                  text: '\n${widget.appointmentOrder.shopType}',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 12),
                                  ),
                                )
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Text(
                          //  appointmentOrder!.shopName
                          //       .replaceAll('\n', ' '),
                          //   style: Theme.of(context).textTheme.bodyMedium,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                        ],
                      ),
                    ),
                  // Text(
                  //  appointmentOrder!.shopType,
                  //   style: Theme.of(context).textTheme.bodySmall,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: .4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // divider,
                  _payoutWidget(
                      'Date',
                      MyDateFormat.toDate(
                          widget.appointmentOrder.bookingDate.toDate())),
                  divider,

                  GestureDetector(
                    onTap: () {
                      _launchMap(widget.appointmentOrder.location);
                    },
                    child: PayoutDataWidget(
                      inMini: true,
                      label: 'Location',
                      value: widget.appointmentOrder!.location,
                      text2Ccolor: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ...ticketInfoWidgets, // Spread the list of widgets into the column
                  const SizedBox(
                    height: 20,
                  ),
                  // divider,
                  _payoutWidget(
                    'Service\npri',
                    '${currencyPartition.isEmpty ? '' : currencyPartition.length > 1 ? currencyPartition[1] : ''} ${_total}',
                  ),
                  divider,
                  _payoutWidget(
                    'Processing\nfee',
                    '${currencyPartition.isEmpty ? '' : currencyPartition.length > 1 ? currencyPartition[1] : ''} ${2.0}',
                  ),

                  divider,
                  const SizedBox(
                    height: 20,
                  ),
                  _totalWidget(
                    'Total',
                    '${currencyPartition.isEmpty ? '' : currencyPartition.length > 1 ? currencyPartition[1] : ''} ${_totalAmount}',
                  ),
                  const SizedBox(
                    height: 40,
                  ),

                  // divider,
                ],
              ),
      ),
    );
  }
}
