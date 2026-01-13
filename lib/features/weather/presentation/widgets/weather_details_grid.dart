import 'package:flutter/material.dart';
import 'package:feather/features/weather/data/models/weather.dart';
import 'package:feather/core/theme/glass_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:provider/provider.dart';
import 'package:feather/features/settings/presentation/providers/settings_provider.dart';
import 'package:feather/core/utils/unit_converters.dart';
import 'package:feather/core/utils/timezone_utils.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final Weather weather;

  const WeatherDetailsGrid({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
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

    final uv = weather.daily?.uvIndexMax?.isNotEmpty == true
        ? weather.daily!.uvIndexMax![0]
        : 0;
    final humidity = weather.hourly?.relativeHumidity2m?[index];
    final rawWindSpeed =
        (weather.hourly?.windSpeed10m?[index] as num?)?.toDouble() ?? 0.0;
    final rawVisibility =
        (weather.hourly?.visibility?[index] as num?)?.toDouble() ?? 0.0;
    final rawPressure =
        (weather.hourly?.pressureMsl?[index] as num?)?.toDouble() ?? 0.0;
    final rawApparentTemp =
        (weather.hourly?.apparentTemperature?[index] as num?)?.toDouble() ??
        0.0;
    final rawActualTemp =
        (weather.hourly?.temperature2m?[index] as num?)?.toDouble() ?? 0.0;

    // Converted Values
    final windSpeed = UnitConverters.convertWindSpeed(
      rawWindSpeed,
      settings.windSpeedUnit,
    );
    final visibility = UnitConverters.convertDistance(
      rawVisibility / 1000,
      settings.distanceUnit,
    );
    final pressure = UnitConverters.convertPressure(
      rawPressure,
      settings.pressureUnit,
    );
    final apparentTemp = UnitConverters.convertTemperature(
      rawApparentTemp,
      settings.tempUnit,
    );
    final actualTemp = UnitConverters.convertTemperature(
      rawActualTemp,
      settings.tempUnit,
    );

    // Symbols
    final tempSymbol = UnitConverters.getTemperatureSymbol(settings.tempUnit);
    final windSymbol = UnitConverters.getWindSpeedSymbol(
      settings.windSpeedUnit,
    );
    final pressureSymbol = UnitConverters.getPressureSymbol(
      settings.pressureUnit,
    );
    final distanceSymbol = UnitConverters.getDistanceSymbol(
      settings.distanceUnit,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildDetailCard(
            "UV Index",
            "$uv",
            _getUvDescription(uv is num ? uv.toDouble() : 0.0),
            WeatherIcons.day_sunny,
          ),
          _buildDetailCard(
            "Feels Like",
            "${apparentTemp.round()}$tempSymbol",
            "Actual: ${actualTemp.round()}$tempSymbol",
            WeatherIcons.thermometer,
          ),
          _buildDetailCard(
            "Humidity",
            "$humidity%",
            "Comfortable",
            // Note: Data doesn't have dew point currently
            WeatherIcons.humidity,
          ),
          _buildDetailCard(
            "Wind",
            "${windSpeed.round()} $windSymbol",
            "Speed",
            WeatherIcons.strong_wind,
          ),
          _buildDetailCard(
            "Pressure",
            "${pressure.round()} $pressureSymbol",
            "Mean Sea Level",
            WeatherIcons.barometer,
          ),
          _buildDetailCard(
            "Visibility",
            "${visibility.toStringAsFixed(1)} $distanceSymbol",
            _getVisibilityDescription(rawVisibility),
            WeatherIcons.day_haze,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    String title,
    String value,
    String sub,
    IconData icon,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(icon, color: Colors.white70, size: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getUvDescription(double uv) {
    if (uv < 3) return "Low";
    if (uv < 6) return "Moderate";
    if (uv < 8) return "High";
    if (uv < 11) return "Very High";
    return "Extreme";
  }

  String _getVisibilityDescription(num vis) {
    if (vis > 10000) return "Excellent";
    if (vis > 5000) return "Good";
    if (vis > 2000) return "Moderate";
    return "Poor";
  }
}
