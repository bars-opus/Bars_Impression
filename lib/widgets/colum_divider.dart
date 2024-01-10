import 'package:bars/utilities/exports.dart';

class ColumnDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       const SizedBox(
          height: 20.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1.0,
          color:  Colors.grey,
        ),
      const  SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
