import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/airport.dart';

class AirportRepository {
  final SharedPreferences _prefs;

  AirportRepository(this._prefs);

  // Mock airport data for offline use
  static final List<Airport> _mockAirports = [
    Airport(
      airportCode: 'CGK',
      city: 'Jakarta',
      country: 'Indonesia',
      airportName: 'Soekarno-Hatta International Airport',
      flightCount: 100,
      latitude: -6.1256,
      longitude: 106.6558,
      timezone: 'Asia/Jakarta',
    ),
    Airport(
      airportCode: 'NRT',
      city: 'Tokyo',
      country: 'Japan',
      airportName: 'Narita International Airport',
      flightCount: 80,
      latitude: 35.7647,
      longitude: 140.3864,
      timezone: 'Asia/Tokyo',
    ),
    Airport(
      airportCode: 'SIN',
      city: 'Singapore',
      country: 'Singapore',
      airportName: 'Changi Airport',
      flightCount: 120,
      latitude: 1.3644,
      longitude: 103.9915,
      timezone: 'Asia/Singapore',
    ),
    Airport(
      airportCode: 'KUL',
      city: 'Kuala Lumpur',
      country: 'Malaysia',
      airportName: 'Kuala Lumpur International Airport',
      flightCount: 90,
      latitude: 2.7456,
      longitude: 101.7099,
      timezone: 'Asia/Kuala_Lumpur',
    ),
    Airport(
      airportCode: 'BKK',
      city: 'Bangkok',
      country: 'Thailand',
      airportName: 'Suvarnabhumi Airport',
      flightCount: 110,
      latitude: 13.6811,
      longitude: 100.7475,
      timezone: 'Asia/Bangkok',
    ),
    Airport(
      airportCode: 'HKG',
      city: 'Hong Kong',
      country: 'China',
      airportName: 'Hong Kong International Airport',
      flightCount: 95,
      latitude: 22.3089,
      longitude: 113.9144,
      timezone: 'Asia/Hong_Kong',
    ),
    Airport(
      airportCode: 'ICN',
      city: 'Seoul',
      country: 'South Korea',
      airportName: 'Incheon International Airport',
      flightCount: 105,
      latitude: 37.4602,
      longitude: 126.4407,
      timezone: 'Asia/Seoul',
    ),
    Airport(
      airportCode: 'PVG',
      city: 'Shanghai',
      country: 'China',
      airportName: 'Shanghai Pudong International Airport',
      flightCount: 115,
      latitude: 31.1433,
      longitude: 121.8052,
      timezone: 'Asia/Shanghai',
    ),
    Airport(
      airportCode: 'DEL',
      city: 'Delhi',
      country: 'India',
      airportName: 'Indira Gandhi International Airport',
      flightCount: 85,
      latitude: 28.5562,
      longitude: 77.1000,
      timezone: 'Asia/Kolkata',
    ),
    Airport(
      airportCode: 'BOM',
      city: 'Mumbai',
      country: 'India',
      airportName: 'Chhatrapati Shivaji Maharaj International Airport',
      flightCount: 75,
      latitude: 19.0887,
      longitude: 72.8679,
      timezone: 'Asia/Kolkata',
    ),
  ];

  // Get all airports (with search filter)
  List<Airport> getAirports({String search = ''}) {
    if (search.isEmpty) {
      return _mockAirports;
    }

    final searchLower = search.toLowerCase();
    return _mockAirports.where((airport) {
      return airport.airportCode.toLowerCase().contains(searchLower) ||
          airport.city.toLowerCase().contains(searchLower) ||
          airport.country.toLowerCase().contains(searchLower) ||
          airport.airportName.toLowerCase().contains(searchLower);
    }).toList();
  }

  // Get departure airports
  List<Airport> getDepartureAirports({String search = ''}) {
    return getAirports(search: search);
  }

  // Get arrival airports
  List<Airport> getArrivalAirports({String search = ''}) {
    return getAirports(search: search);
  }

  // Get airport by code
  Airport? getAirportByCode(String code) {
    return _mockAirports.firstWhere(
          (airport) => airport.airportCode == code,
      orElse: () => Airport.empty,
    );
  }

  // Get airports by city
  List<Airport> getAirportsByCity(String city) {
    final cityLower = city.toLowerCase();
    return _mockAirports.where(
          (airport) => airport.city.toLowerCase().contains(cityLower),
    ).toList();
  }

