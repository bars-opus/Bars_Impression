import 'package:bars/utilities/exports.dart';

class EventPeopleScreen extends StatelessWidget {
  final Event event;
  final PaletteGenerator palette;
  const EventPeopleScreen({Key? key, required this.event, required this.palette})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: palette.darkMutedColor == null
            ? Color(0xFF1a1a1a)
            : palette.darkMutedColor!.color,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: palette.darkMutedColor == null
              ? Color(0xFF1a1a1a)
              : palette.darkMutedColor!.color,
          title: Text(
            'People in this Event',
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(10, 10),
                    blurRadius: 10.0,
                    spreadRadius: 4.0,
                  )
                ]),
           
        ),
      ),
    );
  }
}
