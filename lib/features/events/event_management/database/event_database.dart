import 'package:bars/utilities/exports.dart';
import 'package:uuid/uuid.dart';

class EventDatabase {
  final Event? event;

  final BuildContext context;
  EventDatabase(
      // this.pageController,
      {required this.event,
      required this.context});

  static final _googleGenerativeAIService = GoogleGenerativeAIService();
// Function to get summarize event using Gemini API
  static Future<String> summarizeEvent(Event event) async {
    final prompt =
        'Summarize the following event details:\n\nTitle: ${event.title}\nOverview: ${event.overview}\nTheme: ${event.theme}\nCity: ${event.city}\nDate: ${event.startDate.toDate().toString()}\n\nSummary:';
    final response = await _googleGenerativeAIService.generateResponse(prompt);
    // print(response);
    return response!.trim();
  }

// Function to get similarity score using Gemini API
  static Future<String> gettInsight(
      {required String eventTitle,
      required String eventTheme,
      required String eventDressCode,
      required String eventAdress,
      required String eventCity,
      required Timestamp eventStartDate,
      required bool isInsight}) async {
    final prompt = isInsight
        ? """
Analyze the following information about this event and give an in-depth insight based on the instructions provided.
Ensure the content is structured with clear headings, bullet points, and paragraphs for readability, use # to start a Heading, * to Start a body and +to start a bullete.
1. Analyze the event title: '${eventTitle}' and event theme: '${eventTheme}'. Provide insights on these details to help potential attendees understand the event better.
2. Advise on the appropriate attire for both male and female attendees for this event. If there is a dress code specified by the event organizer, dress code: '${eventDressCode}', use it as a hint.
3. Analyze the event's date: '${MyDateFormat.toDate(eventStartDate.toDate())}' and location: '${eventAdress}'. Based on historical weather data, predict the likely weather conditions and suggest suitable attire.
5. What networking opportunities are available at the event? Offer advice on how attendees can make the most of these opportunities.
6. What are the logistical details such as parking, transportation, and accessibility? Provide tips to help attendees navigate these aspects smoothly.
7. Are there any health and safety guidelines or measures that attendees should be aware of? Provide an overview and advice on how to comply with these measures.
8. What are some general etiquette or behavioral expectations for this event? Offer guidance to ensure attendees conduct themselves appropriately.
9. What should attendees bring with them to the event (e.g., business cards, notebooks, water bottles)? Provide a checklist of essentials.
10. Are there any special considerations, such as dietary restrictions or accessibility needs, that attendees should plan for?
Please provide detailed and actionable insights for potential attendees.
"""
        : """
Analyze the following event information and develop in-depth marketing strategies for the organizer. Structure the content with clear headings, bullet points, and paragraphs for readability. Use # for headings, * for body text, and + for bullet points.
1. Event Branding: Analyze the event title: '${eventTitle}' and theme: '${eventTheme}'. Provide insights on branding, tone, color schemes, and other elements to consider. Do not include a logo. .
2. Event Timing and Location: Evaluate the event's date: '${MyDateFormat.toDate(eventStartDate.toDate())}', city: '${eventCity}', and address: '${eventAdress}'. Offer insights on marketing campaigns.
3. Target Audience: Identify the types of attendees the event should expect.
4. How might the target audience to perceive the event? What emotions or thoughts should the event work evoke? give examples with applicable.
5. What key values or messages should the event communicate? give examples with applicable.
6. Which channels should be used to promote the event, give examples.
7. Networking Opportunities: Discuss available networking opportunities and how organizers can leverage them to attract more attendees.
8. Logistical Considerations: Detail logistical aspects such as parking, transportation, and accessibility, with tips for organizers.
9. Health and Safety: Outline any health and safety guidelines organizers should be aware of, with advice on compliance.
10. Event Etiquette: Provide guidance on general etiquette and behavioral expectations for the event.
11. Special Considerations: Address special considerations like dietary restrictions and accessibility needs.
Please deliver detailed and actionable insights to assist organizers in marketing, planning, and executing a successful event.
""";
    // final response = await _model.generateContent([Content.text(prompt)]);
    final response = await _googleGenerativeAIService.generateResponse(prompt);
    final _insighText = response!.trim();
    // print(_insighText);
    return _insighText;
  }

