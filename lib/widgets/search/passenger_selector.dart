import 'package:flutter/material.dart';

class PassengerSelector extends StatefulWidget {
  final int initialAdults;
  final int initialChildren;
  final int initialInfants;
  final ValueChanged<PassengerCount> onPassengersChanged;

  const PassengerSelector({
    Key? key,
    this.initialAdults = 1,
    this.initialChildren = 0,
    this.initialInfants = 0,
    required this.onPassengersChanged,
  }) : super(key: key);

  @override
  _PassengerSelectorState createState() => _PassengerSelectorState();
}

class PassengerCount {
  final int adults;
  final int children;
  final int infants;

  const PassengerCount({
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
  });

  int get total => adults + children + infants;

  String get description {
    final parts = <String>[];
    if (adults > 0) parts.add('$adults Adult${adults > 1 ? 's' : ''}');
    if (children > 0) parts.add('$children Child${children > 1 ? 'ren' : ''}');
    if (infants > 0) parts.add('$infants Infant${infants > 1 ? 's' : ''}');
    return parts.join(', ');
  }

  PassengerCount copyWith({
    int? adults,
    int? children,
    int? infants,
  }) {
    return PassengerCount(
      adults: adults ?? this.adults,
      children: children ?? this.children,
      infants: infants ?? this.infants,
    );
  }
}

class _PassengerSelectorState extends State<PassengerSelector> {
  late PassengerCount _passengerCount;

  @override
  void initState() {
    super.initState();
    _passengerCount = PassengerCount(
      adults: widget.initialAdults,
      children: widget.initialChildren,
      infants: widget.initialInfants,
    );
  }

  void _updatePassengerCount(PassengerCount newCount) {
    setState(() {
      _passengerCount = newCount;
    });
    widget.onPassengersChanged(newCount);
  }

  void _incrementAdults() {
    if (_passengerCount.adults < 9) {
      _updatePassengerCount(_passengerCount.copyWith(
        adults: _passengerCount.adults + 1,
      ));
    }
  }

  void _decrementAdults() {
    if (_passengerCount.adults > 1 ||
        (_passengerCount.adults == 1 && _passengerCount.children + _passengerCount.infants > 0)) {
      _updatePassengerCount(_passengerCount.copyWith(
        adults: _passengerCount.adults - 1,
      ));
    }
  }

  void _incrementChildren() {
    if (_passengerCount.children < 9) {
      _updatePassengerCount(_passengerCount.copyWith(
        children: _passengerCount.children + 1,
      ));
    }
  }

  void _decrementChildren() {
    if (_passengerCount.children > 0) {
      _updatePassengerCount(_passengerCount.copyWith(
        children: _passengerCount.children - 1,
      ));
    }
  }

  void _incrementInfants() {
    if (_passengerCount.infants < _passengerCount.adults) {
      _updatePassengerCount(_passengerCount.copyWith(
        infants: _passengerCount.infants + 1,
      ));
    }
  }

  void _decrementInfants() {
    if (_passengerCount.infants > 0) {
      _updatePassengerCount(_passengerCount.copyWith(
        infants: _passengerCount.infants - 1,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passengers',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the number of passengers',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.disabledColor,
            ),
          ),
          const SizedBox(height: 24),

          // Adults
          _buildPassengerRow(
            icon: Icons.person,
            title: 'Adults',
            subtitle: '12+ years',
            count: _passengerCount.adults,
            onIncrement: _incrementAdults,
            onDecrement: _decrementAdults,
            canDecrement: _passengerCount.adults > 1 ||
                (_passengerCount.adults == 1 &&
                    _passengerCount.children + _passengerCount.infants > 0),
          ),

          const Divider(),

          // Children
          _buildPassengerRow(
            icon: Icons.child_care,
            title: 'Children',
            subtitle: '2-11 years',
            count: _passengerCount.children,
            onIncrement: _incrementChildren,
            onDecrement: _decrementChildren,
            canDecrement: _passengerCount.children > 0,
          ),

          const Divider(),

          // Infants
          _buildPassengerRow(
            icon: Icons.child_friendly,
            title: 'Infants',
            subtitle: 'Under 2 years',
            count: _passengerCount.infants,
            onIncrement: _incrementInfants,
            onDecrement: _decrementInfants,
            canDecrement: _passengerCount.infants > 0,
            maxCount: _passengerCount.adults,
          ),

          const SizedBox(height: 24),

          // Summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.people,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Passengers',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.disabledColor,
                        ),
                      ),
                      Text(
                        _passengerCount.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${_passengerCount.total}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Done Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required bool canDecrement,
    int? maxCount,
  }) {
    final theme = Theme.of(context);
    final canIncrement = maxCount == null || count < maxCount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              // Decrement button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: canDecrement
                      ? theme.primaryColor.withOpacity(0.1)
                      : theme.disabledColor.withOpacity(0.1),
                ),
                child: IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: canDecrement ? onDecrement : null,
                  color: canDecrement
                      ? theme.primaryColor
                      : theme.disabledColor,
                  padding: EdgeInsets.zero,
                ),
              ),

              // Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$count',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Increment button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: canIncrement
                      ? theme.primaryColor.withOpacity(0.1)
                      : theme.disabledColor.withOpacity(0.1),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: canIncrement ? onIncrement : null,
                  color: canIncrement
                      ? theme.primaryColor
                      : theme.disabledColor,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Passenger selector chip
class PassengerChip extends StatelessWidget {
  final PassengerCount passengerCount;
  final VoidCallback onTap;

  const PassengerChip({
    Key? key,
    required this.passengerCount,
    required this.onTap,
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
              Icons.people,
              size: 16,
              color: theme.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              passengerCount.total == 1
                  ? '1 person'
                  : '${passengerCount.total} people',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}