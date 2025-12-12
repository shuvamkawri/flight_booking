import 'package:flutter/foundation.dart';

import '../../core/services/api_services.dart';
import '../../data/models/flight.dart';

class FlightProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Flight> _flights = [];
  List<Flight> get flights => _flights;

  Flight? _selectedFlight;
  Flight? get selectedFlight => _selectedFlight;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int _currentPage = 1;
  bool _hasNextPage = true;

  Future<void> searchFlights({
    required String from,
    required String to,
    required DateTime departureDate,
    required int passengers,
    String? sortBy,
    Map<String, dynamic>? filters,
    bool loadMore = false,
  }) async {
    try {
      if (!loadMore) {
        _currentPage = 1;
        _isLoading = true;
        _error = null;
        notifyListeners();
      } else {
        if (!_hasNextPage) return;
        _currentPage++;
      }

      print('Searching flights with params:');
      print('From: $from');
      print('To: $to');
      print('Date: $departureDate');
      print('Passengers: $passengers');

      final response = await _apiService.searchFlights(
        from: from,
        to: to,
        date: departureDate,
        passengers: passengers,
        sortBy: sortBy ?? 'price_asc',
        filters: filters ?? {},
        page: _currentPage,
        limit: 10,
      );

      print('API Response: $response');

      if (response['status'] == 'success') {
        final List<Flight> newFlights = (response['data']['flights'] as List)
            .map((flightJson) => Flight.fromJson(flightJson))
            .toList();

        if (loadMore) {
          _flights.addAll(newFlights);
        } else {
          _flights = newFlights;
        }

        _hasNextPage = response['data']['pagination']['hasNextPage'] ?? false;
      } else {
        _error = response['message'] ?? 'Failed to search flights';
      }
    } catch (e) {
      print('Error searching flights: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFlightDetails(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.getFlightDetails(id);

      if (response['status'] == 'success') {
        _selectedFlight = Flight.fromJson(response['data']['flight_details']);
      } else {
        _error = response['message'] ?? 'Failed to get flight details';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFlights() {
    _flights.clear();
    _currentPage = 1;
    _hasNextPage = true;
    notifyListeners();
  }

  void setSelectedFlight(Flight flight) {
    _selectedFlight = flight;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}