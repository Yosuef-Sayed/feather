import 'dart:async';
import 'package:feather/features/weather/data/models/city.dart';
import 'package:feather/features/weather/presentation/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.length < 3) {
        setState(() {
          _results = [];
          _isLoading = false;
        });
        return;
      }

      setState(() => _isLoading = true);
      try {
        final results = await context.read<WeatherProvider>().searchSuggestions(
          query,
        );
        if (mounted) {
          setState(() {
            _results = results;
          });
        }
      } catch (e) {
        // Handle error silently or show snackbar
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    });
  }

  void _addCity(Map<String, dynamic> item) {
    final city = City(
      name: item['name'],
      latitude: (item['latitude'] as num).toDouble(),
      longitude: (item['longitude'] as num).toDouble(),
      country: item['country'] ?? '',
      admin1: item['admin1'] ?? '',
    );
    context.read<WeatherProvider>().addCity(city);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Darker background
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search city...",
            hintStyle: GoogleFonts.poppins(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : _results.isEmpty
          ? Center(
              child: Text(
                _controller.text.length < 3
                    ? "Type at least 3 characters"
                    : "No results found",
                style: GoogleFonts.poppins(color: Colors.white38),
              ),
            )
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];
                final name = item['name'];
                final country = item['country'] ?? '';
                final admin1 = item['admin1'] ?? '';
                final subtitle = [
                  admin1,
                  country,
                ].where((s) => s.isNotEmpty).join(', ');

                return ListTile(
                  title: Text(
                    name,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  subtitle: Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => _addCity(item),
                );
              },
            ),
    );
  }
}
