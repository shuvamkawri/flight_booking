import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool showTimePicker;

  const DatePicker({
    Key? key,
    required this.initialDate,
    this.minDate,
    this.maxDate,
    required this.onDateSelected,
    this.showTimePicker = false,
  }) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime _selectedDate;
  late DateTime _selectedTime;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedTime = widget.initialDate;
    _calendarFormat = CalendarFormat.month;
    _focusedDay = widget.initialDate;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDay = focusedDay;
    });

    if (!widget.showTimePicker) {
      widget.onDateSelected(_selectedDate);
      Navigator.pop(context);
    }
  }

  void _onTimeChanged(DateTime newTime) {
    setState(() {
      _selectedTime = newTime;
    });

    final combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    widget.onDateSelected(combinedDateTime);
  }

  void _confirmSelection() {
    final combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    widget.onDateSelected(combinedDateTime);
    Navigator.pop(context);
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Date',
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

          // Calendar
          TableCalendar(
            firstDay: widget.minDate ?? DateTime.now().subtract(const Duration(days: 365)),
            lastDay: widget.maxDate ?? DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          if (widget.showTimePicker) ...[
            const SizedBox(height: 16),
            const Divider(),
            _buildTimePicker(),
          ],

          const SizedBox(height: 16),

          // Selected Date
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Date & Time',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.disabledColor,
                        ),
                      ),
                      Text(
                        DateFormat('EEE, d MMM yyyy, HH:mm').format(
                          widget.showTimePicker
                              ? DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedTime.hour,
                            _selectedTime.minute,
                          )
                              : _selectedDate,
                        ),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    _onDaySelected(now, now);
                    if (widget.showTimePicker) {
                      _onTimeChanged(now);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.primaryColor),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.showTimePicker ? _confirmSelection : () {
                    widget.onDateSelected(_selectedDate);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Select',
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

  Widget _buildTimePicker() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hour Picker
            _buildTimeWheel(
              initialValue: _selectedTime.hour,
              maxValue: 23,
              onChanged: (value) {
                _onTimeChanged(
                  DateTime(
                    _selectedTime.year,
                    _selectedTime.month,
                    _selectedTime.day,
                    value,
                    _selectedTime.minute,
                  ),
                );
              },
              label: 'Hour',
            ),

            Text(
              ':',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            // Minute Picker
            _buildTimeWheel(
              initialValue: _selectedTime.minute,
              maxValue: 59,
              step: 5,
              onChanged: (value) {
                _onTimeChanged(
                  DateTime(
                    _selectedTime.year,
                    _selectedTime.month,
                    _selectedTime.day,
                    _selectedTime.hour,
                    value,
                  ),
                );
              },
              label: 'Minute',
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('AM'),
              selected: _selectedTime.hour < 12,
              onSelected: (selected) {
                if (selected && _selectedTime.hour >= 12) {
                  _onTimeChanged(
                    DateTime(
                      _selectedTime.year,
                      _selectedTime.month,
                      _selectedTime.day,
                      _selectedTime.hour - 12,
                      _selectedTime.minute,
                    ),
                  );
                }
              },
            ),
            const SizedBox(width: 12),
            ChoiceChip(
              label: const Text('PM'),
              selected: _selectedTime.hour >= 12,
              onSelected: (selected) {
                if (selected && _selectedTime.hour < 12) {
                  _onTimeChanged(
                    DateTime(
                      _selectedTime.year,
                      _selectedTime.month,
                      _selectedTime.day,
                      _selectedTime.hour + 12,
                      _selectedTime.minute,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeWheel({
    required int initialValue,
    required int maxValue,
    int step = 1,
    required ValueChanged<int> onChanged,
    required String label,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: ListWheelScrollView(
              itemExtent: 40,
              diameterRatio: 1.5,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                onChanged(index * step);
              },
              children: List.generate(
                (maxValue ~/ step) + 1,
                    (index) {
                  final value = index * step;
                  final isSelected = value == initialValue;

                  return Center(
                    child: Text(
                      value.toString().padLeft(2, '0'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? theme.primaryColor : theme.disabledColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Date chip
class DateChip extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const DateChip({
    Key? key,
    required this.date,
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
              Icons.calendar_today,
              size: 16,
              color: theme.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('EEE, d MMM').format(date),
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