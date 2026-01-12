import 'package:equatable/equatable.dart';

class Daily extends Equatable {
  final List<String>? time;
  final List<dynamic>? weatherCode;
  final List<dynamic>? temperature2mMax;
  final List<dynamic>? temperature2mMin;
  final List<dynamic>? uvIndexMax;
  final List<String>? sunrise;
  final List<String>? sunset;

  const Daily({
    this.time,
    this.weatherCode,
    this.temperature2mMax,
    this.temperature2mMin,
    this.uvIndexMax,
    this.sunrise,
    this.sunset,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
    time: (json['time'] as List<dynamic>?)?.map((e) => e as String).toList(),
    weatherCode: json['weather_code'] as List<dynamic>?,
    temperature2mMax: json['temperature_2m_max'] as List<dynamic>?,
    temperature2mMin: json['temperature_2m_min'] as List<dynamic>?,
    uvIndexMax: json['uv_index_max'] as List<dynamic>?,
    sunrise: (json['sunrise'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    sunset: (json['sunset'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'time': time,
    'weather_code': weatherCode,
    'temperature_2m_max': temperature2mMax,
    'temperature_2m_min': temperature2mMin,
    'uv_index_max': uvIndexMax,
    'sunrise': sunrise,
    'sunset': sunset,
  };

  @override
  List<Object?> get props {
    return [
      time,
      weatherCode,
      temperature2mMax,
      temperature2mMin,
      uvIndexMax,
      sunrise,
      sunset,
    ];
  }
}
