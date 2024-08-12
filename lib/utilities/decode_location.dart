import 'package:bars/utilities/exports.dart';

Future<void> reverseGeocoding(UserData provider, String address) async {
  AddressService addressService = AddressService();

  try {
    try {
      var latLng = await addressService.getLatLngFromAddress(address);
      provider.setLatLng('${latLng['lat']}, ${latLng['lng']}');
      print(
        provider.latLng,
      );
    } catch (e) {
      print(e);
    }
    List<Location> results = await locationFromAddress(address);

    if (results.length > 0) {
      Location firstResult = results.first;
      List<Placemark> placemarks = await placemarkFromCoordinates(
          firstResult.latitude, firstResult.longitude);
      print(firstResult);

      if (placemarks.length > 0 &&
          (placemarks.first.locality != null &&
              placemarks.first.country != null)) {
        Placemark firstPlacemark = placemarks.first;
        print(
            'City: ${firstPlacemark.locality}, Country: ${firstPlacemark.country}');
        provider.setCity(firstPlacemark.locality!.trim());
        provider.setCountry(firstPlacemark.country!.trim());
      }
    }
  } catch (e) {
    print('error mnmnmnnmnmnmnmnmnmnmnmn');
  }

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
