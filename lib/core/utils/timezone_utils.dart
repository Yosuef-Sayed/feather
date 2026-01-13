import 'package:feather/features/weather/data/models/weather.dart';

class TimeZoneUtils {
  /// Get the current time for a specific location based on its UTC offset
  ///
  /// [weather] - Weather object containing timezone information
  /// Returns DateTime adjusted to the location's timezone
  static DateTime getLocationTime(Weather weather) {
    if (weather.utcOffsetSeconds == null) {
      return DateTime.now(); // Fallback to device time
    }

    // Get current UTC time
    final utcNow = DateTime.now().toUtc();

    // Add the location's UTC offset
    final locationTime = utcNow.add(
      Duration(seconds: weather.utcOffsetSeconds!),
    );

    return locationTime;
  }

  /// Get the current time for a specific offset
  static DateTime getTimeFromOffset(int? utcOffsetSeconds) {
    if (utcOffsetSeconds == null) {
      return DateTime.now();
    }
    final utcNow = DateTime.now().toUtc();
    return utcNow.add(Duration(seconds: utcOffsetSeconds));
  }

  /// Get formatted time from offset
  static String getFormattedTimeFromOffset(
    int? utcOffsetSeconds, {
    bool format24Hour = false,
  }) {
    final locationTime = getTimeFromOffset(utcOffsetSeconds);

    if (format24Hour) {
      return '${locationTime.hour.toString().padLeft(2, '0')}:${locationTime.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = locationTime.hour % 12 == 0 ? 12 : locationTime.hour % 12;
      final minute = locationTime.minute.toString().padLeft(2, '0');
      final period = locationTime.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }
  }

  /// Get a formatted time string for display
  ///
  /// [weather] - Weather object containing timezone information
  /// [format24Hour] - Whether to use 24-hour format (default: false)
  /// Returns formatted time string (e.g., "5:41 PM" or "17:41")
  static String getFormattedLocationTime(
    Weather weather, {
    bool format24Hour = false,
  }) {
    return getFormattedTimeFromOffset(
      weather.utcOffsetSeconds,
      format24Hour: format24Hour,
    );
  }

  /// Check if it's currently day or night at the location
  ///
  /// [weather] - Weather object containing timezone and sunrise/sunset data
  /// Returns true if it's daytime, false if nighttime
  static bool isLocationDaytime(Weather weather) {
    final locationTime = getLocationTime(weather);

    // Try to use sunrise/sunset data if available
    if (weather.daily?.sunrise != null &&
        weather.daily?.sunset != null &&
        weather.daily!.sunrise!.isNotEmpty &&
        weather.daily!.sunset!.isNotEmpty) {
      try {
        final dateStr = locationTime.toIso8601String().substring(0, 10);
        final dailyIndex = weather.daily!.time!.indexOf(dateStr);

        if (dailyIndex != -1) {
          final sunrise = DateTime.parse(weather.daily!.sunrise![dailyIndex]);
          final sunset = DateTime.parse(weather.daily!.sunset![dailyIndex]);

          return locationTime.isAfter(sunrise) && locationTime.isBefore(sunset);
        }
      } catch (_) {
        // Fall through to simple hour check
      }
    }

    // Fallback: simple hour-based check
    return locationTime.hour >= 6 && locationTime.hour < 19;
  }

  /// Get timezone display name
  ///
  /// [weather] - Weather object containing timezone information
  /// Returns timezone string (e.g., "America/Los_Angeles" or "PST")
  static String getTimezoneName(Weather weather) {
    return weather.timezone ?? weather.timezoneAbbreviation ?? 'Local';
  }
}
