import 'package:bars/widgets/general_widget/payout_data_widget.dart';
import 'package:flutter/material.dart';

class NoAppointmentWidget extends StatelessWidget {
  const NoAppointmentWidget({super.key});

  @override
  Widget build(BuildContext context) {

    noApoinmentWdidget(String title, String value) {
    return PayoutDataWidget(
      label: title,
      value: value,
      text2Ccolor: Colors.black,
    );
  }

    return  Column(children: [
        noApoinmentWdidget('Monday', 'Closed'),
        noApoinmentWdidget('Tuesday', 'Closed'),
        noApoinmentWdidget('Wednesday', 'Closed'),
        noApoinmentWdidget('Thursday', 'Closed'),
        noApoinmentWdidget('Friday', 'Closed'),
        noApoinmentWdidget('Saturday', 'Closed'),
        noApoinmentWdidget('Sunday', 'Closed'),
      ]);
  }
}