  // Get airports by country
  List<Airport> getAirportsByCountry(String country) {
    final countryLower = country.toLowerCase();
    return _mockAirports.where(
          (airport) => airport.country.toLowerCase().contains(countryLower),
    ).toList();
  }

  // Get popular airports
  List<Airport> getPopularAirports() {
    return _mockAirports
        .where((airport) => airport.flightCount > 80)
        .toList()
      ..sort((a, b) => b.flightCount.compareTo(a.flightCount));
  }

  // Get recent airports (from shared preferences)
  List<Airport> getRecentAirports() {
    try {
      final recentCodes = _prefs.getStringList('recent_airports') ?? [];

      return recentCodes.map((code) {
        final airport = getAirportByCode(code);
        return airport;
      }).where((airport) => airport != null && airport.isNotEmpty)
          .cast<Airport>()
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Save airport as recent
  Future<void> saveRecentAirport(String airportCode) async {
    try {
      final recentAirports = _prefs.getStringList('recent_airports') ?? [];

      // Remove if already exists
      recentAirports.remove(airportCode);

      // Add to beginning
      recentAirports.insert(0, airportCode);

      // Keep only last 5
      if (recentAirports.length > 5) {
        recentAirports.removeLast();
      }

      await _prefs.setStringList('recent_airports', recentAirports);
    } catch (e) {
      // Ignore storage errors
    }
  }

  // Clear recent airports
  Future<void> clearRecentAirports() async {
    try {
      await _prefs.remove('recent_airports');
    } catch (e) {
      // Ignore storage errors
    }
  }

  // Get airport suggestions based on search
  List<Airport> getSuggestions(String query) {
    if (query.isEmpty) {
      final recent = getRecentAirports();
      final popular = getPopularAirports()
          .where((airport) => !recent.contains(airport))
          .take(5 - recent.length)
          .toList();
      return [...recent, ...popular];
    }

    return getAirports(search: query)
        .take(10)
        .toList();
  }

  // Calculate distance between two airports (simplified)
  double calculateDistance(Airport from, Airport to) {
    if (from.latitude == null || from.longitude == null ||
        to.latitude == null || to.longitude == null) {
      return 0.0;
    }

    // Haversine formula
    const earthRadius = 6371.0; // Earth's radius in kilometers

    final lat1 = from.latitude! * (pi / 180.0);
    final lon1 = from.longitude! * (pi / 180.0);
    final lat2 = to.latitude! * (pi / 180.0);
    final lon2 = to.longitude! * (pi / 180.0);

    final dlat = lat2 - lat1;
    final dlon = lon2 - lon1;

    final a = sin(dlat / 2) * sin(dlat / 2) +
        cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  // Get estimated flight duration between two airports
  String getEstimatedDuration(Airport from, Airport to) {
    final distance = calculateDistance(from, to);

    // Average flight speed: 900 km/h
    final hours = distance / 900;
    final flightHours = hours.floor();
    final flightMinutes = ((hours - flightHours) * 60).round();

    if (flightHours > 0 && flightMinutes > 0) {
      return '${flightHours}h ${flightMinutes}m';
    } else if (flightHours > 0) {
      return '${flightHours}h';
    } else {
      return '${flightMinutes}m';
    }
  }

  // Get timezone difference between two airports
  String? getTimezoneDifference(Airport from, Airport to) {
    if (from.timezone == null || to.timezone == null) {
      return null;
    }

    // Simplified timezone calculation
    final timezoneMap = {
      'Asia/Jakarta': 7,
      'Asia/Tokyo': 9,
      'Asia/Singapore': 8,
      'Asia/Kuala_Lumpur': 8,
      'Asia/Bangkok': 7,
      'Asia/Hong_Kong': 8,
      'Asia/Seoul': 9,
      'Asia/Shanghai': 8,
      'Asia/Kolkata': 5.5,
    };

    final fromOffset = timezoneMap[from.timezone];
    final toOffset = timezoneMap[to.timezone];

    if (fromOffset == null || toOffset == null) {
      return null;
    }

    final difference = toOffset - fromOffset;

    if (difference == 0) {
      return 'Same timezone';
    } else if (difference > 0) {
      return '+$difference hours';
    } else {
      return '$difference hours';
    }
  }
}