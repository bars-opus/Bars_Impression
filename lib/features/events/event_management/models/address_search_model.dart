class AddressSearch {
  final String description;
  final String placeId;

  AddressSearch({required this.description, required this.placeId});

  factory AddressSearch.fromJson(Map<String, dynamic> json) {
    return AddressSearch(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}
