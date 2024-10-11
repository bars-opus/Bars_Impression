import 'package:bars/utilities/exports.dart';

class SelectWorkerWidget extends StatefulWidget {
  final List<ShopWorkerModel> workers;
  // final bool edit;
  // final bool seeMore;
  // final String currency;

  SelectWorkerWidget({
    required this.workers,
    // required this.edit,
    // required this.seeMore,
    // required this.currency,
  });

  @override
  State<SelectWorkerWidget> createState() => _SelectWorkerWidgetState();
}

class _SelectWorkerWidgetState extends State<SelectWorkerWidget> {
  Map<String, bool> selectedWorkers = {};

  @override
  void initState() {
    super.initState();
    selectedWorkers = {for (var worker in widget.workers) worker.id: false};
  }

  void _toggleWorkers(ShopWorkerModel worker) {
    var _provider = Provider.of<UserData>(context, listen: false);

    setState(() {
      bool isSelected = selectedWorkers[worker.id] ?? false;
      selectedWorkers[worker.id] = !isSelected;

      if (!isSelected) {
        _provider.addAppointmentWorkersToList(worker);
      } else {
        _provider.removeAppointmentWorkersFromList(worker);
      }
    });
  }

  _example(ShopWorkerModel worker) {
    var divider = Divider(
      color: Colors.grey,
      thickness: .2,
    );
    return Column(
      children: [
        divider,
        PayoutDataWidget(
          inMini: true,
          label: 'Service',
          value: worker.services.map((service) => service).join(', '),
        ),
        divider,
        PayoutDataWidget(
          inMini: true,
          label: 'Role',
          value: worker.role.map((role) => role).join(', '),
        ),
        divider
      ],
    );
  }

  _buildDisplayPortfolioList(BuildContext context) {
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 400),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.workers.length,
        itemBuilder: (context, index) {
          var worker = widget.workers[index];
          bool isSelected = selectedWorkers[worker.id] ?? false;

          return GestureDetector(
            onTap: () {
              _toggleWorkers(worker);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 250,
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).primaryColorLight,
                ),
                borderRadius: BorderRadius.circular(20),
                color: isSelected
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).primaryColorLight.withOpacity(.5),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: Colors.blue,
                    value: isSelected,
                    onChanged: (bool? value) {
                      _toggleWorkers(worker);
                    },
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 40.0,
                        color: Colors.grey,
                      ),
                      // worker.profileImageUrl!.isEmpty
                      //     ? const Icon(
                      //         Icons.account_circle,
                      //         size: 40.0,
                      //         color: Colors.grey,
                      //       )
                      //     : CircleAvatar(
                      //         radius: 20.0,
                      //         backgroundColor: Colors.blue,
                      //         backgroundImage: CachedNetworkImageProvider(
                      //             worker.profileImageUrl!, errorListener: (_) {
                      //           return;
                      //         }),
                      //       ),
                      SizedBox(
                        width: ResponsiveHelper.responsiveWidth(context, 10.0),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          StarRatingWidget(
                            isMini: true,
                            enableTap: false,
                            onRatingChanged: (_) {},
                            rating: worker.averageRating ?? 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  _example(worker),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort the schedules by date in ascending order
    widget.workers.sort((a, b) => a.name.compareTo(b.name));

    return widget.workers.length < 1
        ? SizedBox.shrink()
        : _buildDisplayPortfolioList(context);
  }
}
