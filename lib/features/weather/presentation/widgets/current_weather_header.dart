import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feather/features/weather/data/models/weather.dart';
import 'package:feather/core/utils/weather_utils.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:provider/provider.dart';
import 'package:feather/features/settings/presentation/providers/settings_provider.dart';
import 'package:feather/core/utils/unit_converters.dart';
import 'package:feather/core/utils/timezone_utils.dart';

class CurrentWeatherHeader extends StatelessWidget {
  final Weather weather;

  const CurrentWeatherHeader({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // Use location-specific time instead of device time
    final now = TimeZoneUtils.getLocationTime(weather);
    final settings = context.watch<SettingsProvider>();

    int index = 0;
    if (weather.hourly?.time != null) {
      final currentHourStr = now.toIso8601String().substring(0, 13);
      for (int i = 0; i < weather.hourly!.time!.length; i++) {
        if (weather.hourly!.time![i].startsWith(currentHourStr)) {
          index = i;
          break;
        }
      }
    }

    if (index == 0 && (weather.hourly?.time?.isNotEmpty ?? false)) {
      index = now.hour;
      if (index >= weather.hourly!.time!.length) index = 0;
    }

    final rawTemp = (weather.hourly?.temperature2m?[index] ?? 0).toDouble();
    final weatherCode = (weather.hourly?.weatherCode?[index] ?? 0).toInt();
    final rawApparentTemp = (weather.hourly?.apparentTemperature?[index] ?? 0)
        .toDouble();

    final convertedTemp = UnitConverters.convertTemperature(
      rawTemp,
      settings.tempUnit,
    );
    final convertedApparentTemp = UnitConverters.convertTemperature(
      rawApparentTemp,
      settings.tempUnit,
    );
    final tempSymbol = UnitConverters.getTemperatureSymbol(settings.tempUnit);

    final isDay = TimeZoneUtils.isLocationDaytime(weather);

    final rawMax =
        (weather.daily?.temperature2mMax?.isNotEmpty == true
                ? weather.daily!.temperature2mMax![0]
                : 0)
            .toDouble();
    final rawMin =
        (weather.daily?.temperature2mMin?.isNotEmpty == true
                ? weather.daily!.temperature2mMin![0]
                : 0)
            .toDouble();

    final convertedMax = UnitConverters.convertTemperature(
      rawMax,
      settings.tempUnit,
    );
    final convertedMin = UnitConverters.convertTemperature(
      rawMin,
      settings.tempUnit,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        BoxedIcon(
          WeatherUtils.getWeatherIcon(weatherCode, isDay: isDay),
          size: 80,
          color: Colors.white,
        ).animate().scale(
          delay: 200.ms,
          duration: 600.ms,
          curve: Curves.elasticOut,
        ),
        const SizedBox(height: 10),
        Text(
          TimeZoneUtils.getFormattedLocationTime(weather),
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 10),
        Text(
          '${convertedTemp.round()}$tempSymbol',
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
            _buildDetailItem(
              'Feels like ${convertedApparentTemp.round()}$tempSymbol',
            ),
            Container(
              height: 20,
              width: 1,
              color: Colors.white30,
              margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
            _buildDetailItem(
              'H:${convertedMax.round()}$tempSymbol L:${convertedMin.round()}$tempSymbol',
            ),
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
