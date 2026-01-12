import 'package:equatable/equatable.dart';

class HourlyUnits extends Equatable {
  final String? time;
  final String? weatherCode;
  final String? temperature2m;
  final String? apparentTemperature;
  final String? relativeHumidity2m;
  final String? windSpeed10m;
  final String? pressureMsl;
  final String? visibility;

  const HourlyUnits({
    this.time,
    this.weatherCode,
    this.temperature2m,
    this.apparentTemperature,
    this.relativeHumidity2m,
    this.windSpeed10m,
    this.pressureMsl,
    this.visibility,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
    time: json['time'] as String?,
    weatherCode: json['weather_code'] as String?,
    temperature2m: json['temperature_2m'] as String?,
    apparentTemperature: json['apparent_temperature'] as String?,
    relativeHumidity2m: json['relative_humidity_2m'] as String?,
    windSpeed10m: json['wind_speed_10m'] as String?,
    pressureMsl: json['pressure_msl'] as String?,
    visibility: json['visibility'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'time': time,
    'weather_code': weatherCode,
    'temperature_2m': temperature2m,
    'apparent_temperature': apparentTemperature,
    'relative_humidity_2m': relativeHumidity2m,
    'wind_speed_10m': windSpeed10m,
    'pressure_msl': pressureMsl,
    'visibility': visibility,
  };

  @override
  List<Object?> get props {
    return [
      time,
      weatherCode,
      temperature2m,
      apparentTemperature,
      relativeHumidity2m,
      windSpeed10m,
      pressureMsl,
      visibility,
    ];
  }
}
