import 'package:flutter/material.dart';

class FlightFilterSheet extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final ValueChanged<Map<String, dynamic>> onApplyFilters;

  const FlightFilterSheet({
    Key? key,
    required this.initialFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _FlightFilterSheetState createState() => _FlightFilterSheetState();
}

class _FlightFilterSheetState extends State<FlightFilterSheet> {
  late Map<String, dynamic> _filters;
  late RangeValues _priceRange;
  late int _stops;
  late String? _selectedAirline;
  late String? _selectedAircraftType;

  final List<String> _airlines = [
    'AirAsia',
    'Bird Indonesia Airline',
    'Catty Airline',
    'Citilink Airline',
    'Garuda Indonesia',
    'Japan Airlines',
    'Lion Air',
    'Malaysia Airlines',
    'Singapore Airlines',
    'Thai Airways',
  ];

  final List<String> _aircraftTypes = [
    'Airbus A320',
    'Airbus A350',
    'Boeing 737',
    'Boeing 777',
    'Boeing 787',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.initialFilters);

    _priceRange = RangeValues(
      (widget.initialFilters['price_min'] ?? 0).toDouble(),
      (widget.initialFilters['price_max'] ?? 1000).toDouble(),
    );

    _stops = widget.initialFilters['stops'] ?? 0;
    _selectedAirline = widget.initialFilters['airline'];
    _selectedAircraftType = widget.initialFilters['aircraft_type'];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _buildPriceRangeFilter(),
                  const SizedBox(height: 24),

                  // Stops
                  _buildStopsFilter(),
                  const SizedBox(height: 24),

                  // Airlines
                  _buildAirlinesFilter(),
                  const SizedBox(height: 24),

                  // Aircraft Types
                  _buildAircraftTypesFilter(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.primaryColor),
                  ),
                  child: Text(
                    'Clear All',
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${_priceRange.start.round()} - \$${_priceRange.end.round()}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 2000,
          divisions: 20,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStopsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stops',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStopChip('Direct', 0),
            const SizedBox(width: 8),
            _buildStopChip('1 Stop', 1),
            const SizedBox(width: 8),
            _buildStopChip('2+ Stops', 2),
          ],
        ),
      ],
    );
  }

  Widget _buildStopChip(String label, int value) {
    final isSelected = _stops == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _stops = selected ? value : 0;
        });
      },
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildAirlinesFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Airlines',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _airlines.map((airline) {
            final isSelected = _selectedAirline == airline;
            return FilterChip(
              label: Text(airline),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedAirline = selected ? airline : null;
                });
              },
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.1),
              checkmarkColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAircraftTypesFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aircraft Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _aircraftTypes.map((type) {
            final isSelected = _selectedAircraftType == type;
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedAircraftType = selected ? type : null;
                });
              },
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.1),
              checkmarkColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _applyFilters() {
    final filters = {
      'price_min': _priceRange.start.round(),
      'price_max': _priceRange.end.round(),
      'stops': _stops,
      if (_selectedAirline != null) 'airline': _selectedAirline,
      if (_selectedAircraftType != null) 'aircraft_type': _selectedAircraftType,
    };

    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 1000);
      _stops = 0;
      _selectedAirline = null;
      _selectedAircraftType = null;
    });
  }
}