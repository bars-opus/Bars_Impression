import 'package:bars/features/events/event_management/presentation/widgets/select_date_range.dart';
import 'package:bars/utilities/exports.dart';

class CreateScheduleWidget extends StatefulWidget {
  // String selectedNameToAdd;
  // String selectedNameToAddProfileImageUrl;
  // String taggedUserExternalLink;
  TextEditingController? tagNameController;
  Future<QuerySnapshot>? users;
  GlobalKey<FormState>? addPersonFormKey;
  final FocusNode? nameSearchfocusNode;
  final bool isSchedule;

  // final VoidCallback cancelSearch;
  // final Function(String) onChanged;

  CreateScheduleWidget({
    Key? key,
    // required this.selectedNameToAdd,
    // required this.selectedNameToAddProfileImageUrl,
    // required this.taggedUserExternalLink,
    required this.tagNameController,
    this.users,
    required this.addPersonFormKey,
    required this.nameSearchfocusNode,
    required this.isSchedule,
  }) : super(key: key);

  @override
  State<CreateScheduleWidget> createState() => _CreateScheduleWidgetState();
}

class _CreateScheduleWidgetState extends State<CreateScheduleWidget> {
  DateTime _scheduleStartTime = DateTime.now();
  DateTime _scheduleEndTime = DateTime.now();

  //Time schedule
  List<DateTime> getDatesInRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  void _showBottomTaggedPeople(bool isSchedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AddTaggedPeople(
            // selectedNameToAdd: widget.selectedNameToAdd,
            // selectedNameToAddProfileImageUrl:
                // widget.selectedNameToAddProfileImageUrl,
            // taggedUserExternalLink: widget.taggedUserExternalLink,
            tagNameController: widget.tagNameController!,
            addPersonFormKey: widget.addPersonFormKey!,
            nameSearchfocusNode: widget.nameSearchfocusNode!,
            isSchedule: isSchedule,
          );
        });
      },
    );
  }

  _sheduleDivider(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    List<DateTime> dateList = getDatesInRange(
        _provider.startDate.toDate(), _provider.clossingDay.toDate());
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          TicketPurchasingIcon(
            title: '',
          ),
          _provider.punchline.isEmpty ||
                  _provider.schedulePerson.isEmpty ||
                  !_provider.endTimeSelected ||
                  !_provider.startTimeSelected
              ? SizedBox.shrink()
              : Align(
                  alignment: Alignment.centerRight,
                  child: MiniCircularProgressButton(
                    color: Colors.blue,
                    text: '  Add ',
                    onPressed: () {
                      EventDatabaseEventData.addSchedule(
                        users: widget.users,
                        context: context,
                        scheduleStartTime: _scheduleStartTime,
                        scheduleEndTime: _scheduleEndTime,
                      );
                      // _addSchedule();
                    },
                  ),
                ),
          const SizedBox(
            height: 30,
          ),
          ContentFieldBlack(
            onlyBlack: false,
            labelText: 'Program title',
            hintText: 'Schedule(Program) title',
            initialValue: _provider.punchline,
            onSavedText: (input) => _provider.setPunchline(input),
            onValidateText: (value) {
              if (value == null || value.isEmpty) {
                return 'Program title cannot be empty';
              }
              return null;
            },
          ),
          // _ticketFiled(
          //   false,
          //   false,
          //   'Program title',
          //   'Schedule(Program) title',
          // _scheduleTitleController,
          //   TextInputType.text,
          //   (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Program title cannot be empty';
          //     }
          //     return null;
          //   },
          // ),
          _sheduleDivider(
              'Enter the title of the program segment (e.g., \'opening prayer\') '),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  if (dateList.length > 1)
                    _sheduleDivider(
                        'Choose the date for which you want to create a program lineup.'),
                  if (_provider.endDateSelected) SelectDateRange(),

                  // _dateRange(),
                  const SizedBox(
                    height: 20,
                  ),
                  _sheduleDivider(
                      'Select the start and end time to indicate the duration for this program on the schedule'),
                  DatePicker(
                    onStartDateChanged: (DateTime newDate) {
                      _scheduleStartTime = newDate;
                    },
                    onStartTimeChanged: (DateTime newDate) {
                      _scheduleStartTime = newDate;
                    },
                    onEndDateChanged: (DateTime newDate) {
                      _scheduleEndTime = newDate;
                    },
                    onEndTimeChanged: (DateTime newDate) {
                      _scheduleEndTime = newDate;
                    },
                    date: false,
                    onlyWhite: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: PickOptionWidget(
                color: Theme.of(context).primaryColorLight,
                dropDown: true,
                title: 'Add speaker or performer',
                onPressed: () {
                  _showBottomTaggedPeople(true);
                }),
          ),
          _sheduleDivider(
              'Add the person or people performing or participating in this program. You can either provide their names from Bars Impression or include a link to their profiles on other platforms.'),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
            child: SchedulePeopleGroup(
              canBeEdited: true,
              groupTaggedEventPeopleGroup: _provider.schedulePerson,
            ),
          ),
        ],
      ),
    );
  }
}
