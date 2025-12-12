import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/passenger.dart';
import '../presentation/providers/flight_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/flight/flight_info_card.dart';


class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Passenger> _passengers = [];
  bool _isLoading = false;
  String? _paymentMethod;

  @override
  void initState() {
    super.initState();
    // Initialize with sample passengers
    _passengers.addAll([
      Passenger(
        passengerNumber: 1,
        title: TitleType.mr,
        firstName: 'Budiarti',
        lastName: 'Rohman',
        passportNumber: 'A12345678',
        type: PassengerType.adult,
      ),
      Passenger(
        passengerNumber: 2,
        title: TitleType.mrs,
        firstName: 'Samantha',
        lastName: 'William',
        passportNumber: 'B98765432',
        type: PassengerType.adult,
      ),
    ]);
  }

  void _submitBooking() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Booking Confirmed'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your flight has been successfully booked!'),
            SizedBox(height: 8),
            Text(
              'Booking Reference: BK12345678',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('An email confirmation has been sent to your email address.'),
          ],
        ),
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
    final flight = Provider.of<FlightProvider>(context).selectedFlight;
    final theme = Theme.of(context);

    if (flight == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Booking',
          showBackButton: true,
        ),
        body: const Center(
          child: Text('No flight selected'),
        ),
      );
    }

    final totalPrice = flight.price * _passengers.length;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Complete Booking',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flight Summary
              FlightSummaryCard(flight: flight),
              const SizedBox(height: 24),

              // Passenger Details
              Text(
                'Passenger Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              ..._passengers.map((passenger) {
                return _buildPassengerCard(passenger);
              }).toList(),

              const SizedBox(height: 24),

              // Contact Information
              Text(
                'Contact Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildContactForm(),

              const SizedBox(height: 24),

              // Payment Method
              Text(
                'Payment Method',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildPaymentMethods(),

              const SizedBox(height: 24),

              // Price Breakdown
              Text(
                'Price Breakdown',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildPriceBreakdown(totalPrice),

              const SizedBox(height: 32),

              // Terms and Conditions
              Row(
                children: [
                  Checkbox(value: true, onChanged: null),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'I agree to the Terms & Conditions and Privacy Policy',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Book Now Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Book Now - \$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
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
      ),
    );
  }

  Widget _buildPassengerCard(Passenger passenger) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passenger ${passenger.passengerNumber} - ${passenger.typeString}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: passenger.firstName,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  initialValue: passenger.lastName,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: passenger.passportNumber,
            decoration: const InputDecoration(
              labelText: 'Passport Number',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter passport number';
              }
              if (value.length < 8) {
                return 'Passport number must be at least 8 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email address';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              if (value.length < 10) {
                return 'Phone number must be at least 10 digits';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        // Credit Card
        _buildPaymentOption(
          icon: Icons.credit_card,
          title: 'Credit/Debit Card',
          subtitle: 'Visa, Mastercard, AMEX',
          value: 'card',
        ),
        const SizedBox(height: 8),

        // Digital Wallet
        _buildPaymentOption(
          icon: Icons.wallet,
          title: 'Digital Wallet',
          subtitle: 'Apple Pay, Google Pay',
          value: 'wallet',
        ),
        const SizedBox(height: 8),

        // Bank Transfer
        _buildPaymentOption(
          icon: Icons.account_balance,
          title: 'Bank Transfer',
          subtitle: 'Direct bank transfer',
          value: 'transfer',
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _paymentMethod == value;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: theme.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
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
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown(double totalPrice) {
    final theme = Theme.of(context);
    final flight = Provider.of<FlightProvider>(context).selectedFlight!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          _buildPriceRow(
            label: 'Flight Fare (x${_passengers.length})',
            value: '\$${(flight.price * _passengers.length).toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _buildPriceRow(
            label: 'Taxes & Fees',
            value: '\$${(flight.price * _passengers.length * 0.1).toStringAsFixed(2)}',
          ),
          const Divider(height: 24),
          _buildPriceRow(
            label: 'Total Amount',
            value: '\$${totalPrice.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          )
              : theme.textTheme.bodyMedium,
        ),
        Text(
          value,
          style: isTotal
              ? theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          )
              : theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}