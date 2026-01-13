import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feather/features/settings/domain/entities/unit_settings.dart';

class SettingsProvider extends ChangeNotifier {
  TemperatureUnit _tempUnit = TemperatureUnit.celsius;
  WindSpeedUnit _windSpeedUnit = WindSpeedUnit.kmh;
  PressureUnit _pressureUnit = PressureUnit.hpa;
  PrecipitationUnit _precipitationUnit = PrecipitationUnit.mm;
  DistanceUnit _distanceUnit = DistanceUnit.km;

  TemperatureUnit get tempUnit => _tempUnit;
  WindSpeedUnit get windSpeedUnit => _windSpeedUnit;
  PressureUnit get pressureUnit => _pressureUnit;
  PrecipitationUnit get precipitationUnit => _precipitationUnit;
  DistanceUnit get distanceUnit => _distanceUnit;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _tempUnit = TemperatureUnit.values[prefs.getInt('tempUnit') ?? 0];
    _windSpeedUnit = WindSpeedUnit.values[prefs.getInt('windSpeedUnit') ?? 0];
    _pressureUnit = PressureUnit.values[prefs.getInt('pressureUnit') ?? 0];
    _precipitationUnit =
        PrecipitationUnit.values[prefs.getInt('precipitationUnit') ?? 0];
    _distanceUnit = DistanceUnit.values[prefs.getInt('distanceUnit') ?? 0];
    notifyListeners();
  }

  Future<void> setTempUnit(TemperatureUnit unit) async {
    _tempUnit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tempUnit', unit.index);
    notifyListeners();
  }

  Future<void> setWindSpeedUnit(WindSpeedUnit unit) async {
    _windSpeedUnit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('windSpeedUnit', unit.index);
    notifyListeners();
  }

  Future<void> setPressureUnit(PressureUnit unit) async {
    _pressureUnit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pressureUnit', unit.index);
    notifyListeners();
  }

  Future<void> setPrecipitationUnit(PrecipitationUnit unit) async {
    _precipitationUnit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('precipitationUnit', unit.index);
    notifyListeners();
  }

  Future<void> setDistanceUnit(DistanceUnit unit) async {
    _distanceUnit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('distanceUnit', unit.index);
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    _tempUnit = TemperatureUnit.celsius;
    _windSpeedUnit = WindSpeedUnit.kmh;
    _pressureUnit = PressureUnit.hpa;
    _precipitationUnit = PrecipitationUnit.mm;
    _distanceUnit = DistanceUnit.km;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tempUnit');
    await prefs.remove('windSpeedUnit');
    await prefs.remove('pressureUnit');
    await prefs.remove('precipitationUnit');
    await prefs.remove('distanceUnit');

    notifyListeners();
  }
}
