import 'package:flutter/foundation.dart';

import '../../data/models/airport.dart';


class SearchProvider with ChangeNotifier {
  // Search parameters
  String _from = 'CGK';
  String _fromCity = 'Jakarta';
  String _to = 'NRT';
  String _toCity = 'Tokyo';
  DateTime _departureDate = DateTime.now().add(const Duration(days: 7));
  int _passengers = 1;
  String _sortBy = 'price_asc';
  Map<String, dynamic> _filters = {};

  // Getters
  String get from => _from;
  String get fromCity => _fromCity;
  String get to => _to;
  String get toCity => _toCity;
  DateTime get departureDate => _departureDate;
  int get passengers => _passengers;
  String get sortBy => _sortBy;
  Map<String, dynamic> get filters => Map.from(_filters);

  // Setters
  void setFrom(String code, String city) {
    _from = code;
    _fromCity = city;
    notifyListeners();
  }

  void setTo(String code, String city) {
    _to = code;
    _toCity = city;
    notifyListeners();
  }

  void setDepartureDate(DateTime date) {
    _departureDate = date;
    notifyListeners();
  }

  void setPassengers(int count) {
    _passengers = count;
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void setFilters(Map<String, dynamic> filters) {
    _filters = Map.from(filters);
    notifyListeners();
  }

  void updateFilter(String key, dynamic value) {
    if (value == null) {
      _filters.remove(key);
    } else {
      _filters[key] = value;
    }
    notifyListeners();
  }

  void clearFilters() {
    _filters.clear();
    notifyListeners();
  }

  void swapAirports() {
    final tempCode = _from;
    final tempCity = _fromCity;

    _from = _to;
    _fromCity = _toCity;

    _to = tempCode;
    _toCity = tempCity;

    notifyListeners();
  }

  void resetSearch() {
    _from = 'CGK';
    _fromCity = 'Jakarta';
    _to = 'NRT';
    _toCity = 'Tokyo';
    _departureDate = DateTime.now().add(const Duration(days: 7));
    _passengers = 1;
    _sortBy = 'price_asc';
    _filters.clear();
    notifyListeners();
  }

  // Helper methods
  bool get hasFilters => _filters.isNotEmpty;

  String get formattedDate {
    final day = _departureDate.day;
    final month = _departureDate.month;
    final year = _departureDate.year;

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final weekday = days[_departureDate.weekday - 1];
    final monthName = months[month - 1];

    return '$weekday, $day $monthName';
  }

  String get formattedPassengers {
    return _passengers == 1 ? '1 person' : '$_passengers people';
  }

  Map<String, dynamic> get searchParams {
    return {
      'from': _from,
      'to': _to,
      'date': _departureDate,
      'passengers': _passengers,
      'sort_by': _sortBy,
      'filters': _filters,
    };
  }

  void setFromAirport(Airport airport) {
    _from = airport.airportCode;
    _fromCity = airport.city;
    notifyListeners();
  }

  void setToAirport(Airport airport) {
    _to = airport.airportCode;
    _toCity = airport.city;
    notifyListeners();
  }
}