import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/airport.dart';
import '../../data/repositories/airport_repository.dart';


class AirportPicker extends StatefulWidget {
  final String title;
  final Airport? initialAirport;
  final bool isDeparture;
  final ValueChanged<Airport> onAirportSelected;
  final SharedPreferences prefs; // Add this

  const AirportPicker({
    Key? key,
    required this.title,
    this.initialAirport,
    required this.isDeparture,
    required this.onAirportSelected,
    required this.prefs, // Add this
  }) : super(key: key);

  @override
  _AirportPickerState createState() => _AirportPickerState();
}

class _AirportPickerState extends State<AirportPicker> {
  late TextEditingController _searchController;
  late AirportRepository _airportRepository;
  List<Airport> _airports = [];
  List<Airport> _filteredAirports = [];
  List<Airport> _recentAirports = [];
  List<Airport> _popularAirports = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _airportRepository = AirportRepository(widget.prefs); // Remove the incorrect parameter

    _loadAirports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAirports() async {
    setState(() {
      _isLoading = true;
    });

    // Load airports
    _airports = _airportRepository.getAirports();
    _recentAirports = _airportRepository.getRecentAirports();
    _popularAirports = _airportRepository.getPopularAirports();

    // Show suggestions if no search
    _filteredAirports = _airportRepository.getSuggestions('');

    setState(() {
      _isLoading = false;
    });
  }

  void _searchAirports(String query) {
    if (query.isEmpty) {
      _filteredAirports = _airportRepository.getSuggestions('');
    } else {
      _filteredAirports = _airportRepository.getAirports(search: query);
    }
    setState(() {});
  }

  void _onAirportSelected(Airport airport) {
    _airportRepository.saveRecentAirport(airport.airportCode);
    widget.onAirportSelected(airport);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _searchAirports,
                decoration: InputDecoration(
                  hintText: 'Search airport or city...',
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                autofocus: true,
              ),
            ),
          ),

          // Airport List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildAirportList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAirportList() {
    final theme = Theme.of(context);
    final hasSearch = _searchController.text.isNotEmpty;

    return ListView(
      children: [
        if (!hasSearch && _recentAirports.isNotEmpty) ...[
          _buildSectionHeader('Recent Searches'),
          ..._recentAirports.map((airport) => _buildAirportItem(airport)),
          const SizedBox(height: 16),
        ],

        if (!hasSearch && _popularAirports.isNotEmpty) ...[
          _buildSectionHeader('Popular Airports'),
          ..._popularAirports.map((airport) => _buildAirportItem(airport)),
          const SizedBox(height: 16),
        ],

        if (hasSearch && _filteredAirports.isNotEmpty) ...[
          _buildSectionHeader('Search Results'),
          ..._filteredAirports.map((airport) => _buildAirportItem(airport)),
        ],

        if (!hasSearch && _recentAirports.isEmpty && _popularAirports.isEmpty) ...[
          _buildSectionHeader('All Airports'),
          ..._airports.map((airport) => _buildAirportItem(airport)),
        ],

        if (hasSearch && _filteredAirports.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.airplanemode_inactive,
                  size: 64,
                  color: theme.disabledColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No airports found',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try searching with different keywords',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).disabledColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAirportItem(Airport airport) {
    final theme = Theme.of(context);
    final isSelected = widget.initialAirport?.airportCode == airport.airportCode;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          widget.isDeparture ? Icons.flight_takeoff : Icons.flight_land,
          color: theme.primaryColor,
        ),
      ),
      title: Text(
        airport.airportCode,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(airport.city),
          Text(
            airport.airportName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.disabledColor,
            ),
          ),
        ],
      ),
      trailing: isSelected
          ? Icon(
        Icons.check_circle,
        color: theme.primaryColor,
      )
          : null,
      onTap: () => _onAirportSelected(airport),
    );
  }
}

// Airport chip for selected airport
class AirportChip extends StatelessWidget {
  final Airport airport;
  final bool isDeparture;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const AirportChip({
    Key? key,
    required this.airport,
    required this.isDeparture,
    required this.onTap,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDeparture ? Icons.flight_takeoff : Icons.flight_land,
              size: 16,
              color: theme.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              airport.airportCode,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: theme.disabledColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}