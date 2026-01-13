import 'package:feather/features/settings/domain/entities/unit_settings.dart';

class UnitConverters {
  static double convertTemperature(double tempCelsius, TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.fahrenheit:
        return (tempCelsius * 9 / 5) + 32;
      case TemperatureUnit.kelvin:
        return tempCelsius + 273.15;
      case TemperatureUnit.celsius:
        return tempCelsius;
    }
  }

  static double convertWindSpeed(double speedKmh, WindSpeedUnit unit) {
    switch (unit) {
      case WindSpeedUnit.mph:
        return speedKmh * 0.621371;
      case WindSpeedUnit.ms:
        return speedKmh / 3.6;
      case WindSpeedUnit.knots:
        return speedKmh * 0.539957;
      case WindSpeedUnit.kmh:
        return speedKmh;
    }
  }

  static double convertPressure(double pressureHpa, PressureUnit unit) {
    switch (unit) {
      case PressureUnit.inhg:
        return pressureHpa * 0.02953;
      case PressureUnit.mmhg:
        return pressureHpa * 0.750062;
      case PressureUnit.mbar:
        return pressureHpa; // 1 hPa = 1 mbar
      case PressureUnit.hpa:
        return pressureHpa;
    }
  }

  static double convertPrecipitation(double precipMm, PrecipitationUnit unit) {
    switch (unit) {
      case PrecipitationUnit.inches:
        return precipMm * 0.0393701;
      case PrecipitationUnit.mm:
        return precipMm;
    }
  }

  static double convertDistance(double distKm, DistanceUnit unit) {
    switch (unit) {
      case DistanceUnit.miles:
        return distKm * 0.621371;
      case DistanceUnit.km:
        return distKm;
    }
  }

  static String getTemperatureSymbol(TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.fahrenheit:
        return "°F";
      case TemperatureUnit.kelvin:
        return "K";
      case TemperatureUnit.celsius:
        return "°C";
    }
  }

  static String getWindSpeedSymbol(WindSpeedUnit unit) {
    switch (unit) {
      case WindSpeedUnit.mph:
        return "mph";
      case WindSpeedUnit.ms:
        return "m/s";
      case WindSpeedUnit.knots:
        return "knots";
      case WindSpeedUnit.kmh:
        return "km/h";
    }
  }

  static String getPressureSymbol(PressureUnit unit) {
    switch (unit) {
      case PressureUnit.inhg:
        return "inHg";
      case PressureUnit.mmhg:
        return "mmHg";
      case PressureUnit.mbar:
        return "mbar";
      case PressureUnit.hpa:
        return "hPa";
    }
  }

  static String getPrecipitationSymbol(PrecipitationUnit unit) {
    switch (unit) {
      case PrecipitationUnit.inches:
        return "in";
      case PrecipitationUnit.mm:
        return "mm";
    }
  }

  static String getDistanceSymbol(DistanceUnit unit) {
    switch (unit) {
      case DistanceUnit.miles:
        return "mi";
      case DistanceUnit.km:
        return "km";
    }
  }
}
