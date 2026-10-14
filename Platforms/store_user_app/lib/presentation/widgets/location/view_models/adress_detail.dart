class AddressDetail {
  final String country;
  final String city;
  final String? district;
  final String? street;
  final String? neighbourhood;
  final String? postcode;
  final String? displayName;
  final double latitude;
  final double longitude;
  String? countryId;
  String? stateId;

  AddressDetail({
    required this.country,
    required this.city,
    this.district,
    this.street,
    this.neighbourhood,
    this.postcode,
    this.displayName,
    this.countryId,
    this.stateId,
    required this.latitude,
    required this.longitude,
  });

  factory AddressDetail.fromJson(Map<String, dynamic> json) {
    final address = json['address'];
    return AddressDetail(
      country: address['country'] ?? '',
      city: address['province'] ?? address['state'] ?? '',
      district: address['county'] ?? address['town'] ?? '',
      street: address['road'] ?? '',
      neighbourhood: address['suburb'] ?? '',
      postcode: address['postcode'],
      displayName: (address['display_name'] as String?) ?? '',
      stateId: null,
      countryId: null,
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lon']),
    );
  }
}
