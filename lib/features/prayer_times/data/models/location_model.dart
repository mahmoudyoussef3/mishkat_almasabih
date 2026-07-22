class LocationModel {
  final double latitude;
  final double longitude;
  final String cityName;
  final String timezone;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.timezone,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'timezone': timezone,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 30.0444,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 31.2357,
      cityName: json['cityName'] as String? ?? 'القاهرة، مصر',
      timezone: json['timezone'] as String? ?? '+2.0',
    );
  }

  static const LocationModel defaultLocation = LocationModel(
    latitude: 30.0444,
    longitude: 31.2357,
    cityName: 'القاهرة، مصر',
    timezone: '+2.0',
  );

  static const List<LocationModel> egyptianCities = [
    LocationModel(
      latitude: 30.0444,
      longitude: 31.2357,
      cityName: 'القاهرة',
      timezone: '+2.0',
    ),
    LocationModel(
      latitude: 31.2001,
      longitude: 29.9187,
      cityName: 'الإسكندرية',
      timezone: '+2.0',
    ),
    LocationModel(
      latitude: 26.8206,
      longitude: 30.8025,
      cityName: 'أسيوط',
      timezone: '+2.0',
    ),
    LocationModel(
      latitude: 25.6872,
      longitude: 32.6396,
      cityName: 'الأقصر',
      timezone: '+2.0',
    ),
    LocationModel(
      latitude: 24.0889,
      longitude: 32.8998,
      cityName: 'أسوان',
      timezone: '+2.0',
    ),
    LocationModel(
      latitude: 31.0409,
      longitude: 31.3785,
      cityName: 'المنصورة',
      timezone: '+2.0',
    ),
    LocationModel(
      latitude: 27.1809,
      longitude: 31.1837,
      cityName: 'المنيا',
      timezone: '+2.0',
    ),
    LocationModel(
      latitude: 30.5965,
      longitude: 31.5084,
      cityName: 'بنها',
      timezone: '+2.0',
    ),
  ];

  @override
  String toString() => cityName;
}
