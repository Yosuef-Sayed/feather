// ignore_for_file: deprecated_member_use

import 'package:feather/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:feather/features/weather/presentation/providers/weather_provider.dart';
import 'package:feather/features/weather/services/weather_service.dart';
import 'package:feather/core/services/location_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            weatherService: WeatherService(),
            locationService: LocationService(),
          ),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Colors.white.withOpacity(0.3),
            selectionHandleColor: Colors.white,
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Feather',
        routerConfig: appRouter,
      ),
    );
  }
}
