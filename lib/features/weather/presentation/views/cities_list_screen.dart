import 'package:feather/features/weather/presentation/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CitiesListScreen extends StatefulWidget {
  const CitiesListScreen({super.key});

  @override
  State<CitiesListScreen> createState() => _CitiesListScreenState();
}

class _CitiesListScreenState extends State<CitiesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadSavedCities();
      // Also ensure we have current location name available?
      // Maybe not strictly necessary if we just label it "Current Location"
      // but nice to have.
      context.read<WeatherProvider>().loadCurrentLocationWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark theme matching app
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Locations",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/search');
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          final savedCities = provider.savedCities;

          return ListView.builder(
            itemCount: savedCities.length + 1, // +1 for Current Location
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildCityTile(
                  context,
                  title: "Current Location",
                  subtitle: provider.currentLocationName,
                  isCurrentLocation: true,
                  onTap: () => context.push(
                    '/weather',
                  ), // No extra = null = current location
                );
              }

              final city = savedCities[index - 1];
              return _buildCityTile(
                context,
                title: city.name,
                subtitle: city.displayName,
                onTap: () => context.push('/weather', extra: city),
                onDelete: () {
                  provider.removeCity(city);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCityTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    VoidCallback? onDelete,
    bool isCurrentLocation = false,
  }) {
    return Dismissible(
      key: ValueKey(title + subtitle),
      direction: onDelete != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          isCurrentLocation ? Icons.my_location : Icons.location_on_outlined,
          color: Colors.white70,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white30,
          size: 16,
        ),
      ),
    );
  }
}
