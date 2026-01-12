import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String admin1;

  const City({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country = '',
    this.admin1 = '',
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String? ?? '',
      admin1: json['admin1'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
    };
  }

  String get displayName {
    if (admin1.isNotEmpty && country.isNotEmpty) {
      return '$name, $admin1, $country';
    } else if (country.isNotEmpty) {
      return '$name, $country';
    }
    return name;
  }

  @override
  List<Object?> get props => [name, latitude, longitude, country, admin1];
}
