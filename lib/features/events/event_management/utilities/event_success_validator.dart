import 'package:flutter/material.dart';

class EventSuccessValidator {
  final int expectedAttendees;
  final int validatedAttendees;

  EventSuccessValidator(
      {required this.expectedAttendees, required this.validatedAttendees});

  bool validateEvent() {
    // Calculate the percentage of validated attendees
    double attendeePercentage = (validatedAttendees / expectedAttendees) * 100;

    // Check if the percentage of validated attendees is >= 10%
    if (attendeePercentage >= 10) {
      return true;
    }

    // // Check if the number of validated attendees is at least 5
    // if (validatedAttendees >= 5) {
    //   return true;
    // }

    // If neither condition is met, return false
    return false;
  }
}
