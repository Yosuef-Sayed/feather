import 'package:flutter/material.dart';
import 'package:feather/core/services/location_service.dart';
import 'package:feather/features/weather/data/models/weather.dart';
import 'package:feather/features/weather/data/models/city.dart';
import 'package:feather/features/weather/data/datasources/remote/weather_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WeatherProvider extends ChangeNotifier {
  final WeatherRemoteDataSource _weatherRemoteDataSource;
  final LocationService _locationService;

  Weather? _weather;
  bool _isLoading = false;
  String? _error;
  String _currentLocationName = "Locating...";

  // Cache check can be enhanced, but for now simple in-memory

  WeatherProvider({
    required WeatherRemoteDataSource weatherRemoteDataSource,
    required LocationService locationService,
  }) : _weatherRemoteDataSource = weatherRemoteDataSource,
       _locationService = locationService;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentLocationName => _currentLocationName;

  Future<void> loadCurrentLocationWeather() async {
    _setLoading(true);
    try {
      final position = await _locationService.getCurrentPosition();
      _currentLocationName = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      _weather = await _weatherRemoteDataSource.getWeather(
        position.latitude,
        position.longitude,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadWeather(double lat, double lon, String name) async {
    _setLoading(true);
    _currentLocationName = name;
    try {
      _weather = await _weatherRemoteDataSource.getWeather(lat, lon);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Map<String, dynamic>>> searchSuggestions(String query) async {
    return await _weatherRemoteDataSource.searchCity(query);
  }

  Future<void> searchWeather(String query) async {
    _setLoading(true);
    try {
      final location = await _locationService.getCoordinatesFromAddress(query);
      if (location != null) {
        // Fetch nicely formatted name
        final name = await _locationService.getAddressFromCoordinates(
          location.latitude,
          location.longitude,
        );
        _currentLocationName = name.isEmpty ? query : name;

        _weather = await _weatherRemoteDataSource.getWeather(
          location.latitude,
          location.longitude,
        );
        _error = null;
      } else {
        _error = "Location not found";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  List<City> _savedCities = [];

  List<City> get savedCities => _savedCities;

  Future<void> loadSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    final String? citiesJson = prefs.getString('saved_cities');
    if (citiesJson != null) {
      final List<dynamic> decoded = jsonDecode(citiesJson);
      _savedCities = decoded.map((e) => City.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> addCity(City city) async {
    if (!_savedCities.any(
      (c) => c.name == city.name && c.country == city.country,
    )) {
      _savedCities.add(city);
      await _saveCitiesToPrefs();
      notifyListeners();
    }
  }

  Future<void> removeCity(City city) async {
    _savedCities.removeWhere(
      (c) => c.name == city.name && c.country == city.country,
    );
    await _saveCitiesToPrefs();
    notifyListeners();
  }

  Future<void> _saveCitiesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _savedCities.map((c) => c.toJson()).toList(),
    );
    await prefs.setString('saved_cities', encoded);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
