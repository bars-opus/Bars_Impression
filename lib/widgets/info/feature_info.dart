import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class FeatureInfo extends StatefulWidget {
  static final id = 'FeatureInfo_screen';
  String feature;
  FeatureInfo({
    required this.feature,
  });

  @override
  _FeatureInfoState createState() => _FeatureInfoState();
}

class _FeatureInfoState extends State<FeatureInfo> {
  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
        appBar: AppBar(
          backgroundColor: widget.feature.startsWith('Punch')
              ? Colors.cyan[800]
              : widget.feature.startsWith('Forum')
                  ? Colors.blue
                  : widget.feature.startsWith('Event')
                      ? Color(0xFFFF2D55)
                      : Colors.white,
          iconTheme: IconThemeData(
            color:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: width / 3,
                  width: width,
                  color: widget.feature.startsWith('Punch')
                      ? Colors.cyan[800]
                      : widget.feature.startsWith('Forum')
                          ? Colors.blue
                          : widget.feature.startsWith('Event')
                              ? Color(0xFFFF2D55)
                              : Colors.white,
                  child: Center(
                    child: widget.feature.startsWith('Punch')
                        ? Hero(
                            tag: "punch mood",
                            child: Material(
                              color: Colors.transparent,
                              child: Text('Punch\nMood',
                                  style: TextStyle(
                                      color: ConfigBloc().darkModeOn
                                          ? Color(0xFF1a1a1a)
                                          : Color(0xFFf2f2f2),
                                      fontSize: 40)),
                            ),
                          )
                        : widget.feature.startsWith('Forum')
                            ? Hero(
                                tag: "create forum",
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text('Forums',
                                      style: TextStyle(
                                          color: ConfigBloc().darkModeOn
                                              ? Color(0xFF1a1a1a)
                                              : Color(0xFFf2f2f2),
                                          fontSize: 40)),
                                ),
                              )
                            : widget.feature.startsWith('Event')
                                ? Hero(
                                    tag: "create event",
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text('Event',
                                          style: TextStyle(
                                              color: ConfigBloc().darkModeOn
                                                  ? Color(0xFF1a1a1a)
                                                  : Color(0xFFf2f2f2),
                                              fontSize: 40)),
                                    ),
                                  )
                                : SizedBox.shrink(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: widget.feature.startsWith('Punch')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              SizedBox(height: 10),
                              Container(
                                height: 2,
                                color: Colors.blue,
                                width: 10,
                              ),
                              SizedBox(height: 30),
                              ShakeTransition(
                                child: Text(
                                  'We know how it feels when you are listening to a song, and the lines in the song just hit different, the rhymes aligned on every line perfectly, the punchline (quotes music lyrics) painting a picture in front of you vividly. And you wish someone could relate with you. Well, someone could. You know how when you take a picture you just wish there are words to express your mood in that picture? We have created a creative way for you to express your mood by using your favorite quotes from lyrics(punchline). We call it punching your mood. Punch your mood by posting a picture and associating the mood of the picture with a punchline. You can honor your favorite artist by punching your mood using their punchline. But first, the mood of the picture has to be related to the punchline you are using. For instance, when you are celebrating a special occasion, your punchline should not be about struggle or hustle, but rather happiness or success. \nBelow are the different aspects of punching your mood.',
                                  style: TextStyle(
                                    color: ConfigBloc().darkModeOn
                                        ? Colors.grey
                                        : Colors.black,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: 10),
                              ShakeTransition(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  child: FeatureInfoWidget(
                                    title: 'A photo',
                                    subTitle:
                                        "A  photo capturing a special moment.",
                                    number: '1',
                                  ),
                                ),
                              ),
                              ShakeTransition(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  child: FeatureInfoWidget(
                                    title: 'A punchline',
                                    subTitle:
                                        'A punchline to express your mood. Why struggle to find words to express a mood when there are impressive world plays and rhymes from the most creative artist and poets out there. A punchline can be reacted to by being liked, disliked, or commented on. We do not display the information of users who have liked or disliked a punchline to promote honesty in their reaction.',
                                    number: '2',
                                  ),
                                ),
                              ),
                              ShakeTransition(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  child: FeatureInfoWidget(
                                    title: 'Artist',
                                    subTitle:
                                        'The name of the artist punchline being used to punch your mood. This serves as a way of giving credibility and promotion to the artist.',
                                    number: '3',
                                  ),
                                ),
                              ),
                              ShakeTransition(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  child: FeatureInfoWidget(
                                    title: 'A music video',
                                    subTitle:
                                        'A music video of the punchline used, so other users can watch if they can relate to the mood punch or if they find the punchline creative enough. Other users can also save the video into a library.',
                                    number: '4',
                                  ),
                                ),
                              ),
                              ShakeTransition(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  child: FeatureInfoWidget(
                                    title: 'Punch Score: ',
                                    subTitle:
                                        'Punchline score is the subtraction of the negative reaction(???) from the positive reaction(Dope) of the punchline. It indicates how people are relating with a punchline ',
                                    number: '5',
                                  ),
                                ),
                              ),
                              ShakeTransition(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  child: FeatureInfoWidget(
                                    title: 'Mood Annotation: ',
                                    subTitle:
                                        'Any additional information(caption) about your mood punch',
                                    number: '6',
                                  ),
                                ),
                              ),
                              ShakeTransition(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  child: FeatureInfoWidget(
                                    title: 'Hash Tag:',
                                    subTitle:
                                        'We have a limited hashtag for easy sorting and integrity.',
                                    number: '7',
                                  ),
                                ),
                              ),
                            ])
                      : widget.feature.startsWith('Forum')
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  SizedBox(height: 10),
                                  Container(
                                    height: 2,
                                    color: Colors.blue,
                                    width: 10,
                                  ),
                                  SizedBox(height: 30),
                                  ShakeTransition(
                                    child: Text(
                                      'Create forums to share ideas and discuss topics in the music industry. You can create forums to debate on music topics, ask for advice and guidance when creating music works like beat production, video editing, and many more. You can also create forums asking for suggestions of people for collaborations and businesses. Creating forums gives you more flexibility to express yourself.',
                                      style: TextStyle(
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.grey
                                            : Colors.black,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ])
                          : widget.feature.startsWith('Event')
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                      SizedBox(height: 10),
                                      Container(
                                        height: 2,
                                        color: Colors.blue,
                                        width: 10,
                                      ),
                                      SizedBox(height: 30),
                                      ShakeTransition(
                                        child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    'Create an event where people can attend, have fun, create memories, and have unforgettable experiences. You can create a virtual event that can be hosted on a live stream of other platforms, or you can create an event with a physical venue that people can attend.You can create two types of events. A private and a public event. A public event can be attended by anybody. But a private event can only be attended by specific people. If you create a private event, only specific people with an invitation card can attend. An invitation card is generated automatically for you after creating an event on your event dashboard. Every person attending an event both public and private would be given an invitation card once they tap the attend button on an event flyer. This invitation card has a unique number (attendee number also known as entrance number) which differentiates one attendee from another. This attendee number helps in auditing and ensuring the safety of each event attendee. When a person taps the attend button on an event flyer, the event would be added to that person\'s list of events the person would be attending on the person\'s event feed. A countdown would be made on the event to let the attendee know that the days are catching up for the event. The following are some components of an event',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 50),
                                      Center(
                                        child: Text(
                                          'An invitation card.',
                                          style: TextStyle(
                                            color: Color(0xFFFF2D55),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      ShakeTransition(
                                        child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '\nEvery event attendee must have an invitation card before attending any event be it a public or a private event. An invitation card is automatically generated by tapping the attend button on an event flier. There are different statuses of an invitation',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0),
                                        child: ShakeTransition(
                                          child: RichText(
                                            textScaleFactor:
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '\nThe  public status.\n',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.grey
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'The public status of an invitation card shows that an event is a public event and the attendee doesn\'t need a special invitation to attend. He can tap on attend on the event flyer to generate a card with an attendee number. ',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.grey
                                                            : Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '\n\nThe invitation requested status.\n',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.grey
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'This status shows only on a private event. This status would show on an invitation card of an attendee if that attendee was not invited to a private event but wants to attend that event. When the attendee taps the attend button, the invitation would be generated for the attendee with the requested status. This requested status shows that the attendee is requesting an invitation. This invitation card has an invitation request number. A request would be sent to the event organizer of that event. The request has to be accepted by the event organizer before the attendee can attend the event. If the request is accepted by the event organizer, the status of the invitation card changes from requested to attending. The attendee would then be given an attendee number(entrance) number.',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.grey
                                                            : Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '\n\nThe  Invitation sent status.\n',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.grey
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'This status appears on an invitation card if an event organizer sends an invitation to a person who didn\'t request to attend an event. In this case, the event organizer is specifically and specifically inviting that person. This invitation card needs to be accepted by the person the event organizer is inviting. This invitation card has an invite number. When a person accepts the invitation, an attendee number would be generated for the person and the status of the invitation would change to attending. The event organizer would be notified when an invited person accepts an invitation. An invited person can choose to accept or reject an invitation. An invited person is not obliged to accept an invitation. ',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.grey
                                                            : Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '\n\nThe invitation attending status.\n',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.grey
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'This status indicates that an attendee would be attending a specific event. This attending status has an attendee number. when an invitation card has this status, the event of that invitation card would be added to the list of events an attendee would be attending on the event feed of the attendee. A countdown would be added to the event to remind the attendee.',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.grey
                                                            : Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '\n\nThe invitation validated status.\n',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Colors.grey
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'When an invitation card is validated, it shows that the attendee has been accepted and welcomed to an event. This validation can only be done by the event organizer on an event\'s dashboard.  The event organizer can validate and invalidate an invitation card. A validated invitation card has a blue checkmark on it with the status validated written in blue. A validated invitation card helps track the actual number of people that attended an event among the expected attendees. This helps in auditing, accountability, and safeguarding the safety of each attendee.',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        ConfigBloc().darkModeOn
                                                            ? Colors.grey
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 50),
                                      Center(
                                        child: Text(
                                          'An attendee',
                                          style: TextStyle(
                                            color: Color(0xFFFF2D55),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      ShakeTransition(
                                        child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '\nAn attendee is a person who would be attending a specific event. A person has to get an attendee number to become an attendee. Without an attendee number, a person is not an attendee.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 50),
                                      Center(
                                        child: Text(
                                          'An attendee number',
                                          style: TextStyle(
                                            color: Color(0xFFFF2D55),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      ShakeTransition(
                                        child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '\nAn attendee number indicates that a person is an attendee an event. An attendee number is a unique number generated for each attendee when a person accepts an event invitation or if an event organizer accepts the invitation request of a person.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 50),
                                      Center(
                                        child: Text(
                                          'An event flyer.',
                                          style: TextStyle(
                                            color: Color(0xFFFF2D55),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      ShakeTransition(
                                        child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '\nAn event flyer indicates all the information about an event. The date, time, special guest, venue, theme, DJ, dressing code, ticket, and  category of the event. There are five main categories of an event. These categories are listed below.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: ConfigBloc().darkModeOn
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ShakeTransition(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7.0),
                                          child: FeatureInfoWidget(
                                            title: 'Festival',
                                            subTitle:
                                                "Promote an upcoming music festival so that others can experience different music cultures.",
                                            number: '1',
                                          ),
                                        ),
                                      ),
                                      ShakeTransition(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7.0),
                                          child: FeatureInfoWidget(
                                            title: 'Award',
                                            subTitle:
                                                'The day legends are being honored. Promote upcoming music award shows.',
                                            number: '2',
                                          ),
                                        ),
                                      ),
                                      ShakeTransition(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7.0),
                                          child: FeatureInfoWidget(
                                            title: 'Tours',
                                            subTitle:
                                                'From city to city, states to states, countries to countries, continents to continents. Let them know you are coming. Let them know you would be live with them, singing with them, raping with them, dancing with them, let them know it is time to create memories together. Promote your upcoming tours and let them know.',
                                            number: '3',
                                          ),
                                        ),
                                      ),
                                      ShakeTransition(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7.0),
                                          child: FeatureInfoWidget(
                                            title: 'Album launch',
                                            subTitle:
                                                'Is a new album coming out? Everybody deserves to hear the genius and creative piece you have out together. Promote your albums and bless the world with your talent.',
                                            number: '4',
                                          ),
                                        ),
                                      ),
                                      ShakeTransition(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7.0),
                                          child: FeatureInfoWidget(
                                            title: 'Others',
                                            subTitle:
                                                'Promote other upcoming events.',
                                            number: '5',
                                          ),
                                        ),
                                      ),
                                    ])
                              : SizedBox.shrink(),
                ),
                FadeAnimation(
                  0.5,
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60.0, bottom: 40),
                      child: Container(
                        width: 250.0,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.blue,
                              side: BorderSide(width: 1.0, color: Colors.blue),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Suggestion Survey',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => FeatureSurvey()))),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
