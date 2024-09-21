import 'package:bars/utilities/exports.dart';
import 'package:blurhash/blurhash.dart';
import 'package:uuid/uuid.dart';

class EventDatabaseDraft {
// Method to create event
  static submitDraft(
    BuildContext context,
    bool isLoading,
    Event? event,
    bool isDraft,
    PageController pageController,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    if (!isLoading) {
      isLoading = true;

      try {
        isDraft || _provider.eventId.isNotEmpty
            ? await _editEventDraft(context, pageController, event, isDraft)
            : await _createEventDraft(context, pageController);
        isLoading = false;
      } catch (e) {
        isLoading = false;
        EventDatabase.showBottomSheetErrorMessage(
          context,
          'Could not save event to draft.',
        );
      }
    }
  }

  //edit draft type and dates
  static submitEditDraftTypeAndDate(
    BuildContext context,
    bool isLoading,
    Event? event,
    bool isDraft,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    if (!isLoading) {
      isLoading = true;

      try {
        await DatabaseService.editEventDraftTypeAndDates(
          type: _provider.category.isEmpty ? 'Others' : _provider.category,
          category: _provider.category,
          startDate: _provider.startDate,
          closingDay: _provider.clossingDay,
          event: event,
          provider: _provider,
          isDraft: isDraft,
        );

        isLoading = false;
      } catch (e) {
        isLoading = false;
        EventDatabase.showBottomSheetErrorMessage(
          context,
          e.toString(),
        );
      }
    }
  }

  //edit draft type and dates
  static submitEditDraftTitleTheme(
    BuildContext context,
    bool isLoading,
    Event? event,
    bool isDraft,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    if (!isLoading) {
      isLoading = true;

      String aiMarketingAdvice = _provider.isPrivate
          ? ''
          : event != null
              ? event.title != _provider.title ||
                      event.theme != _provider.theme ||
                      event.dressCode != _provider.dressCode ||
                      event.city != _provider.city ||
                      event.startDate != _provider.startDate
                  ? await EventDatabase.gettInsight(
                      eventTitle: _provider.title,
                      eventTheme: _provider.theme,
                      eventDressCode: _provider.dressCode,
                      eventAdress: _provider.address,
                      eventCity: _provider.city,
                      eventStartDate: _provider.startDate,
                      isInsight: false)
                  : event.aiMarketingAdvice
              : _provider.titleDraft != _provider.title ||
                      _provider.themeDraft != _provider.theme ||
                      _provider.dressingCodeDraft != _provider.dressCode ||
                      _provider.cityDraft != _provider.city ||
                      _provider.startDateDraft != _provider.startDate
                  ? await EventDatabase.gettInsight(
                      eventTitle: _provider.title,
                      eventTheme: _provider.theme,
                      eventDressCode: _provider.dressCode,
                      eventAdress: _provider.address,
                      eventCity: _provider.city,
                      eventStartDate: _provider.startDate,
                      isInsight: false)
                  : _provider.aiMarketingDraft;

      try {
        await DatabaseService.editEventTitleAndThemeDraft(
          aiMarketingAdvice: aiMarketingAdvice,
          title: _provider.title,
          theme: _provider.theme,
          overView: _provider.overview,
          dressCode: _provider.dressCode,
          city: _provider.city,
          country: _provider.country,
          event: event,
          provider: _provider,
          isDraft: isDraft,
        );
        isLoading = false;
      } catch (e) {
        isLoading = false;

        EventDatabase.showBottomSheetErrorMessage(
          context,
          e.toString(),
        );
      }
    }
  }

  //edit draft type and dates
  static submitEditDraftScheduleAndDate(
    BuildContext context,
    bool isLoading,
    Event? event,
    bool isDraft,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (!isLoading) {
      isLoading = true;

      try {
        await DatabaseService.editEventDraftScheduleAndTicket(
          provider: _provider,
          ticket: _provider.ticket,
          schedule: _provider.schedule,
          event: event,
          currency: _provider.currency,
          isDraft: isDraft,
        );

        isLoading = false;
      } catch (e) {
        isLoading = false;

        EventDatabase.showBottomSheetErrorMessage(
          context,
          e.toString(),
        );
      }
    }
  }

