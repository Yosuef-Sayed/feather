import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feather/features/weather/data/models/weather.dart';
import 'package:feather/core/utils/weather_utils.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_icons/weather_icons.dart';

class CurrentWeatherHeader extends StatelessWidget {
  final Weather weather;

  const CurrentWeatherHeader({super.key, required this.weather});

  bool _isDay(DateTime time, Weather weather) {
    if (weather.daily?.sunrise == null || weather.daily?.sunset == null) {
      return true; // Default to day
    }
    try {
      final dateStr = time.toIso8601String().substring(0, 10);
      final dailyIndex = weather.daily!.time!.indexOf(dateStr);
      if (dailyIndex == -1) return true;

      final sunrise = DateTime.parse(weather.daily!.sunrise![dailyIndex]);
      final sunset = DateTime.parse(weather.daily!.sunset![dailyIndex]);

      return time.isAfter(sunrise) && time.isBefore(sunset);
    } catch (_) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Simple logic to find current hour index.
    // OpenMeteo returns 0-23 for today, then next days.
    // If we assume the first 24 items are today (or starts from now if configured, but default is 00:00).
    // We'll try to find the match.
    int index = 0;
    if (weather.hourly?.time != null) {
      final currentHourStr = now.toIso8601String().substring(
        0,
        13,
      ); // "2023-10-27T10"
      for (int i = 0; i < weather.hourly!.time!.length; i++) {
        if (weather.hourly!.time![i].startsWith(currentHourStr)) {
          index = i;
          break;
        }
      }
    }

    // Fallback using hour if search fails (e.g. slight mismatch)
    if (index == 0 && (weather.hourly?.time?.isNotEmpty ?? false)) {
      // Assume start is 00:00 today.
      index = now.hour;
      if (index >= weather.hourly!.time!.length) index = 0;
    }

    final temp = weather.hourly?.temperature2m?[index] ?? 0;
    final weatherCode = weather.hourly?.weatherCode?[index] ?? 0;
    final apparentTemp = weather.hourly?.apparentTemperature?[index] ?? 0;

    // Determine if it's day or night currently
    final isDay = _isDay(now, weather);

    final dailyMax = weather.daily?.temperature2mMax?.isNotEmpty == true
        ? weather.daily!.temperature2mMax![0]
        : 0;
    final dailyMin = weather.daily?.temperature2mMin?.isNotEmpty == true
        ? weather.daily!.temperature2mMin![0]
        : 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),

        // Icon
        BoxedIcon(
          WeatherUtils.getWeatherIcon(weatherCode as int, isDay: isDay),
          size: 80,
          color: Colors.white,
        ).animate().scale(
          delay: 200.ms,
          duration: 600.ms,
          curve: Curves.elasticOut,
        ),

        const SizedBox(height: 10),

        Text(
          '${temp.round()}°',
          style: GoogleFonts.poppins(
            fontSize: 90,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 1.0,
          ),
        ).animate().fadeIn(delay: 300.ms),

        Text(
          WeatherUtils.getWeatherDescription(weatherCode),
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDetailItem('Feels like ${apparentTemp.round()}°'),
            Container(
              height: 20,
              width: 1,
              color: Colors.white30,
              margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
            _buildDetailItem('H:${dailyMax.round()}° L:${dailyMin.round()}°'),
          ],
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }

  Widget _buildDetailItem(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
