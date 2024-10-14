/// The `ShopBookinSummary` widget displays a summary of event invitations
/// received by the user. It fetches and analyzes invitation data,
/// providing insights using an AI service. The widget supports viewing
/// detailed invitation information and highlights the total number of events.

import 'package:bars/features/gemini_ai/presentation/widgets/shop_booking_summary_widget.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class ShopBookinSummary extends StatefulWidget {
  final List<BookingAppointmentModel> bookings;
  final String shopType;

  const ShopBookinSummary(
      {super.key, required this.bookings, required this.shopType});

  @override
  State<ShopBookinSummary> createState() => _ShopBookinSummaryState();
}

class _ShopBookinSummaryState extends State<ShopBookinSummary> {
  final _googleGenerativeAIService = GoogleGenerativeAIService();
  // List<BookingAppointmentModel> _bookings = [];
  List<String> _analysisResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchBooking();
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // _fetchBooking(); // Call it here
  // }

  /// Prepares invitation data for analysis by formatting each invitation
  /// into a string that can be processed by  Gemini AI.
  String prepareActivitiesForAnalysis(List<BookingAppointmentModel> bookings) {
    return bookings.map((booking) {
      return booking.appointment.map((appointment) {
        return '''
The category of service they are booking for: ${appointment.service}
The type of the category of service: ${appointment.type}
The time it would take to render the service: ${appointment.duruation}
The price that would be paid for the service: ${appointment.price}
The time slot for the service: ${appointment.selectedSlot?.format(context)}
The date the service was booked: ${MyDateFormat.toDate(booking.bookingDate.toDate())}
The worker(s) providing the service: ${appointment.workers.map((worker) => worker.name).join(', ')}
Shop: ${booking.shopName}, Location: ${booking.location}
''';
      }).join('\n\n');
    }).join('\n\n');
  }

