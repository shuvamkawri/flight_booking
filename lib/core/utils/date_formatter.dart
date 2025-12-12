import 'package:intl/intl.dart';

class DateFormatter {
  // Format date as 'EEE, d MMM yyyy' (e.g., "Tue, 2 Apr 2024")
  static String formatDate(DateTime date) {
    return DateFormat('EEE, d MMM yyyy').format(date);
  }

  // Format date as 'd MMM yyyy' (e.g., "2 Apr 2024")
  static String formatDateShort(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  // Format date as 'yyyy-MM-dd' (e.g., "2024-04-02")
  static String formatDateApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format time as 'HH:mm' (e.g., "14:30")
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Format time as 'h:mm a' (e.g., "2:30 PM")
  static String formatTime12Hour(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  // Format date and time as 'EEE, d MMM yyyy HH:mm' (e.g., "Tue, 2 Apr 2024 14:30")
  static String formatDateTime(DateTime date) {
    return DateFormat('EEE, d MMM yyyy HH:mm').format(date);
  }

  // Format relative time (e.g., "2 hours ago", "3 days ago")
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else {
      return formatDate(date);
    }
  }

  // Format duration (e.g., "2h 30m")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  // Format flight duration from string (e.g., "7h 30m")
  static String formatFlightDuration(String duration) {
    try {
      final parts = duration.split(' ');
      if (parts.length == 2) {
        return duration;
      }
      return duration;
    } catch (e) {
      return duration;
    }
  }

  // Parse date from string
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Parse date from API format
  static DateTime? parseApiDate(String dateString) {
    try {
      return DateFormat('yyyy-MM-dd').parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get day of week
  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  // Get month name
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  // Calculate days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Format date for display with special handling for today/tomorrow
  static String formatDateWithSpecialDays(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else {
      return formatDate(date);
    }
  }

  // Calculate arrival time based on departure time and duration string
  static DateTime calculateArrivalTime(
      DateTime departureTime,
      String durationString,
      ) {
    try {
      final durationParts = durationString.split(' ');
      var totalMinutes = 0;

      for (final part in durationParts) {
        if (part.contains('h')) {
          final hours = int.tryParse(part.replaceAll('h', ''));
          if (hours != null) totalMinutes += hours * 60;
        } else if (part.contains('m')) {
          final minutes = int.tryParse(part.replaceAll('m', ''));
          if (minutes != null) totalMinutes += minutes;
        }
      }

      return departureTime.add(Duration(minutes: totalMinutes));
    } catch (e) {
      return departureTime.add(const Duration(hours: 1));
    }
  }
}