import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:feather/core/constants/api_constants.dart';
import 'package:feather/features/weather/data/models/weather.dart';

import 'package:shared_preferences/shared_preferences.dart';

class WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSource({http.Client? client})
    : client = client ?? http.Client();

  Future<Weather> getWeather(double lat, double lon) async {
    final Uri uri = Uri.parse(ApiConstants.forecastEndpoint).replace(
      queryParameters: {
        'latitude': lat.toString(),
        'longitude': lon.toString(),
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,uv_index_max,sunrise,sunset',
        'hourly':
            'weather_code,temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,pressure_msl,visibility',
        'timezone': 'auto',
        'forecast_days': '16',
      },
    );

    try {
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _cacheWeatherData(data); // Cache successful response
        return Weather.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Try to load from cache if network fails
      final cachedWeather = await _getCachedWeatherData();
      if (cachedWeather != null) {
        return cachedWeather;
      }
      throw Exception(
        'Failed to connect to weather service and no cache available: $e',
      );
    }
  }

  Future<void> _cacheWeatherData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_weather', json.encode(data));
    } catch (_) {}
  }

  Future<Weather?> _getCachedWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString('cached_weather');
      if (jsonStr != null) {
        return Weather.fromJson(json.decode(jsonStr));
      }
    } catch (_) {}
    return null;
  }

  Future<List<Map<String, dynamic>>> searchCity(String query) async {
    final Uri uri = Uri.parse('https://geocoding-api.open-meteo.com/v1/search')
        .replace(
          queryParameters: {
            'name': query,
            'count': '5',
            'language': 'en',
            'format': 'json',
          },
        );

    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null) {
          return List<Map<String, dynamic>>.from(data['results']);
        }
        return [];
      } else {
        throw Exception('Failed to search city');
      }
    } catch (e) {
      return [];
    }
  }
}
