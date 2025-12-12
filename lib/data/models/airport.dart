import 'package:equatable/equatable.dart';

class Airport extends Equatable {
  final String airportCode;
  final String city;
  final String country;
  final String airportName;
  final int flightCount;
  final double? latitude;
  final double? longitude;
  final String? timezone;

  const Airport({
    required this.airportCode,
    required this.city,
    required this.country,
    required this.airportName,
    required this.flightCount,
    this.latitude,
    this.longitude,
    this.timezone,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      airportCode: json['airport_code'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      airportName: json['airport_name'] ?? '',
      flightCount: json['flight_count'] ?? 0,
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : null,
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airport_code': airportCode,
      'city': city,
      'country': country,
      'airport_name': airportName,
      'flight_count': flightCount,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
    };
  }

  String get displayName => '$airportCode - $city, $country';
  String get shortDisplayName => '$airportCode - $city';

  @override
  List<Object?> get props => [
    airportCode,
    city,
    country,
    airportName,
    flightCount,
    latitude,
    longitude,
    timezone,
  ];

  Airport copyWith({
    String? airportCode,
    String? city,
    String? country,
    String? airportName,
    int? flightCount,
    double? latitude,
    double? longitude,
    String? timezone,
  }) {
    return Airport(
      airportCode: airportCode ?? this.airportCode,
      city: city ?? this.city,
      country: country ?? this.country,
      airportName: airportName ?? this.airportName,
      flightCount: flightCount ?? this.flightCount,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
    );
  }

  static List<Airport> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Airport.fromJson(json)).toList();
  }

  static const empty = Airport(
    airportCode: '',
    city: '',
    country: '',
    airportName: '',
    flightCount: 0,
  );

  bool get isEmpty => airportCode.isEmpty;
  bool get isNotEmpty => airportCode.isNotEmpty;
}