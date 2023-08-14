import 'package:dio/dio.dart';
import 'package:wapi/src/weather_api/weather_api_exception.dart';

/// A client for making HTTP requests to the Weather API.
class WeatherHttpClient {
  final String _apiKey;
  final Dio _httpClient;

  /// The base URL for the Weather API.
  static const host = 'https://api.weatherapi.com';

  /// Creates an instance of [WeatherHttpClient].
  ///
  /// The [apiKey] parameter is required and should be your Weather API key.
  /// The [httpClient] parameter allows you to provide a custom [Dio] instance.
  /// The [host] parameter can be used to specify a custom API host.
  /// The [interceptors] parameter is used to add custom interceptors to the [Dio] instance.
  WeatherHttpClient({
    required String apiKey,
    Dio? httpClient,
    String? host,
    Iterable<Interceptor> interceptors = const [],
  })  : _apiKey = apiKey,
        _httpClient = httpClient ??
            Dio(BaseOptions(baseUrl: host ?? WeatherHttpClient.host)) {
    _httpClient
      ..options.queryParameters = {
        'key': _apiKey,
        ..._httpClient.options.queryParameters,
      }
      ..interceptors.addAll(interceptors);
  }

  /// Performs a GET request to the specified [uri].
  ///
  /// Returns a [Response] containing the response data.
  /// If the response status code is not 200, a [WeatherApiException] is thrown
  /// with the parsed error information.
  /// If an error occurs during the request, a [WeatherApiUnknownException] is thrown.
  Future<Response<dynamic>> get(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _httpClient.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw WeatherApiException(
          WeatherApiError.fromJson(
              (response.data as Map<String, dynamic>)['error']),
        );
      }

      return response;
    } on WeatherApiException {
      rethrow;
    } catch (e) {
      throw WeatherApiUnknownException(e);
    }
  }
}
