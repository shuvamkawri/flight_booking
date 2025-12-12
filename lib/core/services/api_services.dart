import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const String _baseUrl = 'https://flight.wigian.in';
  final String _apiBase = '$_baseUrl/flight_api.php';

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
      final response = await http.post(
        Uri.parse('$_apiBase/search'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'from': from,
          'to': to,
          'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
          'passengers': passengers,
          'sort_by': sortBy,
          'filters': filters ?? {},
          'page': page,
          'limit': limit,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search flights: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<Map<String, dynamic>> getFlightDetails(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBase/flight'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'id': id}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get flight details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<Map<String, dynamic>> getDepartureAirports({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBase/airports/from'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'search': search,
          'page': page,
          'limit': limit,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get airports: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<Map<String, dynamic>> getArrivalAirports({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBase/airports/to'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'search': search,
          'page': page,
          'limit': limit,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get airports: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<Map<String, dynamic>> getAirlines({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBase/airlines'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'search': search,
          'page': page,
          'limit': limit,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get airlines: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<Map<String, dynamic>> getAircraftTypes({
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBase/aircraft-types'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'search': search,
          'page': page,
          'limit': limit,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get aircraft types: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}