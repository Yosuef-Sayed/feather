import 'package:equatable/equatable.dart';

class DailyUnits extends Equatable {
  final String? time;
  final String? weatherCode;
  final String? temperature2mMax;
  final String? temperature2mMin;
  final String? uvIndexMax;

  const DailyUnits({
    this.time,
    this.weatherCode,
    this.temperature2mMax,
    this.temperature2mMin,
    this.uvIndexMax,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
    time: json['time'] as String?,
    weatherCode: json['weather_code'] as String?,
    temperature2mMax: json['temperature_2m_max'] as String?,
    temperature2mMin: json['temperature_2m_min'] as String?,
    uvIndexMax: json['uv_index_max'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'time': time,
    'weather_code': weatherCode,
    'temperature_2m_max': temperature2mMax,
    'temperature_2m_min': temperature2mMin,
    'uv_index_max': uvIndexMax,
  };

  @override
  List<Object?> get props {
    return [time, weatherCode, temperature2mMax, temperature2mMin, uvIndexMax];
  }
}
