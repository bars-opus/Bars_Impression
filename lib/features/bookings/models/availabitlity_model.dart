// The Availability model will capture the availability schedule of a creative.
// It should be designed to efficiently handle and query availability data.
// If the calendar is meant to show when a creative (e.g., a service provider)
//  is available, you would display the availability model.
// Target User: Organizer (someone looking to book a creative).
// Displayed Data: Dates and times when the creative is available.
// Purpose: To help organizers find and select available slots for booking.

class Availability {
  String userId;
  List<DateTime> availableDates;
  DateTime lastModified;

  Availability({
    required this.userId,
    required this.availableDates,
    required this.lastModified,
  });

  // Serialization
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'availableDates':
          availableDates.map((date) => date.toIso8601String()).toList(),
      'lastModified': lastModified.toIso8601String(),
    };
  }

  // Deserialization
  factory Availability.fromMap(Map<String, dynamic> map) {
    return Availability(
      userId: map['userId'],
      availableDates: List<DateTime>.from(
          map['availableDates'].map((date) => DateTime.parse(date))),
      lastModified: DateTime.parse(map['lastModified']),
    );
  }
}
