import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AffiliateManager {
  static const _eventsKey = 'events_affiliates';

  // Save event ID and affiliate ID as a key-value pair if it does not already exist
  static Future<void> saveEventAffiliateId(
      String eventId, String affiliateId) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing data
    String? eventsAffiliatesJson = prefs.getString(_eventsKey);
    Map<String, String> eventsAffiliates;

    if (eventsAffiliatesJson != null) {
      eventsAffiliates =
          Map<String, String>.from(json.decode(eventsAffiliatesJson));
    } else {
      eventsAffiliates = {};
    }

    // Check if the event ID already exists
    if (!eventsAffiliates.containsKey(eventId)) {
      // Add the event-affiliate pair
      eventsAffiliates[eventId] = affiliateId;

      // Save updated data back to SharedPreferences
      await prefs.setString(_eventsKey, json.encode(eventsAffiliates));
    }
  }

  // Retrieve affiliate ID for a given event ID
  static Future<String?> getAffiliateIdForEvent(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    String? eventsAffiliatesJson = prefs.getString(_eventsKey);

    if (eventsAffiliatesJson != null) {
      Map<String, String> eventsAffiliates =
          Map<String, String>.from(json.decode(eventsAffiliatesJson));
      return eventsAffiliates[eventId];
    }

    return null;
  }

  // Clear a specific event-affiliate pair
  static Future<void> clearEventAffiliateId(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    String? eventsAffiliatesJson = prefs.getString(_eventsKey);

    if (eventsAffiliatesJson != null) {
      Map<String, String> eventsAffiliates =
          Map<String, String>.from(json.decode(eventsAffiliatesJson));
      eventsAffiliates.remove(eventId);
      await prefs.setString(_eventsKey, json.encode(eventsAffiliates));
    }
  }

  // Clear all event-affiliate pairs
  static Future<void> clearAllEventAffiliates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eventsKey);
  }
}
