import 'package:flutter/material.dart';
import 'package:feather/features/weather/data/models/weather.dart';
import 'package:feather/core/theme/glass_container.dart';
import 'package:feather/core/utils/weather_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:feather/features/settings/presentation/providers/settings_provider.dart';
import 'package:feather/core/utils/unit_converters.dart';
import 'package:feather/core/utils/timezone_utils.dart';

class HourlyForecastList extends StatelessWidget {
  final Weather weather;

  const HourlyForecastList({super.key, required this.weather});

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
    // Use location-specific time instead of device time
    final now = TimeZoneUtils.getLocationTime(weather);
    final settings = context.watch<SettingsProvider>();
    final tempSymbol = UnitConverters.getTemperatureSymbol(settings.tempUnit);

    int startIndex = 0;
    if (weather.hourly?.time != null) {
      final currentHourStr = now.toIso8601String().substring(0, 13);
      for (int i = 0; i < weather.hourly!.time!.length; i++) {
        if (weather.hourly!.time![i].startsWith(currentHourStr)) {
          startIndex = i;
          break;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Hourly Forecast",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 140,
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 16),
              borderRadius: BorderRadius.circular(20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 24, // Show next 24 hours
                itemBuilder: (context, i) {
                  final index = startIndex + i;
                  if (index >= (weather.hourly?.time?.length ?? 0)) {
                    return const SizedBox();
                  }

                  final timeStr = weather.hourly!.time![index];
                  final date = DateTime.parse(timeStr);
                  final rawTemp = (weather.hourly!.temperature2m![index] as num)
                      .toDouble();
                  final convertedTemp = UnitConverters.convertTemperature(
                    rawTemp,
                    settings.tempUnit,
                  );
                  final code = weather.hourly!.weatherCode![index];
                  final isDay = _isDay(date, weather);

                  return Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          i == 0 ? "Now" : DateFormat('j').format(date),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Icon(
                          WeatherUtils.getWeatherIcon(
                            (code as num).toInt(),
                            isDay: isDay,
                          ),
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${convertedTemp.round()}$tempSymbol',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
