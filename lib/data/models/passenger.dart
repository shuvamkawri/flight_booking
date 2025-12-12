
import 'package:equatable/equatable.dart';

enum PassengerType { adult, child, infant }
enum TitleType { mr, mrs, ms, miss, dr }

class Passenger extends Equatable {
  final int passengerNumber;
  final TitleType title;
  final String firstName;
  final String lastName;
  final String passportNumber;
  final DateTime? passportExpiry;
  final DateTime? dateOfBirth;
  final PassengerType type;
  final String? seatNumber;
  final String? ticketNumber;
  final String? frequentFlyerNumber;
  final String? profilePicture;
  final Map<String, dynamic>? specialRequests;
  final bool? isWheelchairAssistance;
  final bool? hasSpecialMeal;

  const Passenger({
    required this.passengerNumber,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.passportNumber,
    required this.type,
    this.passportExpiry,
    this.dateOfBirth,
    this.seatNumber,
    this.ticketNumber,
    this.frequentFlyerNumber,
    this.profilePicture,
    this.specialRequests,
    this.isWheelchairAssistance,
    this.hasSpecialMeal,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      passengerNumber: json['passenger_number'] ?? 0,
      title: _parseTitle(json['title'] ?? 'Mr.'),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      passportNumber: json['passport_number'] ?? '',
      type: _parsePassengerType(json['type'] ?? 'adult'),
      passportExpiry: json['passport_expiry'] != null
          ? DateTime.parse(json['passport_expiry'])
          : null,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      seatNumber: json['seat'],
      ticketNumber: json['ticket_number'],
      frequentFlyerNumber: json['frequent_flyer_number'],
      profilePicture: json['profile_picture'],
      specialRequests: json['special_requests'],
      isWheelchairAssistance: json['is_wheelchair_assistance'],
      hasSpecialMeal: json['has_special_meal'],
    );
  }

  static TitleType _parseTitle(String title) {
    switch (title.toLowerCase()) {
      case 'mr.':
      case 'mr':
        return TitleType.mr;
      case 'mrs.':
      case 'mrs':
        return TitleType.mrs;
      case 'ms.':
      case 'ms':
        return TitleType.ms;
      case 'miss':
        return TitleType.miss;
      case 'dr.':
      case 'dr':
        return TitleType.dr;
      default:
        return TitleType.mr;
    }
  }

  static PassengerType _parsePassengerType(String type) {
    switch (type.toLowerCase()) {
      case 'child':
        return PassengerType.child;
      case 'infant':
        return PassengerType.infant;
      default:
        return PassengerType.adult;
    }
  }

  String get titleString {
    switch (title) {
      case TitleType.mr:
        return 'Mr.';
      case TitleType.mrs:
        return 'Mrs.';
      case TitleType.ms:
        return 'Ms.';
      case TitleType.miss:
        return 'Miss';
      case TitleType.dr:
        return 'Dr.';
    }
  }

  String get typeString {
    switch (type) {
      case PassengerType.adult:
        return 'Adult';
      case PassengerType.child:
        return 'Child';
      case PassengerType.infant:
        return 'Infant';
    }
  }

  String get fullName => '$firstName $lastName';
  String get formattedName => '$titleString $firstName $lastName';

  Map<String, dynamic> toJson() {
    return {
      'passenger_number': passengerNumber,
      'title': titleString,
      'first_name': firstName,
      'last_name': lastName,
      'passport_number': passportNumber,
      'type': typeString.toLowerCase(),
      'passport_expiry': passportExpiry?.toIso8601String(),
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'seat': seatNumber,
      'ticket_number': ticketNumber,
      'frequent_flyer_number': frequentFlyerNumber,
      'profile_picture': profilePicture,
      'special_requests': specialRequests,
      'is_wheelchair_assistance': isWheelchairAssistance,
      'has_special_meal': hasSpecialMeal,
    };
  }

  @override
  List<Object?> get props => [
    passengerNumber,
    title,
    firstName,
    lastName,
    passportNumber,
    type,
    passportExpiry,
    dateOfBirth,
    seatNumber,
    ticketNumber,
    frequentFlyerNumber,
    profilePicture,
    specialRequests,
    isWheelchairAssistance,
    hasSpecialMeal,
  ];

  Passenger copyWith({
    int? passengerNumber,
    TitleType? title,
    String? firstName,
    String? lastName,
    String? passportNumber,
    PassengerType? type,
    DateTime? passportExpiry,
    DateTime? dateOfBirth,
    String? seatNumber,
    String? ticketNumber,
    String? frequentFlyerNumber,
    String? profilePicture,
    Map<String, dynamic>? specialRequests,
    bool? isWheelchairAssistance,
    bool? hasSpecialMeal,
  }) {
    return Passenger(
      passengerNumber: passengerNumber ?? this.passengerNumber,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      passportNumber: passportNumber ?? this.passportNumber,
      type: type ?? this.type,
      passportExpiry: passportExpiry ?? this.passportExpiry,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      seatNumber: seatNumber ?? this.seatNumber,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      frequentFlyerNumber: frequentFlyerNumber ?? this.frequentFlyerNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      specialRequests: specialRequests ?? this.specialRequests,
      isWheelchairAssistance: isWheelchairAssistance ?? this.isWheelchairAssistance,
      hasSpecialMeal: hasSpecialMeal ?? this.hasSpecialMeal,
    );
  }

  static List<Passenger> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Passenger.fromJson(json)).toList();
  }

  static const empty = Passenger(
    passengerNumber: 0,
    title: TitleType.mr,
    firstName: '',
    lastName: '',
    passportNumber: '',
    type: PassengerType.adult,
  );

  bool get isEmpty => passengerNumber == 0;
  bool get isNotEmpty => passengerNumber != 0;
}