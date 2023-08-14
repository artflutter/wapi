import 'package:json_annotation/json_annotation.dart';

part 'weather_api_exception.g.dart';

class WeatherHttpClientException implements Exception {}

class WeatherApiException implements WeatherHttpClientException {
  final WeatherApiError error;

  WeatherApiException(this.error);

  @override
  String toString() {
    return "Error: ${error.code}: ${error.message}";
  }
}

class WeatherApiUnknownException implements WeatherHttpClientException {
  final Object error;

  WeatherApiUnknownException(this.error);

  @override
  String toString() {
    return "Error: $error";
  }
}

@JsonSerializable()
class WeatherApiError {
  final int code;
  final String message;

  WeatherApiError({
    required this.code,
    required this.message,
  });

  factory WeatherApiError.fromJson(Map<String, dynamic> json) =>
      _$WeatherApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherApiErrorToJson(this);
}
