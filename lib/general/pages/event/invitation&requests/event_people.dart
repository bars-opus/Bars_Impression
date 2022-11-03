import 'package:bars/utilities/exports.dart';

class EventPeople extends StatelessWidget {
  final Event event;
  final PaletteGenerator palette;
  const EventPeople({Key? key, required this.event, required this.palette})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> guests = event.guess.split(",");
    final List<String> artists = event.artist.split(",");

    return ResponsiveScaffold(
      child: Scaffold(
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
                color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  event.guess.isEmpty
                      ? const SizedBox.shrink()
                      : Center(
                          child: Text(
                            'Special Guests',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: palette.darkMutedColor == null
                                  ? Color(0xFF1a1a1a)
                                  : palette.darkMutedColor!.color,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (guests.length > 0)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[0].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[0].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 1)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 1)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[1].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[1].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 2)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 2)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[2].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[2].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 3)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 3)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[3].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[3].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 4)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 4)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[4].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[4].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 5)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 5)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[5].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[5].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 6)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 6)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[6].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[6].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 7)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 7)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[7].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[7].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 8)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 8)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[8].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[8].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 9)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 9)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[9].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[9].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 10)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 10)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[10].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[10].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 11)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 11)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[11].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[11].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (guests.length > 12)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (guests.length > 12)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${guests[12].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          guests[12].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 60,
                  ),
                  event.artist.isEmpty
                      ? const SizedBox.shrink()
                      : Center(
                          child: Text(
                            'Artist performing',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: palette.darkMutedColor == null
                                  ? Color(0xFF1a1a1a)
                                  : palette.darkMutedColor!.color,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (artists.length > 0)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[0].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[0].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 1)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 1)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[1].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[1].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 2)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 2)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[2].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[2].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 3)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 3)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[3].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[3].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 4)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 4)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[4].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[4].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 5)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 5)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[5].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[5].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 6)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 6)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[6].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[6].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 7)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 7)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[7].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[7].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 8)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 8)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[8].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[8].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 9)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 9)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[9].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[2].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 10)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 10)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[10].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[10].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 11)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 11)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[11].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[11].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 12)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 12)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[12].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[12].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 13)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 13)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[13].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[13].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 14)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 14)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[14].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[14].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 15)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 15)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[15].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[15].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 16)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 16)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[16].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[16].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 17)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 17)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[17].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[17].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 18)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 18)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[18].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[18].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 19)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 19)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[19].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[19].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 20)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 20)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[20].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[20].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 21)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 21)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[21].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[21].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 22)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 22)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[22].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[22].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 23)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 23)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[23].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[23].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 24)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 24)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[24].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[24].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 25)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 25)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[25].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[25].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 26)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 26)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[26].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[26].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 27)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 27)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[27].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[27].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 28)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 28)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[28].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[28].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 29)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 29)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[29].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[29].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (artists.length > 30)
                    Divider(
                      color: Colors.grey,
                    ),
                  if (artists.length > 30)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaggedUser(
                              userId: '@${artists[30].toUpperCase().trim()}',
                              currentUserId: '',
                            ),
                          ),
                        ),
                        child: Text(
                          artists[30].toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