  /// Sets up the invitation data by fetching it from firebase.
  /// It processes each invite and sends it for analysis.
  Future<void> _fetchBooking() async {
    // print(widget.bookings.length);
    // var _provider = Provider.of<UserData>(context, listen: false);

    try {
      // List<BookingAppointmentModel> allBookingModels = [];
      // DocumentSnapshot? lastDocument;

      // // Fetch invitations from the database in batches
      // while (true) {
      //   Query query = newBookingsReceivedRef
      //       .doc(_provider.currentUserId)
      //       .collection('bookings')
      //       .orderBy('timestamp', descending: true)
      //       .limit(10);

      //   if (lastDocument != null) {
      //     query = query.startAfterDocument(lastDocument);
      //   }

      //   QuerySnapshot snapshot = await query.get();

      //   if (snapshot.docs.isEmpty) break;

      //   List<BookingAppointmentModel> batchBookedAppointmentModels = snapshot
      //       .docs
      //       .map((doc) => BookingAppointmentModel.fromDoc(doc))
      //       .toList();
      //   allBookingModels.addAll(batchBookedAppointmentModels);
      //   lastDocument = snapshot.docs.last;
      // }

      // if (allBookingModels.isEmpty) {
      //   if (mounted) {
      //     setState(() {
      //       _bookings = [];
      //       _isLoading = false;
      //     });
      //   }
      //   return; // Exit if no invitations
      // }

      // Analyze the invitations in batches
      List<String> analysisResults =
          await batchAnalyzeActivitiesWithGemini(widget.bookings);

      if (mounted) {
        setState(() {
          _analysisResults = analysisResults;
          // _bookings = widget.bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      //   // mySnackBar(context, 'An error occured');
    }
  }

  /// Analyzes invitation data in batches using the AI service.
  Future<List<String>> batchAnalyzeActivitiesWithGemini(
      List<BookingAppointmentModel> activities) async {
    int batchSize = 10;
    List<String> analysisResults = [];

    for (int i = 0; i < activities.length; i += batchSize) {
      List<BookingAppointmentModel> batch =
          activities.skip(i).take(batchSize).toList();
      String preparedData = prepareActivitiesForAnalysis(batch);
      String analysis = await analyzeActivitiesWithGemini(preparedData);
      analysisResults.add(analysis);
    }

    return analysisResults;
  }

  /// Sends prepared invitation data to the AI service for analysis.
  Future<String> analyzeActivitiesWithGemini(String preparedData) async {
    // var _provider = Provider.of<UserData>(context, listen: false);

    final prompt = '''
Analyze the following booking infomation for my ${widget.shopType} and provide a summary of the booking data I have received:
$preparedData
''';

    final response = await _googleGenerativeAIService.generateResponse(prompt);
    return response!;
  }

  /// Builds a row widget for displaying a summary with an icon.
  Widget _summaryRow(IconData icon, String summary, bool isTotal) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.responsiveHeight(context, 20),
          color: isTotal ? Colors.white : Colors.red,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            summary,
            style: TextStyle(
              color: isTotal
                  ? Colors.white
                  : Theme.of(context).secondaryHeaderColor,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
            ),
          ),
        ),
      ],
    );
  }

  /// Displays a bottom sheet with the list of invitations.
  void _showActivities() {
    var _provider = Provider.of<UserData>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: ResponsiveHelper.responsiveHeight(context, 680),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  TicketPurchasingIcon(title: ''),
                  Container(
                    // color: Colors.blue,
                    height: ResponsiveHelper.responsiveHeight(context, 630),
                    child: ListView.builder(
                      itemCount: widget.bookings.length,
                      itemBuilder: (BuildContext context, int index) {
                        final appoinmentOrder = widget.bookings[index];
                        return UserAppointmenstWidget(
                          // ticketOrder: ticketOrder,
                          currentUserId: _provider.currentUserId!,
                          appointmentList: widget.bookings,
                          appointmentOrder: appoinmentOrder,
                        );
                        // InviteContainerWidget(invite: _invite);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Builds a widget to display the notification count with an icon.
  Widget _notificationCount() {
    return GestureDetector(
      onTap: () => _showActivities(),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: _summaryRow(
          Icons.event_available_outlined,
          "${NumberFormat.compact().format(widget.bookings.length)} events in total",
          true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context);
    String analysisText = _analysisResults.join('\n\n');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(20),
        height: ResponsiveHelper.responsiveHeight(context, 650.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: _isLoading
            ? Center(
                child: Loading(
                  shakeReapeat: false,
                  color: Theme.of(context).secondaryHeaderColor,
                  title: 'processing...',
                  icon: (FontAwesomeIcons.circle),
                ),
              )
            : widget.bookings.isEmpty
                ? Center(
                    child: NoContents(
                      isFLorence: true,
                      title: "",
                      subTitle:
                          "Hey, You have not received any event invitations to analyze",
                      icon: null,
                    ),
                  )
                : analysisText.isEmpty
                    ? Center(
                        child: NoContents(
                          isFLorence: true,
                          title: "",
                          subTitle:
                              "Sorry i could not analyse your bookings now. Let's try again later",
                          icon: null,
                        ),
                      )
                    : Material(
                        color: Colors.transparent,
                        child: ListView(
                          children: [
                            const SizedBox(height: 30),
                            Center(
                              child: ShakeTransition(
                                axis: Axis.vertical,
                                duration: Duration(seconds: 2),
                                child: AnimatedCircle(
                                  size: 30,
                                  stroke: 2,
                                  animateSize: true,
                                  animateShape: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Text(
                              'Hi ${_provider.user!.userName!}.  This is a summary of all your events invitations',
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12.0),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _notificationCount(),
                            ShopBookingSummaryWidget(bookings: widget.bookings),
                            const SizedBox(height: 20),
                            MarkdownBody(
                              data: analysisText,
                              styleSheet: MarkdownStyleSheet(
                                h1: Theme.of(context).textTheme.titleLarge,
                                h2: Theme.of(context).textTheme.titleMedium,
                                p: Theme.of(context).textTheme.bodyMedium,
                                listBullet:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
