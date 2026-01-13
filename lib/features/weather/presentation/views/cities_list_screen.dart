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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadSavedCities();
      context.read<WeatherProvider>().loadCurrentLocationWeather();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Darker theme
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
          final filteredCities = savedCities.where((city) {
            final query = _searchQuery.toLowerCase();
            return city.name.toLowerCase().contains(query) ||
                city.displayName.toLowerCase().contains(query);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search cities...",
                    hintStyle: GoogleFonts.poppins(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white38),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white38,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredCities.isEmpty && _searchQuery.isNotEmpty
                    ? Center(
                        child: Text(
                          "No cities found",
                          style: GoogleFonts.poppins(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchQuery.isEmpty
                            ? filteredCities.length + 1
                            : filteredCities.length,
                        itemBuilder: (context, index) {
                          if (_searchQuery.isEmpty && index == 0) {
                            return _buildCityTile(
                              context,
                              title: "Current Location",
                              subtitle: provider.currentLocationName,
                              isCurrentLocation: true,
                              onTap: () => context.push('/weather'),
                            );
                          }

                          final city =
                              filteredCities[_searchQuery.isEmpty
                                  ? index - 1
                                  : index];
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
                      ),
              ),
            ],
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
