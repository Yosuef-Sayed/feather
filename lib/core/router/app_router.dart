import 'package:go_router/go_router.dart';
import 'package:feather/features/weather/presentation/views/weather_screen.dart';
import 'package:feather/features/weather/presentation/views/cities_list_screen.dart';
import 'package:feather/features/weather/presentation/views/search_screen.dart';
import 'package:feather/features/weather/data/models/city.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WeatherScreen()),
    GoRoute(
      path: '/cities',
      builder: (context, state) => const CitiesListScreen(),
    ),
    GoRoute(
      path: '/weather',
      builder: (context, state) {
        final city = state.extra as City?;
        return WeatherScreen(city: city);
      },
    ),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
  ],
);
