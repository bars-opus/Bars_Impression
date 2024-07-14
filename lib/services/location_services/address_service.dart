import 'package:bars/features/events/event_management/models/address_search_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AddressService {
  final String apiKey = 'AIzaSyBzHyTS-J9Ge8ohh8A1fZANeLqQbGHcGQY';

  Future<List<AddressSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=establishment&key=$apiKey';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    if (json['status'] == 'REQUEST_DENIED') {
      throw Exception('Request denied: ${json['error_message']}');
    }

    var jsonResults = json['predictions'] as List;
    return jsonResults
        .map((address) => AddressSearch.fromJson(address))
        .toList();
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    if (json['status'] == 'REQUEST_DENIED') {
      throw Exception('Request denied: ${json['error_message']}');
    }

    var location = json['result']['geometry']['location'];
    return {'lat': location['lat'], 'lng': location['lng']};
  }

  Future<Map<String, dynamic>> getLatLngFromAddress(String search) async {
    List<AddressSearch> addresses = await getAutocomplete(search);
    if (addresses.isNotEmpty) {
      AddressSearch firstAddress = addresses.first;
      return await getPlaceDetails(firstAddress.placeId);
    } else {
      throw Exception('No addresses found');
    }
  }
}
// class AddressService {
//   Future<List<AddressSearch>> getAutocomplete(String search) async {
//     final key = 'AIzaSyBzHyTS-J9Ge8ohh8A1fZANeLqQbGHcGQY';
//     var url =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=establishment&key=$key';
//     var response = await http.get(Uri.parse(url));
//     var json = convert.jsonDecode(response.body);
//     var jsonResults = json['predictions'] as List;
//     return jsonResults
//         .map((address) => AddressSearch.fromJson(address))
//         .toList();
//   }
// }
