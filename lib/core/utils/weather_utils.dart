import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherUtils {
  static String getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Clear Sky';
      case 1:
        return 'Mainly Clear';
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Overcast';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 56:
      case 57:
        return 'Freezing Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 66:
      case 67:
        return 'Freezing Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow Fall';
      case 77:
        return 'Snow Grains';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 85:
      case 86:
        return 'Snow Showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm w/ Hail';
      default:
        return 'Unknown';
    }
  }

  static IconData getWeatherIcon(int code, {bool isDay = true}) {
    if (isDay) {
      switch (code) {
        case 0:
          return WeatherIcons.day_sunny;
        case 1:
        case 2:
          return WeatherIcons.day_cloudy;
        case 3:
          return WeatherIcons.cloudy;
        case 45:
        case 48:
          return WeatherIcons.day_fog;
        case 51:
        case 53:
        case 55:
          return WeatherIcons.day_showers;
        case 56:
        case 57:
          return WeatherIcons.day_sleet;
        case 61:
        case 63:
        case 65:
          return WeatherIcons.day_rain;
        case 66:
        case 67:
          return WeatherIcons.day_rain_mix;
        case 71:
        case 73:
        case 75:
          return WeatherIcons.day_snow;
        case 77:
          return WeatherIcons.day_snow;
        case 80:
        case 81:
        case 82:
          return WeatherIcons.day_showers;
        case 85:
        case 86:
          return WeatherIcons.day_snow;
        case 95:
          return WeatherIcons.day_thunderstorm;
        case 96:
        case 99:
          return WeatherIcons.day_storm_showers;
        default:
          return WeatherIcons.na;
      }
    } else {
      switch (code) {
        case 0:
          return WeatherIcons.night_clear;
        case 1:
        case 2:
          return WeatherIcons.night_alt_cloudy;
        case 3:
          return WeatherIcons.night_cloudy;
        case 45:
        case 48:
          return WeatherIcons.night_fog;
        case 51:
        case 53:
        case 55:
          return WeatherIcons.night_alt_showers;
        case 56:
        case 57:
          return WeatherIcons.night_alt_sleet;
        case 61:
        case 63:
        case 65:
          return WeatherIcons.night_alt_rain;
        case 66:
        case 67:
          return WeatherIcons.night_alt_rain_mix;
        case 71:
        case 73:
        case 75:
          return WeatherIcons.night_alt_snow;
        case 77:
          return WeatherIcons.night_alt_snow;
        case 80:
        case 81:
        case 82:
          return WeatherIcons.night_alt_showers;
        case 85:
        case 86:
          return WeatherIcons.night_alt_snow;
        case 95:
          return WeatherIcons.night_alt_thunderstorm;
        case 96:
        case 99:
          return WeatherIcons.night_alt_storm_showers;
        default:
          return WeatherIcons.na;
      }
    }
  }

  static List<Color> getWeatherGradient(int code, {bool isNight = false}) {
    if (isNight) {
      return [
        const Color(0xFF0D1231), // Darker Deep Blue
        const Color(0xFF1A104E), // Darker Deep Purple
      ];
    }

    switch (code) {
      case 0: // Sunny/Clear
        return [
          const Color(0xFF1565C0), // Blue
          const Color(0xFF0D47A1), // Darker Blue
        ];
      // Maybe Orange/Yellow as requested for Sunny
      // "Sunny: Yellow/orange gradients"
      // But code 0 is Clear Sky. Let's make it more vibrant blue for sky, or sunny yellow?
      // Let's stick to Blue for Sky, but if it feels "Sunny" maybe:
      /*
        return [
          Color(0xFFFF9800),
          Color(0xFFFF5722),
        ];
        */
      case 1:
      case 2:
      case 3: // Cloudy
        return [
          const Color(0xFF546E7A),
          const Color(0xFF37474F),
        ]; // Darker Gray
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82: // Rain
        return [
          const Color(0xFF263238),
          const Color(0xFF101416),
        ]; // Darker Dark Blue/Gray
      case 71:
      case 73:
      case 75: // Snow
        return [const Color(0xFF29B6F6), const Color(0xFF0288D1)];
      case 95:
      case 96:
      case 99: // Thunderstorm
        return [const Color(0xFF1C2833), const Color(0xFF2E4053)];
      default:
        return [const Color(0xFF1565C0), const Color(0xFF0D47A1)];
    }
  }
}
