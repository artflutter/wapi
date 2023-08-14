import 'package:flutter_test/flutter_test.dart';
import 'package:wapi/src/weather_api/weather_api_exception.dart';

void main() {
  group('WeatherApiException', () {
    test('toString should return proper error message', () {
      final error = WeatherApiError(code: 404, message: 'Not Found');
      final exception = WeatherApiException(error);

      expect(
        exception.toString(),
        'Error: 404: Not Found',
      );
    });
  });

  group('WeatherApiUnknownException', () {
    test('toString should return proper error message', () {
      const error = 'Unknown Error Occurred';
      final exception = WeatherApiUnknownException(error);

      expect(
        exception.toString(),
        'Error: Unknown Error Occurred',
      );
    });
  });
}