  //edit draft type and dates
  static submitEditDraftVenueAndPeople(
    BuildContext context,
    Event? event,
    bool isLoading,
    bool isDraft,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    if (!isLoading) {
      isLoading = true;
      try {
        await DatabaseService.editEventDraftAddressAndPeople(
          provider: _provider,
          taggedPeople: _provider.taggedEventPeople,
          venue: _provider.venue,
          event: event,
          address: _provider.address,
          isDraft: isDraft,
          city: _provider.city,
          country: _provider.country,
        );
        isLoading = false;
      } catch (e) {
        isLoading = false;
        EventDatabase.showBottomSheetErrorMessage(
          context,
          e.toString(),
        );
      }
    }
  }

  //edit draft ContactAndTerms
  static submitEditDrafContactAndTerms(
    BuildContext context,
    Event? event,
    bool isLoading,
    bool isDraft,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    if (!isLoading) {
      isLoading = true;

      try {
        await DatabaseService.editEventDraftContactAndTerms(
          provider: _provider,
          termsAndConditions: _provider.termAndConditions,
          previousEvent: _provider.previousEvent,
          event: event,
          contacts: _provider.eventOrganizerContacts,
          isDraft: isDraft,
        );
        isLoading = false;
      } catch (e) {
        isLoading = false;
        EventDatabase.showBottomSheetErrorMessage(
          context,
          e.toString(),
        );
      }
    }
  }

  static _editEventDraft(
    BuildContext context,
    PageController pageController,
    Event? event,
    bool isDraft,
  ) async {
    animateToPage(1, pageController);
    var _provider = Provider.of<UserData>(context, listen: false);
    String commonId = isDraft ? event!.id : _provider.eventId;
    String _imageUrl = '';
    if (_provider.eventImage == null) {
      _imageUrl = event!.imageUrl;
    } else {
      _imageUrl =
          await StorageService.uploadEvent(_provider.eventImage!, commonId);
    }

    _provider.setImageUrl(_imageUrl);
    await DatabaseService.editEventDraft(
      isDraft: isDraft,
      imageUrl: _imageUrl,
      venue: _provider.venue,
      isPrivate: _provider.isPrivate,
      isVirtual: _provider.isVirtual,
      isFree: _provider.isCashPayment
          ? false
          : _provider.ticketSite.isNotEmpty
              ? false
              : _provider.isFree,
      isCashPayment: _provider.ticketSite.isEmpty
          ? _provider.isCashPayment
          : _provider.isFree
              ? false
              : false,
      showOnExplorePage: true,
      showToFollowers: _provider.isPrivate ? _provider.showToFollowers : false,
      event: event,
      provider: _provider,
    );
  }

  static _createEventDraft(
    BuildContext context,
    PageController pageController,
  ) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setIsLoading(true);
    String commonId = Uuid().v4();
    String _imageUrl =
        await StorageService.uploadEvent(_provider.eventImage!, commonId);
    _provider.setImageUrl(_imageUrl);
    Uint8List bytes = await (_provider.eventImage!).readAsBytes();
    var blurHash = await BlurHash.encode(bytes, 4, 3);
    _provider.setBlurHash(blurHash);

    Event event = EventDatabase.createEvent(
      blurHash: blurHash,
      imageUrl: _imageUrl,
      commonId: commonId,
      link: '',
      insight: '',
      aiMarketingAdvice: '',
      provider: _provider,
    );

    await DatabaseService.createEventDraft(
      event,
      _provider,
    );
    animateToPage(1, pageController);
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
  void showBottomSheetErrorMessage(context, String e) {
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
}
