// This method uses the Google Maps Places Autocomplete API to fetch a list of address suggestions

import 'package:bars/features/events/event_management/models/address_search_model.dart';
import 'package:bars/utilities/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AddressService {
  final String apiKey = GooglemapApiKey.GOOGLEMAPAPI_KEY;

  Future<List<AddressSearch>> getAutocomplete(String search) async {
    // based on the provided search string. It returns a list of AddressSearch objects.
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=establishment&key=$apiKey';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    // If the API request is denied due to an invalid API key, throw an exception
    if (json['status'] == 'REQUEST_DENIED') {
      throw Exception('Request denied: ${json['error_message']}');
    }

    // Parse the response JSON and return a list of AddressSearch objects
    var jsonResults = json['predictions'] as List;
    return jsonResults
        .map((address) => AddressSearch.fromJson(address))
        .toList();
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    // This method uses the Google Maps Places Details API to fetch the latitude and longitude
    // of a specific place based on the provided place ID.
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    // If the API request is denied due to an invalid API key, throw an exception
    if (json['status'] == 'REQUEST_DENIED') {
      throw Exception('Request denied: ${json['error_message']}');
    }
    // Extract the latitude and longitude from the response JSON and return them as a map
    var location = json['result']['geometry']['location'];
    return {'lat': location['lat'], 'lng': location['lng']};
  }

  Future<Map<String, dynamic>> getLatLngFromAddress(String search) async {
    // This method first uses the getAutocomplete method to fetch a list of address suggestions
    // based on the provided search string. It then uses the getPlaceDetails method to fetch
    // the latitude and longitude of the first address in the list.
    List<AddressSearch> addresses = await getAutocomplete(search);
    if (addresses.isNotEmpty) {
      AddressSearch firstAddress = addresses.first;
      return await getPlaceDetails(firstAddress.placeId);
    } else {
      throw Exception('No addresses found');
    }
  }
}