  static setNull(UserData provider, bool pop, BuildContext context) {
    provider.setInt2(0);
    // provider.setInt1(0);
    provider.setArtist('');
    provider.setEventId('');
    provider.setEventId('');
    provider.setArtist('');
    provider.setAiMarketingDraft('');

    provider.setTitle('');
    provider.setTitleDraft('');

    provider.setTheme('');
    provider.setThemeDraft('');

    provider.setImageUrl('');
    provider.setImageUrlDraft('');

    provider.setAddress('');
    provider.setAddressDraft('');

    provider.setVenue('');
    provider.setVenueDraft('');

    provider.setType('');
    provider.setTypeDraft('');

    provider.setCategory('');
    provider.setCategoryDraft('');

    provider.setStartDateString('');
    provider.setStartDateStringDraft('');

    provider.setClossingDate('');
    provider.setClosingDayStringDraft('');

    provider.setCountry('');
    provider.setCountryDraft('');

    provider.setCity('');
    provider.setCityDraft('');

    provider.setDressCode('');
    provider.setDressingCodeDraft('');

    provider.setTicketSite('');
    provider.setTicketSiteDraft('');

    provider.setCurrency('');
    provider.setCurrencyDraft('');

    provider.setEventTermsAndConditions('');
    provider.setEventTermsAndConditionsDraft('');

    provider.setEventVirtualVenueDraft('');
    provider.setBlurHash('');

    provider.ticket.clear();
    provider.ticketList.clear();
    provider.ticketListDraft.clear();

    provider.schedule.clear();
    provider.scheduleDraft.clear();

    provider.taggedEventPeople.clear();
    provider.taggedEventPeopleDraft.clear();

    provider.setEventImage(null);

    provider.setVideoFile1(null);

    provider.setIsCashPayment(false);
    provider.setIsCashPaymentDraft(false);

    provider.setIsVirtual(false);
    provider.setIsVirtualDraft(false);

    provider.setIsPrivate(false);
    provider.setIsPrivateDraft(false);

    provider.setIsFree(false);
    provider.setIsFreeDraft(false);

    provider.setshowToFollowers(false);
    provider.setShowToFollowersDraft(false);

    provider.setIsAffiliateEnabled(false);
    provider.setIsAffiliateEnabledDraft(false);

    provider.setisAffiliateExclusive(false);

    provider.addressSearchResults = [];

    provider.setCouldntDecodeCity(false);

    provider.setIsExternalTicketPayment(false);
    provider.setIsExternalTicketPaymentDraft(false);

    provider.eventOrganizerContacts.clear();
    provider.eventOrganizerContactsDraft.clear();

    if (pop) Navigator.pop(context);
  }

