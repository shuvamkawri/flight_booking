import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constant/app_constants.dart';
import '../../core/services/api_services.dart';
import '../models/airline.dart';
import '../models/airport.dart';
import '../models/flight.dart';


class FlightRepository {
  final ApiService _apiService = ApiService();
  final SharedPreferences _prefs;

  FlightRepository(this._prefs);

  // Search flights with filters
  Future<Map<String, dynamic>> searchFlights({
    required String from,
    required String to,
    required DateTime date,
    required int passengers,
    String sortBy = 'price_asc',
    Map<String, dynamic>? filters,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // Call API
      final response = await _apiService.searchFlights(
        from: from,
        to: to,
        date: date,
        passengers: passengers,
        sortBy: sortBy,
        filters: filters,
        page: page,
        limit: limit,
      );

      if (response['status'] == 'success') {
        // Parse flights
        final List<Flight> flights = (response['data']['flights'] as List)
            .map((flightJson) => Flight.fromJson(flightJson))
            .toList();

        // Get pagination info
        final pagination = response['data']['pagination'];

        // Save recent search
        _saveRecentSearch(
          from: from,
          to: to,
          date: date,
          passengers: passengers,
        );

        return {
          'status': 'success',
          'flights': flights,
          'pagination': pagination,
          'searchParams': response['data']['search_params'],
        };
      } else {
        return {
          'status': 'error',
          'message': response['message'] ?? 'Failed to search flights',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }

  // Get flight details
  Future<Map<String, dynamic>> getFlightDetails(int id) async {
    try {
      final response = await _apiService.getFlightDetails(id);

      if (response['status'] == 'success') {
        final flight = Flight.fromJson(response['data']['flight_details']);

        // Parse passengers if available
        List<dynamic>? passengers;
        if (response['data']['passengers'] != null) {
          passengers = response['data']['passengers'];
        }

        // Get booking info
        final bookingInfo = response['data']['booking_info'];

        return {
          'status': 'success',
          'flight': flight,
          'passengers': passengers,
          'bookingInfo': bookingInfo,
        };
      } else {
        return {
          'status': 'error',
          'message': response['message'] ?? 'Failed to get flight details',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }

  // Get departure airports
  Future<Map<String, dynamic>> getDepartureAirports({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.getDepartureAirports(
        search: search,
        page: page,
        limit: limit,
      );

      if (response['status'] == 'success') {
        final List<Airport> airports = (response['data']['airports'] as List)
            .map((airportJson) => Airport.fromJson(airportJson))
            .toList();

        final pagination = response['data']['pagination'];

        return {
          'status': 'success',
          'airports': airports,
          'pagination': pagination,
        };
      } else {
        return {
          'status': 'error',
          'message': response['message'] ?? 'Failed to get airports',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }

  // Get arrival airports
  Future<Map<String, dynamic>> getArrivalAirports({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.getArrivalAirports(
        search: search,
        page: page,
        limit: limit,
      );

      if (response['status'] == 'success') {
        final List<Airport> airports = (response['data']['airports'] as List)
            .map((airportJson) => Airport.fromJson(airportJson))
            .toList();

        final pagination = response['data']['pagination'];

        return {
          'status': 'success',
          'airports': airports,
          'pagination': pagination,
        };
      } else {
        return {
          'status': 'error',
          'message': response['message'] ?? 'Failed to get airports',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }

  // Get airlines
  Future<Map<String, dynamic>> getAirlines({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.getAirlines(
        search: search,
        page: page,
        limit: limit,
      );

      if (response['status'] == 'success') {
        final List<Airline> airlines = (response['data']['airlines'] as List)
            .map((airlineJson) => Airline.fromJson(airlineJson))
            .toList();

        final pagination = response['data']['pagination'];

        return {
          'status': 'success',
          'airlines': airlines,
          'pagination': pagination,
        };
      } else {
        return {
          'status': 'error',
          'message': response['message'] ?? 'Failed to get airlines',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }

  // Get aircraft types
  Future<Map<String, dynamic>> getAircraftTypes({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.getAircraftTypes(
        search: search,
        page: page,
        limit: limit,
      );

      if (response['status'] == 'success') {
        final List<String> aircraftTypes = (response['data']['aircraft_types'] as List)
            .map((type) => type['aircraft'] as String)
            .toList();

        final pagination = response['data']['pagination'];

        return {
          'status': 'success',
          'aircraftTypes': aircraftTypes,
          'pagination': pagination,
        };
      } else {
        return {
          'status': 'error',
          'message': response['message'] ?? 'Failed to get aircraft types',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }

  // Save recent search
  void _saveRecentSearch({
    required String from,
    required String to,
    required DateTime date,
    required int passengers,
  }) async {
    try {
      final recentSearches = _prefs.getStringList(AppConstants.recentSearchesKey) ?? [];

      final search = json.encode({
        'from': from,
        'to': to,
        'date': date.toIso8601String(),
        'passengers': passengers,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Add to beginning and keep only last 10
      recentSearches.insert(0, search);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }

      await _prefs.setStringList(AppConstants.recentSearchesKey, recentSearches);
    } catch (e) {
      // Ignore storage errors
    }
  }

  // Get recent searches
  List<Map<String, dynamic>> getRecentSearches() {
    try {
      final recentSearches = _prefs.getStringList(AppConstants.recentSearchesKey) ?? [];

      return recentSearches.map((searchString) {
        try {
          return json.decode(searchString) as Map<String, dynamic>;
        } catch (e) {
          return <String, dynamic>{};
        }
      }).where((search) => search.isNotEmpty).toList();
    } catch (e) {
      return [];
    }
  }

  // Save trip
  Future<bool> saveTrip(Flight flight, List<Map<String, dynamic>> passengers) async {
    try {
      final savedTrips = _prefs.getStringList(AppConstants.savedTripsKey) ?? [];

      final trip = json.encode({
        'flight': flight.toJson(),
        'passengers': passengers,
        'savedAt': DateTime.now().toIso8601String(),
      });

      savedTrips.add(trip);
      return await _prefs.setStringList(AppConstants.savedTripsKey, savedTrips);
    } catch (e) {
      return false;
    }
  }

  // Get saved trips
  List<Map<String, dynamic>> getSavedTrips() {
    try {
      final savedTrips = _prefs.getStringList(AppConstants.savedTripsKey) ?? [];

      return savedTrips.map((tripString) {
        try {
          return json.decode(tripString) as Map<String, dynamic>;
        } catch (e) {
          return <String, dynamic>{};
        }
      }).where((trip) => trip.isNotEmpty).toList();
    } catch (e) {
      return [];
    }
  }

  // Clear recent searches
  Future<bool> clearRecentSearches() async {
    try {
      return await _prefs.remove(AppConstants.recentSearchesKey);
    } catch (e) {
      return false;
    }
  }

  // Clear saved trips
  Future<bool> clearSavedTrips() async {
    try {
      return await _prefs.remove(AppConstants.savedTripsKey);
    } catch (e) {
      return false;
    }
  }
}