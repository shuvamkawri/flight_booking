class AppConstants {
  static const String appName = 'Flight Booking';
  static const String baseUrl = 'https://flight.wigian.in/flight_api.php';

  // API Endpoints
  static const String searchEndpoint = '/search';
  static const String flightEndpoint = '/flight';
  static const String airportsFromEndpoint = '/airports/from';
  static const String airportsToEndpoint = '/airports/to';
  static const String airlinesEndpoint = '/airlines';
  static const String aircraftTypesEndpoint = '/aircraft-types';

  // Storage keys
  static const String recentSearchesKey = 'recent_searches';
  static const String savedTripsKey = 'saved_trips';
  static const String userPreferencesKey = 'user_preferences';

  // Default values
  static const String defaultCurrency = 'USD';
  static const String defaultAirportCode = 'CGK';
  static const String defaultAirportName = 'Jakarta Soekarno-Hatta';
  static const String defaultCity = 'Jakarta';

  // Pagination
  static const int defaultPage = 1;
  static const int defaultLimit = 10;

  // Sorting options
  static const List<String> sortOptions = [
    'price_asc',
    'price_desc',
    'duration_asc',
    'departure_asc',
  ];

  static const Map<String, String> sortLabels = {
    'price_asc': 'Lowest Price',
    'price_desc': 'Highest Price',
    'duration_asc': 'Shortest Duration',
    'departure_asc': 'Earliest Departure',
  };

  // Duration formats
  static const String durationFormat = 'h\'h\' m\'m\'';
  static const String timeFormat = 'HH:mm';
  static const String dateFormat = 'EEE, d MMM yyyy';
  static const String dateTimeFormat = 'EEE, d MMM yyyy HH:mm';

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);
}