import 'package:bars/utilities/exports.dart';

class SelectDateRange extends StatelessWidget {
  const SelectDateRange({super.key});

  @override
  Widget build(BuildContext context) {
    UserData _provider = Provider.of<UserData>(
      context,
    );
    final width = MediaQuery.of(context).size.width;
    List<DateTime> dateList = MyDateFormat.getDatesInRange(
        _provider.startDate.toDate(), _provider.clossingDay.toDate());

    // getDatesInRange(
    //     _provider.startDate.toDate(), _provider.clossingDay.toDate()
    //     );

    return Container(
        height: ResponsiveHelper.responsiveHeight(
            context,
            dateList.length == 1
                ? 60
                : dateList.length == 3
                    ? 190
                    : 120),
        width: ResponsiveHelper.responsiveWidth(context, width),
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: dateList.length == 1
                ? 1
                : dateList.length == 3
                    ? 3
                    : 2, // Items down the screen
            mainAxisSpacing: .7,
            crossAxisSpacing: .7,
            childAspectRatio: dateList.length <= 3 ? 0.2 / 1.1 : 0.3,
          ),
          itemCount: dateList.length,
          itemBuilder: (context, index) {
            DateTime date = dateList[index];
            return Card(
              surfaceTintColor: Colors.transparent,
              color: Theme.of(context).primaryColor,
              // Using Card for better visual separation
              child: ListTile(
                title: Text(
                  MyDateFormat.toDate(date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                leading: Radio<DateTime>(
                  value: date,
                  activeColor: Colors.blue,
                  groupValue: _provider.sheduleDateTemp.toDate(),
                  onChanged: (DateTime? value) {
                    _provider.setSheduleDateTemp(Timestamp.fromDate(value!));
                  },
                ),
              ),
            );
          },
        ));
  }
}
