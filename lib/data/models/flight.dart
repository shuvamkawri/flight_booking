import 'package:equatable/equatable.dart';

class Flight extends Equatable {
  final int id;
  final String airlineName;
  final String airlineLogo;
  final String flightNumber;
  final DateTime departureTime;
  final String departureAirportCode;
  final String departureCity;
  final DateTime arrivalTime;
  final String arrivalAirportCode;
  final String arrivalCity;
  final String duration;
  final double price;
  final String currency;
  final String aircraftType;
  final int stops;
  final String? terminal;
  final String? gate;
  final String? flightClass;

  const Flight({
    required this.id,
    required this.airlineName,
    required this.airlineLogo,
    required this.flightNumber,
    required this.departureTime,
    required this.departureAirportCode,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalAirportCode,
    required this.arrivalCity,
    required this.duration,
    required this.price,
    required this.currency,
    required this.aircraftType,
    required this.stops,
    this.terminal,
    this.gate,
    this.flightClass,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    final departureTimeParts = (json['departure']['time'] as String).split(':');
    final arrivalTimeParts = (json['arrival']['time'] as String).split(':');

    final now = DateTime.now();
    final departureTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(departureTimeParts[0]),
      int.parse(departureTimeParts[1]),
    );

    final arrivalTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(arrivalTimeParts[0]),
      int.parse(arrivalTimeParts[1]),
    );

    return Flight(
      id: json['id'] ?? 0,
      airlineName: json['airline_name'] ?? '',
      airlineLogo: json['airline_logo'] ?? '',
      flightNumber: json['flight_number'] ?? '',
      departureTime: departureTime,
      departureAirportCode: json['departure']['airport_code'] ?? '',
      departureCity: json['departure']['city'] ?? '',
      arrivalTime: arrivalTime,
      arrivalAirportCode: json['arrival']['airport_code'] ?? '',
      arrivalCity: json['arrival']['city'] ?? '',
      duration: json['duration'] ?? '',
      price: (json['price']['amount'] ?? 0).toDouble(),
      currency: json['price']['currency'] ?? 'USD',
      aircraftType: json['aircraft_type'] ?? '',
      stops: json['stops'] ?? 0,
      terminal: json['terminal'],
      gate: json['gate'],
      flightClass: json['class'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airline_name': airlineName,
      'airline_logo': airlineLogo,
      'flight_number': flightNumber,
      'departure': {
        'time': '${departureTime.hour.toString().padLeft(2, '0')}:${departureTime.minute.toString().padLeft(2, '0')}:00',
        'airport_code': departureAirportCode,
        'city': departureCity,
      },
      'arrival': {
        'time': '${arrivalTime.hour.toString().padLeft(2, '0')}:${arrivalTime.minute.toString().padLeft(2, '0')}:00',
        'airport_code': arrivalAirportCode,
        'city': arrivalCity,
      },
      'duration': duration,
      'price': {
        'amount': price,
        'currency': currency,
      },
      'aircraft_type': aircraftType,
      'stops': stops,
      'terminal': terminal,
      'gate': gate,
      'class': flightClass,
    };
  }

  @override
  List<Object?> get props => [
    id,
    airlineName,
    flightNumber,
    departureTime,
    arrivalTime,
    price,
  ];
}