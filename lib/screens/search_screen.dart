import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../presentation/providers/flight_provider.dart';
import '../presentation/providers/search_provider.dart';
import 'flight_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);
  }

  Future<void> _searchFlights() async {
    try {
      // Validate inputs
      if (_searchProvider.from.isEmpty || _searchProvider.to.isEmpty) {
        _showErrorDialog('Please select both departure and arrival airports');
        return;
      }

      if (_searchProvider.from == _searchProvider.to) {
        _showErrorDialog('Departure and arrival airports cannot be the same');
        return;
      }

      final flightProvider = Provider.of<FlightProvider>(context, listen: false);

      // Show loading indicator - assign to variable to avoid "void" error
      final loadingDialog = showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Search flights
      // Remove the 'success' variable if searchFlights returns void
      // If searchFlights returns Future<bool>, keep it
      await flightProvider.searchFlights(
        from: _searchProvider.from,
        to: _searchProvider.to,
        departureDate: _searchProvider.departureDate,
        passengers: _searchProvider.passengers,
        sortBy: _searchProvider.sortBy,
        filters: _searchProvider.filters,
      );

      // Dismiss loading indicator
      if (mounted) Navigator.of(context).pop();

      // Check if flights were found - assuming flightProvider has a flights list
      // If searchFlights returns bool, use that. Otherwise check flights list
      if (flightProvider.flights.isNotEmpty && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FlightListScreen(),
          ),
        );
      } else if (mounted) {
        _showErrorDialog('No flights found for the selected criteria');
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss loading indicator
        _showErrorDialog('An error occurred: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f4f7),
      body: Stack(
        children: [
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff4da0ff),
                  Color(0xff8cc6ff),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // TITLE + PROFILE (RIGHT)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Plan your trip",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.grey[600]),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // WHITE CARD
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            // FROM
                            GestureDetector(
                              onTap: () => _showAirportPicker(context, isFrom: true),
                              child: Row(
                                children: [
                                  const Icon(Icons.flight_takeoff,
                                      color: Colors.blue, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "From",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          provider.from.isNotEmpty
                                              ? "${provider.from} (${provider.fromCity})"
                                              : "Select airport",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.swap_vert,
                                      color: Colors.grey, size: 22),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),
                            const Divider(height: 1, thickness: 1),

                            // TO
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () => _showAirportPicker(context, isFrom: false),
                              child: Row(
                                children: [
                                  const Icon(Icons.flight_land,
                                      color: Colors.blue, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "To",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          provider.to.isNotEmpty
                                              ? "${provider.to} (${provider.toCity})"
                                              : "Select airport",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down,
                                      color: Colors.grey, size: 26),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // DATE + PASSENGERS
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff7f8fa),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Departure",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            DateFormat("EEE, d MMM")
                                                .format(provider.departureDate),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectPassengers(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff7f8fa),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Amount",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${provider.passengers} ${provider.passengers == 1 ? 'person' : 'people'}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // SEARCH BUTTON (rounded)
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _searchFlights,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "Search flights",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // SAVED TRIPS TITLE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Saved trips",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "See more",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _searchProvider.departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _searchProvider.departureDate) {
      _searchProvider.setDepartureDate(picked);
    }
  }

  void _selectPassengers(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Passengers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _searchProvider.passengers > 1
                        ? () => _searchProvider.setPassengers(_searchProvider.passengers - 1)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    _searchProvider.passengers.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () => _searchProvider.setPassengers(_searchProvider.passengers + 1),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _searchProvider.passengers == 1 ? '1 person' : '${_searchProvider.passengers} people',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAirportPicker(BuildContext context, {required bool isFrom}) {
    // For testing, let's add some mock airports
    final airports = [
      {'code': 'JFK', 'city': 'New York'},
      {'code': 'LAX', 'city': 'Los Angeles'},
      {'code': 'ORD', 'city': 'Chicago'},
      {'code': 'DFW', 'city': 'Dallas'},
      {'code': 'MIA', 'city': 'Miami'},
      {'code': 'SFO', 'city': 'San Francisco'},
      {'code': 'SEA', 'city': 'Seattle'},
      {'code': 'BOS', 'city': 'Boston'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Text(
                isFrom ? 'Select Departure Airport' : 'Select Arrival Airport',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: airports.length,
                  itemBuilder: (context, index) {
                    final airport = airports[index];
                    return ListTile(
                      leading: const Icon(Icons.flight, color: Colors.blue),
                      title: Text(airport['code']!),
                      subtitle: Text(airport['city']!),
                      onTap: () {
                        if (isFrom) {
                          _searchProvider.setFrom(airport['code']!, airport['city']!);
                        } else {
                          _searchProvider.setTo(airport['code']!, airport['city']!);
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}