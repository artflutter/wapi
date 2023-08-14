import 'package:flutter/material.dart';
import 'package:wapi/src/weather_api/models/weather.dart';
import 'package:wapi/src/widget/weather/temperature_units.dart';
import 'package:wapi/src/widget/weather/weather_no_data_tile.dart';

/// A widget that displays weather data in a tile format.
class WeatherDataTile extends StatelessWidget {
  /// The weather data to be displayed in the tile.
  final Weather weather;

  /// The temperature units to be used for displaying the temperature.
  final TemperatureUnits unit;

  /// Creates a [WeatherDataTile] widget.
  ///
  /// The [weather] argument contains the weather data to be displayed.
  /// The [unit] argument determines the temperature units to be used for displaying the temperature.
  const WeatherDataTile({Key? key, required this.weather, required this.unit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forecast = weather.forecast.forecastDay.firstOrNull;

    if (forecast == null) {
      return const WeatherNoDataTile();
    }

    final temperature = unit == TemperatureUnits.celsius
        ? forecast.day.avgTempC
        : forecast.day.avgTempF;

    return ListTile(
      leading: SizedBox.square(
        dimension: 64,
        child: Image.network(
          'https:${weather.forecast.forecastDay.first.day.condition.icon}',
        ),
      ),
      title: Text('Temp: $temperature ${unit.toString()}'),
    );
  }
}
