import 'package:flutter/material.dart';
import 'package:feather/features/weather/data/models/weather.dart';
import 'package:feather/core/theme/glass_container.dart';
import 'package:feather/core/utils/weather_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:feather/features/settings/presentation/providers/settings_provider.dart';
import 'package:feather/core/utils/unit_converters.dart';

class DailyForecastList extends StatefulWidget {
  final Weather weather;

  const DailyForecastList({super.key, required this.weather});

  @override
  State<DailyForecastList> createState() => _DailyForecastListState();
}

class _DailyForecastListState extends State<DailyForecastList> {
  bool _showAllDays = false;

  @override
  Widget build(BuildContext context) {
    final dailyParams = widget.weather.daily;
    if (dailyParams?.time == null) return const SizedBox();

    final settings = context.watch<SettingsProvider>();
    final tempSymbol = UnitConverters.getTemperatureSymbol(settings.tempUnit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            _showAllDays ? "16-Day Forecast" : "7-Day Forecast",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _showAllDays
                      ? dailyParams!.time!.length
                      : (dailyParams!.time!.length > 7
                            ? 7
                            : dailyParams.time!.length),
                  itemBuilder: (context, index) {
                    final date = DateTime.parse(dailyParams.time![index]);
                    final code =
                        (dailyParams.weatherCode![index] as num?)?.toInt() ?? 0;
                    final rawMax =
                        (dailyParams.temperature2mMax![index] as num?)
                            ?.toDouble() ??
                        0.0;
                    final rawMin =
                        (dailyParams.temperature2mMin![index] as num?)
                            ?.toDouble() ??
                        0.0;

                    final max = UnitConverters.convertTemperature(
                      rawMax,
                      settings.tempUnit,
                    );
                    final min = UnitConverters.convertTemperature(
                      rawMin,
                      settings.tempUnit,
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              index == 0
                                  ? "Today"
                                  : index == 1
                                  ? "Tomorrow"
                                  : DateFormat('EEEE').format(date),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            WeatherUtils.getWeatherIcon(code, isDay: true),
                            color: Colors.white,
                            size: 20,
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${min.round()}$tempSymbol',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                  child: Center(
                                    child: Text(
                                      '/',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${max.round()}$tempSymbol',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (dailyParams.time!.length > 7) ...[
                  const Divider(color: Colors.white24),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showAllDays = !_showAllDays;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _showAllDays ? "Show Less" : "Show 16-Day Forecast",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _showAllDays
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
