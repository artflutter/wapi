import 'dart:async';

import 'package:wapi/src/weather_api/models/weather_location.dart';

import 'models/weather.dart';
import 'weather_http_client.dart';

/// A class responsible for interacting with a weather API to fetch weather data.
class WeatherApiClient {
  final WeatherHttpClient _httpClient;

  /// Constructs a [WeatherApiClient] instance.
  ///
  /// The [apiKey] is required for API authentication. An optional [httpClient]
  /// can be provided for making HTTP requests. If not provided, a default
  /// [WeatherHttpClient] will be used.
  WeatherApiClient({required String apiKey, WeatherHttpClient? httpClient})
      : _httpClient = httpClient ?? WeatherHttpClient(apiKey: apiKey);

  /// Searches for weather locations matching the given [query].
  ///
  /// Returns a list of [WeatherLocation] objects based on the search [query].
  /// The search is performed asynchronously using the underlying HTTP client.
  Future<List<WeatherLocation>> search(String query) async {
    final response = await _httpClient.get(
      '/v1/search.json',
      queryParameters: {"q": query},
    );

    return (response.data as List<dynamic>)
        .map((e) => WeatherLocation.fromJson(e))
        .toList(growable: false);
  }

  /// Retrieves the weather forecast for a specific date and location.
  ///
  /// Returns a [Weather] object representing the weather forecast for the given
  /// [query], [date], and [days] in the future. The forecast data is fetched
  /// asynchronously using the underlying HTTP client.
  Future<Weather> forecast(String query, DateTime date, int days) async {
    final response =
        await _httpClient.get('/v1/forecast.json', queryParameters: {
      "q": query,
      "dt": "${date.year}-${date.month}-${date.day}",
      "days": days.toString(),
    });
    return Weather.fromJson(response.data as Map<String, dynamic>);
  }

  /// Retrieves historical weather data for a specific date and location.
  ///
  /// Returns a [Weather] object representing historical weather data for the
  /// given [query] and [date]. The historical data is fetched asynchronously
  /// using the underlying HTTP client.
  Future<Weather> history(String query, DateTime date) async {
    final response =
        await _httpClient.get('/v1/history.json', queryParameters: {
      "q": query,
      "dt": "${date.year}-${date.month}-${date.day}",
    });
    return Weather.fromJson(response.data as Map<String, dynamic>);
  }

  /// Retrieves future weather data for a specific date and location.
  ///
  /// Returns a [Weather] object representing future weather data for the given
  /// [query] and [date]. The future data is fetched asynchronously using the
  /// underlying HTTP client.
  Future<Weather> future(String query, DateTime date) async {
    final response = await _httpClient.get('/v1/future.json', queryParameters: {
      "q": query,
      "dt": "${date.year}-${date.month}-${date.day}",
    });
    return Weather.fromJson(response.data as Map<String, dynamic>);
  }

  /// Retrieves weather data for a specific date and location, considering
  /// historical, current, or future data as appropriate.
  ///
  /// Returns a [Weather] object based on the [query] and [date]. If the [date]
  /// is in the past, historical data is retrieved. If the [date] is too far in
  /// the future, future data is retrieved. Otherwise, a one-day forecast is
  /// returned. The weather data is fetched asynchronously using the underlying
  /// HTTP client.
  Future<Weather> weather(String query, DateTime date) async {
    final dateNow = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);

    if (date.isBefore(dateNow)) {
      return history(query, date);
    } else if (date.isAfter(dateNow.add(const Duration(days: 14)))) {
      return future(query, date);
    }
    return forecast(query, date, 1);
  }
}
