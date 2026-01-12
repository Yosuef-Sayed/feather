import 'package:equatable/equatable.dart';

class Hourly extends Equatable {
  final List<String>? time;
  final List<dynamic>? weatherCode;
  final List<dynamic>? temperature2m;
  final List<dynamic>? apparentTemperature;
  final List<dynamic>? relativeHumidity2m;
  final List<dynamic>? windSpeed10m;
  final List<dynamic>? pressureMsl;
  final List<dynamic>? visibility;

  const Hourly({
    this.time,
    this.weatherCode,
    this.temperature2m,
    this.apparentTemperature,
    this.relativeHumidity2m,
    this.windSpeed10m,
    this.pressureMsl,
    this.visibility,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
    time: (json['time'] as List<dynamic>?)?.map((e) => e as String).toList(),
    weatherCode: json['weather_code'] as List<dynamic>?,
    temperature2m: json['temperature_2m'] as List<dynamic>?,
    apparentTemperature: json['apparent_temperature'] as List<dynamic>?,
    relativeHumidity2m: json['relative_humidity_2m'] as List<dynamic>?,
    windSpeed10m: json['wind_speed_10m'] as List<dynamic>?,
    pressureMsl: json['pressure_msl'] as List<dynamic>?,
    visibility: json['visibility'] as List<dynamic>?,
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
