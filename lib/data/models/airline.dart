import 'package:equatable/equatable.dart';

class Airline extends Equatable {
  final String name;
  final String code;
  final String logo;
  final String country;
  final String? phoneNumber;
  final String? website;
  final double? rating;
  final int? fleetSize;
  final List<String>? aircraftTypes;
  final bool? isLowCost;

  const Airline({
    required this.name,
    required this.code,
    required this.logo,
    required this.country,
    this.phoneNumber,
    this.website,
    this.rating,
    this.fleetSize,
    this.aircraftTypes,
    this.isLowCost,
  });

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      name: json['airline'] ?? json['name'] ?? '',
      code: json['code'] ?? '',
      logo: json['logo'] ?? '',
      country: json['country'] ?? '',
      phoneNumber: json['phone_number'],
      website: json['website'],
      rating: json['rating'] != null ? double.parse(json['rating'].toString()) : null,
      fleetSize: json['fleet_size'] ?? json['fleetSize'],
      aircraftTypes: json['aircraft_types'] != null
          ? List<String>.from(json['aircraft_types'])
          : null,
      isLowCost: json['is_low_cost'] ?? json['isLowCost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'logo': logo,
      'country': country,
      'phone_number': phoneNumber,
      'website': website,
      'rating': rating,
      'fleet_size': fleetSize,
      'aircraft_types': aircraftTypes,
      'is_low_cost': isLowCost,
    };
  }

  @override
  List<Object?> get props => [
    name,
    code,
    logo,
    country,
    phoneNumber,
    website,
    rating,
    fleetSize,
    aircraftTypes,
    isLowCost,
  ];

  Airline copyWith({
    String? name,
    String? code,
    String? logo,
    String? country,
    String? phoneNumber,
    String? website,
    double? rating,
    int? fleetSize,
    List<String>? aircraftTypes,
    bool? isLowCost,
  }) {
    return Airline(
      name: name ?? this.name,
      code: code ?? this.code,
      logo: logo ?? this.logo,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      rating: rating ?? this.rating,
      fleetSize: fleetSize ?? this.fleetSize,
      aircraftTypes: aircraftTypes ?? this.aircraftTypes,
      isLowCost: isLowCost ?? this.isLowCost,
    );
  }

  static List<Airline> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Airline.fromJson(json)).toList();
  }

  static const empty = Airline(
    name: '',
    code: '',
    logo: '',
    country: '',
  );

  bool get isEmpty => name.isEmpty;
  bool get isNotEmpty => name.isNotEmpty;

  String get displayName {
    if (code.isNotEmpty) {
      return '$name ($code)';
    }
    return name;
  }
}