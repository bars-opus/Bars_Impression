import 'package:bars/utilities/exports.dart';

class EditProfileMusicPref extends StatefulWidget {
  final AccountHolder user;

  EditProfileMusicPref({
    required this.user,
  });

  @override
  _EditProfileMusicPrefState createState() => _EditProfileMusicPrefState();
}

class _EditProfileMusicPrefState extends State<EditProfileMusicPref> {
  final _formKey = GlobalKey<FormState>();
  String _favouritePunchline = '';
  String _favouriteArtist = '';
  String _favouriteSong = '';
  String _favouriteAlbum = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _favouritePunchline = widget.user.favouritePunchline!;
    _favouriteArtist = widget.user.favouriteArtist!;
    _favouriteSong = widget.user.favouriteSong!;
    _favouriteAlbum = widget.user.favouriteAlbum!;
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        usersRef
            .doc(
          widget.user.id,
        )
            .update({
          'favouritePunchline': _favouritePunchline,
          'favouriteArtist': _favouriteArtist,
          'favouriteSong': _favouriteSong,
          'favouriteAlbum': _favouriteAlbum,
        });
      } catch (e) {
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        Flushbar(
          margin: EdgeInsets.all(8),
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Text(
            'Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            result.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.error_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                      child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _isLoading
                                    ? SizedBox(
                                        height: 2.0,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.grey[100],
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.blue),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                EditProfileInfo(
                                    editTitle: 'Music \nPreference',
                                    info:
                                        'You can enter your favorite punchline, favorite musician, and favorite music album so that other users can know the type of music you like and relate to you. These also help promote your favorite music. ',
                                    icon: Icons.favorite),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10.0, right: 10.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    initialValue: _favouritePunchline,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: ConfigBloc().darkModeOn
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 3.0),
                                      ),
                                      enabledBorder: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.grey)),
                                      hintText: "'At least 500 characters",
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      labelText: 'Favorite Punchline',
                                    ),
                                    validator: (input) =>
                                        input!.trim().length > 500
                                            ? 'At least 500 characters'
                                            : null,
                                    onSaved: (input) =>
                                        _favouritePunchline = input!,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10.0, right: 10.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    maxLines: null,
                                    initialValue: _favouriteArtist,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: ConfigBloc().darkModeOn
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 3.0),
                                      ),
                                      enabledBorder: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.grey)),
                                      hintText: "Your favorite musician's name",
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      labelText: 'Favorite Artist',
                                    ),
                                    validator: (input) => input!.trim().length >
                                            50
                                        ? 'Please, enter an artist\'s name with fewer than 50 characters.'
                                        : null,
                                    onSaved: (input) =>
                                        _favouriteArtist = input!.toUpperCase(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10.0, right: 10.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    maxLines: null,
                                    initialValue: _favouriteSong,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: ConfigBloc().darkModeOn
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 3.0),
                                      ),
                                      enabledBorder: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.grey)),
                                      hintText: "Songname - artist\'s name",
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      labelText: 'Favorite Song',
                                    ),
                                    validator: (input) => input!.trim().length >
                                                50 ||
                                            !input.contains('-')
                                        ? ' Songname - artist ( < 50 characters)'
                                        : null,
                                    onSaved: (input) =>
                                        _favouriteSong = input!.toUpperCase(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10.0, right: 10.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    initialValue: _favouriteAlbum,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: ConfigBloc().darkModeOn
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 3.0),
                                      ),
                                      enabledBorder: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.grey)),
                                      hintText: "Album - artist\'s name)",
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      labelText: 'Favorite Album',
                                    ),
                                    validator: (input) => input!.trim().length >
                                                100 ||
                                            !input.contains('-')
                                        ? 'Album - artistName ( < 100 characters)'
                                        : null,
                                    onSaved: (input) =>
                                        _favouriteAlbum = input!.toUpperCase(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 40),
                                    child: Container(
                                      width: 250.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          elevation: 20.0,
                                          onPrimary: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        child: Text(
                                          'Done',
                                          style: TextStyle(
                                            color: ConfigBloc().darkModeOn
                                                ? Color(0xFF1a1a1a)
                                                : Colors.blue,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        onPressed: _submit,
                                      ),
                                    ),
                                  ),
                                ),
                                _isLoading
                                    ? SizedBox(
                                        height: 2.0,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.grey[100],
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.blue),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ))),
                ),
              ),
            ),
          )),
    );
  }
}
