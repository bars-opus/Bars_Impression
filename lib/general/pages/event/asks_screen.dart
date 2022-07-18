import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/rendering.dart';

class AsksScreen extends StatefulWidget {
  final Event event;
  final AccountHolder author;
  final Ask? ask;
  final int askCount;
  final String currentUserId;

  AsksScreen(
      {required this.event,
      required this.askCount,
      required this.author,
      required this.ask,
      required this.currentUserId});

  @override
  _AsksScreenState createState() => _AsksScreenState();
}

class _AsksScreenState extends State<AsksScreen> {
  final TextEditingController _askController = TextEditingController();
  bool _isAsking = false;
  int _askCount = 0;
  bool _isBlockedUser = false;
  late ScrollController _hideButtonController;
  var _isVisible;
  void initState() {
    super.initState();
    _isVisible = true;
    _setupIsBlockedUser();
    _setUpAsks();
    _hideButtonController = new ScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setPost9('');
    });
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.author.id!,
    );
    setState(() {
      _isBlockedUser = isBlockedUser;
    });
  }

  _setUpAsks() async {
    DatabaseService.numAsks(widget.event.id).listen((askCount) {
      if (mounted) {
        setState(() {
          _askCount = askCount;
        });
      }
    });
  }

  _buildAsk(Ask ask, AccountHolder author) {
    final width = MediaQuery.of(context).size.width;
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    return FutureBuilder(
      future: DatabaseService.getUserWithId(ask.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        AccountHolder author = snapshot.data;
        return FocusedMenuHolder(
          menuWidth: width,
          menuOffset: 1,
          blurBackgroundColor:
              ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.red[50],
          openWithTap: false,
          onPressed: () {},
          menuItems: [
            FocusedMenuItem(
              title: Container(
                width: width / 2,
                child: Text(
                  currentUserId == author.id!
                      ? 'Edit  your question'
                      : author.profileHandle!.startsWith('Fan') ||
                              author.profileHandle!.isEmpty
                          ? 'Go to ${author.userName}\' profile '
                          : 'Go to ${author.userName}\' booking page ',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
              ),
              onPressed: () => currentUserId == author.id!
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditQuestion(
                            ask: ask,
                            currentUserId: widget.currentUserId,
                            event: widget.event),
                      ),
                    )
                  : author.profileHandle!.startsWith('Fan') ||
                          author.profileHandle!.isEmpty
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId,
                                    userId: author.id!,
                                    user: widget.author,
                                  )))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileProfessionalProfile(
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId,
                                    user: author,
                                    userId: author.id!,
                                  ))),
            ),
            FocusedMenuItem(
                title: Container(
                  width: width / 2,
                  child: Text(
                    'Report',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportContentPage(
                              contentId: ask.id,
                              contentType: 'question',
                              parentContentId: widget.event.id,
                              repotedAuthorId: widget.event.authorId,
                            )))),
          ],
          child: Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    currentUserId == author.id!
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditQuestion(
                                  ask: ask,
                                  currentUserId: widget.currentUserId,
                                  event: widget.event),
                            ),
                          )
                        : SizedBox.shrink();
                  },
                  backgroundColor: Color(0xFFFF2D55),
                  foregroundColor: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Colors.white,
                  icon: currentUserId == author.id! ? Icons.edit : null,
                  label: currentUserId == author.id! ? 'Edit question' : '',
                ),
              ],
            ),
            child: Authorview(
              report: ask.report,
              content: ask.content,
              author: author,
              timestamp: ask.timestamp,
            ),
          ),
        );
      },
    );
  }

  _buildAskTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: _isVisible ? null : 0.0,
        child: IconTheme(
          data: IconThemeData(
            color: _isAsking ? Colors.blue : Theme.of(context).disabledColor,
          ),
          child: Material(
            color: Colors.white,
            elevation: 10.0,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _askController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLines: _askController.text.length > 300 ? 10 : null,
                      onChanged: (ask) =>
                          Provider.of<UserData>(context, listen: false)
                              .setPost9(ask),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Instrested? Ask more...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: CircularButton(
                      color: Provider.of<UserData>(context, listen: false)
                              .post9
                              .isNotEmpty
                          ? Color(0xFFFF2D55)
                          : Colors.transparent,
                      icon: Icon(
                        Icons.send,
                        color: Provider.of<UserData>(context, listen: false)
                                .post9
                                .isNotEmpty
                            ? Colors.white
                            : !_isVisible
                                ? Colors.transparent
                                : ConfigBloc().darkModeOn
                                    ? Color(0xFF1a1a1a)
                                    : Theme.of(context).disabledColor,
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (Provider.of<UserData>(context, listen: false)
                            .post9
                            .isNotEmpty) {
                          DatabaseService.askAboutEvent(
                            currentUserId: currentUserId,
                            event: widget.event,
                            reportConfirmed: '',
                            ask: _askController.text,
                          );
                          Provider.of<UserData>(context, listen: false)
                              .setPost9('');
                          _askController.clear();
                          setState(() {
                            _isAsking = false;
                          });
                        }
                      },
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

  _pop() {
    Navigator.pop(context);
    Provider.of<UserData>(context, listen: false).setPost9('');
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Material(
            color: Colors.transparent,
            child: NestedScrollView(
              controller: _hideButtonController,
              headerSliverBuilder: (context, innerBoxScrolled) => [
                SliverAppBar(
                  title: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Ask More',
                      style: TextStyle(
                          color: ConfigBloc().darkModeOn
                              ? Color(0xFF1a1a1a)
                              : Color(0xFFe8f3fa),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0.0,
                  automaticallyImplyLeading: true,
                  leading: BackButton(
                    onPressed: _pop,
                  ),
                  expandedHeight: 120,
                  floating: true,
                  snap: true,
                  iconTheme: new IconThemeData(
                    color: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Color(0xFFe8f3fa),
                  ),
                  backgroundColor: Color(0xFFFF2D55),
                  flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                        child: Container(
                          color: Color(0xFFFF2D55),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: 'title' + widget.event.id.toString(),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    widget.event.title.toUpperCase(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: ConfigBloc().darkModeOn
                                          ? Color(0xFF1a1a1a)
                                          : Color(0xFFe8f3fa),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'Asked:    ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: ConfigBloc().darkModeOn
                                              ? Color(0xFF1a1a1a)
                                              : Color(0xFFe8f3fa),
                                        )),
                                    TextSpan(
                                        text: NumberFormat.compact()
                                            .format(_askCount),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: ConfigBloc().darkModeOn
                                              ? Color(0xFF1a1a1a)
                                              : Color(0xFFe8f3fa),
                                        )),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                  timeago.format(
                                    widget.event.timestamp.toDate(),
                                  ),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: ConfigBloc().darkModeOn
                                        ? Color(0xFF1a1a1a)
                                        : Color(0xFFe8f3fa),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
              body: Container(
                color: Color(0xFFFF2D55),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, -5),
                            blurRadius: 2.0,
                            spreadRadius: 2.0,
                          )
                        ],
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Color(0xFFf2f2f2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0))),
                    child: Column(
                      children: <Widget>[
                        StreamBuilder(
                          stream: asksRef
                              .doc(widget.event.id)
                              .collection('eventAsks')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return _askCount == 0
                                ? Expanded(
                                    child: Center(
                                      child: NoContents(
                                        icon: (MdiIcons.calendarQuestion),
                                        title:
                                            'No questions on this event yet,',
                                        subTitle:
                                            'You can be the first person to ask a question or tell others how you feel about this upcoming event, ',
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Scrollbar(
                                        child: CustomScrollView(slivers: [
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            Ask ask = Ask.fromDoc(
                                                snapshot.data.docs[index]);
                                            return FutureBuilder(
                                                future: DatabaseService
                                                    .getUserWithId(
                                                        ask.authorId),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return FollowerUserSchimmerSkeleton();
                                                  }
                                                  AccountHolder author =
                                                      snapshot.data;
                                                  return _buildAsk(ask, author);
                                                });
                                          },
                                          childCount: snapshot.data.docs.length,
                                        ),
                                      )
                                    ])),
                                  ));
                          },
                        ),
                        _isBlockedUser ? SizedBox.shrink() : _buildAskTF(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
