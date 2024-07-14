import 'package:bars/features/creatives/models/place_search_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    final key = 'AIzaSyBzHyTS-J9Ge8ohh8A1fZANeLqQbGHcGQY';
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }
}
