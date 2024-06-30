import 'package:bars/utilities/exports.dart';

Future<void> reverseGeocoding(UserData provider, String address) async {
  try {
    print(address);
    List<Location> results = await locationFromAddress(address);

    if (results != null && results.length > 0) {
      Location firstResult = results.first;
      List<Placemark> placemarks = await placemarkFromCoordinates(
          firstResult.latitude, firstResult.longitude);

      if (placemarks != null &&
          placemarks.length > 0 &&
          (placemarks.first.locality != null &&
              placemarks.first.country != null)) {
        Placemark firstPlacemark = placemarks.first;
        print(
            'City: ${firstPlacemark.locality}, Country: ${firstPlacemark.country}');
        provider.setCity(firstPlacemark.locality!.trim());
        provider.setCountry(firstPlacemark.country!.trim());
      }
    }
  } catch (e) {}

  if (provider.city.isEmpty) {
    // Fallback to string parsing
    List<String> parts = address.split(',');
    if (parts.length > 2) {
      String country = parts[parts.length - 1].trim();
      String stateOrProvince = parts[parts.length - 2].trim();
      String city = parts.length > 3 && stateOrProvince.length <= 2
          ? parts[parts.length - 3].trim()
          : parts[parts.length - 2].trim();
      provider.setCity(city.trim());
      provider.setCountry(country.trim());
      provider.setCouldntDecodeCity(true);
    }
  }
}
