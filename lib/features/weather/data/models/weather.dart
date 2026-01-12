import 'package:equatable/equatable.dart';

import 'daily.dart';
import 'daily_units.dart';
import 'hourly.dart';
import 'hourly_units.dart';

class Weather extends Equatable {
  final double? latitude;
  final double? longitude;
  final double? generationtimeMs;
  final int? utcOffsetSeconds;
  final String? timezone;
  final String? timezoneAbbreviation;
  final int? elevation;
  final HourlyUnits? hourlyUnits;
  final Hourly? hourly;
  final DailyUnits? dailyUnits;
  final Daily? daily;

  const Weather({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.hourlyUnits,
    this.hourly,
    this.dailyUnits,
    this.daily,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    generationtimeMs: (json['generationtime_ms'] as num?)?.toDouble(),
    utcOffsetSeconds: (json['utc_offset_seconds'] as num?)?.toInt(),
    timezone: json['timezone'] as String?,
    timezoneAbbreviation: json['timezone_abbreviation'] as String?,
    elevation: (json['elevation'] as num?)?.toInt(),
    hourlyUnits: json['hourly_units'] == null
        ? null
        : HourlyUnits.fromJson(json['hourly_units'] as Map<String, dynamic>),
    hourly: json['hourly'] == null
        ? null
        : Hourly.fromJson(json['hourly'] as Map<String, dynamic>),
    dailyUnits: json['daily_units'] == null
        ? null
        : DailyUnits.fromJson(json['daily_units'] as Map<String, dynamic>),
    daily: json['daily'] == null
        ? null
        : Daily.fromJson(json['daily'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'generationtime_ms': generationtimeMs,
    'utc_offset_seconds': utcOffsetSeconds,
    'timezone': timezone,
    'timezone_abbreviation': timezoneAbbreviation,
    'elevation': elevation,
    'hourly_units': hourlyUnits?.toJson(),
    'hourly': hourly?.toJson(),
    'daily_units': dailyUnits?.toJson(),
    'daily': daily?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      latitude,
      longitude,
      generationtimeMs,
      utcOffsetSeconds,
      timezone,
      timezoneAbbreviation,
      elevation,
      hourlyUnits,
      hourly,
      dailyUnits,
      daily,
    ];
  }
}
