import 'package:flutter/material.dart';
import 'package:wapi/src/weather_api/models/weather.dart';
import 'package:wapi/src/weather_api/weather_api_client.dart';
import 'package:wapi/src/widget/weather/temperature_units.dart';
import 'package:wapi/src/widget/weather/weather_data_tile.dart';
import 'package:wapi/src/widget/weather/weather_error_tile.dart';
import 'package:wapi/src/widget/weather/weather_no_data_tile.dart';

// Signature for a function that builds a widget when there is no weather data available.
typedef NoDataBuilder = Widget Function(BuildContext context);

// Signature for a function that builds a widget when there is an error fetching weather data.
typedef ErrorDataBuilder = Widget Function(BuildContext context, Object? error);

// Signature for a function that builds a widget using weather data and units.
typedef WeatherDataBuilder = Widget Function(
  BuildContext context,
  Weather weather,
  TemperatureUnits units,
  VoidCallback onRefresh,
);

/// A widget that displays weather information based on the provided API client, query, and date.
class WeatherTile extends StatefulWidget {
  /// The API client used to fetch weather data.
  final WeatherApiClient apiClient;

  /// The query string used to fetch weather data.
  final String query;

  /// The date for which weather data is requested.
  final DateTime date;

  /// A function that builds a widget when there is no weather data available.
  final NoDataBuilder? noDataBuilder;

  /// A function that builds a widget when there is an error fetching weather data.
  final ErrorDataBuilder? errorDataBuilder;

  /// A function that builds a widget using weather data and units.
  final WeatherDataBuilder? dataBuilder;

  /// The temperature unit to display the weather data in.
  final TemperatureUnits unit;

  /// Creates a [WeatherTile] widget.
  WeatherTile({
    Key? key,
    required this.apiClient,
    required this.query,
    DateTime? date,
    TemperatureUnits? unit,
    this.noDataBuilder,
    this.errorDataBuilder,
    this.dataBuilder,
  })  : unit = unit ?? TemperatureUnits.celsius,
        date = date ?? DateTime.now(),
        super(key: key);

  /// Creates a [WeatherTile] using latitude and longitude coordinates.
  factory WeatherTile.lanLng({
    required double lat,
    required double lng,
    required WeatherApiClient apiClient,
    TemperatureUnits? unit,
    DateTime? date,
    NoDataBuilder? noDataBuilder,
    ErrorDataBuilder? errorDataBuilder,
    WeatherDataBuilder? dataBuilder,
  }) {
    return WeatherTile(
      apiClient: apiClient,
      query: '$lat, $lng',
      unit: unit,
      date: date,
      noDataBuilder: noDataBuilder,
      errorDataBuilder: errorDataBuilder,
      dataBuilder: dataBuilder,
    );
  }

  @override
  State<WeatherTile> createState() => _WeatherTileState();
}

class _WeatherTileState extends State<WeatherTile> {
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    _weatherFuture = widget.apiClient.weather(widget.query, widget.date);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WeatherTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    final isSameDate = widget.date.compareTo(oldWidget.date) == 0;
    final isSameQuery = widget.query == oldWidget.query;

    if (!isSameQuery || !isSameDate) {
      _weatherFuture = fetchWeather(query: widget.query, date: widget.date);
    }
  }

  /// Fetches weather data using the provided query and date.
  Future<Weather> fetchWeather({
    required String query,
    required DateTime date,
  }) =>
      widget.apiClient.weather(query, date);

  handleRefresh() {
    setState(() {
      _weatherFuture = fetchWeather(query: widget.query, date: widget.date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        final data = snapshot.data;
        Widget tile =
            widget.noDataBuilder?.call(context) ?? const WeatherNoDataTile();

        if (data != null) {
          tile = widget.dataBuilder?.call(
                context,
                data,
                widget.unit,
                handleRefresh,
              ) ??
              Row(
                children: [
                  Expanded(
                      child: WeatherDataTile(weather: data, unit: widget.unit)),
                  IconButton(
                    onPressed: handleRefresh,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              );
        }

        if (snapshot.hasError) {
          tile = widget.errorDataBuilder?.call(context, snapshot.error) ??
              WeatherErrorTile(error: snapshot.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(
            children: [
              Opacity(opacity: 0.4, child: tile),
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        }

        return tile;
      },
    );
  }
}
