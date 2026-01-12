import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feather/features/weather/presentation/providers/weather_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CitySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.black54),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black54),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSuggestions(context);
  }

  Widget _buildSuggestions(BuildContext context) {
    if (query.length < 3) {
      return Center(
        child: Text(
          "Type at least 3 characters",
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      );
    }

    // Call API directly for suggestions
    final provider = context.read<WeatherProvider>();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: provider.searchSuggestions(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error searching"));
        }
        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return const Center(child: Text("No results found"));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            final name = item['name'];
            final country = item['country'] ?? '';
            final admin1 = item['admin1'] ?? '';
            final subtitle = [
              admin1,
              country,
            ].where((s) => s.isNotEmpty).join(', ');

            return ListTile(
              title: Text(name, style: GoogleFonts.poppins()),
              subtitle: Text(
                subtitle,
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              onTap: () {
                final lat = item['latitude'] as double;
                final lon = item['longitude'] as double;
                provider.loadWeather(lat, lon, name);
                close(context, null);
              },
            );
          },
        );
      },
    );
  }
}
