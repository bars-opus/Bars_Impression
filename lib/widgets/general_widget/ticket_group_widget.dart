import 'package:bars/utilities/exports.dart';

class TicketGoupWidget extends StatefulWidget {
  final List<AppointmentSlotModel> appointmentSlots;
  final bool isEditing;
  final String currency;
  final String eventId;
  final String eventAuthorId;
  final bool fromProfile;
  final DateTime? selectedDay;

  const TicketGoupWidget({
    super.key,
    required this.appointmentSlots,
    required this.currency,
    required this.isEditing,
    this.selectedDay,
    required this.eventId,
    required this.eventAuthorId,
    this.fromProfile = true,
  });

  @override
  State<TicketGoupWidget> createState() => _TicketGoupWidgetState();
}

class _TicketGoupWidgetState extends State<TicketGoupWidget> {
  Map<String, bool> selectedAppointment = {};
  Map<String, bool> checkingAvailability = {};

  @override
  void initState() {
    super.initState();
    for (var appointment in widget.appointmentSlots) {
      selectedAppointment[appointment.id] = false;
    }
  }

  void _toggleAppointment(AppointmentSlotModel appoinment) {
    var _provider = Provider.of<UserData>(context, listen: false);

    var appoinmentSelected = selectedAppointment[appoinment.id] ?? false;
    setState(() {
      selectedAppointment[appoinment.id] = !appoinmentSelected;
    });

    if (!appoinmentSelected) {
      // The appoinment was not previously selected, so add it to the list.
      _provider.addAppointmentToList(appoinment);
    } else {
      // The appoinment was previously selected, so remove it from the list.
      _provider.removeAppointmentFromList(appoinment);
    }
  }

  _removeTicket(AppointmentSlotModel removingTicket) async {
    widget.appointmentSlots
        .removeWhere((appointment) => appointment.id == removingTicket.id);
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    final List<String> currencyPartition =
        widget.currency.trim().replaceAll('\n', ' ').split("|");

    Map<String, Map<String, List<AppointmentSlotModel>>>
        appointmentsByDateAndGroup = {};
    for (AppointmentSlotModel appointment in widget.appointmentSlots) {
      String appointmentDate = appointment.service;

      if (!appointmentsByDateAndGroup.containsKey(appointmentDate)) {
        appointmentsByDateAndGroup[appointmentDate] = {};
      }
      Map<String, List<AppointmentSlotModel>> groupMap =
          appointmentsByDateAndGroup[appointmentDate]!;
      if (!groupMap.containsKey(appointment.type)) {
        groupMap[appointment.type] = [];
      }
      groupMap[appointment.type]!.add(appointment);
    }

    var sortedEntries = appointmentsByDateAndGroup.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedEntries.length,
      itemBuilder: (BuildContext context, int dateIndex) {
        String service = sortedEntries[dateIndex].key;
        Map<String, List<AppointmentSlotModel>> groups =
            sortedEntries[dateIndex].value;

        List<Widget> groupWidgets = groups.entries.map((groupEntry) {
          String groupName = groupEntry.key;
          List<AppointmentSlotModel> appointments = groupEntry.value;
          List<Widget> appointmentWidgets = appointments.map((appointment) {
            bool isSelected = selectedAppointment[appointment.id] ?? false;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[400] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SalesReceiptWidget(
                                      isTicket: true,
                                      text2Ccolor: Colors.black,
                                      width: 100,
                                      isRefunded: false,
                                      lable: 'Duration',
                                      value: appointment.duruation,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (checkingAvailability[appointment.id] ==
                                          false ||
                                      checkingAvailability[appointment.id] ==
                                          null)
                                    Text(
                                      '${currencyPartition.isEmpty ? '' : currencyPartition.length > 1 ? currencyPartition[1] : ''} ${appointment.price}',
                                      style: TextStyle(
                                          fontSize: ResponsiveHelper
                                              .responsiveFontSize(
                                                  context, 18.0),
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  if (!widget.isEditing)
                                    checkingAvailability[appointment.id] == true
                                        ? SizedBox(
                                            height: ResponsiveHelper
                                                .responsiveHeight(
                                                    context, 10.0),
                                            width: ResponsiveHelper
                                                .responsiveHeight(
                                                    context, 10.0),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              color: Colors.blue,
                                            ),
                                          )
                                        : Checkbox(
                                            checkColor: Colors.blue,
                                            activeColor: Colors.white,
                                            side:
                                                BorderSide(color: Colors.black),
                                            value: selectedAppointment[
                                                appointment.id],
                                            onChanged: (bool? value) async {
                                              var appointmentSelected =
                                                  selectedAppointment[
                                                          appointment.id] ??
                                                      false;
                                              _toggleAppointment(appointment);
                                            },
                                          ),
                                  if (widget.isEditing)
                                    GestureDetector(
                                        onTap: () => _removeTicket(appointment),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.red,
                                        )),
                                ],
                              ),
                            ]),
                        // SettingSwitch(
                        //   isAlwaysBlack: isSelected ? true : false,
                        //   color: isSelected
                        //       ? Colors.grey[700] ?? Colors.grey
                        //       : Colors.blue,
                        //   title: 'Select your favorite worker.',
                        //   subTitle: appointment.favoriteWorker
                        //       ? 'You would have to select a preferred worker in the next step.\nSee available workers below'
                        //       : 'A random worker would be selected for you.\nSee available workers below',
                        //   value: appointment.favoriteWorker,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       appointment.favoriteWorker = value;
                        //     });
                        //   },
                        // ),
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
                            edit: appointment.favoriteWorker,
                            workers: appointment.workers,
                            currentUserId: _provider.currentUserId!,
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          }).toList();

          return ExpansionTile(
            initiallyExpanded: true,
            iconColor: Colors.grey,
            collapsedIconColor: Colors.blue,
            title: Text(
              groupName.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            children: appointmentWidgets,
          );
        }).toList();

        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                service,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(children: groupWidgets),
            ),
          ],
        );

        return content;
      },
    );
  }
}