  ///This method helps to create event
  static Future<void> submitCreate(
    BuildContext context,
    PageController pageController,
    // bool isDraft,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    bool _isLoading = false; // Ensure this variable is handled properly
    if (!_isLoading) {
      FocusScope.of(context).unfocus();
      animateToPage(1, pageController);

      // Call your animation method here
      _isLoading = true;
      String commonId = _provider.eventId;
      // try {
      String imageUrl = _provider.imageUrl;
      Event event = await _createEvent(imageUrl, commonId, context);

      PaletteGenerator _paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(event.imageUrl, errorListener: (_) {
          return;
        }),
        size: Size(1110, 150),
        maximumColorCount: 20,
      );

      DocumentSnapshot doc = await eventsRef
          .doc(_provider.currentUserId)
          .collection('userEvents')
          .doc(commonId)
          .get();

      Event newEvent = await Event.fromDoc(doc);
      await setNull(_provider, true, context);

      // await Future.delayed(Duration(milliseconds: 100));
      _isLoading = false;
      // if (mounted) {
      _navigateToPage(
          context,
          EventEnlargedScreen(
            justCreated: true,
            currentUserId: _provider.currentUserId!,
            event: newEvent,
            type: newEvent.type,
            palette: _paletteGenerator,
            showPrivateEvent: false,
          ));
      mySnackBar(context, 'Your event was published successfully.');
      // }
      // } catch (e) {
      //   _isLoading = false;
      //   animateToBack(1, pageController);
      //   showBottomSheetErrorMessage(context, 'Failed to edit event');
      //   // Handle errors here

      //   // Show error message
      // }
    }
  }

  static Future<Event> _createEvent(
      String imageUrl, String commonId, BuildContext context) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    String link = '';
    // await DatabaseService.myDynamicLink(
    //     imageUrl,
    //     _provider.title,
    //     _provider.theme,
    //     'https://www.barsopus.com/event_${commonId}_${_provider.currentUserId}');

    String insight = '';

    //  await gettInsight(
    //     eventTitle: _provider.title,
    //     eventTheme: _provider.theme,
    //     eventDressCode: _provider.dressCode,
    //     eventAdress: _provider.address,
    //     eventCity: _provider.city,
    //     eventStartDate: _provider.startDate,
    //     isInsight: true);

    Event event = createEvent(
      blurHash: _provider.blurHash,
      imageUrl: imageUrl,
      commonId: commonId,
      link: link,
      insight: insight,
      aiMarketingAdvice: _provider.aiMarketingDraft,
      // aiMarketingAdvice,
      provider: _provider,
    );

    List<TaggedNotificationModel> notificationsSponsorsPartners =
        await _provider.taggedEventPeople.map((person) {
      return TaggedNotificationModel(
          id: person.id,
          taggedParentTitle: event.title, // Assign name to taggedParentTitle
          role: person.role,
          taggedType: person.taggedType,
          verifiedTag: false,
          isEvent: true, // Example value; adjust as needed
          personId: person.internalProfileLink,
          taggedParentId: event.id,
          taggedParentAuthorId: event.authorId,
          taggedParentImageUrl: event.imageUrl);
    }).toList();

    List<TaggedNotificationModel> notificationsSchedulePeople =
        await _provider.schedulePerson.map((person) {
      return TaggedNotificationModel(
          id: person.id,
          taggedParentTitle: event.title, // Assign name to taggedParentTitle
          role: 'Schedule',
          taggedType: 'performer',
          verifiedTag: false,
          isEvent: true, // Example value; adjust as needed
          personId: person.internalProfileLink,
          taggedParentId: event.id,
          taggedParentAuthorId: event.authorId,
          taggedParentImageUrl: event.imageUrl);
    }).toList();

    String summary = '';
    // await summarizeEvent(event);
    await DatabaseService.createEvent(event, _provider.user!,
        notificationsSponsorsPartners + notificationsSchedulePeople, summary);

    return event;
  }

  static Event createEvent({
    required String blurHash,
    required String imageUrl,
    required String commonId,
    required String link,
    required String insight,
    required String aiMarketingAdvice,
    required UserData provider,
  }) {
    return Event(
      blurHash: blurHash,
      imageUrl: imageUrl,
      type: provider.category.isEmpty ? 'Others' : provider.category,
      category: provider.category,
      title: provider.title,
      rate: provider.currency,
      ticket: provider.ticket,
      schedule: provider.schedule,
      taggedPeople: provider.taggedEventPeople,
      venue: provider.venue,
      startDate: provider.startDate,
      time: '',
      theme: provider.theme,
      dressCode: provider.dressCode,
      address: provider.address,
      authorId: provider.currentUserId!,
      timestamp: Timestamp.fromDate(DateTime.now()),
      previousEvent: provider.previousEvent,
      hasDateBeenPostponed: false,
      triller: '',
      report: '',
      reportConfirmed: '',
      city: provider.city,
      country: provider.country,
      virtualVenue: provider.isVirtual ? provider.venue : '',
      ticketSite: provider.ticketSite,
      isVirtual: provider.isVirtual,
      isPrivate: provider.isPrivate,
      showToFollowers: provider.isPrivate ? provider.showToFollowers : false,
      id: commonId,
      isFree: provider.isCashPayment
          ? false
          : provider.ticketSite.isNotEmpty
              ? false
              : provider.isFree,
      isCashPayment: provider.ticketSite.isEmpty
          ? provider.isCashPayment
          : provider.isFree
              ? false
              : false,
      showOnExplorePage: true,
      fundsDistributed: false,
      clossingDay: provider.startDate,
      authorName: provider.user!.userName!,
      termsAndConditions: provider.eventTermsAndConditions,
      dynamicLink: link,
      subaccountId: provider.userLocationPreference!.subaccountId!,
      transferRecepientId:
          provider.userLocationPreference!.transferRecepientId!,
      contacts: provider.eventOrganizerContacts,
      improvemenSuggestion: '',
      isAffiliateEnabled: provider.isAffiliateEnabled,
      isAffiliateExclusive: provider.isAffiliateExclusive,
      totalAffiliateAmount: 0,
      latLng: provider.latLng,
      aiAnalysis: insight,
      overview: provider.overview,
      aiMarketingAdvice: aiMarketingAdvice,
    );
  }

