// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:feather/features/weather/presentation/providers/weather_provider.dart';
import 'package:feather/features/weather/presentation/widgets/current_weather_header.dart';
import 'package:feather/features/weather/presentation/widgets/hourly_forecast_list.dart';
import 'package:feather/features/weather/presentation/widgets/daily_forecast_list.dart';
import 'package:feather/features/weather/presentation/widgets/weather_details_grid.dart';
import 'package:feather/features/weather/data/models/city.dart';
import 'package:feather/core/utils/weather_utils.dart';
import 'package:feather/core/utils/timezone_utils.dart';
import 'package:shimmer/shimmer.dart';

class WeatherScreen extends StatefulWidget {
  final City? city;
  const WeatherScreen({super.key, this.city});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.city != null) {
        context.read<WeatherProvider>().loadWeather(
          widget.city!.latitude,
          widget.city!.longitude,
          widget.city!.displayName,
        );
      } else {
        context.read<WeatherProvider>().loadCurrentLocationWeather();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        // Determine background gradient
        List<Color> gradientColors = [Colors.blue, Colors.lightBlue]; // Default
        if (provider.weather != null &&
            provider.weather!.hourly?.weatherCode != null) {
          // Use location-specific time for gradient and day/night determination
          final code = provider.weather!.hourly!.weatherCode!.isNotEmpty
              ? provider.weather!.hourly!.weatherCode![0] as int
              : 0;

          bool isNight = !TimeZoneUtils.isLocationDaytime(provider.weather!);
          gradientColors = WeatherUtils.getWeatherGradient(
            code,
            isNight: isNight,
          );
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                child: Container(color: Colors.white.withOpacity(0)),
              ),
            ),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leadingWidth: MediaQuery.sizeOf(context).width,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Text(
                    widget.city?.name ?? provider.currentLocationName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.only(right: 10),
            actions: [
              // List button to navigate to CitiesListScreen
              IconButton(
                icon: const Icon(
                  Icons.format_list_bulleted_add,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.push('/cities');
                },
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.settings, color: Colors.white),
                onPressed: () {
                  context.push('/settings');
                },
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            child: RefreshIndicator(
              edgeOffset: MediaQuery.of(context).padding.top + kToolbarHeight,
              onRefresh: () async {
                if (widget.city != null) {
                  await provider.loadWeather(
                    widget.city!.latitude,
                    widget.city!.longitude,
                    widget.city!.displayName,
                  );
                } else {
                  await provider.loadCurrentLocationWeather();
                }
              },
              child: _buildBody(provider),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(WeatherProvider provider) {
    if (provider.isLoading) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: Colors.white30,
          highlightColor: Colors.white54,
          child: const Text(
            "Loading Weather...",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 60),
            const SizedBox(height: 20),
            Text(
              "Error: ${provider.error}",
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.city != null) {
                  provider.loadWeather(
                    widget.city!.latitude,
                    widget.city!.longitude,
                    widget.city!.displayName,
                  );
                } else {
                  provider.loadCurrentLocationWeather();
                }
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (provider.weather == null) {
      return const Center(
        child: Text("No Data", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        CurrentWeatherHeader(weather: provider.weather!),
        const SizedBox(height: 30),
        HourlyForecastList(weather: provider.weather!),
        const SizedBox(height: 20),
        DailyForecastList(weather: provider.weather!),
        WeatherDetailsGrid(weather: provider.weather!),
        const SizedBox(height: 40),
        const Center(
          child: Text(
            "Data provided by Open-Meteo",
            style: TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
