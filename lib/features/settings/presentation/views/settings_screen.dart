import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feather/features/settings/presentation/providers/settings_provider.dart';
import 'package:feather/features/settings/domain/entities/unit_settings.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Darker theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader("Resets"),
              ListTile(
                title: Text(
                  "Reset to Default",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                trailing: const Icon(Icons.restore, color: Colors.white),
                onTap: () {
                  settings.resetToDefaults();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      width: 250,
                      content: Center(child: Text("Settings reset to default")),
                    ),
                  );
                },
              ),
              const Divider(color: Colors.white24),
              _buildSectionHeader("Units"),
              _buildDropdownTile<TemperatureUnit>(
                title: "Temperature",
                value: settings.tempUnit,
                items: TemperatureUnit.values,
                onChanged: (val) => settings.setTempUnit(val!),
                getName: (val) => val.name.toUpperCase(),
              ),
              _buildDropdownTile<WindSpeedUnit>(
                title: "Wind Speed",
                value: settings.windSpeedUnit,
                items: WindSpeedUnit.values,
                onChanged: (val) => settings.setWindSpeedUnit(val!),
                getName: (val) => val.name.toUpperCase(),
              ),
              _buildDropdownTile<PressureUnit>(
                title: "Pressure",
                value: settings.pressureUnit,
                items: PressureUnit.values,
                onChanged: (val) => settings.setPressureUnit(val!),
                getName: (val) => val.name.toUpperCase(),
              ),
              _buildDropdownTile<PrecipitationUnit>(
                title: "Precipitation",
                value: settings.precipitationUnit,
                items: PrecipitationUnit.values,
                onChanged: (val) => settings.setPrecipitationUnit(val!),
                getName: (val) => val.name.toUpperCase(),
              ),
              _buildDropdownTile<DistanceUnit>(
                title: "Distance",
                value: settings.distanceUnit,
                items: DistanceUnit.values,
                onChanged: (val) => settings.setDistanceUnit(val!),
                getName: (val) => val.name.toUpperCase(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.blue,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDropdownTile<T>({
    required String title,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) getName,
  }) {
    return ListTile(
      title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
      trailing: DropdownButton<T>(
        value: value,
        dropdownColor: Colors.grey[900],
        style: GoogleFonts.poppins(color: Colors.white),
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: items.map((item) {
          return DropdownMenuItem<T>(value: item, child: Text(getName(item)));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