// This method is used to edit event
  static Future<Event> editEvent(
    BuildContext context,
    Event event,
    PageController pageController,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    animateToPage(1, pageController);

    Event _event = Event(
      aiAnalysis: '',
      hasDateBeenPostponed: _provider.clossingDay != event.clossingDay ||
          _provider.startDate != event.startDate,
      blurHash: event.blurHash,
      imageUrl: event.imageUrl,
      type: _provider.category.isEmpty ? 'Others' : _provider.category,
      title: _provider.title,
      rate: _provider.currency,
      ticket: _provider.ticket,
      schedule: _provider.schedule,
      taggedPeople: _provider.taggedEventPeople,
      venue: _provider.venue,
      startDate: _provider.startDate,
      time: '',
      theme: _provider.theme,
      dressCode: _provider.dressCode,
      address: _provider.address,
      authorId: _provider.currentUserId!,
      timestamp: Timestamp.fromDate(DateTime.now()),
      previousEvent: _provider.previousEvent,
      triller: '',
      report: '',
      reportConfirmed: '',
      city: _provider.city,
      country: _provider.country,
      virtualVenue: _provider.isVirtual ? _provider.venue : '',
      ticketSite: _provider.ticketSite,
      isVirtual: _provider.isVirtual,
      isPrivate: _provider.isPrivate,
      id: event.id,
      isFree: _provider.isFree,
      isCashPayment: _provider.isCashPayment,
      showOnExplorePage: true,
      fundsDistributed: false,
      showToFollowers: _provider.bool6,
      clossingDay: _provider.clossingDay,
      authorName: _provider.user!.userName!,
      category: _provider.category,
      termsAndConditions: _provider.eventTermsAndConditions,
      dynamicLink: event.dynamicLink,
      subaccountId: _provider.userLocationPreference!.subaccountId!,
      transferRecepientId:
          _provider.userLocationPreference!.transferRecepientId!,
      contacts: _provider.eventOrganizerContacts,
      improvemenSuggestion: '',
      isAffiliateEnabled: _provider.isAffiliateEnabled,
      isAffiliateExclusive: _provider.isAffiliateExclusive,
      totalAffiliateAmount: 0,
      latLng: _provider.latLng,
      overview: _provider.overview,
      aiMarketingAdvice: '',
    );

    String insight = event.title != _provider.title ||
            event.theme != _provider.theme ||
            event.dressCode != _provider.dressCode ||
            event.city != _provider.city ||
            event.startDate != _provider.startDate
        ? await gettInsight(
            eventTitle: _event.title,
            eventTheme: _event.theme,
            eventDressCode: _event.dressCode,
            eventAdress: _event.address,
            eventCity: _event.city,
            eventStartDate: _event.startDate,
            isInsight: true)
        : event.aiAnalysis;

    String aiMarketingAdvice = _provider.isPrivate
        ? ''
        : event.title != _provider.title ||
                event.theme != _provider.theme ||
                event.dressCode != _provider.dressCode ||
                event.city != _provider.city ||
                event.startDate != _provider.startDate
            ? await gettInsight(
                eventTitle: _event.title,
                eventTheme: _event.theme,
                eventDressCode: _event.dressCode,
                eventAdress: _event.address,
                eventCity: _event.city,
                eventStartDate: _event.startDate,
                isInsight: false)
            : event.aiMarketingAdvice;

    String summary = event.title != _provider.title ||
            event.theme != _provider.theme ||
            event.dressCode != _provider.dressCode ||
            event.city != _provider.city ||
            event.startDate != _provider.startDate
        ? await summarizeEvent(_event)
        : '';

    try {
      await DatabaseService.editEvent(
          _event, insight, summary, aiMarketingAdvice);
      setNull(_provider, true, context);
      mySnackBar(context, 'Saved successfully');
      return _event; // Return the edited event
    } catch (e) {
      // Handle the error
      animateToBack(1, pageController);
      showBottomSheetErrorMessage(context, 'Failed to edit event');
    }
    return _event; // Ensure that an Event is returned even if there's an error
  }

  //Code to animate to previous page
  static animateToBack(
    int index,
    PageController pageController,
  ) {
    pageController.animateToPage(
      pageController.page!.toInt() - index,
      // Provider.of<UserData>(context, listen: false).int1 - index,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  //Code to animate to next page
  static animateToPage(
    int index,
    PageController pageController,
  ) {
    pageController.animateToPage(
      pageController.page!.toInt() + index,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  //Code to display error to page
  static void showBottomSheetErrorMessage(BuildContext context, String e) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: e,
          subTitle: 'Check your internet connection and try again.',
        );
      },
    );
  }

  //Code to navigate to page
  static void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
